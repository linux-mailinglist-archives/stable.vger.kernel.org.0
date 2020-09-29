Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F170427C915
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbgI2MH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730241AbgI2Lhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E94E622204;
        Tue, 29 Sep 2020 11:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379350;
        bh=gK1pCVrS3EWbvsNEZcGrV7NFBFqJjT6F0+m+yH146Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ja+i7h3jO/bydKTmkth+i+OaGhTwdapcG5AiQg20odVMKhfChEz0JxZv0w7ShVrDB
         YiNfpsTY9KjWDEUBUWQOtR9VRs+MTZerJKaKu1+qw+QnI6pYl/aqBBWazOUU43uxWP
         nQCduI0eNzZ05dLgrOQvKXgFsKsQr0FItjx3F9/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/388] btrfs: tree-checker: Check leaf chunk item size
Date:   Tue, 29 Sep 2020 12:57:04 +0200
Message-Id: <20200929110014.982090952@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit f6d2a5c263afca84646cf3300dc13061bedbd99e ]

Inspired by btrfs-progs github issue #208, where chunk item in chunk
tree has invalid num_stripes (0).

Although that can already be caught by current btrfs_check_chunk_valid(),
that function doesn't really check item size as it needs to handle chunk
item in super block sys_chunk_array().

This patch will add two extra checks for chunk items in chunk tree:

- Basic chunk item size
  If the item is smaller than btrfs_chunk (which already contains one
  stripe), exit right now as reading num_stripes may even go beyond
  eb boundary.

- Item size check against num_stripes
  If item size doesn't match with calculated chunk size, then either the
  item size or the num_stripes is corrupted. Error out anyway.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 91ea38506fbb7..84b8d6ebf98f3 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -674,6 +674,44 @@ int btrfs_check_chunk_valid(struct extent_buffer *leaf,
 	return 0;
 }
 
+/*
+ * Enhanced version of chunk item checker.
+ *
+ * The common btrfs_check_chunk_valid() doesn't check item size since it needs
+ * to work on super block sys_chunk_array which doesn't have full item ptr.
+ */
+static int check_leaf_chunk_item(struct extent_buffer *leaf,
+				 struct btrfs_chunk *chunk,
+				 struct btrfs_key *key, int slot)
+{
+	int num_stripes;
+
+	if (btrfs_item_size_nr(leaf, slot) < sizeof(struct btrfs_chunk)) {
+		chunk_err(leaf, chunk, key->offset,
+			"invalid chunk item size: have %u expect [%zu, %u)",
+			btrfs_item_size_nr(leaf, slot),
+			sizeof(struct btrfs_chunk),
+			BTRFS_LEAF_DATA_SIZE(leaf->fs_info));
+		return -EUCLEAN;
+	}
+
+	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	/* Let btrfs_check_chunk_valid() handle this error type */
+	if (num_stripes == 0)
+		goto out;
+
+	if (btrfs_chunk_item_size(num_stripes) !=
+	    btrfs_item_size_nr(leaf, slot)) {
+		chunk_err(leaf, chunk, key->offset,
+			"invalid chunk item size: have %u expect %lu",
+			btrfs_item_size_nr(leaf, slot),
+			btrfs_chunk_item_size(num_stripes));
+		return -EUCLEAN;
+	}
+out:
+	return btrfs_check_chunk_valid(leaf, chunk, key->offset);
+}
+
 __printf(3, 4)
 __cold
 static void dev_item_err(const struct extent_buffer *eb, int slot,
@@ -1265,7 +1303,7 @@ static int check_leaf_item(struct extent_buffer *leaf,
 		break;
 	case BTRFS_CHUNK_ITEM_KEY:
 		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
-		ret = btrfs_check_chunk_valid(leaf, chunk, key->offset);
+		ret = check_leaf_chunk_item(leaf, chunk, key, slot);
 		break;
 	case BTRFS_DEV_ITEM_KEY:
 		ret = check_dev_item(leaf, key, slot);
-- 
2.25.1



