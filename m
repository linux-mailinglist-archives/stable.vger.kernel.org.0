Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A71217DD
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbfLPSCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:02:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729385AbfLPSCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:02:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B40332072D;
        Mon, 16 Dec 2019 18:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519365;
        bh=SO4JUwapH9iXhFMuU1al+fkIfajrbgb6VCS8LETZ3Zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qo5PMJ+9owVnvNNTNbOkbqm8YsNqnEgZRRebjkTY4WrVuTni11yPXyV0fhC8/4OoW
         gzOyxfMLnbfEwyGDzXc72Li8kT27JG5IQSSRrIrLPdkyjB8idCzEsDqzD2TZNp5loY
         maKdtP3XQlqrdNir7eY6G+Bz9nK57Luba//aTqaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 036/140] btrfs: check page->mapping when loading free space cache
Date:   Mon, 16 Dec 2019 18:48:24 +0100
Message-Id: <20191216174759.049219103@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ add callchain ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/free-space-cache.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -382,6 +382,12 @@ static int io_ctl_prepare_pages(struct b
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


