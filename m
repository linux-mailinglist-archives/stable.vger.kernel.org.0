Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5A01D0E7C
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733108AbgEMKAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387682AbgEMJvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37D4520769;
        Wed, 13 May 2020 09:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363508;
        bh=I2jwnxVXM12FKVcYuCcTAMuuoCTdocvVrL5yu3rWjI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XA7pMBAV46Tvdq+trzNetGPAaTY55J4XWC87iJSMQpSLbu9veSDBFfp0KCPM51fT
         QDPxl0g/w4UQ5oIeEQF+GM8WUWxUdKU9K/B1s878LyxOBerO5OywWRXB/IDedWxmYv
         ViuxEvH7rWIIDxca40meDZLqmsEzjpONTM/+EGUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 013/118] cxgb4: fix EOTID leak when disabling TC-MQPRIO offload
Date:   Wed, 13 May 2020 11:43:52 +0200
Message-Id: <20200513094418.847414141@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 69422a7e5d578aab277091f4ebb7c1b387f3e355 ]

Under heavy load, the EOTID termination FLOWC request fails to get
enqueued to the end of the Tx ring due to lack of credits. This
results in EOTID leak.

When disabling TC-MQPRIO offload, the link is already brought down
to cleanup EOTIDs. So, flush any pending enqueued skbs that can't be
sent outside the wire, to make room for FLOWC request. Also, move the
FLOWC descriptor consumption logic closer to when the FLOWC request is
actually posted to hardware.

Fixes: 0e395b3cb1fb ("cxgb4: add FLOWC based QoS offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c |   39 ++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2202,6 +2202,9 @@ static void ethofld_hard_xmit(struct net
 	if (unlikely(skip_eotx_wr)) {
 		start = (u64 *)wr;
 		eosw_txq->state = next_state;
+		eosw_txq->cred -= wrlen16;
+		eosw_txq->ncompl++;
+		eosw_txq->last_compl = 0;
 		goto write_wr_headers;
 	}
 
@@ -2360,6 +2363,34 @@ netdev_tx_t t4_start_xmit(struct sk_buff
 	return cxgb4_eth_xmit(skb, dev);
 }
 
+static void eosw_txq_flush_pending_skbs(struct sge_eosw_txq *eosw_txq)
+{
+	int pktcount = eosw_txq->pidx - eosw_txq->last_pidx;
+	int pidx = eosw_txq->pidx;
+	struct sk_buff *skb;
+
+	if (!pktcount)
+		return;
+
+	if (pktcount < 0)
+		pktcount += eosw_txq->ndesc;
+
+	while (pktcount--) {
+		pidx--;
+		if (pidx < 0)
+			pidx += eosw_txq->ndesc;
+
+		skb = eosw_txq->desc[pidx].skb;
+		if (skb) {
+			dev_consume_skb_any(skb);
+			eosw_txq->desc[pidx].skb = NULL;
+			eosw_txq->inuse--;
+		}
+	}
+
+	eosw_txq->pidx = eosw_txq->last_pidx + 1;
+}
+
 /**
  * cxgb4_ethofld_send_flowc - Send ETHOFLD flowc request to bind eotid to tc.
  * @dev - netdevice
@@ -2435,9 +2466,11 @@ int cxgb4_ethofld_send_flowc(struct net_
 					    FW_FLOWC_MNEM_EOSTATE_CLOSING :
 					    FW_FLOWC_MNEM_EOSTATE_ESTABLISHED);
 
-	eosw_txq->cred -= len16;
-	eosw_txq->ncompl++;
-	eosw_txq->last_compl = 0;
+	/* Free up any pending skbs to ensure there's room for
+	 * termination FLOWC.
+	 */
+	if (tc == FW_SCHED_CLS_NONE)
+		eosw_txq_flush_pending_skbs(eosw_txq);
 
 	ret = eosw_txq_enqueue(eosw_txq, skb);
 	if (ret) {


