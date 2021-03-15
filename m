Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24C833B710
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhCON72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232312AbhCON6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9095C64F34;
        Mon, 15 Mar 2021 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816702;
        bh=FYEib7Qc+zd8XyDPJDqStoS8FTLRRMIFWhsDCCF4Tas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k55v7vSQGyc8oRYahDCJxa4zAmHmjaVMFSIdsQVUWolx+Wnjfwak2WHXcQr289uK5
         9ZhBclTQNNvyMi+ENJ7NnIJL9pEiXcMdlV2T69Q++csVxlZ3iRvNAbw7B0xsudc6lY
         NkKMABdlBRKkaRMCL57m9FLmS9dqZmHyyXlIYwIU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 074/306] s390/qeth: schedule TX NAPI on QAOB completion
Date:   Mon, 15 Mar 2021 14:52:17 +0100
Message-Id: <20210315135510.147889280@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Julian Wiedmann <jwi@linux.ibm.com>

commit 3e83d467a08e25b27c44c885f511624a71c84f7c upstream.

When a QAOB notifies us that a pending TX buffer has been delivered, the
actual TX completion processing by qeth_tx_complete_pending_bufs()
is done within the context of a TX NAPI instance. We shouldn't rely on
this instance being scheduled by some other TX event, but just do it
ourselves.

qeth_qdio_handle_aob() is called from qeth_poll(), ie. our main NAPI
instance. To avoid touching the TX queue's NAPI instance
before/after it is (un-)registered, reorder the code in qeth_open()
and qeth_stop() accordingly.

Fixes: 0da9581ddb0f ("qeth: exploit asynchronous delivery of storage blocks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_core_main.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -470,6 +470,7 @@ static void qeth_qdio_handle_aob(struct
 	struct qaob *aob;
 	struct qeth_qdio_out_buffer *buffer;
 	enum iucv_tx_notify notification;
+	struct qeth_qdio_out_q *queue;
 	unsigned int i;
 
 	aob = (struct qaob *) phys_to_virt(phys_aob_addr);
@@ -512,7 +513,9 @@ static void qeth_qdio_handle_aob(struct
 			buffer->is_header[i] = 0;
 		}
 
+		queue = buffer->q;
 		atomic_set(&buffer->state, QETH_QDIO_BUF_EMPTY);
+		napi_schedule(&queue->napi);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -7225,9 +7228,7 @@ int qeth_open(struct net_device *dev)
 	card->data.state = CH_STATE_UP;
 	netif_tx_start_all_queues(dev);
 
-	napi_enable(&card->napi);
 	local_bh_disable();
-	napi_schedule(&card->napi);
 	if (IS_IQD(card)) {
 		struct qeth_qdio_out_q *queue;
 		unsigned int i;
@@ -7239,8 +7240,12 @@ int qeth_open(struct net_device *dev)
 			napi_schedule(&queue->napi);
 		}
 	}
+
+	napi_enable(&card->napi);
+	napi_schedule(&card->napi);
 	/* kick-start the NAPI softirq: */
 	local_bh_enable();
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qeth_open);
@@ -7250,6 +7255,11 @@ int qeth_stop(struct net_device *dev)
 	struct qeth_card *card = dev->ml_priv;
 
 	QETH_CARD_TEXT(card, 4, "qethstop");
+
+	napi_disable(&card->napi);
+	cancel_delayed_work_sync(&card->buffer_reclaim_work);
+	qdio_stop_irq(CARD_DDEV(card));
+
 	if (IS_IQD(card)) {
 		struct qeth_qdio_out_q *queue;
 		unsigned int i;
@@ -7270,10 +7280,6 @@ int qeth_stop(struct net_device *dev)
 		netif_tx_disable(dev);
 	}
 
-	napi_disable(&card->napi);
-	cancel_delayed_work_sync(&card->buffer_reclaim_work);
-	qdio_stop_irq(CARD_DDEV(card));
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qeth_stop);


