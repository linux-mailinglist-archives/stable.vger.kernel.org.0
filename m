Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6BF12C77A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbfL2Rmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:42:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbfL2Rmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:42:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41DEF207FD;
        Sun, 29 Dec 2019 17:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641350;
        bh=aVGBNafn8ccvV1/KO7hDblzXPn28cCskNHJE9l2KE2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZaVAxK4qe8DUwYt57yNWinwY/Vej2xYbmL5BzG0inlfNW7fyDjIAfumQmpoulQ/4
         ipYpHyvAvW2KDf3TIG0pd6/RFGcfQiCHTVoDx5s2nbRggBoFMvD+DHYvVFY7KZuWeb
         c1ZNIZ7gQmUBc6Vgh0QQ+Aed/ehvUf6Wh5aw7Cqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 030/434] Btrfs: make tree checker detect checksum items with overlapping ranges
Date:   Sun, 29 Dec 2019 18:21:23 +0100
Message-Id: <20191229172704.048754998@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit ad1d8c439978ede77cbf73cbdd11bafe810421a5 upstream.

Having checksum items, either on the checksums tree or in a log tree, that
represent ranges that overlap each other is a sign of a corruption. Such
case confuses the checksum lookup code and can result in not being able to
find checksums or find stale checksums.

So add a check for such case.

This is motivated by a recent fix for a case where a log tree had checksum
items covering ranges that overlap each other due to extent cloning, and
resulted in missing checksums after replaying the log tree. It also helps
detect past issues such as stale and outdated checksums due to overlapping,
commit 27b9a8122ff71a ("Btrfs: fix csum tree corruption, duplicate and
outdated checksums").

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-checker.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -243,7 +243,7 @@ static int check_extent_data_item(struct
 }
 
 static int check_csum_item(struct extent_buffer *leaf, struct btrfs_key *key,
-			   int slot)
+			   int slot, struct btrfs_key *prev_key)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	u32 sectorsize = fs_info->sectorsize;
@@ -267,6 +267,20 @@ static int check_csum_item(struct extent
 			btrfs_item_size_nr(leaf, slot), csumsize);
 		return -EUCLEAN;
 	}
+	if (slot > 0 && prev_key->type == BTRFS_EXTENT_CSUM_KEY) {
+		u64 prev_csum_end;
+		u32 prev_item_size;
+
+		prev_item_size = btrfs_item_size_nr(leaf, slot - 1);
+		prev_csum_end = (prev_item_size / csumsize) * sectorsize;
+		prev_csum_end += prev_key->offset;
+		if (prev_csum_end > key->offset) {
+			generic_err(leaf, slot - 1,
+"csum end range (%llu) goes beyond the start range (%llu) of the next csum item",
+				    prev_csum_end, key->offset);
+			return -EUCLEAN;
+		}
+	}
 	return 0;
 }
 
@@ -1239,7 +1253,7 @@ static int check_leaf_item(struct extent
 		ret = check_extent_data_item(leaf, key, slot, prev_key);
 		break;
 	case BTRFS_EXTENT_CSUM_KEY:
-		ret = check_csum_item(leaf, key, slot);
+		ret = check_csum_item(leaf, key, slot, prev_key);
 		break;
 	case BTRFS_DIR_ITEM_KEY:
 	case BTRFS_DIR_INDEX_KEY:


