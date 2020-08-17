Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1429247558
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgHQTWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387401AbgHQPfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:35:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63B0A20709;
        Mon, 17 Aug 2020 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678547;
        bh=Lj2cDuIRJyvNmwWF/RkschS7tY056Y2PZ1WIKLE+tr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFoKYnSZ96E1r3z8OifpLjxzUNmQ1yr2qwthYzTcfHiZ9V8N55FvC5floG4bKKWcX
         JAu8igkvkeroT74dX/KqoAOIpY+s1vxfYRKKFkb0U+rcKTYDIKqXIJtfDxswHK5y2b
         MxlfdL8o/VVPkjeBJwq6Fk5Gh6HleF3UfLb12fGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dean Nelson <dnelson@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 372/464] net: thunderx: initialize VFs mailbox mutex before first usage
Date:   Mon, 17 Aug 2020 17:15:25 +0200
Message-Id: <20200817143851.594294569@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dean Nelson <dnelson@redhat.com>

[ Upstream commit c1055b76ad00aed0e8b79417080f212d736246b6 ]

A VF's mailbox mutex is not getting initialized by nicvf_probe() until after
it is first used. And such usage is resulting in...

[   28.270927] ------------[ cut here ]------------
[   28.270934] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[   28.270980] WARNING: CPU: 9 PID: 675 at kernel/locking/mutex.c:938 __mutex_lock+0xdac/0x12f0
[   28.270985] Modules linked in: ast(+) nicvf(+) i2c_algo_bit drm_vram_helper drm_ttm_helper ttm nicpf(+) drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm ixgbe(+) sg thunder_bgx mdio i2c_thunderx mdio_thunder thunder_xcv mdio_cavium dm_mirror dm_region_hash dm_log dm_mod
[   28.271064] CPU: 9 PID: 675 Comm: systemd-udevd Not tainted 4.18.0+ #1
[   28.271070] Hardware name: GIGABYTE R120-T34-00/MT30-GS2-00, BIOS F02 08/06/2019
[   28.271078] pstate: 60000005 (nZCv daif -PAN -UAO)
[   28.271086] pc : __mutex_lock+0xdac/0x12f0
[   28.271092] lr : __mutex_lock+0xdac/0x12f0
[   28.271097] sp : ffff800d42146fb0
[   28.271103] x29: ffff800d42146fb0 x28: 0000000000000000
[   28.271113] x27: ffff800d24361180 x26: dfff200000000000
[   28.271122] x25: 0000000000000000 x24: 0000000000000002
[   28.271132] x23: ffff20001597cc80 x22: ffff2000139e9848
[   28.271141] x21: 0000000000000000 x20: 1ffff001a8428e0c
[   28.271151] x19: ffff200015d5d000 x18: 1ffff001ae0f2184
[   28.271160] x17: 0000000000000000 x16: 0000000000000000
[   28.271170] x15: ffff800d70790c38 x14: ffff20001597c000
[   28.271179] x13: ffff20001597cc80 x12: ffff040002b2f779
[   28.271189] x11: 1fffe40002b2f778 x10: ffff040002b2f778
[   28.271199] x9 : 0000000000000000 x8 : 00000000f1f1f1f1
[   28.271208] x7 : 00000000f2f2f2f2 x6 : 0000000000000000
[   28.271217] x5 : 1ffff001ae0f2186 x4 : 1fffe400027eb03c
[   28.271227] x3 : dfff200000000000 x2 : ffff1001a8428dbe
[   28.271237] x1 : c87fdfac7ea11d00 x0 : 0000000000000000
[   28.271246] Call trace:
[   28.271254]  __mutex_lock+0xdac/0x12f0
[   28.271261]  mutex_lock_nested+0x3c/0x50
[   28.271297]  nicvf_send_msg_to_pf+0x40/0x3a0 [nicvf]
[   28.271316]  nicvf_register_misc_interrupt+0x20c/0x328 [nicvf]
[   28.271334]  nicvf_probe+0x508/0xda0 [nicvf]
[   28.271344]  local_pci_probe+0xc4/0x180
[   28.271352]  pci_device_probe+0x3ec/0x528
[   28.271363]  driver_probe_device+0x21c/0xb98
[   28.271371]  device_driver_attach+0xe8/0x120
[   28.271379]  __driver_attach+0xe0/0x2a0
[   28.271386]  bus_for_each_dev+0x118/0x190
[   28.271394]  driver_attach+0x48/0x60
[   28.271401]  bus_add_driver+0x328/0x558
[   28.271409]  driver_register+0x148/0x398
[   28.271416]  __pci_register_driver+0x14c/0x1b0
[   28.271437]  nicvf_init_module+0x54/0x10000 [nicvf]
[   28.271447]  do_one_initcall+0x18c/0xc18
[   28.271457]  do_init_module+0x18c/0x618
[   28.271464]  load_module+0x2bc0/0x4088
[   28.271472]  __se_sys_finit_module+0x110/0x188
[   28.271479]  __arm64_sys_finit_module+0x70/0xa0
[   28.271490]  el0_svc_handler+0x15c/0x380
[   28.271496]  el0_svc+0x8/0xc
[   28.271502] irq event stamp: 52649
[   28.271513] hardirqs last  enabled at (52649): [<ffff200011b4d790>] _raw_spin_unlock_irqrestore+0xc0/0xd8
[   28.271522] hardirqs last disabled at (52648): [<ffff200011b4d3c4>] _raw_spin_lock_irqsave+0x3c/0xf0
[   28.271530] softirqs last  enabled at (52330): [<ffff200010082af4>] __do_softirq+0xacc/0x117c
[   28.271540] softirqs last disabled at (52313): [<ffff20001019b354>] irq_exit+0x3cc/0x500
[   28.271545] ---[ end trace a9b90324c8a0d4ee ]---

This problem is resolved by moving the call to mutex_init() up earlier
in nicvf_probe().

Fixes: 609ea65c65a0 ("net: thunderx: add mutex to protect mailbox from concurrent calls for same VF")
Signed-off-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index a82c708a32278..4fee95584e31a 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2180,6 +2180,9 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		nic->max_queues *= 2;
 	nic->ptp_clock = ptp_clock;
 
+	/* Initialize mutex that serializes usage of VF's mailbox */
+	mutex_init(&nic->rx_mode_mtx);
+
 	/* MAP VF's configuration registers */
 	nic->reg_base = pcim_iomap(pdev, PCI_CFG_REG_BAR_NUM, 0);
 	if (!nic->reg_base) {
@@ -2256,7 +2259,6 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&nic->rx_mode_work.work, nicvf_set_rx_mode_task);
 	spin_lock_init(&nic->rx_mode_wq_lock);
-	mutex_init(&nic->rx_mode_mtx);
 
 	err = register_netdev(netdev);
 	if (err) {
-- 
2.25.1



