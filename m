Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF35C499DB2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586096AbiAXWZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584584AbiAXWV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B031C0424E0;
        Mon, 24 Jan 2022 12:51:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06507B810A8;
        Mon, 24 Jan 2022 20:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C71EC340E5;
        Mon, 24 Jan 2022 20:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057485;
        bh=qEjckpQvRmxcTRNa+OgIplbRP5NSdJP2K0D8QWEZUBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSsJxzLf8hFnNqYFF17Y1p3GLL+mSNpX5E3qRJt1QHntxTByb1hHrcGQErsdDshhw
         eQUFPImhb3MHdHvJI95rIC3miEq0F+Lt491gY91lcLCtxcoTu1xZhyjet1gNWpbn3Y
         5MyJn5LM0fFGLHPLkbwyZ87go10uXGiskOCgsmWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 795/846] net: axienet: limit minimum TX ring size
Date:   Mon, 24 Jan 2022 19:45:12 +0100
Message-Id: <20220124184128.378317235@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
 
@@ -1364,7 +1365,8 @@ static int axienet_ethtools_set_ringpara
 	if (ering->rx_pending > RX_BD_NUM_MAX ||
 	    ering->rx_mini_pending ||
 	    ering->rx_jumbo_pending ||
-	    ering->rx_pending > TX_BD_NUM_MAX)
+	    ering->tx_pending < TX_BD_NUM_MIN ||
+	    ering->tx_pending > TX_BD_NUM_MAX)
 		return -EINVAL;
 
 	if (netif_running(ndev))


