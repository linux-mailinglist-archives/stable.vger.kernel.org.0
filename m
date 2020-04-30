Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24501BFA43
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgD3Nw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgD3NwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:52:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E8B924955;
        Thu, 30 Apr 2020 13:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254745;
        bh=wIKXzFqMTAINVGKW6QkWm/9DSbQ3VQX2Ny4HMXoVPb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViV5JstT8FiocrN5BT+izMBksRhuxSFt585Kp1GJVUJ5MYM0J8cFudmAwAUQf4kU7
         Mqft8vr54v05LnxoxYerO+u73mzZjQ8ntFBShM8Kc2+GXArN/+epb14GVt9kWkUIXj
         obex8JlRSIKVtnhhGgHE610z9Bcj/ZJdAdu+P7oA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 05/57] ASoC: topology: Check soc_tplg_add_route return value
Date:   Thu, 30 Apr 2020 09:51:26 -0400
Message-Id: <20200430135218.20372-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index efe6ad3bfcd9b..e0b40d4d8784c 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1283,7 +1283,9 @@ static int soc_tplg_dapm_graph_elems_load(struct soc_tplg *tplg,
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

