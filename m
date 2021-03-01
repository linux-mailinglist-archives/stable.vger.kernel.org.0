Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A438328F9D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242377AbhCATxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:53:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242310AbhCATo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB5206524C;
        Mon,  1 Mar 2021 17:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619667;
        bh=p5nuNUD/3W6qhFpJpTknVkK9pkmt4N7lCzU8Qdop+PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UiX7CB3adcWLEeX8gS6h5eJWw3a3cXuryBKk98lxhsZ+LyQ0cpfpb5qhCS0aI2tA3
         DmtzRRdcjMcwGmLJKD0cgVoK42lNl82w1Unodu8DDA0y5p3tDy5vB5PPMaN0gJjgAm
         2tTYEZen7oiypz6nuflnMsgu6gvgb+9wk4Pm3RF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 538/663] btrfs: account for new extents being deleted in total_bytes_pinned
Date:   Mon,  1 Mar 2021 17:13:06 +0100
Message-Id: <20210301161208.476036599@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 81e75ac74ecba929d1e922bf93f9fc467232e39f upstream.

My recent patch set "A variety of lock contention fixes", found here

https://lore.kernel.org/linux-btrfs/cover.1608319304.git.josef@toxicpanda.com/
(Tracked in https://github.com/btrfs/linux/issues/86)

that reduce lock contention on the extent root by running delayed refs
less often resulted in a regression in generic/371.  This test
fallocate()'s the fs until it's full, deletes all the files, and then
tries to fallocate() until full again.

Before these patches we would run all of the delayed refs during
flushing, and then would commit the transaction because we had plenty of
pinned space to recover in order to allocate.  However my patches made
it so we weren't running the delayed refs as aggressively, which meant
that we appeared to have less pinned space when we were deciding to
commit the transaction.

We use the space_info->total_bytes_pinned to approximate how much space
we have pinned.  It's approximate because if we remove a reference to an
extent we may free it, but there may be more references to it than we
know of at that point, but we account it as pinned at the creation time,
and then it's properly accounted when the delayed ref runs.

The way we account for pinned space is if the
delayed_ref_head->total_ref_mod is < 0, because that is clearly a
freeing option.  However there is another case, and that is where
->total_ref_mod == 0 && ->must_insert_reserved == 1.

When we allocate a new extent, we have ->total_ref_mod == 1 and we have
->must_insert_reserved == 1.  This is used to indicate that it is a
brand new extent and will need to have its extent entry added before we
modify any references on the delayed ref head.  But if we subsequently
remove that extent reference, our ->total_ref_mod will be 0, and that
space will be pinned and freed.  Accounting for this case properly
allows for generic/371 to pass with my delayed refs patches applied.

It's important to note that this problem exists without the referenced
patches, it just was uncovered by them.

CC: stable@vger.kernel.org # 5.10
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delayed-ref.c |    5 +++++
 fs/btrfs/extent-tree.c |   33 +++++++++++++++++++--------------
 2 files changed, 24 insertions(+), 14 deletions(-)

--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -732,11 +732,16 @@ static noinline void update_existing_hea
 	 * 2. We were negative and went to 0 or positive, so no longer can say
 	 *    that the space would be pinned, decrement our counter from the
 	 *    total_bytes_pinned counter.
+	 * 3. We are now at 0 and have ->must_insert_reserved set, which means
+	 *    this was a new allocation and then we dropped it, and thus must
+	 *    add our space to the total_bytes_pinned counter.
 	 */
 	if (existing->total_ref_mod < 0 && old_ref_mod >= 0)
 		btrfs_mod_total_bytes_pinned(fs_info, flags, existing->num_bytes);
 	else if (existing->total_ref_mod >= 0 && old_ref_mod < 0)
 		btrfs_mod_total_bytes_pinned(fs_info, flags, -existing->num_bytes);
+	else if (existing->total_ref_mod == 0 && existing->must_insert_reserved)
+		btrfs_mod_total_bytes_pinned(fs_info, flags, existing->num_bytes);
 
 	spin_unlock(&existing->lock);
 }
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1755,23 +1755,28 @@ void btrfs_cleanup_ref_head_accounting(s
 {
 	int nr_items = 1;	/* Dropping this ref head update. */
 
-	if (head->total_ref_mod < 0) {
+	/*
+	 * We had csum deletions accounted for in our delayed refs rsv, we need
+	 * to drop the csum leaves for this update from our delayed_refs_rsv.
+	 */
+	if (head->total_ref_mod < 0 && head->is_data) {
+		spin_lock(&delayed_refs->lock);
+		delayed_refs->pending_csums -= head->num_bytes;
+		spin_unlock(&delayed_refs->lock);
+		nr_items += btrfs_csum_bytes_to_leaves(fs_info, head->num_bytes);
+	}
+
+	/*
+	 * We were dropping refs, or had a new ref and dropped it, and thus must
+	 * adjust down our total_bytes_pinned, the space may or may not have
+	 * been pinned and so is accounted for properly in the pinned space by
+	 * now.
+	 */
+	if (head->total_ref_mod < 0 ||
+	    (head->total_ref_mod == 0 && head->must_insert_reserved)) {
 		u64 flags = btrfs_ref_head_to_space_flags(head);
 
 		btrfs_mod_total_bytes_pinned(fs_info, flags, -head->num_bytes);
-
-		/*
-		 * We had csum deletions accounted for in our delayed refs rsv,
-		 * we need to drop the csum leaves for this update from our
-		 * delayed_refs_rsv.
-		 */
-		if (head->is_data) {
-			spin_lock(&delayed_refs->lock);
-			delayed_refs->pending_csums -= head->num_bytes;
-			spin_unlock(&delayed_refs->lock);
-			nr_items += btrfs_csum_bytes_to_leaves(fs_info,
-				head->num_bytes);
-		}
 	}
 
 	btrfs_delayed_refs_rsv_release(fs_info, nr_items);


