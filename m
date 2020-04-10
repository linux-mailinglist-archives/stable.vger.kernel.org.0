Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5027C1A4B97
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 23:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgDJVcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 17:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 17:32:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34E0E20753;
        Fri, 10 Apr 2020 21:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586554359;
        bh=cBWRW76SvB24Ppziggmko24ngvHKcl9FYD2nWQmJ0CM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cYwA0gE0gYA4rPXtIIgLOsI4Arhq5khxiWAGLzsqHc3xXuqfSnWtnQLDgJL2Up320
         m9Khb4clEI67SUMcS6QauStN+Ps/u08vGk91Y3iVl6BuEiF2e26/uwDALVS2jdZcQm
         xg39sG09tq9acI+3snqaypHciV9+0nInOEGYh+PU=
Date:   Fri, 10 Apr 2020 14:32:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chge@linux.alibaba.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 08/35] ocfs2: no need try to truncate file beyond
 i_size
Message-ID: <20200410213238.KttQSeJuw%akpm@linux-foundation.org>
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changwei Ge <chge@linux.alibaba.com>
Subject: ocfs2: no need try to truncate file beyond i_size

Linux fallocate(2) with FALLOC_FL_PUNCH_HOLE mode set, its offset can
exceed inode size.  Ocfs2 now does't allow that offset beyond inode size. 
This restriction is not necessary and voilates fallocate(2) semantics.

If fallocate(2) offset is beyond inode size, just return success and do
nothing further.

Otherwise, ocfs2 will crash the kernel.

kernel BUG at fs/ocfs2//alloc.c:7264!
 ocfs2_truncate_inline+0x20f/0x360 [ocfs2]
 ? ocfs2_read_blocks+0x2f3/0x5f0 [ocfs2]
 ocfs2_remove_inode_range+0x23c/0xcb0 [ocfs2]
 ? ocfs2_read_inode_block+0x10/0x20 [ocfs2]
 ? ocfs2_allocate_extend_trans+0x1a0/0x1a0 [ocfs2]
 __ocfs2_change_file_space+0x4a5/0x650 [ocfs2]
 ocfs2_fallocate+0x83/0xa0 [ocfs2]
 ? __audit_syscall_entry+0xb8/0x100
 ? __sb_start_write+0x3b/0x70
 vfs_fallocate+0x148/0x230
 SyS_fallocate+0x48/0x80
 do_syscall_64+0x79/0x170

Link: http://lkml.kernel.org/r/20200407082754.17565-1-chge@linux.alibaba.com
Signed-off-by: Changwei Ge <chge@linux.alibaba.com>
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

 fs/ocfs2/alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ocfs2/alloc.c~ocfs2-no-need-try-to-truncate-file-beyond-i_size
+++ a/fs/ocfs2/alloc.c
@@ -7402,6 +7402,10 @@ int ocfs2_truncate_inline(struct inode *
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_inline_data *idata = &di->id2.i_data;
 
+	/* No need to punch hole beyond i_size. */
+	if (start >= i_size_read(inode))
+		return 0;
+
 	if (end > i_size_read(inode))
 		end = i_size_read(inode);
 
_
