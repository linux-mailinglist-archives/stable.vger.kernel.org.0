Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1501F3A60B5
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhFNKhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233505AbhFNKfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED0C661206;
        Mon, 14 Jun 2021 10:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666745;
        bh=bYIvQUL/L8SXdwowI50911FbHROn5SVxawabsKcL6vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8hOxTUL+eD9hJc1OjjtHjcSpETFPMMNjeD99pKY/4zpEkpLmU3XHQ4ker3pOjKfa
         aV+NesD5nFh/x5jQD+zNuHsIACaMvn7okBH7AvUICOU0fMWQc7EpQ6hAvr7y2Cyl58
         W8NlZa6ATLJgJWNd2i/VHd3voiRwSjNSsBF6kn5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saubhik Mukherjee <saubhik.mukherjee@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/49] net: appletalk: cops: Fix data race in cops_probe1
Date:   Mon, 14 Jun 2021 12:27:07 +0200
Message-Id: <20210614102642.339160940@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
References: <20210614102641.857724541@linuxfoundation.org>
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
index 486e1e6997fc..dde0cda3f696 100644
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



