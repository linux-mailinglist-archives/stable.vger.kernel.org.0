Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8575AB02D
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbiIBMus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237602AbiIBMtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:49:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078D1E39A5;
        Fri,  2 Sep 2022 05:36:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBB3AB81CCF;
        Fri,  2 Sep 2022 12:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95E0C433D7;
        Fri,  2 Sep 2022 12:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122024;
        bh=NCkrkN/a7jHje8w1I7Ub415KcgGU7rYcKhygD8WxETo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMV6+TkdDbiuoipI13S+kWVn26Zjf1Hhp+Tc4qi8fmrr1CAKmJajdAl72A1NNrJ1I
         bonxs3Kr/axr4kI9mGURpYKeFXuPDiz1v3Drpc/WMQhKUpil+IcwxDjpRBFCEC6DdU
         LmWbEcMIeBawP/nO2Iv9o3edYTtA41Tdvt4ZkvyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Wen Gu <guwen@linux.alibaba.com>,
        Hawkins Jiawei <yin31149@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
Subject: [PATCH 5.15 31/73] net: fix refcount bug in sk_psock_get (2)
Date:   Fri,  2 Sep 2022 14:18:55 +0200
Message-Id: <20220902121405.463164532@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hawkins Jiawei <yin31149@gmail.com>

commit 2a0133723f9ebeb751cfce19f74ec07e108bef1f upstream.

Syzkaller reports refcount bug as follows:
------------[ cut here ]------------
refcount_t: saturated; leaking memory.
WARNING: CPU: 1 PID: 3605 at lib/refcount.c:19 refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
Modules linked in:
CPU: 1 PID: 3605 Comm: syz-executor208 Not tainted 5.18.0-syzkaller-03023-g7e062cda7d90 #0
 <TASK>
 __refcount_add_not_zero include/linux/refcount.h:163 [inline]
 __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
 refcount_inc_not_zero include/linux/refcount.h:245 [inline]
 sk_psock_get+0x3bc/0x410 include/linux/skmsg.h:439
 tls_data_ready+0x6d/0x1b0 net/tls/tls_sw.c:2091
 tcp_data_ready+0x106/0x520 net/ipv4/tcp_input.c:4983
 tcp_data_queue+0x25f2/0x4c90 net/ipv4/tcp_input.c:5057
 tcp_rcv_state_process+0x1774/0x4e80 net/ipv4/tcp_input.c:6659
 tcp_v4_do_rcv+0x339/0x980 net/ipv4/tcp_ipv4.c:1682
 sk_backlog_rcv include/net/sock.h:1061 [inline]
 __release_sock+0x134/0x3b0 net/core/sock.c:2849
 release_sock+0x54/0x1b0 net/core/sock.c:3404
 inet_shutdown+0x1e0/0x430 net/ipv4/af_inet.c:909
 __sys_shutdown_sock net/socket.c:2331 [inline]
 __sys_shutdown_sock net/socket.c:2325 [inline]
 __sys_shutdown+0xf1/0x1b0 net/socket.c:2343
 __do_sys_shutdown net/socket.c:2351 [inline]
 __se_sys_shutdown net/socket.c:2349 [inline]
 __x64_sys_shutdown+0x50/0x70 net/socket.c:2349
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
 </TASK>

During SMC fallback process in connect syscall, kernel will
replaces TCP with SMC. In order to forward wakeup
smc socket waitqueue after fallback, kernel will sets
clcsk->sk_user_data to origin smc socket in
smc_fback_replace_callbacks().

Later, in shutdown syscall, kernel will calls
sk_psock_get(), which treats the clcsk->sk_user_data
as psock type, triggering the refcnt warning.

So, the root cause is that smc and psock, both will use
sk_user_data field. So they will mismatch this field
easily.

This patch solves it by using another bit(defined as
SK_USER_DATA_PSOCK) in PTRMASK, to mark whether
sk_user_data points to a psock object or not.
This patch depends on a PTRMASK introduced in commit f1ff5ce2cd5e
("net, sk_msg: Clear sk_user_data pointer on clone if tagged").

For there will possibly be more flags in the sk_user_data field,
this patch also refactor sk_user_data flags code to be more generic
to improve its maintainability.

Reported-and-tested-by: syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skmsg.h |    3 +-
 include/net/sock.h    |   68 +++++++++++++++++++++++++++++++++++---------------
 net/core/skmsg.c      |    4 ++
 3 files changed, 53 insertions(+), 22 deletions(-)

