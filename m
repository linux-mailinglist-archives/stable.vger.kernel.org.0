Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1ED33C312
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 18:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbhCOQ7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 12:59:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:49772 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235214AbhCOQ70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 12:59:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D46A8AC17;
        Mon, 15 Mar 2021 16:59:24 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 6E76A1F2BC9; Mon, 15 Mar 2021 17:59:11 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        syzbot+628472a2aac693ab0fcd@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH] ext4: Fix timer use-after-free on failed mount
Date:   Mon, 15 Mar 2021 17:59:06 +0100
Message-Id: <20210315165906.2175-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When filesystem mount fails because of corrupted filesystem we first
cancel the s_err_report timer reminding fs errors every day and only
then we flush s_error_work. However s_error_work may report another fs
error and re-arm timer thus resulting in timer use-after-free. Fix the
problem by first flushing the work and only after that canceling the
s_err_report timer.

Reported-by: syzbot+628472a2aac693ab0fcd@syzkaller.appspotmail.com
Fixes: 2d01ddc86606 ("ext4: save error info to sb through journal if available")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ad34a37278cd..2e3d4c5c2eb4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5149,8 +5149,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 failed_mount3a:
 	ext4_es_unregister_shrinker(sbi);
 failed_mount3:
-	del_timer_sync(&sbi->s_err_report);
 	flush_work(&sbi->s_error_work);
+	del_timer_sync(&sbi->s_err_report);
 	if (sbi->s_mmp_tsk)
 		kthread_stop(sbi->s_mmp_tsk);
 failed_mount2:
-- 
2.26.2

