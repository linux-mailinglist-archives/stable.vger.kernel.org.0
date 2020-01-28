Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447B114B86E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbgA1OXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:23:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732231AbgA1OX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:23:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2DF824690;
        Tue, 28 Jan 2020 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221408;
        bh=xAXZtDYlOlILeGtjxh9GRlm/T1K2DnWjZ7gl8/6GPJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbtC8NHwMLYnZ+8Mtfp2xBGkPIrDozIb4yqBsg9Oku6aOqKm/ygdOV0eTshH3BeWF
         ir0qZl0pKsuBoKrCbLtYFbtnYmImyIyc9JLJGTUNNWU3AkSYL6HnPpwB0vRfKzOSgw
         gFl6mv7IeItj6zI1eOy7uZAJMZ8wG0vLIeb41Fyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 212/271] llc: fix sk_buff refcounting in llc_conn_state_process()
Date:   Tue, 28 Jan 2020 15:06:01 +0100
Message-Id: <20200128135908.310315429@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 36453c852816f19947ca482a595dffdd2efa4965 ]

If llc_conn_state_process() sees that llc_conn_service() put the skb on
a list, it will drop one fewer references to it.  This is wrong because
the current behavior is that llc_conn_service() never consumes a
reference to the skb.

The code also makes the number of skb references being dropped
conditional on which of ind_prim and cfm_prim are nonzero, yet neither
of these affects how many references are *acquired*.  So there is extra
code that tries to fix this up by sometimes taking another reference.

Remove the unnecessary/broken refcounting logic and instead just add an
skb_get() before the only two places where an extra reference is
actually consumed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/llc/llc_conn.c | 33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
index 2689e95471dc4..1bdbd134bd7a8 100644
--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -64,12 +64,6 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 	struct llc_sock *llc = llc_sk(skb->sk);
 	struct llc_conn_state_ev *ev = llc_conn_ev(skb);
 
-	/*
-	 * We have to hold the skb, because llc_conn_service will kfree it in
-	 * the sending path and we need to look at the skb->cb, where we encode
-	 * llc_conn_state_ev.
-	 */
-	skb_get(skb);
 	ev->ind_prim = ev->cfm_prim = 0;
 	/*
 	 * Send event to state machine
@@ -77,21 +71,12 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 	rc = llc_conn_service(skb->sk, skb);
 	if (unlikely(rc != 0)) {
 		printk(KERN_ERR "%s: llc_conn_service failed\n", __func__);
-		goto out_kfree_skb;
-	}
-
-	if (unlikely(!ev->ind_prim && !ev->cfm_prim)) {
-		/* indicate or confirm not required */
-		if (!skb->next)
-			goto out_kfree_skb;
 		goto out_skb_put;
 	}
 
-	if (unlikely(ev->ind_prim && ev->cfm_prim)) /* Paranoia */
-		skb_get(skb);
-
 	switch (ev->ind_prim) {
 	case LLC_DATA_PRIM:
+		skb_get(skb);
 		llc_save_primitive(sk, skb, LLC_DATA_PRIM);
 		if (unlikely(sock_queue_rcv_skb(sk, skb))) {
 			/*
@@ -108,6 +93,7 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 		 * skb->sk pointing to the newly created struct sock in
 		 * llc_conn_handler. -acme
 		 */
+		skb_get(skb);
 		skb_queue_tail(&sk->sk_receive_queue, skb);
 		sk->sk_state_change(sk);
 		break;
@@ -123,7 +109,6 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 				sk->sk_state_change(sk);
 			}
 		}
-		kfree_skb(skb);
 		sock_put(sk);
 		break;
 	case LLC_RESET_PRIM:
@@ -132,14 +117,11 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 		 * RESET is not being notified to upper layers for now
 		 */
 		printk(KERN_INFO "%s: received a reset ind!\n", __func__);
-		kfree_skb(skb);
 		break;
 	default:
-		if (ev->ind_prim) {
+		if (ev->ind_prim)
 			printk(KERN_INFO "%s: received unknown %d prim!\n",
 				__func__, ev->ind_prim);
-			kfree_skb(skb);
-		}
 		/* No indication */
 		break;
 	}
@@ -181,15 +163,12 @@ int llc_conn_state_process(struct sock *sk, struct sk_buff *skb)
 		printk(KERN_INFO "%s: received a reset conf!\n", __func__);
 		break;
 	default:
-		if (ev->cfm_prim) {
+		if (ev->cfm_prim)
 			printk(KERN_INFO "%s: received unknown %d prim!\n",
 					__func__, ev->cfm_prim);
-			break;
-		}
-		goto out_skb_put; /* No confirmation */
+		/* No confirmation */
+		break;
 	}
-out_kfree_skb:
-	kfree_skb(skb);
 out_skb_put:
 	kfree_skb(skb);
 	return rc;
-- 
2.20.1



