Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942CF76A93
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387445AbfGZNkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387437AbfGZNkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83C2522BE8;
        Fri, 26 Jul 2019 13:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148423;
        bh=kdDk1CBB9bt8maWhjSpCjH2YxMp3YDDBWtpFwBsVQVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UB+b2+3t8DdVTTgPGX8tyaD/mTK4Sa6bdsASoW9awJyTAzRcduFE9GZno4ZMVoqSV
         6cLTuaEpZw+ubHKvbhKmG6nfWMHV/e2dwIImZ5kiUx8aPUL9TxwNKekwhsjZl5/0Gc
         +ja8LT0wcFlnDGLBemqN0bGBsTmNenErqvgOOEZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 26/85] btrfs: tree-checker: Check if the file extent end overflows
Date:   Fri, 26 Jul 2019 09:38:36 -0400
Message-Id: <20190726133936.11177-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 4c094c33c9ed4b8d0d814bd1d7ff78e123d15d00 ]

Under certain conditions, we could have strange file extent item in log
tree like:

  item 18 key (69599 108 397312) itemoff 15208 itemsize 53
	extent data disk bytenr 0 nr 0
	extent data offset 0 nr 18446744073709547520 ram 18446744073709547520

The num_bytes + ram_bytes overflow 64 bit type.

For num_bytes part, we can detect such overflow along with file offset
(key->offset), as file_offset + num_bytes should never go beyond u64.

For ram_bytes part, it's about the decompressed size of the extent, not
directly related to the size.
In theory it is OK to have a large value, and put extra limitation
on RAM bytes may cause unexpected false alerts.

So in tree-checker, we only check if the file offset and num bytes
overflow.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 96fce4bef4e7..ccd5706199d7 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -132,6 +132,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	struct btrfs_file_extent_item *fi;
 	u32 sectorsize = fs_info->sectorsize;
 	u32 item_size = btrfs_item_size_nr(leaf, slot);
+	u64 extent_end;
 
 	if (!IS_ALIGNED(key->offset, sectorsize)) {
 		file_extent_err(leaf, slot,
@@ -207,6 +208,16 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	    CHECK_FE_ALIGNED(leaf, slot, fi, num_bytes, sectorsize))
 		return -EUCLEAN;
 
+	/* Catch extent end overflow */
+	if (check_add_overflow(btrfs_file_extent_num_bytes(leaf, fi),
+			       key->offset, &extent_end)) {
+		file_extent_err(leaf, slot,
+	"extent end overflow, have file offset %llu extent num bytes %llu",
+				key->offset,
+				btrfs_file_extent_num_bytes(leaf, fi));
+		return -EUCLEAN;
+	}
+
 	/*
 	 * Check that no two consecutive file extent items, in the same leaf,
 	 * present ranges that overlap each other.
-- 
2.20.1

