Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF68527F58
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241546AbiEPIPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 04:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241529AbiEPIPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:15:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9782536E19
        for <stable@vger.kernel.org>; Mon, 16 May 2022 01:15:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34211611C8
        for <stable@vger.kernel.org>; Mon, 16 May 2022 08:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A27DC385AA;
        Mon, 16 May 2022 08:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652688903;
        bh=6iUvgfdR3Iq55TgFRNH1bFxk8YNq5ahBp2zsIpU0yCk=;
        h=Subject:To:Cc:From:Date:From;
        b=kZ2xb/ymb6qkuKICLjtiFf2CKgjWKO53Nt4MZimKnZ93UA4x58/BzbrHWg7mr+ENp
         jvP1lWIrsvPhwnFowbeMhG83DkV6gzuxAbFZ9R2nca1a2VgGvyazKZECWuy3z8cOsQ
         kHn/vCjtdWZJqmQMpOZtuZ+0OG8YQODfCa1cZHgU=
Subject: FAILED: patch "[PATCH] writeback: Avoid skipping inode writeback" failed to apply to 4.19-stable tree
To:     jing.xia@unisoc.com, hch@lst.de, jack@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 10:14:54 +0200
Message-ID: <1652688894147164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 846a3351ddfe4a86eede4bb26a205c3f38ef84d3 Mon Sep 17 00:00:00 2001
From: Jing Xia <jing.xia@unisoc.com>
Date: Tue, 10 May 2022 10:35:14 +0800
Subject: [PATCH] writeback: Avoid skipping inode writeback

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
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220510023514.27399-1-jing.xia@unisoc.com

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

