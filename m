Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC06DD655
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 05:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfJSDUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 23:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbfJSDUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 23:20:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B864F2245D;
        Sat, 19 Oct 2019 03:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571455209;
        bh=39Q5BGSUsX/HGz8O7Di3OCyrDcvj/GEGTj9Cpk1q3rA=;
        h=Date:From:To:Subject:From;
        b=X3u3yNo33JaO6IDK66En+kVs+K5z6An6DT5/o70QPhjpYg3OU+YxuwQZc+/4H0Zms
         2HytjByyAWX/3xEkSns88WhRi401o2nl1yYGpP18wtN/3km76JpGEGFCxC7tC7RL62
         voWB4DD8fIc84jmr03HxnBphrKdgyo2AKxnIj9OM=
Date:   Fri, 18 Oct 2019 20:20:08 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        yilikernel@gmail.com
Subject:  [patch 15/26] ocfs2: fix panic due to ocfs2_wq is null
Message-ID: <20191019032008.gi5vt1rJb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Li <yilikernel@gmail.com>
Subject: ocfs2: fix panic due to ocfs2_wq is null

mount.ocfs2 failed when reading ocfs2 filesystem superblock encounters an
error.  ocfs2_initialize_super() returns before allocating ocfs2_wq. 
ocfs2_dismount_volume() triggers the following panic.

  Oct 15 16:09:27 cnwarekv-205120 kernel: On-disk corruption
discovered.Please run fsck.ocfs2 once the filesystem is unmounted.
  Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):
ocfs2_read_locked_inode:537 ERROR: status = -30
  Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):
ocfs2_init_global_system_inodes:458 ERROR: status = -30
  Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):
ocfs2_init_global_system_inodes:491 ERROR: status = -30
  Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):
ocfs2_initialize_super:2313 ERROR: status = -30
  Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44):
ocfs2_fill_super:1033 ERROR: status = -30
  ------------[ cut here ]------------
  Oops: 0002 [#1] SMP NOPTI
  Modules linked in: ocfs2 rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache
lockd grace ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager
ocfs2_stackglue configfs sunrpc ipt_REJECT nf_reject_ipv4
nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT
nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack
ip6table_filter ip6_tables ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 ovmapi ppdev
parport_pc parport fb_sys_fops sysimgblt sysfillrect syscopyarea
acpi_cpufreq pcspkr i2c_piix4 i2c_core sg ext4 jbd2 mbcache2 sr_mod cdrom
  CPU: 1 PID: 11753 Comm: mount.ocfs2 Tainted: G  E
        4.14.148-200.ckv.x86_64 #1
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

Link: http://lkml.kernel.org/r/1571139611-24107-1-git-send-email-yili@winhong.com
Signed-off-by: Yi Li <yilikernel@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c    |    3 ++-
 fs/ocfs2/localalloc.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-fix-panic-due-to-ocfs2_wq-is-null
+++ a/fs/ocfs2/journal.c
@@ -217,7 +217,8 @@ void ocfs2_recovery_exit(struct ocfs2_su
 	/* At this point, we know that no more recovery threads can be
 	 * launched, so wait for any recovery completion work to
 	 * complete. */
-	flush_workqueue(osb->ocfs2_wq);
+	if (osb->ocfs2_wq)
+		flush_workqueue(osb->ocfs2_wq);
 
 	/*
 	 * Now that recovery is shut down, and the osb is about to be
--- a/fs/ocfs2/localalloc.c~ocfs2-fix-panic-due-to-ocfs2_wq-is-null
+++ a/fs/ocfs2/localalloc.c
@@ -377,7 +377,8 @@ void ocfs2_shutdown_local_alloc(struct o
 	struct ocfs2_dinode *alloc = NULL;
 
 	cancel_delayed_work(&osb->la_enable_wq);
-	flush_workqueue(osb->ocfs2_wq);
+	if (osb->ocfs2_wq)
+		flush_workqueue(osb->ocfs2_wq);
 
 	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
 		goto out;
_
