Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EAE6433DF
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiLETk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbiLETkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7423F27CD0
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:37:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0962BB811F3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE77C433C1;
        Mon,  5 Dec 2022 19:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269032;
        bh=p4Et3VxSSb3SYl1187Wm3HVHlTpWjqLEiI9U13Lxb8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7XC7qRpIHCcuQ3lNdBoix+foPROAyFztqDfZpGqmH1HLBEbLcDm9F1pFrgTgy6L3
         NQYcDJSZjNS+b+Pt2wSwJTHoAsdummdrhgr7rZmDMDDM/P5AclJy0zi3x/4IqozBOz
         U8Mi30bELZWobaJhH/WlOxK2Y3797lghCKJlVQy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Caleb Sander <csander@purestorage.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/120] nvme: fix SRCU protection of nvme_ns_head list
Date:   Mon,  5 Dec 2022 20:10:40 +0100
Message-Id: <20221205190809.557044104@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Caleb Sander <csander@purestorage.com>

[ Upstream commit 899d2a05dc14733cfba6224083c6b0dd5a738590 ]

Walking the nvme_ns_head siblings list is protected by the head's srcu
in nvme_ns_head_submit_bio() but not nvme_mpath_revalidate_paths().
Removing namespaces from the list also fails to synchronize the srcu.
Concurrent scan work can therefore cause use-after-frees.

Hold the head's srcu lock in nvme_mpath_revalidate_paths() and
synchronize with the srcu, not the global RCU, in nvme_ns_remove().

Observed the following panic when making NVMe/RDMA connections
with native multipath on the Rocky Linux 8.6 kernel
(it seems the upstream kernel has the same race condition).
Disassembly shows the faulting instruction is cmp 0x50(%rdx),%rcx;
computing capacity !=3D get_capacity(ns->disk).
Address 0x50 is dereferenced because ns->disk is NULL.
The NULL disk appears to be the result of concurrent scan work
freeing the namespace (note the log line in the middle of the panic).

