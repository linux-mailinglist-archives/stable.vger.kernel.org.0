Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97230529015
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346960AbiEPUFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348888AbiEPT7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001C110B0;
        Mon, 16 May 2022 12:52:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9061C60A50;
        Mon, 16 May 2022 19:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CB2C385AA;
        Mon, 16 May 2022 19:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730728;
        bh=3/viTrq2CJi48RpXpQDqdjV7P1sTUTEI5Kc8yZ9ijAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwGdYeAQuiwvCZgBmysyGvD6JL5nWDVTa+oW3de6kPhUmykp6hGgrSGxuJfJ6LbiG
         6v+OvzefwwS2h/2oSAjCNHjVUE6EGjAxEi1WyKWaTXLE4NAnIag0BAQ3y7uH+i3rvr
         DprsfwtXvnGd+89kQpczbNR0gsMlFFIlC0Vjw978=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Jing Xia <jing.xia@unisoc.com>
Subject: [PATCH 5.15 089/102] writeback: Avoid skipping inode writeback
Date:   Mon, 16 May 2022 21:37:03 +0200
Message-Id: <20220516193626.553611508@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jing Xia <jing.xia@unisoc.com>

commit 846a3351ddfe4a86eede4bb26a205c3f38ef84d3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1739,6 +1739,10 @@ static int writeback_single_inode(struct
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


