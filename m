Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4846749A03D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578083AbiAXXE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382589AbiAXW4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:56:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CABBC055AA5;
        Mon, 24 Jan 2022 13:11:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B42F61469;
        Mon, 24 Jan 2022 21:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEE3C340E5;
        Mon, 24 Jan 2022 21:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058664;
        bh=2BQlgnQsNwEwfMzcRqMA7YHREraPyfZU8xrRYkLHLTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y143LeyqjIO+aQNMWbs3xBKNlT8WooTvoQxFGMfLanofKX0DfidKuOrpYBhCUsV83
         77ycAYuG0EYeS0UluziiosRXDN6v1tR0uLEDOqO0aRXzfWRPyJwRj+YCpBP/mKOHW1
         6uUNbQn8JQwFTnJtS8wrUBadC2ewaLQf/gTmVJiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0362/1039] serial: 8250_bcm7271: Propagate error codes from brcmuart_probe()
Date:   Mon, 24 Jan 2022 19:35:51 +0100
Message-Id: <20220124184137.453861148@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit c195438f1e84de8fa46b4f5264d12379bee6e9a1 ]

In case of failures brcmuart_probe() always returned -ENODEV, this
isn't correct for example platform_get_irq_byname() may return
-EPROBE_DEFER to handle such cases propagate error codes in
brcmuart_probe() in case of failures.

Fixes: 41a469482de25 ("serial: 8250: Add new 8250-core based Broadcom STB driver")
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20211224142917.6966-4-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_bcm7271.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_bcm7271.c b/drivers/tty/serial/8250/8250_bcm7271.c
index 5163d60756b73..0877cf24f7de0 100644
--- a/drivers/tty/serial/8250/8250_bcm7271.c
+++ b/drivers/tty/serial/8250/8250_bcm7271.c
@@ -1076,14 +1076,18 @@ static int brcmuart_probe(struct platform_device *pdev)
 		priv->rx_bufs = dma_alloc_coherent(dev,
 						   priv->rx_size,
 						   &priv->rx_addr, GFP_KERNEL);
-		if (!priv->rx_bufs)
+		if (!priv->rx_bufs) {
+			ret = -EINVAL;
 			goto err;
+		}
 		priv->tx_size = UART_XMIT_SIZE;
 		priv->tx_buf = dma_alloc_coherent(dev,
 						  priv->tx_size,
 						  &priv->tx_addr, GFP_KERNEL);
-		if (!priv->tx_buf)
+		if (!priv->tx_buf) {
+			ret = -EINVAL;
 			goto err;
+		}
 	}
 
 	ret = serial8250_register_8250_port(&up);
@@ -1097,6 +1101,7 @@ static int brcmuart_probe(struct platform_device *pdev)
 	if (priv->dma_enabled) {
 		dma_irq = platform_get_irq_byname(pdev,  "dma");
 		if (dma_irq < 0) {
+			ret = dma_irq;
 			dev_err(dev, "no IRQ resource info\n");
 			goto err1;
 		}
@@ -1116,7 +1121,7 @@ err1:
 err:
 	brcmuart_free_bufs(dev, priv);
 	brcmuart_arbitration(priv, 0);
-	return -ENODEV;
+	return ret;
 }
 
 static int brcmuart_remove(struct platform_device *pdev)
-- 
2.34.1



