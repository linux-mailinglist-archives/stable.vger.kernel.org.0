Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF2A2A1A5A
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 20:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgJaT66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 15:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbgJaT66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 15:58:58 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 286D8206E9;
        Sat, 31 Oct 2020 19:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604174338;
        bh=pg93KM0ZOaLrR1WbAPRS3b1mszl+k1+y2wAs9bVDi5Q=;
        h=From:To:Cc:Subject:Date:From;
        b=UH8w45+kfcmduZ8atKoG5GbgzR5hQSSgbgMIL7cm7kgUuiZRIVidWyQxwokMuD8+u
         9JiGIKFzkz2qFmK9c4vCN3onboqPNLvAKukZFNr91O7GLdbYzHfvIhf+nbQGTqwF+q
         3sRN68nNeoO2CGO606/e08Tcl+ORtAZqAg2grkAQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.4] f2fs crypto: avoid unneeded memory allocation in ->readdir
Date:   Sat, 31 Oct 2020 12:58:09 -0700
Message-Id: <20201031195809.377983-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit e06f86e61d7a67fe6e826010f57aa39c674f4b1b upstream.
[This backport fixes a regression in 4.4-stable caused by commit
11a6e8f89521 ("f2fs: check memory boundary by insane namelen"), which
depended on this missing commit.  This bad backport broke f2fs
encryption because it moved the incrementing of 'bit_pos' to earlier in
f2fs_fill_dentries() without accounting for it being used in the
encrypted dir case.  This caused readdir() on encrypted directories to
start failing.  Tested with 'kvm-xfstests -c f2fs -g encrypt'.]

When decrypting dirents in ->readdir, fscrypt_fname_disk_to_usr won't
change content of original encrypted dirent, we don't need to allocate
additional buffer for storing mirror of it, so get rid of it.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/dir.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index e2ff0eb16f89c..c1130914d6ed7 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -820,15 +820,8 @@ bool f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
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
 
-- 
2.29.1

