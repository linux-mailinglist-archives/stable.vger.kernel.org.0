Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B770020BDEF
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 05:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgF0DdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 23:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgF0DdQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B68652084C;
        Sat, 27 Jun 2020 03:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593228795;
        bh=1uChL96IPy+S65dA+EVRPChxEv+yMikkB43M9rj7GAg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qTjA0KMX6aPrWRFJz6oFzbjaUtSysqacBSTW8nppW3JtG8Nk+vfpqdX01w0GVpDbP
         9BYYIfozKZblNqoqbSIB0TBS5aUj+Hsbbk9i/1wvgcGknr91b6pcqx7FjJcUONukdk
         dRvlLqVn9/wpLjPrnK4oFZe0w/RTrsfmUsA3aRRE=
Date:   Fri, 26 Jun 2020 20:33:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org
Subject:  [merged] ocfs2-fix-panic-on-nfs-server-over-ocfs2.patch
 removed from -mm tree
Message-ID: <20200627033314.f0YEu2VPi%akpm@linux-foundation.org>
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: fix panic on nfs server over ocfs2
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-panic-on-nfs-server-over-ocfs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: fix panic on nfs server over ocfs2

The following kernel panic was captured when running nfs server over
ocfs2, at that time ocfs2_test_inode_bit() was checking whether one inode
locating at "blkno" 5 was valid, that is ocfs2 root inode, its
"suballoc_slot" was OCFS2_INVALID_SLOT(65535) and it was allocted from
//global_inode_alloc, but here it wrongly assumed that it was got from per
slot inode alloctor which would cause array overflow and trigger kernel
panic.

