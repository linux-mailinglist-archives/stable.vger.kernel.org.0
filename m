Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB9C22F09D
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgG0O0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732559AbgG0O0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:26:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51BB320663;
        Mon, 27 Jul 2020 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859967;
        bh=1pOd5ni6jB5ltyfiKPaIv6AydXaYcI8IVegnKk2vKME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPDr7zjhY+pmRcN+PKqdYfI5Yg7vEVItaP8VRsOPndqtZhnIV0FEX09BpvjeAfX/N
         oWJZX+Gyba2RNwL4CDwu8slkQQC26+y+M3j2PtoKoAu8XMTDQJa13C6NvalHGSQK4T
         Z4F5ppBa1PXDxK9h6QQp5T/0H6MzXq0kVerXoi1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.7 174/179] ASoC: topology: fix kernel oops on route addition error
Date:   Mon, 27 Jul 2020 16:05:49 +0200
Message-Id: <20200727134941.132796251@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 6f0307df83f2aa6bdf656c2219c89ce96502d20e upstream.

When errors happens while loading graph components, the kernel oopses
while trying to remove all topology components. This can be
root-caused to a list pointing to memory that was already freed on
error.

remove_route() is already called on errors and will perform the
required cleanups so there's no need to free the route memory in
soc_tplg_dapm_graph_elems_load() if the route was added to the
list. We do however want to free the routes allocated but not added to
the list.

Fixes: 7df04ea7a31ea ('ASoC: topology: modify dapm route loading routine and add dapm route unloading')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200707203749.113883-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-topology.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1285,17 +1285,29 @@ static int soc_tplg_dapm_graph_elems_loa
 		list_add(&routes[i]->dobj.list, &tplg->comp->dobj_list);
 
 		ret = soc_tplg_add_route(tplg, routes[i]);
-		if (ret < 0)
+		if (ret < 0) {
+			/*
+			 * this route was added to the list, it will
+			 * be freed in remove_route() so increment the
+			 * counter to skip it in the error handling
+			 * below.
+			 */
+			i++;
 			break;
+		}
 
 		/* add route, but keep going if some fail */
 		snd_soc_dapm_add_routes(dapm, routes[i], 1);
 	}
 
-	/* free memory allocated for all dapm routes in case of error */
-	if (ret < 0)
-		for (i = 0; i < count ; i++)
-			kfree(routes[i]);
+	/*
+	 * free memory allocated for all dapm routes not added to the
+	 * list in case of error
+	 */
+	if (ret < 0) {
+		while (i < count)
+			kfree(routes[i++]);
+	}
 
 	/*
 	 * free pointer to array of dapm routes as this is no longer needed.


