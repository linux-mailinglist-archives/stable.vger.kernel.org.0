Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC5C43FE94
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 16:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhJ2OmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 10:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhJ2OmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Oct 2021 10:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C093610A0;
        Fri, 29 Oct 2021 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635518376;
        bh=waqtTNOnEq+jNhHt7p9LG6WlkLMUV9k6npGddDvwtrY=;
        h=Subject:To:Cc:From:Date:From;
        b=dIM90vQ1hPsPBRO7c95+hPRaV6ogVy/63iWulQXlpg9POs1pFIcPQjcYq0Vx58OlN
         0dUfkMeXg3SbDtr5sLRKphQnZNULRipvv+KXeuv9W+kAacfian87eVCFxX9FAGcrXL
         xxBRdiOhvv81a14bmf6Q8Amwvfl6pAwqePZIE4I8=
Subject: FAILED: patch "[PATCH] net/tls: Fix flipped sign in tls_err_abort() calls" failed to apply to 4.19-stable tree
To:     daniel.m.jordan@oracle.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 29 Oct 2021 16:39:34 +0200
Message-ID: <163551837423485@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From da353fac65fede6b8b4cfe207f0d9408e3121105 Mon Sep 17 00:00:00 2001
From: Daniel Jordan <daniel.m.jordan@oracle.com>
Date: Wed, 27 Oct 2021 17:59:20 -0400
Subject: [PATCH] net/tls: Fix flipped sign in tls_err_abort() calls

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

diff --git a/include/net/tls.h b/include/net/tls.h
index 01d2e3744393..1fffb206f09f 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -358,6 +358,7 @@ int tls_sk_query(struct sock *sk, int optname, char __user *optval,
 		int __user *optlen);
 int tls_sk_attach(struct sock *sk, int optname, char __user *optval,
 		  unsigned int optlen);
+void tls_err_abort(struct sock *sk, int err);
 
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
@@ -466,12 +467,6 @@ static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
 #endif
 }
 
-static inline void tls_err_abort(struct sock *sk, int err)
-{
-	sk->sk_err = err;
-	sk_error_report(sk);
-}
-
 static inline bool tls_bigint_increment(unsigned char *seq, int len)
 {
 	int i;
@@ -512,7 +507,7 @@ static inline void tls_advance_record_sn(struct sock *sk,
 					 struct cipher_context *ctx)
 {
 	if (tls_bigint_increment(ctx->rec_seq, prot->rec_seq_size))
-		tls_err_abort(sk, EBADMSG);
+		tls_err_abort(sk, -EBADMSG);
 
 	if (prot->version != TLS_1_3_VERSION &&
 	    prot->cipher_type != TLS_CIPHER_CHACHA20_POLY1305)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d5d09bd817b7..1644f8baea19 100644
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
+	sk_error_report(sk);
+}
+
 static int __skb_nsg(struct sk_buff *skb, int offset, int len,
                      unsigned int recursion_level)
 {
@@ -419,7 +428,7 @@ int tls_tx_records(struct sock *sk, int flags)
 
 tx_err:
 	if (rc < 0 && rc != -EAGAIN)
-		tls_err_abort(sk, EBADMSG);
+		tls_err_abort(sk, -EBADMSG);
 
 	return rc;
 }
@@ -763,7 +772,7 @@ static int tls_push_record(struct sock *sk, int flags,
 			       msg_pl->sg.size + prot->tail_size, i);
 	if (rc < 0) {
 		if (rc != -EINPROGRESS) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			if (split) {
 				tls_ctx->pending_open_record_frags = true;
 				tls_merge_open_record(sk, rec, tmp, orig_end);
@@ -1827,7 +1836,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		err = decrypt_skb_update(sk, skb, &msg->msg_iter,
 					 &chunk, &zc, async_capable);
 		if (err < 0 && err != -EINPROGRESS) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			goto recv_end;
 		}
 
@@ -2007,7 +2016,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 		}
 
 		if (err < 0) {
-			tls_err_abort(sk, EBADMSG);
+			tls_err_abort(sk, -EBADMSG);
 			goto splice_read_end;
 		}
 		ctx->decrypted = 1;

