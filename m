Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F3C171CC3
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388878AbgB0OPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:15:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389226AbgB0OPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:15:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 016C720801;
        Thu, 27 Feb 2020 14:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812901;
        bh=CHl1Ijmq4X3Po2RGPAVEwO+7YBtOj/3h2Daad7KweI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=en9djk/6MJTOUneiPGWHI6TGgqfL1K2QEQ3coCtSVELnFz7ArPM3V7w1fa063nIM/
         rmtK2ut6Aklh/DjJledKdKT5XBxwWs/R1D1JIlP1QDRavn5O1vIMskLkcxinzyFHNn
         hldcGoaIDNA4Afg8oIMHk5UGhyhFs8OybZEomJ9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Wang <wangyan122@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Jun Piao <piaojun@huawei.com>,
        Jan Kara <jack@suse.cz>, stable@kernel.org
Subject: [PATCH 5.5 058/150] jbd2: fix ocfs2 corrupt when clearing block group bits
Date:   Thu, 27 Feb 2020 14:36:35 +0100
Message-Id: <20200227132241.652559370@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wangyan <wangyan122@huawei.com>

commit 8eedabfd66b68a4623beec0789eac54b8c9d0fb6 upstream.

I found a NULL pointer dereference in ocfs2_block_group_clear_bits().
The running environment:
	kernel version: 4.19
	A cluster with two nodes, 5 luns mounted on two nodes, and do some
	file operations like dd/fallocate/truncate/rm on every lun with storage
	network disconnection.

The fallocate operation on dm-23-45 caused an null pointer dereference.

