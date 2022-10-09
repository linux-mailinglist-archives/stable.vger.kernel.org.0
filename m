Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31F35F95F7
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbiJJA0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbiJJAYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:24:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5F53EA6F;
        Sun,  9 Oct 2022 16:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4792560C57;
        Sun,  9 Oct 2022 23:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15334C43141;
        Sun,  9 Oct 2022 23:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359887;
        bh=smQ+WOJ2DvzcoWgCJ8NdsVMDowvo9I+a12p6Z3muVUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5MDaU90hyZH12wsdpfdQYWILWq7W6zKm+dDSF6MVlXf3zhWnxMEDR/XNqB4Yodt3
         uxQXkSms29xREs4t0mjv2B+752yZfMIasuRrl6k7HOcGPzvshMUMlpESC+vIIdMKVN
         jMOZDOI4MvET+mrfIvetOx5yKQSca5AHBVO9O6oMsm+vmIRLmcT9Ns9aAA5tpIgdL8
         Hp3BdvqWCGmzel0XTgylexjn8AZ17Q+WnplHb6Dr8ZxH7K9Q99XeLb9c0WUZ+o+jSw
         k9UacFgC5QKFqBXNjrTsJAdoix5ql5q/cuG9PaXAa33aHLzgVLczTqD0f243KGKYip
         7oHFhqm178pDg==
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
Subject: [PATCH AUTOSEL 4.19 10/10] drm/exynos: Fix return type for mixer_mode_valid and hdmi_mode_valid
Date:   Sun,  9 Oct 2022 19:57:45 -0400
Message-Id: <20221009235746.1232129-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235746.1232129-1-sashal@kernel.org>
References: <20221009235746.1232129-1-sashal@kernel.org>
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
index 2092a650df7d..227856f0a3c4 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -911,8 +911,8 @@ static int hdmi_find_phy_conf(struct hdmi_context *hdata, u32 pixel_clock)
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
index 522d6c46d7b1..16a7624021a8 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -1018,7 +1018,7 @@ static void mixer_disable(struct exynos_drm_crtc *crtc)
 	clear_bit(MXR_BIT_POWERED, &ctx->flags);
 }
 
-static int mixer_mode_valid(struct exynos_drm_crtc *crtc,
+static enum drm_mode_status mixer_mode_valid(struct exynos_drm_crtc *crtc,
 		const struct drm_display_mode *mode)
 {
 	struct mixer_context *ctx = crtc->ctx;
-- 
2.35.1

