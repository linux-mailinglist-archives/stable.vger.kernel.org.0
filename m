Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED5D3A63C1
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbhFNLQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235662AbhFNLOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:14:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD1086195F;
        Mon, 14 Jun 2021 10:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667767;
        bh=9DsQAlrXIIkKDZkN+WHC7MUMFp4igyRwhLat0llSGY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2a+nf3zCtYQeXiQHvRL4lnGAbs2bQgWj1Z5kMLx9R1KGy+fxdhb4Et2Y1XbL1YUfK
         Ym7VaOJ8P9K0ucCTh/m8A9to4aIGhAxpMTtbbmSUAduuK3smPGqaoNfGEOsuMCkhtV
         YBf12krsfiCdTPoNDfHLHji4pIFpzhfveR6GIk0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saubhik Mukherjee <saubhik.mukherjee@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 033/173] net: appletalk: cops: Fix data race in cops_probe1
Date:   Mon, 14 Jun 2021 12:26:05 +0200
Message-Id: <20210614102659.245682967@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saubhik Mukherjee <saubhik.mukherjee@gmail.com>

[ Upstream commit a4dd4fc6105e54393d637450a11d4cddb5fabc4f ]

In cops_probe1(), there is a write to dev->base_addr after requesting an
interrupt line and registering the interrupt handler cops_interrupt().
The handler might be called in parallel to handle an interrupt.
cops_interrupt() tries to read dev->base_addr leading to a potential
data race. So write to dev->base_addr before calling request_irq().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Saubhik Mukherjee <saubhik.mukherjee@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/appletalk/cops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index ba8e70a8e312..6b12ce822e51 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -327,6 +327,8 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			break;
 	}
 
+	dev->base_addr = ioaddr;
+
 	/* Reserve any actual interrupt. */
 	if (dev->irq) {
 		retval = request_irq(dev->irq, cops_interrupt, 0, dev->name, dev);
@@ -334,8 +336,6 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			goto err_out;
 	}
 
-	dev->base_addr = ioaddr;
-
         lp = netdev_priv(dev);
         spin_lock_init(&lp->lock);
 
-- 
2.30.2



