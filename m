Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE37E499B93
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376998AbiAXVyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:54:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33356 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378927AbiAXVoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:44:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D176B61574;
        Mon, 24 Jan 2022 21:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D3EC340E4;
        Mon, 24 Jan 2022 21:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060644;
        bh=EjBx6VLc9soLrs83ucHSAMI+i/H49AZLt1t7DcmUv5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qjcw02vLYpzpJFse8CcxgCPB5+vAav3XWy7mAcQUHOaM+bRmNJg9Nq6PrAWtDR/vA
         EvWiQplnt3R32TBHn45bRTaX7qmp72c+3ggXurtLZ++t0WIgZE5WxDQYXRRWuzSfNb
         jk1gX9vV02inD7BztUfpjB5GDDCGldoMcreUPNn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 0973/1039] net: axienet: fix number of TX ring slots for available check
Date:   Mon, 24 Jan 2022 19:46:02 +0100
Message-Id: <20220124184158.001190784@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit aba57a823d2985a2cc8c74a2535f3a88e68d9424 upstream.

The check for the number of available TX ring slots was off by 1 since a
slot is required for the skb header as well as each fragment. This could
result in overwriting a TX ring slot that was still in use.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -747,7 +747,7 @@ axienet_start_xmit(struct sk_buff *skb,
 	num_frag = skb_shinfo(skb)->nr_frags;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
-	if (axienet_check_tx_bd_space(lp, num_frag)) {
+	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
 		if (netif_queue_stopped(ndev))
 			return NETDEV_TX_BUSY;
 
@@ -757,7 +757,7 @@ axienet_start_xmit(struct sk_buff *skb,
 		smp_mb();
 
 		/* Space might have just been freed - check again */
-		if (axienet_check_tx_bd_space(lp, num_frag))
+		if (axienet_check_tx_bd_space(lp, num_frag + 1))
 			return NETDEV_TX_BUSY;
 
 		netif_wake_queue(ndev);


