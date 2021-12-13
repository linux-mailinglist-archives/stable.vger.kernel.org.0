Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E31F472951
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbhLMKTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244355AbhLMKRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:17:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89C2C0497E0;
        Mon, 13 Dec 2021 01:56:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E957B80E0B;
        Mon, 13 Dec 2021 09:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A260EC34602;
        Mon, 13 Dec 2021 09:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389364;
        bh=ViRQ72+iO678WTxe0xUtXAi6crvMjILnJhS0X6N108Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9t9RN1CBBoz9tvhQaih82pOjcIsiJlNIrHYWwGIzX/Fod/y6Djo7dhEhZosb2TxV
         m/kWEQkGbKd0b4O7Bkp5vBeHtvz12WDIh2Gz2GVNjIUzTV99f/QV4Dt0jcf78FqKrK
         53KriGmHIYMTU2P/MspJ4IaqAMtUuKkdN9Tko288=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 075/171] btrfs: free exchange changeset on failures
Date:   Mon, 13 Dec 2021 10:29:50 +0100
Message-Id: <20211213092947.599175571@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit da5e817d9d75422eaaa05490d0b9a5e328fc1a51 upstream.

Fstests runs on my VMs have show several kmemleak reports like the following.

  unreferenced object 0xffff88811ae59080 (size 64):
    comm "xfs_io", pid 12124, jiffies 4294987392 (age 6.368s)
    hex dump (first 32 bytes):
      00 c0 1c 00 00 00 00 00 ff cf 1c 00 00 00 00 00  ................
      90 97 e5 1a 81 88 ff ff 90 97 e5 1a 81 88 ff ff  ................
    backtrace:
      [<00000000ac0176d2>] ulist_add_merge+0x60/0x150 [btrfs]
      [<0000000076e9f312>] set_state_bits+0x86/0xc0 [btrfs]
      [<0000000014fe73d6>] set_extent_bit+0x270/0x690 [btrfs]
      [<000000004f675208>] set_record_extent_bits+0x19/0x20 [btrfs]
      [<00000000b96137b1>] qgroup_reserve_data+0x274/0x310 [btrfs]
      [<0000000057e9dcbb>] btrfs_check_data_free_space+0x5c/0xa0 [btrfs]
      [<0000000019c4511d>] btrfs_delalloc_reserve_space+0x1b/0xa0 [btrfs]
      [<000000006d37e007>] btrfs_dio_iomap_begin+0x415/0x970 [btrfs]
      [<00000000fb8a74b8>] iomap_iter+0x161/0x1e0
      [<0000000071dff6ff>] __iomap_dio_rw+0x1df/0x700
      [<000000002567ba53>] iomap_dio_rw+0x5/0x20
      [<0000000072e555f8>] btrfs_file_write_iter+0x290/0x530 [btrfs]
      [<000000005eb3d845>] new_sync_write+0x106/0x180
      [<000000003fb505bf>] vfs_write+0x24d/0x2f0
      [<000000009bb57d37>] __x64_sys_pwrite64+0x69/0xa0
      [<000000003eba3fdf>] do_syscall_64+0x43/0x90

In case brtfs_qgroup_reserve_data() or btrfs_delalloc_reserve_metadata()
fail the allocated extent_changeset will not be freed.

So in btrfs_check_data_free_space() and btrfs_delalloc_reserve_space()
free the allocated extent_changeset to get rid of the allocated memory.

The issue currently only happens in the direct IO write path, but only
after 65b3c08606e5 ("btrfs: fix ENOSPC failure when attempting direct IO
write into NOCOW range"), and also at defrag_one_locked_target(). Every
other place is always calling extent_changeset_free() even if its call
to btrfs_delalloc_reserve_space() or btrfs_check_data_free_space() has
failed.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delalloc-space.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -143,10 +143,13 @@ int btrfs_check_data_free_space(struct b
 
 	/* Use new btrfs_qgroup_reserve_data to reserve precious data space. */
 	ret = btrfs_qgroup_reserve_data(inode, reserved, start, len);
-	if (ret < 0)
+	if (ret < 0) {
 		btrfs_free_reserved_data_space_noquota(fs_info, len);
-	else
+		extent_changeset_free(*reserved);
+		*reserved = NULL;
+	} else {
 		ret = 0;
+	}
 	return ret;
 }
 
@@ -452,8 +455,11 @@ int btrfs_delalloc_reserve_space(struct
 	if (ret < 0)
 		return ret;
 	ret = btrfs_delalloc_reserve_metadata(inode, len);
-	if (ret < 0)
+	if (ret < 0) {
 		btrfs_free_reserved_data_space(inode, *reserved, start, len);
+		extent_changeset_free(*reserved);
+		*reserved = NULL;
+	}
 	return ret;
 }
 


