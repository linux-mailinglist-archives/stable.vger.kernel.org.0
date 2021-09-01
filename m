Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69023FDC19
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344606AbhIAMqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345663AbhIAMoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4899461153;
        Wed,  1 Sep 2021 12:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499937;
        bh=C8PwbP1bdvAq4541uYPyLTfeK4W8SctHqqKYsRF0WR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeft8UeRpvPu1geF7Ue8NV8KNZgAEWrDN8XEQrSTJo5Pi/MKyeP+hbjF7G5fmXBkH
         4N5oXKkHeXFoWmpyLd+ab8IC1nvUbuAjwKBtwZ5TI5CY/kx0Y/lUbZ/lyw2ofEkCkN
         xL3Ci/KeLA6D5/IwND5Y6uvWuPLlnHdKA1BQNzds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Petko Manolov <petko.manolov@konsulko.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 042/113] net: usb: pegasus: fixes of set_register(s) return value evaluation;
Date:   Wed,  1 Sep 2021 14:27:57 +0200
Message-Id: <20210901122303.394313119@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petko Manolov <petko.manolov@konsulko.com>

[ Upstream commit ffc9c3ebb4af870a121da99826e9ccb63dc8b3d7 ]

- restore the behavior in enable_net_traffic() to avoid regressions - Jakub
    Kicinski;
  - hurried up and removed redundant assignment in pegasus_open() before yet
    another checker complains;

Fixes: 8a160e2e9aeb ("net: usb: pegasus: Check the return value of get_geristers() and friends;")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index a08a46fef0d2..847372c6d9e8 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -471,7 +471,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
 		write_mii_word(pegasus, 0, 0x1b, &auxmode);
 	}
 
-	return 0;
+	return ret;
 fail:
 	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 	return ret;
@@ -860,7 +860,7 @@ static int pegasus_open(struct net_device *net)
 	if (!pegasus->rx_skb)
 		goto exit;
 
-	res = set_registers(pegasus, EthID, 6, net->dev_addr);
+	set_registers(pegasus, EthID, 6, net->dev_addr);
 
 	usb_fill_bulk_urb(pegasus->rx_urb, pegasus->usb,
 			  usb_rcvbulkpipe(pegasus->usb, 1),
-- 
2.30.2



