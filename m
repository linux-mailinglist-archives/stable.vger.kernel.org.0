Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729DE280122
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 16:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbgJAOSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 10:18:38 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:45781 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732213AbgJAOSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 10:18:37 -0400
Received: from threadripper.lan ([46.223.126.90]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MvbJw-1kepec1eTe-00shEs; Thu, 01 Oct 2020 16:12:52 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Russell King <linux@armlinux.org.uk>,
        Christoph Hellwig <hch@lst.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Subject: [PATCH v3 03/10] ARM: oabi-compat: add epoll_pwait handler
Date:   Thu,  1 Oct 2020 16:12:26 +0200
Message-Id: <20201001141233.119343-4-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201001141233.119343-1-arnd@arndb.de>
References: <20201001141233.119343-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:cWWCYuRJriYKt0llInUlGsi6sGZrKAuOlwaggzj3/coCoUzqfLK
 tdhpTdf+H1PnSpU5qTRkfZCY1eCG1Cjc26hA5rHMOatSmHap4G/tHtXis84Mc+nDdeUaSjS
 PlQBkFWU32fdiDbaBtMFwdhbryJMvp4bYkfA1tB83+ywMKEBtsP41yb1F5scXxc27obsYYl
 e2PBjElmQm1a2yMG97plw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8KoJdIdJE48=:NagsGsryJpJbVVgCWIG8Dl
 TK55c5Uky+ByPG1n0gRwWakJVYO/rum7Ux9EMwxw91jTAxdKRmgLratvGoZ+w+d89GM1/Xrss
 8mp5vJ2u/mIAlWDsGAiaZQVCY5yqvUFYUXitsawpLdx1VsStNyKZHj3SAYrX3sPvDjeOeQJXf
 F6Lz90Gp9PCiKUn6fqK4E7/+ocAABsMbmGk5yZtGtwRpewnpwuw2V5+WJTQ3NY27aIkxD3m/7
 LHpuZRYac6TnT2w1JkBTDwhC8CRzSKpa9Rm2uv5SOn0hno8TZrXP6GyHfRRrRicof/lVHpYHT
 BX4OZ0bhwOh8/t9HHeR2hTSxmvzeEzusPH6/uDoaGFgP8D5eBS4eI5GFMXi/GftQT8h8ksI+y
 KEhdH540xg7sfyfcpEHFGD5JOww8qU9qWqd5mALH5//Bwdd5ry2NdZGRj1VhppgCoFoX631wV
 qGMAVZOMt6YwsxvTZk1249fzxgX+vb1EILfPlxIX2PMU4/VGNPcsCKbCCsfP56uTPmJ/Fd6p2
 waKzgHp2TSV98nFLc+zdB1KSrJ9ug4trDLi3k+zSyDzQ0halWiwkKje9GEMCN1GXuS8FyJwzQ
 8NhhcnZjaKSrjuU+Mx5cN4X3BmZHiatQqxLRUt20yBp32u8ON/1icfzMj+9e9GWffja+q+hqt
 cI59jmyFR73TKPORMGcpQGPV58tOFPeqZm4sQPHYYj+sgKqzc5j6uzbIl9PUE0v+UzxLeAZIW
 ST77u6VkPYfPRhW1KJP41f7XnCIQ25CfZo8FF4Y3MpFIqe+P//8m5xvwgZYU7FdIamOb+/ArD
 5SAbi0rCo5TiFEA+SFhgjJanfVX73IB3zEYSj5t+AEXWE36j5qZAz7UwRzOjryug3gVTGIk
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 171077cbf419..39a24bee7df8 100644
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

