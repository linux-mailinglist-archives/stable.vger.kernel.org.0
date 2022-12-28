Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4C165798A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiL1PCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiL1PCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:02:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15F6E7D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 435BFB81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EB7C433D2;
        Wed, 28 Dec 2022 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239725;
        bh=dJnKCnr+KJel3KkIA9uRHw1fiqj2jlgofhaqxUKk4Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xamnxJlmcCZDIdQ1mBRyTk/2pABlddhgqr57eHEtTGGKxCeVfK+D6NcMzPUms13uX
         j5wcI5svQuBiRmJKMg9+IYCBuZOIIhMvuNRWIcnxT6MqMub+NFuPLu71xNDMLRpri6
         MhdFAFV+yVdiMW0FyGoUZvMBwVmJPoDbwdLvZAvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pengcheng Yang <yangpc@wangsu.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 262/731] bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
Date:   Wed, 28 Dec 2022 15:36:09 +0100
Message-Id: <20221228144304.157958153@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pengcheng Yang <yangpc@wangsu.com>

[ Upstream commit a351d6087bf7d3d8440d58d3bf244ec64b89394a ]

When redirecting, we use sk_msg_to_ingress() to get the BPF_F_INGRESS
flag from the msg->flags. If apply_bytes is used and it is larger than
the current data being processed, sk_psock_msg_verdict() will not be
called when sendmsg() is called again. At this time, the msg->flags is 0,
and we lost the BPF_F_INGRESS flag.

So we need to save the BPF_F_INGRESS flag in sk_psock and use it when
redirection.

Fixes: 8934ce2fd081 ("bpf: sockmap redirect ingress support")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/1669718441-2654-3-git-send-email-yangpc@wangsu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h |  1 +
 include/net/tcp.h     |  4 ++--
 net/core/skmsg.c      |  9 ++++++---
 net/ipv4/tcp_bpf.c    | 11 ++++++-----
 net/tls/tls_sw.c      |  6 ++++--
 5 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index ba015a77238a..6e18ca234f81 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -83,6 +83,7 @@ struct sk_psock {
 	u32				apply_bytes;
 	u32				cork_bytes;
 	u32				eval;
+	bool				redir_ingress; /* undefined if sk_redir is null */
 	struct sk_msg			*cork;
 	struct sk_psock_progs		progs;
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 81ef95dc27ba..fdac6913b6c8 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2243,8 +2243,8 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 #endif /* CONFIG_BPF_SYSCALL */
 
-int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
-			  int flags);
+int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
+			  struct sk_msg *msg, u32 bytes, int flags);
 #endif /* CONFIG_NET_SOCK_MSG */
 
 #if !defined(CONFIG_BPF_SYSCALL) || !defined(CONFIG_NET_SOCK_MSG)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index f562f7e2bdc7..dc9b93d8f0d3 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -880,13 +880,16 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 	ret = sk_psock_map_verd(ret, msg->sk_redir);
 	psock->apply_bytes = msg->apply_bytes;
 	if (ret == __SK_REDIRECT) {
-		if (psock->sk_redir)
+		if (psock->sk_redir) {
 			sock_put(psock->sk_redir);
-		psock->sk_redir = msg->sk_redir;
-		if (!psock->sk_redir) {
+			psock->sk_redir = NULL;
+		}
+		if (!msg->sk_redir) {
 			ret = __SK_DROP;
 			goto out;
 		}
+		psock->redir_ingress = sk_msg_to_ingress(msg);
+		psock->sk_redir = msg->sk_redir;
 		sock_hold(psock->sk_redir);
 	}
 out:
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index a38db402994d..2db868ca32af 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -131,10 +131,9 @@ static int tcp_bpf_push_locked(struct sock *sk, struct sk_msg *msg,
 	return ret;
 }
 
-int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
-			  u32 bytes, int flags)
+int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
+			  struct sk_msg *msg, u32 bytes, int flags)
 {
-	bool ingress = sk_msg_to_ingress(msg);
 	struct sk_psock *psock = sk_psock_get(sk);
 	int ret;
 
@@ -277,7 +276,7 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 				struct sk_msg *msg, int *copied, int flags)
 {
-	bool cork = false, enospc = sk_msg_full(msg);
+	bool cork = false, enospc = sk_msg_full(msg), redir_ingress;
 	struct sock *sk_redir;
 	u32 tosend, origsize, sent, delta = 0;
 	u32 eval;
@@ -323,6 +322,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		sk_msg_apply_bytes(psock, tosend);
 		break;
 	case __SK_REDIRECT:
+		redir_ingress = psock->redir_ingress;
 		sk_redir = psock->sk_redir;
 		sk_msg_apply_bytes(psock, tosend);
 		if (!psock->apply_bytes) {
@@ -339,7 +339,8 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		release_sock(sk);
 
 		origsize = msg->sg.size;
-		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
+		ret = tcp_bpf_sendmsg_redir(sk_redir, redir_ingress,
+					    msg, tosend, flags);
 		sent = origsize - msg->sg.size;
 
 		if (eval == __SK_REDIRECT)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 794ef3b3d7d4..c0fea678abb1 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -801,7 +801,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	struct sk_psock *psock;
 	struct sock *sk_redir;
 	struct tls_rec *rec;
-	bool enospc, policy;
+	bool enospc, policy, redir_ingress;
 	int err = 0, send;
 	u32 delta = 0;
 
@@ -846,6 +846,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 		}
 		break;
 	case __SK_REDIRECT:
+		redir_ingress = psock->redir_ingress;
 		sk_redir = psock->sk_redir;
 		memcpy(&msg_redir, msg, sizeof(*msg));
 		if (msg->apply_bytes < send)
@@ -855,7 +856,8 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 		sk_msg_return_zero(sk, msg, send);
 		msg->sg.size -= send;
 		release_sock(sk);
-		err = tcp_bpf_sendmsg_redir(sk_redir, &msg_redir, send, flags);
+		err = tcp_bpf_sendmsg_redir(sk_redir, redir_ingress,
+					    &msg_redir, send, flags);
 		lock_sock(sk);
 		if (err < 0) {
 			*copied -= sk_msg_free_nocharge(sk, &msg_redir);
-- 
2.35.1



