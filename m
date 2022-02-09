Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B154AFBE6
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240794AbiBISvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241256AbiBISuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:50:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE557C03E941;
        Wed,  9 Feb 2022 10:46:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8367BB82385;
        Wed,  9 Feb 2022 18:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4E9C340E7;
        Wed,  9 Feb 2022 18:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432390;
        bh=M3g5niZDmS2QGRzOcEgr6nK0pvMXu9h0RVKKGiXxNIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELE5wEbTYfhH08ruRYQI1lPqk0gZsjO8tMHxUHCBcByr/EiUIC83afh2s+7V3UgrE
         zHchVWvKJQmN9rjs+cTlq6FWmoBxkep2yhv2ElF84h2d2zT0g8u9OG8+JXUaXDKM3O
         l69YoDKwFGQJ4iICA5WZBaBEajfEJ86FFY+00xr2uHK2w8mSE+zSTzT8qe6l3VbY6M
         jw0ouXiA91LmmpsbSEfpDJQlLbr8sEyCrqAL2uHFCH6kXLpLI+6WvO4xqhMYm86pr6
         sJ6FWfZwG9ip/UdfWScw3BpSW34uq46eic3/RRUuE2FNL4hETqrvtmV+4x3HR1gGi8
         R9YGJO9SaEnQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 6/7] vfs: make freeze_super abort when sync_filesystem returns error
Date:   Wed,  9 Feb 2022 13:45:49 -0500
Message-Id: <20220209184550.48481-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184550.48481-1-sashal@kernel.org>
References: <20220209184550.48481-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 2719c7160dcfaae1f73a1c0c210ad3281c19022e ]

If we fail to synchronize the filesystem while preparing to freeze the
fs, abort the freeze.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/super.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 377c439477b74..20e9cd2b6488d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1298,11 +1298,9 @@ static void lockdep_sb_freeze_acquire(struct super_block *sb)
 		percpu_rwsem_acquire(sb->s_writers.rw_sem + level, 0, _THIS_IP_);
 }
 
-static void sb_freeze_unlock(struct super_block *sb)
+static void sb_freeze_unlock(struct super_block *sb, int level)
 {
-	int level;
-
-	for (level = SB_FREEZE_LEVELS - 1; level >= 0; level--)
+	for (level--; level >= 0; level--)
 		percpu_up_write(sb->s_writers.rw_sem + level);
 }
 
@@ -1373,7 +1371,14 @@ int freeze_super(struct super_block *sb)
 	sb_wait_write(sb, SB_FREEZE_PAGEFAULT);
 
 	/* All writers are done so after syncing there won't be dirty data */
-	sync_filesystem(sb);
+	ret = sync_filesystem(sb);
+	if (ret) {
+		sb->s_writers.frozen = SB_UNFROZEN;
+		sb_freeze_unlock(sb, SB_FREEZE_PAGEFAULT);
+		wake_up(&sb->s_writers.wait_unfrozen);
+		deactivate_locked_super(sb);
+		return ret;
+	}
 
 	/* Now wait for internal filesystem counter */
 	sb->s_writers.frozen = SB_FREEZE_FS;
@@ -1385,7 +1390,7 @@ int freeze_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_writers.frozen = SB_UNFROZEN;
-			sb_freeze_unlock(sb);
+			sb_freeze_unlock(sb, SB_FREEZE_FS);
 			wake_up(&sb->s_writers.wait_unfrozen);
 			deactivate_locked_super(sb);
 			return ret;
@@ -1437,7 +1442,7 @@ int thaw_super(struct super_block *sb)
 	}
 
 	sb->s_writers.frozen = SB_UNFROZEN;
-	sb_freeze_unlock(sb);
+	sb_freeze_unlock(sb, SB_FREEZE_FS);
 out:
 	wake_up(&sb->s_writers.wait_unfrozen);
 	deactivate_locked_super(sb);
-- 
2.34.1

