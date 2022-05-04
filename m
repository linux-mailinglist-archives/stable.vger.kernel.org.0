Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4D151A728
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354154AbiEDRCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355583AbiEDRAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691264B868;
        Wed,  4 May 2022 09:51:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 749D9B82752;
        Wed,  4 May 2022 16:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B511C385AA;
        Wed,  4 May 2022 16:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683109;
        bh=3U7sqrrWCLxxeCB6R9XUzsC/Y8YeVs1cxEa7tbzOWxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3kPcWrBePbICuoXUdbJgv6kzd5TylN4y329qMBZ1P0Gr37nB0M2eViMkmmwZB4a0
         +6a54+o1aZKYgZY3ayLihM24EeWPd/0MLq63kHMpyTkql43NCQjhmxj8wtjxmAIxPo
         hnxxQeJmd44+WXGdb/5QYMbs7WPJ9z5kjlQgpBA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Jan Kara <jack@suse.cz>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/129] ext4: fix bug_on in start_this_handle during umount filesystem
Date:   Wed,  4 May 2022 18:44:53 +0200
Message-Id: <20220504153028.958476561@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 fs/ext4/super.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5e6c03458317..3e26edeca8c7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1176,18 +1176,23 @@ static void ext4_put_super(struct super_block *sb)
 	int aborted = 0;
 	int i, err;
 
-	ext4_unregister_li_request(sb);
-	ext4_quota_off_umount(sb);
-
-	destroy_workqueue(sbi->rsv_conversion_wq);
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
+	destroy_workqueue(sbi->rsv_conversion_wq);
+
 	if (sbi->s_journal) {
 		aborted = is_journal_aborted(sbi->s_journal);
 		err = jbd2_journal_destroy(sbi->s_journal);
-- 
2.35.1



