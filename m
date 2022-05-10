Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E2F520B53
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 04:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbiEJCjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 22:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbiEJCjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 22:39:44 -0400
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F9A9FDC
        for <stable@vger.kernel.org>; Mon,  9 May 2022 19:35:46 -0700 (PDT)
Received: from SHSend.spreadtrum.com (shmbx04.spreadtrum.com [10.0.1.214])
        by SHSQR01.spreadtrum.com with ESMTPS id 24A2ZHmq016228
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO);
        Tue, 10 May 2022 10:35:17 +0800 (CST)
        (envelope-from Jing.Xia@unisoc.com)
Received: from bj08259pcu.spreadtrum.com (10.0.74.59) by
 shmbx04.spreadtrum.com (10.0.1.214) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Tue, 10 May 2022 10:35:17 +0800
From:   Jing Xia <jing.xia@unisoc.com>
To:     <viro@zeniv.linux.org.uk>
CC:     <jack@suse.cz>, <hch@lst.de>, <jing.xia@unisoc.com>,
        <jing.xia.mail@gmail.com>, <stable@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] writeback: Avoid skipping inode writeback
Date:   Tue, 10 May 2022 10:35:14 +0800
Message-ID: <20220510023514.27399-1-jing.xia@unisoc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.74.59]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 shmbx04.spreadtrum.com (10.0.1.214)
X-MAIL: SHSQR01.spreadtrum.com 24A2ZHmq016228
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have run into an issue that a task gets stuck in
balance_dirty_pages_ratelimited() when perform I/O stress testing.
The reason we observed is that an I_DIRTY_PAGES inode with lots
of dirty pages is in b_dirty_time list and standard background
writeback cannot writeback the inode.
After studing the relevant code, the following scenario may lead
to the issue:

task1                                   task2
-----                                   -----
fuse_flush
 write_inode_now //in b_dirty_time
  writeback_single_inode
   __writeback_single_inode
                                 fuse_write_end
                                  filemap_dirty_folio
                                   __xa_set_mark:PAGECACHE_TAG_DIRTY
    lock inode->i_lock
    if mapping tagged PAGECACHE_TAG_DIRTY
    inode->i_state |= I_DIRTY_PAGES
    unlock inode->i_lock
                                   __mark_inode_dirty:I_DIRTY_PAGES
                                      lock inode->i_lock
                                      -was dirty,inode stays in
                                      -b_dirty_time
                                      unlock inode->i_lock

   if(!(inode->i_state & I_DIRTY_All))
      -not true,so nothing done

This patch moves the dirty inode to b_dirty list when the inode
currently is not queued in b_io or b_more_io list at the end of
writeback_single_inode.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
CC: stable@vger.kernel.org
Fixes: 0ae45f63d4ef ("vfs: add support for a lazytime mount option")
Signed-off-by: Jing Xia <jing.xia@unisoc.com>
---
 fs/fs-writeback.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 591fe9cf1659..1fae0196292a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1712,6 +1712,10 @@ static int writeback_single_inode(struct inode *inode,
 	 */
 	if (!(inode->i_state & I_DIRTY_ALL))
 		inode_cgwb_move_to_attached(inode, wb);
+	else if (!(inode->i_state & I_SYNC_QUEUED) &&
+		 (inode->i_state & I_DIRTY))
+		redirty_tail_locked(inode, wb);
+
 	spin_unlock(&wb->list_lock);
 	inode_sync_complete(inode);
 out:
-- 
2.17.1

