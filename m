Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E440B3DAE8B
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 23:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhG2Vxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 17:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhG2Vxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 17:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C46F660F48;
        Thu, 29 Jul 2021 21:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627595619;
        bh=qysA7nDRpqIDS5XUdlw1Nw1TLIWMRy4wbTIQgDsb3y8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oVQiwpUG9tjeoHyIY+0CK7um2J+1QjAZnZfs15lH5z5mOuSKzObd7DoILVdgX3Jtk
         aRxECMYfuX9gQ7RJVziE/jNKCfaW8sP6eVhyIDDgr/HxBWT9ZPLXhPI+rtQ7Or3/ML
         lKYulMb1ArLQEpw634pAi3m/UEzHzqkyJOug6Ffs=
Date:   Thu, 29 Jul 2021 14:53:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 2/7] ocfs2: fix zero out valid data
Message-ID: <20210729215338.ZhfcJipXa%akpm@linux-foundation.org>
In-Reply-To: <20210729145259.24681c326dc3ed18194cf9e5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
