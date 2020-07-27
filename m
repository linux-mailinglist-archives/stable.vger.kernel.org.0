Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096FF22F15E
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgG0OSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731279AbgG0OSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:18:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D7042075A;
        Mon, 27 Jul 2020 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859521;
        bh=ypuA/oRfRs3AqXkaEtmQlA22CeAA125dbi9BiGjjIyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vShvrK6rWGy0tFWG8JLViLLTFFlafdeA/F3RMA0V1Z6owEhV1WqdRz2SQdHK5lkZz
         qqdVAHPF/bdUMZcHEPXs+LdTZnR0jDG5N6tfkce701Ro+dObr6kV9SK0b0I5Y7Sv9V
         vBxcB362r/0uGGnsiWvf23w1A5u+I2Ct/9D1XNvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 134/138] ASoC: topology: fix kernel oops on route addition error
Date:   Mon, 27 Jul 2020 16:05:29 +0200
Message-Id: <20200727134932.112940483@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
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
@@ -1284,17 +1284,29 @@ static int soc_tplg_dapm_graph_elems_loa
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


