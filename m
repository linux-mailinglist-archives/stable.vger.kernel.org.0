Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9384121D8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357338AbhITSKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358605AbhITSHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:07:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FC8D6324F;
        Mon, 20 Sep 2021 17:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158293;
        bh=0bxMqghMWE8jYyhwodguChsinCuVvW/DSK+nOv02lts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qyrO2qTE0STPQ11Lxt6e2EbEPgREp4M6aEBsm9RtpxvvniFVEYz1MnWwBKD0WGc0
         M7dqDFhqH1TFEnhjaO2faQ7ai/6uB8h2JdLQfSsMnP48cSUHiZGRfwuouLVARMZGvu
         8KN50XCRsJCHqHj5yWscl0U3/kPzQ6tEYm/1I++g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <frank.li@vivo.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/260] f2fs: reduce the scope of setting fsck tag when de->name_len is zero
Date:   Mon, 20 Sep 2021 18:41:05 +0200
Message-Id: <20210920163932.709960824@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit d4bf15a7ce172d186d400d606adf4f34a59130d6 ]

I recently found a case where de->name_len is 0 in f2fs_fill_dentries()
easily reproduced, and finally set the fsck flag.

Thread A			Thread B
- f2fs_readdir
 - f2fs_read_inline_dir
  - ctx->pos = d.max
				- f2fs_add_dentry
				 - f2fs_add_inline_entry
				  - do_convert_inline_dir
				 - f2fs_add_regular_entry
- f2fs_readdir
 - f2fs_fill_dentries
  - set_sbi_flag(sbi, SBI_NEED_FSCK)

Process A opens the folder, and has been reading without closing it.
During this period, Process B created a file under the folder (occupying
multiple f2fs_dir_entry, exceeding the d.max of the inline dir). After
creation, process A uses the d.max of inline dir to read it again, and
it will read that de->name_len is 0.

And Chao pointed out that w/o inline conversion, the race condition still
can happen as below:

dir_entry1: A
dir_entry2: B
dir_entry3: C
free slot: _
ctx->pos: ^

Thread A is traversing directory,
ctx-pos moves to below position after readdir() by thread A:
AAAABBBB___
        ^

Then thread B delete dir_entry2, and create dir_entry3.

Thread A calls readdir() to lookup dirents starting from middle
of new dirent slots as below:
AAAACCCCCC_
        ^
In these scenarios, the file system is not damaged, and it's hard to
avoid it. But we can bypass tagging FSCK flag if:
a) bit_pos (:= ctx->pos % d->max) is non-zero and
b) before bit_pos moves to first valid dir_entry.

Fixes: ddf06b753a85 ("f2fs: fix to trigger fsck if dirent.name_len is zero")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
[Chao: clean up description]
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/dir.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 7b3fbfe68f8c..99c4a868d73b 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -892,6 +892,7 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 	struct f2fs_sb_info *sbi = F2FS_I_SB(d->inode);
 	struct blk_plug plug;
 	bool readdir_ra = sbi->readdir_ra == 1;
+	bool found_valid_dirent = false;
 	int err = 0;
 
 	bit_pos = ((unsigned long)ctx->pos % d->max);
@@ -906,13 +907,15 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 
 		de = &d->dentry[bit_pos];
 		if (de->name_len == 0) {
+			if (found_valid_dirent || !bit_pos) {
+				printk_ratelimited(
+					"%sF2FS-fs (%s): invalid namelen(0), ino:%u, run fsck to fix.",
+					KERN_WARNING, sbi->sb->s_id,
+					le32_to_cpu(de->ino));
+				set_sbi_flag(sbi, SBI_NEED_FSCK);
+			}
 			bit_pos++;
 			ctx->pos = start_pos + bit_pos;
-			printk_ratelimited(
-				"%sF2FS-fs (%s): invalid namelen(0), ino:%u, run fsck to fix.",
-				KERN_WARNING, sbi->sb->s_id,
-				le32_to_cpu(de->ino));
-			set_sbi_flag(sbi, SBI_NEED_FSCK);
 			continue;
 		}
 
@@ -955,6 +958,7 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 			f2fs_ra_node_page(sbi, le32_to_cpu(de->ino));
 
 		ctx->pos = start_pos + bit_pos;
+		found_valid_dirent = true;
 	}
 out:
 	if (readdir_ra)
-- 
2.30.2



