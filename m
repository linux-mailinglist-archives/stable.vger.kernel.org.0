Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F05F5EA430
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiIZLlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238306AbiIZLlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:41:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3216EF36;
        Mon, 26 Sep 2022 03:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79495B802C7;
        Mon, 26 Sep 2022 10:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E84FC433C1;
        Mon, 26 Sep 2022 10:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188760;
        bh=y/gALYPVLhY1t540ccqNSN5HhB15eObVd05zhhOGZDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exrcOkaVc1CrkmVfu04AkPCoDEnx+EFe1Doe1jZYtPaXrDzYLEIB60+XFFfh1V+SJ
         P8en0IA+XiREPxq/4XoLh28MOw69HS0GDSnzsp9YLlYkU6SQY6mmZgmyB3Izlj0sR7
         iaci4sYoRHvPsuxqPs166KmEK29bF4nnfxZmsRaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Maki <joamaki@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/148] bonding: fix NULL deref in bond_rr_gen_slave_id
Date:   Mon, 26 Sep 2022 12:12:26 +0200
Message-Id: <20220926100800.331321356@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Toppins <jtoppins@redhat.com>

[ Upstream commit 0e400d602f46360752e4b32ce842dba3808e15e6 ]

Fix a NULL dereference of the struct bonding.rr_tx_counter member because
if a bond is initially created with an initial mode != zero (Round Robin)
the memory required for the counter is never created and when the mode is
changed there is never any attempt to verify the memory is allocated upon
switching modes.

