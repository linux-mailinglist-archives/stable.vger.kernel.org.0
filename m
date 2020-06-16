Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B2A1FBAE1
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731665AbgFPQPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729835AbgFPPmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:42:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 040E1214F1;
        Tue, 16 Jun 2020 15:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322126;
        bh=ELu6WPG4+sAvh19uhN0GXT119B0iyYXi286G6sFTCZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkMpvY1VU+FrOsQbCBM+XxLJmGTF8S0agy/VNTHbI4mZnLDLWfpjTfrFu3uvnr0p0
         TOKgik5vGBQqbQmaKgiiExlGLN4d4AdtFwa5QeBWVRLVvrxufzYSnaXqEuze8pjGL2
         a65v7JF0JlvDyXe3cBxmfKQ9uWiMuK5Bhq4qBLCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 011/163] net: dsa: qca8k: Fix "Unexpected gfp" kernel exception
Date:   Tue, 16 Jun 2020 17:33:05 +0200
Message-Id: <20200616153107.410190387@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Michal Vokáč" <michal.vokac@ysoft.com>

[ Upstream commit 67122a7910bf2135dc7f7ececfcf16a5bdb362c1 ]

Commit 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
replaced the dsa_switch_alloc helper by devm_kzalloc in all DSA
drivers. Unfortunately it introduced a typo in qca8k.c driver and
wrong argument is passed to the devm_kzalloc function.

This fix mitigates the following kernel exception:

  Unexpected gfp: 0x6 (__GFP_HIGHMEM|GFP_DMA32). Fixing up to gfp: 0x101 (GFP_DMA|__GFP_ZERO). Fix your code!
  CPU: 1 PID: 44 Comm: kworker/1:1 Not tainted 5.5.9-yocto-ua #1
  Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
  Workqueue: events deferred_probe_work_func
  [<c0014924>] (unwind_backtrace) from [<c00123bc>] (show_stack+0x10/0x14)
  [<c00123bc>] (show_stack) from [<c04c8fb4>] (dump_stack+0x90/0xa4)
  [<c04c8fb4>] (dump_stack) from [<c00e1b10>] (new_slab+0x20c/0x214)
  [<c00e1b10>] (new_slab) from [<c00e1cd0>] (___slab_alloc.constprop.0+0x1b8/0x540)
  [<c00e1cd0>] (___slab_alloc.constprop.0) from [<c00e2074>] (__slab_alloc.constprop.0+0x1c/0x24)
  [<c00e2074>] (__slab_alloc.constprop.0) from [<c00e4538>] (__kmalloc_track_caller+0x1b0/0x298)
  [<c00e4538>] (__kmalloc_track_caller) from [<c02cccac>] (devm_kmalloc+0x24/0x70)
  [<c02cccac>] (devm_kmalloc) from [<c030d888>] (qca8k_sw_probe+0x94/0x1ac)
  [<c030d888>] (qca8k_sw_probe) from [<c0304788>] (mdio_probe+0x30/0x54)
  [<c0304788>] (mdio_probe) from [<c02c93bc>] (really_probe+0x1e0/0x348)
  [<c02c93bc>] (really_probe) from [<c02c9884>] (driver_probe_device+0x60/0x16c)
  [<c02c9884>] (driver_probe_device) from [<c02c7fb0>] (bus_for_each_drv+0x70/0x94)
  [<c02c7fb0>] (bus_for_each_drv) from [<c02c9708>] (__device_attach+0xb4/0x11c)
  [<c02c9708>] (__device_attach) from [<c02c8148>] (bus_probe_device+0x84/0x8c)
  [<c02c8148>] (bus_probe_device) from [<c02c8cec>] (deferred_probe_work_func+0x64/0x90)
  [<c02c8cec>] (deferred_probe_work_func) from [<c0033c14>] (process_one_work+0x1d4/0x41c)
  [<c0033c14>] (process_one_work) from [<c00340a4>] (worker_thread+0x248/0x528)
  [<c00340a4>] (worker_thread) from [<c0039148>] (kthread+0x124/0x150)
  [<c0039148>] (kthread) from [<c00090d8>] (ret_from_fork+0x14/0x3c)
  Exception stack(0xee1b5fb0 to 0xee1b5ff8)
  5fa0:                                     00000000 00000000 00000000 00000000
  5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
  5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
  qca8k 2188000.ethernet-1:0a: Using legacy PHYLIB callbacks. Please migrate to PHYLINK!
  qca8k 2188000.ethernet-1:0a eth2 (uninitialized): PHY [2188000.ethernet-1:01] driver [Generic PHY]
  qca8k 2188000.ethernet-1:0a eth1 (uninitialized): PHY [2188000.ethernet-1:02] driver [Generic PHY]

Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/qca8k.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1079,8 +1079,7 @@ qca8k_sw_probe(struct mdio_device *mdiod
 	if (id != QCA8K_ID_QCA8337)
 		return -ENODEV;
 
-	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds),
-				QCA8K_NUM_PORTS);
+	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
 


