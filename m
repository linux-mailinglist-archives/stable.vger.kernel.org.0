Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAEF6557DE
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbiLXBmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237003AbiLXBl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:41:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3471A1A3B3;
        Fri, 23 Dec 2022 17:33:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F24D61FC1;
        Sat, 24 Dec 2022 01:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8EFC433EF;
        Sat, 24 Dec 2022 01:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845611;
        bh=0WGDblyUo5izy0rAoYoXxsjzXp+j7+ssAcq3XUtfXXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nA4mYkq5qjpmzc6HoWWUxwmwKhargOlA8e3LOx8EQVd481pW2zx2OuxOp2SzuM/2l
         YDD3gDKmgBdgK8gk/W92cs9db+x9rYzkbhgrqcDPU/Ef1kTo8ZcB2KEm6EZyTsoxJp
         6nUdOhG65l84GyUHjYDNO5flmZrmg5WOpNYTTC8QLJVb4CGfXmbJsh1BtoT6+BpD20
         NyhFgibiPSXDkyzDEbsYY3y3HYNEPj1D4Ujfvd7ncjWGdRASJ2oX70J5owtLSVFB78
         YnpPYa4Th/AMu9nsqLH95JpFJ/BfCru72moil+1cwIpbBSVqs70L0lTfmCiOK67w1V
         wG9WGpCx5XH3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        laurent.pinchart+renesas@ideasonboard.com,
        wsa+renesas@sang-engineering.com, yang.lee@linux.alibaba.com,
        posteuca@mutex.one, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/4] usb: gadget: u_ether: Do not make UDC parent of the net device
Date:   Fri, 23 Dec 2022 20:33:23 -0500
Message-Id: <20221224013325.393931-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013325.393931-1-sashal@kernel.org>
References: <20221224013325.393931-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 321b59870f850a10dbb211ecd2bd87b41497ea6f ]

The UDC is not a suitable parent of the net device as the UDC can
change or vanish during the lifecycle of the ethernet gadget. This
can be illustrated with the following:

mkdir -p /sys/kernel/config/usb_gadget/mygadget
cd /sys/kernel/config/usb_gadget/mygadget
mkdir -p configs/c.1/strings/0x409
echo "C1:Composite Device" > configs/c.1/strings/0x409/configuration
mkdir -p functions/ecm.usb0
ln -s functions/ecm.usb0 configs/c.1/
echo "dummy_udc.0" > UDC
rmmod dummy_hcd

The 'rmmod' removes the UDC from the just created gadget, leaving
the still existing net device with a no longer existing parent.

Accessing the ethernet device with commands like:

ip --details link show usb0

will result in a KASAN splat:

==================================================================
BUG: KASAN: use-after-free in if_nlmsg_size+0x3e8/0x528
Read of size 4 at addr c5c84754 by task ip/357

CPU: 3 PID: 357 Comm: ip Not tainted 6.1.0-rc3-00013-gd14953726b24-dirty #324
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
 unwind_backtrace from show_stack+0x10/0x14
 show_stack from dump_stack_lvl+0x58/0x70
 dump_stack_lvl from print_report+0x134/0x4d4
 print_report from kasan_report+0x78/0x10c
 kasan_report from if_nlmsg_size+0x3e8/0x528
 if_nlmsg_size from rtnl_getlink+0x2b4/0x4d0
 rtnl_getlink from rtnetlink_rcv_msg+0x1f4/0x674
 rtnetlink_rcv_msg from netlink_rcv_skb+0xb4/0x1f8
 netlink_rcv_skb from netlink_unicast+0x294/0x478
 netlink_unicast from netlink_sendmsg+0x328/0x640
 netlink_sendmsg from ____sys_sendmsg+0x2a4/0x3b4
 ____sys_sendmsg from ___sys_sendmsg+0xc8/0x12c
 ___sys_sendmsg from sys_sendmsg+0xa0/0x120
 sys_sendmsg from ret_fast_syscall+0x0/0x1c

Solve this by not setting the parent of the ethernet device.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20221104131031.850850-2-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_ether.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 5d72872310e7..3c8dab71ba47 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -796,7 +796,6 @@ struct eth_dev *gether_setup_name(struct usb_gadget *g,
 	net->ethtool_ops = &ops;
 
 	dev->gadget = g;
-	SET_NETDEV_DEV(net, &g->dev);
 	SET_NETDEV_DEVTYPE(net, &gadget_type);
 
 	status = register_netdev(net);
@@ -864,8 +863,6 @@ int gether_register_netdev(struct net_device *net)
 	struct sockaddr sa;
 	int status;
 
-	if (!net->dev.parent)
-		return -EINVAL;
 	dev = netdev_priv(net);
 	g = dev->gadget;
 	status = register_netdev(net);
@@ -901,7 +898,6 @@ void gether_set_gadget(struct net_device *net, struct usb_gadget *g)
 
 	dev = netdev_priv(net);
 	dev->gadget = g;
-	SET_NETDEV_DEV(net, &g->dev);
 }
 EXPORT_SYMBOL_GPL(gether_set_gadget);
 
-- 
2.35.1

