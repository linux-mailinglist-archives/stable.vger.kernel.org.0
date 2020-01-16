Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4509013FEEF
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391150AbgAPX2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:28:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391141AbgAPX2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12D64206D9;
        Thu, 16 Jan 2020 23:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217320;
        bh=bwkaRjRlE85PiGBRvEmaRXUO7pIt+5zFzo7sHow+pbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frEwzrSs4O6b+SjvG3bgpz9XnsBISi5ciPwRpKnt5n6nfiAYS7SHvAMnN1AZB1Ntt
         Xb4Xj3WBrJjb7HQx0Dwv9HTqLx5GxDcnTvvOdEykJLk2qocm11bK5yAJMrnmv7sJwJ
         O09nKz55rfYHrshFcxKW5XXaUoLFasCd7R2dZ0OU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 09/84] f2fs: check memory boundary by insane namelen
Date:   Fri, 17 Jan 2020 00:17:43 +0100
Message-Id: <20200116231714.655118606@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 4e240d1bab1ead280ddf5eb05058dba6bbd57d10 upstream.

If namelen is corrupted to have very long value, fill_dentries can copy
wrong memory area.

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -806,6 +806,17 @@ int f2fs_fill_dentries(struct dir_contex
 		de_name.name = d->filename[bit_pos];
 		de_name.len = le16_to_cpu(de->name_len);
 
+		/* check memory boundary before moving forward */
+		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
+		if (unlikely(bit_pos > d->max)) {
+			f2fs_msg(sbi->sb, KERN_WARNING,
+				"%s: corrupted namelen=%d, run fsck to fix.",
+				__func__, le16_to_cpu(de->name_len));
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
+			err = -EINVAL;
+			goto out;
+		}
+
 		if (f2fs_encrypted_inode(d->inode)) {
 			int save_len = fstr->len;
 
@@ -826,7 +837,6 @@ int f2fs_fill_dentries(struct dir_contex
 		if (sbi->readdir_ra == 1)
 			f2fs_ra_node_page(sbi, le32_to_cpu(de->ino));
 
-		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 		ctx->pos = start_pos + bit_pos;
 	}
 out:


