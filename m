Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DFE11CB4E
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 11:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfLLKuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 05:50:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:57138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728722AbfLLKuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 05:50:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2325DAD29;
        Thu, 12 Dec 2019 10:50:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 04D7A1E0B8A; Thu, 12 Dec 2019 11:50:20 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     reiserfs-devel@vger.kernel.org
Cc:     <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] reiserfs: Fix memory leak of journal device string
Date:   Thu, 12 Dec 2019 11:50:17 +0100
Message-Id: <20191212105018.910-2-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191212105018.910-1-jack@suse.cz>
References: <20191212105018.910-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a filesystem is mounted with jdev mount option, we store the
journal device name in an allocated string in superblock. However we
fail to ever free that string. Fix it.

Reported-by: syzbot+1c6756baf4b16b94d2a6@syzkaller.appspotmail.com
Fixes: c3aa077648e1 ("reiserfs: Properly display mount options in /proc/mounts")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 3244037b1286..d127af64283e 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -629,6 +629,7 @@ static void reiserfs_put_super(struct super_block *s)
 	reiserfs_write_unlock(s);
 	mutex_destroy(&REISERFS_SB(s)->lock);
 	destroy_workqueue(REISERFS_SB(s)->commit_wq);
+	kfree(REISERFS_SB(s)->s_jdev);
 	kfree(s->s_fs_info);
 	s->s_fs_info = NULL;
 }
@@ -2240,6 +2241,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 			kfree(qf_names[j]);
 	}
 #endif
+	kfree(sbi->s_jdev);
 	kfree(sbi);
 
 	s->s_fs_info = NULL;
-- 
2.16.4

