Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C03D12F178
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgABXAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 18:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727498AbgABWMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:12:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E005121D7D;
        Thu,  2 Jan 2020 22:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003153;
        bh=r3pZeP9IeRuVmMfAsl/FdeSCsHqM9bwXH8Ql28UUO9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAJKzAZGZHu4XgJ0YyBk2ee/SucuOt649iHmD5j3UZ5Jut2NGyVrs4rPDaYaxRGac
         NYU10MHOjsH11ZVsd0n9jHIZYmEy9Q7o5zY8gtY4C0DaohZt15SxjTMvbZkrDcM4X8
         Z3JIivt08GsM6Wp9NkKj70WTlJdO+RKLKF0DryDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        Jan Kara <jack@suse.cz>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/191] ext4: update direct I/O read lock pattern for IOCB_NOWAIT
Date:   Thu,  2 Jan 2020 23:05:24 +0100
Message-Id: <20200102215834.457865761@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Bobrowski <mbobrowski@mbobrowski.org>

[ Upstream commit 548feebec7e93e58b647dba70b3303dcb569c914 ]

This patch updates the lock pattern in ext4_direct_IO_read() to not
block on inode lock in cases of IOCB_NOWAIT direct I/O reads. The
locking condition implemented here is similar to that of 942491c9e6d6
("xfs: fix AIM7 regression").

Fixes: 16c54688592c ("ext4: Allow parallel DIO reads")
Signed-off-by: Matthew Bobrowski <mbobrowski@mbobrowski.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/c5d5e759f91747359fbd2c6f9a36240cf75ad79f.1572949325.git.mbobrowski@mbobrowski.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 53134e4509b8..b10aa115eade 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3836,7 +3836,13 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 	 * writes & truncates and since we take care of writing back page cache,
 	 * we are protected against page writeback as well.
 	 */
-	inode_lock_shared(inode);
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock_shared(inode))
+			return -EAGAIN;
+	} else {
+		inode_lock_shared(inode);
+	}
+
 	ret = filemap_write_and_wait_range(mapping, iocb->ki_pos,
 					   iocb->ki_pos + count - 1);
 	if (ret)
-- 
2.20.1



