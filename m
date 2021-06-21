Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E453AEDB0
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhFUQWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhFUQVG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:21:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46A326128A;
        Mon, 21 Jun 2021 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292331;
        bh=l+y3EfbZGUT0PhyUh4Dy88/m/60AmB8eIKoRxFtmZ1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+KyXH1dx7ZILKRKPHRoBKUoA3Ce85YBlS9KabXGRUXinR0OB2z0GJ94OOVUm1Yr1
         nhkYmPeLFxjO4mKNaJ9fPe4njD7pz9WBP1hJcLKlWfyyjiOy9RDz2O5hgFpb630sp+
         8YtAcFMhCl4pdePfMNbYVyvBCDjXPDBo3+QE8x14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
        syzbot+220c1a29987a9a490903@syzkaller.appspotmail.com,
        syzbot+45199c1b73b4013525cf@syzkaller.appspotmail.com,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 52/90] can: j1939: fix Use-after-Free, hold skb ref while in use
Date:   Mon, 21 Jun 2021 18:15:27 +0200
Message-Id: <20210621154905.911284678@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 2030043e616cab40f510299f09b636285e0a3678 upstream.

This patch fixes a Use-after-Free found by the syzbot.

The problem is that a skb is taken from the per-session skb queue,
without incrementing the ref count. This leads to a Use-after-Free if
the skb is taken concurrently from the session queue due to a CTS.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/r/20210521115720.7533-1-o.rempel@pengutronix.de
Cc: Hillf Danton <hdanton@sina.com>
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: syzbot+220c1a29987a9a490903@syzkaller.appspotmail.com
Reported-by: syzbot+45199c1b73b4013525cf@syzkaller.appspotmail.com
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/transport.c |   54 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 14 deletions(-)

--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -330,6 +330,9 @@ static void j1939_session_skb_drop_old(s
 
 	if ((do_skcb->offset + do_skb->len) < offset_start) {
 		__skb_unlink(do_skb, &session->skb_queue);
+		/* drop ref taken in j1939_session_skb_queue() */
+		skb_unref(do_skb);
+
 		kfree_skb(do_skb);
 	}
 	spin_unlock_irqrestore(&session->skb_queue.lock, flags);
@@ -349,12 +352,13 @@ void j1939_session_skb_queue(struct j193
 
 	skcb->flags |= J1939_ECU_LOCAL_SRC;
 
+	skb_get(skb);
 	skb_queue_tail(&session->skb_queue, skb);
 }
 
 static struct
-sk_buff *j1939_session_skb_find_by_offset(struct j1939_session *session,
-					  unsigned int offset_start)
+sk_buff *j1939_session_skb_get_by_offset(struct j1939_session *session,
+					 unsigned int offset_start)
 {
 	struct j1939_priv *priv = session->priv;
 	struct j1939_sk_buff_cb *do_skcb;
@@ -371,6 +375,10 @@ sk_buff *j1939_session_skb_find_by_offse
 			skb = do_skb;
 		}
 	}
+
+	if (skb)
+		skb_get(skb);
+
 	spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 
 	if (!skb)
@@ -381,12 +389,12 @@ sk_buff *j1939_session_skb_find_by_offse
 	return skb;
 }
 
