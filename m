Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F33D24752A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgHQTT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:19:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730523AbgHQPgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:36:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94AF2208E4;
        Mon, 17 Aug 2020 15:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678615;
        bh=aD0VJ2hek/6giczS2XRZSjOIniMLgWhsJr0SHpGkQQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/5BiirO6zMWe78iLENdq/nQw2uYmYra21yFCf15GnUgWuPk09903KnJR+v1zUzdH
         FWLY6xGnF5Qj8cwiJHV5Bf0hfWlrwctsmlb2EiEtVfNyjl5yCkQ3xhDA7NgU1Nmtvi
         0SV+l2M8oRjp7deACn4bA1m8/FYxFcQSOrk9INu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, EJ Hsu <ejh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 396/464] r8152: Use MAC address from correct device tree node
Date:   Mon, 17 Aug 2020 17:15:49 +0200
Message-Id: <20200817143852.747892430@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit b9b40ee4db6cb186341b97bca4f0d7aa2a042a66 ]

Query the USB device's device tree node when looking for a MAC address.
The struct device embedded into the struct net_device does not have a
device tree node attached at all.

The reason why this went unnoticed is because the system where this was
tested was one of the few development units that had its OTP programmed,
as opposed to production systems where the MAC address is stored in a
separate EEPROM and is passed via device tree by the firmware.

Reported-by: EJ Hsu <ejh@nvidia.com>
Fixes: acb6d3771a03 ("r8152: Use MAC address from device tree if available")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: EJ Hsu <ejh@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/r8152.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1504,7 +1504,7 @@ static int determine_ethernet_addr(struc
 
 	sa->sa_family = dev->type;
 
-	ret = eth_platform_get_mac_address(&dev->dev, sa->sa_data);
+	ret = eth_platform_get_mac_address(&tp->udev->dev, sa->sa_data);
 	if (ret < 0) {
 		if (tp->version == RTL_VER_01) {
 			ret = pla_ocp_read(tp, PLA_IDR, 8, sa->sa_data);


