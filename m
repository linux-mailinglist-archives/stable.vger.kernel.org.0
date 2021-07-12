Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917FB3C48CA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbhGLGk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237919AbhGLGjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B4A161175;
        Mon, 12 Jul 2021 06:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071744;
        bh=iXWUN98jx3JLlOGPuVyKL7wiVdseHkC2hZfUoaHLIZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGngb5DSJ7HcTs4pkjUbJrnpeTX/0x1ftr0Iv73INtRtTgjvjigtzrLmEFr/lqj/T
         RjCH1moF2YvZPR5BZwugj+o1XTsisfp3iSiMdGc8AAr/mqxlio6k9zrcWq0J+TRxuA
         Yi8d1gS2yvyBeMTUuZOa143fMVYget68aIuKFzqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/593] btrfs: sysfs: fix format string for some discard stats
Date:   Mon, 12 Jul 2021 08:05:18 +0200
Message-Id: <20210712060900.432885025@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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



