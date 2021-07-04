Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87703BB0A0
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhGDXJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231325AbhGDXIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C18661946;
        Sun,  4 Jul 2021 23:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439959;
        bh=mwyT0CnTFy0k8PpQGR1TNJY0zisSRYQ8wl4PXiE2MaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNXLuiBCkdAHZWoLYD1QYLD03EoV2i5syqYuW5nTP2gS8RD1/NtdWnNIeO44goWHi
         0yalzQ9NkNAfyrw9pXicnQQ/ZnQqeVXW3iZ7YRD991NWzohM+WVavqcgY4/l0BqFvm
         4GBeWxFygZk199qz6bnxyUImCERKTgC5ni1lrA429w3bdA6EkgFBvuNY9pH2UxvB+I
         MJK5MfmjWteV2HQv1T0lmPAVG4VwUjx/YFfx2JVgI0k3iLwC6QGu3pJCzZDh/XRIDm
         tSqES7sSQn6Ay+AWk4IwihVUzdW1dMCIjQ7BAbbfSEvb7D0+ruJ+j/EhG99fUEl3Ro
         ma9IrY3uyJf9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 73/85] btrfs: sysfs: fix format string for some discard stats
Date:   Sun,  4 Jul 2021 19:04:08 -0400
Message-Id: <20210704230420.1488358-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
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
index 436ac7b4b334..4f5b14cd3a19 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -429,7 +429,7 @@ static ssize_t btrfs_discard_bitmap_bytes_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = discard_to_fs_info(kobj);
 
-	return scnprintf(buf, PAGE_SIZE, "%lld\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 			fs_info->discard_ctl.discard_bitmap_bytes);
 }
 BTRFS_ATTR(discard, discard_bitmap_bytes, btrfs_discard_bitmap_bytes_show);
@@ -451,7 +451,7 @@ static ssize_t btrfs_discard_extent_bytes_show(struct kobject *kobj,
 {
 	struct btrfs_fs_info *fs_info = discard_to_fs_info(kobj);
 
-	return scnprintf(buf, PAGE_SIZE, "%lld\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 			fs_info->discard_ctl.discard_extent_bytes);
 }
 BTRFS_ATTR(discard, discard_extent_bytes, btrfs_discard_extent_bytes_show);
-- 
2.30.2

