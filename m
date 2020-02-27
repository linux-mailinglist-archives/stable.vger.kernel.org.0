Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C88172083
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbgB0Nte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:49:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731043AbgB0Nta (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:49:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABECC246A1;
        Thu, 27 Feb 2020 13:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811370;
        bh=NCStkUO1sJ0PJivtjHkTUa7b0w8xn2leK7ev7u7wBw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4IOgY1fDvbfpZ77xPc3a8szeOcDMEShfojW92XgTur6I/y38IPGdFXjob++nDB23
         GUpOU///eCwG1n4hAiOahHA/u69uTQlv3NHqBEjxyzssgppsnqE1KKK8plJK1bjraq
         vh4Y2L/Z7HSwojDXcTIRCarAWc3tqfUX8dF8xeAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Wang <wangyan122@huawei.com>,
        Jun Piao <piaojun@huawei.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <jiangqi903@gmail.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 106/165] ocfs2: fix a NULL pointer dereference when call ocfs2_update_inode_fsync_trans()
Date:   Thu, 27 Feb 2020 14:36:20 +0100
Message-Id: <20200227132246.636143031@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wangyan <wangyan122@huawei.com>

[ Upstream commit 9f16ca48fc818a17de8be1f75d08e7f4addc4497 ]

I found a NULL pointer dereference in ocfs2_update_inode_fsync_trans(),
handle->h_transaction may be NULL in this situation:

ocfs2_file_write_iter
  ->__generic_file_write_iter
      ->generic_perform_write
        ->ocfs2_write_begin
          ->ocfs2_write_begin_nolock
            ->ocfs2_write_cluster_by_desc
              ->ocfs2_write_cluster
                ->ocfs2_mark_extent_written
                  ->ocfs2_change_extent_flag
                    ->ocfs2_split_extent
                      ->ocfs2_try_to_merge_extent
                        ->ocfs2_extend_rotate_transaction
                          ->ocfs2_extend_trans
                            ->jbd2_journal_restart
                              ->jbd2__journal_restart
                                // handle->h_transaction is NULL here
                                ->handle->h_transaction = NULL;
                                ->start_this_handle
                                  /* journal aborted due to storage
                                     network disconnection, return error */
                                  ->return -EROFS;
                         /* line 3806 in ocfs2_try_to_merge_extent (),
                            it will ignore ret error. */
                        ->ret = 0;
        ->...
        ->ocfs2_write_end
          ->ocfs2_write_end_nolock
            ->ocfs2_update_inode_fsync_trans
              // NULL pointer dereference
              ->oi->i_sync_tid = handle->h_transaction->t_tid;

The information of NULL pointer dereference as follows:
    JBD2: Detected IO errors while flushing file data on dm-11-45
    Aborting journal on device dm-11-45.
    JBD2: Error -5 detected when updating journal superblock for dm-11-45.
    (dd,22081,3):ocfs2_extend_trans:474 ERROR: status = -30
    (dd,22081,3):ocfs2_try_to_merge_extent:3877 ERROR: status = -30
    Unable to handle kernel NULL pointer dereference at
    virtual address 0000000000000008
    Mem abort info:
      ESR = 0x96000004
      Exception class = DABT (current EL), IL = 32 bits
      SET = 0, FnV = 0
      EA = 0, S1PTW = 0
    Data abort info:
      ISV = 0, ISS = 0x00000004
      CM = 0, WnR = 0
    user pgtable: 4k pages, 48-bit VAs, pgdp = 00000000e74e1338
    [0000000000000008] pgd=0000000000000000
    Internal error: Oops: 96000004 [#1] SMP
    Process dd (pid: 22081, stack limit = 0x00000000584f35a9)
    CPU: 3 PID: 22081 Comm: dd Kdump: loaded
    Hardware name: Huawei TaiShan 2280 V2/BC82AMDD, BIOS 0.98 08/25/2019
    pstate: 60400009 (nZCv daif +PAN -UAO)
    pc : ocfs2_write_end_nolock+0x2b8/0x550 [ocfs2]
    lr : ocfs2_write_end_nolock+0x2a0/0x550 [ocfs2]
    sp : ffff0000459fba70
    x29: ffff0000459fba70 x28: 0000000000000000
    x27: ffff807ccf7f1000 x26: 0000000000000001
    x25: ffff807bdff57970 x24: ffff807caf1d4000
    x23: ffff807cc79e9000 x22: 0000000000001000
    x21: 000000006c6cd000 x20: ffff0000091d9000
    x19: ffff807ccb239db0 x18: ffffffffffffffff
    x17: 000000000000000e x16: 0000000000000007
    x15: ffff807c5e15bd78 x14: 0000000000000000
    x13: 0000000000000000 x12: 0000000000000000
    x11: 0000000000000000 x10: 0000000000000001
    x9 : 0000000000000228 x8 : 000000000000000c
    x7 : 0000000000000fff x6 : ffff807a308ed6b0
    x5 : ffff7e01f10967c0 x4 : 0000000000000018
    x3 : d0bc661572445600 x2 : 0000000000000000
    x1 : 000000001b2e0200 x0 : 0000000000000000
    Call trace:
     ocfs2_write_end_nolock+0x2b8/0x550 [ocfs2]
     ocfs2_write_end+0x4c/0x80 [ocfs2]
     generic_perform_write+0x108/0x1a8
     __generic_file_write_iter+0x158/0x1c8
     ocfs2_file_write_iter+0x668/0x950 [ocfs2]
     __vfs_write+0x11c/0x190
     vfs_write+0xac/0x1c0
     ksys_write+0x6c/0xd8
     __arm64_sys_write+0x24/0x30
     el0_svc_common+0x78/0x130
     el0_svc_handler+0x38/0x78
     el0_svc+0x8/0xc

To prevent NULL pointer dereference in this situation, we use
is_handle_aborted() before using handle->h_transaction->t_tid.

Link: http://lkml.kernel.org/r/03e750ab-9ade-83aa-b000-b9e81e34e539@huawei.com
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/journal.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 497a4171ef61f..bfb50fc51528f 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -637,9 +637,11 @@ static inline void ocfs2_update_inode_fsync_trans(handle_t *handle,
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	oi->i_sync_tid = handle->h_transaction->t_tid;
-	if (datasync)
-		oi->i_datasync_tid = handle->h_transaction->t_tid;
+	if (!is_handle_aborted(handle)) {
+		oi->i_sync_tid = handle->h_transaction->t_tid;
+		if (datasync)
+			oi->i_datasync_tid = handle->h_transaction->t_tid;
+	}
 }
 
 #endif /* OCFS2_JOURNAL_H */
-- 
2.20.1



