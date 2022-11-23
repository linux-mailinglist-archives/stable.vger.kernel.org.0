Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1226354A1
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbiKWJJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbiKWJJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:09:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE2119026
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:09:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCA2D6185C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C46C433C1;
        Wed, 23 Nov 2022 09:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194544;
        bh=2yUZ0Gp9sgv67cCr2F+XSXvXjP4KLd8KPn60qmdRxRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Ftvw4Q9PB+jrcNS8QBN2XGDrtPXksOjAiQhmpo1H/i6i6W3kE3B2pqo79RIIUxtd
         Pe0fRlfrRHLCcUctW4KkoT7+V8oYlmn1g9sLAcGDWQ5n1XyU9XqQqrxKikJTQPFj11
         +J6R/9LkBR0MQuJcRXXKfIItIL5jwOc82oz85y1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+278279efdd2730dd14bf@syzkaller.appspotmail.com,
        shaozhengchao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [PATCH 4.19 106/114] kcm: close race conditions on sk_receive_queue
Date:   Wed, 23 Nov 2022 09:51:33 +0100
Message-Id: <20221123084555.945680088@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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

From: Cong Wang <cong.wang@bytedance.com>

commit 5121197ecc5db58c07da95eb1ff82b98b121a221 upstream.

sk->sk_receive_queue is protected by skb queue lock, but for KCM
sockets its RX path takes mux->rx_lock to protect more than just
skb queue. However, kcm_recvmsg() still only grabs the skb queue
lock, so race conditions still exist.

We can teach kcm_recvmsg() to grab mux->rx_lock too but this would
introduce a potential performance regression as struct kcm_mux can
be shared by multiple KCM sockets.

So we have to enforce skb queue lock in requeue_rx_msgs() and handle
skb peek case carefully in kcm_wait_data(). Fortunately,
skb_recv_datagram() already handles it nicely and is widely used by
other sockets, we can just switch to skb_recv_datagram() after
getting rid of the unnecessary sock lock in kcm_recvmsg() and
kcm_splice_read(). Side note: SOCK_DONE is not used by KCM sockets,
so it is safe to get rid of this check too.

I ran the original syzbot reproducer for 30 min without seeing any
issue.

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Reported-by: syzbot+278279efdd2730dd14bf@syzkaller.appspotmail.com
Reported-by: shaozhengchao <shaozhengchao@huawei.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/20221114005119.597905-1-xiyou.wangcong@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/kcm/kcmsock.c |   60 +++++++-----------------------------------------------
 1 file changed, 8 insertions(+), 52 deletions(-)

--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -224,7 +224,7 @@ static void requeue_rx_msgs(struct kcm_m
 	struct sk_buff *skb;
 	struct kcm_sock *kcm;
 
-	while ((skb = __skb_dequeue(head))) {
+	while ((skb = skb_dequeue(head))) {
 		/* Reset destructor to avoid calling kcm_rcv_ready */
 		skb->destructor = sock_rfree;
 		skb_orphan(skb);
@@ -1085,53 +1085,18 @@ out_error:
 	return err;
 }
 
-static struct sk_buff *kcm_wait_data(struct sock *sk, int flags,
-				     long timeo, int *err)
-{
-	struct sk_buff *skb;
-
-	while (!(skb = skb_peek(&sk->sk_receive_queue))) {
-		if (sk->sk_err) {
-			*err = sock_error(sk);
-			return NULL;
-		}
-
-		if (sock_flag(sk, SOCK_DONE))
-			return NULL;
-
-		if ((flags & MSG_DONTWAIT) || !timeo) {
-			*err = -EAGAIN;
-			return NULL;
-		}
-
-		sk_wait_data(sk, &timeo, NULL);
-
-		/* Handle signals */
-		if (signal_pending(current)) {
-			*err = sock_intr_errno(timeo);
-			return NULL;
-		}
-	}
-
-	return skb;
-}
-
 static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 		       size_t len, int flags)
 {
+	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
 	int err = 0;
-	long timeo;
 	struct strp_msg *stm;
 	int copied = 0;
 	struct sk_buff *skb;
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		goto out;
 
@@ -1162,14 +1127,11 @@ msg_finished:
 			/* Finished with message */
 			msg->msg_flags |= MSG_EOR;
 			KCM_STATS_INCR(kcm->stats.rx_msgs);
-			skb_unlink(skb, &sk->sk_receive_queue);
-			kfree_skb(skb);
 		}
 	}
 
 out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied ? : err;
 }
 
@@ -1177,9 +1139,9 @@ static ssize_t kcm_splice_read(struct so
 			       struct pipe_inode_info *pipe, size_t len,
 			       unsigned int flags)
 {
+	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
-	long timeo;
 	struct strp_msg *stm;
 	int err = 0;
 	ssize_t copied;
@@ -1187,11 +1149,7 @@ static ssize_t kcm_splice_read(struct so
 
 	/* Only support splice for SOCKSEQPACKET */
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		goto err_out;
 
@@ -1219,13 +1177,11 @@ static ssize_t kcm_splice_read(struct so
 	 * finish reading the message.
 	 */
 
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied;
 
 err_out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return err;
 }
 


