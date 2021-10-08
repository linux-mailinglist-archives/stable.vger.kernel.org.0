Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285C94268D9
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241112AbhJHLcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240433AbhJHLb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:31:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AC9661073;
        Fri,  8 Oct 2021 11:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692551;
        bh=cVs+LLM6Y3J0hUp/xjiO24L4iC4G7CUWOk7RKQfsBOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vx4TAIBx52rBVoLrzGKTkSjfJw2EReypeNfyDKkOzLWSFainJukiVrTPDmKeR5aS+
         GLBTnTs+afoX45SKjWt0G8cXu2eKrsPAEWYnv80OX4Z7s+Anc8BNmDHQ9cA+tjVahk
         uQ+DH7AiJ1ZoF2HSaVIklvh3fjPjpooCZjWb30AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 1/8] af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
Date:   Fri,  8 Oct 2021 13:27:38 +0200
Message-Id: <20211008112713.989947127@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112713.941269121@linuxfoundation.org>
References: <20211008112713.941269121@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 35306eb23814444bd4021f8a1c3047d3cb0c8b2b upstream.

Jann Horn reported that SO_PEERCRED and SO_PEERGROUPS implementations
are racy, as af_unix can concurrently change sk_peer_pid and sk_peer_cred.

In order to fix this issue, this patch adds a new spinlock that needs
to be used whenever these fields are read or written.

Jann also pointed out that l2cap_sock_get_peer_pid_cb() is currently
reading sk->sk_peer_pid which makes no sense, as this field
is only possibly set by AF_UNIX sockets.
We will have to clean this in a separate patch.
This could be done by reverting b48596d1dc25 "Bluetooth: L2CAP: Add get_peer_pid callback"
or implementing what was truly expected.

Fixes: 109f6e39fa07 ("af_unix: Allow SO_PEERCRED to work across namespaces.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jann Horn <jannh@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[backport note: 4.4 and 4.9 don't have SO_PEERGROUPS, only SO_PEERCRED]
[backport note: got rid of sk_get_peer_cred(), no users in 4.4/4.9]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h |    2 ++
 net/core/sock.c    |   12 +++++++++---
 net/unix/af_unix.c |   34 ++++++++++++++++++++++++++++------
 3 files changed, 39 insertions(+), 9 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -420,8 +420,10 @@ struct sock {
 	u32			sk_max_ack_backlog;
 	__u32			sk_priority;
 	__u32			sk_mark;
+	spinlock_t		sk_peer_lock;
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
+
 	long			sk_rcvtimeo;
 	long			sk_sndtimeo;
 	struct timer_list	sk_timer;
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1011,7 +1011,6 @@ set_rcvbuf:
 }
 EXPORT_SYMBOL(sock_setsockopt);
 
-
 static void cred_to_ucred(struct pid *pid, const struct cred *cred,
 			  struct ucred *ucred)
 {
@@ -1171,7 +1170,11 @@ int sock_getsockopt(struct socket *sock,
 		struct ucred peercred;
 		if (len > sizeof(peercred))
 			len = sizeof(peercred);
+
+		spin_lock(&sk->sk_peer_lock);
 		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
+		spin_unlock(&sk->sk_peer_lock);
+
 		if (copy_to_user(optval, &peercred, len))
 			return -EFAULT;
 		goto lenout;
@@ -1439,9 +1442,10 @@ static void __sk_destruct(struct rcu_hea
 		sk->sk_frag.page = NULL;
 	}
 
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	/* We do not need to acquire sk->sk_peer_lock, we are the last user. */
+	put_cred(sk->sk_peer_cred);
 	put_pid(sk->sk_peer_pid);
+
 	if (likely(sk->sk_net_refcnt))
 		put_net(sock_net(sk));
 	sk_prot_free(sk->sk_prot_creator, sk);
@@ -2490,6 +2494,8 @@ void sock_init_data(struct socket *sock,
 
 	sk->sk_peer_pid 	=	NULL;
 	sk->sk_peer_cred	=	NULL;
+	spin_lock_init(&sk->sk_peer_lock);
+
 	sk->sk_write_pending	=	0;
 	sk->sk_rcvlowat		=	1;
 	sk->sk_rcvtimeo		=	MAX_SCHEDULE_TIMEOUT;
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -594,20 +594,42 @@ static void unix_release_sock(struct soc
 
 static void init_peercred(struct sock *sk)
 {
-	put_pid(sk->sk_peer_pid);
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	spin_lock(&sk->sk_peer_lock);
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
 	sk->sk_peer_pid  = get_pid(task_tgid(current));
 	sk->sk_peer_cred = get_current_cred();
+	spin_unlock(&sk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
 
 static void copy_peercred(struct sock *sk, struct sock *peersk)
 {
-	put_pid(sk->sk_peer_pid);
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	if (sk < peersk) {
+		spin_lock(&sk->sk_peer_lock);
+		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	} else {
+		spin_lock(&peersk->sk_peer_lock);
+		spin_lock_nested(&sk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	}
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
 	sk->sk_peer_pid  = get_pid(peersk->sk_peer_pid);
 	sk->sk_peer_cred = get_cred(peersk->sk_peer_cred);
+
+	spin_unlock(&sk->sk_peer_lock);
+	spin_unlock(&peersk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
 
 static int unix_listen(struct socket *sock, int backlog)


