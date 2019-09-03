Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D64BA702A
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbfICQ0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730678AbfICQ0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C801C23789;
        Tue,  3 Sep 2019 16:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527998;
        bh=MVLZQSfnTmoyEXqpBENYUw+6JiZTtBhjO8y0I001DNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bXkJ/O7JARS5aeZkot+zMCtqc0dt/SRkCy8nV9vip8XzTU5bMFFenKtmY/YT4fCI
         QXwT1tuonGPzMHTdBITgs2WY9ex12YnjxUdxjDgnBc3hnuMACesSzV0/PMB0Bqv6RS
         aS+JvRAiDyVl+24fJt47RHnN06rA+NL5xnbZF3WY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 046/167] btrfs: volumes: Make sure no dev extent is beyond device boundary
Date:   Tue,  3 Sep 2019 12:23:18 -0400
Message-Id: <20190903162519.7136-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 05a37c48604c19b50873fd9663f9140c150469d1 ]

Add extra dev extent end check against device boundary.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6e008bd5c8cd1..c20708bfae561 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7411,6 +7411,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 	struct extent_map_tree *em_tree = &fs_info->mapping_tree.map_tree;
 	struct extent_map *em;
 	struct map_lookup *map;
+	struct btrfs_device *dev;
 	u64 stripe_len;
 	bool found = false;
 	int ret = 0;
@@ -7460,6 +7461,22 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 			physical_offset, devid);
 		ret = -EUCLEAN;
 	}
+
+	/* Make sure no dev extent is beyond device bondary */
+	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	if (!dev) {
+		btrfs_err(fs_info, "failed to find devid %llu", devid);
+		ret = -EUCLEAN;
+		goto out;
+	}
+	if (physical_offset + physical_len > dev->disk_total_bytes) {
+		btrfs_err(fs_info,
+"dev extent devid %llu physical offset %llu len %llu is beyond device boundary %llu",
+			  devid, physical_offset, physical_len,
+			  dev->disk_total_bytes);
+		ret = -EUCLEAN;
+		goto out;
+	}
 out:
 	free_extent_map(em);
 	return ret;
-- 
2.20.1

