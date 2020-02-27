Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4E5171D61
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389823AbgB0OSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:18:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:58668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389818AbgB0OSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:18:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC0E24690;
        Thu, 27 Feb 2020 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813087;
        bh=pFlqS0oVMrE05Ga1rfqDuJWkhwUyK39vt3gc/t375Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNCCX22kkz6qc9/ZPlQQc5ynMUgrqhEquY61Oyeqt96QJqrC5+jTvANYo7e1p8jLu
         dDlvyJFkrK2KsDcAjEMC4Vmd3otmtwsG4TMmtEgUP4TEnhGEx5MOejdEkCfFHWGrAw
         ILKaryWCTMNp83HZx/TVFswHCcZJSk1aoHKh1R+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 105/150] btrfs: fix bytes_may_use underflow in prealloc error condtition
Date:   Thu, 27 Feb 2020 14:37:22 +0100
Message-Id: <20200227132248.284207698@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit b778cf962d71a0e737923d55d0432f3bd287258e upstream.

I hit the following warning while running my error injection stress
testing:

  WARNING: CPU: 3 PID: 1453 at fs/btrfs/space-info.h:108 btrfs_free_reserved_data_space_noquota+0xfd/0x160 [btrfs]
  RIP: 0010:btrfs_free_reserved_data_space_noquota+0xfd/0x160 [btrfs]
  Call Trace:
  btrfs_free_reserved_data_space+0x4f/0x70 [btrfs]
  __btrfs_prealloc_file_range+0x378/0x470 [btrfs]
  elfcorehdr_read+0x40/0x40
  ? elfcorehdr_read+0x40/0x40
  ? btrfs_commit_transaction+0xca/0xa50 [btrfs]
  ? dput+0xb4/0x2a0
  ? btrfs_log_dentry_safe+0x55/0x70 [btrfs]
  ? btrfs_sync_file+0x30e/0x420 [btrfs]
  ? do_fsync+0x38/0x70
  ? __x64_sys_fdatasync+0x13/0x20
  ? do_syscall_64+0x5b/0x1b0
  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

This happens if we fail to insert our reserved file extent.  At this
point we've already converted our reservation from ->bytes_may_use to
->bytes_reserved.  However once we break we will attempt to free
everything from [cur_offset, end] from ->bytes_may_use, but our extent
reservation will overlap part of this.

Fix this problem by adding ins.offset (our extent allocation size) to
cur_offset so we remove the actual remaining part from ->bytes_may_use.

I validated this fix using my inject-error.py script

python inject-error.py -o should_fail_bio -t cache_save_setup -t \
	__btrfs_prealloc_file_range \
	-t insert_reserved_file_extent.constprop.0 \
	-r "-5" ./run-fsstress.sh

where run-fsstress.sh simply mounts and runs fsstress on a disk.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10487,6 +10487,7 @@ static int __btrfs_prealloc_file_range(s
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key ins;
 	u64 cur_offset = start;
+	u64 clear_offset = start;
 	u64 i_size;
 	u64 cur_bytes;
 	u64 last_alloc = (u64)-1;
@@ -10521,6 +10522,15 @@ static int __btrfs_prealloc_file_range(s
 				btrfs_end_transaction(trans);
 			break;
 		}
+
+		/*
+		 * We've reserved this space, and thus converted it from
+		 * ->bytes_may_use to ->bytes_reserved.  Any error that happens
+		 * from here on out we will only need to clear our reservation
+		 * for the remaining unreserved area, so advance our
+		 * clear_offset by our extent size.
+		 */
+		clear_offset += ins.offset;
 		btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 
 		last_alloc = ins.offset;
@@ -10600,9 +10610,9 @@ next:
 		if (own_trans)
 			btrfs_end_transaction(trans);
 	}
-	if (cur_offset < end)
-		btrfs_free_reserved_data_space(inode, NULL, cur_offset,
-			end - cur_offset + 1);
+	if (clear_offset < end)
+		btrfs_free_reserved_data_space(inode, NULL, clear_offset,
+			end - clear_offset + 1);
 	return ret;
 }
 


