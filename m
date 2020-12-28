Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139002E67E8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgL1NGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:06:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729657AbgL1NGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:06:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBD8422583;
        Mon, 28 Dec 2020 13:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160754;
        bh=Kb+FOsQMUlU45v7HgtHVomXRIUI2/2di63Cmzi3ur5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGuCcBqAb71LMNx5M4aZl1mgc7aoh/Vmn4+7l3UxW1/A6V2KPVhvsGqTdIZzoFGx5
         9YQWiRybKvng9ePgROr1fuCqlqKNK40E4635+7nYiD3sacQDwcMqqGPZFBQKJ8Y2yF
         2PcztWqkFtHEDbtzF/RyycvSbiSJAe+wlgRqurJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 152/175] btrfs: scrub: Dont use inode page cache in scrub_handle_errored_block()
Date:   Mon, 28 Dec 2020 13:50:05 +0100
Message-Id: <20201228124900.623478349@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 665d4953cde6d9e75c62a07ec8f4f8fd7d396ade upstream

In commit ac0b4145d662 ("btrfs: scrub: Don't use inode pages for device
replace") we removed the branch of copy_nocow_pages() to avoid
corruption for compressed nodatasum extents.

However above commit only solves the problem in scrub_extent(), if
during scrub_pages() we failed to read some pages,
sctx->no_io_error_seen will be non-zero and we go to fixup function
scrub_handle_errored_block().

In scrub_handle_errored_block(), for sctx without csum (no matter if
we're doing replace or scrub) we go to scrub_fixup_nodatasum() routine,
which does the similar thing with copy_nocow_pages(), but does it
without the extra check in copy_nocow_pages() routine.

So for test cases like btrfs/100, where we emulate read errors during
replace/scrub, we could corrupt compressed extent data again.

This patch will fix it just by avoiding any "optimization" for
nodatasum, just falls back to the normal fixup routine by try read from
any good copy.

This also solves WARN_ON() or dead lock caused by lame backref iteration
in scrub_fixup_nodatasum() routine.

The deadlock or WARN_ON() won't be triggered before commit ac0b4145d662
("btrfs: scrub: Don't use inode pages for device replace") since
copy_nocow_pages() have better locking and extra check for data extent,
and it's already doing the fixup work by try to read data from any good
copy, so it won't go scrub_fixup_nodatasum() anyway.

This patch disables the faulty code and will be removed completely in a
followup patch.

Fixes: ac0b4145d662 ("btrfs: scrub: Don't use inode pages for device replace")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -919,11 +919,6 @@ static int scrub_handle_errored_block(st
 	have_csum = sblock_to_check->pagev[0]->have_csum;
 	dev = sblock_to_check->pagev[0]->dev;
 
-	if (sctx->is_dev_replace && !is_metadata && !have_csum) {
-		sblocks_for_recheck = NULL;
-		goto nodatasum_case;
-	}
-
 	/*
 	 * read all mirrors one after the other. This includes to
 	 * re-read the extent or metadata block that failed (that was
@@ -1036,13 +1031,19 @@ static int scrub_handle_errored_block(st
 		goto out;
 	}
 
-	if (!is_metadata && !have_csum) {
+	/*
+	 * NOTE: Even for nodatasum case, it's still possible that it's a
+	 * compressed data extent, thus scrub_fixup_nodatasum(), which write
+	 * inode page cache onto disk, could cause serious data corruption.
+	 *
+	 * So here we could only read from disk, and hope our recovery could
+	 * reach disk before the newer write.
+	 */
+	if (0 && !is_metadata && !have_csum) {
 		struct scrub_fixup_nodatasum *fixup_nodatasum;
 
 		WARN_ON(sctx->is_dev_replace);
 
-nodatasum_case:
-
 		/*
 		 * !is_metadata and !have_csum, this means that the data
 		 * might not be COWed, that it might be modified


