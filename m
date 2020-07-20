Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F70D226C03
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgGTPj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728518AbgGTPj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:39:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3941F22B4E;
        Mon, 20 Jul 2020 15:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259598;
        bh=cSxS4YWnRC2AZvH8yca7ffr8tLw7bkuEtMicPWSPDSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N007WIthHaaOgfUy+Xlaxx6kKxW2Xvm4m3KmxcV+LZMciltfWLgeudnp6O9p6avmz
         4JJtGQMD8Udu77abtICY0lSdrigoTYPMbfveoVZ0WHvihjKOllxIidUbRjqFWnNczz
         q6YLsS0aoFHwtQ16v7JV56rOQcU4pr9/RpXHhgvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 10/86] smsc95xx: check return value of smsc95xx_reset
Date:   Mon, 20 Jul 2020 17:36:06 +0200
Message-Id: <20200720152753.638659470@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
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
index 6852ebafd4d3b..6ecae631a6307 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1292,6 +1292,8 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	/* Init all registers */
 	ret = smsc95xx_reset(dev);
+	if (ret)
+		goto free_pdata;
 
 	/* detect device revision as different features may be available */
 	ret = smsc95xx_read_reg(dev, ID_REV, &val);
@@ -1320,6 +1322,10 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
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



