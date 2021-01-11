Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EC92F15A5
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbhAKNnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731316AbhAKNMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:12:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE53D22795;
        Mon, 11 Jan 2021 13:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370706;
        bh=CYlp0IubFJHrQ+Yfeh+mGQzOj/6wXnEUndV+uBbPNPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AcdKb5fmPb34ZDmFU25JI7f2T8FDJQjsJHnT3u8O5h52c+ZAlNr7I2JEqxL50Na8Y
         ZEeyZsTd2THsJlcDGYLXLXQYFNh2ixhakzIR/PdoEUFLWmHc/ibt1yznBl+xqljl8q
         iumEkIMdUroYdjH+DLpFDoG+61C087M+5oxtjpLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Chulski <stefanc@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 32/92] net: mvpp2: fix pkt coalescing int-threshold configuration
Date:   Mon, 11 Jan 2021 14:01:36 +0100
Message-Id: <20210111130040.692896300@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

[ Upstream commit 4f374d2c43a9e5e773f1dee56db63bd6b8a36276 ]

The packet coalescing interrupt threshold has separated registers
for different aggregated/cpu (sw-thread). The required value should
be loaded for every thread but not only for 1 current cpu.

Fixes: 213f428f5056 ("net: mvpp2: add support for TX interrupts and RX queue distribution modes")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Link: https://lore.kernel.org/r/1608748521-11033-1-git-send-email-stefanc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2161,17 +2161,18 @@ static void mvpp2_rx_pkts_coal_set(struc
 static void mvpp2_tx_pkts_coal_set(struct mvpp2_port *port,
 				   struct mvpp2_tx_queue *txq)
 {
-	unsigned int thread = mvpp2_cpu_to_thread(port->priv, get_cpu());
+	unsigned int thread;
 	u32 val;
 
 	if (txq->done_pkts_coal > MVPP2_TXQ_THRESH_MASK)
 		txq->done_pkts_coal = MVPP2_TXQ_THRESH_MASK;
 
 	val = (txq->done_pkts_coal << MVPP2_TXQ_THRESH_OFFSET);
-	mvpp2_thread_write(port->priv, thread, MVPP2_TXQ_NUM_REG, txq->id);
-	mvpp2_thread_write(port->priv, thread, MVPP2_TXQ_THRESH_REG, val);
-
-	put_cpu();
+	/* PKT-coalescing registers are per-queue + per-thread */
+	for (thread = 0; thread < MVPP2_MAX_THREADS; thread++) {
+		mvpp2_thread_write(port->priv, thread, MVPP2_TXQ_NUM_REG, txq->id);
+		mvpp2_thread_write(port->priv, thread, MVPP2_TXQ_THRESH_REG, val);
+	}
 }
 
 static u32 mvpp2_usec_to_cycles(u32 usec, unsigned long clk_hz)


