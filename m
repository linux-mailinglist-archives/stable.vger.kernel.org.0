Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDA32ABD75
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgKINqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:46:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730075AbgKIM5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:57:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C572076E;
        Mon,  9 Nov 2020 12:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926672;
        bh=Mn+6KCzlChwh59gmr9s1vSh/TJwl8LCLE1iobewZrAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y02KvlE3Nrd7fZXlD2x/eKvJg617hKb33kgI3irTUOW1ZDgNueCUbykXVdXLv2HvG
         0exBKFmzgEHCQhDbx9KgyuFHJUP+StZ9Q+wapSGStuFhKBxrpG9t1CzptL+qM+Va/O
         nT3J6tKf2OMi9Yn5zO55c5mD+m+BdFAfjW/H/cyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.4 10/86] f2fs crypto: avoid unneeded memory allocation in ->readdir
Date:   Mon,  9 Nov 2020 13:54:17 +0100
Message-Id: <20201109125021.360517842@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit e06f86e61d7a67fe6e826010f57aa39c674f4b1b upstream.

When decrypting dirents in ->readdir, fscrypt_fname_disk_to_usr won't
change content of original encrypted dirent, we don't need to allocate
additional buffer for storing mirror of it, so get rid of it.

[This backport fixes a regression in 4.4-stable caused by commit
11a6e8f89521 ("f2fs: check memory boundary by insane namelen"), which
depended on this missing commit.  This bad backport broke f2fs
encryption because it moved the incrementing of 'bit_pos' to earlier in
f2fs_fill_dentries() without accounting for it being used in the
encrypted dir case.  This caused readdir() on encrypted directories to
start failing.  Tested with 'kvm-xfstests -c f2fs -g encrypt'.]

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -820,15 +820,8 @@ bool f2fs_fill_dentries(struct dir_conte
 			int save_len = fstr->len;
 			int ret;
 
-			de_name.name = kmalloc(de_name.len, GFP_NOFS);
-			if (!de_name.name)
-				return false;
-
-			memcpy(de_name.name, d->filename[bit_pos], de_name.len);
-
 			ret = f2fs_fname_disk_to_usr(d->inode, &de->hash_code,
 							&de_name, fstr);
-			kfree(de_name.name);
 			if (ret < 0)
 				return true;
 


