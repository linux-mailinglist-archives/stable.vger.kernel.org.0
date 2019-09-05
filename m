Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F037AA736
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 17:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388285AbfIEPYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 11:24:07 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:33439 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388090AbfIEPYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 11:24:05 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N3omW-1iErpu38zI-00zlqx; Thu, 05 Sep 2019 17:23:34 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Christian Brauner <christian@brauner.io>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-arch@vger.kernel.org, y2038@lists.linaro.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Matt Turner <mattst88@gmail.com>, stable@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH 2/2] ipc: fix sparc64 ipc() wrapper
Date:   Thu,  5 Sep 2019 17:21:25 +0200
Message-Id: <20190905152155.1392871-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190905152155.1392871-1-arnd@arndb.de>
References: <20190905152155.1392871-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:J3zArHkEyY/TISMmsfP0WbJtNBFechQID0MqECzAk0ctCCZ95pR
 yxgwoT6AqRe9E3cjun1fqcvGxYNu0dhxnJv1n8TiPRO3OsLdyhUfeh5h64xInym/iWECW65
 T3KYK41gn/U20N0+cooujcbryonZ+TM85tiFbXMR/F9+C8N9NhGWEfBNKIlD3ZONOHd8yT8
 j87ugz7kTJtQ6MlGcuqgQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:x/9WiilpczI=:GUB6fhEl40TlKmebyV3VtP
 tQZX3lSk+a5TLFJKCm0hJi5iYixyH1OiciKfQkbQTvimuD44FGQ7U8hsVf5gn8KjbAxbU9iuq
 /ehYRHVo2+xqH3r5XWZEvjuEZoVxeA1HUc2pmC8p+Nj00s111rvzBulzfxNS1gSDhoKPIZ2qz
 cGMmSIc9K8luRJeIcuKCGpHLiZIri2GY2jz9UyjXZ9+QDAkc5GZ2dgiKQesN1M2r9oo5mnLdc
 kmNYWK6nA4JjoLQJXQWlcOK79fIN69hvbvaTjSvw975krZyjihDLmCBKRzRtXvMpw2a+hkO+U
 dCQ9/qDjkmGSJRfCu+zCf1Q5cl9EkK2lNTFGE7G3d0qFVuqwqF7sIUcmHSeZOuZlLOHV3cUSl
 YsKinsjpr45kL9+iQqR7BAFxsWamu/sLMLCYgJkh3Q/bDjCBHEYxReRGzxjPL309IJ+jdAbng
 Q6Axj0jiJbXC74NRsVcPtyeFCz8nr0EYBLYzH9nH+8fkbAgoXz75KfqfkXHLSsKeCAPON3h9z
 upT87m0FvgjNUoJHw5y99hjfAowzQINh7qsDHCvEpt2T13Y+1ypYTm5rV6CHP8c7OJsAC8tjI
 x4OQMcg+4ym3RHKhwTdY8J7QLLtxjxa48Wz7c+ND9PKoXw7Y9tsgXcmFA+RltXE+Gvy+cE5s2
 1TmI+a//nrrYnyRn+D1okiKpl4dJAo9OViaw7Ae+JH5Mw+tsprds18iMpTw+Ba0bdNjbHvcLa
 32I38a7MyVqBoVJ9CpnLLRA1b1aurNA8LNgb5CPjLv7CiQTob84/AH75xl/PHGd5eK/ex9Wid
 yCulJWrgfB9IombsP5qX21Jt/xPM0uvtvYmeLQd6wPrJIqaGJY=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Reported-by: Matt Turner <mattst88@gmail.com>
Fixes: 275f22148e87 ("ipc: rename old-style shmctl/semctl/msgctl syscalls")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Hi Matt,

Can you check that this solves your problem?
---
 arch/sparc/kernel/sys_sparc_64.c | 30 +++++++++++++++---------------
 include/linux/syscalls.h         | 19 +++++++++++++++++++
 ipc/util.h                       | 25 ++-----------------------
 3 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index ccc88926bc00..5ad0494df367 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -340,21 +340,21 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
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
@@ -365,18 +365,18 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
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
@@ -396,13 +396,13 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
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
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 88145da7d140..f7c561c4dcdd 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1402,4 +1402,23 @@ static inline unsigned int ksys_personality(unsigned int personality)
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
diff --git a/ipc/util.h b/ipc/util.h
index 0fcf8e719b76..5766c61aed0e 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -276,29 +276,7 @@ static inline int compat_ipc_parse_version(int *cmd)
 	*cmd &= ~IPC_64;
 	return version;
 }
-#endif
 
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
-
-/* for CONFIG_ARCH_WANT_OLD_COMPAT_IPC */
-long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
-			    unsigned int nsops,
-			    const struct old_timespec32 __user *timeout);
-#ifdef CONFIG_COMPAT
 long compat_ksys_old_semctl(int semid, int semnum, int cmd, int arg);
 long compat_ksys_old_msgctl(int msqid, int cmd, void __user *uptr);
 long compat_ksys_msgrcv(int msqid, compat_uptr_t msgp, compat_ssize_t msgsz,
@@ -306,6 +284,7 @@ long compat_ksys_msgrcv(int msqid, compat_uptr_t msgp, compat_ssize_t msgsz,
 long compat_ksys_msgsnd(int msqid, compat_uptr_t msgp,
 		       compat_ssize_t msgsz, int msgflg);
 long compat_ksys_old_shmctl(int shmid, int cmd, void __user *uptr);
-#endif /* CONFIG_COMPAT */
+
+#endif
 
 #endif
-- 
2.20.0

