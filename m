Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B6A4B3B1B
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 12:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbiBMLX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 06:23:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiBMLX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 06:23:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DF85B883
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 03:23:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45EE3B80AC8
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 11:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45443C004E1;
        Sun, 13 Feb 2022 11:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644751431;
        bh=bsDyie00NmBnmo/xFpI/WgZmi2zj/6tQQp2gTu107W8=;
        h=Subject:To:Cc:From:Date:From;
        b=BeFvRrKzPfhvli7uMIS71pkXVMqpDloUrjA/aiJudtHK4zEtFrKXEMBZlvoRS79LU
         jS/2wPHj3lFNwttX9d2GxBDXNs5xX8Im/fT+78INjXDdFseskiAy9cNv4m5oH4UL8c
         +9zy2+C4HvGD+rFx+CxaaN1ivxVfm2QROL08x0Uk=
Subject: FAILED: patch "[PATCH] seccomp: Invalidate seccomp mode to catch death failures" failed to apply to 4.9-stable tree
To:     keescook@chromium.org, luto@amacapital.net, wad@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Feb 2022 12:23:48 +0100
Message-ID: <1644751428247218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 495ac3069a6235bfdf516812a2a9b256671bbdf9 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Mon, 7 Feb 2022 20:21:13 -0800
Subject: [PATCH] seccomp: Invalidate seccomp mode to catch death failures

If seccomp tries to kill a process, it should never see that process
again. To enforce this proactively, switch the mode to something
impossible. If encountered: WARN, reject all syscalls, and attempt to
kill the process again even harder.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Fixes: 8112c4f140fa ("seccomp: remove 2-phase API")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 4d8f44a17727..db10e73d06e0 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -29,6 +29,9 @@
 #include <linux/syscalls.h>
 #include <linux/sysctl.h>
 
+/* Not exposed in headers: strictly internal use only. */
+#define SECCOMP_MODE_DEAD	(SECCOMP_MODE_FILTER + 1)
+
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 #include <asm/syscall.h>
 #endif
@@ -1010,6 +1013,7 @@ static void __secure_computing_strict(int this_syscall)
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
+	current->seccomp.mode = SECCOMP_MODE_DEAD;
 	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL_THREAD, true);
 	do_exit(SIGKILL);
 }
@@ -1261,6 +1265,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	case SECCOMP_RET_KILL_THREAD:
 	case SECCOMP_RET_KILL_PROCESS:
 	default:
+		current->seccomp.mode = SECCOMP_MODE_DEAD;
 		seccomp_log(this_syscall, SIGSYS, action, true);
 		/* Dump core only if this is the last remaining thread. */
 		if (action != SECCOMP_RET_KILL_THREAD ||
@@ -1309,6 +1314,11 @@ int __secure_computing(const struct seccomp_data *sd)
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

