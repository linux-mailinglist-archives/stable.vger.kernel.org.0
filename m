Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EC12E3958
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387598AbgL1NUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:20:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387609AbgL1NUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:20:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6083020728;
        Mon, 28 Dec 2020 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161625;
        bh=mg9C9BOsc8Yb4r1plntlZtnY6RBd9cn1Dr0NSo/2R3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qa4q5BwQG5TjnS8dp22LNDnRf9GpDb/tN+VYaU9jHV8/DakShkhgkA3YFM+SIt9Vh
         Z38W+0gr5qG85N/drrES8sLV0UxidozR2lSbVRx1eqIcSRv7PHk6QlubLvqGNDT4wQ
         Z+OKy3aqTmM3SwjgF3K8o4Aign00xVTDLJAfUvhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergej Bauer <sbauer@blackbox.su>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 033/346] lan743x: fix for potential NULL pointer dereference with bare card
Date:   Mon, 28 Dec 2020 13:45:52 +0100
Message-Id: <20201228124921.384198148@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergej Bauer <sbauer@blackbox.su>

[ Upstream commit e9e13b6adc338be1eb88db87bcb392696144bd02 ]

This is the 3rd revision of the patch fix for potential null pointer dereference
with lan743x card.

The simpliest way to reproduce: boot with bare lan743x and issue "ethtool ethN"
commant where ethN is the interface with lan743x card. Example:

$ sudo ethtool eth7
dmesg:
[  103.510336] BUG: kernel NULL pointer dereference, address: 0000000000000340
...
[  103.510836] RIP: 0010:phy_ethtool_get_wol+0x5/0x30 [libphy]
...
[  103.511629] Call Trace:
[  103.511666]  lan743x_ethtool_get_wol+0x21/0x40 [lan743x]
[  103.511724]  dev_ethtool+0x1507/0x29d0
[  103.511769]  ? avc_has_extended_perms+0x17f/0x440
[  103.511820]  ? tomoyo_init_request_info+0x84/0x90
[  103.511870]  ? tomoyo_path_number_perm+0x68/0x1e0
[  103.511919]  ? tty_insert_flip_string_fixed_flag+0x82/0xe0
[  103.511973]  ? inet_ioctl+0x187/0x1d0
[  103.512016]  dev_ioctl+0xb5/0x560
[  103.512055]  sock_do_ioctl+0xa0/0x140
[  103.512098]  sock_ioctl+0x2cb/0x3c0
[  103.512139]  __x64_sys_ioctl+0x84/0xc0
[  103.512183]  do_syscall_64+0x33/0x80
[  103.512224]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  103.512274] RIP: 0033:0x7f54a9cba427
...

Previous versions can be found at:
v1:
initial version
    https://lkml.org/lkml/2020/10/28/921

v2:
do not return from lan743x_ethtool_set_wol if netdev->phydev == NULL, just skip
the call of phy_ethtool_set_wol() instead.
    https://lkml.org/lkml/2020/10/31/380

v3:
in function lan743x_ethtool_set_wol:
use ternary operator instead of if-else sentence (review by Markus Elfring)
return -ENETDOWN insted of -EIO (review by Andrew Lunn)

Signed-off-by: Sergej Bauer <sbauer@blackbox.su>

Link: https://lore.kernel.org/r/20201101223556.16116-1-sbauer@blackbox.su
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_ethtool.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -659,7 +659,9 @@ static void lan743x_ethtool_get_wol(stru
 
 	wol->supported = 0;
 	wol->wolopts = 0;
-	phy_ethtool_get_wol(netdev->phydev, wol);
+
+	if (netdev->phydev)
+		phy_ethtool_get_wol(netdev->phydev, wol);
 
 	wol->supported |= WAKE_BCAST | WAKE_UCAST | WAKE_MCAST |
 		WAKE_MAGIC | WAKE_PHY | WAKE_ARP;
@@ -688,9 +690,8 @@ static int lan743x_ethtool_set_wol(struc
 
 	device_set_wakeup_enable(&adapter->pdev->dev, (bool)wol->wolopts);
 
-	phy_ethtool_set_wol(netdev->phydev, wol);
-
-	return 0;
+	return netdev->phydev ? phy_ethtool_set_wol(netdev->phydev, wol)
+			: -ENETDOWN;
 }
 #endif /* CONFIG_PM */
 


