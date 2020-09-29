Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8061F27C67F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbgI2Lpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbgI2Lp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 326BB20848;
        Tue, 29 Sep 2020 11:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379928;
        bh=VwKYcLdKdyLywwkV/IU6tgV8uptS/9x4Zk9BQYEnp6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdbcwDLDxOYwb20VOSJUoeJCaZIJnWoYJQC2/o0zi1rqa7n6aqJQOR0dDP/Yw7C8G
         gjfTH9ZE1ePuT4A00VrSpdBFMCG3y88spjMA5KNg1JCrqTos5NAdRIcdzQKW3iD16C
         GzOfqZfposOet6UcCBD4mlMdn140+94MYut+wdGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e864a35d361e1d4e29a5@syzkaller.appspotmail.com,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 378/388] btrfs: fix overflow when copying corrupt csums for a message
Date:   Tue, 29 Sep 2020 13:01:49 +0200
Message-Id: <20200929110028.760543733@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 35be8851d172c6e3db836c0f28c19087b10c9e00 upstream.

Syzkaller reported a buffer overflow in btree_readpage_end_io_hook()
when loop mounting a crafted image:

  detected buffer overflow in memcpy
  ------------[ cut here ]------------
  kernel BUG at lib/string.c:1129!
  invalid opcode: 0000 [#1] PREEMPT SMP KASAN
  CPU: 1 PID: 26 Comm: kworker/u4:2 Not tainted 5.9.0-rc4-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Workqueue: btrfs-endio-meta btrfs_work_helper
  RIP: 0010:fortify_panic+0xf/0x20 lib/string.c:1129
  RSP: 0018:ffffc90000e27980 EFLAGS: 00010286
  RAX: 0000000000000022 RBX: ffff8880a80dca64 RCX: 0000000000000000
  RDX: ffff8880a90860c0 RSI: ffffffff815dba07 RDI: fffff520001c4f22
  RBP: ffff8880a80dca00 R08: 0000000000000022 R09: ffff8880ae7318e7
  R10: 0000000000000000 R11: 0000000000077578 R12: 00000000ffffff6e
  R13: 0000000000000008 R14: ffffc90000e27a40 R15: 1ffff920001c4f3c
  FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000557335f440d0 CR3: 000000009647d000 CR4: 00000000001506e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   memcpy include/linux/string.h:405 [inline]
   btree_readpage_end_io_hook.cold+0x206/0x221 fs/btrfs/disk-io.c:642
   end_bio_extent_readpage+0x4de/0x10c0 fs/btrfs/extent_io.c:2854
   bio_endio+0x3cf/0x7f0 block/bio.c:1449
   end_workqueue_fn+0x114/0x170 fs/btrfs/disk-io.c:1695
   btrfs_work_helper+0x221/0xe20 fs/btrfs/async-thread.c:318
   process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
   worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
   kthread+0x3b5/0x4a0 kernel/kthread.c:292
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
  Modules linked in:
  ---[ end trace b68924293169feef ]---
  RIP: 0010:fortify_panic+0xf/0x20 lib/string.c:1129
  RSP: 0018:ffffc90000e27980 EFLAGS: 00010286
  RAX: 0000000000000022 RBX: ffff8880a80dca64 RCX: 0000000000000000
  RDX: ffff8880a90860c0 RSI: ffffffff815dba07 RDI: fffff520001c4f22
  RBP: ffff8880a80dca00 R08: 0000000000000022 R09: ffff8880ae7318e7
  R10: 0000000000000000 R11: 0000000000077578 R12: 00000000ffffff6e
  R13: 0000000000000008 R14: ffffc90000e27a40 R15: 1ffff920001c4f3c
  FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f95b7c4d008 CR3: 000000009647d000 CR4: 00000000001506e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

The overflow happens, because in btree_readpage_end_io_hook() we assume
that we have found a 4 byte checksum instead of the real possible 32
bytes we have for the checksums.

With the fix applied:

[   35.726623] BTRFS: device fsid 815caf9a-dc43-4d2a-ac54-764b8333d765 devid 1 transid 5 /dev/loop0 scanned by syz-repro (215)
[   35.738994] BTRFS info (device loop0): disk space caching is enabled
[   35.738998] BTRFS info (device loop0): has skinny extents
[   35.743337] BTRFS warning (device loop0): loop0 checksum verify failed on 1052672 wanted 0xf9c035fc8d239a54 found 0x67a25c14b7eabcf9 level 0
[   35.743420] BTRFS error (device loop0): failed to read chunk root
[   35.745899] BTRFS error (device loop0): open_ctree failed

Reported-by: syzbot+e864a35d361e1d4e29a5@syzkaller.appspotmail.com
Fixes: d5178578bcd4 ("btrfs: directly call into crypto framework for checksumming")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -649,16 +649,15 @@ static int btree_readpage_end_io_hook(st
 		goto err;
 
 	if (memcmp_extent_buffer(eb, result, 0, csum_size)) {
-		u32 val;
-		u32 found = 0;
-
-		memcpy(&found, result, csum_size);
+		u8 val[BTRFS_CSUM_SIZE] = { 0 };
 
 		read_extent_buffer(eb, &val, 0, csum_size);
 		btrfs_warn_rl(fs_info,
-		"%s checksum verify failed on %llu wanted %x found %x level %d",
+	"%s checksum verify failed on %llu wanted " CSUM_FMT " found " CSUM_FMT " level %d",
 			      fs_info->sb->s_id, eb->start,
-			      val, found, btrfs_header_level(eb));
+			      CSUM_FMT_VALUE(csum_size, val),
+			      CSUM_FMT_VALUE(csum_size, result),
+			      btrfs_header_level(eb));
 		ret = -EUCLEAN;
 		goto err;
 	}


