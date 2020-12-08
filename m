Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AFE2D2D03
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 15:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgLHOWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 09:22:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:41362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729840AbgLHOWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 09:22:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 75C23AD7C;
        Tue,  8 Dec 2020 14:22:12 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3F60A1E133E; Tue,  8 Dec 2020 15:22:12 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] quota: Fix error handling path of dquot_resume()
Date:   Tue,  8 Dec 2020 15:22:08 +0100
Message-Id: <20201208142208.14096-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When reloading of quota failed we tried to cleanup using
vfs_cleanup_quota_inode() however we passed wrong 'type' argument. Fix
that.

Fixes: ae45f07d47cc ("quota: Simplify dquot_resume()")
Reported-by: syzbot+2643e825238d7aabb37f@syzkaller.appspotmail.com
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

I plan to queue this patch to my tree for the merge window.

								Honza

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index bb02989d92b6..4f1373463766 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2455,7 +2455,7 @@ int dquot_resume(struct super_block *sb, int type)
 		ret = dquot_load_quota_sb(sb, cnt, dqopt->info[cnt].dqi_fmt_id,
 					  flags);
 		if (ret < 0)
-			vfs_cleanup_quota_inode(sb, type);
+			vfs_cleanup_quota_inode(sb, cnt);
 	}
 
 	return ret;
-- 
2.16.4

