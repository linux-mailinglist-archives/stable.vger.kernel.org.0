Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCF44726F5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhLMJ4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:56:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:44500 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238769AbhLMJyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:54:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8D056CE0E89;
        Mon, 13 Dec 2021 09:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B42C34601;
        Mon, 13 Dec 2021 09:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389269;
        bh=Q4VgdxCetITBXU+KoRRJIaxoRRD/IkP/pXQ8GLnH6D0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hL3Eo7vdvKxZH6Rkg/jEC2Rs262XOZptZ7STLjpHjJzBKT+fWdip1s8ai+AZVWvdl
         262xSuwWgXK856ZaVWTAhP0AsgEb12MQ+0VGiE4GnAaNwUeqVZdXdqG/7abgsD4IVl
         1jFIkz7IxyA+c9Tes8VWYcEPUfm9l+1k5zMZtnWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>
Subject: [PATCH 5.15 041/171] ethtool: do not perform operations on net devices being unregistered
Date:   Mon, 13 Dec 2021 10:29:16 +0100
Message-Id: <20211213092946.450128360@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

commit dde91ccfa25fd58f64c397d91b81a4b393100ffa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/netlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -40,7 +40,8 @@ int ethnl_ops_begin(struct net_device *d
 	if (dev->dev.parent)
 		pm_runtime_get_sync(dev->dev.parent);
 
-	if (!netif_device_present(dev)) {
+	if (!netif_device_present(dev) ||
+	    dev->reg_state == NETREG_UNREGISTERING) {
 		ret = -ENODEV;
 		goto err;
 	}


