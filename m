Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C907313904
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbfEDK1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbfEDK1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:27:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D19F2084A;
        Sat,  4 May 2019 10:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965629;
        bh=4iZ5vn7MMcFMFNiQ4hMRCFtwJ73/pIg1/xqKHpRP17g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R282dFlUNb+UzMBFDGG27kOewgj5Q+Hm74lPCaWltn/DUgjxXvKWXOVD6YsSESTKg
         ORx7Hacv2YLRUY7Cw7lkuZSWfOZIg/RU0nOy/LunEjVa1boVtWzYko5FeIB9eUAMN5
         YIY0qDx8bDju0ZudgDIKQuiWXn83vvdQrI9h0ipY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xu <yinxu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 12/23] sctp: avoid running the sctp state machine recursively
Date:   Sat,  4 May 2019 12:25:14 +0200
Message-Id: <20190504102451.943074752@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
References: <20190504102451.512405835@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit fbd019737d71e405f86549fd738f81e2ff3dd073 ]

Ying triggered a call trace when doing an asconf testing:

  BUG: scheduling while atomic: swapper/12/0/0x10000100
  Call Trace:
   <IRQ>  [<ffffffffa4375904>] dump_stack+0x19/0x1b
   [<ffffffffa436fcaf>] __schedule_bug+0x64/0x72
   [<ffffffffa437b93a>] __schedule+0x9ba/0xa00
   [<ffffffffa3cd5326>] __cond_resched+0x26/0x30
   [<ffffffffa437bc4a>] _cond_resched+0x3a/0x50
   [<ffffffffa3e22be8>] kmem_cache_alloc_node+0x38/0x200
   [<ffffffffa423512d>] __alloc_skb+0x5d/0x2d0
   [<ffffffffc0995320>] sctp_packet_transmit+0x610/0xa20 [sctp]
   [<ffffffffc098510e>] sctp_outq_flush+0x2ce/0xc00 [sctp]
   [<ffffffffc098646c>] sctp_outq_uncork+0x1c/0x20 [sctp]
   [<ffffffffc0977338>] sctp_cmd_interpreter.isra.22+0xc8/0x1460 [sctp]
   [<ffffffffc0976ad1>] sctp_do_sm+0xe1/0x350 [sctp]
   [<ffffffffc099443d>] sctp_primitive_ASCONF+0x3d/0x50 [sctp]
   [<ffffffffc0977384>] sctp_cmd_interpreter.isra.22+0x114/0x1460 [sctp]
   [<ffffffffc0976ad1>] sctp_do_sm+0xe1/0x350 [sctp]
   [<ffffffffc097b3a4>] sctp_assoc_bh_rcv+0xf4/0x1b0 [sctp]
   [<ffffffffc09840f1>] sctp_inq_push+0x51/0x70 [sctp]
   [<ffffffffc099732b>] sctp_rcv+0xa8b/0xbd0 [sctp]

As it shows, the first sctp_do_sm() running under atomic context (NET_RX
softirq) invoked sctp_primitive_ASCONF() that uses GFP_KERNEL flag later,
and this flag is supposed to be used in non-atomic context only. Besides,
sctp_do_sm() was called recursively, which is not expected.

