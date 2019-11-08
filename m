Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C82F5737
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391034AbfKHTTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:19:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389478AbfKHTAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 779A8224D5;
        Fri,  8 Nov 2019 18:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239540;
        bh=0Fumw5pABDtmBx8PhfFyYVSWE/glUAgUa2Q4RqX3LXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPYjGZktsdbKWSjIdPdy4Runmw7HSv6dirM7xqPAbeKaxSoHJPnOG9n1g+m0BBFUk
         eaBOZbnMokdLRtXdeD6cQkusSsOPyIuSdAavSC/pwOIjHhYs1e/tzpAREyGIwDoCRs
         du8P+ymlgmvR9Yf0jYvADFan5ThLvvQ2CggzbjWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 38/62] net: usb: lan78xx: Connect PHY before registering MAC
Date:   Fri,  8 Nov 2019 19:50:26 +0100
Message-Id: <20191108174747.578061301@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 38b4fe320119859c11b1dc06f6b4987a16344fa1 ]

As soon as the netdev is registers, the kernel can start using the
interface. If the driver connects the MAC to the PHY after the netdev
is registered, there is a race condition where the interface can be
opened without having the PHY connected.

Change the order to close this race condition.

Fixes: 92571a1aae40 ("lan78xx: Connect phy early")
Reported-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3642,10 +3642,14 @@ static int lan78xx_probe(struct usb_inte
 	/* driver requires remote-wakeup capability during autosuspend. */
 	intf->needs_remote_wakeup = 1;
 
+	ret = lan78xx_phy_init(dev);
+	if (ret < 0)
+		goto out4;
+
 	ret = register_netdev(netdev);
 	if (ret != 0) {
 		netif_err(dev, probe, netdev, "couldn't register the device\n");
-		goto out4;
+		goto out5;
 	}
 
 	usb_set_intfdata(intf, dev);
@@ -3658,14 +3662,10 @@ static int lan78xx_probe(struct usb_inte
 	pm_runtime_set_autosuspend_delay(&udev->dev,
 					 DEFAULT_AUTOSUSPEND_DELAY);
 
-	ret = lan78xx_phy_init(dev);
-	if (ret < 0)
-		goto out5;
-
 	return 0;
 
 out5:
-	unregister_netdev(netdev);
+	phy_disconnect(netdev->phydev);
 out4:
 	usb_free_urb(dev->urb_intr);
 out3:


