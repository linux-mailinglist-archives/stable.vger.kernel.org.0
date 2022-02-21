Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602E24BDBBC
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244691AbiBUJWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:22:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349701AbiBUJVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD37626ADB;
        Mon, 21 Feb 2022 01:08:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B719CE0E92;
        Mon, 21 Feb 2022 09:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE7BC340F4;
        Mon, 21 Feb 2022 09:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434520;
        bh=wpyf4EP47UnTT4MLirHHjUfl41vKf0RPd5Bd+CIhiNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPep7jusosR7HypxZd4SMHgu1dsAw8CRz+g6d3EWk8ETS0aDdqsnO62p8ItKDYEZN
         5hZTY5k6u8EM1C2bN9WWlEG7WA3HFkIp5m7JSI+LatX8o2pqSeryv0FPgsmomaTaNC
         YmV1wmuspGUFWqpu6Mgn7KnG7ylVvTKSW2os+4Fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/196] vfs: make freeze_super abort when sync_filesystem returns error
Date:   Mon, 21 Feb 2022 09:47:48 +0100
Message-Id: <20220221084932.142296329@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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
index a1f82dfd1b39a..87379bb1f7a30 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1616,11 +1616,9 @@ static void lockdep_sb_freeze_acquire(struct super_block *sb)
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
 
@@ -1691,7 +1689,14 @@ int freeze_super(struct super_block *sb)
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
@@ -1703,7 +1708,7 @@ int freeze_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_writers.frozen = SB_UNFROZEN;
-			sb_freeze_unlock(sb);
+			sb_freeze_unlock(sb, SB_FREEZE_FS);
 			wake_up(&sb->s_writers.wait_unfrozen);
 			deactivate_locked_super(sb);
 			return ret;
@@ -1748,7 +1753,7 @@ static int thaw_super_locked(struct super_block *sb)
 	}
 
 	sb->s_writers.frozen = SB_UNFROZEN;
-	sb_freeze_unlock(sb);
+	sb_freeze_unlock(sb, SB_FREEZE_FS);
 out:
 	wake_up(&sb->s_writers.wait_unfrozen);
 	deactivate_locked_super(sb);
-- 
2.34.1



