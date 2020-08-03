Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D449923A575
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgHCMhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729633AbgHCMfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:35:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0380220678;
        Mon,  3 Aug 2020 12:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458114;
        bh=/Y49samosuTbVUI8TU/dEDJDdUYQ+s2HKb4c9bua5H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSV5FcaBQ5oo9YeGlkTfS5BJLwJFZlC0EPiNZT4+OPxIQC2rB0lQZkRw7884bO9tA
         Eri9dn8w5kLGQrrqTwvIzNoqQKUfMccYTQkgGJfAdZnkgUHzCHviF6JPC4GHaIvw5P
         hDs+XCUyGci9LS9TG7G9bLhyDJICU/IfyinH5SdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/51] f2fs: check memory boundary by insane namelen
Date:   Mon,  3 Aug 2020 14:20:01 +0200
Message-Id: <20200803121850.274400619@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121849.488233135@linuxfoundation.org>
References: <20200803121849.488233135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 4e240d1bab1ead280ddf5eb05058dba6bbd57d10 ]

If namelen is corrupted to have very long value, fill_dentries can copy
wrong memory area.

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/dir.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 4abefd841b6c7..7a177b8f227d2 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -817,6 +817,16 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 		de_name.name = d->filename[bit_pos];
 		de_name.len = le16_to_cpu(de->name_len);
 
+		/* check memory boundary before moving forward */
+		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
+		if (unlikely(bit_pos > d->max)) {
+			f2fs_msg(F2FS_I_SB(d->inode)->sb, KERN_WARNING,
+				"%s: corrupted namelen=%d, run fsck to fix.",
+				__func__, le16_to_cpu(de->name_len));
+			set_sbi_flag(F2FS_I_SB(d->inode)->sb->s_fs_info, SBI_NEED_FSCK);
+			return -EINVAL;
+		}
+
 		if (f2fs_encrypted_inode(d->inode)) {
 			int save_len = fstr->len;
 			int err;
@@ -835,7 +845,6 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 					le32_to_cpu(de->ino), d_type))
 			return 1;
 
-		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 		ctx->pos = start_pos + bit_pos;
 	}
 	return 0;
-- 
2.25.1



