Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4087469959
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 15:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245457AbhLFOsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 09:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242816AbhLFOsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 09:48:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316B4C061746;
        Mon,  6 Dec 2021 06:44:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2646B80FAC;
        Mon,  6 Dec 2021 14:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C086C341C1;
        Mon,  6 Dec 2021 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638801879;
        bh=jD7hTCqRrM5m/SGRU4q5TUNEzaYAGktc8wEkQCep70U=;
        h=From:To:Cc:Subject:Date:From;
        b=JyP7syxCBvz6OfIrqUdgMTUm4ChppcExoWsjjEAMnaTUJv9xSDjS1fC8J7HDyQTdw
         S2NTL1aPX+bwJLQFMEa0mWGjLAMNTOj/Kd7RI+3vxn1/0Brdy2tfx0Zm9roAOiA6QH
         1Jxrxdnk1hwBUWCqj4eccyWNLfWvn17lXEHMnnraHSb7jJSR8PW2UwmDCnU6ZAQUyO
         wqQAvnuym4Kzf3QGh0lBX0j4viVwbSWXAH7O9ds5mPxdiQ5Vmqm5v3LCISaGnXRlNz
         M6r50lx74WB6XzAWf/1Yk0r5hgH5P6yhpvkPklfMvDKzBw03UvE5xOb/EsCuNBWyv8
         6c3FEM0fOOsEA==
From:   Chao Yu <chao@kernel.org>
To:     jaegeuk@kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chao Yu <chao@kernel.org>,
        stable@vger.kernel.org, Wenqing Liu <wenqingliu0120@gmail.com>
Subject: [PATCH 1/3] f2fs: fix to do sanity check on inode type during garbage collection
Date:   Mon,  6 Dec 2021 22:44:19 +0800
Message-Id: <20211206144421.3735-1-chao@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As report by Wenqing Liu in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215231

- Overview
kernel NULL pointer dereference triggered  in folio_mark_dirty() when mount and operate on a crafted f2fs image

- Reproduce
tested on kernel 5.16-rc3, 5.15.X under root

1. mkdir mnt
2. mount -t f2fs tmp1.img mnt
3. touch tmp
4. cp tmp mnt

F2FS-fs (loop0): sanity_check_inode: inode (ino=49) extent info [5942, 4294180864, 4] is incorrect, run fsck to fix
F2FS-fs (loop0): f2fs_check_nid_range: out-of-range nid=31340049, run fsck to fix.
BUG: kernel NULL pointer dereference, address: 0000000000000000
 folio_mark_dirty+0x33/0x50
 move_data_page+0x2dd/0x460 [f2fs]
 do_garbage_collect+0xc18/0x16a0 [f2fs]
 f2fs_gc+0x1d3/0xd90 [f2fs]
 f2fs_balance_fs+0x13a/0x570 [f2fs]
 f2fs_create+0x285/0x840 [f2fs]
 path_openat+0xe6d/0x1040
 do_filp_open+0xc5/0x140
 do_sys_openat2+0x23a/0x310
 do_sys_open+0x57/0x80

The root cause is for special file: e.g. character, block, fifo or socket file,
f2fs doesn't assign address space operations pointer array for mapping->a_ops field,
so, in a fuzzed image, SSA table indicates a data block belong to special file, when
f2fs tries to migrate that block, it causes NULL pointer access once move_data_page()
calls a_ops->set_dirty_page().

Cc: stable@vger.kernel.org
Reported-by: Wenqing Liu <wenqingliu0120@gmail.com>
Signed-off-by: Chao Yu <chao@kernel.org>
---
 fs/f2fs/gc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index a946ce0ead34..e0bdc4361a9b 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1457,7 +1457,8 @@ static int gc_data_segment(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 
 		if (phase == 3) {
 			inode = f2fs_iget(sb, dni.ino);
-			if (IS_ERR(inode) || is_bad_inode(inode))
+			if (IS_ERR(inode) || is_bad_inode(inode) ||
+					special_file(inode->i_mode))
 				continue;
 
 			if (!down_write_trylock(
-- 
2.32.0

