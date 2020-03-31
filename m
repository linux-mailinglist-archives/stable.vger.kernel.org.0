Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B57791990FC
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbgCaJQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731946AbgCaJQO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:16:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A0EA20675;
        Tue, 31 Mar 2020 09:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646172;
        bh=pCcuB+pWkl42Rhm34auNydPrvo+nVOHuntQjPPkv8N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pHqCHqDZu5qcdznYGUt03rYA5ujbcKD3Blq7Td1IcAbKmSRtxe7wDNy4J8RJRaSM
         J/2yXg9PARHtqOBCoygXylNJS1zv4JRTDzTPzbV49L1hpurM/1VwY69u6Y7xC/ojBn
         Hnb8ZWzYGYxa5PqrEZ4I4SQnNtsehEova+n+HSYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/155] s390/qeth: handle error when backing RX buffer
Date:   Tue, 31 Mar 2020 10:58:27 +0200
Message-Id: <20200331085425.945450047@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 17413852804d7e86e6f0576cca32c1541817800e ]

qeth_init_qdio_queues() fills the RX ring with an initial set of
RX buffers. If qeth_init_input_buffer() fails to back one of the RX
buffers with memory, we need to bail out and report the error.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index ac8ad951a4203..fe70e9875bde0 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2633,12 +2633,12 @@ static int qeth_init_input_buffer(struct qeth_card *card,
 		buf->rx_skb = netdev_alloc_skb(card->dev,
 					       QETH_RX_PULL_LEN + ETH_HLEN);
 		if (!buf->rx_skb)
-			return 1;
+			return -ENOMEM;
 	}
 
 	pool_entry = qeth_find_free_buffer_pool_entry(card);
 	if (!pool_entry)
-		return 1;
+		return -ENOBUFS;
 
 	/*
 	 * since the buffer is accessed only from the input_tasklet
@@ -2670,10 +2670,15 @@ int qeth_init_qdio_queues(struct qeth_card *card)
 	/* inbound queue */
 	qdio_reset_buffers(card->qdio.in_q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q);
 	memset(&card->rx, 0, sizeof(struct qeth_rx));
+
 	qeth_initialize_working_pool_list(card);
 	/*give only as many buffers to hardware as we have buffer pool entries*/
-	for (i = 0; i < card->qdio.in_buf_pool.buf_count - 1; ++i)
-		qeth_init_input_buffer(card, &card->qdio.in_q->bufs[i]);
+	for (i = 0; i < card->qdio.in_buf_pool.buf_count - 1; i++) {
+		rc = qeth_init_input_buffer(card, &card->qdio.in_q->bufs[i]);
+		if (rc)
+			return rc;
+	}
+
 	card->qdio.in_q->next_buf_to_init =
 		card->qdio.in_buf_pool.buf_count - 1;
 	rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT, 0, 0,
-- 
2.20.1



