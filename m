Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC99845BBF1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243990AbhKXMZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:25:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244749AbhKXMYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:24:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A024861053;
        Wed, 24 Nov 2021 12:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756070;
        bh=g5nifpUJN2RkH6er6+T6k4+356+3J7aV2BJUIElogRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hb1kUqvoT8CHwbS8WorKIxaRxDZf3/rx6oVPLvSUsxkpW+owYv34p5rigUo4qPkuZ
         zbYi2n10Mo/LQ0tcepjdzOgvsnPg24ufhgZIeNSdpQrjYYRiMet5ZJX9CY/2eXe4DM
         hfH7lRYBHd6Usk+6uGkbIFK4aN7Paos1L8F9xjBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.9 159/207] net: mdio-mux: fix unbalanced put_device
Date:   Wed, 24 Nov 2021 12:57:10 +0100
Message-Id: <20211124115709.158453042@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

commit 60f786525032432af1b7d9b8935cb12936244ccd upstream.

mdio_mux_uninit() call put_device (unconditionally) because of
of_mdio_find_bus() in mdio_mux_init.
But of_mdio_find_bus is only called if mux_bus is empty.
If mux_bus is set, mdio_mux_uninit will print a "refcount_t: underflow"
trace.

This patch add a get_device in the other branch of "if (mux_bus)".

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mdio-mux.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/mdio-mux.c
+++ b/drivers/net/phy/mdio-mux.c
@@ -117,6 +117,7 @@ int mdio_mux_init(struct device *dev,
 	} else {
 		parent_bus_node = NULL;
 		parent_bus = mux_bus;
+		get_device(&parent_bus->dev);
 	}
 
 	pb = devm_kzalloc(dev, sizeof(*pb), GFP_KERNEL);
@@ -182,9 +183,7 @@ int mdio_mux_init(struct device *dev,
 
 	devm_kfree(dev, pb);
 err_pb_kz:
-	/* balance the reference of_mdio_find_bus() took */
-	if (!mux_bus)
-		put_device(&parent_bus->dev);
+	put_device(&parent_bus->dev);
 err_parent_bus:
 	of_node_put(parent_bus_node);
 	return ret_val;
@@ -202,7 +201,6 @@ void mdio_mux_uninit(void *mux_handle)
 		cb = cb->next;
 	}
 
-	/* balance the reference of_mdio_find_bus() in mdio_mux_init() took */
 	put_device(&pb->mii_bus->dev);
 }
 EXPORT_SYMBOL_GPL(mdio_mux_uninit);


