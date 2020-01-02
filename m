Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E924812EF30
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgABWd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730247AbgABWd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:33:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C3C20863;
        Thu,  2 Jan 2020 22:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004407;
        bh=RhCCQf6vbMWOz/PzvEA9pf9RgyUz1RetvwxKHW8BPEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fClO2FcxrotAcLFxAj9Dh4kQhBPEaRkjEQVa+PmIETzFykN0S4dHBZMMpxcPTgcnk
         rjH139f+UFsc7hnd1fwQf79li0rRBvzpuz2SX9nyW4zEog/GExigM47a/fCm6gKCNb
         P7OLd9LsOwkeSKdRuezOdE68htwEkiOuqSRShkgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Netanel Belgazal <netanel@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 166/171] net: ena: fix napi handler misbehavior when the napi budget is zero
Date:   Thu,  2 Jan 2020 23:08:17 +0100
Message-Id: <20200102220609.736665065@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Netanel Belgazal <netanel@amazon.com>

[ Upstream commit 24dee0c7478d1a1e00abdf5625b7f921467325dc ]

In netpoll the napi handler could be called with budget equal to zero.
Current ENA napi handler doesn't take that into consideration.

The napi handler handles Rx packets in a do-while loop.
Currently, the budget check happens only after decrementing the
budget, therefore the napi handler, in rare cases, could run over
MAX_INT packets.

In addition to that, this moves all budget related variables to int
calculation and stop mixing u32 to avoid ambiguity

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Netanel Belgazal <netanel@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1105,8 +1105,8 @@ static int ena_io_poll(struct napi_struc
 	struct ena_ring *tx_ring, *rx_ring;
 	struct ena_eth_io_intr_reg intr_reg;
 
-	u32 tx_work_done;
-	u32 rx_work_done;
+	int tx_work_done;
+	int rx_work_done = 0;
 	int tx_budget;
 	int napi_comp_call = 0;
 	int ret;
@@ -1122,7 +1122,11 @@ static int ena_io_poll(struct napi_struc
 	}
 
 	tx_work_done = ena_clean_tx_irq(tx_ring, tx_budget);
-	rx_work_done = ena_clean_rx_irq(rx_ring, napi, budget);
+	/* On netpoll the budget is zero and the handler should only clean the
+	 * tx completions.
+	 */
+	if (likely(budget))
+		rx_work_done = ena_clean_rx_irq(rx_ring, napi, budget);
 
 	if ((budget > rx_work_done) && (tx_budget > tx_work_done)) {
 		napi_complete_done(napi, rx_work_done);


