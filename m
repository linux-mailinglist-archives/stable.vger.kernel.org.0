Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16F95F95B2
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiJJAWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiJJAVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:21:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D490C3ED6E;
        Sun,  9 Oct 2022 16:55:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70D9960DD1;
        Sun,  9 Oct 2022 23:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28429C433B5;
        Sun,  9 Oct 2022 23:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359717;
        bh=SX0GqgOA8NN1x9UoZzDYjtv0281u8oPohNcPl7py/Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwBZqeR+h73t1N4u4V28v4NpOo1PxOkzeu1vKw+z/3hdE+Cw46NpdMMw1cbz686ZN
         VddtwUjT3gDVgCCM9pP42q4CzydlAXBAzCheyZS0nbV9b8IPkzI1ToAjHWFFfaTfJs
         0Tduzi1AfVL/EqzQiUrGBn26oWxov5jxrFv0uI1msgGwIgSNAf5FEYQSJn7nRLlHHD
         4UaX6/Ki6fIBKQMnU+z5yhi49FIHtEwMSNl3kZ+nev2mxlw2z5PMiOxBdA6ubrJ8zD
         sMpqrnic1VwLbsIF4n3jzZQb0X1GrZ/9CEXcBSraWArpt3AAPh/rkDycLCnMEB5FyL
         JUOAt59OCE+6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Inki Dae <inki.dae@samsung.com>,
        Sasha Levin <sashal@kernel.org>, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@gmail.com, daniel@ffwll.ch,
        krzysztof.kozlowski@linaro.org, nathan@kernel.org,
        ndesaulniers@google.com, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 21/25] drm/exynos: Fix return type for mixer_mode_valid and hdmi_mode_valid
Date:   Sun,  9 Oct 2022 19:54:21 -0400
Message-Id: <20221009235426.1231313-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235426.1231313-1-sashal@kernel.org>
References: <20221009235426.1231313-1-sashal@kernel.org>
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

From: Nathan Huckleberry <nhuck@google.com>

[ Upstream commit 1261255531088208daeca818e2b486030b5339e5 ]

The field mode_valid in exynos_drm_crtc_ops is expected to be of type enum
drm_mode_status (*mode_valid)(struct exynos_drm_crtc *crtc,
                                   const struct drm_display_mode *mode);

Likewise for mode_valid in drm_connector_helper_funcs.

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of mixer_mode_valid and hdmi_mode_valid should be changed
from int to enum drm_mode_status.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://protect2.fireeye.com/v1/url?k=3e644738-5fef521d-3e65cc77-
74fe485cbff6-36ad29bf912d3c9f&q=1&e=5cc06174-77dd-4abd-ab50-
155da5711aa3&u=https%3A%2F%2Fgithub.com%2FClangBuiltLinux%2Flinux%2Fissues%2F
1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c  | 4 ++--
 drivers/gpu/drm/exynos/exynos_mixer.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 7655142a4651..912a7df9f8c4 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -922,8 +922,8 @@ static int hdmi_find_phy_conf(struct hdmi_context *hdata, u32 pixel_clock)
 	return -EINVAL;
 }
 
-static int hdmi_mode_valid(struct drm_connector *connector,
-			struct drm_display_mode *mode)
+static enum drm_mode_status hdmi_mode_valid(struct drm_connector *connector,
+					    struct drm_display_mode *mode)
 {
 	struct hdmi_context *hdata = connector_to_hdmi(connector);
 	int ret;
diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index 41c54f1f60bc..8d01e1068245 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -1044,7 +1044,7 @@ static void mixer_atomic_disable(struct exynos_drm_crtc *crtc)
 	clear_bit(MXR_BIT_POWERED, &ctx->flags);
 }
 
-static int mixer_mode_valid(struct exynos_drm_crtc *crtc,
+static enum drm_mode_status mixer_mode_valid(struct exynos_drm_crtc *crtc,
 		const struct drm_display_mode *mode)
 {
 	struct mixer_context *ctx = crtc->ctx;
-- 
2.35.1

