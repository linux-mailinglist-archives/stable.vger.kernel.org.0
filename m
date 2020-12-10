Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3C82D62B8
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389519AbgLJOg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729844AbgLJOgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:36:20 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg KH <greg@kroah.com>,
        Kees Cook <keescook@chromium.org>, Willy Tarreau <w@1wt.eu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 42/54] lib/syscall: fix syscall registers retrieval on 32-bit platforms
Date:   Thu, 10 Dec 2020 15:27:19 +0100
Message-Id: <20201210142604.106487872@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

commit 4f134b89a24b965991e7c345b9a4591821f7c2a6 upstream.

Lilith >_> and Claudio Bozzato of Cisco Talos security team reported
that collect_syscall() improperly casts the syscall registers to 64-bit
values leaking the uninitialized last 24 bytes on 32-bit platforms, that
are visible in /proc/self/syscall.

The cause is that info->data.args are u64 while syscall_get_arguments()
uses longs, as hinted by the bogus pointer cast in the function.

Let's just proceed like the other call places, by retrieving the
registers into an array of longs before assigning them to the caller's
array.  This was successfully tested on x86_64, i386 and ppc32.

Reference: CVE-2020-28588, TALOS-2020-1211
Fixes: 631b7abacd02 ("ptrace: Remove maxargs from task_current_syscall()")
Cc: Greg KH <greg@kroah.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Michael Ellerman <mpe@ellerman.id.au> (ppc32)
Signed-off-by: Willy Tarreau <w@1wt.eu>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/syscall.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/lib/syscall.c
+++ b/lib/syscall.c
@@ -7,6 +7,7 @@
 
 static int collect_syscall(struct task_struct *target, struct syscall_info *info)
 {
+	unsigned long args[6] = { };
 	struct pt_regs *regs;
 
 	if (!try_get_task_stack(target)) {
@@ -27,8 +28,14 @@ static int collect_syscall(struct task_s
 
 	info->data.nr = syscall_get_nr(target, regs);
 	if (info->data.nr != -1L)
-		syscall_get_arguments(target, regs,
-				      (unsigned long *)&info->data.args[0]);
+		syscall_get_arguments(target, regs, args);
+
+	info->data.args[0] = args[0];
+	info->data.args[1] = args[1];
+	info->data.args[2] = args[2];
+	info->data.args[3] = args[3];
+	info->data.args[4] = args[4];
+	info->data.args[5] = args[5];
 
 	put_task_stack(target);
 	return 0;


