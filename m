Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2839F344453
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhCVM7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233094AbhCVM5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:57:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AF96619BD;
        Mon, 22 Mar 2021 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417356;
        bh=cTZ4pKqI4MOnC74+1p5ARE2mS0vr8FtJauf9yIXiEmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIF/nQnSVQcvHftJS9haZzEsXWh6l/9HUTSJoZ/UBxV/i0MyqyntSwaSW1+aJAnbF
         GRsjzbZx6WtUeo3+DtkOyCFkDaLxhGL4j3EQ9gcC4CVtbUOb4608Dj9EeJjFII4him
         u3nGIkNCum2V2zC041iqFpHqSngZXOkykJlzTZLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+98b881fdd8ebf45ab4ae@syzkaller.appspotmail.com,
        stable@kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 41/43] ext4: do not try to set xattr into ea_inode if value is empty
Date:   Mon, 22 Mar 2021 13:29:22 +0100
Message-Id: <20210322121921.355615556@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

commit 6b22489911b726eebbf169caee52fea52013fbdd upstream.

Syzbot report a warning that ext4 may create an empty ea_inode if set
an empty extent attribute to a file on the file system which is no free
blocks left.

  WARNING: CPU: 6 PID: 10667 at fs/ext4/xattr.c:1640 ext4_xattr_set_entry+0x10f8/0x1114 fs/ext4/xattr.c:1640
  ...
  Call trace:
   ext4_xattr_set_entry+0x10f8/0x1114 fs/ext4/xattr.c:1640
   ext4_xattr_block_set+0x1d0/0x1b1c fs/ext4/xattr.c:1942
   ext4_xattr_set_handle+0x8a0/0xf1c fs/ext4/xattr.c:2390
   ext4_xattr_set+0x120/0x1f0 fs/ext4/xattr.c:2491
   ext4_xattr_trusted_set+0x48/0x5c fs/ext4/xattr_trusted.c:37
   __vfs_setxattr+0x208/0x23c fs/xattr.c:177
  ...

Now, ext4 try to store extent attribute into an external inode if
ext4_xattr_block_set() return -ENOSPC, but for the case of store an
empty extent attribute, store the extent entry into the extent
attribute block is enough. A simple reproduce below.

  fallocate test.img -l 1M
  mkfs.ext4 -F -b 2048 -O ea_inode test.img
  mount test.img /mnt
  dd if=/dev/zero of=/mnt/foo bs=2048 count=500
  setfattr -n "user.test" /mnt/foo

Reported-by: syzbot+98b881fdd8ebf45ab4ae@syzkaller.appspotmail.com
Fixes: 9c6e7853c531 ("ext4: reserve space for xattr entries/names")
Cc: stable@kernel.org
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20210305120508.298465-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2418,7 +2418,7 @@ retry_inode:
 				 * external inode if possible.
 				 */
 				if (ext4_has_feature_ea_inode(inode->i_sb) &&
-				    !i.in_inode) {
+				    i.value_len && !i.in_inode) {
 					i.in_inode = 1;
 					goto retry_inode;
 				}


