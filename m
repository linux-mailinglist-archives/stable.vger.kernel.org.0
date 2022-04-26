Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8479551087A
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353762AbiDZTFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353753AbiDZTFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF12199817;
        Tue, 26 Apr 2022 12:02:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A9B7B82249;
        Tue, 26 Apr 2022 19:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5393C385AA;
        Tue, 26 Apr 2022 19:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999739;
        bh=iw5SCpFro/JP7l3X7EgKZ6Yqw1DXUGHdxpZWO5Mv9SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrWjcW28WjqmZVgK9fEl0G9PdXTMq7DrCqK16tUPNhIvSN6tU1pRS/nzT+8a+aa2h
         TaJoBMjD8EGh8h/hBHq+9X2p0+IbhSzJyBuUdK0+SdrWJLr15THuPaj9lJlh1a0AkQ
         QpSXSI4qn93pdkFifGszSJ2J0S6QFNlCAFwttZcGDgd+0fBz2+1Q1chhVXI0ThXkjW
         OGo3M6djmLvhNvePTKd5r2VI9QcE/h2oHXIEOlfu4tl17ZDTneBuyh1FjsLXau+a4j
         j9yHC6zmyn01rZXTM3p/gnbK3L2IFDQZUZG0v3sUX7TGhZ+npnYULK5vYBfh+xiCoO
         SvdFODXTJilZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 03/15] ext4: fix bug_on in start_this_handle during umount filesystem
Date:   Tue, 26 Apr 2022 15:02:02 -0400
Message-Id: <20220426190216.2351413-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190216.2351413-1-sashal@kernel.org>
References: <20220426190216.2351413-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit b98535d091795a79336f520b0708457aacf55c67 ]

We got issue as follows:
------------[ cut here ]------------
kernel BUG at fs/jbd2/transaction.c:389!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 9 PID: 131 Comm: kworker/9:1 Not tainted 5.17.0-862.14.0.6.x86_64-00001-g23f87daf7d74-dirty #197
Workqueue: events flush_stashed_error_work
RIP: 0010:start_this_handle+0x41c/0x1160
RSP: 0018:ffff888106b47c20 EFLAGS: 00010202
RAX: ffffed10251b8400 RBX: ffff888128dc204c RCX: ffffffffb52972ac
RDX: 0000000000000200 RSI: 0000000000000004 RDI: ffff888128dc2050
RBP: 0000000000000039 R08: 0000000000000001 R09: ffffed10251b840a
R10: ffff888128dc204f R11: ffffed10251b8409 R12: ffff888116d78000
R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888128dc2000
FS:  0000000000000000(0000) GS:ffff88839d680000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001620068 CR3: 0000000376c0e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 jbd2__journal_start+0x38a/0x790
 jbd2_journal_start+0x19/0x20
 flush_stashed_error_work+0x110/0x2b3
 process_one_work+0x688/0x1080
 worker_thread+0x8b/0xc50
 kthread+0x26f/0x310
 ret_from_fork+0x22/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---

Above issue may happen as follows:
      umount            read procfs            error_work
ext4_put_super
  flush_work(&sbi->s_error_work);

                      ext4_mb_seq_groups_show
	                ext4_mb_load_buddy_gfp
			  ext4_mb_init_group
			    ext4_mb_init_cache
	                      ext4_read_block_bitmap_nowait
			        ext4_validate_block_bitmap
				  ext4_error
			            ext4_handle_error
			              schedule_work(&EXT4_SB(sb)->s_error_work);

  ext4_unregister_sysfs(sb);
  jbd2_journal_destroy(sbi->s_journal);
    journal_kill_thread
      journal->j_flags |= JBD2_UNMOUNT;

                                          flush_stashed_error_work
				            jbd2_journal_start
					      start_this_handle
					        BUG_ON(journal->j_flags & JBD2_UNMOUNT);

To solve this issue, we call 'ext4_unregister_sysfs() before flushing
s_error_work in ext4_put_super().

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/20220322012419.725457-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fd4d34deb9fc..d72adbc7e836 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1167,20 +1167,25 @@ static void ext4_put_super(struct super_block *sb)
 	int aborted = 0;
 	int i, err;
 
-	ext4_unregister_li_request(sb);
-	ext4_quota_off_umount(sb);
-
-	flush_work(&sbi->s_error_work);
-	destroy_workqueue(sbi->rsv_conversion_wq);
-	ext4_release_orphan_info(sb);
-
 	/*
 	 * Unregister sysfs before destroying jbd2 journal.
 	 * Since we could still access attr_journal_task attribute via sysfs
 	 * path which could have sbi->s_journal->j_task as NULL
+	 * Unregister sysfs before flush sbi->s_error_work.
+	 * Since user may read /proc/fs/ext4/xx/mb_groups during umount, If
+	 * read metadata verify failed then will queue error work.
+	 * flush_stashed_error_work will call start_this_handle may trigger
+	 * BUG_ON.
 	 */
 	ext4_unregister_sysfs(sb);
 
+	ext4_unregister_li_request(sb);
+	ext4_quota_off_umount(sb);
+
+	flush_work(&sbi->s_error_work);
+	destroy_workqueue(sbi->rsv_conversion_wq);
+	ext4_release_orphan_info(sb);
+
 	if (sbi->s_journal) {
 		aborted = is_journal_aborted(sbi->s_journal);
 		err = jbd2_journal_destroy(sbi->s_journal);
-- 
2.35.1

