Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4E6ACDD4
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387407AbfIHMxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733298AbfIHMxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:53:01 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FF8621479;
        Sun,  8 Sep 2019 12:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947180;
        bh=fMbPfK1UhWLIjJXKJhL4Z2oYmNROo8CHt2j9I/iG4Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9TEANnJ1l8pDc0mZzxZdh4H+ChTo3e0+F5d8LztVMpqyTYYxB1PA2ZsuET+iEH1r
         U+dGuLwncjxGzVEw117ZPEEuJPLTEUQvZbQvfDunGZmTBETAx1B35vJiq2Q3t3FUhw
         vQLhqSA4PP6GTgHao+qHY3vNpwrA/IjONpbIe8jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 55/94] lan78xx: Fix memory leaks
Date:   Sun,  8 Sep 2019 13:41:51 +0100
Message-Id: <20190908121152.011370031@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b9cbf8a64865b50fd0f4a3915fa00ac7365cdf8f ]

In lan78xx_probe(), a new urb is allocated through usb_alloc_urb() and
saved to 'dev->urb_intr'. However, in the following execution, if an error
occurs, 'dev->urb_intr' is not deallocated, leading to memory leaks. To fix
this issue, invoke usb_free_urb() to free the allocated urb before
returning from the function.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3d92ea6fcc02b..f033fee225a11 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3792,7 +3792,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	ret = register_netdev(netdev);
 	if (ret != 0) {
 		netif_err(dev, probe, netdev, "couldn't register the device\n");
-		goto out3;
+		goto out4;
 	}
 
 	usb_set_intfdata(intf, dev);
@@ -3807,12 +3807,14 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	ret = lan78xx_phy_init(dev);
 	if (ret < 0)
-		goto out4;
+		goto out5;
 
 	return 0;
 
-out4:
+out5:
 	unregister_netdev(netdev);
+out4:
+	usb_free_urb(dev->urb_intr);
 out3:
 	lan78xx_unbind(dev, intf);
 out2:
-- 
2.20.1



