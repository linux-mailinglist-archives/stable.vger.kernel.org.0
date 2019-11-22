Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2C51070A8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfKVKkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:40:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbfKVKkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:40:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D85D020717;
        Fri, 22 Nov 2019 10:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419212;
        bh=SLrivsqtWUW1YaeUJjXQacHkwJO/47lWejE0nFG1YqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNQ6KyMy7hv+sz/8UXFkrB+Ic8cjWR8zcgYXp4uqYZY+gqpxmIbXJB/QQP6QrwTQw
         Txrc4xEpth5rJV37HmqH9hg0bx10k1Jll0OXbH9gvx/sqv+/1AsygINUtauERkd4xP
         EzR95oEP3w+F2+VYgsrA14shrgLABJ8/ypROaAb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Raghuram Chary Jallipalli 
        <raghuramchary.jallipalli@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 036/222] net: lan78xx: Bail out if lan78xx_get_endpoints fails
Date:   Fri, 22 Nov 2019 11:26:16 +0100
Message-Id: <20191122100846.707774879@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit fa8cd98c06407b5798b927cd7fd14d30f360ed02 ]

We need to bail out if lan78xx_get_endpoints() fails, otherwise the
result is overwritten.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Raghuram Chary Jallipalli <raghuramchary.jallipalli@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index e143a7fe93201..a3f9d8f05db4a 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2621,6 +2621,11 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 	int i;
 
 	ret = lan78xx_get_endpoints(dev, intf);
+	if (ret) {
+		netdev_warn(dev->net, "lan78xx_get_endpoints failed: %d\n",
+			    ret);
+		return ret;
+	}
 
 	dev->data[0] = (unsigned long)kzalloc(sizeof(*pdata), GFP_KERNEL);
 
-- 
2.20.1



