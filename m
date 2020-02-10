Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09B81577CE
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbgBJNCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:02:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729747AbgBJMka (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:30 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28C3D20842;
        Mon, 10 Feb 2020 12:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338430;
        bh=/L09c4D6tvDhtBvettooq6PMqTLwWh1zJo9L3kooNdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZzqqDJq0eG3kRU8erkocQDdVLlD8x1tCbxUaNSzZXbjviptwGVJHEm5fpdd5KmbN
         9kBPslQln8rNIQrvNCqiGIlspvfS6rG16ilBtYClKMyy2QAVm0JvlH4nIRCIJwKVM2
         lxrbyToRzycylTX4oskK4YEauL5/AGx6PEtOp9uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 155/367] btrfs: fix improper setting of scanned for range cyclic write cache pages
Date:   Mon, 10 Feb 2020 04:31:08 -0800
Message-Id: <20200210122439.130689063@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 556755a8a99be8ca3cd9fbe36aaf9b3b0339a00d upstream.

We noticed that we were having regular CG OOM kills in cases where there
was still enough dirty pages to avoid OOM'ing.  It turned out there's
this corner case in btrfs's handling of range_cyclic where files that
were being redirtied were not getting fully written out because of how
we do range_cyclic writeback.

We unconditionally were setting scanned = 1; the first time we found any
pages in the inode.  This isn't actually what we want, we want it to be
set if we've scanned the entire file.  For range_cyclic we could be
starting in the middle or towards the end of the file, so we could write
one page and then not write any of the other dirty pages in the file
because we set scanned = 1.

Fix this by not setting scanned = 1 if we find pages.  The rules for
setting scanned should be

1) !range_cyclic.  In this case we have a specified range to write out.
2) range_cyclic && index == 0.  In this case we've started at the
   beginning and there is no need to loop around a second time.
3) range_cyclic && we started at index > 0 and we've reached the end of
   the file without satisfying our nr_to_write.

This patch fixes both of our writepages implementations to make sure
these rules hold true.  This fixed our over zealous CG OOMs in
production.

Fixes: d1310b2e0cd9 ("Btrfs: Split the extent_map code into two parts")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add comment ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3941,6 +3941,11 @@ int btree_write_cache_pages(struct addre
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
+		/*
+		 * Start from the beginning does not need to cycle over the
+		 * range, mark it as scanned.
+		 */
+		scanned = (index == 0);
 	} else {
 		index = wbc->range_start >> PAGE_SHIFT;
 		end = wbc->range_end >> PAGE_SHIFT;
@@ -3958,7 +3963,6 @@ retry:
 			tag))) {
 		unsigned i;
 
-		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
@@ -4087,6 +4091,11 @@ static int extent_write_cache_pages(stru
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
 		end = -1;
+		/*
+		 * Start from the beginning does not need to cycle over the
+		 * range, mark it as scanned.
+		 */
+		scanned = (index == 0);
 	} else {
 		index = wbc->range_start >> PAGE_SHIFT;
 		end = wbc->range_end >> PAGE_SHIFT;
@@ -4120,7 +4129,6 @@ retry:
 						&index, end, tag))) {
 		unsigned i;
 
-		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 


