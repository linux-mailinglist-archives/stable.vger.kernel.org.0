Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09554BE892
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345777AbiBUIx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 03:53:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345668AbiBUIxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:53:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DE517A9F;
        Mon, 21 Feb 2022 00:52:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DC5CB80EAA;
        Mon, 21 Feb 2022 08:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE66FC340E9;
        Mon, 21 Feb 2022 08:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433570;
        bh=LX4/1hs1SFohhphc14r6GvrG4GtlOhrrIKgHhAeELbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PizHHQzcXIhxDglnONON5J5szozpc2mXAdUQnAbkUvUxA9bNTzGPtGunkeHmltuC+
         bENB8bXXqRQWkYuo4Y2rCPrz+DvydsaMIU9tuIuxowBY1pgctTtxQ6+74sORUNjQ5R
         /donjcZ6VcyOyk7DJROb/pl/NXtK79PCUO14oEuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/45] vfs: make freeze_super abort when sync_filesystem returns error
Date:   Mon, 21 Feb 2022 09:49:03 +0100
Message-Id: <20220221084910.865394502@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084910.454824160@linuxfoundation.org>
References: <20220221084910.454824160@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Darrick J. Wong <djwong@kernel.org>

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
index 1d7461bca1600..819a33e79a011 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1380,11 +1380,9 @@ static void lockdep_sb_freeze_acquire(struct super_block *sb)
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
 
@@ -1455,7 +1453,14 @@ int freeze_super(struct super_block *sb)
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
@@ -1467,7 +1472,7 @@ int freeze_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_writers.frozen = SB_UNFROZEN;
-			sb_freeze_unlock(sb);
+			sb_freeze_unlock(sb, SB_FREEZE_FS);
 			wake_up(&sb->s_writers.wait_unfrozen);
 			deactivate_locked_super(sb);
 			return ret;
@@ -1519,7 +1524,7 @@ int thaw_super(struct super_block *sb)
 	}
 
 	sb->s_writers.frozen = SB_UNFROZEN;
-	sb_freeze_unlock(sb);
+	sb_freeze_unlock(sb, SB_FREEZE_FS);
 out:
 	wake_up(&sb->s_writers.wait_unfrozen);
 	deactivate_locked_super(sb);
-- 
2.34.1



