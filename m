Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A98F6501BD
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbiLRQfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiLRQdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:33:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876F8270D;
        Sun, 18 Dec 2022 08:12:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 224C160DB4;
        Sun, 18 Dec 2022 16:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB47C433EF;
        Sun, 18 Dec 2022 16:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379967;
        bh=kvU+2fSgBjunwK2CfNT1L4BIgyAbAMZJL4sX1ZHUArQ=;
        h=From:To:Cc:Subject:Date:From;
        b=g8GtzOBDXIazXIunYnmhHBjvxD6dDRXH8dajDWvqrAFYC+bBRw9TgnIzzoT65KyHE
         wB+T9lzvgPZk0Hgj3k0c7NAUg8+EDS2KB85/gf8p2KHIyhU1fEwW+39V2yLoO8sxQb
         mF8yGSB8MA7VCo0Zqg0lPBL4yMgZ8RNPL3kTcOViFDElQUgYH4BF4YYFr2YFKC8AXy
         nni9rA7M18kGGJO8JlLGF34lU+yPn3wb+Od6vRPEJRnpVXq3kJKA5Kz3KRqcTQNHL3
         pY7XkAtjs53Lmt4OBZLjYbt7Yf4gPrt9XfHhz3SacI8hIss3wUs+qYWaI1ASokSgKa
         MI515eORqgTpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Brown <doug@schmorgal.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, airlied@gmail.com,
        daniel@ffwll.ch, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 01/46] drm/etnaviv: add missing quirks for GC300
Date:   Sun, 18 Dec 2022 11:11:59 -0500
Message-Id: <20221218161244.930785-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Brown <doug@schmorgal.com>

[ Upstream commit cc7d3fb446a91f24978a6aa59cbb578f92e22242 ]

The GC300's features register doesn't specify that a 2D pipe is
available, and like the GC600, its idle register reports zero bits where
modules aren't present.

Signed-off-by: Doug Brown <doug@schmorgal.com>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index cc5b07f86346..e8ff70be449a 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -416,6 +416,12 @@ static void etnaviv_hw_identify(struct etnaviv_gpu *gpu)
 	if (gpu->identity.model == chipModel_GC700)
 		gpu->identity.features &= ~chipFeatures_FAST_CLEAR;
 
+	/* These models/revisions don't have the 2D pipe bit */
+	if ((gpu->identity.model == chipModel_GC500 &&
+	     gpu->identity.revision <= 2) ||
+	    gpu->identity.model == chipModel_GC300)
+		gpu->identity.features |= chipFeatures_PIPE_2D;
+
 	if ((gpu->identity.model == chipModel_GC500 &&
 	     gpu->identity.revision < 2) ||
 	    (gpu->identity.model == chipModel_GC300 &&
@@ -449,8 +455,9 @@ static void etnaviv_hw_identify(struct etnaviv_gpu *gpu)
 				gpu_read(gpu, VIVS_HI_CHIP_MINOR_FEATURE_5);
 	}
 
-	/* GC600 idle register reports zero bits where modules aren't present */
-	if (gpu->identity.model == chipModel_GC600)
+	/* GC600/300 idle register reports zero bits where modules aren't present */
+	if (gpu->identity.model == chipModel_GC600 ||
+	    gpu->identity.model == chipModel_GC300)
 		gpu->idle_mask = VIVS_HI_IDLE_STATE_TX |
 				 VIVS_HI_IDLE_STATE_RA |
 				 VIVS_HI_IDLE_STATE_SE |
-- 
2.35.1

