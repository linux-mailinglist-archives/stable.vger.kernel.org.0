Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AED199060
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731699AbgCaJLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731696AbgCaJLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:11:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD44C20675;
        Tue, 31 Mar 2020 09:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645882;
        bh=HeEzbeDHe5YF1KUgv3rzS1HaR+nSqhMKG6IuSXD3plo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIQoa3tj8Cxlrtj+c5lvz82ZYsA8TdJ6HWHMw+iG2uzaUEXbjEUZmJZ25TMQ0Osc9
         ga7/yg2ammPt7ukZYI3/PreWgt3riNW33JBVNS2N2vlreLRH3YeMeJ8+8KFM9+nNm4
         b9XKj3POjz+A87qzqp8Ny7h5bUXos0MUcWC/rAJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 007/155] cxgb4: fix throughput drop during Tx backpressure
Date:   Tue, 31 Mar 2020 10:57:27 +0200
Message-Id: <20200331085419.163290714@linuxfoundation.org>
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

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 7affd80802afb6ca92dba47d768632fbde365241 ]

commit 7c3bebc3d868 ("cxgb4: request the TX CIDX updates to status page")
reverted back to getting Tx CIDX updates via DMA, instead of interrupts,
introduced by commit d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE
doorbell queue timer")

However, it missed reverting back several code changes where Tx CIDX
updates are not explicitly requested during backpressure when using
interrupt mode. These missed changes cause slow recovery during
backpressure because the corresponding interrupt no longer comes and
hence results in Tx throughput drop.

So, revert back these missed code changes, as well, which will allow
explicitly requesting Tx CIDX updates when backpressure happens.
This enables the corresponding interrupt with Tx CIDX update message
to get generated and hence speed up recovery and restore back
throughput.

Fixes: 7c3bebc3d868 ("cxgb4: request the TX CIDX updates to status page")
Fixes: d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE doorbell queue timer")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c |   42 +------------------------------
 1 file changed, 2 insertions(+), 40 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1469,16 +1469,7 @@ out_free:	dev_kfree_skb_any(skb);
 		 * has opened up.
 		 */
 		eth_txq_stop(q);
-
-		/* If we're using the SGE Doorbell Queue Timer facility, we
-		 * don't need to ask the Firmware to send us Egress Queue CIDX
-		 * Updates: the Hardware will do this automatically.  And
-		 * since we send the Ingress Queue CIDX Updates to the
-		 * corresponding Ethernet Response Queue, we'll get them very
-		 * quickly.
-		 */
-		if (!q->dbqt)
-			wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
 	}
 
 	wr = (void *)&q->q.desc[q->q.pidx];
@@ -1792,16 +1783,7 @@ static netdev_tx_t cxgb4_vf_eth_xmit(str
 		 * has opened up.
 		 */
 		eth_txq_stop(txq);
-
-		/* If we're using the SGE Doorbell Queue Timer facility, we
-		 * don't need to ask the Firmware to send us Egress Queue CIDX
-		 * Updates: the Hardware will do this automatically.  And
-		 * since we send the Ingress Queue CIDX Updates to the
-		 * corresponding Ethernet Response Queue, we'll get them very
-		 * quickly.
-		 */
-		if (!txq->dbqt)
-			wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
 	}
 
 	/* Start filling in our Work Request.  Note that we do _not_ handle
@@ -2924,26 +2906,6 @@ static void t4_tx_completion_handler(str
 	}
 
 	txq = &s->ethtxq[pi->first_qset + rspq->idx];
-
-	/* We've got the Hardware Consumer Index Update in the Egress Update
-	 * message.  If we're using the SGE Doorbell Queue Timer mechanism,
-	 * these Egress Update messages will be our sole CIDX Updates we get
-	 * since we don't want to chew up PCIe bandwidth for both Ingress
-	 * Messages and Status Page writes.  However, The code which manages
-	 * reclaiming successfully DMA'ed TX Work Requests uses the CIDX value
-	 * stored in the Status Page at the end of the TX Queue.  It's easiest
-	 * to simply copy the CIDX Update value from the Egress Update message
-	 * to the Status Page.  Also note that no Endian issues need to be
-	 * considered here since both are Big Endian and we're just copying
-	 * bytes consistently ...
-	 */
-	if (txq->dbqt) {
-		struct cpl_sge_egr_update *egr;
-
-		egr = (struct cpl_sge_egr_update *)rsp;
-		WRITE_ONCE(txq->q.stat->cidx, egr->cidx);
-	}
-
 	t4_sge_eth_txq_egress_update(adapter, txq, -1);
 }
 


