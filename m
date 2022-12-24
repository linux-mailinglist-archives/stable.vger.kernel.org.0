Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986C7655742
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbiLXBd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbiLXBc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:32:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0F818E2B;
        Fri, 23 Dec 2022 17:31:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 526FB61F9C;
        Sat, 24 Dec 2022 01:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99543C433EF;
        Sat, 24 Dec 2022 01:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845462;
        bh=kYxK3DAkdYsOhwt+M+g9vYhaCgz2L7LJ5W7/+A4Bhv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muxeHfi6a+ye+XDbzcr8mywgWKYRuVlulBVIkB1zkUGAZ2GKGNXYh+w4Mgmyb0rMu
         EtqLwl6XGKK+Ed+ajg1z0EBrmWYcf7SKeyXvqroixgKMxCPsdfYVvF5IUw/uOq5eUL
         J6ecQnKVtYE/noy84BQ3cavLNA2IBo056F7HXFeR0BVKJ3anMohHym1/AY97UkucZ7
         CchP2UW9rY+F62XXuXCByv6vt1mRyRbeHlTMGBY9ae8obtJSaxWUbLCnPpiBnyE2p6
         coNThUq37g7u9vnim2GeE3BlobDf5TCAAcsyLfy9RaLxQj/Eh8Qgvhm+Xkd6JnE420
         FLnPj/BgHWpZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        laurent.pinchart+renesas@ideasonboard.com,
        wsa+renesas@sang-engineering.com, posteuca@mutex.one,
        richard.leitner@skidata.com, yang.lee@linux.alibaba.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 05/18] usb: gadget: u_ether: Do not make UDC parent of the net device
Date:   Fri, 23 Dec 2022 20:30:21 -0500
Message-Id: <20221224013034.392810-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013034.392810-1-sashal@kernel.org>
References: <20221224013034.392810-1-sashal@kernel.org>
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
index 7887def05dc2..8a009493f24a 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -798,7 +798,6 @@ struct eth_dev *gether_setup_name(struct usb_gadget *g,
 	net->max_mtu = GETHER_MAX_MTU_SIZE;
 
 	dev->gadget = g;
-	SET_NETDEV_DEV(net, &g->dev);
 	SET_NETDEV_DEVTYPE(net, &gadget_type);
 
 	status = register_netdev(net);
@@ -873,8 +872,6 @@ int gether_register_netdev(struct net_device *net)
 	struct usb_gadget *g;
 	int status;
 
-	if (!net->dev.parent)
-		return -EINVAL;
 	dev = netdev_priv(net);
 	g = dev->gadget;
 
@@ -905,7 +902,6 @@ void gether_set_gadget(struct net_device *net, struct usb_gadget *g)
 
 	dev = netdev_priv(net);
 	dev->gadget = g;
-	SET_NETDEV_DEV(net, &g->dev);
 }
 EXPORT_SYMBOL_GPL(gether_set_gadget);
 
-- 
2.35.1

