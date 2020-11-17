Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DD82B636A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbgKQNiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733020AbgKQNh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77598207BC;
        Tue, 17 Nov 2020 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620278;
        bh=GVkkd3xbSyokIMZbTFu7jGFjPbtezSYtLEbImUcav24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6iSXguyUh1bykmtkvk6RK+mKIYXknQnLlRfjsFAiRO6krzgoOy8cEcv1KVojRZiQ
         Y0n4gS+8LZ/ljV4ynYvcWNz+cUQTN6QrPGmCFGFmWYm0WAtGHKTQvQpOHJImazTMs8
         rrzwDC+4ENW7vqk7R6WG0HhygXs86I4EdRZuuflY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit Maheshwari <rohitm@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 166/255] ch_ktls: tcb update fails sometimes
Date:   Tue, 17 Nov 2020 14:05:06 +0100
Message-Id: <20201117122147.015779525@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>

[ Upstream commit 7d01c428c86b525dc780226924d74df2048cf411 ]

context id and port id should be filled while sending tcb update.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chcr_ktls.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 026689d091102..dc5e22bc64b39 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -659,7 +659,8 @@ int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
 }
 
 static void *__chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
-					u32 tid, void *pos, u16 word, u64 mask,
+					u32 tid, void *pos, u16 word,
+					struct sge_eth_txq *q, u64 mask,
 					u64 val, u32 reply)
 {
 	struct cpl_set_tcb_field_core *cpl;
@@ -668,7 +669,10 @@ static void *__chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
 
 	/* ULP_TXPKT */
 	txpkt = pos;
-	txpkt->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) | ULP_TXPKT_DEST_V(0));
+	txpkt->cmd_dest = htonl(ULPTX_CMD_V(ULP_TX_PKT) |
+				ULP_TXPKT_CHANNELID_V(tx_info->port_id) |
+				ULP_TXPKT_FID_V(q->q.cntxt_id) |
+				ULP_TXPKT_RO_F);
 	txpkt->len = htonl(DIV_ROUND_UP(CHCR_SET_TCB_FIELD_LEN, 16));
 
 	/* ULPTX_IDATA sub-command */
@@ -723,7 +727,7 @@ static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
 		} else {
 			u8 buf[48] = {0};
 
-			__chcr_write_cpl_set_tcb_ulp(tx_info, tid, buf, word,
+			__chcr_write_cpl_set_tcb_ulp(tx_info, tid, buf, word, q,
 						     mask, val, reply);
 
 			return chcr_copy_to_txd(buf, &q->q, pos,
@@ -731,7 +735,7 @@ static void *chcr_write_cpl_set_tcb_ulp(struct chcr_ktls_info *tx_info,
 		}
 	}
 
-	pos = __chcr_write_cpl_set_tcb_ulp(tx_info, tid, pos, word,
+	pos = __chcr_write_cpl_set_tcb_ulp(tx_info, tid, pos, word, q,
 					   mask, val, reply);
 
 	/* check again if we are at the end of the queue */
-- 
2.27.0



