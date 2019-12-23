Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4226412991E
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfLWRMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:12:21 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48227 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLWRMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:12:21 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4663021EE9;
        Mon, 23 Dec 2019 12:12:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:12:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=f7PRZv
        ZmT7aLpNnXmwitVLqf+/WqqHAU3NgiCWWpBEs=; b=omiJ14dbhHkP7AcAxuTNXr
        5kWt0HnHTJk3ct7LSkql035kz6S32548SiVMksC0wfV6KIyqsNtS8f9MhkwWV0/r
        05BjkVIJWRnrRqT29r/WDmxnUWanRIAyzN43ZEgkll3Fz6OU81853iHepOGs5rYu
        NlknjFjqYStRDOZl17NlcEvnp2SUzlobO8DtMRHcsRkB2uyt7N8o0KwC9y0MH3m4
        GBKoxcgOCapLjoqux7lJ9Pzo7fIck0SI5ck/hNP6VVlH7H7bO+4LVlYI4qy5GVTf
        rkr3kgyMt8hKLaCqFKt9MrDsvdMoAxOptZhK5yjGmXmEZssXe+FdE4HhfYiMz56Q
        ==
X-ME-Sender: <xms:dPUAXsQfiOFT595OqsXohWcMSLchG9yysMfl4OrT1iMl4O4OXQSUdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeduleekrdekledrieegrddvgeelnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeh
X-ME-Proxy: <xmx:dPUAXlVFQVo17PQIUfWgtEkKyjwCtnuIsZnzbIyaS5EMdFY-l_Ye0A>
    <xmx:dPUAXp1_a4B9Nu1hK2KpqrrClQy3VU8YBxNE1T0w9t-fgxvq6mD3qg>
    <xmx:dPUAXk9XeQ-c8AUEPqpE3hbj1HFsHeIb48tojsz8jC-EtWYYFB_9jA>
    <xmx:dPUAXpSHS1LaS3zmA4F4g2JXilvG8t8zUuaOPkZYBQCQzRyKjmP70Q>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id D74C48005A;
        Mon, 23 Dec 2019 12:12:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] Btrfs: make tree checker detect checksum items with" failed to apply to 4.14-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:12:13 -0500
Message-ID: <1577121133252247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ad1d8c439978ede77cbf73cbdd11bafe810421a5 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 2 Dec 2019 11:01:03 +0000
Subject: [PATCH] Btrfs: make tree checker detect checksum items with
 overlapping ranges

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

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 092b8ece36d7..97f3520b8d98 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -332,7 +332,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 }
 
 static int check_csum_item(struct extent_buffer *leaf, struct btrfs_key *key,
-			   int slot)
+			   int slot, struct btrfs_key *prev_key)
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	u32 sectorsize = fs_info->sectorsize;
@@ -356,6 +356,20 @@ static int check_csum_item(struct extent_buffer *leaf, struct btrfs_key *key,
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
 
@@ -1355,7 +1369,7 @@ static int check_leaf_item(struct extent_buffer *leaf,
 		ret = check_extent_data_item(leaf, key, slot, prev_key);
 		break;
 	case BTRFS_EXTENT_CSUM_KEY:
-		ret = check_csum_item(leaf, key, slot);
+		ret = check_csum_item(leaf, key, slot, prev_key);
 		break;
 	case BTRFS_DIR_ITEM_KEY:
 	case BTRFS_DIR_INDEX_KEY:

