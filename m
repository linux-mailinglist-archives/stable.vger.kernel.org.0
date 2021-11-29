Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE1F4625C2
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhK2WnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbhK2Wmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:42:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8BFC07E5ED;
        Mon, 29 Nov 2021 10:38:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC47FB815DB;
        Mon, 29 Nov 2021 18:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC82C53FC7;
        Mon, 29 Nov 2021 18:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211105;
        bh=OQgr4Qm0K/FI2+/xyEOL9xaYgNpsramsiM1RU2OSjVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7/BG/WpD4tfTKaT2jBAIQEZjkZXFQsI+awR49g5v8EAX35OH0eXB366hG45xa5FV
         Ohd5NinF3YyVdJuc69VfY8cG1IQ7QjszSOKlwTzIA4BPF45wiWZeDSl/ccoqZ0T/w7
         g34UxfyKUhyJ8eh9JPI9sqaPNch/S82nntCuJIUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/179] net: marvell: prestera: fix double free issue on err path
Date:   Mon, 29 Nov 2021 19:18:08 +0100
Message-Id: <20211129181722.022851290@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

[ Upstream commit e8d032507cb7912baf1d3e0af54516f823befefd ]

fix error path handling in prestera_bridge_port_join() that
cases prestera driver to crash (see below).

 Trace:
   Internal error: Oops: 96000044 [#1] SMP
   Modules linked in: prestera_pci prestera uio_pdrv_genirq
   CPU: 1 PID: 881 Comm: ip Not tainted 5.15.0 #1
   pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
   pc : prestera_bridge_destroy+0x2c/0xb0 [prestera]
   lr : prestera_bridge_port_join+0x2cc/0x350 [prestera]
   sp : ffff800011a1b0f0
   ...
   x2 : ffff000109ca6c80 x1 : dead000000000100 x0 : dead000000000122
    Call trace:
   prestera_bridge_destroy+0x2c/0xb0 [prestera]
   prestera_bridge_port_join+0x2cc/0x350 [prestera]
   prestera_netdev_port_event.constprop.0+0x3c4/0x450 [prestera]
   prestera_netdev_event_handler+0xf4/0x110 [prestera]
   raw_notifier_call_chain+0x54/0x80
   call_netdevice_notifiers_info+0x54/0xa0
   __netdev_upper_dev_link+0x19c/0x380

Fixes: e1189d9a5fbe ("net: marvell: prestera: Add Switchdev driver implementation")
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 79f2fca0d412d..b4599fe4ca8da 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -497,8 +497,8 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 
 	br_port = prestera_bridge_port_add(bridge, port->dev);
 	if (IS_ERR(br_port)) {
-		err = PTR_ERR(br_port);
-		goto err_brport_create;
+		prestera_bridge_put(bridge);
+		return PTR_ERR(br_port);
 	}
 
 	err = switchdev_bridge_port_offload(br_port->dev, port->dev, NULL,
@@ -519,8 +519,6 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 err_switchdev_offload:
 	prestera_bridge_port_put(br_port);
-err_brport_create:
-	prestera_bridge_put(bridge);
 	return err;
 }
 
-- 
2.33.0



