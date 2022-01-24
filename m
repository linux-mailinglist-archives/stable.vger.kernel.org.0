Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF92499413
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357406AbiAXUin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385519AbiAXUd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6C6C07E29C;
        Mon, 24 Jan 2022 11:45:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75015B8121C;
        Mon, 24 Jan 2022 19:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FDCC340E7;
        Mon, 24 Jan 2022 19:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053534;
        bh=fDKZb5ZOGOoDpGNIT4AzWS/7B5dYfdm2X4IfhgXunug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUICPZLcKgdJfChlXS8m6A2zomMTIkFzTd0C9bZjWsyXNXw93OJqeWE8nPz5Q0IBB
         AjcZEAxtbeTOhtznPG7ZdGIkB9TN7ecxQa2pw6TTzRWHKq0eBx2Ny5aFjRv/1SiU7V
         uMI/bm/dTa4uUjET5jVWw0xEzrxm+5XJydqclrB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "George G. Davis" <davis.george@siemens.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/563] mtd: hyperbus: rpc-if: fix bug in rpcif_hb_remove
Date:   Mon, 24 Jan 2022 19:37:41 +0100
Message-Id: <20220124184027.714831597@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George G. Davis <davis.george@siemens.com>

[ Upstream commit baaf965f94308301d2dc554d72a87d7432cd5ce6 ]

The following KASAN BUG is observed when testing the rpc-if driver on
rcar-gen3:

root@rcar-gen3:~# modprobe -r rpc-if
[  101.930146] ==================================================================
[  101.937408] BUG: KASAN: slab-out-of-bounds in __lock_acquire+0x518/0x25d0
[  101.944240] Read of size 8 at addr ffff0004c5be2750 by task modprobe/664
[  101.950959]
[  101.952466] CPU: 2 PID: 664 Comm: modprobe Not tainted 5.14.0-rc1-00342-g1a1464d7aa31 #1
[  101.960578] Hardware name: Renesas H3ULCB board based on r8a77951 (DT)
[  101.967120] Call trace:
[  101.969580]  dump_backtrace+0x0/0x2c0
[  101.973275]  show_stack+0x1c/0x30
[  101.976616]  dump_stack_lvl+0x9c/0xd8
[  101.980301]  print_address_description.constprop.0+0x74/0x2b8
[  101.986071]  kasan_report+0x1f4/0x26c
[  101.989757]  __asan_load8+0x98/0xd4
[  101.993266]  __lock_acquire+0x518/0x25d0
[  101.997215]  lock_acquire.part.0+0x18c/0x360
[  102.001506]  lock_acquire+0x74/0x90
[  102.005013]  _raw_spin_lock_irq+0x98/0x130
[  102.009131]  __pm_runtime_disable+0x30/0x210
[  102.013427]  rpcif_hb_remove+0x5c/0x70 [rpc_if]
[  102.018001]  platform_remove+0x40/0x80
[  102.021771]  __device_release_driver+0x234/0x350
[  102.026412]  driver_detach+0x158/0x20c
[  102.030179]  bus_remove_driver+0xa0/0x140
[  102.034212]  driver_unregister+0x48/0x80
[  102.038153]  platform_driver_unregister+0x18/0x24
[  102.042879]  rpcif_platform_driver_exit+0x1c/0x34 [rpc_if]
[  102.048400]  __arm64_sys_delete_module+0x210/0x310
[  102.053212]  invoke_syscall+0x60/0x190
[  102.056986]  el0_svc_common+0x12c/0x144
[  102.060844]  do_el0_svc+0x88/0xac
[  102.064181]  el0_svc+0x24/0x3c
[  102.067257]  el0t_64_sync_handler+0x1a8/0x1b0
[  102.071634]  el0t_64_sync+0x198/0x19c
[  102.075315]
[  102.076815] Allocated by task 628:
[  102.080781]
[  102.082280] Last potentially related work creation:
[  102.087524]
[  102.089022] The buggy address belongs to the object at ffff0004c5be2000
[  102.089022]  which belongs to the cache kmalloc-2k of size 2048
[  102.101555] The buggy address is located 1872 bytes inside of
[  102.101555]  2048-byte region [ffff0004c5be2000, ffff0004c5be2800)
[  102.113486] The buggy address belongs to the page:
[  102.118409]
[  102.119908] Memory state around the buggy address:
[  102.124711]  ffff0004c5be2600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  102.131947]  ffff0004c5be2680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  102.139181] >ffff0004c5be2700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  102.146412]                                                  ^
[  102.152257]  ffff0004c5be2780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  102.159491]  ffff0004c5be2800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  102.166723] ==================================================================

The above bug is caused by use of the wrong pointer in the
rpcif_disable_rpm() call. Fix the bug by using the correct pointer.

Fixes: 5de15b610f78 ("mtd: hyperbus: add Renesas RPC-IF driver")
Signed-off-by: George G. Davis <davis.george@siemens.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20210716204935.25859-1-george_davis@mentor.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/hyperbus/rpc-if.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/hyperbus/rpc-if.c b/drivers/mtd/hyperbus/rpc-if.c
index 367b0d72bf622..dc164c18f8429 100644
--- a/drivers/mtd/hyperbus/rpc-if.c
+++ b/drivers/mtd/hyperbus/rpc-if.c
@@ -152,9 +152,9 @@ static int rpcif_hb_remove(struct platform_device *pdev)
 {
 	struct rpcif_hyperbus *hyperbus = platform_get_drvdata(pdev);
 	int error = hyperbus_unregister_device(&hyperbus->hbdev);
-	struct rpcif *rpc = dev_get_drvdata(pdev->dev.parent);
 
-	rpcif_disable_rpm(rpc);
+	rpcif_disable_rpm(&hyperbus->rpc);
+
 	return error;
 }
 
-- 
2.34.1



