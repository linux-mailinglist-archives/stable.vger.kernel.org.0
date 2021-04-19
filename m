Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2F9364409
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbhDSNZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241357AbhDSNWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:22:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CAB361354;
        Mon, 19 Apr 2021 13:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838288;
        bh=imUZ3C9Sftcex1J+MERKEd8JzO2ZbcZ53DzjncOKK1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNOjAHDYNg1iZuPTtpWssXZr7qIGagTadEf8zwiCS4B+hVL4cBujiPgdO5jDfUDad
         BM1KRuasjKz5OK3pjWy+/x+gNWxGIf8YiP/sn7Un8RZvu2cIYXLA3w6MWnTrzG4kZs
         gNpJup5LHWHdcqsjMXMXJNjOS4uJM/aYp21lPkpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 084/103] ch_ktls: do not send snd_una update to TCB in middle
Date:   Mon, 19 Apr 2021 15:06:35 +0200
Message-Id: <20210419130530.686424234@linuxfoundation.org>
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

commit e8a4155567b3c903f49cbf89b8017e9cc22c4fe4 upstream.

snd_una update should not be done when the same skb is being
sent out.chcr_short_record_handler() sends it again even
though SND_UNA update is already sent for the skb in
chcr_ktls_xmit(), which causes mismatch in un-acked
TCP seq number, later causes problem in sending out
complete record.

Fixes: 429765a149f1 ("chcr: handle partial end part of a record")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c |   53 ----------
 1 file changed, 53 deletions(-)

--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1650,54 +1650,6 @@ static void chcr_ktls_copy_record_in_skb
 }
 
 /*
- * chcr_ktls_update_snd_una:  Reset the SEND_UNA. It will be done to avoid
- * sending the same segment again. It will discard the segment which is before
- * the current tx max.
- * @tx_info - driver specific tls info.
- * @q - TX queue.
- * return: NET_TX_OK/NET_XMIT_DROP.
- */
-static int chcr_ktls_update_snd_una(struct chcr_ktls_info *tx_info,
-				    struct sge_eth_txq *q)
-{
-	struct fw_ulptx_wr *wr;
-	unsigned int ndesc;
-	int credits;
-	void *pos;
-	u32 len;
-
-	len = sizeof(*wr) + roundup(CHCR_SET_TCB_FIELD_LEN, 16);
-	ndesc = DIV_ROUND_UP(len, 64);
-
-	credits = chcr_txq_avail(&q->q) - ndesc;
-	if (unlikely(credits < 0)) {
-		chcr_eth_txq_stop(q);
-		return NETDEV_TX_BUSY;
-	}
-
-	pos = &q->q.desc[q->q.pidx];
-
-	wr = pos;
-	/* ULPTX wr */
-	wr->op_to_compl = htonl(FW_WR_OP_V(FW_ULPTX_WR));
-	wr->cookie = 0;
-	/* fill len in wr field */
-	wr->flowid_len16 = htonl(FW_WR_LEN16_V(DIV_ROUND_UP(len, 16)));
-
-	pos += sizeof(*wr);
-
-	pos = chcr_write_cpl_set_tcb_ulp(tx_info, q, tx_info->tid, pos,
-					 TCB_SND_UNA_RAW_W,
-					 TCB_SND_UNA_RAW_V(TCB_SND_UNA_RAW_M),
-					 TCB_SND_UNA_RAW_V(0), 0);
-
-	chcr_txq_advance(&q->q, ndesc);
-	cxgb4_ring_tx_db(tx_info->adap, &q->q, ndesc);
-
-	return 0;
-}
-
-/*
  * chcr_end_part_handler: This handler will handle the record which
  * is complete or if record's end part is received. T6 adapter has a issue that
  * it can't send out TAG with partial record so if its an end part then we have
@@ -1897,11 +1849,6 @@ static int chcr_short_record_handler(str
 			/* reset tcp_seq as per the prior_data_required len */
 			tcp_seq -= prior_data_len;
 		}
-		/* reset snd una, so the middle record won't send the already
-		 * sent part.
-		 */
-		if (chcr_ktls_update_snd_una(tx_info, q))
-			goto out;
 		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_middle_pkts);
 	} else {
 		atomic64_inc(&tx_info->adap->ch_ktls_stats.ktls_tx_start_pkts);


