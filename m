Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4FE50F8C1
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346818AbiDZJLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347047AbiDZJJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:09:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B8617D4AC;
        Tue, 26 Apr 2022 01:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B38C61408;
        Tue, 26 Apr 2022 08:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA17C385A4;
        Tue, 26 Apr 2022 08:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962970;
        bh=JW1TDYK1LrQuzyBvKDA2RhxOyDnOpK7xVeQCCKUpyHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOMzYYHweDOUE5UxAmLzbUNg4mATC/YlbULuqJUHH7hZc7ITpvYfGxsZMg6Jz1I8c
         OuuPy8ZcI7vqKki12YK0uscdUOYEN30K0T1Ok7r2Uig+2hZNEwt0vwx2l9BH51FYUK
         hQK88zFD1IzM/VOVHuZ/KcLjqPX29REmgA/fDSN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.17 142/146] jbd2: fix a potential race while discarding reserved buffers after an abort
Date:   Tue, 26 Apr 2022 10:22:17 +0200
Message-Id: <20220426081754.049154511@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit 23e3d7f7061f8682c751c46512718f47580ad8f0 upstream.

we got issue as follows:
[   72.796117] EXT4-fs error (device sda): ext4_journal_check_start:83: comm fallocate: Detected aborted journal
[   72.826847] EXT4-fs (sda): Remounting filesystem read-only
fallocate: fallocate failed: Read-only file system
[   74.791830] jbd2_journal_commit_transaction: jh=0xffff9cfefe725d90 bh=0x0000000000000000 end delay
[   74.793597] ------------[ cut here ]------------
[   74.794203] kernel BUG at fs/jbd2/transaction.c:2063!
[   74.794886] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[   74.795533] CPU: 4 PID: 2260 Comm: jbd2/sda-8 Not tainted 5.17.0-rc8-next-20220315-dirty #150
[   74.798327] RIP: 0010:__jbd2_journal_unfile_buffer+0x3e/0x60
[   74.801971] RSP: 0018:ffffa828c24a3cb8 EFLAGS: 00010202
[   74.802694] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   74.803601] RDX: 0000000000000001 RSI: ffff9cfefe725d90 RDI: ffff9cfefe725d90
[   74.804554] RBP: ffff9cfefe725d90 R08: 0000000000000000 R09: ffffa828c24a3b20
[   74.805471] R10: 0000000000000001 R11: 0000000000000001 R12: ffff9cfefe725d90
[   74.806385] R13: ffff9cfefe725d98 R14: 0000000000000000 R15: ffff9cfe833a4d00
[   74.807301] FS:  0000000000000000(0000) GS:ffff9d01afb00000(0000) knlGS:0000000000000000
[   74.808338] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   74.809084] CR2: 00007f2b81bf4000 CR3: 0000000100056000 CR4: 00000000000006e0
[   74.810047] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   74.810981] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   74.811897] Call Trace:
[   74.812241]  <TASK>
[   74.812566]  __jbd2_journal_refile_buffer+0x12f/0x180
[   74.813246]  jbd2_journal_refile_buffer+0x4c/0xa0
[   74.813869]  jbd2_journal_commit_transaction.cold+0xa1/0x148
[   74.817550]  kjournald2+0xf8/0x3e0
[   74.819056]  kthread+0x153/0x1c0
[   74.819963]  ret_from_fork+0x22/0x30

Above issue may happen as follows:
        write                   truncate                   kjournald2
generic_perform_write
 ext4_write_begin
  ext4_walk_page_buffers
   do_journal_get_write_access ->add BJ_Reserved list
 ext4_journalled_write_end
  ext4_walk_page_buffers
   write_end_fn
    ext4_handle_dirty_metadata
                ***************JBD2 ABORT**************
     jbd2_journal_dirty_metadata
 -> return -EROFS, jh in reserved_list
                                                   jbd2_journal_commit_transaction
                                                    while (commit_transaction->t_reserved_list)
                                                      jh = commit_transaction->t_reserved_list;
                        truncate_pagecache_range
                         do_invalidatepage
			  ext4_journalled_invalidatepage
			   jbd2_journal_invalidatepage
			    journal_unmap_buffer
			     __dispose_buffer
			      __jbd2_journal_unfile_buffer
			       jbd2_journal_put_journal_head ->put last ref_count
			        __journal_remove_journal_head
				 bh->b_private = NULL;
				 jh->b_bh = NULL;
				                      jbd2_journal_refile_buffer(journal, jh);
							bh = jh2bh(jh);
							->bh is NULL, later will trigger null-ptr-deref
				 journal_free_journal_head(jh);

After commit 96f1e0974575, we no longer hold the j_state_lock while
iterating over the list of reserved handles in
jbd2_journal_commit_transaction().  This potentially allows the
journal_head to be freed by journal_unmap_buffer while the commit
codepath is also trying to free the BJ_Reserved buffers.  Keeping
j_state_lock held while trying extends hold time of the lock
minimally, and solves this issue.

Fixes: 96f1e0974575("jbd2: avoid long hold times of j_state_lock while committing a transaction")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220317142137.1821590-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/commit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -488,7 +488,6 @@ void jbd2_journal_commit_transaction(jou
 	jbd2_journal_wait_updates(journal);
 
 	commit_transaction->t_state = T_SWITCH;
-	write_unlock(&journal->j_state_lock);
 
 	J_ASSERT (atomic_read(&commit_transaction->t_outstanding_credits) <=
 			journal->j_max_transaction_buffers);
@@ -508,6 +507,8 @@ void jbd2_journal_commit_transaction(jou
 	 * has reserved.  This is consistent with the existing behaviour
 	 * that multiple jbd2_journal_get_write_access() calls to the same
 	 * buffer are perfectly permissible.
+	 * We use journal->j_state_lock here to serialize processing of
+	 * t_reserved_list with eviction of buffers from journal_unmap_buffer().
 	 */
 	while (commit_transaction->t_reserved_list) {
 		jh = commit_transaction->t_reserved_list;
@@ -527,6 +528,7 @@ void jbd2_journal_commit_transaction(jou
 		jbd2_journal_refile_buffer(journal, jh);
 	}
 
+	write_unlock(&journal->j_state_lock);
 	/*
 	 * Now try to drop any written-back buffers from the journal's
 	 * checkpoint lists.  We do this *before* commit because it potentially


