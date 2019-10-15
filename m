Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15870D71A0
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 10:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbfJOI4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 04:56:07 -0400
Received: from regular1.263xmail.com ([211.150.70.206]:52688 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbfJOI4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 04:56:07 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2019 04:56:04 EDT
Received: from localhost (unknown [192.168.167.177])
        by regular1.263xmail.com (Postfix) with ESMTP id 6155C446;
        Tue, 15 Oct 2019 16:48:09 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [14.18.236.69])
        by smtp.263.net (postfix) whith ESMTP id P25598T140291575101184S1571129275418300_;
        Tue, 15 Oct 2019 16:48:10 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <92ecf1971a239bca4301e37177ddeafb>
X-RL-SENDER: yili@winhong.com
X-SENDER: yili@winhong.com
X-LOGIN-NAME: yili@winhong.com
X-FST-TO: stable@vger.kernel.org
X-SENDER-IP: 14.18.236.69
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From:   Yi Li <yili@winhong.com>
To:     stable@vger.kernel.org
Cc:     yili@winhong.com, Yi Li <yilikernel@gmail.com>
Subject: [PATCH] ocfs2: fix panic due to ocfs2_wq is null
Date:   Tue, 15 Oct 2019 16:47:35 +0800
Message-Id: <1571129255-1617-1-git-send-email-yili@winhong.com>
X-Mailer: git-send-email 2.7.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mount.ocfs2 failed when read ocfs2 filesystem super error.
the func ocfs2_initialize_super will return before allocate ocfs2_wq.
ocfs2_dismount_volume will flush the ocfs2_wq, that triggered the following panic.

Oct 15 16:09:27 cnwarekv-205120 kernel: OCFS2: ERROR (device dm-34): ocfs2_validate_inode_block: Invalid dinode #513: fs_generation is 1837764116
Oct 15 16:09:27 cnwarekv-205120 kernel: On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
Oct 15 16:09:27 cnwarekv-205120 kernel: OCFS2: File system is now read-only.
Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):ocfs2_read_locked_inode:537 ERROR: status = -30
Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):ocfs2_init_global_system_inodes:458 ERROR: status = -30
Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):ocfs2_init_global_system_inodes:491 ERROR: status = -30
Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):ocfs2_initialize_super:2313 ERROR: status = -30
Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):ocfs2_fill_super:1033 ERROR: status = -30
------------[ cut here ]------------
Oops: 0002 [#1] SMP NOPTI
Modules linked in: ocfs2 rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd grace ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs sunrpc ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 ovmapi ppdev parport_pc parport xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea acpi_cpufreq pcspkr i2c_piix4 i2c_core sg ext4 jbd2 mbcache2 sr_mod cdrom xen_blkfront pata_acpi ata_generic ata_piix floppy dm_mirror dm_region_hash dm_log dm_mod
CPU: 1 PID: 11753 Comm: mount.ocfs2 Tainted: G  E	4.14.148-200.ckv.x86_64 #1
Hardware name: Sugon H320-G30/35N16-US, BIOS 0SSDX017 12/21/2018
task: ffff967af0520000 task.stack: ffffa5f05484000
RIP: 0010:mutex_lock+0x19/0x20
Call Trace:
  flush_workqueue+0x81/0x460
  ocfs2_shutdown_local_alloc+0x47/0x440 [ocfs2]
  ocfs2_dismount_volume+0x84/0x400 [ocfs2]
  ocfs2_fill_super+0xa4/0x1270 [ocfs2]
  ? ocfs2_initialize_super.isa.211+0xf20/0xf20 [ocfs2]
  mount_bdev+0x17f/0x1c0
  mount_fs+0x3a/0x160

Signed-off-by: Yi Li <yilikernel@gmail.com>
---
 fs/ocfs2/localalloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 158e5af..943e5c3 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -377,7 +377,9 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	struct ocfs2_dinode *alloc = NULL;
 
 	cancel_delayed_work(&osb->la_enable_wq);
-	flush_workqueue(osb->ocfs2_wq);
+	if (osb->ocfs2_wq) {
+	    flush_workqueue(osb->ocfs2_wq);
+	}
 
 	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
 		goto out;
-- 
2.7.5



