Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E831959491E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242200AbiHOXWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347820AbiHOXVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:21:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6D67E334;
        Mon, 15 Aug 2022 13:04:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B09A6068D;
        Mon, 15 Aug 2022 20:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20802C433D7;
        Mon, 15 Aug 2022 20:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593889;
        bh=5ZU6X8oaR8xjXctu3ueiBJ3MhQdIAk1kx0PHsF8cpTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=we3JILC+b5wRUNYU2S/0f7Ut6Xtt3THzhARarDzKLdySSt7O2UABTIYAlJbFWFj9n
         T1di6mXQZdBUEqBsRzmTs+W04v6IjUmvKrV7RwU3Ac9lFbv7qkDibD0xrH47XYS2HE
         58MuQubeWFsfPp3znas049+NOuJNxa/C0Sk2syBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1024/1095] btrfs: make the bg_reclaim_threshold per-space info
Date:   Mon, 15 Aug 2022 20:07:03 +0200
Message-Id: <20220815180511.435577823@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit bb5a098d9791f184899499531ff4411089e2a5e0 ]

For non-zoned file systems it's useful to have the auto reclaim feature,
however there are different use cases for non-zoned, for example we may
not want to reclaim metadata chunks ever, only data chunks.  Move this
sysfs flag to per-space_info.  This won't affect current users because
this tunable only ever did anything for zoned, and that is currently
hidden behind BTRFS_CONFIG_DEBUG.

Tested-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ jth restore global bg_reclaim_threshold ]
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c |  7 +++++--
 fs/btrfs/space-info.c       |  9 +++++++++
 fs/btrfs/space-info.h       |  6 ++++++
 fs/btrfs/sysfs.c            | 37 +++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h            |  6 +-----
 5 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 01a408db5683..ef84bc5030cd 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2630,16 +2630,19 @@ int __btrfs_add_free_space(struct btrfs_block_group *block_group,
 static int __btrfs_add_free_space_zoned(struct btrfs_block_group *block_group,
 					u64 bytenr, u64 size, bool used)
 {
-	struct btrfs_fs_info *fs_info = block_group->fs_info;
+	struct btrfs_space_info *sinfo = block_group->space_info;
 	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	u64 offset = bytenr - block_group->start;
 	u64 to_free, to_unusable;
-	const int bg_reclaim_threshold = READ_ONCE(fs_info->bg_reclaim_threshold);
+	int bg_reclaim_threshold = 0;
 	bool initial = (size == block_group->length);
 	u64 reclaimable_unusable;
 
 	WARN_ON(!initial && offset + size > block_group->zone_capacity);
 
+	if (!initial)
+		bg_reclaim_threshold = READ_ONCE(sinfo->bg_reclaim_threshold);
+
 	spin_lock(&ctl->tree_lock);
 	if (!used)
 		to_free = size;
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 56a7c99fc03e..85608acb9557 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -181,6 +181,12 @@ void btrfs_clear_space_info_full(struct btrfs_fs_info *info)
 		found->full = 0;
 }
 
+/*
+ * Block groups with more than this value (percents) of unusable space will be
+ * scheduled for background reclaim.
+ */
+#define BTRFS_DEFAULT_ZONED_RECLAIM_THRESH			(75)
+
 static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 {
 
@@ -203,6 +209,9 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 	INIT_LIST_HEAD(&space_info->priority_tickets);
 	space_info->clamp = 1;
 
+	if (btrfs_is_zoned(info))
+		space_info->bg_reclaim_threshold = BTRFS_DEFAULT_ZONED_RECLAIM_THRESH;
+
 	ret = btrfs_sysfs_add_space_info_type(info, space_info);
 	if (ret)
 		return ret;
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index d841fed73492..a803e29bd781 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -24,6 +24,12 @@ struct btrfs_space_info {
 				   the space info if we had an ENOSPC in the
 				   allocator. */
 
+	/*
+	 * Once a block group drops below this threshold (percents) we'll
+	 * schedule it for reclaim.
+	 */
+	int bg_reclaim_threshold;
+
 	int clamp;		/* Used to scale our threshold for preemptive
 				   flushing. The value is >> clamp, so turns
 				   out to be a 2^clamp divisor. */
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index ba78ca5aabbb..43845cae0c74 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -722,6 +722,42 @@ SPACE_INFO_ATTR(bytes_zone_unusable);
 SPACE_INFO_ATTR(disk_used);
 SPACE_INFO_ATTR(disk_total);
 
+static ssize_t btrfs_sinfo_bg_reclaim_threshold_show(struct kobject *kobj,
+						     struct kobj_attribute *a,
+						     char *buf)
+{
+	struct btrfs_space_info *space_info = to_space_info(kobj);
+	ssize_t ret;
+
+	ret = sysfs_emit(buf, "%d\n", READ_ONCE(space_info->bg_reclaim_threshold));
+
+	return ret;
+}
+
+static ssize_t btrfs_sinfo_bg_reclaim_threshold_store(struct kobject *kobj,
+						      struct kobj_attribute *a,
+						      const char *buf, size_t len)
+{
+	struct btrfs_space_info *space_info = to_space_info(kobj);
+	int thresh;
+	int ret;
+
+	ret = kstrtoint(buf, 10, &thresh);
+	if (ret)
+		return ret;
+
+	if (thresh != 0 && (thresh <= 50 || thresh > 100))
+		return -EINVAL;
+
+	WRITE_ONCE(space_info->bg_reclaim_threshold, thresh);
+
+	return len;
+}
+
+BTRFS_ATTR_RW(space_info, bg_reclaim_threshold,
+	      btrfs_sinfo_bg_reclaim_threshold_show,
+	      btrfs_sinfo_bg_reclaim_threshold_store);
+
 /*
  * Allocation information about block group types.
  *
@@ -738,6 +774,7 @@ static struct attribute *space_info_attrs[] = {
 	BTRFS_ATTR_PTR(space_info, bytes_zone_unusable),
 	BTRFS_ATTR_PTR(space_info, disk_used),
 	BTRFS_ATTR_PTR(space_info, disk_total),
+	BTRFS_ATTR_PTR(space_info, bg_reclaim_threshold),
 	NULL,
 };
 ATTRIBUTE_GROUPS(space_info);
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index c424417e19bb..199b69670fa2 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -10,11 +10,7 @@
 #include "block-group.h"
 #include "btrfs_inode.h"
 
-/*
- * Block groups with more than this value (percents) of unusable space will be
- * scheduled for background reclaim.
- */
-#define BTRFS_DEFAULT_RECLAIM_THRESH		75
+#define BTRFS_DEFAULT_RECLAIM_THRESH           			(75)
 
 struct btrfs_zoned_device_info {
 	/*
-- 
2.35.1



