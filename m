Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02A64704DC
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 16:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbhLJPve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 10:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243677AbhLJPtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 10:49:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28129C07E5DE
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 07:44:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75E63CE211C
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 15:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D406C00446;
        Fri, 10 Dec 2021 15:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639151090;
        bh=EIp5wNnUFBfjb2PgOkQoohdGYlY0+NMl/UPKA61cA/I=;
        h=Subject:To:Cc:From:Date:From;
        b=p6NQiXCLHd1szIb3DPZH5eCySnBW7fQSWXSNVJYx/FCEQnuGIHRaf3LQDl4j1kV/O
         bO9X/aGX+/tL2z/iPu52xPSI00qrQrEyMaLT2IuaFrHGmrot+4JGqMg+WDd/Ft4Oqi
         EuQxWcJJQpF1LAYcpj40n9oNOII8eT4sQAjr1H6A=
Subject: FAILED: patch "[PATCH] ethtool: do not perform operations on net devices being" failed to apply to 5.10-stable tree
To:     atenart@kernel.org, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 16:44:47 +0100
Message-ID: <1639151087230186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dde91ccfa25fd58f64c397d91b81a4b393100ffa Mon Sep 17 00:00:00 2001
From: Antoine Tenart <atenart@kernel.org>
Date: Fri, 3 Dec 2021 11:13:18 +0100
Subject: [PATCH] ethtool: do not perform operations on net devices being
 unregistered

There is a short period between a net device starts to be unregistered
and when it is actually gone. In that time frame ethtool operations
could still be performed, which might end up in unwanted or undefined
behaviours[1].

Do not allow ethtool operations after a net device starts its
unregistration. This patch targets the netlink part as the ioctl one
isn't affected: the reference to the net device is taken and the
operation is executed within an rtnl lock section and the net device
won't be found after unregister.

[1] For example adding Tx queues after unregister ends up in NULL
    pointer exceptions and UaFs, such as:

      BUG: KASAN: use-after-free in kobject_get+0x14/0x90
      Read of size 1 at addr ffff88801961248c by task ethtool/755

      CPU: 0 PID: 755 Comm: ethtool Not tainted 5.15.0-rc6+ #778
      Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/014
      Call Trace:
       dump_stack_lvl+0x57/0x72
       print_address_description.constprop.0+0x1f/0x140
       kasan_report.cold+0x7f/0x11b
       kobject_get+0x14/0x90
       kobject_add_internal+0x3d1/0x450
       kobject_init_and_add+0xba/0xf0
       netdev_queue_update_kobjects+0xcf/0x200
       netif_set_real_num_tx_queues+0xb4/0x310
       veth_set_channels+0x1c3/0x550
       ethnl_set_channels+0x524/0x610

Fixes: 041b1c5d4a53 ("ethtool: helper functions for netlink interface")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Link: https://lore.kernel.org/r/20211203101318.435618-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 38b44c0291b1..96f4180aabd2 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -40,7 +40,8 @@ int ethnl_ops_begin(struct net_device *dev)
 	if (dev->dev.parent)
 		pm_runtime_get_sync(dev->dev.parent);
 
-	if (!netif_device_present(dev)) {
+	if (!netif_device_present(dev) ||
+	    dev->reg_state == NETREG_UNREGISTERING) {
 		ret = -ENODEV;
 		goto err;
 	}