--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -283,7 +283,8 @@ static inline void sk_msg_sg_copy_clear(
 
 static inline struct sk_psock *sk_psock(const struct sock *sk)
 {
-	return rcu_dereference_sk_user_data(sk);
+	return __rcu_dereference_sk_user_data_with_flags(sk,
+							 SK_USER_DATA_PSOCK);
 }
 
 static inline void sk_psock_set_state(struct sk_psock *psock,
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -543,14 +543,26 @@ enum sk_pacing {
 	SK_PACING_FQ		= 2,
 };
 
-/* Pointer stored in sk_user_data might not be suitable for copying
- * when cloning the socket. For instance, it can point to a reference
- * counted object. sk_user_data bottom bit is set if pointer must not
- * be copied.
+/* flag bits in sk_user_data
+ *
+ * - SK_USER_DATA_NOCOPY:      Pointer stored in sk_user_data might
+ *   not be suitable for copying when cloning the socket. For instance,
+ *   it can point to a reference counted object. sk_user_data bottom
+ *   bit is set if pointer must not be copied.
+ *
+ * - SK_USER_DATA_BPF:         Mark whether sk_user_data field is
+ *   managed/owned by a BPF reuseport array. This bit should be set
+ *   when sk_user_data's sk is added to the bpf's reuseport_array.
+ *
+ * - SK_USER_DATA_PSOCK:       Mark whether pointer stored in
+ *   sk_user_data points to psock type. This bit should be set
+ *   when sk_user_data is assigned to a psock object.
  */
 #define SK_USER_DATA_NOCOPY	1UL
-#define SK_USER_DATA_BPF	2UL	/* Managed by BPF */
-#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF)
+#define SK_USER_DATA_BPF	2UL
+#define SK_USER_DATA_PSOCK	4UL
+#define SK_USER_DATA_PTRMASK	~(SK_USER_DATA_NOCOPY | SK_USER_DATA_BPF |\
+				  SK_USER_DATA_PSOCK)
 
 /**
  * sk_user_data_is_nocopy - Test if sk_user_data pointer must not be copied
@@ -563,24 +575,40 @@ static inline bool sk_user_data_is_nocop
 
 #define __sk_user_data(sk) ((*((void __rcu **)&(sk)->sk_user_data)))
 
+/**
+ * __rcu_dereference_sk_user_data_with_flags - return the pointer
+ * only if argument flags all has been set in sk_user_data. Otherwise
+ * return NULL
+ *
+ * @sk: socket
+ * @flags: flag bits
+ */
+static inline void *
+__rcu_dereference_sk_user_data_with_flags(const struct sock *sk,
+					  uintptr_t flags)
+{
+	uintptr_t sk_user_data = (uintptr_t)rcu_dereference(__sk_user_data(sk));
+
+	WARN_ON_ONCE(flags & SK_USER_DATA_PTRMASK);
+
+	if ((sk_user_data & flags) == flags)
+		return (void *)(sk_user_data & SK_USER_DATA_PTRMASK);
+	return NULL;
+}
+
 #define rcu_dereference_sk_user_data(sk)				\
+	__rcu_dereference_sk_user_data_with_flags(sk, 0)
+#define __rcu_assign_sk_user_data_with_flags(sk, ptr, flags)		\
 ({									\
-	void *__tmp = rcu_dereference(__sk_user_data((sk)));		\
-	(void *)((uintptr_t)__tmp & SK_USER_DATA_PTRMASK);		\
-})
-#define rcu_assign_sk_user_data(sk, ptr)				\
-({									\
-	uintptr_t __tmp = (uintptr_t)(ptr);				\
-	WARN_ON_ONCE(__tmp & ~SK_USER_DATA_PTRMASK);			\
-	rcu_assign_pointer(__sk_user_data((sk)), __tmp);		\
-})
-#define rcu_assign_sk_user_data_nocopy(sk, ptr)				\
-({									\
-	uintptr_t __tmp = (uintptr_t)(ptr);				\
-	WARN_ON_ONCE(__tmp & ~SK_USER_DATA_PTRMASK);			\
+	uintptr_t __tmp1 = (uintptr_t)(ptr),				\
+		  __tmp2 = (uintptr_t)(flags);				\
+	WARN_ON_ONCE(__tmp1 & ~SK_USER_DATA_PTRMASK);			\
+	WARN_ON_ONCE(__tmp2 & SK_USER_DATA_PTRMASK);			\
 	rcu_assign_pointer(__sk_user_data((sk)),			\
-			   __tmp | SK_USER_DATA_NOCOPY);		\
+			   __tmp1 | __tmp2);				\
 })
+#define rcu_assign_sk_user_data(sk, ptr)				\
+	__rcu_assign_sk_user_data_with_flags(sk, ptr, 0)
 
 /*
  * SK_CAN_REUSE and SK_NO_REUSE on a socket mean that the socket is OK
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -731,7 +731,9 @@ struct sk_psock *sk_psock_init(struct so
 	sk_psock_set_state(psock, SK_PSOCK_TX_ENABLED);
 	refcount_set(&psock->refcnt, 1);
 
-	rcu_assign_sk_user_data_nocopy(sk, psock);
+	__rcu_assign_sk_user_data_with_flags(sk, psock,
+					     SK_USER_DATA_NOCOPY |
+					     SK_USER_DATA_PSOCK);
 	sock_hold(sk);
 
 out:


