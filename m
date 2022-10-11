Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8669F5FB55E
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiJKOxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiJKOwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:52:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433916B8F3;
        Tue, 11 Oct 2022 07:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6335B811F5;
        Tue, 11 Oct 2022 14:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C219C433D6;
        Tue, 11 Oct 2022 14:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499869;
        bh=m8AjujuI84mFQB5vrcRAbz/2Sxf94CEzaFq6piOQRPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TStrIjKkgkbYGvskBkJzSJXN8TKYS7YggZhyfOh8mVocRq8rivTCEGqDYhqKZKoVt
         KftjaDcu7Vj6+G9nypEVHXwjttR3xf0LZWEwiLFx6Amb2Gx6/vKryJ3zwfXhIxZdnW
         QCuOtGlK6Z/26mtVEvNMPCJPHYVSmgRLKJRbmuTlTQlt/bjD5W8alaJOrNazhPAcDn
         jS6Z1RCJc5sfB0tRPDNL8tjFToQKK5T8fp3x9ZzvHP4KmmywEoH8cQplgyJQOPDuj2
         7ai6khp9lWWujs+wapsfqz0XwInO4v1okiRraxgUTO71quiBp1bbRdQKU81gT+YKfY
         mpte3I4WwPBYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 34/46] btrfs: don't print information about space cache or tree every remount
Date:   Tue, 11 Oct 2022 10:50:02 -0400
Message-Id: <20221011145015.1622882-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
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
index f89beac3c665..f1c6ca59299e 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -626,6 +626,7 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 	int saved_compress_level;
 	bool saved_compress_force;
 	int no_compress = 0;
+	const bool remounting = test_bit(BTRFS_FS_STATE_REMOUNTING, &info->fs_state);
 
 	if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
 		btrfs_set_opt(info->mount_opt, FREE_SPACE_TREE);
@@ -1137,10 +1138,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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

