Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E92891A502A
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgDKMO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgDKMO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:14:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 078EA20787;
        Sat, 11 Apr 2020 12:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607298;
        bh=jAAXTDtXNw7GX4YyP022FtCivU3zuV/OGlJLKJqnpE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNvOClG77JvgvPQqUHXnbFBdFngsG6X8uBU5nXxchnmABSYSiQEXzwR+bAABbs4Ba
         8rQaT+NGx8jEYr7fzyj4BY7gAPwCGtZ4xAht99v8ENUpgJdccgangRy4M2sKy8D37h
         xkOZxXO9xBWOC8/e0tAVPTIn+suhnxwm25iL6ARE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
Subject: [PATCH 4.19 03/54] sctp: fix refcount bug in sctp_wfree
Date:   Sat, 11 Apr 2020 14:08:45 +0200
Message-Id: <20200411115508.593027768@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

[ Upstream commit 5c3e82fe159622e46e91458c1a6509c321a62820 ]

We should iterate over the datamsgs to move
all chunks(skbs) to newsk.

The following case cause the bug:
for the trouble SKB, it was in outq->transmitted list

sctp_outq_sack
        sctp_check_transmitted
                SKB was moved to outq->sacked list
        then throw away the sack queue
                SKB was deleted from outq->sacked
(but it was held by datamsg at sctp_datamsg_to_asoc
So, sctp_wfree was not called here)

then migrate happened

        sctp_for_each_tx_datachunk(
        sctp_clear_owner_w);
        sctp_assoc_migrate();
        sctp_for_each_tx_datachunk(
        sctp_set_owner_w);
SKB was not in the outq, and was not changed to newsk

finally

__sctp_outq_teardown
        sctp_chunk_put (for another skb)
                sctp_datamsg_put
                        __kfree_skb(msg->frag_list)
                                sctp_wfree (for SKB)
	SKB->sk was still oldsk (skb->sk != asoc->base.sk).

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Acked-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -165,29 +165,44 @@ static void sctp_clear_owner_w(struct sc
 	skb_orphan(chunk->skb);
 }
 
+#define traverse_and_process()	\
+do {				\
+	msg = chunk->msg;	\
+	if (msg == prev_msg)	\
+		continue;	\
+	list_for_each_entry(c, &msg->chunks, frag_list) {	\
+		if ((clear && asoc->base.sk == c->skb->sk) ||	\
+		    (!clear && asoc->base.sk != c->skb->sk))	\
+			cb(c);	\
+	}			\
+	prev_msg = msg;		\
+} while (0)
+
 static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
+				       bool clear,
 				       void (*cb)(struct sctp_chunk *))
 
 {
+	struct sctp_datamsg *msg, *prev_msg = NULL;
 	struct sctp_outq *q = &asoc->outqueue;
+	struct sctp_chunk *chunk, *c;
 	struct sctp_transport *t;
-	struct sctp_chunk *chunk;
 
 	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
 		list_for_each_entry(chunk, &t->transmitted, transmitted_list)
-			cb(chunk);
+			traverse_and_process();
 
 	list_for_each_entry(chunk, &q->retransmit, transmitted_list)
-		cb(chunk);
+		traverse_and_process();
 
 	list_for_each_entry(chunk, &q->sacked, transmitted_list)
-		cb(chunk);
+		traverse_and_process();
 
 	list_for_each_entry(chunk, &q->abandoned, transmitted_list)
-		cb(chunk);
+		traverse_and_process();
 
 	list_for_each_entry(chunk, &q->out_chunk_list, list)
-		cb(chunk);
+		traverse_and_process();
 }
 
 static void sctp_for_each_rx_skb(struct sctp_association *asoc, struct sock *sk,
@@ -8899,9 +8914,9 @@ static void sctp_sock_migrate(struct soc
 	 * paths won't try to lock it and then oldsk.
 	 */
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
-	sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
+	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.