The information of NULL pointer dereference as follows:
	[577992.878282] JBD2: Error -5 detected when updating journal superblock for dm-23-45.
	[577992.878290] Aborting journal on device dm-23-45.
	...
	[577992.890778] JBD2: Error -5 detected when updating journal superblock for dm-24-46.
	[577992.890908] __journal_remove_journal_head: freeing b_committed_data
	[577992.890916] (fallocate,88392,52):ocfs2_extend_trans:474 ERROR: status = -30
	[577992.890918] __journal_remove_journal_head: freeing b_committed_data
	[577992.890920] (fallocate,88392,52):ocfs2_rotate_tree_right:2500 ERROR: status = -30
	[577992.890922] __journal_remove_journal_head: freeing b_committed_data
	[577992.890924] (fallocate,88392,52):ocfs2_do_insert_extent:4382 ERROR: status = -30
	[577992.890928] (fallocate,88392,52):ocfs2_insert_extent:4842 ERROR: status = -30
	[577992.890928] __journal_remove_journal_head: freeing b_committed_data
	[577992.890930] (fallocate,88392,52):ocfs2_add_clusters_in_btree:4947 ERROR: status = -30
	[577992.890933] __journal_remove_journal_head: freeing b_committed_data
	[577992.890939] __journal_remove_journal_head: freeing b_committed_data
	[577992.890949] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
	[577992.890950] Mem abort info:
	[577992.890951]   ESR = 0x96000004
	[577992.890952]   Exception class = DABT (current EL), IL = 32 bits
	[577992.890952]   SET = 0, FnV = 0
	[577992.890953]   EA = 0, S1PTW = 0
	[577992.890954] Data abort info:
	[577992.890955]   ISV = 0, ISS = 0x00000004
	[577992.890956]   CM = 0, WnR = 0
	[577992.890958] user pgtable: 4k pages, 48-bit VAs, pgdp = 00000000f8da07a9
	[577992.890960] [0000000000000020] pgd=0000000000000000
	[577992.890964] Internal error: Oops: 96000004 [#1] SMP
	[577992.890965] Process fallocate (pid: 88392, stack limit = 0x00000000013db2fd)
	[577992.890968] CPU: 52 PID: 88392 Comm: fallocate Kdump: loaded Tainted: G        W  OE     4.19.36 #1
	[577992.890969] Hardware name: Huawei TaiShan 2280 V2/BC82AMDD, BIOS 0.98 08/25/2019
	[577992.890971] pstate: 60400009 (nZCv daif +PAN -UAO)
	[577992.891054] pc : _ocfs2_free_suballoc_bits+0x63c/0x968 [ocfs2]
	[577992.891082] lr : _ocfs2_free_suballoc_bits+0x618/0x968 [ocfs2]
	[577992.891084] sp : ffff0000c8e2b810
	[577992.891085] x29: ffff0000c8e2b820 x28: 0000000000000000
	[577992.891087] x27: 00000000000006f3 x26: ffffa07957b02e70
	[577992.891089] x25: ffff807c59d50000 x24: 00000000000006f2
	[577992.891091] x23: 0000000000000001 x22: ffff807bd39abc30
	[577992.891093] x21: ffff0000811d9000 x20: ffffa07535d6a000
	[577992.891097] x19: ffff000001681638 x18: ffffffffffffffff
	[577992.891098] x17: 0000000000000000 x16: ffff000080a03df0
	[577992.891100] x15: ffff0000811d9708 x14: 203d207375746174
	[577992.891101] x13: 73203a524f525245 x12: 20373439343a6565
	[577992.891103] x11: 0000000000000038 x10: 0101010101010101
	[577992.891106] x9 : ffffa07c68a85d70 x8 : 7f7f7f7f7f7f7f7f
	[577992.891109] x7 : 0000000000000000 x6 : 0000000000000080
	[577992.891110] x5 : 0000000000000000 x4 : 0000000000000002
	[577992.891112] x3 : ffff000001713390 x2 : 2ff90f88b1c22f00
	[577992.891114] x1 : ffff807bd39abc30 x0 : 0000000000000000
	[577992.891116] Call trace:
	[577992.891139]  _ocfs2_free_suballoc_bits+0x63c/0x968 [ocfs2]
	[577992.891162]  _ocfs2_free_clusters+0x100/0x290 [ocfs2]
	[577992.891185]  ocfs2_free_clusters+0x50/0x68 [ocfs2]
	[577992.891206]  ocfs2_add_clusters_in_btree+0x198/0x5e0 [ocfs2]
	[577992.891227]  ocfs2_add_inode_data+0x94/0xc8 [ocfs2]
	[577992.891248]  ocfs2_extend_allocation+0x1bc/0x7a8 [ocfs2]
	[577992.891269]  ocfs2_allocate_extents+0x14c/0x338 [ocfs2]
	[577992.891290]  __ocfs2_change_file_space+0x3f8/0x610 [ocfs2]
	[577992.891309]  ocfs2_fallocate+0xe4/0x128 [ocfs2]
	[577992.891316]  vfs_fallocate+0x11c/0x250
	[577992.891317]  ksys_fallocate+0x54/0x88
	[577992.891319]  __arm64_sys_fallocate+0x28/0x38
	[577992.891323]  el0_svc_common+0x78/0x130
	[577992.891325]  el0_svc_handler+0x38/0x78
	[577992.891327]  el0_svc+0x8/0xc

My analysis process as follows:
ocfs2_fallocate
  __ocfs2_change_file_space
    ocfs2_allocate_extents
      ocfs2_extend_allocation
        ocfs2_add_inode_data
          ocfs2_add_clusters_in_btree
            ocfs2_insert_extent
              ocfs2_do_insert_extent
                ocfs2_rotate_tree_right
                  ocfs2_extend_rotate_transaction
                    ocfs2_extend_trans
                      jbd2_journal_restart
                        jbd2__journal_restart
                          /* handle->h_transaction is NULL,
                           * is_handle_aborted(handle) is true
                           */
                          handle->h_transaction = NULL;
                          start_this_handle
                            return -EROFS;
            ocfs2_free_clusters
              _ocfs2_free_clusters
                _ocfs2_free_suballoc_bits
                  ocfs2_block_group_clear_bits
                    ocfs2_journal_access_gd
                      __ocfs2_journal_access
                        jbd2_journal_get_undo_access
                          /* I think jbd2_write_access_granted() will
                           * return true, because do_get_write_access()
                           * will return -EROFS.
                           */
                          if (jbd2_write_access_granted(...)) return 0;
                          do_get_write_access
                            /* handle->h_transaction is NULL, it will
                             * return -EROFS here, so do_get_write_access()
                             * was not called.
                             */
                            if (is_handle_aborted(handle)) return -EROFS;
                    /* bh2jh(group_bh) is NULL, caused NULL
                       pointer dereference */
                    undo_bg = (struct ocfs2_group_desc *)
                                bh2jh(group_bh)->b_committed_data;

If handle->h_transaction == NULL, then jbd2_write_access_granted()
does not really guarantee that journal_head will stay around,
not even speaking of its b_committed_data. The bh2jh(group_bh)
can be removed after ocfs2_journal_access_gd() and before call
"bh2jh(group_bh)->b_committed_data". So, we should move
is_handle_aborted() check from do_get_write_access() into
jbd2_journal_get_undo_access() and jbd2_journal_get_write_access()
before the call to jbd2_write_access_granted().

Link: https://lore.kernel.org/r/f72a623f-b3f1-381a-d91d-d22a1c83a336@huawei.com
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/transaction.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -936,8 +936,6 @@ do_get_write_access(handle_t *handle, st
 	char *frozen_buffer = NULL;
 	unsigned long start_lock, time_lock;
 
-	if (is_handle_aborted(handle))
-		return -EROFS;
 	journal = transaction->t_journal;
 
 	jbd_debug(5, "journal_head %p, force_copy %d\n", jh, force_copy);
@@ -1189,6 +1187,9 @@ int jbd2_journal_get_write_access(handle
 	struct journal_head *jh;
 	int rc;
 
+	if (is_handle_aborted(handle))
+		return -EROFS;
+
 	if (jbd2_write_access_granted(handle, bh, false))
 		return 0;
 
@@ -1326,6 +1327,9 @@ int jbd2_journal_get_undo_access(handle_
 	struct journal_head *jh;
 	char *committed_data = NULL;
 
+	if (is_handle_aborted(handle))
+		return -EROFS;
+
 	if (jbd2_write_access_granted(handle, bh, true))
 		return 0;
 


