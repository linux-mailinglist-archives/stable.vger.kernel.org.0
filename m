Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451252F196
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfE3EOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbfE3DQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:12 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B056245D8;
        Thu, 30 May 2019 03:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186172;
        bh=uP0wVDJZ21vTACQut16rItjPR0xwaJ5+3qdiC+JLdQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXlM3soM0MbzOvRcEbxIk8S/vcLPunTliJHaAdPv1BPLwxCg7Plyc0hAukmaErOX3
         ICvk7/sV9ZmHKZ/u6vjCabNzIbGKood7zx2HLhG2JOt4em/EjybSas7bO37Voui3/R
         tKOPUTQl0UbN+F9j9UIabevmHuPBBNK5zf7UUaPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 003/276] ext4: wait for outstanding dio during truncate in nojournal mode
Date:   Wed, 29 May 2019 20:02:41 -0700
Message-Id: <20190530030523.634560870@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 82a25b027ca48d7ef197295846b352345853dfa8 upstream.

We didn't wait for outstanding direct IO during truncate in nojournal
mode (as we skip orphan handling in that case). This can lead to fs
corruption or stale data exposure if truncate ends up freeing blocks
and these get reallocated before direct IO finishes. Fix the condition
determining whether the wait is necessary.

CC: stable@vger.kernel.org
Fixes: 1c9114f9c0f1 ("ext4: serialize unlocked dio reads with truncate")
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5601,20 +5601,17 @@ int ext4_setattr(struct dentry *dentry,
 				goto err_out;
 			}
 		}
-		if (!shrink)
+		if (!shrink) {
 			pagecache_isize_extended(inode, oldsize, inode->i_size);
-
-		/*
-		 * Blocks are going to be removed from the inode. Wait
-		 * for dio in flight.  Temporarily disable
-		 * dioread_nolock to prevent livelock.
-		 */
-		if (orphan) {
-			if (!ext4_should_journal_data(inode)) {
-				inode_dio_wait(inode);
-			} else
-				ext4_wait_for_tail_page_commit(inode);
+		} else {
+			/*
+			 * Blocks are going to be removed from the inode. Wait
+			 * for dio in flight.
+			 */
+			inode_dio_wait(inode);
 		}
+		if (orphan && ext4_should_journal_data(inode))
+			ext4_wait_for_tail_page_commit(inode);
 		down_write(&EXT4_I(inode)->i_mmap_sem);
 
 		rc = ext4_break_layouts(inode);


