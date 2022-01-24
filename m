Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1E549A4F7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2372107AbiAYAKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444932AbiAXVHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:07:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BEAC061A11;
        Mon, 24 Jan 2022 12:07:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44CEB6131F;
        Mon, 24 Jan 2022 20:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C63CC340E5;
        Mon, 24 Jan 2022 20:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054852;
        bh=Yz34gZFrUHF1zddU6TD8TqbiJ7HLufaVp9r91pYmln8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nH24LWsFcWa8MqTDrseuAzQhLB3f2Z5O1iEjO2v7GzpgwXjs++yCDs4uCHVGIOIre
         ZRwQC1oJJ30W/jnPJqUY6+5EA60ME511hHEW7g5QtC4SH/acwsMxLRFt02h89B/iTH
         bmumXL6Skni2PauhOFq1n/iWHN7WerSzgQQmPYqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 524/563] net: axienet: limit minimum TX ring size
Date:   Mon, 24 Jan 2022 19:44:49 +0100
Message-Id: <20220124184042.563314333@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit 70f5817deddbc6ef3faa35841cab83c280cc653a upstream.

The driver will not work properly if the TX ring size is set to below
MAX_SKB_FRAGS + 1 since it needs to hold at least one full maximally
fragmented packet in the TX ring. Limit setting the ring size to below
this value.

Fixes: 8b09ca823ffb4 ("net: axienet: Make RX/TX ring sizes configurable")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -43,6 +43,7 @@
 /* Descriptors defines for Tx and Rx DMA */
 #define TX_BD_NUM_DEFAULT		64
 #define RX_BD_NUM_DEFAULT		1024
+#define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
 #define TX_BD_NUM_MAX			4096
 #define RX_BD_NUM_MAX			4096
 
@@ -1373,7 +1374,8 @@ static int axienet_ethtools_set_ringpara
 	if (ering->rx_pending > RX_BD_NUM_MAX ||
 	    ering->rx_mini_pending ||
 	    ering->rx_jumbo_pending ||
-	    ering->rx_pending > TX_BD_NUM_MAX)
+	    ering->tx_pending < TX_BD_NUM_MIN ||
+	    ering->tx_pending > TX_BD_NUM_MAX)
 		return -EINVAL;
 
 	if (netif_running(ndev))


