Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156FF18B6E2
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbgCSNX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729985AbgCSNXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:23:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7373B21655;
        Thu, 19 Mar 2020 13:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624234;
        bh=3af7f/CO/fTsD3hpWvzuPtjznu2o9Apvd9AMygwOY9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apoINyBWGgWm11YMgszUWRrIxGC8CrWYNKZL65AZMOf36rI9es1B5O9Fjkx4imALz
         y+vZX4+XdXNYXPQGas9R756yYTGz9xSzBSGsd+kmsfHyk5+7PYCvaXnPC4Efaz+3kR
         Iy3tx7LiaOY40j8qY8pBchYBesCB0sroK7TLMWOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/60] net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch
Date:   Thu, 19 Mar 2020 14:04:03 +0100
Message-Id: <20200319123927.351958308@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit eae7172f8141eb98e64e6e81acc9e9d5b2add127 ]

usbnet creates network interfaces with min_mtu = 0 and
max_mtu = ETH_MAX_MTU.

These values are not modified by qmi_wwan when the network interface
is created initially, allowing, for example, to set mtu greater than 1500.

When a raw_ip switch is done (raw_ip set to 'Y', then set to 'N') the mtu
values for the network interface are set through ether_setup, with
min_mtu = ETH_MIN_MTU and max_mtu = ETH_DATA_LEN, not allowing anymore to
set mtu greater than 1500 (error: mtu greater than device maximum).

The patch restores the original min/max mtu values set by usbnet after a
raw_ip switch.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 3b7a3b8a5e067..5754bb6ca0eec 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -337,6 +337,9 @@ static void qmi_wwan_netdev_setup(struct net_device *net)
 		netdev_dbg(net, "mode: raw IP\n");
 	} else if (!net->header_ops) { /* don't bother if already set */
 		ether_setup(net);
+		/* Restoring min/max mtu values set originally by usbnet */
+		net->min_mtu = 0;
+		net->max_mtu = ETH_MAX_MTU;
 		clear_bit(EVENT_NO_IP_ALIGN, &dev->flags);
 		netdev_dbg(net, "mode: Ethernet\n");
 	}
-- 
2.20.1



