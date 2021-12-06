Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7A4469C9A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359055AbhLFPXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:23:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38822 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355959AbhLFPVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:21:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7C1C6130D;
        Mon,  6 Dec 2021 15:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F04DC341C2;
        Mon,  6 Dec 2021 15:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803900;
        bh=UtOdD7UOwFTTMncBV2kXlv+ctN+w+KR62/wd5b3/AlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXVZOMM8ay8iuaBRNWfFferTAx0hj5xbsfGcdHiyblnqNckX5NWt7evCh7TxSA7/m
         txc1o97dtALeZ1Bc3SK94OQOQgCPCyk3oXg+cpdzTCEoyVmUrC659b8HlY5vj0l66f
         y7tpFBjtI3IiS/i96PBb9zDlGTOaiBuVg54sjyko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Sven Schuchmann <schuchmann@schleissheimer.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 086/130] net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available
Date:   Mon,  6 Dec 2021 15:56:43 +0100
Message-Id: <20211206145602.637100196@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schuchmann <schuchmann@schleissheimer.de>

commit 817b653160db9852d5a0498a31f047e18ce27e5b upstream.

On most systems request for IRQ 0 will fail, phylib will print an error message
and fall back to polling. To fix this set the phydev->irq to PHY_POLL if no IRQ
is available.

Fixes: cc89c323a30e ("lan78xx: Use irq_domain for phy interrupt from USB Int. EP")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sven Schuchmann <schuchmann@schleissheimer.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2128,7 +2128,7 @@ static int lan78xx_phy_init(struct lan78
 	if (dev->domain_data.phyirq > 0)
 		phydev->irq = dev->domain_data.phyirq;
 	else
-		phydev->irq = 0;
+		phydev->irq = PHY_POLL;
 	netdev_dbg(dev->net, "phydev->irq = %d\n", phydev->irq);
 
 	/* set to AUTOMDIX */


