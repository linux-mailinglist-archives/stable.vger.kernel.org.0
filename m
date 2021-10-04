Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513E4420D45
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhJDNOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:14:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235863AbhJDNLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:11:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DEC46124C;
        Mon,  4 Oct 2021 13:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352666;
        bh=+OiA/3tu8xo/BiQt/++BSVtCTOInzsyAK+mk277wPLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ciCD30AwPR93ZW548SZeSVfxT0KxQqVKsJmU+3R8yELbiH2gz0UIHSN2WZDyIjw2S
         +DF99iolRoT9I+fJQ11u9l+sLCigPLWVrAGitycEoCCR+FRzHgCQcoSC+e5zD11X05
         ex3Fbfjo2EJS0R+zaxkjC3cIpBWBAGnMeOS6UlDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 74/95] af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
Date:   Mon,  4 Oct 2021 14:52:44 +0200
Message-Id: <20211004125035.993218914@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 35306eb23814444bd4021f8a1c3047d3cb0c8b2b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h |  2 ++
 net/core/sock.c    | 32 ++++++++++++++++++++++++++------
 net/unix/af_unix.c | 34 ++++++++++++++++++++++++++++------
 3 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 351749c694ce..75677050c82e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -471,8 +471,10 @@ struct sock {
 	u32			sk_ack_backlog;
 	u32			sk_max_ack_backlog;
 	kuid_t			sk_uid;
+	spinlock_t		sk_peer_lock;
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
+
 	long			sk_rcvtimeo;
 	ktime_t			sk_stamp;
 #if BITS_PER_LONG==32
diff --git a/net/core/sock.c b/net/core/sock.c
index 956af38aa0d6..41a77027a549 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1057,6 +1057,16 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 }
 EXPORT_SYMBOL(sock_setsockopt);
 
+static const struct cred *sk_get_peer_cred(struct sock *sk)
+{
+	const struct cred *cred;
+
+	spin_lock(&sk->sk_peer_lock);
+	cred = get_cred(sk->sk_peer_cred);
+	spin_unlock(&sk->sk_peer_lock);
+
+	return cred;
+}
 
 static void cred_to_ucred(struct pid *pid, const struct cred *cred,
 			  struct ucred *ucred)
@@ -1231,7 +1241,11 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
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
@@ -1239,20 +1253,23 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 
 	case SO_PEERGROUPS:
 	{
+		const struct cred *cred;
 		int ret, n;
 
-		if (!sk->sk_peer_cred)
+		cred = sk_get_peer_cred(sk);
+		if (!cred)
 			return -ENODATA;
 
-		n = sk->sk_peer_cred->group_info->ngroups;
+		n = cred->group_info->ngroups;
 		if (len < n * sizeof(gid_t)) {
 			len = n * sizeof(gid_t);
+			put_cred(cred);
 			return put_user(len, optlen) ? -EFAULT : -ERANGE;
 		}
 		len = n * sizeof(gid_t);
 
-		ret = groups_to_user((gid_t __user *)optval,
-				     sk->sk_peer_cred->group_info);
+		ret = groups_to_user((gid_t __user *)optval, cred->group_info);
+		put_cred(cred);
 		if (ret)
 			return ret;
 		goto lenout;
@@ -1576,9 +1593,10 @@ static void __sk_destruct(struct rcu_head *head)
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
@@ -2826,6 +2844,8 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 	sk->sk_peer_pid 	=	NULL;
 	sk->sk_peer_cred	=	NULL;
+	spin_lock_init(&sk->sk_peer_lock);
+
 	sk->sk_write_pending	=	0;
 	sk->sk_rcvlowat		=	1;
 	sk->sk_rcvtimeo		=	MAX_SCHEDULE_TIMEOUT;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c293a558b0d4..82279dbd2f62 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -600,20 +600,42 @@ static void unix_release_sock(struct sock *sk, int embrion)
 
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
-- 
2.33.0



