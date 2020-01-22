Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6977F14561B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgAVNUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgAVNUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:49 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 206C420704;
        Wed, 22 Jan 2020 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699248;
        bh=DvpWguXOaO9qZ5/G7dCXQkTSGzgL7lHWKUKhKMkLb9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JePgdlN8rU7w5698IThxmnURvFox9n8EFpASFkmCUx6rARwVxzFhw2ChNCZf2qbqW
         i+j99532Jf676b3lv2IPq1wei5Sy8N96SNGKx4NQJwOA2vv6JMHwTtg0PXLTz800ZB
         kfMHtKV+dlpWzfWAqNGNb+G/UX0/XC9eDzCG+Hyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 087/222] btrfs: fix memory leak in qgroup accounting
Date:   Wed, 22 Jan 2020 10:27:53 +0100
Message-Id: <20200122092839.946009315@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 26ef8493e1ab771cb01d27defca2fa1315dc3980 upstream.

When running xfstests on the current btrfs I get the following splat from
kmemleak:

unreferenced object 0xffff88821b2404e0 (size 32):
  comm "kworker/u4:7", pid 26663, jiffies 4295283698 (age 8.776s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 10 ff fd 26 82 88 ff ff  ...........&....
    10 ff fd 26 82 88 ff ff 20 ff fd 26 82 88 ff ff  ...&.... ..&....
  backtrace:
    [<00000000f94fd43f>] ulist_alloc+0x25/0x60 [btrfs]
    [<00000000fd023d99>] btrfs_find_all_roots_safe+0x41/0x100 [btrfs]
    [<000000008f17bd32>] btrfs_find_all_roots+0x52/0x70 [btrfs]
    [<00000000b7660afb>] btrfs_qgroup_rescan_worker+0x343/0x680 [btrfs]
    [<0000000058e66778>] btrfs_work_helper+0xac/0x1e0 [btrfs]
    [<00000000f0188930>] process_one_work+0x1cf/0x350
    [<00000000af5f2f8e>] worker_thread+0x28/0x3c0
    [<00000000b55a1add>] kthread+0x109/0x120
    [<00000000f88cbd17>] ret_from_fork+0x35/0x40

This corresponds to:

  (gdb) l *(btrfs_find_all_roots_safe+0x41)
  0x8d7e1 is in btrfs_find_all_roots_safe (fs/btrfs/backref.c:1413).
  1408
  1409            tmp = ulist_alloc(GFP_NOFS);
  1410            if (!tmp)
  1411                    return -ENOMEM;
  1412            *roots = ulist_alloc(GFP_NOFS);
  1413            if (!*roots) {
  1414                    ulist_free(tmp);
  1415                    return -ENOMEM;
  1416            }
  1417

Following the lifetime of the allocated 'roots' ulist, it gets freed
again in btrfs_qgroup_account_extent().

But this does not happen if the function is called with the
'BTRFS_FS_QUOTA_ENABLED' flag cleared, then btrfs_qgroup_account_extent()
does a short leave and directly returns.

Instead of directly returning we should jump to the 'out_free' in order to
free all resources as expected.

CC: stable@vger.kernel.org # 4.14+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
[ add comment ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/qgroup.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2423,8 +2423,12 @@ int btrfs_qgroup_account_extent(struct b
 	u64 nr_old_roots = 0;
 	int ret = 0;
 
+	/*
+	 * If quotas get disabled meanwhile, the resouces need to be freed and
+	 * we can't just exit here.
+	 */
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
-		return 0;
+		goto out_free;
 
 	if (new_roots) {
 		if (!maybe_fs_roots(new_roots))


