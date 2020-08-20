Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5897F24BF99
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgHTNuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbgHTJ1W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:27:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3B6B2224D;
        Thu, 20 Aug 2020 09:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915641;
        bh=9xm3/+RTBPQYWS6XNn5NPWhUPDrqLdrKs6vsvXi7Yhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAWvR2HsLjuSL1UiOa4DFGwhMLyHsKj72hBNO4DqlFfh+P5dq0d40H+FXqTkvQKIe
         u4yJdhPfrLjZmND5oCEaNL9iMrCijKDfEv7ENyvcyl/ILJTycQVkjPL0RJ75zv0BTq
         Cy3I2B94z1MdsOxSlXXWSKnSiwO+Se2dORIKqtKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Gang He <ghe@suse.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Changwei Ge <gechangwei@live.cn>,
        Jun Piao <piaojun@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 084/232] ocfs2: change slot number type s16 to u16
Date:   Thu, 20 Aug 2020 11:18:55 +0200
Message-Id: <20200820091616.885142054@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxiao Bi <junxiao.bi@oracle.com>

commit 38d51b2dd171ad973afc1f5faab825ed05a2d5e9 upstream.

Dan Carpenter reported the following static checker warning.

	fs/ocfs2/super.c:1269 ocfs2_parse_options() warn: '(-1)' 65535 can't fit into 32767 'mopt->slot'
	fs/ocfs2/suballoc.c:859 ocfs2_init_inode_steal_slot() warn: '(-1)' 65535 can't fit into 32767 'osb->s_inode_steal_slot'
	fs/ocfs2/suballoc.c:867 ocfs2_init_meta_steal_slot() warn: '(-1)' 65535 can't fit into 32767 'osb->s_meta_steal_slot'

That's because OCFS2_INVALID_SLOT is (u16)-1. Slot number in ocfs2 can be
never negative, so change s16 to u16.

Fixes: 9277f8334ffc ("ocfs2: fix value of OCFS2_INVALID_SLOT")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200627001259.19757-1-junxiao.bi@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/ocfs2.h    |    4 ++--
 fs/ocfs2/suballoc.c |    4 ++--
 fs/ocfs2/super.c    |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
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
 
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
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
 
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
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


