Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029CE3A6048
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhFNKdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233077AbhFNKcb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:32:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61D4E611CA;
        Mon, 14 Jun 2021 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666613;
        bh=wsd71GWpjcCghhnVLpTuvODi+OFI3tJj2bsAKOT2WyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjzhsfeWwLsvzIk6Fm3+FN/kZysgLVoy4V02SwMOn2kJfGxFhydZPOxdMuGkoU4lF
         srtHj8ZiMMKDq6o73O1qjuHnGLw1l+nStT99PCDa85d5A3SSVU+RVJfNHQdqNMDoDr
         hXW6mW2SsTPH6VfFEW3BnnQersUQGWbB+AgTVL8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saubhik Mukherjee <saubhik.mukherjee@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 12/34] net: appletalk: cops: Fix data race in cops_probe1
Date:   Mon, 14 Jun 2021 12:27:03 +0200
Message-Id: <20210614102641.986810199@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
References: <20210614102641.582612289@linuxfoundation.org>
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
index 7f2a032c354c..841a5de58c7c 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -324,6 +324,8 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			break;
 	}
 
+	dev->base_addr = ioaddr;
+
 	/* Reserve any actual interrupt. */
 	if (dev->irq) {
 		retval = request_irq(dev->irq, cops_interrupt, 0, dev->name, dev);
@@ -331,8 +333,6 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			goto err_out;
 	}
 
-	dev->base_addr = ioaddr;
-
         lp = netdev_priv(dev);
         spin_lock_init(&lp->lock);
 
-- 
2.30.2



