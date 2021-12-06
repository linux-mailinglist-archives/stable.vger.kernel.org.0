Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864E9469BE5
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359324AbhLFPRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45912 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350802AbhLFPNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:13:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDEB5B8111B;
        Mon,  6 Dec 2021 15:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3489FC341C2;
        Mon,  6 Dec 2021 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803409;
        bh=UNmQR/ZW6hu9poxes7mAsiMVluYYGlX0okgG5nXiKKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENBx5pIsFoGEGmRiIax7fAhB1temTHQJ97K/OCM3C1asGLLOjyZKhIUZpfRn0xfE6
         YMYGis39Rll9MnZs5kL5JeHsdP8LKyrYiH0brlluD6asQaSuKXh7DttGakOid8RAWL
         RDcdYtvW9WVq/PYiNJb42wp6gGZXn/HpnmwiS2tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Sven Schuchmann <schuchmann@schleissheimer.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 32/48] net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available
Date:   Mon,  6 Dec 2021 15:56:49 +0100
Message-Id: <20211206145549.939737593@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
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
@@ -2152,7 +2152,7 @@ static int lan78xx_phy_init(struct lan78
 	if (dev->domain_data.phyirq > 0)
 		phydev->irq = dev->domain_data.phyirq;
 	else
-		phydev->irq = 0;
+		phydev->irq = PHY_POLL;
 	netdev_dbg(dev->net, "phydev->irq = %d\n", phydev->irq);
 
 	/* set to AUTOMDIX */


