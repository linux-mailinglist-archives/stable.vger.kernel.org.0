Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C942A0A5D
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 16:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbgJ3Ptg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 11:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727195AbgJ3Ptf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 11:49:35 -0400
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95439221EB;
        Fri, 30 Oct 2020 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604072974;
        bh=V6qzY14LfJ5Qyf+Zp/oXQxezqCq4VbzoDYPwNxOKOhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHMmLQWj/hrKi5keJjlqsxQMjXZrNmlZKbjy2paFODhj+RqM7NouoGE8VKn2UoUkM
         rESg3IOM/PSjlrHek6TbvICXdfd2VegMQXfqY/RnZzQhXYViEg8hDoitR7Ygtfhc1T
         mukGs/RapqPzH4p9SMRx1iDhzwju+1vManV9j6Zs=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Russell King <linux@armlinux.org.uk>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        viro@zeniv.linux.org.uk, linus.walleij@linaro.org, arnd@arndb.de,
        stable@vger.kernel.org
Subject: [PATCH 3/9] ARM: oabi-compat: add epoll_pwait handler
Date:   Fri, 30 Oct 2020 16:49:13 +0100
Message-Id: <20201030154919.1246645-3-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201030154919.1246645-1-arnd@kernel.org>
References: <20201030154519.1245983-1-arnd@kernel.org>
 <20201030154919.1246645-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The epoll_wait() syscall has a special version for OABI compat
mode to convert the arguments to the EABI structure layout
of the kernel. However, the later epoll_pwait() syscall was
added in arch/arm in linux-2.6.32 without this conversion.

Use the same kind of handler for both.

Fixes: 369842658a36 ("ARM: 5677/1: ARM support for TIF_RESTORE_SIGMASK/pselect6/ppoll/epoll_pwait")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/kernel/sys_oabi-compat.c | 37 ++++++++++++++++++++++++++++---
 arch/arm/tools/syscall.tbl        |  2 +-
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 0203e545bbc8..a2b1ae01e5bf 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -264,9 +264,8 @@ asmlinkage long sys_oabi_epoll_ctl(int epfd, int op, int fd,
 	return do_epoll_ctl(epfd, op, fd, &kernel, false);
 }
 
-asmlinkage long sys_oabi_epoll_wait(int epfd,
-				    struct oabi_epoll_event __user *events,
-				    int maxevents, int timeout)
+static long do_oabi_epoll_wait(int epfd, struct oabi_epoll_event __user *events,
+			       int maxevents, int timeout)
 {
 	struct epoll_event *kbuf;
 	struct oabi_epoll_event e;
@@ -299,6 +298,38 @@ asmlinkage long sys_oabi_epoll_wait(int epfd,
 	return err ? -EFAULT : ret;
 }
 
+SYSCALL_DEFINE4(oabi_epoll_wait, int, epfd,
+		struct oabi_epoll_event __user *, events,
+		int, maxevents, int, timeout)
+{
+	return do_oabi_epoll_wait(epfd, events, maxevents, timeout);
+}
+
+/*
+ * Implement the event wait interface for the eventpoll file. It is the kernel
+ * part of the user space epoll_pwait(2).
+ */
+SYSCALL_DEFINE6(oabi_epoll_pwait, int, epfd,
+		struct oabi_epoll_event __user *, events, int, maxevents,
+		int, timeout, const sigset_t __user *, sigmask,
+		size_t, sigsetsize)
+{
+	int error;
+
+	/*
+	 * If the caller wants a certain signal mask to be set during the wait,
+	 * we apply it here.
+	 */
+	error = set_user_sigmask(sigmask, sigsetsize);
+	if (error)
+		return error;
+
+	error = do_oabi_epoll_wait(epfd, events, maxevents, timeout);
+	restore_saved_sigmask_unless(error == -EINTR);
+
+	return error;
+}
+
 struct oabi_sembuf {
 	unsigned short	sem_num;
 	short		sem_op;
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index d056a548358e..330cf0aa04c4 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -360,7 +360,7 @@
 343	common	vmsplice		sys_vmsplice
 344	common	move_pages		sys_move_pages
 345	common	getcpu			sys_getcpu
-346	common	epoll_pwait		sys_epoll_pwait
+346	common	epoll_pwait		sys_epoll_pwait		sys_oabi_epoll_pwait
 347	common	kexec_load		sys_kexec_load
 348	common	utimensat		sys_utimensat_time32
 349	common	signalfd		sys_signalfd
-- 
2.27.0

