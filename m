Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C4E4258D7
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 19:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242876AbhJGRHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 13:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242379AbhJGRHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 13:07:34 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905D0C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 10:05:40 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id t2so21149614wrb.8
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 10:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wok8NLQCmfTMW1FRBpt9yU1QLcdKLocWhWkVpKdAgkc=;
        b=XXTiO1Bi2G/Si0yp48ZtEb/PtGpAUmRyHqGS8Ex3aN8nLFGzIobs8ZnIQugF9gYVrY
         HJwFwOjPd4xHTP+cDiOwsaeP+SAMEvGhbpxczszfNcqtIcAn8rNGj633jKTMn9WQHmu5
         JJM4rTu8m8J1RnkGHe0c++/DyctWyEfs9I8Bn1d/en70bPn0sHduAbEustA2H5iFk+No
         HufH0K+0rOZTz0rjHU1E0ht/kLIrXflwCCi93LgPJheDI7SSHAcx050rRQBr4pq+6dNi
         h8zR6xCpUzc5DogxkhILR6NRXtphTLX2EEgbbcku0MSrKHEm8raAWAPr7HiJncVw3490
         YAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wok8NLQCmfTMW1FRBpt9yU1QLcdKLocWhWkVpKdAgkc=;
        b=asQFhqE+ph9D5Yn9MGI0b+Ynf2T5gTLhDVuHk5pNO6ucZqdoWtYZQmDhSbhg62NtpK
         ssGKXl1vjn6kQVWjHM0h3ZpnQjufMXa30ZI0MY4HckgtVshjzSyNbqbs9z9Te03tdSxv
         wQgiegezX3wI3blfYuPifUjs4dgsx94t4oD+jQ774uUUbQ2A7uX78Y4MryYwvPc7vjOu
         zZZIntd9CJjHi+OZT09ZLuMIf9+3ALd5hB1K0mdUP2kOY2MNUT/NKeaT6izEaaBtfC2x
         YLy+OKKglI112Sj8bkwqAB3luzjBHe1psc49TZzx1mCtOAM8ukdZ6Y9nApjx7a3hndxz
         V8lA==
X-Gm-Message-State: AOAM531kT2uqn2l3kycMcMSOv8xrjRkFGnR6zPF3QVqd4OveaxVtES6M
        9iRKOtNAlF0HYvdJmSJNdC2FNjA6X/mRNg==
X-Google-Smtp-Source: ABdhPJzNeEBGTXkkNm2Op/K1wvClEd0RIstsKuEeq6+KO712VMCFxqKdfZall1gu9z7uE1bquVABPQ==
X-Received: by 2002:adf:9b97:: with SMTP id d23mr6798749wrc.135.1633626338837;
        Thu, 07 Oct 2021 10:05:38 -0700 (PDT)
Received: from localhost ([2a02:168:96c5:1:55ed:514f:6ad7:5bcc])
        by smtp.gmail.com with ESMTPSA id f9sm193836wrt.11.2021.10.07.10.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 10:05:38 -0700 (PDT)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jann Horn <jannh@google.com>
Subject: [PATCH stable 4.9] af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
Date:   Thu,  7 Oct 2021 19:05:36 +0200
Message-Id: <20211007170536.2587403-1-jannh@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
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
This could be done by reverting b48596d1dc25 "Bluetooth: L2CAP: Add get_pee=
r_pid callback"
or implementing what was truly expected.

Fixes: 109f6e39fa07 ("af_unix: Allow SO_PEERCRED to work across namespaces.=
")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jann Horn <jannh@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[backport note: 4.4 and 4.9 don't have SO_PEERGROUPS, only SO_PEERCRED]
[backport note: got rid of sk_get_peer_cred(), no users in 4.4/4.9]
Signed-off-by: Jann Horn <jannh@google.com>
---
 include/net/sock.h |  2 ++
 net/core/sock.c    | 12 +++++++++---
 net/unix/af_unix.c | 34 ++++++++++++++++++++++++++++------
 3 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index cf27f3688c39..78c292f15ffc 100644
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
diff --git a/net/core/sock.c b/net/core/sock.c
index d468ffb5a31c..1845a37d9f7e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1011,7 +1011,6 @@ int sock_setsockopt(struct socket *sock, int level, i=
nt optname,
 }
 EXPORT_SYMBOL(sock_setsockopt);
=20
-
 static void cred_to_ucred(struct pid *pid, const struct cred *cred,
 			  struct ucred *ucred)
 {
@@ -1171,7 +1170,11 @@ int sock_getsockopt(struct socket *sock, int level, =
int optname,
 		struct ucred peercred;
 		if (len > sizeof(peercred))
 			len =3D sizeof(peercred);
+
+		spin_lock(&sk->sk_peer_lock);
 		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
+		spin_unlock(&sk->sk_peer_lock);
+
 		if (copy_to_user(optval, &peercred, len))
 			return -EFAULT;
 		goto lenout;
@@ -1439,9 +1442,10 @@ static void __sk_destruct(struct rcu_head *head)
 		sk->sk_frag.page =3D NULL;
 	}
=20
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	/* We do not need to acquire sk->sk_peer_lock, we are the last user. */
+	put_cred(sk->sk_peer_cred);
 	put_pid(sk->sk_peer_pid);
+
 	if (likely(sk->sk_net_refcnt))
 		put_net(sock_net(sk));
 	sk_prot_free(sk->sk_prot_creator, sk);
@@ -2490,6 +2494,8 @@ void sock_init_data(struct socket *sock, struct sock =
*sk)
=20
 	sk->sk_peer_pid 	=3D	NULL;
 	sk->sk_peer_cred	=3D	NULL;
+	spin_lock_init(&sk->sk_peer_lock);
+
 	sk->sk_write_pending	=3D	0;
 	sk->sk_rcvlowat		=3D	1;
 	sk->sk_rcvtimeo		=3D	MAX_SCHEDULE_TIMEOUT;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 2c643e1919aa..e7e012933714 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -594,20 +594,42 @@ static void unix_release_sock(struct sock *sk, int em=
brion)
=20
 static void init_peercred(struct sock *sk)
 {
-	put_pid(sk->sk_peer_pid);
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	spin_lock(&sk->sk_peer_lock);
+	old_pid =3D sk->sk_peer_pid;
+	old_cred =3D sk->sk_peer_cred;
 	sk->sk_peer_pid  =3D get_pid(task_tgid(current));
 	sk->sk_peer_cred =3D get_current_cred();
+	spin_unlock(&sk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
=20
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
+	old_pid =3D sk->sk_peer_pid;
+	old_cred =3D sk->sk_peer_cred;
 	sk->sk_peer_pid  =3D get_pid(peersk->sk_peer_pid);
 	sk->sk_peer_cred =3D get_cred(peersk->sk_peer_cred);
+
+	spin_unlock(&sk->sk_peer_lock);
+	spin_unlock(&peersk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
=20
 static int unix_listen(struct socket *sock, int backlog)

base-commit: af222b7cde477ac2c3f757520bf7e6b7625a380f
--=20
2.33.0.882.g93a45727a2-goog

