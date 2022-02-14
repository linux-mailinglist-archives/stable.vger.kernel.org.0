Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2592E4B476B
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244343AbiBNJhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:37:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245078AbiBNJg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:36:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8576D1BB;
        Mon, 14 Feb 2022 01:34:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEE7F60FA2;
        Mon, 14 Feb 2022 09:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D97FC340E9;
        Mon, 14 Feb 2022 09:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831261;
        bh=+K6gOQcA+LF5SpOFif8PwRQQML3bGTv7/R/mALbvJcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lprVTGPQ9z9dpfM15I1XE1Myo2M0FDrfpeOMsPYC/hZSzIJH5VA/KP8p8UyU5xqjM
         dQhJwEEaYffG6oUT/3FCPxE/kqVN6iwMs6FTRZCGeCS6E+tgJ2w72N/NBwM0Ae1yqR
         9fuAqy04ugZFXpuUV3q8x3j8FONaEYEAXjgB+Vhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.19 47/49] seccomp: Invalidate seccomp mode to catch death failures
Date:   Mon, 14 Feb 2022 10:26:13 +0100
Message-Id: <20220214092449.859958524@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Kees Cook <keescook@chromium.org>

commit 495ac3069a6235bfdf516812a2a9b256671bbdf9 upstream.

If seccomp tries to kill a process, it should never see that process
again. To enforce this proactively, switch the mode to something
impossible. If encountered: WARN, reject all syscalls, and attempt to
kill the process again even harder.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Fixes: 8112c4f140fa ("seccomp: remove 2-phase API")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/seccomp.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -28,6 +28,9 @@
 #include <linux/syscalls.h>
 #include <linux/sysctl.h>
 
+/* Not exposed in headers: strictly internal use only. */
+#define SECCOMP_MODE_DEAD	(SECCOMP_MODE_FILTER + 1)
+
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 #include <asm/syscall.h>
 #endif
@@ -628,6 +631,7 @@ static void __secure_computing_strict(in
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
+	current->seccomp.mode = SECCOMP_MODE_DEAD;
 	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL_THREAD, true);
 	do_exit(SIGKILL);
 }
@@ -742,6 +746,7 @@ static int __seccomp_filter(int this_sys
 	case SECCOMP_RET_KILL_THREAD:
 	case SECCOMP_RET_KILL_PROCESS:
 	default:
+		current->seccomp.mode = SECCOMP_MODE_DEAD;
 		seccomp_log(this_syscall, SIGSYS, action, true);
 		/* Dump core only if this is the last remaining thread. */
 		if (action == SECCOMP_RET_KILL_PROCESS ||
@@ -794,6 +799,11 @@ int __secure_computing(const struct secc
 		return 0;
 	case SECCOMP_MODE_FILTER:
 		return __seccomp_filter(this_syscall, sd, false);
+	/* Surviving SECCOMP_RET_KILL_* must be proactively impossible. */
+	case SECCOMP_MODE_DEAD:
+		WARN_ON_ONCE(1);
+		do_exit(SIGKILL);
+		return -1;
 	default:
 		BUG();
 	}


