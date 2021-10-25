Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084E04399CA
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 17:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbhJYPP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 11:15:58 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54246 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbhJYPP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 11:15:57 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4A9AF21958;
        Mon, 25 Oct 2021 15:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1635174813; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X4Rffi8a7ohQm/hvgshJ/X+5XAjZudu4WDOAxaoKqpo=;
        b=rMbWKKF27Nve1p+TS0MZI5N/KeY4liLcBymGPQfLR4vBWmYcMR6+NpTT9DtGA6zdxxCA3l
        SwlbQU3r5wgz7zX9NPS1CMktREbjuYLof2Gq84FJCvx85c84wZKz807/Le/s6KfVvX0p4r
        Oa4jcJlLrL0SHH7H63mQtjj3mqYbo6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1635174813;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X4Rffi8a7ohQm/hvgshJ/X+5XAjZudu4WDOAxaoKqpo=;
        b=CFbcO9zR2JQAsgzkjy70C+HZI1ee73o2lBvh9tRUndU99cJYN3iaIKLdXShs15t7kPL/6s
        nb4km10r0JHwtBAg==
Received: from quack2.suse.cz (unknown [10.100.224.230])
        by relay2.suse.de (Postfix) with ESMTP id 0CACBA3B88;
        Mon, 25 Oct 2021 15:13:32 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id C23751E00C7; Mon, 25 Oct 2021 17:13:32 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     ocfs2-devel@oss.oracle.com,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Gang He <ghe@suse.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ocfs2: Fix data corruption on truncate
Date:   Mon, 25 Oct 2021 17:13:24 +0200
Message-Id: <20211025151332.11301-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211025150008.29002-1-jack@suse.cz>
References: <20211025150008.29002-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2127; h=from:subject; bh=8rH7V8oUZIaV62wFoBn9uNxHVKQTpuSlM30rnn8yJ48=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBhdsmU346KUVkGYPuW5Gdlpq2z7Ix/NFSxavkgIsEW IKAJiTmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYXbJlAAKCRCcnaoHP2RA2T5aB/ 9FyM1mw6k0c9/JwXkX3dmD1zWq/Da1BbLjTGszNQq3uR5wDz7gBePYEbrqxHywMmtQg/GsfAXM5j+C 2anoDe658l4JVKb0ohLTobM9zO1DyYGjJOyQyUjcFAB3OTQvrwJrWiqNCecbNoMEsGeE3ESDH+nDZW vw8xFxIHovTJVvRBSmeLgBWI21E56vMEd/+dv7nPmrc227yJzoO1YEBNU1fxRJKPb6M4h1011o4u3/ 7jbqMw8z1zcAa5syb1TieganBHV4qTvNeKSurkYMCdfa31FxjylYqnrlTN7NKgpuYcrd01a8hnCUSx fzGXdeaR2HP9wb/TmE/+6cOHXmkS+Z
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ocfs2_truncate_file() did unmap invalidate page cache pages before
zeroing partial tail cluster and setting i_size. Thus some pages could
be left (and likely have left if the cluster zeroing happened) in the
page cache beyond i_size after truncate finished letting user possibly
see stale data once the file was extended again. Also the tail cluster
zeroing was not guaranteed to finish before truncate finished causing
possible stale data exposure. The problem started to be particularly
easy to hit after commit 6dbf7bb55598 "fs: Don't invalidate page buffers
in block_write_full_page()" stopped invalidation of pages beyond i_size
from page writeback path.

Fix these problems by unmapping and invalidating pages in the page cache
after the i_size is reduced and tail cluster is zeroed out.

CC: stable@vger.kernel.org
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 54d7843c0211..fc5f780fa235 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -476,10 +476,11 @@ int ocfs2_truncate_file(struct inode *inode,
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
@@ -498,6 +499,9 @@ int ocfs2_truncate_file(struct inode *inode,
 		goto bail_unlock_sem;
 	}
 
+	unmap_mapping_range(inode->i_mapping, new_i_size + PAGE_SIZE - 1, 0, 1);
+	truncate_inode_pages(inode->i_mapping, new_i_size);
+
 	status = ocfs2_commit_truncate(osb, inode, di_bh);
 	if (status < 0) {
 		mlog_errno(status);
-- 
2.26.2

