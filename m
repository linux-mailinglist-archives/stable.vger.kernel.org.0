Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695E023E72C
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 08:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgHGGSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 02:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CCA922CAE;
        Fri,  7 Aug 2020 06:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781083;
        bh=JEjT5MjxPtlExL/ndg5RGSqopRhTQSjzsLnn9XKylbs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=V6YFwy07FiK8iF+0DsXVL4sLoeSuhRsp7Zvf9xoViRMScDvQRQanPIJTrH0DdrtqE
         w3kbUdrbfFazzee8l+1XlZSmnAHGKxFJ3LYXDebH05wSSpMHqFAtzEtuxpOruzj0HB
         OCEc05BKNamekNVzz0lnfnQRFAXgFBl7hTpjjOT4=
Date:   Thu, 06 Aug 2020 23:18:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 019/163] ocfs2: change slot number type s16 to u16
Message-ID: <20200807061802.UMoDJErtC%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
