Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7190D4B4A88
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346187AbiBNKRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346190AbiBNKPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:15:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97FE77A82;
        Mon, 14 Feb 2022 01:52:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B95BB80DBF;
        Mon, 14 Feb 2022 09:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5130DC36AEA;
        Mon, 14 Feb 2022 09:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832348;
        bh=OjPeCyA/ofgU7GFCY7rViE5BCiYYQglG21UC4UdiCZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdrgDFbpifXNosamZPphHK4pft3fC5Xc0gCmPm139XoNeNFRI0y10T9sw8cClD4GM
         VtRfjCgdLdk5RuC2G5QToBF1zBCFF0L3c08UwHhqEzRMDB8A4d4/NgiK8RkpWkR6wQ
         tc8/lqjKku9fZKNN9wY6LNHdSvJUw7Itd9wCMcrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 158/172] seccomp: Invalidate seccomp mode to catch death failures
Date:   Mon, 14 Feb 2022 10:26:56 +0100
Message-Id: <20220214092511.852647286@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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
@@ -29,6 +29,9 @@
 #include <linux/syscalls.h>
 #include <linux/sysctl.h>
 
+/* Not exposed in headers: strictly internal use only. */
+#define SECCOMP_MODE_DEAD	(SECCOMP_MODE_FILTER + 1)
+
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 #include <asm/syscall.h>
 #endif
@@ -1010,6 +1013,7 @@ static void __secure_computing_strict(in
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
+	current->seccomp.mode = SECCOMP_MODE_DEAD;
 	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL_THREAD, true);
 	do_exit(SIGKILL);
 }
@@ -1261,6 +1265,7 @@ static int __seccomp_filter(int this_sys
 	case SECCOMP_RET_KILL_THREAD:
 	case SECCOMP_RET_KILL_PROCESS:
 	default:
+		current->seccomp.mode = SECCOMP_MODE_DEAD;
 		seccomp_log(this_syscall, SIGSYS, action, true);
 		/* Dump core only if this is the last remaining thread. */
 		if (action != SECCOMP_RET_KILL_THREAD ||
@@ -1309,6 +1314,11 @@ int __secure_computing(const struct secc
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


