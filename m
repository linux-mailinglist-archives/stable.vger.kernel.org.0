Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EC62B6411
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732893AbgKQNkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:40:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732878AbgKQNki (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AC9F207BC;
        Tue, 17 Nov 2020 13:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620437;
        bh=yGkz/vrJaUCwdalWjncXUBGP3eDe5LTO0FTvHWhsL50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASwtGL+QksJUOId8pOKFG3K8pOGksG5qi6a50SnI+Bmu5hanCcUn3aJSFM6cZn7cF
         pOn85NSfqeCML/NXZyFTa74htdM/ilRJV7Y+UVQzPdTADKc48lYZ/FOSPcWN3V5cJc
         eVj8Y/JQ/HT8GdL+SfJeqTOCT2C3R5YShVHWh4fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wengang Wang <wen.gang.wang@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.9 217/255] ocfs2: initialize ip_next_orphan
Date:   Tue, 17 Nov 2020 14:05:57 +0100
Message-Id: <20201117122149.502595336@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wengang Wang <wen.gang.wang@oracle.com>

commit f5785283dd64867a711ca1fb1f5bb172f252ecdf upstream.

Though problem if found on a lower 4.1.12 kernel, I think upstream has
same issue.

In one node in the cluster, there is the following callback trace:

   # cat /proc/21473/stack
   __ocfs2_cluster_lock.isra.36+0x336/0x9e0 [ocfs2]
   ocfs2_inode_lock_full_nested+0x121/0x520 [ocfs2]
   ocfs2_evict_inode+0x152/0x820 [ocfs2]
   evict+0xae/0x1a0
   iput+0x1c6/0x230
   ocfs2_orphan_filldir+0x5d/0x100 [ocfs2]
   ocfs2_dir_foreach_blk+0x490/0x4f0 [ocfs2]
   ocfs2_dir_foreach+0x29/0x30 [ocfs2]
   ocfs2_recover_orphans+0x1b6/0x9a0 [ocfs2]
   ocfs2_complete_recovery+0x1de/0x5c0 [ocfs2]
   process_one_work+0x169/0x4a0
   worker_thread+0x5b/0x560
   kthread+0xcb/0xf0
   ret_from_fork+0x61/0x90

The above stack is not reasonable, the final iput shouldn't happen in
ocfs2_orphan_filldir() function.  Looking at the code,

  2067         /* Skip inodes which are already added to recover list, since dio may
  2068          * happen concurrently with unlink/rename */
  2069         if (OCFS2_I(iter)->ip_next_orphan) {
  2070                 iput(iter);
  2071                 return 0;
  2072         }
  2073

The logic thinks the inode is already in recover list on seeing
ip_next_orphan is non-NULL, so it skip this inode after dropping a
reference which incremented in ocfs2_iget().

While, if the inode is already in recover list, it should have another
reference and the iput() at line 2070 should not be the final iput
(dropping the last reference).  So I don't think the inode is really in
the recover list (no vmcore to confirm).

Note that ocfs2_queue_orphans(), though not shown up in the call back
trace, is holding cluster lock on the orphan directory when looking up
for unlinked inodes.  The on disk inode eviction could involve a lot of
IOs which may need long time to finish.  That means this node could hold
the cluster lock for very long time, that can lead to the lock requests
(from other nodes) to the orhpan directory hang for long time.

Looking at more on ip_next_orphan, I found it's not initialized when
allocating a new ocfs2_inode_info structure.

This causes te reflink operations from some nodes hang for very long
time waiting for the cluster lock on the orphan directory.

Fix: initialize ip_next_orphan as NULL.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201109171746.27884-1-wen.gang.wang@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1713,6 +1713,7 @@ static void ocfs2_inode_init_once(void *
 
 	oi->ip_blkno = 0ULL;
 	oi->ip_clusters = 0;
+	oi->ip_next_orphan = NULL;
 
 	ocfs2_resv_init_once(&oi->ip_la_data_resv);
 


