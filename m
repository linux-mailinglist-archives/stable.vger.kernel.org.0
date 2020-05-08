Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B531CACF5
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbgEHM5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730291AbgEHMzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:55:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 656902495C;
        Fri,  8 May 2020 12:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942507;
        bh=+oeNiTYPadaKg8OL8/VAEVfJ9NdIfn3+Zuj8RJ/QEGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIhTfhdHwRTsd6IOtCnhjW7JQAy17VvdzCqAD5wjycW7jWXsrST9A/w29C1OXeyvl
         DOA4SsIMlD/W6poJChDO3HXt4AYNX8eYS5dI7VtX3/S6FUf4Rg/6gM2TKRAaYgruzv
         y/emWH2xokOS1H/QaXfZgrqaQGQR3uXnkt2YEzaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 06/49] ASoC: topology: Check soc_tplg_add_route return value
Date:   Fri,  8 May 2020 14:35:23 +0200
Message-Id: <20200508123043.815690910@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123042.775047422@linuxfoundation.org>
References: <20200508123042.775047422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 6856e887eae3efc0fe56899cb3f969fe063171c5 ]

Function soc_tplg_add_route can propagate error code from callback, we
should check its return value and handle fail in correct way.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200327204729.397-5-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index c86c3ea533f68..aa7714f2b78fd 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1284,7 +1284,9 @@ static int soc_tplg_dapm_graph_elems_load(struct soc_tplg *tplg,
 		routes[i]->dobj.index = tplg->index;
 		list_add(&routes[i]->dobj.list, &tplg->comp->dobj_list);
 
-		soc_tplg_add_route(tplg, routes[i]);
+		ret = soc_tplg_add_route(tplg, routes[i]);
+		if (ret < 0)
+			break;
 
 		/* add route, but keep going if some fail */
 		snd_soc_dapm_add_routes(dapm, routes[i], 1);
-- 
2.20.1



