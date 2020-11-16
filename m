Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329812B5008
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgKPSlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:41:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgKPSlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 13:41:47 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB35E20888;
        Mon, 16 Nov 2020 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605552105;
        bh=uIpvrMnfZiHC2X8YfNJV3paHWMO6Z7xOhywLgcTsMgM=;
        h=Date:From:To:Subject:From;
        b=nPJLfRXBz9V2uRle3TXM5uChMvpBY5UTBHzN8hi5AP2JZJM5aK8R7TJeOzMq7yOL5
         RCYeuSLNsiKT1hq/oFVj0C5TWmxAFBhSD2bLF86Y82ijWpwK9XtiYjDU+/inlDXJhb
         RE9HGbFD6wcPkBacRPVwLa5Rwp12DYEm52XvBA5E=
Date:   Mon, 16 Nov 2020 10:41:44 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org, wen.gang.wang@oracle.com
Subject:  [merged] ocfs2-initialize-ip_next_orphan.patch removed
 from -mm tree
Message-ID: <20201116184144.bLK1ChtmF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: initialize ip_next_orphan
has been removed from the -mm tree.  Its filename was
     ocfs2-initialize-ip_next_orphan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: initialize ip_next_orphan

Though problem if found on a lower 4.1.12 kernel, I think upstream has
same issue.

In one node in the cluster, there is the following callback trace:

# cat /proc/21473/stack
[<ffffffffc09a2f06>] __ocfs2_cluster_lock.isra.36+0x336/0x9e0 [ocfs2]
[<ffffffffc09a4481>] ocfs2_inode_lock_full_nested+0x121/0x520 [ocfs2]
[<ffffffffc09b2ce2>] ocfs2_evict_inode+0x152/0x820 [ocfs2]
[<ffffffff8122b36e>] evict+0xae/0x1a0
[<ffffffff8122bd26>] iput+0x1c6/0x230
[<ffffffffc09b60ed>] ocfs2_orphan_filldir+0x5d/0x100 [ocfs2]
[<ffffffffc0992ae0>] ocfs2_dir_foreach_blk+0x490/0x4f0 [ocfs2]
[<ffffffffc099a1e9>] ocfs2_dir_foreach+0x29/0x30 [ocfs2]
[<ffffffffc09b7716>] ocfs2_recover_orphans+0x1b6/0x9a0 [ocfs2]
[<ffffffffc09b9b4e>] ocfs2_complete_recovery+0x1de/0x5c0 [ocfs2]
[<ffffffff810a1399>] process_one_work+0x169/0x4a0
[<ffffffff810a1bcb>] worker_thread+0x5b/0x560
[<ffffffff810a7a2b>] kthread+0xcb/0xf0
[<ffffffff816f5d21>] ret_from_fork+0x61/0x90
[<ffffffffffffffff>] 0xffffffffffffffff

The above stack is not reasonable, the final iput shouldn't happen in
ocfs2_orphan_filldir() function. Looking at the code,

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
trace, is holding cluster lock on the orphan directory when looking up for
unlinked inodes.  The on disk inode eviction could involve a lot of IOs
which may need long time to finish.  That means this node could hold the
cluster lock for very long time, that can lead to the lock requests (from
other nodes) to the orhpan directory hang for long time.

Looking at more on ip_next_orphan, I found it's not initialized when
allocating a new ocfs2_inode_info structure.

This causes te reflink operations from some nodes hang for very long
time waiting for the cluster lock on the orphan directory.

Fix: initialize ip_next_orphan as NULL.

Link: https://lkml.kernel.org/r/20201109171746.27884-1-wen.gang.wang@oracle.com
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
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

 fs/ocfs2/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/super.c~ocfs2-initialize-ip_next_orphan
+++ a/fs/ocfs2/super.c
@@ -1713,6 +1713,7 @@ static void ocfs2_inode_init_once(void *
 
 	oi->ip_blkno = 0ULL;
 	oi->ip_clusters = 0;
+	oi->ip_next_orphan = NULL;
 
 	ocfs2_resv_init_once(&oi->ip_la_data_resv);
 
_

Patches currently in -mm which might be from wen.gang.wang@oracle.com are


