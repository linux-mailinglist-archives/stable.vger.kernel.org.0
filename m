Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CCB4512BD
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347268AbhKOTjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244998AbhKOTSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C8C763333;
        Mon, 15 Nov 2021 18:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000798;
        bh=gaLTfNA2pHqkn9JgLoxkZBqqx6KIIBKXrnLnKoxujg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ+jVjfKKGsFSrCv3LMx3m0Bmy4Vr75wQFTvMNbAd/nWZod2ZNo1JI6ZUxUn2GNoI
         2Kq4Lg2o1U/fsZHs9Y7VscZxHIah8w/ZvRBiyZHGmJfy7pdtB5N48pl1NGEFgij1kB
         FiePlbAD/mRi8dvdgUXp+FbAmOg1ehPAqDAmYTdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Light Hsieh <light.hsieh@mediatek.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.14 796/849] f2fs: should use GFP_NOFS for directory inodes
Date:   Mon, 15 Nov 2021 18:04:39 +0100
Message-Id: <20211115165447.166741008@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 92d602bc7177325e7453189a22e0c8764ed3453e upstream.

We use inline_dentry which requires to allocate dentry page when adding a link.
If we allow to reclaim memory from filesystem, we do down_read(&sbi->cp_rwsem)
twice by f2fs_lock_op(). I think this should be okay, but how about stopping
the lockdep complaint [1]?

f2fs_create()
 - f2fs_lock_op()
 - f2fs_do_add_link()
  - __f2fs_find_entry
   - f2fs_get_read_data_page()
   -> kswapd
    - shrink_node
     - f2fs_evict_inode
      - f2fs_lock_op()

[1]

fs_reclaim
){+.+.}-{0:0}
:
kswapd0:        lock_acquire+0x114/0x394
kswapd0:        __fs_reclaim_acquire+0x40/0x50
kswapd0:        prepare_alloc_pages+0x94/0x1ec
kswapd0:        __alloc_pages_nodemask+0x78/0x1b0
kswapd0:        pagecache_get_page+0x2e0/0x57c
kswapd0:        f2fs_get_read_data_page+0xc0/0x394
kswapd0:        f2fs_find_data_page+0xa4/0x23c
kswapd0:        find_in_level+0x1a8/0x36c
kswapd0:        __f2fs_find_entry+0x70/0x100
kswapd0:        f2fs_do_add_link+0x84/0x1ec
kswapd0:        f2fs_mkdir+0xe4/0x1e4
kswapd0:        vfs_mkdir+0x110/0x1c0
kswapd0:        do_mkdirat+0xa4/0x160
kswapd0:        __arm64_sys_mkdirat+0x24/0x34
kswapd0:        el0_svc_common.llvm.17258447499513131576+0xc4/0x1e8
kswapd0:        do_el0_svc+0x28/0xa0
kswapd0:        el0_svc+0x24/0x38
kswapd0:        el0_sync_handler+0x88/0xec
kswapd0:        el0_sync+0x1c0/0x200
kswapd0:
-> #1
(
&sbi->cp_rwsem
){++++}-{3:3}
:
kswapd0:        lock_acquire+0x114/0x394
kswapd0:        down_read+0x7c/0x98
kswapd0:        f2fs_do_truncate_blocks+0x78/0x3dc
kswapd0:        f2fs_truncate+0xc8/0x128
kswapd0:        f2fs_evict_inode+0x2b8/0x8b8
kswapd0:        evict+0xd4/0x2f8
kswapd0:        iput+0x1c0/0x258
kswapd0:        do_unlinkat+0x170/0x2a0
kswapd0:        __arm64_sys_unlinkat+0x4c/0x68
kswapd0:        el0_svc_common.llvm.17258447499513131576+0xc4/0x1e8
kswapd0:        do_el0_svc+0x28/0xa0
kswapd0:        el0_svc+0x24/0x38
kswapd0:        el0_sync_handler+0x88/0xec
kswapd0:        el0_sync+0x1c0/0x200

Cc: stable@vger.kernel.org
Fixes: bdbc90fa55af ("f2fs: don't put dentry page in pagecache into highmem")
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Light Hsieh <light.hsieh@mediatek.com>
Tested-by: Light Hsieh <light.hsieh@mediatek.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |    2 +-
 fs/f2fs/namei.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -527,7 +527,7 @@ make_now:
 		inode->i_op = &f2fs_dir_inode_operations;
 		inode->i_fop = &f2fs_dir_operations;
 		inode->i_mapping->a_ops = &f2fs_dblock_aops;
-		inode_nohighmem(inode);
+		mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
 	} else if (S_ISLNK(inode->i_mode)) {
 		if (file_is_encrypt(inode))
 			inode->i_op = &f2fs_encrypted_symlink_inode_operations;
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -757,7 +757,7 @@ static int f2fs_mkdir(struct user_namesp
 	inode->i_op = &f2fs_dir_inode_operations;
 	inode->i_fop = &f2fs_dir_operations;
 	inode->i_mapping->a_ops = &f2fs_dblock_aops;
-	inode_nohighmem(inode);
+	mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
 
 	set_inode_flag(inode, FI_INC_LINK);
 	f2fs_lock_op(sbi);


