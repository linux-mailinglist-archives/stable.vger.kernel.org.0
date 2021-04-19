Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA843643FD
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240028AbhDSNXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241181AbhDSNVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:21:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11C7B61400;
        Mon, 19 Apr 2021 13:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838280;
        bh=/Z6OCQUFL7u5EhYaxMUNJuVhH7l50zWkWy04jj07uMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7L2aIsCk0EaIZMWkmhKhWl8udihSSydYOxXj0w4viZDylpVjnym56Vfu1F0ENMD7
         VzCDizJBq66LuAxY2HtNla+UolVRxIo2zfbXWtCJ8W/PdKp10nyJP5Ojpu1fdZ4k9T
         YHrEngD0hvR1C1ZGlS9btXzTSmeC70k4EeDsi/EM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 081/103] ch_ktls: Fix kernel panic
Date:   Mon, 19 Apr 2021 15:06:32 +0200
Message-Id: <20210419130530.582556602@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

commit 1a73e427b824133940c2dd95ebe26b6dce1cbf10 upstream.

Taking page refcount is not ideal and causes kernel panic
sometimes. It's better to take tx_ctx lock for the complete
skb transmit, to avoid page cleanup if ACK received in middle.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c |   24 ++--------
 1 file changed, 5 insertions(+), 19 deletions(-)

--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -2015,12 +2015,11 @@ static int chcr_ktls_xmit(struct sk_buff
 	 * we will send the complete record again.
 	 */
 
+	spin_lock_irqsave(&tx_ctx->base.lock, flags);
+
 	do {
-		int i;
 
 		cxgb4_reclaim_completed_tx(adap, &q->q, true);
-		/* lock taken */
-		spin_lock_irqsave(&tx_ctx->base.lock, flags);
 		/* fetch the tls record */
 		record = tls_get_record(&tx_ctx->base, tcp_seq,
 					&tx_info->record_no);
@@ -2079,11 +2078,11 @@ static int chcr_ktls_xmit(struct sk_buff
 						    tls_end_offset, skb_offset,
 						    0);
 
-			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
 			if (ret) {
 				/* free the refcount taken earlier */
 				if (tls_end_offset < data_len)
 					dev_kfree_skb_any(skb);
+				spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
 				goto out;
 			}
 
@@ -2093,16 +2092,6 @@ static int chcr_ktls_xmit(struct sk_buff
 			continue;
 		}
 
-		/* increase page reference count of the record, so that there
-		 * won't be any chance of page free in middle if in case stack
-		 * receives ACK and try to delete the record.
-		 */
-		for (i = 0; i < record->num_frags; i++)
-			__skb_frag_ref(&record->frags[i]);
-		/* lock cleared */
-		spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
-
-
 		/* if a tls record is finishing in this SKB */
 		if (tls_end_offset <= data_len) {
 			ret = chcr_end_part_handler(tx_info, skb, record,
@@ -2127,13 +2116,9 @@ static int chcr_ktls_xmit(struct sk_buff
 			data_len = 0;
 		}
 
-		/* clear the frag ref count which increased locally before */
-		for (i = 0; i < record->num_frags; i++) {
-			/* clear the frag ref count */
-			__skb_frag_unref(&record->frags[i]);
-		}
 		/* if any failure, come out from the loop. */
 		if (ret) {
+			spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
 			if (th->fin)
 				dev_kfree_skb_any(skb);
 
@@ -2148,6 +2133,7 @@ static int chcr_ktls_xmit(struct sk_buff
 
 	} while (data_len > 0);
 
+	spin_unlock_irqrestore(&tx_ctx->base.lock, flags);
 	atomic64_inc(&port_stats->ktls_tx_encrypted_packets);
 	atomic64_add(skb_data_len, &port_stats->ktls_tx_encrypted_bytes);
 


