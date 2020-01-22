Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4671450D9
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733141AbgAVJjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733134AbgAVJjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:39:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C14724680;
        Wed, 22 Jan 2020 09:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685941;
        bh=p+8GyNqwrHT4q0DGDk/9BN7UfY+AzIYXz6i8tMjSyjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BR6phXev8MBmwYrXy6XiarPd7ENm10/rKerk4cUQ0Nmlo1DGdOpjeDxDxGRlBaC/m
         vE6E7GJ9/6FMYa2vy42MwumAgoqHSxA7FnrOVs92Bq4TaBkk3pJtbL8gS1SucfV/Ev
         krSgNz9lxCEfOw3jZYlStjg7zACOzvvXuBRvAvgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        RENARD Pierre-Francois <pfrenard@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 45/65] net: usb: lan78xx: limit size of local TSO packets
Date:   Wed, 22 Jan 2020 10:29:30 +0100
Message-Id: <20200122092757.538297009@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f8d7408a4d7f60f8b2df0f81decdc882dd9c20dc ]

lan78xx_tx_bh() makes sure to not exceed MAX_SINGLE_PACKET_SIZE
bytes in the aggregated packets it builds, but does
nothing to prevent large GSO packets being submitted.

Pierre-Francois reported various hangs when/if TSO is enabled.

For localy generated packets, we can use netif_set_gso_max_size()
to limit the size of TSO packets.

Note that forwarded packets could still hit the issue,
so a complete fix might require implementing .ndo_features_check
for this driver, forcing a software segmentation if the size
of the TSO packet exceeds MAX_SINGLE_PACKET_SIZE.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
Tested-by: RENARD Pierre-Francois <pfrenard@gmail.com>
Cc: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3612,6 +3612,7 @@ static int lan78xx_probe(struct usb_inte
 
 	/* MTU range: 68 - 9000 */
 	netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
+	netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
 
 	dev->ep_blkin = (intf->cur_altsetting)->endpoint + 0;
 	dev->ep_blkout = (intf->cur_altsetting)->endpoint + 1;


