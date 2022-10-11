Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B152F5FB5DB
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiJKPAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiJKO5V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:57:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FF09E0D8;
        Tue, 11 Oct 2022 07:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5A5BFCE1748;
        Tue, 11 Oct 2022 14:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EE9C43470;
        Tue, 11 Oct 2022 14:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499939;
        bh=7CIXEYSAFuWxl92Tjpt7YuUtpfkm/cVmMsTSmhp9nxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwLadPlGMhmoN2b9qxsiIe53JsKvdG+OragmdegTSpRlkRwYi+RlCq4oL+De2eHZJ
         QoFt5M71vEzii2N/RiRWUOY+UpRNgJOLSOEmRgKWlqeTr9mrGUNQn0TaUN+xbe7tya
         ADCd3d/2ai3KM96F6l4O8vUzEKD0tPcekJ++SFVJro9C/nmwzIos3WZYZZ9+YyTTMf
         c0Q96hXunLLGEro2WlLhwoeH1+cTebIX19EYhWjHAKDKrFrNhP54ZxFQvW6pO90eoW
         3Qi3M+vJuSJHqrsQfWIrWOK3yCemJcpS7PzfHWnm7x2wLhnnci8fONeL2bIDo3f2Gx
         SnYrw1LU1jhmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhang songyi <zhang.songyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 32/40] btrfs: remove the unnecessary result variables
Date:   Tue, 11 Oct 2022 10:51:21 -0400
Message-Id: <20221011145129.1623487-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
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
index 92a1fa8e3da6..90bc674c7c37 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -725,11 +725,8 @@ static ssize_t btrfs_sinfo_bg_reclaim_threshold_show(struct kobject *kobj,
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
@@ -1064,11 +1061,8 @@ static ssize_t btrfs_bg_reclaim_threshold_show(struct kobject *kobj,
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

