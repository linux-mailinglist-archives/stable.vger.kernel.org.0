Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781A0420FC2
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbhJDNhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237852AbhJDNfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE93C6323B;
        Mon,  4 Oct 2021 13:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353371;
        bh=smiUTtRiaGoU+nFcMxewv5eiXgcGWdbOb6D2V+gBoC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2onJPbJMwr1y/s9bJ+7LJ3s1O63D4BrrVEJ7g8rKRTJ+Dsl2kVrYMrsDZ0oIEBnf9
         07Jj4WkzZIP6oDACK6KXqpxlkMrIfjwRIz3SjzZm69X1iOAoMv6EUWYkcMwfNUEVLj
         QhmaNJEcvniVyBell0Dc7UjMFc4ZSF1YBsyJXqu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 103/172] smsc95xx: fix stalled rx after link change
Date:   Mon,  4 Oct 2021 14:52:33 +0200
Message-Id: <20211004125048.309479236@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit 5ab8a447bcfee1ded709e7ff5dc7608ca9f66ae2 ]

After commit 05b35e7eb9a1 ("smsc95xx: add phylib support"), link changes
are no longer propagated to usbnet. As a result, rx URB allocation won't
happen until there is a packet sent out first (this might never happen,
e.g. running just ssh server with a static IP). Fix by triggering usbnet
EVENT_LINK_CHANGE.

Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 4c8ee1cff4d4..4cb71dd1998c 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1178,7 +1178,10 @@ static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 
 static void smsc95xx_handle_link_change(struct net_device *net)
 {
+	struct usbnet *dev = netdev_priv(net);
+
 	phy_print_status(net->phydev);
+	usbnet_defer_kevent(dev, EVENT_LINK_CHANGE);
 }
 
 static int smsc95xx_start_phy(struct usbnet *dev)
-- 
2.33.0



