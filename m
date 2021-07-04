Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8303BB169
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhGDXLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhGDXKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31AB861452;
        Sun,  4 Jul 2021 23:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440068;
        bh=H23AYYvulrpKBUSOuzXm0fdjY1KZV6XWaW5BPoth7mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlB5xEyhaZG04NSff5x82q6jWYDNPsN/O4DY3/VHzWyQMv2apKszDw+NlThcegHJX
         Ptyv97b4K01/RzpGhWQ0tI5Ol7UALhASoQUiP0Yv1jH+LAv1YBx3IBCc/JchXGFwSr
         yXO+DR9bN/g3B+RHY6GE9mDynNlJE462puE0vadlYn84WxKVFf2AqOXs+LvOW3LJGG
         VoEP5Utm2S6/GHfuTayHuKpdy7s+mxOJhhS43/Qd4ALiIpXM8GYLQhaDvbbGZQDWnD
         Kgezuj1sFraC6L1wuVTZG57UuNor9Nb4z0/ZHufRKGikf4yCwnRiefpvjtCSO7uRR+
         uXIWwD8RkHYMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 69/80] btrfs: sysfs: fix format string for some discard stats
Date:   Sun,  4 Jul 2021 19:06:05 -0400
Message-Id: <20210704230616.1489200-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit 8c5ec995616f1202ab92e195fd75d6f60d86f85c ]

The type of discard_bitmap_bytes and discard_extent_bytes is u64 so the
format should be %llu, though the actual values would hardly ever
overflow to negative values.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 6eb1c50fa98c..bd95446869d0 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -414,7 +414,7 @@ static ssize_t btrfs_discard_bitmap_bytes_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = discard_to_fs_info(kobj);
 
-	return scnprintf(buf, PAGE_SIZE, "%lld\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 			fs_info->discard_ctl.discard_bitmap_bytes);
 }
 BTRFS_ATTR(discard, discard_bitmap_bytes, btrfs_discard_bitmap_bytes_show);
@@ -436,7 +436,7 @@ static ssize_t btrfs_discard_extent_bytes_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = discard_to_fs_info(kobj);
 
-	return scnprintf(buf, PAGE_SIZE, "%lld\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 			fs_info->discard_ctl.discard_extent_bytes);
 }
 BTRFS_ATTR(discard, discard_extent_bytes, btrfs_discard_extent_bytes_show);
-- 
2.30.2

