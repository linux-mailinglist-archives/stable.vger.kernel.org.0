Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774EC32905A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242512AbhCAUHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:07:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235826AbhCATy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8C6B65372;
        Mon,  1 Mar 2021 17:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621302;
        bh=c+Xf1BlEoCxW55UOMBGgTIGAio+vkfJpYHE52gXt9nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN4jVvjDAtXzm7ng/3Wl4QciHvEoU/1A36K41Wt5EaIHJtY3KZaWfdNQHnRHu0aRu
         mHsgAjQLni9JHHqtOMO5nnC/KuutozpYQP3q5wfED5ft6QgowYVhGPgv5f6HlxbM1+
         rwIcb9sZy9fUMFQQPBmWiajSUXQDvj1MyZBe8dYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 436/775] RDMA/siw: Fix calculation of tx_valid_cpus size
Date:   Mon,  1 Mar 2021 17:10:04 +0100
Message-Id: <20210301161223.112203290@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 429fa9698957d1a910535ce5e33aedf5adfdabc1 ]

The size of tx_valid_cpus was calculated under the assumption that the
numa nodes identifiers are continuous, which is not the case in all archs
as this could lead to the following panic when trying to access an invalid
tx_valid_cpus index, avoid the following panic by using nr_node_ids
instead of num_online_nodes() to allocate the tx_valid_cpus size.

   Kernel attempted to read user page (8) - exploit attempt? (uid: 0)
   BUG: Kernel NULL pointer dereference on read at 0x00000008
   Faulting instruction address: 0xc0080000081b4a90
   Oops: Kernel access of bad area, sig: 11 [#1]
   LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA PowerNV
   Modules linked in: siw(+) rfkill rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm sunrpc ib_umad rdma_cm ib_cm iw_cm i40iw ib_uverbs ib_core i40e ses enclosure scsi_transport_sas ipmi_powernv ibmpowernv at24 ofpart ipmi_devintf regmap_i2c ipmi_msghandler powernv_flash uio_pdrv_genirq uio mtd opal_prd zram ip_tables xfs libcrc32c sd_mod t10_pi ast i2c_algo_bit drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm_ttm_helper ttm drm vmx_crypto aacraid drm_panel_orientation_quirks dm_mod
   CPU: 40 PID: 3279 Comm: modprobe Tainted: G        W      X --------- ---  5.11.0-0.rc4.129.eln108.ppc64le #2
   NIP:  c0080000081b4a90 LR: c0080000081b4a2c CTR: c0000000007ce1c0
   REGS: c000000027fa77b0 TRAP: 0300   Tainted: G        W      X --------- ---   (5.11.0-0.rc4.129.eln108.ppc64le)
   MSR:  9000000002009033 <SF,HV,VEC,EE,ME,IR,DR,RI,LE>  CR: 44224882  XER: 00000000
   CFAR: c0000000007ce200 DAR: 0000000000000008 DSISR: 40000000 IRQMASK: 0
   GPR00: c0080000081b4a2c c000000027fa7a50 c0080000081c3900 0000000000000040
   GPR04: c000000002023080 c000000012e1c300 000020072ad70000 0000000000000001
   GPR08: c000000001726068 0000000000000008 0000000000000008 c0080000081b5758
   GPR12: c0000000007ce1c0 c0000007fffc3000 00000001590b1e40 0000000000000000
   GPR16: 0000000000000000 0000000000000001 000000011ad68fc8 00007fffcc09c5c8
   GPR20: 0000000000000008 0000000000000000 00000001590b2850 00000001590b1d30
   GPR24: 0000000000043d68 000000011ad67a80 000000011ad67a80 0000000000100000
   GPR28: c000000012e1c300 c0000000020271c8 0000000000000001 c0080000081bf608
   NIP [c0080000081b4a90] siw_init_cpulist+0x194/0x214 [siw]
   LR [c0080000081b4a2c] siw_init_cpulist+0x130/0x214 [siw]
   Call Trace:
   [c000000027fa7a50] [c0080000081b4a2c] siw_init_cpulist+0x130/0x214 [siw] (unreliable)
   [c000000027fa7a90] [c0080000081b4e68] siw_init_module+0x40/0x2a0 [siw]
   [c000000027fa7b30] [c0000000000124f4] do_one_initcall+0x84/0x2e0
   [c000000027fa7c00] [c000000000267ffc] do_init_module+0x7c/0x350
   [c000000027fa7c90] [c00000000026a180] __do_sys_init_module+0x210/0x250
   [c000000027fa7db0] [c0000000000387e4] system_call_exception+0x134/0x230
   [c000000027fa7e10] [c00000000000d660] system_call_common+0xf0/0x27c
   Instruction dump:
   40810044 3d420000 e8bf0000 e88a82d0 3d420000 e90a82c8 792a1f24 7cc4302a
   7d2642aa 79291f24 7d25482a 7d295214 <7d4048a8> 7d4a3b78 7d4049ad 40c2fff4

Fixes: bdcf26bf9b3a ("rdma/siw: network and RDMA core interface")
Link: https://lore.kernel.org/r/20210201112922.141085-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index ee95cf29179d2..41c46dfaebf66 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -135,7 +135,7 @@ static struct {
 
 static int siw_init_cpulist(void)
 {
-	int i, num_nodes = num_possible_nodes();
+	int i, num_nodes = nr_node_ids;
 
 	memset(siw_tx_thread, 0, sizeof(siw_tx_thread));
 
-- 
2.27.0



