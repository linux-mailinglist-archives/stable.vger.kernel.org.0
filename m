Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927DC59D8F5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243850AbiHWJxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239498AbiHWJvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:51:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B739F199;
        Tue, 23 Aug 2022 01:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FDFE61538;
        Tue, 23 Aug 2022 08:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C088C433D6;
        Tue, 23 Aug 2022 08:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244308;
        bh=RV5lvrGojSt03S8hfAZkFwEi+RNIqI0sjsluXw/4lY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcunCx1iXGi9M6ZC2V07KBb7hoVFdSI0K955khr1sqboeW5x/NHXEZLN4wK66coBv
         6VC1mXnNr/zZjmAtEd5f93ogR6jOXCaBWk3stNwv3sOOqhuG6IHB6UADzNe/x5UuEM
         R7eHfZBFsAa6v3V4EDGzF+oyrCP5RQeruG4ybr/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 117/229] jbd2: fix assertion jh->b_frozen_data == NULL failure when journal aborted
Date:   Tue, 23 Aug 2022 10:24:38 +0200
Message-Id: <20220823080057.872861919@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 4a734f0869f970b8a9b65062ea40b09a5da9dba8 ]

Following process will fail assertion 'jh->b_frozen_data == NULL' in
jbd2_journal_dirty_metadata():

                   jbd2_journal_commit_transaction
unlink(dir/a)
 jh->b_transaction = trans1
 jh->b_jlist = BJ_Metadata
                    journal->j_running_transaction = NULL
                    trans1->t_state = T_COMMIT
unlink(dir/b)
 handle->h_trans = trans2
 do_get_write_access
  jh->b_modified = 0
  jh->b_frozen_data = frozen_buffer
  jh->b_next_transaction = trans2
 jbd2_journal_dirty_metadata
  is_handle_aborted
   is_journal_aborted // return false

           --> jbd2 abort <--

                     while (commit_transaction->t_buffers)
                      if (is_journal_aborted)
                       jbd2_journal_refile_buffer
                        __jbd2_journal_refile_buffer
                         WRITE_ONCE(jh->b_transaction,
						jh->b_next_transaction)
                         WRITE_ONCE(jh->b_next_transaction, NULL)
                         __jbd2_journal_file_buffer(jh, BJ_Reserved)
        J_ASSERT_JH(jh, jh->b_frozen_data == NULL) // assertion failure !

The reproducer (See detail in [Link]) reports:
 ------------[ cut here ]------------
 kernel BUG at fs/jbd2/transaction.c:1629!
 invalid opcode: 0000 [#1] PREEMPT SMP
 CPU: 2 PID: 584 Comm: unlink Tainted: G        W
 5.19.0-rc6-00115-g4a57a8400075-dirty #697
 RIP: 0010:jbd2_journal_dirty_metadata+0x3c5/0x470
 RSP: 0018:ffffc90000be7ce0 EFLAGS: 00010202
 Call Trace:
  <TASK>
  __ext4_handle_dirty_metadata+0xa0/0x290
  ext4_handle_dirty_dirblock+0x10c/0x1d0
  ext4_delete_entry+0x104/0x200
  __ext4_unlink+0x22b/0x360
  ext4_unlink+0x275/0x390
  vfs_unlink+0x20b/0x4c0
  do_unlinkat+0x42f/0x4c0
  __x64_sys_unlink+0x37/0x50
  do_syscall_64+0x35/0x80

After journal aborting, __jbd2_journal_refile_buffer() is executed with
holding @jh->b_state_lock, we can fix it by moving 'is_handle_aborted()'
into the area protected by @jh->b_state_lock.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216251
Fixes: 470decc613ab20 ("[PATCH] jbd2: initial copy of files from jbd")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://lore.kernel.org/r/20220715125152.4022726-1-chengzhihao1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/transaction.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 3311b1e684de..7eb4f7c0a43b 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1338,8 +1338,6 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	struct journal_head *jh;
 	int ret = 0;
 
-	if (is_handle_aborted(handle))
-		return -EROFS;
 	if (!buffer_jbd(bh))
 		return -EUCLEAN;
 
@@ -1386,6 +1384,18 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	journal = transaction->t_journal;
 	jbd_lock_bh_state(bh);
 
+	if (is_handle_aborted(handle)) {
+		/*
+		 * Check journal aborting with @jh->b_state_lock locked,
+		 * since 'jh->b_transaction' could be replaced with
+		 * 'jh->b_next_transaction' during old transaction
+		 * committing if journal aborted, which may fail
+		 * assertion on 'jh->b_frozen_data == NULL'.
+		 */
+		ret = -EROFS;
+		goto out_unlock_bh;
+	}
+
 	if (jh->b_modified == 0) {
 		/*
 		 * This buffer's got modified and becoming part
-- 
2.35.1



