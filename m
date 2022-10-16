Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FF9600111
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 18:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJPQLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 12:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJPQLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 12:11:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27ED33E15
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 09:11:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58CFBB80CBF
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 16:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E01C433D6;
        Sun, 16 Oct 2022 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665936678;
        bh=7lyM1HM6doQwUDaYRWQoHdYY0w8+sgI75Y4x0ehmYKA=;
        h=Subject:To:Cc:From:Date:From;
        b=B/q28327GOELJeOEsQDBE3+dGyk+X9SjbwyWLYv8NR5lERKQ/gUZYUeylGDiwPLgn
         mjrAJQ+Yz30oETJABqLyD8GGWyTmlzZu8QSOUkVeGWoYMM1g9v2GqvFL6MaZhYVQ4N
         ox/I+jX1NWscWQWrJ9jx60H9y0NmpCsndosnkhfU=
Subject: FAILED: patch "[PATCH] drm/simpledrm: Fix return type of" failed to apply to 6.0-stable tree
To:     nathan@kernel.org, samitolvanen@google.com, tpgxyz@gmail.com,
        tzimmermann@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 18:12:03 +0200
Message-ID: <166593672329153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f9929f69de94 ("drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f9929f69de94212f98b3ad72a3e81c3bd3d333e0 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 25 Jul 2022 16:36:29 -0700
Subject: [PATCH] drm/simpledrm: Fix return type of
 simpledrm_simple_display_pipe_mode_valid()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When booting a kernel compiled with clang's CFI protection
(CONFIG_CFI_CLANG), there is a CFI failure in
drm_simple_kms_crtc_mode_valid() when trying to call
simpledrm_simple_display_pipe_mode_valid() through ->mode_valid():

[    0.322802] CFI failure (target: simpledrm_simple_display_pipe_mode_valid+0x0/0x8):
...
[    0.324928] Call trace:
[    0.324969]  __ubsan_handle_cfi_check_fail+0x58/0x60
[    0.325053]  __cfi_check_fail+0x3c/0x44
[    0.325120]  __cfi_slowpath_diag+0x178/0x200
[    0.325192]  drm_simple_kms_crtc_mode_valid+0x58/0x80
[    0.325279]  __drm_helper_update_and_validate+0x31c/0x464
...

The ->mode_valid() member in 'struct drm_simple_display_pipe_funcs'
expects a return type of 'enum drm_mode_status', not 'int'. Correct it
to fix the CFI failure.

Cc: stable@vger.kernel.org
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/1647
Reported-by: Tomasz Paweł Gajc <tpgxyz@gmail.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220725233629.223223-1-nathan@kernel.org
(cherry picked from commit 0c09bc33aa8e9dc867300acaadc318c2f0d85a1e)
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>

diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simpledrm.c
index 768242a78e2b..5422363690e7 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -627,7 +627,7 @@ static const struct drm_connector_funcs simpledrm_connector_funcs = {
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
-static int
+static enum drm_mode_status
 simpledrm_simple_display_pipe_mode_valid(struct drm_simple_display_pipe *pipe,
 				    const struct drm_display_mode *mode)
 {