This causes the following Oops on an aarch64 machine:
    [  334.686773] Unable to handle kernel paging request at virtual address ffff2c91ac905000
    [  334.694703] Mem abort info:
    [  334.697486]   ESR = 0x0000000096000004
    [  334.701234]   EC = 0x25: DABT (current EL), IL = 32 bits
    [  334.706536]   SET = 0, FnV = 0
    [  334.709579]   EA = 0, S1PTW = 0
    [  334.712719]   FSC = 0x04: level 0 translation fault
    [  334.717586] Data abort info:
    [  334.720454]   ISV = 0, ISS = 0x00000004
    [  334.724288]   CM = 0, WnR = 0
    [  334.727244] swapper pgtable: 4k pages, 48-bit VAs, pgdp=000008044d662000
    [  334.733944] [ffff2c91ac905000] pgd=0000000000000000, p4d=0000000000000000
    [  334.740734] Internal error: Oops: 96000004 [#1] SMP
    [  334.745602] Modules linked in: bonding tls veth rfkill sunrpc arm_spe_pmu vfat fat acpi_ipmi ipmi_ssif ixgbe igb i40e mdio ipmi_devintf ipmi_msghandler arm_cmn arm_dsu_pmu cppc_cpufreq acpi_tad fuse zram crct10dif_ce ast ghash_ce sbsa_gwdt nvme drm_vram_helper drm_ttm_helper nvme_core ttm xgene_hwmon
    [  334.772217] CPU: 7 PID: 2214 Comm: ping Not tainted 6.0.0-rc4-00133-g64ae13ed4784 #4
    [  334.779950] Hardware name: GIGABYTE R272-P31-00/MP32-AR1-00, BIOS F18v (SCP: 1.08.20211002) 12/01/2021
    [  334.789244] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
    [  334.796196] pc : bond_rr_gen_slave_id+0x40/0x124 [bonding]
    [  334.801691] lr : bond_xmit_roundrobin_slave_get+0x38/0xdc [bonding]
    [  334.807962] sp : ffff8000221733e0
    [  334.811265] x29: ffff8000221733e0 x28: ffffdbac8572d198 x27: ffff80002217357c
    [  334.818392] x26: 000000000000002a x25: ffffdbacb33ee000 x24: ffff07ff980fa000
    [  334.825519] x23: ffffdbacb2e398ba x22: ffff07ff98102000 x21: ffff07ff981029c0
    [  334.832646] x20: 0000000000000001 x19: ffff07ff981029c0 x18: 0000000000000014
    [  334.839773] x17: 0000000000000000 x16: ffffdbacb1004364 x15: 0000aaaabe2f5a62
    [  334.846899] x14: ffff07ff8e55d968 x13: ffff07ff8e55db30 x12: 0000000000000000
    [  334.854026] x11: ffffdbacb21532e8 x10: 0000000000000001 x9 : ffffdbac857178ec
    [  334.861153] x8 : ffff07ff9f6e5a28 x7 : 0000000000000000 x6 : 000000007c2b3742
    [  334.868279] x5 : ffff2c91ac905000 x4 : ffff2c91ac905000 x3 : ffff07ff9f554400
    [  334.875406] x2 : ffff2c91ac905000 x1 : 0000000000000001 x0 : ffff07ff981029c0
    [  334.882532] Call trace:
    [  334.884967]  bond_rr_gen_slave_id+0x40/0x124 [bonding]
    [  334.890109]  bond_xmit_roundrobin_slave_get+0x38/0xdc [bonding]
    [  334.896033]  __bond_start_xmit+0x128/0x3a0 [bonding]
    [  334.901001]  bond_start_xmit+0x54/0xb0 [bonding]
    [  334.905622]  dev_hard_start_xmit+0xb4/0x220
    [  334.909798]  __dev_queue_xmit+0x1a0/0x720
    [  334.913799]  arp_xmit+0x3c/0xbc
    [  334.916932]  arp_send_dst+0x98/0xd0
    [  334.920410]  arp_solicit+0xe8/0x230
    [  334.923888]  neigh_probe+0x60/0xb0
    [  334.927279]  __neigh_event_send+0x3b0/0x470
    [  334.931453]  neigh_resolve_output+0x70/0x90
    [  334.935626]  ip_finish_output2+0x158/0x514
    [  334.939714]  __ip_finish_output+0xac/0x1a4
    [  334.943800]  ip_finish_output+0x40/0xfc
    [  334.947626]  ip_output+0xf8/0x1a4
    [  334.950931]  ip_send_skb+0x5c/0x100
    [  334.954410]  ip_push_pending_frames+0x3c/0x60
    [  334.958758]  raw_sendmsg+0x458/0x6d0
    [  334.962325]  inet_sendmsg+0x50/0x80
    [  334.965805]  sock_sendmsg+0x60/0x6c
    [  334.969286]  __sys_sendto+0xc8/0x134
    [  334.972853]  __arm64_sys_sendto+0x34/0x4c
    [  334.976854]  invoke_syscall+0x78/0x100
    [  334.980594]  el0_svc_common.constprop.0+0x4c/0xf4
    [  334.985287]  do_el0_svc+0x38/0x4c
    [  334.988591]  el0_svc+0x34/0x10c
    [  334.991724]  el0t_64_sync_handler+0x11c/0x150
    [  334.996072]  el0t_64_sync+0x190/0x194
    [  334.999726] Code: b9001062 f9403c02 d53cd044 8b040042 (b8210040)
    [  335.005810] ---[ end trace 0000000000000000 ]---
    [  335.010416] Kernel panic - not syncing: Oops: Fatal exception in interrupt
    [  335.017279] SMP: stopping secondary CPUs
    [  335.021374] Kernel Offset: 0x5baca8eb0000 from 0xffff800008000000
    [  335.027456] PHYS_OFFSET: 0x80000000
    [  335.030932] CPU features: 0x0000,0085c029,19805c82
    [  335.035713] Memory Limit: none
    [  335.038756] Rebooting in 180 seconds..

The fix is to allocate the memory in bond_open() which is guaranteed
to be called before any packets are processed.

Fixes: 848ca9182a7d ("net: bonding: Use per-cpu rr_tx_counter")
CC: Jussi Maki <joamaki@gmail.com>
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 01d2c0591eb8..402dffc508ef 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3930,6 +3930,12 @@ static int bond_open(struct net_device *bond_dev)
 	struct list_head *iter;
 	struct slave *slave;
 
+	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN && !bond->rr_tx_counter) {
+		bond->rr_tx_counter = alloc_percpu(u32);
+		if (!bond->rr_tx_counter)
+			return -ENOMEM;
+	}
+
 	/* reset slave->backup and slave->inactive */
 	if (bond_has_slaves(bond)) {
 		bond_for_each_slave(bond, slave, iter) {
@@ -5907,15 +5913,6 @@ static int bond_init(struct net_device *bond_dev)
 	if (!bond->wq)
 		return -ENOMEM;
 
-	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN) {
-		bond->rr_tx_counter = alloc_percpu(u32);
-		if (!bond->rr_tx_counter) {
-			destroy_workqueue(bond->wq);
-			bond->wq = NULL;
-			return -ENOMEM;
-		}
-	}
-
 	spin_lock_init(&bond->stats_lock);
 	netdev_lockdep_set_classes(bond_dev);
 
-- 
2.35.1



