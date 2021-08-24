Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1D93F6596
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbhHXROy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239320AbhHXRLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:11:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9DDD61360;
        Tue, 24 Aug 2021 17:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824469;
        bh=bQLrVWFBj5744gzUSuxVy1UXEzsP8gwLK3raqZHB130=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LP7MYZYnEPdxorb770mZVbUvgYbrqnukjcD8sPSHQDDMT8KmJREiDRbi1YMcjtN44
         OCY22O30PhvTuqaJL9fK25BP6cZnfnbxjSOmk+l+BUmXNklJBt+WLVfwhW8ZbI60/v
         A1L0XnSsJpP0qekPwXZli8BktjnIys9FmNJLFylqasflDEdDp6lE9I/XG6QzAPpW4O
         uwN7G/wz6qiTd4ejKGxKFjFEmuakmyLCQ7UBnzCx8YrXSFTRx9Qps9HXLLqwxTYs/g
         wIiDpClUKmCrNgHDA1ITzBYIqFTOv1MD0pZUVhvpFnDM+iDX8qd4Pdacych7jlecLm
         iZMLtNiAafcQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ritesh Harjani <riteshh@linux.ibm.com>,
        syzbot+77fa5bdb65cc39711820@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Theodore Ts'o <tytso@mit.edu>,
        George Kennedy <george.kennedy@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 01/61] ext4: fix EXT4_MAX_LOGICAL_BLOCK macro
Date:   Tue, 24 Aug 2021 13:00:06 -0400
Message-Id: <20210824170106.710221-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit 175efa81feb8405676e0136d97b10380179c92e0 upstream.

ext4 supports max number of logical blocks in a file to be 0xffffffff.
(This is since ext4_extent's ee_block is __le32).
This means that EXT4_MAX_LOGICAL_BLOCK should be 0xfffffffe (starting
from 0 logical offset). This patch fixes this.

The issue was seen when ext4 moved to iomap_fiemap API and when
overlayfs was mounted on top of ext4. Since overlayfs was missing
filemap_check_ranges(), so it could pass a arbitrary huge length which
lead to overflow of map.m_len logic.

This patch fixes that.

Fixes: d3b6f23f7167 ("ext4: move ext4_fiemap to use iomap framework")
Reported-by: syzbot+77fa5bdb65cc39711820@syzkaller.appspotmail.com
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20200505154324.3226743-2-hch@lst.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf3eaa903033..ae2cb15d9540 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -718,7 +718,7 @@ enum {
 #define EXT4_MAX_BLOCK_FILE_PHYS	0xFFFFFFFF
 
 /* Max logical block we can support */
-#define EXT4_MAX_LOGICAL_BLOCK		0xFFFFFFFF
+#define EXT4_MAX_LOGICAL_BLOCK		0xFFFFFFFE
 
 /*
  * Structure of an inode on the disk
-- 
2.30.2

