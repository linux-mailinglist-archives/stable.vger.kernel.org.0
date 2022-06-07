Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232DD541D17
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383727AbiFGWIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356690AbiFGWGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAF7252C2C;
        Tue,  7 Jun 2022 12:15:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C908B822C0;
        Tue,  7 Jun 2022 19:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC007C385A2;
        Tue,  7 Jun 2022 19:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629348;
        bh=AFmrO0annGer79QB+xtRaRH2XRcecd0xN8/ccZeQdG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3f+YylxH7DsLQfDyLdr6NuiB+JNxafZeeXSLfGcgJWSmvCeqFDY1nLPv6hya/H8v
         H92ISD/OgU79NkuFFLpWXGGZ75B8ZNHPf2T2ZYEAgeKJdZJha3OutP6GutouT0E4PF
         wNez1j8GMf6w9rPyrKR1sBxluOC2nqHawcUr/pzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenqing Liu <wenqingliu0120@gmail.com>,
        Chao Yu <chao.yu@oppo.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 659/879] f2fs: fix to do sanity check on inline_dots inode
Date:   Tue,  7 Jun 2022 19:02:57 +0200
Message-Id: <20220607165021.975926404@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit 12662d19467b391b5b509ac5e9ab4f583c6dde16 ]

As Wenqing reported in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=215765

It will cause a kernel panic with steps:
- mkdir mnt
- mount tmp40.img mnt
- ls mnt

folio_mark_dirty+0x33/0x50
f2fs_add_regular_entry+0x541/0xad0 [f2fs]
f2fs_add_dentry+0x6c/0xb0 [f2fs]
f2fs_do_add_link+0x182/0x230 [f2fs]
__recover_dot_dentries+0x2d6/0x470 [f2fs]
f2fs_lookup+0x5af/0x6a0 [f2fs]
__lookup_slow+0xac/0x200
lookup_slow+0x45/0x70
walk_component+0x16c/0x250
path_lookupat+0x8b/0x1f0
filename_lookup+0xef/0x250
user_path_at_empty+0x46/0x70
vfs_statx+0x98/0x190
__do_sys_newlstat+0x41/0x90
__x64_sys_newlstat+0x1a/0x30
do_syscall_64+0x37/0xb0
entry_SYSCALL_64_after_hwframe+0x44/0xae

The root cause is for special file: e.g. character, block, fifo or
socket file, f2fs doesn't assign address space operations pointer array
for mapping->a_ops field, so, in a fuzzed image, if inline_dots flag was
tagged in special file, during lookup(), when f2fs runs into
__recover_dot_dentries(), it will cause NULL pointer access once
f2fs_add_regular_entry() calls a_ops->set_dirty_page().

Fixes: 510022a85839 ("f2fs: add F2FS_INLINE_DOTS to recover missing dot dentries")
Reported-by: Wenqing Liu <wenqingliu0120@gmail.com>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 5ed79b29999f..fffafd2aa438 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -461,6 +461,13 @@ static int __recover_dot_dentries(struct inode *dir, nid_t pino)
 		return 0;
 	}
 
+	if (!S_ISDIR(dir->i_mode)) {
+		f2fs_err(sbi, "inconsistent inode status, skip recovering inline_dots inode (ino:%lu, i_mode:%u, pino:%u)",
+			  dir->i_ino, dir->i_mode, pino);
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		return -ENOTDIR;
+	}
+
 	err = f2fs_dquot_initialize(dir);
 	if (err)
 		return err;
-- 
2.35.1



