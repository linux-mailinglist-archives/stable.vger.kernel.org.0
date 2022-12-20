Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E434F65184E
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbiLTB04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiLTBZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:25:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F1B12619;
        Mon, 19 Dec 2022 17:22:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56BD2611CA;
        Tue, 20 Dec 2022 01:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79582C433F0;
        Tue, 20 Dec 2022 01:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499372;
        bh=nS27qSQH9aONY23QC2SPtvpuWbqFz0toZyg7XoZ4C0g=;
        h=From:To:Cc:Subject:Date:From;
        b=T3DZ9qAYroF27Gn8DpZpsBqEDwE4kss4InEc2um9k32a+x4NCQdOJlkwxG637dbxJ
         4AaSp1DnmIwZC4YeF1l7g0DAJzah+UCfMl9pXFXb0uQ9fAeocvvn7+h9hZfOdYqXK0
         dUIeiA1UPvdyydOGdeilMjNHgQd8rbuQEVtW2iAFdjAlj/oCaqK137tkOmYoXSfHwh
         r2VSgKSvhM403MLYH64ibdPp8nxZv2oM8YP+3eq8ynmtjio6J0KWwmxsIM0XX5ms5S
         I+8aQy3A2KxtM+rYITjC4M2vV9DzTQFE1cCqpVfzru2YfKVTfUeOkw9MC0DNLITLdL
         GOmooOJsIj+aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>, stefan@agner.ch,
        alison.wang@nxp.com, airlied@gmail.com, daniel@ffwll.ch,
        ndesaulniers@google.com, dri-devel@lists.freedesktop.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 4.9 1/3] drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
Date:   Mon, 19 Dec 2022 20:22:47 -0500
Message-Id: <20221220012249.1222904-1-sashal@kernel.org>
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
index e1dd75b18118..5993d6ac85e6 100644
--- a/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
+++ b/drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c
@@ -90,8 +90,9 @@ static int fsl_dcu_drm_connector_get_modes(struct drm_connector *connector)
 	return num_modes;
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

