Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544784FD84B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbiDLHhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353796AbiDLHZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A991565AF;
        Tue, 12 Apr 2022 00:04:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 466AF60B2B;
        Tue, 12 Apr 2022 07:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5334EC385A6;
        Tue, 12 Apr 2022 07:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747077;
        bh=SzBItMyTsxEN8wbEy8s1evcdeOWaK+YL9Vm2ua8qJns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1lqx/8oacK8kPfemJ2/MvuXoe/TOb0a4ikoPR0puZyGDoLkOx9wWgtsFS37euSMl
         YScmOGXZbwbTNX6bcByIS8XUohtJv2vYcbbbwZx8rmB2Jc9LxSkHr//Q3D6HKukqrG
         0dd4zd+qxYxKpqXav2yC38is18b4YPE+HRb5Es4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 234/285] btrfs: avoid defragging extents whose next extents are not targets
Date:   Tue, 12 Apr 2022 08:31:31 +0200
Message-Id: <20220412062950.415220912@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 75a36a7d3ea904cef2e5b56af0c58cc60dcf947a upstream.

[BUG]
There is a report that autodefrag is defragging single sector, which
is completely waste of IO, and no help for defragging:

   btrfs-cleaner-808 defrag_one_locked_range: root=256 ino=651122 start=0 len=4096

[CAUSE]
In defrag_collect_targets(), we check if the current range (A) can be merged
with next one (B).

If mergeable, we will add range A into target for defrag.

However there is a catch for autodefrag, when checking mergeability
against range B, we intentionally pass 0 as @newer_than, hoping to get a
higher chance to merge with the next extent.

But in the next iteration, range B will looked up by defrag_lookup_extent(),
with non-zero @newer_than.

And if range B is not really newer, it will rejected directly, causing
only range A being defragged, while we expect to defrag both range A and
B.

[FIX]
Since the root cause is the difference in check condition of
defrag_check_next_extent() and defrag_collect_targets(), we fix it by:

1. Pass @newer_than to defrag_check_next_extent()
2. Pass @extent_thresh to defrag_check_next_extent()

This makes the check between defrag_collect_targets() and
defrag_check_next_extent() more consistent.

While there is still some minor difference, the remaining checks are
focus on runtime flags like writeback/delalloc, which are mostly
transient and safe to be checked only in defrag_collect_targets().

Link: https://github.com/btrfs/linux/issues/423#issuecomment-1066981856
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1189,7 +1189,7 @@ static u32 get_extent_max_capacity(const
 }
 
 static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em,
-				     bool locked)
+				     u32 extent_thresh, u64 newer_than, bool locked)
 {
 	struct extent_map *next;
 	bool ret = false;
@@ -1199,11 +1199,12 @@ static bool defrag_check_next_extent(str
 		return false;
 
 	/*
-	 * We want to check if the next extent can be merged with the current
-	 * one, which can be an extent created in a past generation, so we pass
-	 * a minimum generation of 0 to defrag_lookup_extent().
+	 * Here we need to pass @newer_then when checking the next extent, or
+	 * we will hit a case we mark current extent for defrag, but the next
+	 * one will not be a target.
+	 * This will just cause extra IO without really reducing the fragments.
 	 */
-	next = defrag_lookup_extent(inode, em->start + em->len, 0, locked);
+	next = defrag_lookup_extent(inode, em->start + em->len, newer_than, locked);
 	/* No more em or hole */
 	if (!next || next->block_start >= EXTENT_MAP_LAST_BYTE)
 		goto out;
@@ -1215,6 +1216,13 @@ static bool defrag_check_next_extent(str
 	 */
 	if (next->len >= get_extent_max_capacity(em))
 		goto out;
+	/* Skip older extent */
+	if (next->generation < newer_than)
+		goto out;
+	/* Also check extent size */
+	if (next->len >= extent_thresh)
+		goto out;
+
 	ret = true;
 out:
 	free_extent_map(next);
@@ -1420,7 +1428,7 @@ static int defrag_collect_targets(struct
 			goto next;
 
 		next_mergeable = defrag_check_next_extent(&inode->vfs_inode, em,
-							  locked);
+						extent_thresh, newer_than, locked);
 		if (!next_mergeable) {
 			struct defrag_target_range *last;
 


