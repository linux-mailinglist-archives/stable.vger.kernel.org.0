Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EF765180A
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbiLTBYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiLTBWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:22:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A301658E;
        Mon, 19 Dec 2022 17:21:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C593D6120F;
        Tue, 20 Dec 2022 01:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2680EC433D2;
        Tue, 20 Dec 2022 01:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499310;
        bh=qOA0kc5AT61+wN807kw4Lv6g/XMsGIrYoDY0P4yySpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T25eC21SvsWFQLFyDVzWysedVoZdu1U7dIIKwCaH8hpTHnSe/iQUoIj2TZy3xREnb
         7sTX3HlmN4uHdFDc5jBc70HR6xgMpBNj9lsNonVJMWoXhVterFYRqsiOYlY0m+ijQA
         Rh5bWSXDkaNY0v6R9yqKMquwA5DrrshLtBWPTjjmgBLblhbcqJrKB4JoWvHdePrXbt
         3qdo5lFbU+/SOq+xOsCglsrgkLx1MZOdV8xpC7881vrTVaGoZdpFE8wFNGWmFpTA+X
         Wu5LuJVIwsnQ4v7nCNK2HPTKgRfhJ9pnCx/VNMk83VAesJDGZAPYw/J/rkUCoBHJby
         VbP2vYYSDgoLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>, alain.volmat@foss.st.com,
        airlied@gmail.com, daniel@ffwll.ch, ndesaulniers@google.com,
        dri-devel@lists.freedesktop.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 11/16] drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()
Date:   Mon, 19 Dec 2022 20:21:21 -0500
Message-Id: <20221220012127.1222311-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012127.1222311-1-sashal@kernel.org>
References: <20221220012127.1222311-1-sashal@kernel.org>
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

[ Upstream commit 0ad811cc08a937d875cbad0149c1bab17f84ba05 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/gpu/drm/sti/sti_hda.c:637:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .mode_valid = sti_hda_connector_mode_valid,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/sti/sti_dvo.c:376:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .mode_valid = sti_dvo_connector_mode_valid,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/gpu/drm/sti/sti_hdmi.c:1035:16: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(struct drm_connector *, struct drm_display_mode *)' with an expression of type 'int (struct drm_connector *, struct drm_display_mode *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .mode_valid = sti_hdmi_connector_mode_valid,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

->mode_valid() in 'struct drm_connector_helper_funcs' expects a return
type of 'enum drm_mode_status', not 'int'. Adjust the return type of
sti_{dvo,hda,hdmi}_connector_mode_valid() to match the prototype's to
resolve the warning and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221102155623.3042869-1-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sti/sti_dvo.c  | 5 +++--
 drivers/gpu/drm/sti/sti_hda.c  | 5 +++--
 drivers/gpu/drm/sti/sti_hdmi.c | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_dvo.c b/drivers/gpu/drm/sti/sti_dvo.c
index b6ee8a82e656..076d5f30a09c 100644
--- a/drivers/gpu/drm/sti/sti_dvo.c
+++ b/drivers/gpu/drm/sti/sti_dvo.c
@@ -346,8 +346,9 @@ static int sti_dvo_connector_get_modes(struct drm_connector *connector)
 
 #define CLK_TOLERANCE_HZ 50
 
-static int sti_dvo_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+sti_dvo_connector_mode_valid(struct drm_connector *connector,
+			     struct drm_display_mode *mode)
 {
 	int target = mode->clock * 1000;
 	int target_min = target - CLK_TOLERANCE_HZ;
diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
index 03cc401ed593..a53b5a15c2a9 100644
--- a/drivers/gpu/drm/sti/sti_hda.c
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -601,8 +601,9 @@ static int sti_hda_connector_get_modes(struct drm_connector *connector)
 
 #define CLK_TOLERANCE_HZ 50
 
-static int sti_hda_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+sti_hda_connector_mode_valid(struct drm_connector *connector,
+			     struct drm_display_mode *mode)
 {
 	int target = mode->clock * 1000;
 	int target_min = target - CLK_TOLERANCE_HZ;
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index cb82622877d2..09e0cadb6368 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -1004,8 +1004,9 @@ static int sti_hdmi_connector_get_modes(struct drm_connector *connector)
 
 #define CLK_TOLERANCE_HZ 50
 
-static int sti_hdmi_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+sti_hdmi_connector_mode_valid(struct drm_connector *connector,
+			      struct drm_display_mode *mode)
 {
 	int target = mode->clock * 1000;
 	int target_min = target - CLK_TOLERANCE_HZ;
-- 
2.35.1

