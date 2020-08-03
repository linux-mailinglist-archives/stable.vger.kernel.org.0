Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078E223A5CC
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgHCMlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729261AbgHCMcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:32:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 011FB204EC;
        Mon,  3 Aug 2020 12:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457925;
        bh=8OoNLzM9mef1N3xrgx4IKRdDJjPBJpJae6hwQNZo8l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHHfXhcGB8ogAL0N2mICFSh7K5FGkd7mjSVYLEn3LR0YKbcFJsiFfLdAiE4bhscpN
         x2aecNrcEDmIEHt4fwXWvzAA7M62NBaaHIrL1CBFyOJqLZPdhsnzxaBIp75QeLujDO
         /BHR+0I2jnakj/3qOEbiDtfvMXiqXaOLANBPluDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 32/56] net: lan78xx: add missing endpoint sanity check
Date:   Mon,  3 Aug 2020 14:19:47 +0200
Message-Id: <20200803121851.898829519@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 8d8e95fd6d69d774013f51e5f2ee10c6e6d1fc14 ]

Add the missing endpoint sanity check to prevent a NULL-pointer
dereference should a malicious device lack the expected endpoints.

Note that the driver has a broken endpoint-lookup helper,
lan78xx_get_endpoints(), which can end up accepting interfaces in an
altsetting without endpoints as long as *some* altsetting has a bulk-in
and a bulk-out endpoint.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Cc: Woojung.Huh@microchip.com <Woojung.Huh@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 92548887df2fe..2dff233814ea5 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3786,6 +3786,11 @@ static int lan78xx_probe(struct usb_interface *intf,
 	netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
 	netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
 
+	if (intf->cur_altsetting->desc.bNumEndpoints < 3) {
+		ret = -ENODEV;
+		goto out3;
+	}
+
 	dev->ep_blkin = (intf->cur_altsetting)->endpoint + 0;
 	dev->ep_blkout = (intf->cur_altsetting)->endpoint + 1;
 	dev->ep_intr = (intf->cur_altsetting)->endpoint + 2;
-- 
2.25.1



