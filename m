Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C6E29BFB0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816438AbgJ0RGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762641AbgJ0PGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:06:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F180C22275;
        Tue, 27 Oct 2020 15:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811199;
        bh=hyRHfek5kRpCjhxU/oAuY4RrZ4hzquBLpSBV0g4MUvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmRPPfiWApwtu3KOnLYgWcMZUxsBBUl3cfoVHTVAQ3MiitCocc7fe7QdFOdKUbsdV
         N+up2jmdeClS7ITRPThl+Z3Yv+L48w7VsNideChm6cIhtv2bnmB16LPN4rLRIe7EmX
         GVGRdCUMJarVuKH3x0ivNgiYRRtQGe8HIzbOVDDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+05139c4039d0679e19ff@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 407/633] f2fs: reject CASEFOLD inode flag without casefold feature
Date:   Tue, 27 Oct 2020 14:52:30 +0100
Message-Id: <20201027135541.814012524@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit f6322f3f1212e005e7e6aa82ceb62be53030a64b ]

syzbot reported:

    general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
    KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
    CPU: 0 PID: 6860 Comm: syz-executor835 Not tainted 5.9.0-rc8-syzkaller #0
    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
    RIP: 0010:utf8_casefold+0x43/0x1b0 fs/unicode/utf8-core.c:107
    [...]
    Call Trace:
     f2fs_init_casefolded_name fs/f2fs/dir.c:85 [inline]
     __f2fs_setup_filename fs/f2fs/dir.c:118 [inline]
     f2fs_prepare_lookup+0x3bf/0x640 fs/f2fs/dir.c:163
     f2fs_lookup+0x10d/0x920 fs/f2fs/namei.c:494
     __lookup_hash+0x115/0x240 fs/namei.c:1445
     filename_create+0x14b/0x630 fs/namei.c:3467
     user_path_create fs/namei.c:3524 [inline]
     do_mkdirat+0x56/0x310 fs/namei.c:3664
     do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
     entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [...]

The problem is that an inode has F2FS_CASEFOLD_FL set, but the
filesystem doesn't have the casefold feature flag set, and therefore
super_block::s_encoding is NULL.

Fix this by making sanity_check_inode() reject inodes that have
F2FS_CASEFOLD_FL when the filesystem doesn't have the casefold feature.

Reported-by: syzbot+05139c4039d0679e19ff@syzkaller.appspotmail.com
Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 44582a4db513e..1e014535c2530 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -287,6 +287,13 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
 		return false;
 	}
 
+	if ((fi->i_flags & F2FS_CASEFOLD_FL) && !f2fs_sb_has_casefold(sbi)) {
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		f2fs_warn(sbi, "%s: inode (ino=%lx) has casefold flag, but casefold feature is off",
+			  __func__, inode->i_ino);
+		return false;
+	}
+
 	if (f2fs_has_extra_attr(inode) && f2fs_sb_has_compression(sbi) &&
 			fi->i_flags & F2FS_COMPR_FL &&
 			F2FS_FITS_IN_INODE(ri, fi->i_extra_isize,
-- 
2.25.1



