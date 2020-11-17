Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1102B653A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731498AbgKQNww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:52:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731477AbgKQN2p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:28:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6207F2078E;
        Tue, 17 Nov 2020 13:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619726;
        bh=3fntGhdmntGkANo1Skyjo7G96MAFJgTdfCEIu2/0TQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HN+tYEjYsvPI3RVag2oSbNgEx3WSI3eQmTejhtApm8aUm/da/HQFb3iNpwoeHqFsk
         BRK0l8zXXtCBFJlQ8cMNxkjuJ2WCj57tgi/nAyQQ7fFg/F82Arnj7G/2Xjrv3t2WEQ
         J6JtNfx0EK/dSI6RTGZRuzrnATZ7b6S8aIUQxvJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, nl6720 <nl6720@gmail.com>,
        Chao Yu <yuchao0@huawei.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 5.4 106/151] erofs: derive atime instead of leaving it empty
Date:   Tue, 17 Nov 2020 14:05:36 +0100
Message-Id: <20201117122126.572763583@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit d3938ee23e97bfcac2e0eb6b356875da73d700df upstream.

EROFS has _only one_ ondisk timestamp (ctime is currently
documented and recorded, we might also record mtime instead
with a new compat feature if needed) for each extended inode
since EROFS isn't mainly for archival purposes so no need to
keep all timestamps on disk especially for Android scenarios
due to security concerns. Also, romfs/cramfs don't have their
own on-disk timestamp, and squashfs only records mtime instead.

Let's also derive access time from ondisk timestamp rather than
leaving it empty, and if mtime/atime for each file are really
needed for specific scenarios as well, we can also use xattrs
to record them then.

Link: https://lore.kernel.org/r/20201031195102.21221-1-hsiangkao@aol.com
[ Gao Xiang: It'd be better to backport for user-friendly concern. ]
Fixes: 431339ba9042 ("staging: erofs: add inode operations")
Cc: stable <stable@vger.kernel.org> # 4.19+
Reported-by: nl6720 <nl6720@gmail.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/erofs/inode.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -107,11 +107,9 @@ static struct page *erofs_read_inode(str
 		i_gid_write(inode, le32_to_cpu(die->i_gid));
 		set_nlink(inode, le32_to_cpu(die->i_nlink));
 
-		/* ns timestamp */
-		inode->i_mtime.tv_sec = inode->i_ctime.tv_sec =
-			le64_to_cpu(die->i_ctime);
-		inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec =
-			le32_to_cpu(die->i_ctime_nsec);
+		/* extended inode has its own timestamp */
+		inode->i_ctime.tv_sec = le64_to_cpu(die->i_ctime);
+		inode->i_ctime.tv_nsec = le32_to_cpu(die->i_ctime_nsec);
 
 		inode->i_size = le64_to_cpu(die->i_size);
 
@@ -149,11 +147,9 @@ static struct page *erofs_read_inode(str
 		i_gid_write(inode, le16_to_cpu(dic->i_gid));
 		set_nlink(inode, le16_to_cpu(dic->i_nlink));
 
-		/* use build time to derive all file time */
-		inode->i_mtime.tv_sec = inode->i_ctime.tv_sec =
-			sbi->build_time;
-		inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec =
-			sbi->build_time_nsec;
+		/* use build time for compact inodes */
+		inode->i_ctime.tv_sec = sbi->build_time;
+		inode->i_ctime.tv_nsec = sbi->build_time_nsec;
 
 		inode->i_size = le32_to_cpu(dic->i_size);
 		if (erofs_inode_is_data_compressed(vi->datalayout))
@@ -167,6 +163,11 @@ static struct page *erofs_read_inode(str
 		goto err_out;
 	}
 
+	inode->i_mtime.tv_sec = inode->i_ctime.tv_sec;
+	inode->i_atime.tv_sec = inode->i_ctime.tv_sec;
+	inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec;
+	inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec;
+
 	if (!nblks)
 		/* measure inode.i_blocks as generic filesystems */
 		inode->i_blocks = roundup(inode->i_size, EROFS_BLKSIZ) >> 9;


