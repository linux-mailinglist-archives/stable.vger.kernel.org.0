Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3CD65182B
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiLTBZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiLTBXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:23:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D48B10FEE;
        Mon, 19 Dec 2022 17:22:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C67C16120F;
        Tue, 20 Dec 2022 01:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DF2C433D2;
        Tue, 20 Dec 2022 01:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499334;
        bh=NEUP6zN9OADZm5zNxMnUdUs2DJSQYC2jc+XVsX3Rf54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4OBOl6iknMkltLcCr38As4JD7olCtUVE8L+prGMi4XC9KBYFz1N9F+4foMVg9hyB
         iDlvGyscBJhbkjBrjmib60rzMmdnFuAY4TztQGj1kHwm7ZeuBtbEyDFPVONMZQG8m+
         EufxZTn7YipXzZb68F4KYTKvZtcvW6wlOWR1CJ0WiHVJdda8f94VqZeRItlvl4EEXd
         QDV5R9Mln/yFHxkqMi76mSf/GRDYi5grIDaPehwob7JLrzrc85fsip+m3MrOFHa9tl
         4nvmdeZYyROyIptvMSioXVb8O/KYtrIsSBXbAbPAtwL6mFnKzVm6NLLrgNwVH/iZJh
         HOmEi+hkDdr+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>, stefan@agner.ch,
        alison.wang@nxp.com, airlied@gmail.com, daniel@ffwll.ch,
        ndesaulniers@google.com, dri-devel@lists.freedesktop.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 6/9] drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
Date:   Mon, 19 Dec 2022 20:21:56 -0500
Message-Id: <20221220012159.1222517-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012159.1222517-1-sashal@kernel.org>
References: <20221220012159.1222517-1-sashal@kernel.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 96d845a67b7e406cfed7880a724c8ca6121e022e ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c:74:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .mode_valid = fsl_dcu_drm_connector_mode_valid,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

->mode_valid() in 'struct drm_connector_helper_funcs' expects a return
type of 'enum drm_mode_status', not 'int'. Adjust the return type of
fsl_dcu_drm_connector_mode_valid() to match the prototype's to resolve
the warning and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221102154215.78059-1-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
index 4d4a715b429d..2c2b92324a2e 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
@@ -60,8 +60,9 @@ static int fsl_dcu_drm_connector_get_modes(struct drm_connector *connector)
 	return drm_panel_get_modes(fsl_connector->panel, connector);
 }
 
-static int fsl_dcu_drm_connector_mode_valid(struct drm_connector *connector,
-					    struct drm_display_mode *mode)
+static enum drm_mode_status
+fsl_dcu_drm_connector_mode_valid(struct drm_connector *connector,
+				 struct drm_display_mode *mode)
 {
 	if (mode->hdisplay & 0xf)
 		return MODE_ERROR;
-- 
2.35.1

