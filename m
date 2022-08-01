Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1E25869FA
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbiHAMKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbiHAMJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:09:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD17865670;
        Mon,  1 Aug 2022 04:56:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C3C4B80EAC;
        Mon,  1 Aug 2022 11:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED20C433C1;
        Mon,  1 Aug 2022 11:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354972;
        bh=FZ7qdQqb6OKyqrt8HeDVkfqD76pNHrnbJRAJTK7zECE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdmLWuMvwR+qZ4YOIGugvv0AkrSQgZ6I4D9eWL0PrmTvtGX5Jhqovs5P42AkOvIEi
         /H0gwfq8RAwOpGI2x2vY1kzRzhwuZlHRnd3mbO5v4Q4StG+UmXUY/IU1WDX8aVM1+/
         M3aTiEF1z7sJkZ8hox+KzvAL7sYilT5JdlBAH6r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Tomasz=20Pawe=C5=82=20Gajc?= <tpgxyz@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 5.18 17/88] drm/simpledrm: Fix return type of simpledrm_simple_display_pipe_mode_valid()
Date:   Mon,  1 Aug 2022 13:46:31 +0200
Message-Id: <20220801114138.843533461@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 0c09bc33aa8e9dc867300acaadc318c2f0d85a1e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/simpledrm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -627,7 +627,7 @@ static const struct drm_connector_funcs
 	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
 };
 
-static int
+static enum drm_mode_status
 simpledrm_simple_display_pipe_mode_valid(struct drm_simple_display_pipe *pipe,
 				    const struct drm_display_mode *mode)
 {


