Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6A418B64B
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgCSNZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730647AbgCSNZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:25:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650D2208C3;
        Thu, 19 Mar 2020 13:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624333;
        bh=3af7f/CO/fTsD3hpWvzuPtjznu2o9Apvd9AMygwOY9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVygLwR/2CaDsuUw2uAxOPnncSizWzO4EKLOMxaszUKgLZIEFsWOUwgSAwUmvVMKa
         Ry9WFvtUmmyCcx4Nk7A6QDvb+8qy+Rjzt8yF8Uzpxzde3kRYMUbwypa8tBYgDMzUTV
         f8SNg9QzJsiNgaJSpfjtza0xnCFZ04OwSuOvdXoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 26/65] net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch
Date:   Thu, 19 Mar 2020 14:04:08 +0100
Message-Id: <20200319123934.633133331@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
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



