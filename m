Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2E281138
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 06:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfHEE7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 00:59:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34435 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbfHEE7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 00:59:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8F7EC210D8;
        Mon,  5 Aug 2019 00:59:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 00:59:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9RF/ua
        mNolevxUxbPqau3uREeLqvm+W8F8zzNKlVsHw=; b=JTpObtd7YWBgY0x4utgLaa
        Shn/ErxCf/uIPMzQ7PERNFaTiy0bVXndqw4SZ//sHCzhGmIaqTL0ApgM/c40qLpO
        S+/MfzVmNNg2F73bFoEyguACzMTnGPYvzLjpdAe+EM4bpf7+n5P820fn297Vrk5i
        yee4fpYWIJypScN7HDrGvb0Fefhe0ZR/mqJVmXq2hwozveOT/t9uM0mLAY+MMNXt
        jql5Bfu6E1IQPYff89C2v/DOWwu9BYU93mxf46Qjgka41TrHFQtjHiM3v58IeotA
        4bGmMpNDMECwVqyxbHTsATOGMLiIsQt55I+WSPAN9UEendpIkrcNRoHHjR5K4EWA
        ==
X-ME-Sender: <xms:pLdHXZPqL2W0gEtiWEUqkQfI2mU4k8Mngu2v3ZUZZMh-bTDPS1yD1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:pLdHXYTfVZ0DO7gSWn7jrH3oCnZcBa-AnLKhHhcfr72wPsucx2IrIw>
    <xmx:pLdHXbDMD7lKgGbH9AVjKG91Gwc91CF27ttFjbzAvQQ0Doe38XXWEg>
    <xmx:pLdHXXjmcygtOU62sg4PbLwQGHSZAOYz1IoCzl2D5LxrpfdPNzM7zA>
    <xmx:pLdHXa-sF-7QtfsYZxDiBfIhzalsTeh9OsurtzK3tlALd1oc9KorjQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F097B380076;
        Mon,  5 Aug 2019 00:59:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix race leading to fs corruption after transaction" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 06:59:14 +0200
Message-ID: <1564981154143101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb2d3daddbfb6318d170e79aac1f7d5e4d49f0d7 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Thu, 25 Jul 2019 11:27:04 +0100
Subject: [PATCH] Btrfs: fix race leading to fs corruption after transaction
 abort

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

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3b8ae1a8f02d..39b7bcde3c6f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2037,6 +2037,16 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
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

