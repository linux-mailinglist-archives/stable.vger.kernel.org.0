Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855843C4C8C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241956AbhGLHGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241765AbhGLHED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:04:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88FC061205;
        Mon, 12 Jul 2021 07:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073276;
        bh=H23AYYvulrpKBUSOuzXm0fdjY1KZV6XWaW5BPoth7mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6g3hs0Z8NVcsUTpi/IjmMRjrMtQ8cS/eFQFCN34316Zw2sy96FNu5Qq/ihCa7SaE
         0tDZijleB2vcv4+fUu886C4/J14Xe3GXuZnQYceiwmesLzavLb+v43zgTRlNvRk7tj
         WVxIvo22J8IhypvEjzPrat9KF9R7EF50x8iIt7Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 186/700] btrfs: sysfs: fix format string for some discard stats
Date:   Mon, 12 Jul 2021 08:04:29 +0200
Message-Id: <20210712060953.064614563@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



