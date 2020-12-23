Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEE02E1E49
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgLWPg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:36:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728511AbgLWPeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D807223384;
        Wed, 23 Dec 2020 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737600;
        bh=R/m2beTvS2RspLPupAIbroGGO6INkYe2wdw6bDODIZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPAOyfOlvOLpYrQ2jIxUvVKYWd6LCQKYeLVi8pRbT5UCqcp4woUrwaFeJpmrlEpGp
         e5IEqaUxdyZPhHYMSWfxKvAVVUlKKckobXO+wWSZjb5pWu3Ll0SvsUGhASgeCINLeb
         ehn9idN1WveIfzIptFB5LZXKlJMn5I4oMIzjj3uY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        kitestramuort <kitestramuort@autistici.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 24/40] f2fs: fix to seek incorrect data offset in inline data file
Date:   Wed, 23 Dec 2020 16:33:25 +0100
Message-Id: <20201223150516.715040953@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit 7a6e59d719ef0ec9b3d765cba3ba98ee585cbde3 upstream.

As kitestramuort reported:

F2FS-fs (nvme0n1p4): access invalid blkaddr:1598541474
[   25.725898] ------------[ cut here ]------------
[   25.725903] WARNING: CPU: 6 PID: 2018 at f2fs_is_valid_blkaddr+0x23a/0x250
[   25.725923] Call Trace:
[   25.725927]  ? f2fs_llseek+0x204/0x620
[   25.725929]  ? ovl_copy_up_data+0x14f/0x200
[   25.725931]  ? ovl_copy_up_inode+0x174/0x1e0
[   25.725933]  ? ovl_copy_up_one+0xa22/0xdf0
[   25.725936]  ? ovl_copy_up_flags+0xa6/0xf0
[   25.725938]  ? ovl_aio_cleanup_handler+0xd0/0xd0
[   25.725939]  ? ovl_maybe_copy_up+0x86/0xa0
[   25.725941]  ? ovl_open+0x22/0x80
[   25.725943]  ? do_dentry_open+0x136/0x350
[   25.725945]  ? path_openat+0xb7e/0xf40
[   25.725947]  ? __check_sticky+0x40/0x40
[   25.725948]  ? do_filp_open+0x70/0x100
[   25.725950]  ? __check_sticky+0x40/0x40
[   25.725951]  ? __check_sticky+0x40/0x40
[   25.725953]  ? __x64_sys_openat+0x1db/0x2c0
[   25.725955]  ? do_syscall_64+0x2d/0x40
[   25.725957]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

llseek() reports invalid block address access, the root cause is if
file has inline data, f2fs_seek_block() will access inline data regard
as block address index in inode block, which should be wrong, fix it.

Reported-by: kitestramuort <kitestramuort@autistici.org>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/file.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -412,9 +412,14 @@ static loff_t f2fs_seek_block(struct fil
 		goto fail;
 
 	/* handle inline data case */
-	if (f2fs_has_inline_data(inode) && whence == SEEK_HOLE) {
-		data_ofs = isize;
-		goto found;
+	if (f2fs_has_inline_data(inode)) {
+		if (whence == SEEK_HOLE) {
+			data_ofs = isize;
+			goto found;
+		} else if (whence == SEEK_DATA) {
+			data_ofs = offset;
+			goto found;
+		}
 	}
 
 	pgofs = (pgoff_t)(offset >> PAGE_SHIFT);