Vlad tried to fix this recursive call in Commit c0786693404c ("sctp: Fix
oops when sending queued ASCONF chunks") by introducing a new command
SCTP_CMD_SEND_NEXT_ASCONF. But it didn't work as this command is still
used in the first sctp_do_sm() call, and sctp_primitive_ASCONF() will
be called in this command again.

To avoid calling sctp_do_sm() recursively, we send the next queued ASCONF
not by sctp_primitive_ASCONF(), but by sctp_sf_do_prm_asconf() in the 1st
sctp_do_sm() directly.

Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sctp/command.h |    1 -
 net/sctp/sm_sideeffect.c   |   29 -----------------------------
 net/sctp/sm_statefuns.c    |   35 +++++++++++++++++++++++++++--------
 3 files changed, 27 insertions(+), 38 deletions(-)

--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -105,7 +105,6 @@ enum sctp_verb {
 	SCTP_CMD_T1_RETRAN,	 /* Mark for retransmission after T1 timeout  */
 	SCTP_CMD_UPDATE_INITTAG, /* Update peer inittag */
 	SCTP_CMD_SEND_MSG,	 /* Send the whole use message */
-	SCTP_CMD_SEND_NEXT_ASCONF, /* Send the next ASCONF after ACK */
 	SCTP_CMD_PURGE_ASCONF_QUEUE, /* Purge all asconf queues.*/
 	SCTP_CMD_SET_ASOC,	 /* Restore association context */
 	SCTP_CMD_LAST
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1112,32 +1112,6 @@ static void sctp_cmd_send_msg(struct sct
 }
 
 
-/* Sent the next ASCONF packet currently stored in the association.
- * This happens after the ASCONF_ACK was succeffully processed.
- */
-static void sctp_cmd_send_asconf(struct sctp_association *asoc)
-{
-	struct net *net = sock_net(asoc->base.sk);
-
-	/* Send the next asconf chunk from the addip chunk
-	 * queue.
-	 */
-	if (!list_empty(&asoc->addip_chunk_list)) {
-		struct list_head *entry = asoc->addip_chunk_list.next;
-		struct sctp_chunk *asconf = list_entry(entry,
-						struct sctp_chunk, list);
-		list_del_init(entry);
-
-		/* Hold the chunk until an ASCONF_ACK is received. */
-		sctp_chunk_hold(asconf);
-		if (sctp_primitive_ASCONF(net, asoc, asconf))
-			sctp_chunk_free(asconf);
-		else
-			asoc->addip_last_asconf = asconf;
-	}
-}
-
-
 /* These three macros allow us to pull the debugging code out of the
  * main flow of sctp_do_sm() to keep attention focused on the real
  * functionality there.
@@ -1783,9 +1757,6 @@ static int sctp_cmd_interpreter(enum sct
 			}
 			sctp_cmd_send_msg(asoc, cmd->obj.msg, gfp);
 			break;
-		case SCTP_CMD_SEND_NEXT_ASCONF:
-			sctp_cmd_send_asconf(asoc);
-			break;
 		case SCTP_CMD_PURGE_ASCONF_QUEUE:
 			sctp_asconf_queue_teardown(asoc);
 			break;
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3824,6 +3824,29 @@ enum sctp_disposition sctp_sf_do_asconf(
 	return SCTP_DISPOSITION_CONSUME;
 }
 
+static enum sctp_disposition sctp_send_next_asconf(
+					struct net *net,
+					const struct sctp_endpoint *ep,
+					struct sctp_association *asoc,
+					const union sctp_subtype type,
+					struct sctp_cmd_seq *commands)
+{
+	struct sctp_chunk *asconf;
+	struct list_head *entry;
+
+	if (list_empty(&asoc->addip_chunk_list))
+		return SCTP_DISPOSITION_CONSUME;
+
+	entry = asoc->addip_chunk_list.next;
+	asconf = list_entry(entry, struct sctp_chunk, list);
+
+	list_del_init(entry);
+	sctp_chunk_hold(asconf);
+	asoc->addip_last_asconf = asconf;
+
+	return sctp_sf_do_prm_asconf(net, ep, asoc, type, asconf, commands);
+}
+
 /*
  * ADDIP Section 4.3 General rules for address manipulation
  * When building TLV parameters for the ASCONF Chunk that will add or
@@ -3915,14 +3938,10 @@ enum sctp_disposition sctp_sf_do_asconf_
 				SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RTO));
 
 		if (!sctp_process_asconf_ack((struct sctp_association *)asoc,
-					     asconf_ack)) {
-			/* Successfully processed ASCONF_ACK.  We can
-			 * release the next asconf if we have one.
-			 */
-			sctp_add_cmd_sf(commands, SCTP_CMD_SEND_NEXT_ASCONF,
-					SCTP_NULL());
-			return SCTP_DISPOSITION_CONSUME;
-		}
+					     asconf_ack))
+			return sctp_send_next_asconf(net, ep,
+					(struct sctp_association *)asoc,
+							type, commands);
 
 		abort = sctp_make_abort(asoc, asconf_ack,
 					sizeof(struct sctp_errhdr));