[430033.469151] BUG: unable to handle kernel paging request at
0000000000001088
[430033.469367] IP: [<ffffffff816f6898>] _raw_spin_lock+0x18/0xf0
[430033.469567] PGD 1e06ba067 PUD 1e9e7d067 PMD 0
[430033.469769] Oops: 0002 [#1] SMP
[430033.469975] Modules linked in: tun nfsd lockd grace nfs_acl auth_rpcgss
ocfs2 xen_netback xen_blkback xen_gntalloc xen_gntdev xen_evtchn xenfs
xen_privcmd ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager
ocfs2_stackglue configfs bnx2fc fcoe libfcoe libfc sunrpc bridge 8021q mrp
garp stp llc bonding dm_round_robin scsi_dh_emc dm_multipath iTCO_wdt
iTCO_vendor_support pcspkr sb_edac edac_core i2c_i801 i2c_core lpc_ich
mfd_core sg ext4 jbd2 mbcache2 sd_mod ahci libahci lpfc scsi_transport_fc
be2net vxlan udp_tunnel ip6_udp_tunnel mpt3sas scsi_transport_sas raid_class
crc32c_intel be2iscsi bnx2i cnic uio cxgb4i cxgb4 cxgb3i libcxgbi ipv6 cxgb3
mdio libiscsi_tcp qla4xxx iscsi_boot_sysfs libiscsi scsi_transport_iscsi
dm_mirror dm_region_hash dm_log dm_mod
[430033.472350] CPU: 6 PID: 24873 Comm: nfsd Not tainted
4.1.12-124.36.1.el6uek.x86_64 #2
[430033.472719] Hardware name: Huawei CH121 V3/IT11SGCA1, BIOS 3.87
02/02/2018
[430033.472910] task: ffff88005ae98000 ti: ffff88005ae94000 task.ti:
ffff88005ae94000
[430033.473277] RIP: e030:[<ffffffff816f6898>]  [<ffffffff816f6898>]
_raw_spin_lock+0x18/0xf0
[430033.473655] RSP: e02b:ffff88005ae97908  EFLAGS: 00010206
[430033.473850] RAX: ffff88005ae98000 RBX: 0000000000001088 RCX:
0000000000000000
[430033.474205] RDX: 0000000000020000 RSI: 0000000000000009 RDI:
0000000000001088
[430033.474574] RBP: ffff88005ae97928 R08: 0000000000000000 R09:
ffff880212878e00
[430033.474938] R10: 0000000000007ff0 R11: 0000000000000000 R12:
0000000000001088
[430033.475324] R13: ffff8800063c0aa8 R14: ffff8800650c27d0 R15:
000000000000ffff
[430033.475721] FS:  0000000000000000(0000) GS:ffff880218180000(0000)
knlGS:ffff880218180000
[430033.476199] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[430033.476390] CR2: 0000000000001088 CR3: 00000002033d0000 CR4:
0000000000042660
[430033.476760] Stack:
[430033.476942]  0000000000001000 0000000000001088 ffff8800063c0aa8
ffff8800650c27d0
[430033.477329]  ffff88005ae97948 ffffffff8122a3de 0000000000000009
ffff8800063c0000
[430033.477718]  ffff88005ae979e8 ffffffffc0714e43 ffff88005ae97968
ffff88019de8f958
[430033.478104] Call Trace:
[430033.478286]  [<ffffffff8122a3de>] igrab+0x1e/0x60
[430033.478494]  [<ffffffffc0714e43>] ocfs2_get_system_file_inode+0x63/0x3a0
[ocfs2]
[430033.478870]  [<ffffffffc06a87df>] ? ocfs2_read_blocks_sync+0x13f/0x3c0
[ocfs2]
[430033.479267]  [<ffffffffc06ff2d8>] ocfs2_test_inode_bit+0x328/0xa00
[ocfs2]
[430033.479498]  [<ffffffffc06bef5a>] ocfs2_get_parent+0xba/0x3e0 [ocfs2]
[430033.479730]  [<ffffffff8129b305>] reconnect_path+0xb5/0x300
[430033.479933]  [<ffffffff8129b646>] exportfs_decode_fh+0xf6/0x2b0
[430033.480124]  [<ffffffffc0814af0>] ? nfsd_proc_getattr+0xa0/0xa0 [nfsd]
[430033.480294]  [<ffffffffc081a682>] ? exp_find+0xe2/0x190 [nfsd]
[430033.480461]  [<ffffffff810e5a7e>] ? irq_get_irq_data+0xe/0x10
[430033.480627]  [<ffffffff810ea1a7>] ? __call_rcu_nocb_enqueue+0xd7/0xe0
[430033.480794]  [<ffffffff810eb9e8>] ? __call_rcu+0xe8/0x360
[430033.480959]  [<ffffffffc0815860>] fh_verify+0x350/0x660 [nfsd]
[430033.481134]  [<ffffffffc0535076>] ? cache_check+0x56/0x3a0 [sunrpc]
[430033.481317]  [<ffffffffc0823a4d>] nfsd4_putfh+0x4d/0x60 [nfsd]
[430033.481505]  [<ffffffffc0826003>] nfsd4_proc_compound+0x3d3/0x6f0 [nfsd]
[430033.481730]  [<ffffffffc0811f60>] nfsd_dispatch+0xe0/0x290 [nfsd]
[430033.481950]  [<ffffffffc052b752>] ? svc_tcp_adjust_wspace+0x12/0x30
[sunrpc]
[430033.482152]  [<ffffffffc052a512>] svc_process_common+0x412/0x6a0 [sunrpc]
[430033.482351]  [<ffffffffc052a8c3>] svc_process+0x123/0x210 [sunrpc]
[430033.482550]  [<ffffffffc081190f>] nfsd+0xff/0x170 [nfsd]
[430033.482744]  [<ffffffffc0811810>] ? nfsd_destroy+0x80/0x80 [nfsd]
[430033.482943]  [<ffffffff810a7aeb>] kthread+0xcb/0xf0
[430033.483151]  [<ffffffff816f10ea>] ? __schedule+0x24a/0x810
[430033.483354]  [<ffffffff816f10ea>] ? __schedule+0x24a/0x810
[430033.483553]  [<ffffffff810a7a20>] ? kthread_create_on_node+0x180/0x180
[430033.483777]  [<ffffffff816f72a1>] ret_from_fork+0x61/0x90
[430033.483976]  [<ffffffff810a7a20>] ? kthread_create_on_node+0x180/0x180
[430033.484191] Code: 83 c2 02 0f b7 f2 e8 18 dc 91 ff 66 90 eb bf 0f 1f 40
00 55 48 89 e5 41 56 41 55 41 54 53 0f 1f 44 00 00 48 89 fb ba 00 00 02 00
<f0> 0f c1 17 89 d0 45 31 e4 45 31 ed c1 e8 10 66 39 d0 41 89 c6
[430033.485174] RIP  [<ffffffff816f6898>] _raw_spin_lock+0x18/0xf0
[430033.485370]  RSP <ffff88005ae97908>
[430033.485566] CR2: 0000000000001088
[430033.486223] ---[ end trace 7264463cd1aac8f9 ]---
[430033.666368] Kernel panic - not syncing: Fatal exception

Link: http://lkml.kernel.org/r/20200616183829.87211-4-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/suballoc.c~ocfs2-fix-panic-on-nfs-server-over-ocfs2
+++ a/fs/ocfs2/suballoc.c
@@ -2825,9 +2825,12 @@ int ocfs2_test_inode_bit(struct ocfs2_su
 		goto bail;
 	}
 
-	inode_alloc_inode =
-		ocfs2_get_system_file_inode(osb, INODE_ALLOC_SYSTEM_INODE,
-					    suballoc_slot);
+	if (suballoc_slot == (u16)OCFS2_INVALID_SLOT)
+		inode_alloc_inode = ocfs2_get_system_file_inode(osb,
+			GLOBAL_INODE_ALLOC_SYSTEM_INODE, suballoc_slot);
+	else
+		inode_alloc_inode = ocfs2_get_system_file_inode(osb,
+			INODE_ALLOC_SYSTEM_INODE, suballoc_slot);
 	if (!inode_alloc_inode) {
 		/* the error code could be inaccurate, but we are not able to
 		 * get the correct one. */
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are


