Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2562E407B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390867AbgL1Owr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501963AbgL1OS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA3A2206D4;
        Mon, 28 Dec 2020 14:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165094;
        bh=knmx04ElNEQXe1pqfqequ5Od6CLtzLgVSaUyaCQk6sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zc7oERVXS7wcmsZcc9xctIyYDOqTnmpV6N7KpDcyzRksYmzOpWGLcRWGfPzcjsbAq
         uZYxhrgoJT1fYUqXQDvIt4UfFlWVpHn6YKyVn+rjYQ+Dlr0efXDLOD7Nj0sz4k59ww
         MDdOJz7oWk3ntmOXFWh1oCA4BN3s4LuyHSo4idsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 379/717] scsi: qla2xxx: Fix FW initialization error on big endian machines
Date:   Mon, 28 Dec 2020 13:46:17 +0100
Message-Id: <20201228125039.168657058@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

[ Upstream commit 8a78dd6ed1af06bfa7b4ade81328ff7ea11b6947 ]

Some fields are not correctly byte swapped causing failure during
initialization. As probe() returns failure, HBAs will not be claimed when
this happens.

qla2xxx [0007:01:00.0]-ffff:3: Secure Flash Update in FW: Supported
qla2xxx [0007:01:00.0]-ffff:3: SCM in FW: Supported
qla2xxx [0007:01:00.0]-00d2:3: Init Firmware **** FAILED ****.
qla2xxx [0007:01:00.0]-00d6:3: Failed to initialize adapter - Adapter flags 2.
qla2xxx 0007:01:00.1: enabling device (0140 -> 0142)
qla2xxx [0007:01:00.1]-011c: : MSI-X vector count: 128.
qla2xxx [0007:01:00.1]-001d: : Found an ISP2289 irq 18 iobase 0xd000080080004000.
qla2xxx 0007:01:00.1: Using 64-bit direct DMA at offset 800000000000000
BUG: Bad page state in process insmod  pfn:67118 page:f00000000168bd40
count:-1 mapcount:0 mapping: (null) index:0x0
page flags: 0x3ffff800000000() page dumped because: nonzero _count
Modules linked in: qla2xxx(OE+) nvme_fc nvme_fabrics
	nvme_core scsi_transport_fc scsi_tgt nls_utf8 isofs ip6t_rpfilter
	ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
	nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat
	nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
	ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4
	nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
	iptable_security iptable_raw ebtable_filter ebtables ip6table_filter
	ip6_tables iptable_filter nx_crypto ses enclosure scsi_transport_sas
	pseries_rng sg ip_tables xfs libcrc32c sr_mod cdrom sd_mod crc_t10dif
	crct10dif_generic crct10dif_common usb_storage ipr libata tg3 ptp
	pps_core dm_mirror dm_region_hash dm_log dm_mod
CPU: 32 PID: 8560 Comm: insmod Kdump: loaded Tainted: G
	OE  ------------   3.10.0-957.el7.ppc64 #1
Call Trace:
[c0000006dd7caa70] [c00000000001cca8] .show_stack+0x88/0x330 (unreliable)
[c0000006dd7cab30] [c000000000ac3d88] .dump_stack+0x28/0x3c
[c0000006dd7caba0] [c00000000029e48c] .bad_page+0x15c/0x1c0
[c0000006dd7cac40] [c00000000029f938] .get_page_from_freelist+0x11e8/0x1ea0
[c0000006dd7caf40] [c0000000002a1d30] .__alloc_pages_nodemask+0x1c0/0xc70
[c0000006dd7cb140] [c00000000002ba0c] .__dma_direct_alloc_coherent+0x8c/0x170
[c0000006dd7cb1e0] [d000000010a94688] .qla2x00_mem_alloc+0x10f8/0x1370 [qla2xxx]
[c0000006dd7cb2d0] [d000000010a9c790] .qla2x00_probe_one+0xb60/0x22e0 [qla2xxx]
[c0000006dd7cb540] [c0000000005de764] .pci_device_probe+0x204/0x300
[c0000006dd7cb600] [c0000000006ca61c] .driver_probe_device+0x2cc/0x6f0
[c0000006dd7cb6b0] [c0000000006cabec] .__driver_attach+0x10c/0x110
[c0000006dd7cb740] [c0000000006c5f04] .bus_for_each_dev+0x94/0x100
[c0000006dd7cb7e0] [c0000000006c94f4] .driver_attach+0x34/0x50
[c0000006dd7cb860] [c0000000006c8f58] .bus_add_driver+0x298/0x3b0
[c0000006dd7cb900] [c0000000006cb6e0] .driver_register+0xb0/0x1a0
[c0000006dd7cb980] [c0000000005dc474] .__pci_register_driver+0xc4/0xf0
[c0000006dd7cba10] [d000000010b94e20] .qla2x00_module_init+0x2a8/0x328 [qla2xxx]
[c0000006dd7cbaa0] [c00000000000c130] .do_one_initcall+0x130/0x2e0
[c0000006dd7cbb50] [c0000000001b2e8c] .load_module+0x1afc/0x2340
[c0000006dd7cbd40] [c0000000001b3920] .SyS_finit_module+0xd0/0x130
[c0000006dd7cbe30] [c00000000000a284] 	system_call+0x38/0xfc

Link: https://lore.kernel.org/r/20201202132312.19966-9-njavali@marvell.com
Fixes: 9f2475fe7406 ("scsi: qla2xxx: SAN congestion management implementation")
Fixes: cf3c54fb49a4 ("scsi: qla2xxx: Add SLER and PI control support”)
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 07afd0d8a8f3e..bef871a890281 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1129,7 +1129,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		if (ha->flags.scm_supported_a &&
 		    (ha->fw_attributes_ext[0] & FW_ATTR_EXT0_SCM_SUPPORTED)) {
 			ha->flags.scm_supported_f = 1;
-			ha->sf_init_cb->flags |= BIT_13;
+			ha->sf_init_cb->flags |= cpu_to_le16(BIT_13);
 		}
 		ql_log(ql_log_info, vha, 0x11a3, "SCM in FW: %s\n",
 		       (ha->flags.scm_supported_f) ? "Supported" :
@@ -1137,9 +1137,9 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 
 		if (vha->flags.nvme2_enabled) {
 			/* set BIT_15 of special feature control block for SLER */
-			ha->sf_init_cb->flags |= BIT_15;
+			ha->sf_init_cb->flags |= cpu_to_le16(BIT_15);
 			/* set BIT_14 of special feature control block for PI CTRL*/
-			ha->sf_init_cb->flags |= BIT_14;
+			ha->sf_init_cb->flags |= cpu_to_le16(BIT_14);
 		}
 	}
 
-- 
2.27.0



