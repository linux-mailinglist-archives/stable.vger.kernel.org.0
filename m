Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02CC1B5CDB
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfIRGZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfIRGZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40F4A21920;
        Wed, 18 Sep 2019 06:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787932;
        bh=VuHNiLvCe8DWb60mOj+Qp0dPZ5HLt47rLlkOTRkmYR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYdGR7MV0PA9RVTbljLKzcxgtoh+/bifvRA/NHoRq+bsgLFWU6uJgE0WUU2bWgh4+
         G6Hw9DJwBbpsGZsschom4t5NdFv0jASrNhMjrgaeovFT6waws70MipKxZmd5A290at
         r6QrcBkVAD0qTDQNPrb1/Fx9e8GcOHU8EzoGqwEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Turner <mattst88@gmail.com>,
        Anatoly Pugachev <matorola@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.2 36/85] ipc: fix sparc64 ipc() wrapper
Date:   Wed, 18 Sep 2019 08:18:54 +0200
Message-Id: <20190918061235.288080697@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit fb377eb80c80339b580831a3c0fcce34a4c9d1ad upstream.

Matt bisected a sparc64 specific issue with semctl, shmctl and msgctl
to a commit from my y2038 series in linux-5.1, as I missed the custom
sys_ipc() wrapper that sparc64 uses in place of the generic version that
I patched.

The problem is that the sys_{sem,shm,msg}ctl() functions in the kernel
now do not allow being called with the IPC_64 flag any more, resulting
in a -EINVAL error when they don't recognize the command.

Instead, the correct way to do this now is to call the internal
ksys_old_{sem,shm,msg}ctl() functions to select the API version.

As we generally move towards these functions anyway, change all of
sparc_ipc() to consistently use those in place of the sys_*() versions,
and move the required ksys_*() declarations into linux/syscalls.h

The IS_ENABLED(CONFIG_SYSVIPC) check is required to avoid link
errors when ipc is disabled.

Reported-by: Matt Turner <mattst88@gmail.com>
Fixes: 275f22148e87 ("ipc: rename old-style shmctl/semctl/msgctl syscalls")
Cc: stable@vger.kernel.org
Tested-by: Matt Turner <mattst88@gmail.com>
Tested-by: Anatoly Pugachev <matorola@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/kernel/sys_sparc_64.c |   33 ++++++++++++++++++---------------
 include/linux/syscalls.h         |   19 +++++++++++++++++++
 ipc/util.h                       |   25 ++-----------------------
 3 files changed, 39 insertions(+), 38 deletions(-)

