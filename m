Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C86E156658
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBHSeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:34:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34234 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727891AbgBHS3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-0003fX-VJ; Sat, 08 Feb 2020 18:29:38 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-000CRq-MP; Sat, 08 Feb 2020 18:29:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nikolay Borisov" <nborisov@suse.com>,
        "Josef Bacik" <josef@toxicpanda.com>,
        "Filipe Manana" <fdmanana@suse.com>,
        "David Sterba" <dsterba@suse.com>
Date:   Sat, 08 Feb 2020 18:20:42 +0000
Message-ID: <lsq.1581185940.727355076@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 103/148] btrfs: check page->mapping when loading free
 space cache
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 3797136b626ad4b6582223660c041efdea8f26b2 upstream.

While testing 5.2 we ran into the following panic

[52238.017028] BUG: kernel NULL pointer dereference, address: 0000000000000001
[52238.105608] RIP: 0010:drop_buffers+0x3d/0x150
[52238.304051] Call Trace:
[52238.308958]  try_to_free_buffers+0x15b/0x1b0
[52238.317503]  shrink_page_list+0x1164/0x1780
[52238.325877]  shrink_inactive_list+0x18f/0x3b0
[52238.334596]  shrink_node_memcg+0x23e/0x7d0
[52238.342790]  ? do_shrink_slab+0x4f/0x290
[52238.350648]  shrink_node+0xce/0x4a0
[52238.357628]  balance_pgdat+0x2c7/0x510
[52238.365135]  kswapd+0x216/0x3e0
[52238.371425]  ? wait_woken+0x80/0x80
[52238.378412]  ? balance_pgdat+0x510/0x510
[52238.386265]  kthread+0x111/0x130
[52238.392727]  ? kthread_create_on_node+0x60/0x60
[52238.401782]  ret_from_fork+0x1f/0x30

The page we were trying to drop had a page->private, but had no
page->mapping and so called drop_buffers, assuming that we had a
buffer_head on the page, and then panic'ed trying to deref 1, which is
our page->private for data pages.

This is happening because we're truncating the free space cache while
we're trying to load the free space cache.  This isn't supposed to
happen, and I'll fix that in a followup patch.  However we still
shouldn't allow those sort of mistakes to result in messing with pages
that do not belong to us.  So add the page->mapping check to verify that
we still own this page after dropping and re-acquiring the page lock.

This page being unlocked as:
btrfs_readpage
  extent_read_full_page
    __extent_read_full_page
      __do_readpage
        if (!nr)
	   unlock_page  <-- nr can be 0 only if submit_extent_page
			    returns an error

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ add callchain ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/free-space-cache.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -360,6 +360,12 @@ static int io_ctl_prepare_pages(struct i
 		if (uptodate && !PageUptodate(page)) {
 			btrfs_readpage(NULL, page);
 			lock_page(page);
+			if (page->mapping != inode->i_mapping) {
+				btrfs_err(BTRFS_I(inode)->root->fs_info,
+					  "free space cache page truncated");
+				io_ctl_drop_pages(io_ctl);
+				return -EIO;
+			}
 			if (!PageUptodate(page)) {
 				btrfs_err(BTRFS_I(inode)->root->fs_info,
 					   "error reading free space cache");

