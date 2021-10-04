Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C355A421046
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238404AbhJDNmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238401AbhJDNkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:40:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B774E63241;
        Mon,  4 Oct 2021 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353514;
        bh=sOVzJxwK84o5XNM1rfS3b5If5JqEFxjGHjgIVU5UD90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ywc15LXXkTL6M5NJfdVfFnlbIcLJ0RvnCyXCEgzvtFAB9mYDZoUs7NsD1EksUV6ru
         vvo/RKVP8OO5Zs+CSNAP+PFYX+b0+vZBqlATvWYM/avOL3E0SmUDQVa+mDtATLe5DX
         3nNIOciZoJXknWDQqi5BpBhsjoNoPgfpjieGfbtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        yangerkun <yangerkun@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.14 158/172] ext4: flush s_error_work before journal destroy in ext4_fill_super
Date:   Mon,  4 Oct 2021 14:53:28 +0200
Message-Id: <20211004125050.070888021@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

commit bb9464e08309f6befe80866f5be51778ca355ee9 upstream.

The error path in ext4_fill_super forget to flush s_error_work before
journal destroy, and it may trigger the follow bug since
flush_stashed_error_work can run concurrently with journal destroy
without any protection for sbi->s_journal.

[32031.740193] EXT4-fs (loop66): get root inode failed
[32031.740484] EXT4-fs (loop66): mount failed
[32031.759805] ------------[ cut here ]------------
[32031.759807] kernel BUG at fs/jbd2/transaction.c:373!
[32031.760075] invalid opcode: 0000 [#1] SMP PTI
[32031.760336] CPU: 5 PID: 1029268 Comm: kworker/5:1 Kdump: loaded
4.18.0
[32031.765112] Call Trace:
[32031.765375]  ? __switch_to_asm+0x35/0x70
[32031.765635]  ? __switch_to_asm+0x41/0x70
[32031.765893]  ? __switch_to_asm+0x35/0x70
[32031.766148]  ? __switch_to_asm+0x41/0x70
[32031.766405]  ? _cond_resched+0x15/0x40
[32031.766665]  jbd2__journal_start+0xf1/0x1f0 [jbd2]
[32031.766934]  jbd2_journal_start+0x19/0x20 [jbd2]
[32031.767218]  flush_stashed_error_work+0x30/0x90 [ext4]
[32031.767487]  process_one_work+0x195/0x390
[32031.767747]  worker_thread+0x30/0x390
[32031.768007]  ? process_one_work+0x390/0x390
[32031.768265]  kthread+0x10d/0x130
[32031.768521]  ? kthread_flush_work_fn+0x10/0x10
[32031.768778]  ret_from_fork+0x35/0x40

static int start_this_handle(...)
    BUG_ON(journal->j_flags & JBD2_UNMOUNT); <---- Trigger this

Besides, after we enable fast commit, ext4_fc_replay can add work to
s_error_work but return success, so the latter journal destroy in
ext4_load_journal can trigger this problem too.

Fix this problem with two steps:
1. Call ext4_commit_super directly in ext4_handle_error for the case
   that called from ext4_fc_replay
2. Since it's hard to pair the init and flush for s_error_work, we'd
   better add a extras flush_work before journal destroy in
   ext4_fill_super

Besides, this patch will call ext4_commit_super in ext4_handle_error for
any nojournal case too. But it seems safe since the reason we call
schedule_work was that we should save error info to sb through journal
if available. Conversely, for the nojournal case, it seems useless delay
commit superblock to s_error_work.

Fixes: c92dc856848f ("ext4: defer saving error info from atomic context")
Fixes: 2d01ddc86606 ("ext4: save error info to sb through journal if available")
Cc: stable@kernel.org
Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210924093917.1953239-1-yangerkun@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -661,7 +661,7 @@ static void ext4_handle_error(struct sup
 		 * constraints, it may not be safe to do it right here so we
 		 * defer superblock flushing to a workqueue.
 		 */
-		if (continue_fs)
+		if (continue_fs && journal)
 			schedule_work(&EXT4_SB(sb)->s_error_work);
 		else
 			ext4_commit_super(sb);
@@ -5189,12 +5189,15 @@ failed_mount_wq:
 	sbi->s_ea_block_cache = NULL;
 
 	if (sbi->s_journal) {
+		/* flush s_error_work before journal destroy. */
+		flush_work(&sbi->s_error_work);
 		jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
 	}
 failed_mount3a:
 	ext4_es_unregister_shrinker(sbi);
 failed_mount3:
+	/* flush s_error_work before sbi destroy */
 	flush_work(&sbi->s_error_work);
 	del_timer_sync(&sbi->s_err_report);
 	ext4_stop_mmpd(sbi);


