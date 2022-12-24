Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811346557E6
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbiLXBm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbiLXBl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:41:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6BC17409;
        Fri, 23 Dec 2022 17:33:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6049B8219D;
        Sat, 24 Dec 2022 01:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E817C433D2;
        Sat, 24 Dec 2022 01:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845587;
        bh=YlhgIuvHdPk4d7mnSLS5qFqeY9eZBnbh2zV/J3CDOWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPZZGbeY0k0EVEmRFXf6t/5z0Dq9Qxx9yfPY3RtDbTthWDttxrynTi4Jt/1hgWupv
         gJVa70AhHm7/IuP2uXvz8hACpudu03WKxwFDBAyDGnMC5uql2XIr8uDaVTkwri8Ck6
         fT96SQ2HFyzOTyWDGQSumpJxdSHrFFj9mt6e+GtaLYAgLKUhZ12USouMjrnS8Ij5GG
         k8DVG/E5eUL4XRoAz3QgMRlT5aJCEe+5Ukp1eKozwAXvwwFPJNCJt7G1vusemX8NuG
         GHJphjvDWKZNPlUJ/6Pqf5Bkqblz2Hcy2HMLO+7Cl5IXO0i0688yKPXHU0Fkp9Eefy
         G6GgeLcB3RP0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        wsa+renesas@sang-engineering.com, posteuca@mutex.one,
        yang.lee@linux.alibaba.com, skhan@linuxfoundation.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 3/6] usb: gadget: u_ether: Do not make UDC parent of the net device
Date:   Fri, 23 Dec 2022 20:32:51 -0500
Message-Id: <20221224013254.393646-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013254.393646-1-sashal@kernel.org>
References: <20221224013254.393646-1-sashal@kernel.org>
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
index 2fe91f120bb1..c4196c32c0be 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -795,7 +795,6 @@ struct eth_dev *gether_setup_name(struct usb_gadget *g,
 	net->max_mtu = GETHER_MAX_MTU_SIZE;
 
 	dev->gadget = g;
-	SET_NETDEV_DEV(net, &g->dev);
 	SET_NETDEV_DEVTYPE(net, &gadget_type);
 
 	status = register_netdev(net);
@@ -869,8 +868,6 @@ int gether_register_netdev(struct net_device *net)
 	struct usb_gadget *g;
 	int status;
 
-	if (!net->dev.parent)
-		return -EINVAL;
 	dev = netdev_priv(net);
 	g = dev->gadget;
 
@@ -901,7 +898,6 @@ void gether_set_gadget(struct net_device *net, struct usb_gadget *g)
 
 	dev = netdev_priv(net);
 	dev->gadget = g;
-	SET_NETDEV_DEV(net, &g->dev);
 }
 EXPORT_SYMBOL_GPL(gether_set_gadget);
 
-- 
2.35.1

