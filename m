Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D0B13FEEE
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390840AbgAPX2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:28:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390228AbgAPX2i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A32BA20684;
        Thu, 16 Jan 2020 23:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217318;
        bh=xX6H7ltO0x7XcJKEz9c3JG1ncjXf1ZnS6cx4jwm+/jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6X4ULIylPRBsNulHTLZ0r+4WVDgUtyifH5BhfQ4BNiguPmhvzs7IT2q97VQtryQo
         geI/Q28p6xdI5B9X1BUg7616gODnoZMGgiQQYFr0ZnvejScoOj/m2lYXDzqzpHPZiT
         Gx84w15Cj+80SjE/RLpTnGpLjaQcZJ7xyKkjwqXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Chao Yu <yuchao0@huawei.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 08/84] f2fs: Move err variable to function scope in f2fs_fill_dentries()
Date:   Fri, 17 Jan 2020 00:17:42 +0100
Message-Id: <20200116231714.528924990@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben.hutchings@codethink.co.uk>

This is preparation for the following backported fixes.  It was done
upstream as part of commit e1293bdfa01d "f2fs: plug readahead IO in
readdir()", the rest of which does not seem suitable for stable.

Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -785,6 +785,7 @@ int f2fs_fill_dentries(struct dir_contex
 	struct f2fs_dir_entry *de = NULL;
 	struct fscrypt_str de_name = FSTR_INIT(NULL, 0);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(d->inode);
+	int err = 0;
 
 	bit_pos = ((unsigned long)ctx->pos % d->max);
 
@@ -807,7 +808,6 @@ int f2fs_fill_dentries(struct dir_contex
 
 		if (f2fs_encrypted_inode(d->inode)) {
 			int save_len = fstr->len;
-			int err;
 
 			err = fscrypt_fname_disk_to_usr(d->inode,
 						(u32)de->hash_code, 0,
@@ -829,7 +829,8 @@ int f2fs_fill_dentries(struct dir_contex
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 		ctx->pos = start_pos + bit_pos;
 	}
-	return 0;
+out:
+	return err;
 }
 
 static int f2fs_readdir(struct file *file, struct dir_context *ctx)


