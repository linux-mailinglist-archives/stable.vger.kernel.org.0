Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364EB81B23
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbfHENKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730353AbfHENKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:10:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D2BF21738;
        Mon,  5 Aug 2019 13:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010636;
        bh=jzVLDuVem1d4gjgkeRqF0oymqX9LgfTyIHdZAEMFhos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3tIgSUij6lS2lleFplF++bApHotxKcpMsfiEzRYZOCrdKJPtjPT8NqRG7XggJPbo
         B1GpAJbiVzODua0/MSwiHN0FAa/j+ulQIo2daQP41NA7XenSdWqSOEOAWlRNNtA1d4
         JoR+OZdmYmuJA+mgvU8qpUxJwKZ30JfS5ew9nd44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 45/74] Btrfs: fix race leading to fs corruption after transaction abort
Date:   Mon,  5 Aug 2019 15:02:58 +0200
Message-Id: <20190805124939.528802586@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit cb2d3daddbfb6318d170e79aac1f7d5e4d49f0d7 upstream.

When one transaction is finishing its commit, it is possible for another
transaction to start and enter its initial commit phase as well. If the
first ends up getting aborted, we have a small time window where the second
transaction commit does not notice that the previous transaction aborted
and ends up committing, writing a superblock that points to btrees that
reference extent buffers (nodes and leafs) that were not persisted to disk.
The consequence is that after mounting the filesystem again, we will be
unable to load some btree nodes/leafs, either because the content on disk
is either garbage (or just zeroes) or corresponds to the old content of a
previouly COWed or deleted node/leaf, resulting in the well known error
messages "parent transid verify failed on ...".
The following sequence diagram illustrates how this can happen.

        CPU 1                                           CPU 2

 <at transaction N>

 btrfs_commit_transaction()
   (...)
   --> sets transaction state to
       TRANS_STATE_UNBLOCKED
   --> sets fs_info->running_transaction
       to NULL

                                                    (...)
                                                    btrfs_start_transaction()
                                                      start_transaction()
                                                        wait_current_trans()
                                                          --> returns immediately
                                                              because
                                                              fs_info->running_transaction
                                                              is NULL
                                                        join_transaction()
                                                          --> creates transaction N + 1
                                                          --> sets
                                                              fs_info->running_transaction
                                                              to transaction N + 1
                                                          --> adds transaction N + 1 to
                                                              the fs_info->trans_list list
                                                        --> returns transaction handle
                                                            pointing to the new
                                                            transaction N + 1
                                                    (...)

                                                    btrfs_sync_file()
                                                      btrfs_start_transaction()
                                                        --> returns handle to
                                                            transaction N + 1
                                                      (...)

   btrfs_write_and_wait_transaction()
     --> writeback of some extent
         buffer fails, returns an
	 error
   btrfs_handle_fs_error()
     --> sets BTRFS_FS_STATE_ERROR in
         fs_info->fs_state
   --> jumps to label "scrub_continue"
   cleanup_transaction()
     btrfs_abort_transaction(N)
       --> sets BTRFS_FS_STATE_TRANS_ABORTED
           flag in fs_info->fs_state
       --> sets aborted field in the
           transaction and transaction
	   handle structures, for
           transaction N only
     --> removes transaction from the
         list fs_info->trans_list
                                                      btrfs_commit_transaction(N + 1)
                                                        --> transaction N + 1 was not
							    aborted, so it proceeds
                                                        (...)
                                                        --> sets the transaction's state
                                                            to TRANS_STATE_COMMIT_START
                                                        --> does not find the previous
                                                            transaction (N) in the
                                                            fs_info->trans_list, so it
                                                            doesn't know that transaction
                                                            was aborted, and the commit
                                                            of transaction N + 1 proceeds
                                                        (...)
                                                        --> sets transaction N + 1 state
                                                            to TRANS_STATE_UNBLOCKED
                                                        btrfs_write_and_wait_transaction()
                                                          --> succeeds writing all extent
                                                              buffers created in the
                                                              transaction N + 1
                                                        write_all_supers()
                                                           --> succeeds
                                                           --> we now have a superblock on
                                                               disk that points to trees
                                                               that refer to at least one
                                                               extent buffer that was
                                                               never persisted

So fix this by updating the transaction commit path to check if the flag
BTRFS_FS_STATE_TRANS_ABORTED is set on fs_info->fs_state if after setting
the transaction to the TRANS_STATE_COMMIT_START we do not find any previous
transaction in the fs_info->trans_list. If the flag is set, just fail the
transaction commit with -EROFS, as we do in other places. The exact error
code for the previous transaction abort was already logged and reported.

Fixes: 49b25e0540904b ("btrfs: enhance transaction abort infrastructure")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/transaction.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2027,6 +2027,16 @@ int btrfs_commit_transaction(struct btrf
 		}
 	} else {
 		spin_unlock(&fs_info->trans_lock);
+		/*
+		 * The previous transaction was aborted and was already removed
+		 * from the list of transactions at fs_info->trans_list. So we
+		 * abort to prevent writing a new superblock that reflects a
+		 * corrupt state (pointing to trees with unwritten nodes/leafs).
+		 */
+		if (test_bit(BTRFS_FS_STATE_TRANS_ABORTED, &fs_info->fs_state)) {
+			ret = -EROFS;
+			goto cleanup_transaction;
+		}
 	}
 
 	extwriter_counter_dec(cur_trans, trans->type);


