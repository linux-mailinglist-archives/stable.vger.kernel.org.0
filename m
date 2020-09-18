Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA9426FD50
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 14:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgIRMrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 08:47:14 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:38071 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgIRMrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 08:47:05 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MfYgC-1kyvGF0nzE-00g4ML; Fri, 18 Sep 2020 14:46:35 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Christoph Hellwig <hch@infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 3/9] ARM: oabi-compat: add epoll_pwait handler
Date:   Fri, 18 Sep 2020 14:46:18 +0200
Message-Id: <20200918124624.1469673-4-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918124624.1469673-1-arnd@arndb.de>
References: <20200918124624.1469673-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:k9iqebiHjZ3oX4maOmeQmQ79S0aPwKPwE2q75VUILRfCNExgNeO
 t0nF6W9/K5gbYqjtYvM4XiNKBdrX7ZFYKkzh1Fxlh6/il8JpWkY3ypnnne2K3+vI88uMf/n
 qjTCSjNLfgphnVaY0MT4mVePdlMdTJlatzEmPXHlWRCVNfUZ6DbTt1b1Dh0nOmmPcquU1tI
 S6QntlECa7NX6h38ahEOA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XfkwJUmH3E4=:S60cqccaGmI+fr+LIINq+e
 sDHp87nP2o+HiNpcipd5cqxDft/QdzBStQvx4rdJIbhgsG3Z9YqLp+e0IzBqBycYmllyoxlC+
 Lu6splyvjbeRGeABicNZcAia+DzbZWji3IESnk4Enqlm3I4HWz1XhMHGbepFYsZrCBZ4Cvnj9
 rc6fETdbTjR+FAPREHNuIcL1kqsl0ivLBGngtWdX3EJr/vzZ3ENTveZA1yk+9WZHDjyRx/apv
 MJbeH5bbB6WxooA4NpCMwRbgIJdlocSUPiUQ7SC9NvZpGjdTTin1TmvCIS1/zGWe5ofM86sIC
 zCURttpBs5CH6gcyNOYCwfUO7Ed45rMupRQdBhg38GzuJbpFSl9A85ovWkBXRLF2n6IyGyJGp
 bJgEKRu6M7S3Gg0lVLRXVVxVqAiMV2e0B7Yf1ffd/5vYycbkP72ZhJfKPbgcE6naWGIQ0AfIb
 knBd7KxhSTqEzIqTmZHqEkcCCE1Dgi+nOwzsFLvscM3O+jFT5L2AmciwWsOpRu+3uHtNK9hE+
 XvNiERzJYepOaCk7SVXbgLA3YkBGb2oVqxjnbiNtnmi0DLseUBsuygwR2LeGSruPcjvV1j4Jk
 2AO/D9NyX0UEpYdKXmg8ki0/N8pfdEzLezVc+hATYQ/Kj6gAn+uol7nRpHKzgaFKri5e98hce
 oBX07m2UVBxgVuJNLrXCYYx/qLrewR8R5SSxaVNmjuv5SBDjFt1ZjpuocmHPNPzLqedINavQw
 ZHa1+B/i4so5uBmRR2P+xykrXvdaZoPpSIFGJp1bVMbLzl+9oNKv3fyzO4D3QN1ClVpJx2mZr
 u1erPP0OiCtf8yAPsWfI2hGTJnkOKyvFWqlMVUiMGt9mxmItPlpCLZgTwQ67tvgcmtYfztF
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

