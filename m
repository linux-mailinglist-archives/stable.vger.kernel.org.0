Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A60D3D2F40
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 23:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhGVU5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 16:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhGVU5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 16:57:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C21ED60E8F;
        Thu, 22 Jul 2021 21:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626989904;
        bh=wJSDzwEWiog02rTZ5XNiHzFbJrYiZ2lDW/vkzkdAU9M=;
        h=Date:From:To:Subject:From;
        b=oQeXMDX+fsNkVfkwA9FiKf2jF6yg65HusXkGw0EozyVCckuEAX+HgOE0lgcuiIKTr
         mVGFwncnzHoOI75YRZOnEDRO86uk5PziRa/TkAhVjk07GqduiyyzZT2VYhm1bx2rw0
         CSaEqzmlUNx4yzxRZ3VEv0uLPDwmQHDcKkhHTNNU=
Date:   Thu, 22 Jul 2021 14:38:22 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        junxiao.bi@oracle.com
Subject:  + ocfs2-fix-zero-out-valid-data.patch added to -mm tree
Message-ID: <20210722213822.icPg0%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: fix zero out valid data
has been added to the -mm tree.  Its filename is
     ocfs2-fix-zero-out-valid-data.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-zero-out-valid-data.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-zero-out-valid-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: fix zero out valid data

If append-dio feature is enabled, direct-io write and fallocate could run
in parallel to extend file size, fallocate used "orig_isize" to record
i_size before taking "ip_alloc_sem", when ocfs2_zeroout_partial_cluster()
zeroout EOF blocks, i_size maybe already extended by
ocfs2_dio_end_io_write(), that will cause valid data zeroed out.

Link: https://lkml.kernel.org/r/20210722054923.24389-1-junxiao.bi@oracle.com
Fixes: 6bba4471f0cc ("ocfs2: fix data corruption by fallocate")
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

 fs/ocfs2/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/file.c~ocfs2-fix-zero-out-valid-data
+++ a/fs/ocfs2/file.c
@@ -1935,7 +1935,6 @@ static int __ocfs2_change_file_space(str
 		goto out_inode_unlock;
 	}
 
-	orig_isize = i_size_read(inode);
 	switch (sr->l_whence) {
 	case 0: /*SEEK_SET*/
 		break;
@@ -1943,7 +1942,7 @@ static int __ocfs2_change_file_space(str
 		sr->l_start += f_pos;
 		break;
 	case 2: /*SEEK_END*/
-		sr->l_start += orig_isize;
+		sr->l_start += i_size_read(inode);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1998,6 +1997,7 @@ static int __ocfs2_change_file_space(str
 		ret = -EINVAL;
 	}
 
+	orig_isize = i_size_read(inode);
 	/* zeroout eof blocks in the cluster. */
 	if (!ret && change_size && orig_isize < size) {
 		ret = ocfs2_zeroout_partial_cluster(inode, orig_isize,
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-fix-zero-out-valid-data.patch
ocfs2-issue-zeroout-to-eof-blocks.patch

