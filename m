Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BA25FB66A
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJKPET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiJKPCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:02:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2529C7F0;
        Tue, 11 Oct 2022 07:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86579611D0;
        Tue, 11 Oct 2022 14:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D89C43470;
        Tue, 11 Oct 2022 14:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499982;
        bh=RbzMwJKSMzifuqi8AhO0nu6C4QQcB3sBDVIF/2sbV/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srlykvvkvAT7MNDwhIqeK2e8H6yEMQTfF8WQAT9ExprgpRWQyvGHFsU2PrgWY3xY8
         eE+HtnovVIeBoyNXFZHvFhvBAR7FM3qs2HnjjOH6GcvOw2Ot+ckMGSMyS3Xi849q/o
         NONrMJwu3ihYlMf9d4bjEFjJysJPxo33MjGvwetQzFbkjz1rNJIXHJT6e/9tDEkngF
         gOJwuh2Iw96ufEhVdh/NxT+QKEgTiATJL4e72iH5ysNHvV03EldOY1H18Pb89MGKSU
         yvbVI6ZZm6KkCjrVujICGWmwTYUUV78bu/yn0e1qVsdyTWJOE4Q5Qa7nrj81z7jRTq
         JLSQStpWFJXJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 20/26] btrfs: don't print information about space cache or tree every remount
Date:   Tue, 11 Oct 2022 10:52:27 -0400
Message-Id: <20221011145233.1624013-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145233.1624013-1-sashal@kernel.org>
References: <20221011145233.1624013-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

[ Upstream commit dbecac26630014d336a8e5ea67096ff18210fb9c ]

btrfs currently prints information about space cache or free space tree
being in use on every remount, regardless whether such remount actually
enabled or disabled one of these features.

This is actually unnecessary since providing remount options changing the
state of these features will explicitly print the appropriate notice.

Let's instead print such unconditional information just on an initial mount
to avoid filling the kernel log when, for example, laptop-mode-tools
remount the fs on some events.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/super.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 969bf0724fdf..442fcd1b14a6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -574,6 +574,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 	int saved_compress_level;
 	bool saved_compress_force;
 	int no_compress = 0;
+	const bool remounting = test_bit(BTRFS_FS_STATE_REMOUNTING, &info->fs_state);
 
 	if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
 		btrfs_set_opt(info->mount_opt, FREE_SPACE_TREE);
@@ -1065,10 +1066,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 	}
 	if (!ret)
 		ret = btrfs_check_mountopts_zoned(info);
-	if (!ret && btrfs_test_opt(info, SPACE_CACHE))
-		btrfs_info(info, "disk space caching is enabled");
-	if (!ret && btrfs_test_opt(info, FREE_SPACE_TREE))
-		btrfs_info(info, "using free space tree");
+	if (!ret && !remounting) {
+		if (btrfs_test_opt(info, SPACE_CACHE))
+			btrfs_info(info, "disk space caching is enabled");
+		if (btrfs_test_opt(info, FREE_SPACE_TREE))
+			btrfs_info(info, "using free space tree");
+	}
 	return ret;
 }
 
-- 
2.35.1

