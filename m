Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8085923EC
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240562AbiHNQ0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242210AbiHNQZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:25:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ADC18E32;
        Sun, 14 Aug 2022 09:23:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5FA860C98;
        Sun, 14 Aug 2022 16:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190ECC433D7;
        Sun, 14 Aug 2022 16:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494182;
        bh=Ubdo+zLeCBEUIp0Fs/1zOYCZvfQ0W+LWuOA/P/mTFU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxuqFS7bXOC+e59Gmb6BO0soLSRMfqIWK13dfzNhEjhW4Sy2rpKLmWmWQ+TRJP1Hu
         J03MkVTAQF6OIU6zUuRS2Tt1pmx7Wurx2eQ8StSs+L9uxuxv9yOREwuyqzSYYLhGL7
         uOCuqIkGpkXtDy2k6Iz6Iiqak6VvUH1N34Fr3s3JbLwZYiN/mQFRv3VaYz+kTLlRor
         D1uWS7e5xhEVEC5eLDBS2EFu3dB0FENCU4CdNEntVaQoIJiAv/MFQZreKhqInL+oh7
         2hhljutI+pP2sNp5vXi/C0OX/g1n0FEb1XNJJ+taWWEPVbCK/h3DiwL3JzWgJ3MVi8
         LGfXxmQsb0DjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <chao.yu@oppo.com>,
        Dipanjan Das <mail.dipanjan.das@gmail.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>, chao@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.19 40/48] f2fs: fix to avoid use f2fs_bug_on() in f2fs_new_node_page()
Date:   Sun, 14 Aug 2022 12:19:33 -0400
Message-Id: <20220814161943.2394452-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao.yu@oppo.com>

[ Upstream commit 141170b759e03958f296033bb7001be62d1d363b ]

As Dipanjan Das <mail.dipanjan.das@gmail.com> reported, syzkaller
found a f2fs bug as below:

RIP: 0010:f2fs_new_node_page+0x19ac/0x1fc0 fs/f2fs/node.c:1295
Call Trace:
 write_all_xattrs fs/f2fs/xattr.c:487 [inline]
 __f2fs_setxattr+0xe76/0x2e10 fs/f2fs/xattr.c:743
 f2fs_setxattr+0x233/0xab0 fs/f2fs/xattr.c:790
 f2fs_xattr_generic_set+0x133/0x170 fs/f2fs/xattr.c:86
 __vfs_setxattr+0x115/0x180 fs/xattr.c:182
 __vfs_setxattr_noperm+0x125/0x5f0 fs/xattr.c:216
 __vfs_setxattr_locked+0x1cf/0x260 fs/xattr.c:277
 vfs_setxattr+0x13f/0x330 fs/xattr.c:303
 setxattr+0x146/0x160 fs/xattr.c:611
 path_setxattr+0x1a7/0x1d0 fs/xattr.c:630
 __do_sys_lsetxattr fs/xattr.c:653 [inline]
 __se_sys_lsetxattr fs/xattr.c:649 [inline]
 __x64_sys_lsetxattr+0xbd/0x150 fs/xattr.c:649
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

NAT entry and nat bitmap can be inconsistent, e.g. one nid is free
in nat bitmap, and blkaddr in its NAT entry is not NULL_ADDR, it
may trigger BUG_ON() in f2fs_new_node_page(), fix it.

Reported-by: Dipanjan Das <mail.dipanjan.das@gmail.com>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index cf6f7fc83c08..02e92a72511b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1292,7 +1292,11 @@ struct page *f2fs_new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 		dec_valid_node_count(sbi, dn->inode, !ofs);
 		goto fail;
 	}
-	f2fs_bug_on(sbi, new_ni.blk_addr != NULL_ADDR);
+	if (unlikely(new_ni.blk_addr != NULL_ADDR)) {
+		err = -EFSCORRUPTED;
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		goto fail;
+	}
 #endif
 	new_ni.nid = dn->nid;
 	new_ni.ino = dn->inode->i_ino;
-- 
2.35.1

