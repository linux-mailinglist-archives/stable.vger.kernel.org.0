Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E43F4416CF
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhKAJaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232836AbhKAJ2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:28:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9040661167;
        Mon,  1 Nov 2021 09:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758560;
        bh=2cybuqC6d8IWv2/TAWzQQHVLDcpqRg6KvUfIRgfDyJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCHYtc3a8oaYTWsF1lcV23fMaGyKpxgUPxIYv4QqUh6sOlQ1qxgnFPJ8CGo9uSDRg
         yUmHbwn+GLFtSuUuTDLHbdYJecdLTPnZqG44nYZFwBnvsiJA13MEurBHMEWUR1sccW
         LrVroRMJQvXKFgi1LlEN1eD3GjOQVWxDY4BVS9Y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 14/51] net/tls: Fix flipped sign in tls_err_abort() calls
Date:   Mon,  1 Nov 2021 10:17:18 +0100
Message-Id: <20211101082503.950349367@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit da353fac65fede6b8b4cfe207f0d9408e3121105 upstream.

sk->sk_err appears to expect a positive value, a convention that ktls
doesn't always follow and that leads to memory corruption in other code.
For instance,

    [kworker]
    tls_encrypt_done(..., err=<negative error from crypto request>)
      tls_err_abort(.., err)
        sk->sk_err = err;

    [task]
    splice_from_pipe_feed
      ...
        tls_sw_do_sendpage
          if (sk->sk_err) {
            ret = -sk->sk_err;  // ret is positive

    splice_from_pipe_feed (continued)
      ret = actor(...)  // ret is still positive and interpreted as bytes
                        // written, resulting in underflow of buf->len and
                        // sd->len, leading to huge buf->offset and bogus
                        // addresses computed in later calls to actor()

Fix all tls_err_abort() callers to pass a negative error code
consistently and centralize the error-prone sign flip there, throwing in
a warning to catch future misuse and uninlining the function so it
really does only warn once.

Cc: stable@vger.kernel.org
Fixes: c46234ebb4d1e ("tls: RX path for ktls")
Reported-by: syzbot+b187b77c8474f9648fae@syzkaller.appspotmail.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h |    9 ++-------
 net/tls/tls_sw.c  |   17 +++++++++++++----
 2 files changed, 15 insertions(+), 11 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -360,6 +360,7 @@ int tls_sk_query(struct sock *sk, int op
 		int __user *optlen);
 int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
 		  unsigned int optlen);
+void tls_err_abort(struct sock *sk, int err);
 
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
@@ -465,12 +466,6 @@ static inline bool tls_is_sk_tx_device_o
 #endif
 }
 
-static inline void tls_err_abort(struct sock *sk, int err)
-{
-	sk->sk_err = err;
-	sk->sk_error_report(sk);
-}
-
 static inline bool tls_bigint_increment(unsigned char *seq, int len)
 {
 	int i;
@@ -499,7 +494,7 @@ static inline void tls_advance_record_sn
 					 struct cipher_context *ctx)
 {
 	if (tls_bigint_increment(ctx->rec_seq, prot->rec_seq_size))
-		tls_err_abort(sk, EBADMSG);
+		tls_err_abort(sk, -EBADMSG);
 
 	if (prot->version != TLS_1_3_VERSION)
 		tls_bigint_increment(ctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -35,6 +35,7 @@
  * SOFTWARE.
  */
 
+#include <linux/bug.h>
 #include <linux/sched/signal.h>
 #include <linux/module.h>
 #include <linux/splice.h>
@@ -43,6 +44,14 @@
 #include <net/strparser.h>
 #include <net/tls.h>
 
+noinline void tls_err_abort(struct sock *sk, int err)
+{
+	WARN_ON_ONCE(err >= 0);
+	/* sk->sk_err should contain a positive error code. */
+	sk->sk_err = -err;
+	sk->sk_error_report(sk);
+}
+
 static int __skb_nsg(struct sk_buff *skb, int offset, int len,
                      unsigned int recursion_level)
 {
@@ -416,7 +425,7 @@ int tls_tx_records(struct sock *sk, int
 
 tx_err:
 	if (rc < 0 && rc != -EAGAIN)
-		tls_err_abort(sk, EBADMSG);
+		tls_err_abort(sk, -EBADMSG);
 
 	return rc;
 }
@@ -761,7 +770,7 @@ static int tls_push_record(struct sock *
 			       msg_pl->sg.size + prot->tail_size, i);
 	if (rc < 0) {
 		if (rc != -EINPROGRESS) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			if (split) {
 				tls_ctx->pending_open_record_frags = true;
 				tls_merge_open_record(sk, rec, tmp, orig_end);
@@ -1822,7 +1831,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		err = decrypt_skb_update(sk, skb, &msg->msg_iter,
 					 &chunk, &zc, async_capable);
 		if (err < 0 && err != -EINPROGRESS) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
 		}
 
@@ -2002,7 +2011,7 @@ ssize_t tls_sw_splice_read(struct socket
 		}
 
 		if (err < 0) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			goto splice_read_end;
 		}
 		ctx->decrypted = true;


