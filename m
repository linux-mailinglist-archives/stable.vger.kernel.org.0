Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC5E5FB55F
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiJKOxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiJKOwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:52:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4669AFCE;
        Tue, 11 Oct 2022 07:51:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7DBC0CE1884;
        Tue, 11 Oct 2022 14:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2535C433D7;
        Tue, 11 Oct 2022 14:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499873;
        bh=b4APTbwxmg5bi6YKhDKQej0hwuw8Ja3ji/KO8Qa+H3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcEgZLD9NajBZsf4xfReb1wTii4z3PTwsneYLA1gn/xUrF566poCbrAultKiO9MXC
         OxSyFrX0KrRhtrFmIr4stXBhEX+g0J+ICFjyDlEv9V0E/ndVB4ySac7vjv8ay3ByYE
         09tVdo5KTjtgjhUUXfzB6MzF2C3i9hfPdC74ziC+JlSTN9hEG/9IEoTSCk+qgW86ch
         NlwrYyorAOSJgC7CCBYxkSgPXSqPWipgNfMSCawoF7YzYNZq2ww1iXWlrMIzHYvbEu
         pVw02gsGDboVAqq0eduRpKBKy1g0v/rUt19ghR1T+JCnoUTUSQCa+PI91qsIXyDuK2
         lD0NhSDBm+Ijw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhang songyi <zhang.songyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 37/46] btrfs: remove the unnecessary result variables
Date:   Tue, 11 Oct 2022 10:50:05 -0400
Message-Id: <20221011145015.1622882-37-sashal@kernel.org>
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

From: zhang songyi <zhang.songyi@zte.com.cn>

[ Upstream commit bd64f6221a98fb1857485c63fd3d8da8d47406c6 ]

Return the sysfs_emit() and iterate_object_props() directly instead of
using unnecessary variables.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/props.c |  5 +----
 fs/btrfs/sysfs.c | 10 ++--------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index a2ec8ecae8de..055a631276ce 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -270,11 +270,8 @@ int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 ino = btrfs_ino(BTRFS_I(inode));
-	int ret;
-
-	ret = iterate_object_props(root, path, ino, inode_prop_iterator, inode);
 
-	return ret;
+	return iterate_object_props(root, path, ino, inode_prop_iterator, inode);
 }
 
 static int prop_compression_validate(const struct btrfs_inode *inode,
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index d5d0717fd09a..484a4ed3ecf8 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -837,11 +837,8 @@ static ssize_t btrfs_sinfo_bg_reclaim_threshold_show(struct kobject *kobj,
 						     char *buf)
 {
 	struct btrfs_space_info *space_info = to_space_info(kobj);
-	ssize_t ret;
-
-	ret = sysfs_emit(buf, "%d\n", READ_ONCE(space_info->bg_reclaim_threshold));
 
-	return ret;
+	return sysfs_emit(buf, "%d\n", READ_ONCE(space_info->bg_reclaim_threshold));
 }
 
 static ssize_t btrfs_sinfo_bg_reclaim_threshold_store(struct kobject *kobj,
@@ -1222,11 +1219,8 @@ static ssize_t btrfs_bg_reclaim_threshold_show(struct kobject *kobj,
 					       char *buf)
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
-	ssize_t ret;
-
-	ret = sysfs_emit(buf, "%d\n", READ_ONCE(fs_info->bg_reclaim_threshold));
 
-	return ret;
+	return sysfs_emit(buf, "%d\n", READ_ONCE(fs_info->bg_reclaim_threshold));
 }
 
 static ssize_t btrfs_bg_reclaim_threshold_store(struct kobject *kobj,
-- 
2.35.1

