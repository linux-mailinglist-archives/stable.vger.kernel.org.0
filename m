Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD48E6AEAF0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjCGRis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjCGRi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:38:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6722798E90
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:34:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 040596150E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7AAC433D2;
        Tue,  7 Mar 2023 17:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210458;
        bh=KlI0Af6jzISROLZI1o66mQcCtKGt8CKHC5fBEpIPhFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGiRvvQe1EgnQtNfxRJ3g2f13M95iY4Yp0UVXEET4+KkuayN7OTMvm2Ud6MR2aNaA
         zM6X1JBybggjTz+JaR6/xiutu7uSY/9xwBtMPsFZcks21d4juEO/h/qZYPUGOLLDNY
         P8DnMb/uvOsYBV/M0USlTK4FB0KX5iCf6t1rGDQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Sindhu Devale <sindhu.devale@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0547/1001] RDMA/irdma: Cap MSIX used to online CPUs + 1
Date:   Tue,  7 Mar 2023 17:55:19 +0100
Message-Id: <20230307170045.202396068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 9cd9842c46996ef62173c36619c746f57416bcb0 ]

The irdma driver can use a maximum number of msix vectors equal
to num_online_cpus() + 1 and the kernel warning stack below is shown
if that number is exceeded.

The kernel throws a warning as the driver tries to update the affinity
hint with a CPU mask greater than the max CPU IDs. Fix this by capping
the MSIX vectors to num_online_cpus() + 1.

 WARNING: CPU: 7 PID: 23655 at include/linux/cpumask.h:106 irdma_cfg_ceq_vector+0x34c/0x3f0 [irdma]
 RIP: 0010:irdma_cfg_ceq_vector+0x34c/0x3f0 [irdma]
 Call Trace:
 irdma_rt_init_hw+0xa62/0x1290 [irdma]
 ? irdma_alloc_local_mac_entry+0x1a0/0x1a0 [irdma]
 ? __is_kernel_percpu_address+0x63/0x310
 ? rcu_read_lock_held_common+0xe/0xb0
 ? irdma_lan_unregister_qset+0x280/0x280 [irdma]
 ? irdma_request_reset+0x80/0x80 [irdma]
 ? ice_get_qos_params+0x84/0x390 [ice]
 irdma_probe+0xa40/0xfc0 [irdma]
 ? rcu_read_lock_bh_held+0xd0/0xd0
 ? irdma_remove+0x140/0x140 [irdma]
 ? rcu_read_lock_sched_held+0x62/0xe0
 ? down_write+0x187/0x3d0
 ? auxiliary_match_id+0xf0/0x1a0
 ? irdma_remove+0x140/0x140 [irdma]
 auxiliary_bus_probe+0xa6/0x100
 __driver_probe_device+0x4a4/0xd50
 ? __device_attach_driver+0x2c0/0x2c0
 driver_probe_device+0x4a/0x110
 __driver_attach+0x1aa/0x350
 bus_for_each_dev+0x11d/0x1b0
 ? subsys_dev_iter_init+0xe0/0xe0
 bus_add_driver+0x3b1/0x610
 driver_register+0x18e/0x410
 ? 0xffffffffc0b88000
 irdma_init_module+0x50/0xaa [irdma]
 do_one_initcall+0x103/0x5f0
 ? perf_trace_initcall_level+0x420/0x420
 ? do_init_module+0x4e/0x700
 ? __kasan_kmalloc+0x7d/0xa0
 ? kmem_cache_alloc_trace+0x188/0x2b0
 ? kasan_unpoison+0x21/0x50
 do_init_module+0x1d1/0x700
 load_module+0x3867/0x5260
 ? layout_and_allocate+0x3990/0x3990
 ? rcu_read_lock_held_common+0xe/0xb0
 ? rcu_read_lock_sched_held+0x62/0xe0
 ? rcu_read_lock_bh_held+0xd0/0xd0
 ? __vmalloc_node_range+0x46b/0x890
 ? lock_release+0x5c8/0xba0
 ? alloc_vm_area+0x120/0x120
 ? selinux_kernel_module_from_file+0x2a5/0x300
 ? __inode_security_revalidate+0xf0/0xf0
 ? __do_sys_init_module+0x1db/0x260
 __do_sys_init_module+0x1db/0x260
 ? load_module+0x5260/0x5260
 ? do_syscall_64+0x22/0x450
 do_syscall_64+0xa5/0x450
 entry_SYSCALL_64_after_hwframe+0x66/0xdb

Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Link: https://lore.kernel.org/r/20230207201938.1329-1-sindhu.devale@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index ab246447520bd..2e1e2bad04011 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -483,6 +483,8 @@ static int irdma_save_msix_info(struct irdma_pci_f *rf)
 	iw_qvlist->num_vectors = rf->msix_count;
 	if (rf->msix_count <= num_online_cpus())
 		rf->msix_shared = true;
+	else if (rf->msix_count > num_online_cpus() + 1)
+		rf->msix_count = num_online_cpus() + 1;
 
 	pmsix = rf->msix_entries;
 	for (i = 0, ceq_idx = 0; i < rf->msix_count; i++, iw_qvinfo++) {
-- 
2.39.2



