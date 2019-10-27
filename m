Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4CCE6964
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfJ0VH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728192AbfJ0VH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:07:27 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C3F9214AF;
        Sun, 27 Oct 2019 21:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210446;
        bh=GHu3kxfw3EEQhhSdbxenzvZRkwjxrDM1IARAor+TjfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdHqg3EfKyFr54FP75JSmgXtl4XKVMzOsKIhTVeatsNOcRQjeluzfPH6vKsMBJMPL
         FO9Vaad/9Pu+hyMAE4hcPpCeF+s3fQ/tjXJgOZGb7Uts9ZmCQ9NS3ikt1JedgRqmAn
         RwSQGsYf1kgmFJ89hNoKCBokEM0i/roFeaY96guc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Li <yilikernel@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 018/119] ocfs2: fix panic due to ocfs2_wq is null
Date:   Sun, 27 Oct 2019 21:59:55 +0100
Message-Id: <20191027203305.287771867@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Li <yilikernel@gmail.com>

commit b918c43021baaa3648de09e19a4a3dd555a45f40 upstream.

mount.ocfs2 failed when reading ocfs2 filesystem superblock encounters
an error.  ocfs2_initialize_super() returns before allocating ocfs2_wq.
ocfs2_dismount_volume() triggers the following panic.

  Oct 15 16:09:27 cnwarekv-205120 kernel: On-disk corruption discovered.Please run fsck.ocfs2 once the filesystem is unmounted.
  Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44): ocfs2_read_locked_inode:537 ERROR: status = -30
  Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44): ocfs2_init_global_system_inodes:458 ERROR: status = -30
  Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44): ocfs2_init_global_system_inodes:491 ERROR: status = -30
  Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44): ocfs2_initialize_super:2313 ERROR: status = -30
  Oct 15 16:09:27 cnwarekv-205120 kernel: (mount.ocfs2,22804,44): ocfs2_fill_super:1033 ERROR: status = -30
  ------------[ cut here ]------------
  Oops: 0002 [#1] SMP NOPTI
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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/journal.c    |    3 ++-
 fs/ocfs2/localalloc.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -231,7 +231,8 @@ void ocfs2_recovery_exit(struct ocfs2_su
 	/* At this point, we know that no more recovery threads can be
 	 * launched, so wait for any recovery completion work to
 	 * complete. */
-	flush_workqueue(osb->ocfs2_wq);
+	if (osb->ocfs2_wq)
+		flush_workqueue(osb->ocfs2_wq);
 
 	/*
 	 * Now that recovery is shut down, and the osb is about to be
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -391,7 +391,8 @@ void ocfs2_shutdown_local_alloc(struct o
 	struct ocfs2_dinode *alloc = NULL;
 
 	cancel_delayed_work(&osb->la_enable_wq);
-	flush_workqueue(osb->ocfs2_wq);
+	if (osb->ocfs2_wq)
+		flush_workqueue(osb->ocfs2_wq);
 
 	if (osb->local_alloc_state == OCFS2_LA_UNUSED)
 		goto out;


