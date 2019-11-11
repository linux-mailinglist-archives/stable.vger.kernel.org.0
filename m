Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E21AF7E5F
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfKKSp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:45:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729362AbfKKSpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:45:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EFC920659;
        Mon, 11 Nov 2019 18:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497954;
        bh=MiB01lvFJ4sJdU+938T48brDjZ+FvCovG0/QzdKzXj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8XCzyxzZg9y12LOhH4jBDnHkxtI2wYXeyk+seTuxoZHliGEmXCrPqG1qmPbF5Yd7
         YPYoQQ1D7hVYKxy22WBhsQR7LLd33mjWfi/n+0c35H4yB7NGyVL11l+/SEJn7NBOPr
         3nUjYxKAD38uJ5MA3pCLcu2NS5YJwi99qa1KijKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/125] net: hisilicon: Fix "Trying to free already-free IRQ"
Date:   Mon, 11 Nov 2019 19:29:05 +0100
Message-Id: <20191111181454.103481087@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

[ Upstream commit 63a41746827cb16dc6ad0d4d761ab4e7dda7a0c3 ]

When rmmod hip04_eth.ko, we can get the following warning:

Task track: rmmod(1623)>bash(1591)>login(1581)>init(1)
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1623 at kernel/irq/manage.c:1557 __free_irq+0xa4/0x2ac()
Trying to free already-free IRQ 200
Modules linked in: ping(O) pramdisk(O) cpuinfo(O) rtos_snapshot(O) interrupt_ctrl(O) mtdblock mtd_blkdevrtfs nfs_acl nfs lockd grace sunrpc xt_tcpudp ipt_REJECT iptable_filter ip_tables x_tables nf_reject_ipv
CPU: 0 PID: 1623 Comm: rmmod Tainted: G           O    4.4.193 #1
Hardware name: Hisilicon A15
[<c020b408>] (rtos_unwind_backtrace) from [<c0206624>] (show_stack+0x10/0x14)
[<c0206624>] (show_stack) from [<c03f2be4>] (dump_stack+0xa0/0xd8)
[<c03f2be4>] (dump_stack) from [<c021a780>] (warn_slowpath_common+0x84/0xb0)
[<c021a780>] (warn_slowpath_common) from [<c021a7e8>] (warn_slowpath_fmt+0x3c/0x68)
[<c021a7e8>] (warn_slowpath_fmt) from [<c026876c>] (__free_irq+0xa4/0x2ac)
[<c026876c>] (__free_irq) from [<c0268a14>] (free_irq+0x60/0x7c)
[<c0268a14>] (free_irq) from [<c0469e80>] (release_nodes+0x1c4/0x1ec)
[<c0469e80>] (release_nodes) from [<c0466924>] (__device_release_driver+0xa8/0x104)
[<c0466924>] (__device_release_driver) from [<c0466a80>] (driver_detach+0xd0/0xf8)
[<c0466a80>] (driver_detach) from [<c0465e18>] (bus_remove_driver+0x64/0x8c)
[<c0465e18>] (bus_remove_driver) from [<c02935b0>] (SyS_delete_module+0x198/0x1e0)
[<c02935b0>] (SyS_delete_module) from [<c0202ed0>] (__sys_trace_return+0x0/0x10)
---[ end trace bb25d6123d849b44 ]---

Currently "rmmod hip04_eth.ko" call free_irq more than once
as devres_release_all and hip04_remove both call free_irq.
This results in a 'Trying to free already-free IRQ' warning.
To solve the problem free_irq has been moved out of hip04_remove.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 2f8f03e0db81e..644ad78d00515 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -945,7 +945,6 @@ static int hip04_remove(struct platform_device *pdev)
 
 	hip04_free_ring(ndev, d);
 	unregister_netdev(ndev);
-	free_irq(ndev->irq, ndev);
 	of_node_put(priv->phy_node);
 	cancel_work_sync(&priv->tx_timeout_task);
 	free_netdev(ndev);
-- 
2.20.1



