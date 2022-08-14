Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F02592157
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240759AbiHNPgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240792AbiHNPfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:35:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BBD1CFE9;
        Sun, 14 Aug 2022 08:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DBB060C8C;
        Sun, 14 Aug 2022 15:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E18C433D6;
        Sun, 14 Aug 2022 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491056;
        bh=YA7qGjAoZ0w68jbN59Y8bWwXYBlkSuhDhVnrXYHcvq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMF4rrtPsLxTsUC13FTY1pKYHw14XFUPrHdEEQeLJGMosSQKljhHyy32ML8ios2vj
         if5zYbMBYZCs9255pPtoCNJ1K5uImyx6D7BIAXRj57mh+mi11Hb2vNfsEqpa3pcUYk
         P4cuW08rZQxXQXesAB9pWXyx0sk10MSWhq5CaQQoPGEXYN7chZJKgM+Yq0+PCobCiC
         TyaJoMasWYtBpBSuhiWWQOxIVpOQFP7OzGJe2aNCX6oQYRLdXW9polOaFPr1Z61hDw
         yeGrCMGaB37aI7gwrW+1qT9FTL1vn+0koqfMqVd6NPKrCFmJ0LiEI8zv3knrHhNq2F
         zD3Xlvlwv62/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, khilman@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 13/56] drm/meson: Fix overflow implicit truncation warnings
Date:   Sun, 14 Aug 2022 11:29:43 -0400
Message-Id: <20220814153026.2377377-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <quic_saipraka@quicinc.com>

[ Upstream commit 98692f52c588225034cbff458622c2c06dfcb544 ]

Fix -Woverflow warnings for drm/meson driver which is a result
of moving arm64 custom MMIO accessor macros to asm-generic function
implementations giving a bonus type-checking now and uncovering these
overflow warnings.

drivers/gpu/drm/meson/meson_viu.c: In function ‘meson_viu_init’:
drivers/gpu/drm/meson/meson_registers.h:1826:48: error: large integer implicitly truncated to unsigned type [-Werror=overflow]
 #define  VIU_OSD_BLEND_REORDER(dest, src)      ((src) << (dest * 4))
                                                ^
drivers/gpu/drm/meson/meson_viu.c:472:18: note: in expansion of macro ‘VIU_OSD_BLEND_REORDER’
   writel_relaxed(VIU_OSD_BLEND_REORDER(0, 1) |
                  ^~~~~~~~~~~~~~~~~~~~~

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_viu.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_viu.c b/drivers/gpu/drm/meson/meson_viu.c
index 259f3e6bec90..bb7e109534de 100644
--- a/drivers/gpu/drm/meson/meson_viu.c
+++ b/drivers/gpu/drm/meson/meson_viu.c
@@ -469,17 +469,17 @@ void meson_viu_init(struct meson_drm *priv)
 			priv->io_base + _REG(VD2_IF0_LUMA_FIFO_SIZE));
 
 	if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A)) {
-		writel_relaxed(VIU_OSD_BLEND_REORDER(0, 1) |
-			       VIU_OSD_BLEND_REORDER(1, 0) |
-			       VIU_OSD_BLEND_REORDER(2, 0) |
-			       VIU_OSD_BLEND_REORDER(3, 0) |
-			       VIU_OSD_BLEND_DIN_EN(1) |
-			       VIU_OSD_BLEND1_DIN3_BYPASS_TO_DOUT1 |
-			       VIU_OSD_BLEND1_DOUT_BYPASS_TO_BLEND2 |
-			       VIU_OSD_BLEND_DIN0_BYPASS_TO_DOUT0 |
-			       VIU_OSD_BLEND_BLEN2_PREMULT_EN(1) |
-			       VIU_OSD_BLEND_HOLD_LINES(4),
-			       priv->io_base + _REG(VIU_OSD_BLEND_CTRL));
+		u32 val = (u32)VIU_OSD_BLEND_REORDER(0, 1) |
+			  (u32)VIU_OSD_BLEND_REORDER(1, 0) |
+			  (u32)VIU_OSD_BLEND_REORDER(2, 0) |
+			  (u32)VIU_OSD_BLEND_REORDER(3, 0) |
+			  (u32)VIU_OSD_BLEND_DIN_EN(1) |
+			  (u32)VIU_OSD_BLEND1_DIN3_BYPASS_TO_DOUT1 |
+			  (u32)VIU_OSD_BLEND1_DOUT_BYPASS_TO_BLEND2 |
+			  (u32)VIU_OSD_BLEND_DIN0_BYPASS_TO_DOUT0 |
+			  (u32)VIU_OSD_BLEND_BLEN2_PREMULT_EN(1) |
+			  (u32)VIU_OSD_BLEND_HOLD_LINES(4);
+		writel_relaxed(val, priv->io_base + _REG(VIU_OSD_BLEND_CTRL));
 
 		writel_relaxed(OSD_BLEND_PATH_SEL_ENABLE,
 			       priv->io_base + _REG(OSD1_BLEND_SRC_CTRL));
-- 
2.35.1

