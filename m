Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF433B1F0F
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389686AbfIMNPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389070AbfIMNPW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:22 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB8C8214D8;
        Fri, 13 Sep 2019 13:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380522;
        bh=awY45/ht+lyuUV0fbMcLrqlDylGYw3vE8THQWBXkhZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqsDg+R0EJZxXqunC8F0SOR90xTey5DthivZrGijLZYgybrUziSpOyaODl+ipa2G2
         fhchQNi9AZ/WFsCATTFGURN9Sp7/KV84jbIsWRSrX+snphKsnnWFQLVQFfHGa0eOC3
         wj0qT4LU795tW9APvUfbjNfjYt1JFo28LL/6eYcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/190] btrfs: volumes: Make sure no dev extent is beyond device boundary
Date:   Fri, 13 Sep 2019 14:05:28 +0100
Message-Id: <20190913130605.428254115@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



