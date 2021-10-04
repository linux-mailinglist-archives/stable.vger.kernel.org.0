Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B077F420EB2
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbhJDN13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236929AbhJDNZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:25:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 312CA61B63;
        Mon,  4 Oct 2021 13:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353076;
        bh=qu+WSH9qPU3IcvVtKrMjd5cwDirZGSzcucxPtJM+UzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKjLclRp/den9bjLakZ2cp7onqEIGF1vQqDV66lQcSt6T5WgpubrHBs2E96HDVQUj
         yeUn8vwBI/Nce0EWeCadx5fQLkHlCpMwmByQLhNAZoUqXOgkUkPoCE8j6mJbPakTxL
         Lnq0nZ6T63PffLO1+RdXyeGNhQag3EWrafCCFjuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        yangerkun <yangerkun@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 80/93] ext4: fix potential infinite loop in ext4_dx_readdir()
Date:   Mon,  4 Oct 2021 14:53:18 +0200
Message-Id: <20211004125037.238214278@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

commit 42cb447410d024e9d54139ae9c21ea132a8c384c upstream.

When ext4_htree_fill_tree() fails, ext4_dx_readdir() can run into an
infinite loop since if info->last_pos != ctx->pos this will reset the
directory scan and reread the failing entry.  For example:

1. a dx_dir which has 3 block, block 0 as dx_root block, block 1/2 as
   leaf block which own the ext4_dir_entry_2
2. block 1 read ok and call_filldir which will fill the dirent and update
   the ctx->pos
3. block 2 read fail, but we has already fill some dirent, so we will
   return back to userspace will a positive return val(see ksys_getdents64)
4. the second ext4_dx_readdir will reset the world since info->last_pos
   != ctx->pos, and will also init the curr_hash which pos to block 1
5. So we will read block1 too, and once block2 still read fail, we can
   only fill one dirent because the hash of the entry in block1(besides
   the last one) won't greater than curr_hash
6. this time, we forget update last_pos too since the read for block2
   will fail, and since we has got the one entry, ksys_getdents64 can
   return success
7. Latter we will trapped in a loop with step 4~6

Cc: stable@kernel.org
Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210914111415.3921954-1-yangerkun@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/dir.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -534,7 +534,7 @@ static int ext4_dx_readdir(struct file *
 	struct dir_private_info *info = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct fname *fname;
-	int	ret;
+	int ret = 0;
 
 	if (!info) {
 		info = ext4_htree_create_dir_info(file, ctx->pos);
@@ -582,7 +582,7 @@ static int ext4_dx_readdir(struct file *
 						   info->curr_minor_hash,
 						   &info->next_hash);
 			if (ret < 0)
-				return ret;
+				goto finished;
 			if (ret == 0) {
 				ctx->pos = ext4_get_htree_eof(file);
 				break;
@@ -613,7 +613,7 @@ static int ext4_dx_readdir(struct file *
 	}
 finished:
 	info->last_pos = ctx->pos;
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 static int ext4_dir_open(struct inode * inode, struct file * filp)