--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -336,25 +336,28 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int,
 {
 	long err;
 
+	if (!IS_ENABLED(CONFIG_SYSVIPC))
+		return -ENOSYS;
+
 	/* No need for backward compatibility. We can start fresh... */
 	if (call <= SEMTIMEDOP) {
 		switch (call) {
 		case SEMOP:
-			err = sys_semtimedop(first, ptr,
-					     (unsigned int)second, NULL);
+			err = ksys_semtimedop(first, ptr,
+					      (unsigned int)second, NULL);
 			goto out;
 		case SEMTIMEDOP:
-			err = sys_semtimedop(first, ptr, (unsigned int)second,
+			err = ksys_semtimedop(first, ptr, (unsigned int)second,
 				(const struct __kernel_timespec __user *)
-					     (unsigned long) fifth);
+					      (unsigned long) fifth);
 			goto out;
 		case SEMGET:
-			err = sys_semget(first, (int)second, (int)third);
+			err = ksys_semget(first, (int)second, (int)third);
 			goto out;
 		case SEMCTL: {
-			err = sys_semctl(first, second,
-					 (int)third | IPC_64,
-					 (unsigned long) ptr);
+			err = ksys_old_semctl(first, second,
+					      (int)third | IPC_64,
+					      (unsigned long) ptr);
 			goto out;
 		}
 		default:
@@ -365,18 +368,18 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int,
 	if (call <= MSGCTL) {
 		switch (call) {
 		case MSGSND:
-			err = sys_msgsnd(first, ptr, (size_t)second,
+			err = ksys_msgsnd(first, ptr, (size_t)second,
 					 (int)third);
 			goto out;
 		case MSGRCV:
-			err = sys_msgrcv(first, ptr, (size_t)second, fifth,
+			err = ksys_msgrcv(first, ptr, (size_t)second, fifth,
 					 (int)third);
 			goto out;
 		case MSGGET:
-			err = sys_msgget((key_t)first, (int)second);
+			err = ksys_msgget((key_t)first, (int)second);
 			goto out;
 		case MSGCTL:
-			err = sys_msgctl(first, (int)second | IPC_64, ptr);
+			err = ksys_old_msgctl(first, (int)second | IPC_64, ptr);
 			goto out;
 		default:
 			err = -ENOSYS;
@@ -396,13 +399,13 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int,
 			goto out;
 		}
 		case SHMDT:
-			err = sys_shmdt(ptr);
+			err = ksys_shmdt(ptr);
 			goto out;
 		case SHMGET:
-			err = sys_shmget(first, (size_t)second, (int)third);
+			err = ksys_shmget(first, (size_t)second, (int)third);
 			goto out;
 		case SHMCTL:
-			err = sys_shmctl(first, (int)second | IPC_64, ptr);
+			err = ksys_old_shmctl(first, (int)second | IPC_64, ptr);
 			goto out;
 		default:
 			err = -ENOSYS;
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1397,4 +1397,23 @@ static inline unsigned int ksys_personal
 	return old;
 }
 
+/* for __ARCH_WANT_SYS_IPC */
+long ksys_semtimedop(int semid, struct sembuf __user *tsops,
+		     unsigned int nsops,
+		     const struct __kernel_timespec __user *timeout);
+long ksys_semget(key_t key, int nsems, int semflg);
+long ksys_old_semctl(int semid, int semnum, int cmd, unsigned long arg);
+long ksys_msgget(key_t key, int msgflg);
+long ksys_old_msgctl(int msqid, int cmd, struct msqid_ds __user *buf);
+long ksys_msgrcv(int msqid, struct msgbuf __user *msgp, size_t msgsz,
+		 long msgtyp, int msgflg);
+long ksys_msgsnd(int msqid, struct msgbuf __user *msgp, size_t msgsz,
+		 int msgflg);
+long ksys_shmget(key_t key, size_t size, int shmflg);
+long ksys_shmdt(char __user *shmaddr);
+long ksys_old_shmctl(int shmid, int cmd, struct shmid_ds __user *buf);
+long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
+			    unsigned int nsops,
+			    const struct old_timespec32 __user *timeout);
+
 #endif
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -276,29 +276,7 @@ static inline int compat_ipc_parse_versi
 	*cmd &= ~IPC_64;
 	return version;
 }
-#endif
-
-/* for __ARCH_WANT_SYS_IPC */
-long ksys_semtimedop(int semid, struct sembuf __user *tsops,
-		     unsigned int nsops,
-		     const struct __kernel_timespec __user *timeout);
-long ksys_semget(key_t key, int nsems, int semflg);
-long ksys_old_semctl(int semid, int semnum, int cmd, unsigned long arg);
-long ksys_msgget(key_t key, int msgflg);
-long ksys_old_msgctl(int msqid, int cmd, struct msqid_ds __user *buf);
-long ksys_msgrcv(int msqid, struct msgbuf __user *msgp, size_t msgsz,
-		 long msgtyp, int msgflg);
-long ksys_msgsnd(int msqid, struct msgbuf __user *msgp, size_t msgsz,
-		 int msgflg);
-long ksys_shmget(key_t key, size_t size, int shmflg);
-long ksys_shmdt(char __user *shmaddr);
-long ksys_old_shmctl(int shmid, int cmd, struct shmid_ds __user *buf);
 
-/* for CONFIG_ARCH_WANT_OLD_COMPAT_IPC */
-long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
-			    unsigned int nsops,
-			    const struct old_timespec32 __user *timeout);
-#ifdef CONFIG_COMPAT
 long compat_ksys_old_semctl(int semid, int semnum, int cmd, int arg);
 long compat_ksys_old_msgctl(int msqid, int cmd, void __user *uptr);
 long compat_ksys_msgrcv(int msqid, compat_uptr_t msgp, compat_ssize_t msgsz,
@@ -306,6 +284,7 @@ long compat_ksys_msgrcv(int msqid, compa
 long compat_ksys_msgsnd(int msqid, compat_uptr_t msgp,
 		       compat_ssize_t msgsz, int msgflg);
 long compat_ksys_old_shmctl(int shmid, int cmd, void __user *uptr);
-#endif /* CONFIG_COMPAT */
+
+#endif
 
 #endif