-static struct sk_buff *j1939_session_skb_find(struct j1939_session *session)
+static struct sk_buff *j1939_session_skb_get(struct j1939_session *session)
 {
 	unsigned int offset_start;
 
 	offset_start = session->pkt.dpo * 7;
-	return j1939_session_skb_find_by_offset(session, offset_start);
+	return j1939_session_skb_get_by_offset(session, offset_start);
 }
 
 /* see if we are receiver
@@ -776,7 +784,7 @@ static int j1939_session_tx_dat(struct j
 	int ret = 0;
 	u8 dat[8];
 
-	se_skb = j1939_session_skb_find_by_offset(session, session->pkt.tx * 7);
+	se_skb = j1939_session_skb_get_by_offset(session, session->pkt.tx * 7);
 	if (!se_skb)
 		return -ENOBUFS;
 
@@ -801,7 +809,8 @@ static int j1939_session_tx_dat(struct j
 			netdev_err_once(priv->ndev,
 					"%s: 0x%p: requested data outside of queued buffer: offset %i, len %i, pkt.tx: %i\n",
 					__func__, session, skcb->offset, se_skb->len , session->pkt.tx);
-			return -EOVERFLOW;
+			ret = -EOVERFLOW;
+			goto out_free;
 		}
 
 		if (!len) {
@@ -835,6 +844,12 @@ static int j1939_session_tx_dat(struct j
 	if (pkt_done)
 		j1939_tp_set_rxtimeout(session, 250);
 
+ out_free:
+	if (ret)
+		kfree_skb(se_skb);
+	else
+		consume_skb(se_skb);
+
 	return ret;
 }
 
@@ -1007,7 +1022,7 @@ static int j1939_xtp_txnext_receiver(str
 static int j1939_simple_txnext(struct j1939_session *session)
 {
 	struct j1939_priv *priv = session->priv;
-	struct sk_buff *se_skb = j1939_session_skb_find(session);
+	struct sk_buff *se_skb = j1939_session_skb_get(session);
 	struct sk_buff *skb;
 	int ret;
 
@@ -1015,8 +1030,10 @@ static int j1939_simple_txnext(struct j1
 		return 0;
 
 	skb = skb_clone(se_skb, GFP_ATOMIC);
-	if (!skb)
-		return -ENOMEM;
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
 
 	can_skb_set_owner(skb, se_skb->sk);
 
@@ -1024,12 +1041,18 @@ static int j1939_simple_txnext(struct j1
 
 	ret = j1939_send_one(priv, skb);
 	if (ret)
-		return ret;
+		goto out_free;
 
 	j1939_sk_errqueue(session, J1939_ERRQUEUE_SCHED);
 	j1939_sk_queue_activate_next(session);
 
-	return 0;
+ out_free:
+	if (ret)
+		kfree_skb(se_skb);
+	else
+		consume_skb(se_skb);
+
+	return ret;
 }
 
 static bool j1939_session_deactivate_locked(struct j1939_session *session)
@@ -1170,9 +1193,10 @@ static void j1939_session_completed(stru
 	struct sk_buff *skb;
 
 	if (!session->transmission) {
-		skb = j1939_session_skb_find(session);
+		skb = j1939_session_skb_get(session);
 		/* distribute among j1939 receivers */
 		j1939_sk_recv(session->priv, skb);
+		consume_skb(skb);
 	}
 
 	j1939_session_deactivate_activate_next(session);
@@ -1744,7 +1768,7 @@ static void j1939_xtp_rx_dat_one(struct
 {
 	struct j1939_priv *priv = session->priv;
 	struct j1939_sk_buff_cb *skcb;
-	struct sk_buff *se_skb;
+	struct sk_buff *se_skb = NULL;
 	const u8 *dat;
 	u8 *tpdat;
 	int offset;
@@ -1786,7 +1810,7 @@ static void j1939_xtp_rx_dat_one(struct
 		goto out_session_cancel;
 	}
 
-	se_skb = j1939_session_skb_find_by_offset(session, packet * 7);
+	se_skb = j1939_session_skb_get_by_offset(session, packet * 7);
 	if (!se_skb) {
 		netdev_warn(priv->ndev, "%s: 0x%p: no skb found\n", __func__,
 			    session);
@@ -1848,11 +1872,13 @@ static void j1939_xtp_rx_dat_one(struct
 		j1939_tp_set_rxtimeout(session, 250);
 	}
 	session->last_cmd = 0xff;
+	consume_skb(se_skb);
 	j1939_session_put(session);
 
 	return;
 
  out_session_cancel:
+	kfree_skb(se_skb);
 	j1939_session_timers_cancel(session);
 	j1939_session_cancel(session, J1939_XTP_ABORT_FAULT);
 	j1939_session_put(session);


