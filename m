Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C164497F53
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiAXMYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbiAXMYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:24:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F59C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 04:24:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4F2FB80F91
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97C3C340E7;
        Mon, 24 Jan 2022 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643027087;
        bh=uJcYyJ+6QLyiILdu3A6xVVwTc80YfXDhx0/sw5stGxg=;
        h=Subject:To:Cc:From:Date:From;
        b=1Kno+62xy2xQ1kZmVz/SHV9qcz/hXw80O3lVdo1pcSwJtSyFBxE66jv7p4TvI3fQ+
         tikGSksaRYdHbtPjp4KKTYddZ+R/VhRiBv+RLaE6eWy7ZATtQ9z/DEHKdpXHD6OGTI
         Oeb2qJ1k1rquM1Z8L2YeM61LuMoF/Ix7e2IeZS9o=
Subject: FAILED: patch "[PATCH] f2fs: fix to avoid panic in is_alive() if metadata is" failed to apply to 5.4-stable tree
To:     chao@kernel.org, jaegeuk@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:24:44 +0100
Message-ID: <164302708414397@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f6db43076d190d9bf75559dec28e18b9d12e4ce5 Mon Sep 17 00:00:00 2001
From: Chao Yu <chao@kernel.org>
Date: Mon, 6 Dec 2021 22:44:20 +0800
Subject: [PATCH] f2fs: fix to avoid panic in is_alive() if metadata is
 inconsistent

As report by Wenqing Liu in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215231

If we enable CONFIG_F2FS_CHECK_FS config, and with fuzzed image attached
in above link, we will encounter panic when executing below script:

1. mkdir mnt
2. mount -t f2fs tmp1.img mnt
3. touch tmp

F2FS-fs (loop11): mismatched blkaddr 5765 (source_blkaddr 1) in seg 3
kernel BUG at fs/f2fs/gc.c:1042!
 do_garbage_collect+0x90f/0xa80 [f2fs]
 f2fs_gc+0x294/0x12a0 [f2fs]
 f2fs_balance_fs+0x2c5/0x7d0 [f2fs]
 f2fs_create+0x239/0xd90 [f2fs]
 lookup_open+0x45e/0xa90
 open_last_lookups+0x203/0x670
 path_openat+0xae/0x490
 do_filp_open+0xbc/0x160
 do_sys_openat2+0x2f1/0x500
 do_sys_open+0x5e/0xa0
 __x64_sys_openat+0x28/0x40

Previously, f2fs tries to catch data inconcistency exception in between
SSA and SIT table during GC, however once the exception is caught, it will
call f2fs_bug_on to hang kernel, it's not needed, instead, let's set
SBI_NEED_FSCK flag and skip migrating current block.

Fixes: bbf9f7d90f21 ("f2fs: Fix indefinite loop in f2fs_gc()")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index e0bdc4361a9b..3e64b234df21 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1039,7 +1039,7 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 			if (!test_and_set_bit(segno, SIT_I(sbi)->invalid_segmap)) {
 				f2fs_err(sbi, "mismatched blkaddr %u (source_blkaddr %u) in seg %u",
 					 blkaddr, source_blkaddr, segno);
-				f2fs_bug_on(sbi, 1);
+				set_sbi_flag(sbi, SBI_NEED_FSCK);
 			}
 		}
 #endif

