Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F9F45B9AA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241996AbhKXMDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:03:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241859AbhKXMDo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:03:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CCAB60FDC;
        Wed, 24 Nov 2021 12:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755235;
        bh=J2USBgA3nvsI5S8KZizLVyZ3l0AWSw6m91TvFiqrA/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBkfYbLpBSziOtcaCJQlHFlTvb3lZJFcnws2V9aNoaOODRfbUMJYki2OQYAOfgdae
         CWnHEXqubI5bPhAAYIlGIUpbeZGeCdPYsH+PwmRjhTT/S13Br9o2ySvQUXVkQ87cYz
         12JPqkFmr8zJWwHxo6kjvqMDfWs9ld0/wdMIwjMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 007/162] ocfs2: fix data corruption on truncate
Date:   Wed, 24 Nov 2021 12:55:10 +0100
Message-Id: <20211124115658.568442638@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 839b63860eb3835da165642923120d305925561d upstream.

Patch series "ocfs2: Truncate data corruption fix".

As further testing has shown, commit 5314454ea3f ("ocfs2: fix data
corruption after conversion from inline format") didn't fix all the data
corruption issues the customer started observing after 6dbf7bb55598
("fs: Don't invalidate page buffers in block_write_full_page()") This
time I have tracked them down to two bugs in ocfs2 truncation code.

One bug (truncating page cache before clearing tail cluster and setting
i_size) could cause data corruption even before 6dbf7bb55598, but before
that commit it needed a race with page fault, after 6dbf7bb55598 it
started to be pretty deterministic.

Another bug (zeroing pages beyond old i_size) used to be harmless
inefficiency before commit 6dbf7bb55598.  But after commit 6dbf7bb55598
in combination with the first bug it resulted in deterministic data
corruption.

Although fixing only the first problem is needed to stop data
corruption, I've fixed both issues to make the code more robust.

This patch (of 2):

ocfs2_truncate_file() did unmap invalidate page cache pages before
zeroing partial tail cluster and setting i_size.  Thus some pages could
be left (and likely have left if the cluster zeroing happened) in the
page cache beyond i_size after truncate finished letting user possibly
see stale data once the file was extended again.  Also the tail cluster
zeroing was not guaranteed to finish before truncate finished causing
possible stale data exposure.  The problem started to be particularly
easy to hit after commit 6dbf7bb55598 "fs: Don't invalidate page buffers
in block_write_full_page()" stopped invalidation of pages beyond i_size
from page writeback path.

Fix these problems by unmapping and invalidating pages in the page cache
after the i_size is reduced and tail cluster is zeroed out.

Link: https://lkml.kernel.org/r/20211025150008.29002-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20211025151332.11301-1-jack@suse.cz
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/file.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -490,10 +490,11 @@ int ocfs2_truncate_file(struct inode *in
 	 * greater than page size, so we have to truncate them
 	 * anyway.
 	 */
-	unmap_mapping_range(inode->i_mapping, new_i_size + PAGE_SIZE - 1, 0, 1);
-	truncate_inode_pages(inode->i_mapping, new_i_size);
 
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		unmap_mapping_range(inode->i_mapping,
+				    new_i_size + PAGE_SIZE - 1, 0, 1);
+		truncate_inode_pages(inode->i_mapping, new_i_size);
 		status = ocfs2_truncate_inline(inode, di_bh, new_i_size,
 					       i_size_read(inode), 1);
 		if (status)
@@ -512,6 +513,9 @@ int ocfs2_truncate_file(struct inode *in
 		goto bail_unlock_sem;
 	}
 
+	unmap_mapping_range(inode->i_mapping, new_i_size + PAGE_SIZE - 1, 0, 1);
+	truncate_inode_pages(inode->i_mapping, new_i_size);
+
 	status = ocfs2_commit_truncate(osb, inode, di_bh);
 	if (status < 0) {
 		mlog_errno(status);


