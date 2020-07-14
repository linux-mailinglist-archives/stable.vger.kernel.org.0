Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8231E21FADB
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbgGNS4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730103AbgGNS4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73DEA229CA;
        Tue, 14 Jul 2020 18:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752983;
        bh=QuTUpPj32od8xKGnqQ9wp9FMjS5Eo+apjOKbMlh7Uxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEUt72RnedHF8H1/3nTpp/eO9YDksmhhLUzvUCRLe4a7fJKwBOe0Ny7p8Yeq0TBFR
         UGnwVgf+XdL4oxjk+pdd4IgN6bNQwwA+6gIi5sXbKCGXqM+h7K0wtPOk8CddB0Zlye
         jw8/rqzqQ93VZsP0N70ENOf6h5R7ljIbI4SFtQs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 075/166] smsc95xx: check return value of smsc95xx_reset
Date:   Tue, 14 Jul 2020 20:44:00 +0200
Message-Id: <20200714184119.445973386@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Edich <andre.edich@microchip.com>

[ Upstream commit 7c8b1e855f94f88a0c569be6309fc8d5c8844cd1 ]

The return value of the function smsc95xx_reset() must be checked
to avoid returning false success from the function smsc95xx_bind().

Fixes: 2f7ca802bdae2 ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
Signed-off-by: Andre Edich <andre.edich@microchip.com>
Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 3cf4dc3433f91..eb404bb74e18e 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1287,6 +1287,8 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	/* Init all registers */
 	ret = smsc95xx_reset(dev);
+	if (ret)
+		goto free_pdata;
 
 	/* detect device revision as different features may be available */
 	ret = smsc95xx_read_reg(dev, ID_REV, &val);
@@ -1317,6 +1319,10 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	schedule_delayed_work(&pdata->carrier_check, CARRIER_CHECK_DELAY);
 
 	return 0;
+
+free_pdata:
+	kfree(pdata);
+	return ret;
 }
 
 static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
-- 
2.25.1



