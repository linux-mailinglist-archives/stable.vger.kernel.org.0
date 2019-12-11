Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49D711B3E7
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733253AbfLKP1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733249AbfLKP1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:27:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0E082173E;
        Wed, 11 Dec 2019 15:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078028;
        bh=Ij6qeap0hI6cFj/+9nasKGNk7xnnnew3c0gdzp7vhk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pv/16BXy/j7OhieDdsEVXRERHQyYdG/k+KPPodQnTnpnJDV3HgEC4W18ISxAQyErF
         Y+PNOV+mdSEcgBQEyYWYrk5r7ajYupV1z/baPuDewxNXOV3XS8/+U/bNscQQpzAkHw
         hSZE9CkGXI+i5h4ejbyXC+VLq1rlP8T+ESk02bxc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        Jan Kara <jack@suse.cz>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 23/79] ext4: update direct I/O read lock pattern for IOCB_NOWAIT
Date:   Wed, 11 Dec 2019 10:25:47 -0500
Message-Id: <20191211152643.23056-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f8a0af11a31e8..00d25a0643913 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3839,7 +3839,13 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
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

