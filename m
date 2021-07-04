Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815823BB398
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhGDXSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233103AbhGDXOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0270361969;
        Sun,  4 Jul 2021 23:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440164;
        bh=iXWUN98jx3JLlOGPuVyKL7wiVdseHkC2hZfUoaHLIZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0k+wqAU3otfH98710yaVpJRVUh3+0MAo3J0hYJM7NpnU/DbujSR77im3fyijwJEC
         oqKFOhYOPYtL9vYCy33xCzvJkveAigwkwWJVHrLPibG5fNVd+2uuXfgxLZZVE3to44
         5a5VEVjGb3ccKC9T5uvmpcAuhJdQp3HcPjHcWpuBEjQ4zxzcFevENdMcBK76qf755T
         F0GNmfxULu+31ysvw4uqDXU3bN1AwNPWAUn8XJIa54hkW3NLq4e5B86ndCrfiCEufY
         9EztiiOXdk5qt7LaDJyayY8sZ63leGBzPuq7bRbMiZWDNG7AAV3PV6j6G/cOiJNkLB
         Qss11lGQXpTuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 60/70] btrfs: sysfs: fix format string for some discard stats
Date:   Sun,  4 Jul 2021 19:07:53 -0400
Message-Id: <20210704230804.1490078-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
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
index 279d9262b676..3bb6b688ece5 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -382,7 +382,7 @@ static ssize_t btrfs_discard_bitmap_bytes_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = discard_to_fs_info(kobj);
 
-	return scnprintf(buf, PAGE_SIZE, "%lld\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 			fs_info->discard_ctl.discard_bitmap_bytes);
 }
 BTRFS_ATTR(discard, discard_bitmap_bytes, btrfs_discard_bitmap_bytes_show);
@@ -404,7 +404,7 @@ static ssize_t btrfs_discard_extent_bytes_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = discard_to_fs_info(kobj);
 
-	return scnprintf(buf, PAGE_SIZE, "%lld\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 			fs_info->discard_ctl.discard_extent_bytes);
 }
 BTRFS_ATTR(discard, discard_extent_bytes, btrfs_discard_extent_bytes_show);
-- 
2.30.2