[37314.206036] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000050
[37314.206036] nvme0n3: detected capacity change from 0 to 11811160064
[37314.299753] PGD 0 P4D 0
[37314.299756] Oops: 0000 [#1] SMP PTI
[37314.299759] CPU: 29 PID: 322046 Comm: kworker/u98:3 Kdump: loaded Tainte=
d: G        W      X --------- -  - 4.18.0-372.32.1.el8test86.x86_64 #1
[37314.299762] Hardware name: Dell Inc. PowerEdge R720/0JP31P, BIOS 2.7.0 0=
5/23/2018
[37314.299763] Workqueue: nvme-wq nvme_scan_work [nvme_core]
[37314.299783] RIP: 0010:nvme_mpath_revalidate_paths+0x26/0xb0 [nvme_core]
[37314.299790] Code: 1f 44 00 00 66 66 66 66 90 55 53 48 8b 5f 50 48 8b 83 =
c8 c9 00 00 48 8b 13 48 8b 48 50 48 39 d3 74 20 48 8d 42 d0 48 8b 50 20 <48=
> 3b 4a 50 74 05 f0 80 60 70 ef 48 8b 50 30 48 8d 42 d0 48 39 d3
[37315.058803] RSP: 0018:ffffabe28f913d10 EFLAGS: 00010202
[37315.121316] RAX: ffff927a077da800 RBX: ffff92991dd70000 RCX: 00000000016=
00000
[37315.206704] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff92991b7=
19800
[37315.292106] RBP: ffff929a6b70c000 R08: 000000010234cd4a R09: c0000000fff=
f7fff
[37315.377501] R10: 0000000000000001 R11: ffffabe28f913a30 R12: 00000000000=
00000
[37315.462889] R13: ffff92992716600c R14: ffff929964e6e030 R15: ffff92991dd=
70000
[37315.548286] FS:  0000000000000000(0000) GS:ffff92b87fb80000(0000) knlGS:=
0000000000000000
[37315.645111] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37315.713871] CR2: 0000000000000050 CR3: 0000002208810006 CR4: 00000000000=
606e0
[37315.799267] Call Trace:
[37315.828515]  nvme_update_ns_info+0x1ac/0x250 [nvme_core]
[37315.892075]  nvme_validate_or_alloc_ns+0x2ff/0xa00 [nvme_core]
[37315.961871]  ? __blk_mq_free_request+0x6b/0x90
[37316.015021]  nvme_scan_work+0x151/0x240 [nvme_core]
[37316.073371]  process_one_work+0x1a7/0x360
[37316.121318]  ? create_worker+0x1a0/0x1a0
[37316.168227]  worker_thread+0x30/0x390
[37316.212024]  ? create_worker+0x1a0/0x1a0
[37316.258939]  kthread+0x10a/0x120
[37316.297557]  ? set_kthread_struct+0x50/0x50
[37316.347590]  ret_from_fork+0x35/0x40
[37316.390360] Modules linked in: nvme_rdma nvme_tcp(X) nvme_fabrics nvme_c=
ore netconsole iscsi_tcp libiscsi_tcp dm_queue_length dm_service_time nf_co=
nntrack_netlink br_netfilter bridge stp llc overlay nft_chain_nat ipt_MASQU=
ERADE nf_nat xt_addrtype xt_CT nft_counter xt_state xt_conntrack nf_conntra=
ck nf_defrag_ipv6 nf_defrag_ipv4 xt_comment xt_multiport nft_compat nf_tabl=
es libcrc32c nfnetlink dm_multipath tg3 rpcrdma sunrpc rdma_ucm ib_srpt ib_=
isert iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscs=
i ib_umad rdma_cm ib_ipoib iw_cm ib_cm intel_rapl_msr iTCO_wdt iTCO_vendor_=
support dcdbas intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powercl=
amp coretemp kvm_intel ipmi_ssif kvm irqbypass crct10dif_pclmul crc32_pclmu=
l mlx5_ib ghash_clmulni_intel ib_uverbs rapl intel_cstate intel_uncore ib_c=
ore ipmi_si joydev mei_me pcspkr ipmi_devintf mei lpc_ich wmi ipmi_msghandl=
er acpi_power_meter ext4 mbcache jbd2 sd_mod t10_pi sg mgag200 mlx5_core dr=
m_kms_helper syscopyarea
[37316.390419]  sysfillrect ahci sysimgblt fb_sys_fops libahci drm crc32c_i=
ntel libata mlxfw pci_hyperv_intf tls i2c_algo_bit psample dm_mirror dm_reg=
ion_hash dm_log dm_mod fuse [last unloaded: nvme_core]
[37317.645908] CR2: 0000000000000050

Fixes: e7d65803e2bb ("nvme-multipath: revalidate paths during rescan")
Signed-off-by: Caleb Sander <csander@purestorage.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      | 2 +-
 drivers/nvme/host/multipath.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 92fe67bd2457..694373951b18 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3920,7 +3920,7 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 	mutex_unlock(&ns->ctrl->subsys->lock);
=20
 	/* guarantee not available in head->list */
-	synchronize_rcu();
+	synchronize_srcu(&ns->head->srcu);
=20
 	/* wait for concurrent submissions */
 	if (nvme_mpath_clear_current_path(ns))
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 36b48e2ff642..fe199d568a4a 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -151,11 +151,14 @@ void nvme_mpath_revalidate_paths(struct nvme_ns *ns)
 	struct nvme_ns_head *head =3D ns->head;
 	sector_t capacity =3D get_capacity(head->disk);
 	int node;
+	int srcu_idx;
=20
+	srcu_idx =3D srcu_read_lock(&head->srcu);
 	list_for_each_entry_rcu(ns, &head->list, siblings) {
 		if (capacity !=3D get_capacity(ns->disk))
 			clear_bit(NVME_NS_READY, &ns->flags);
 	}
+	srcu_read_unlock(&head->srcu, srcu_idx);
=20
 	for_each_node(node)
 		rcu_assign_pointer(head->current_path[node], NULL);
--=20
2.35.1



