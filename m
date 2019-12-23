Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF7D0129920
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfLWRMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:12:31 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46321 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLWRMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:12:31 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D4ABD21C48;
        Mon, 23 Dec 2019 12:12:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:12:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ei9mIZ
        IKDheaQHz2M3WurlxgmT6FStBRMWGDDagS0Hs=; b=rIl6n7qtcM9gj1wqoq9aSt
        zXl5UTXliF8lRCwDKh9YHTS1EdpgoqAD4YKVZUOgxa5Eq7e8SbVC/pWVYgkFydlZ
        DRPuCCj1aq2FoYBDvINB0+DTPS5L75V6vpTjWg+nZci8tXjrOJXHb9mig64G1dT1
        BNKFe/uSRg3K9U0j+FKh4q9lFzvG0Uqtg2FdcnczEIcRyYcDtIJ7mrUydOB4ziwI
        haU1zlLNjIXVv/ZMwsHr5+VdgGKOAI0h1eQeG7tGrJE1keWixvbcSqKHPRpm1gaC
        I8II7b/bgqlE/Aa4BbLSX2g5eJA4oc+0GJeR+duYQSOr08ilSrCdhCjgQGPGs0yw
        ==
X-ME-Sender: <xms:ffUAXjouvs2Oq0XrR2Bi3fZsBk5r0x4lB6TwAROm-s8yGWDHyNyPzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeduleekrdekledrieegrddvgeelnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeej
X-ME-Proxy: <xmx:ffUAXgYXRIlJqI5MF9RC-Cw9pqese7OfsdyvJkqZ84HMSRyZYaV2ow>
    <xmx:ffUAXtHMkZ_KvhQ3fd4yg8npapUCg6cjy92YE47Dg03raMueCR6RPQ>
    <xmx:ffUAXuarwvrx9z_1TYZuHn703b8XVE3MH0QrI6hZABTPGS0bIWHssw>
    <xmx:ffUAXkYwGZRi_vo9wqm0SHlSzyoqEv2kGNR0C9g-ft36DXscequlpA>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id 551AB8005C;
        Mon, 23 Dec 2019 12:12:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] Btrfs: make tree checker detect checksum items with" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:12:16 -0500
Message-ID: <1577121136165252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

