Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C086A4258D6
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 19:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242917AbhJGRH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 13:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242876AbhJGRH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 13:07:26 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF223C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 10:05:31 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o20so21116562wro.3
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 10:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yT8BWw98ne1yIpW0t3VtiZPgqDZ4Qjw5d5DaO+/yNOQ=;
        b=IUorRyOk0dd+Kaert/22r0aN31KSoSHhnsn8P5natp8iHIwPOhHO8b5wjp8/uJL8cl
         MSiT1Y+FleQTPuRpuk8Qb/D+ma4a7IOmOVzo3WZcVS/Kr0NfmcuSJuSvLhAE4f5yTt3r
         Kcpw6Clwk3paQnEINoWE/7/ES+7zw7R15zdt3YwErj8SRRSEi07eNxndXYgQV9aBIrae
         lDOS6rhyLXmZJPlVD8/Jit2VzSdhlpS4OUdUtyINl5gqQgkBsQgnXb8/6/j/RvUWXfGa
         jfrYQPt/CPdmPsDwnStrPFKQBLByJn+V6jDbkyUPXhks4y4x2Zj7xF7kUG32lEayBglY
         /VBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yT8BWw98ne1yIpW0t3VtiZPgqDZ4Qjw5d5DaO+/yNOQ=;
        b=HO2uYxxkvuQxDFtkenjZENkdidUNo/tTBe4cK95k3hgLONssq0NxZULi70K2BGJXWW
         YgumXqKX3D6y2UPEwaC993IIbXh4lok4+Oc9NCfr0blQsHIjk5GNDqSi2NDHQQczqso4
         i1e+StFitGowVQl30Z95/gOJgHTFa3u9JO69JFwLxVRw6YD0Wr1n+gO39LcHYtQ4TSHb
         2C+VlM38WNjuVReWQYbYc3zRAHizim5R5YGLMWUtegfS/vFCMctx//QqSxcuD5p6BPa7
         7hbsmVbLKL2sxyQqZJnFEZhtcZSAP8h0VYxBJDpeHFaxJ52UAYhMzOPRc0dTDP0s0f6O
         /1Aw==
X-Gm-Message-State: AOAM533pk27o5IrMHWBwcUPhN/L8mQxvN+ab+ZlIIliHR/98TxfdL7h4
        T9SKU87ZSHDgfaU+ujau3om3a9Vy2Fk4eg==
X-Google-Smtp-Source: ABdhPJzfahePWfGmzXgExsI/Qg7la/Ck8bHPKgS/4p/+SCz6JDhVjqp096IQVoSbTfIBFeLO8qwekA==
X-Received: by 2002:a5d:6dce:: with SMTP id d14mr7170718wrz.363.1633626329921;
        Thu, 07 Oct 2021 10:05:29 -0700 (PDT)
Received: from localhost ([2a02:168:96c5:1:55ed:514f:6ad7:5bcc])
        by smtp.gmail.com with ESMTPSA id d7sm228488wrh.13.2021.10.07.10.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 10:05:29 -0700 (PDT)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jann Horn <jannh@google.com>
Subject: [PATCH stable 4.4] af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
Date:   Thu,  7 Oct 2021 19:05:18 +0200
Message-Id: <20211007170518.2587346-1-jannh@google.com>
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
index 1b657a3a30b5..3671bc7b7bc1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -429,8 +429,10 @@ struct sock {
 #if IS_ENABLED(CONFIG_CGROUP_NET_PRIO)
 	__u32			sk_cgrp_prioidx;
 #endif
+	spinlock_t		sk_peer_lock;
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
+
 	long			sk_rcvtimeo;
 	long			sk_sndtimeo;
 	struct timer_list	sk_timer;
diff --git a/net/core/sock.c b/net/core/sock.c
index 82f9a7dbea6f..5e9ff8d9f9e3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1014,7 +1014,6 @@ set_rcvbuf:
 }
 EXPORT_SYMBOL(sock_setsockopt);
=20
-
 static void cred_to_ucred(struct pid *pid, const struct cred *cred,
 			  struct ucred *ucred)
 {
@@ -1174,7 +1173,11 @@ int sock_getsockopt(struct socket *sock, int level, =
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
@@ -1467,9 +1470,10 @@ void sk_destruct(struct sock *sk)
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
@@ -2442,6 +2446,8 @@ void sock_init_data(struct socket *sock, struct sock =
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
index cb9911dcafdb..242d170991b4 100644
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

base-commit: a123b2f4737a9f4e34e92e502972b6388f90133f
--=20
2.33.0.882.g93a45727a2-goog

