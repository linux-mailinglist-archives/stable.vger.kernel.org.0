Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0802400EC
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 04:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgHJCe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 22:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1A48206C3;
        Mon, 10 Aug 2020 02:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026866;
        bh=7BlARFhx/MK1YeaCmaiwzsMzuvd4acIcreoHEWobrH0=;
        h=Date:From:To:Subject:From;
        b=vDlmKjeD7VcgHN00A+8FjBVNuErtgp1i1QvSUOtYe912p2NCasvBW3Uh1BeXT7UWE
         4oiFqdBsC9asYkUyfU74cp5q+L5vHPsz5By3uZl/tG2ukX1Xdt0ne43ibVecSdzapq
         CU8A8w0LhCJYdCrAxkgRxdPMcIDkwoH8YVjsLx0E=
Date:   Sun, 09 Aug 2020 19:34:25 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, stable@vger.kernel.org
Subject:  [merged] ocfs2-change-slot-number-type-s16-to-u16.patch
 removed from -mm tree
Message-ID: <20200810023425.MG_JvF1Gq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: change slot number type s16 to u16
has been removed from the -mm tree.  Its filename was
     ocfs2-change-slot-number-type-s16-to-u16.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: change slot number type s16 to u16

Dan Carpenter reported the following static checker warning.

	fs/ocfs2/super.c:1269 ocfs2_parse_options() warn: '(-1)' 65535 can't fit into 32767 'mopt->slot'
	fs/ocfs2/suballoc.c:859 ocfs2_init_inode_steal_slot() warn: '(-1)' 65535 can't fit into 32767 'osb->s_inode_steal_slot'
	fs/ocfs2/suballoc.c:867 ocfs2_init_meta_steal_slot() warn: '(-1)' 65535 can't fit into 32767 'osb->s_meta_steal_slot'

That's because OCFS2_INVALID_SLOT is (u16)-1. Slot number in ocfs2 can be
never negative, so change s16 to u16.

Link: http://lkml.kernel.org/r/20200627001259.19757-1-junxiao.bi@oracle.com
Fixes: 9277f8334ffc ("ocfs2: fix value of OCFS2_INVALID_SLOT")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h    |    4 ++--
 fs/ocfs2/suballoc.c |    4 ++--
 fs/ocfs2/super.c    |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/ocfs2.h~ocfs2-change-slot-number-type-s16-to-u16
+++ a/fs/ocfs2/ocfs2.h
@@ -327,8 +327,8 @@ struct ocfs2_super
 	spinlock_t osb_lock;
 	u32 s_next_generation;
 	unsigned long osb_flags;
-	s16 s_inode_steal_slot;
-	s16 s_meta_steal_slot;
+	u16 s_inode_steal_slot;
+	u16 s_meta_steal_slot;
 	atomic_t s_num_inodes_stolen;
 	atomic_t s_num_meta_stolen;
 
--- a/fs/ocfs2/suballoc.c~ocfs2-change-slot-number-type-s16-to-u16
+++ a/fs/ocfs2/suballoc.c
@@ -879,9 +879,9 @@ static void __ocfs2_set_steal_slot(struc
 {
 	spin_lock(&osb->osb_lock);
 	if (type == INODE_ALLOC_SYSTEM_INODE)
-		osb->s_inode_steal_slot = slot;
+		osb->s_inode_steal_slot = (u16)slot;
 	else if (type == EXTENT_ALLOC_SYSTEM_INODE)
-		osb->s_meta_steal_slot = slot;
+		osb->s_meta_steal_slot = (u16)slot;
 	spin_unlock(&osb->osb_lock);
 }
 
--- a/fs/ocfs2/super.c~ocfs2-change-slot-number-type-s16-to-u16
+++ a/fs/ocfs2/super.c
@@ -78,7 +78,7 @@ struct mount_options
 	unsigned long	commit_interval;
 	unsigned long	mount_opt;
 	unsigned int	atime_quantum;
-	signed short	slot;
+	unsigned short	slot;
 	int		localalloc_opt;
 	unsigned int	resv_level;
 	int		dir_resv_level;
@@ -1349,7 +1349,7 @@ static int ocfs2_parse_options(struct su
 				goto bail;
 			}
 			if (option)
-				mopt->slot = (s16)option;
+				mopt->slot = (u16)option;
 			break;
 		case Opt_commit:
 			if (match_int(&args[0], &option)) {
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are


