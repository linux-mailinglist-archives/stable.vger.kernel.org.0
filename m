Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B8D2E379C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgL1M6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:58:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729045AbgL1M6K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:58:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F5BA207C9;
        Mon, 28 Dec 2020 12:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160250;
        bh=4QAC7qeL+YoC1ltwe3fWxolyc+FRKOcUV33qt+FjxCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cysb+AbdLqIH5SYO6bmcYtl4lcOrG/fe6sDrKMjHDKreFqKwWnBtuUfvB5TkV/1G6
         2hDH+iUodiXh3bWpJrCHKSEsAyAl8A69t1Kq8GPD/rg3AfgFSUQHwVLPbuMBDuLO+0
         r+y6TKM0JuKwHBf0iIIwSrQJo49ogJvrPqzCo/0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        "Pavel Machek (CIP)" <pavel@denx.de>,
        David Sterba <dsterba@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 118/132] btrfs: fix return value mixup in btrfs_get_extent
Date:   Mon, 28 Dec 2020 13:50:02 +0100
Message-Id: <20201228124852.113626392@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek <pavel@denx.de>

commit 881a3a11c2b858fe9b69ef79ac5ee9978a266dc9 upstream

btrfs_get_extent() sets variable ret, but out: error path expect error
to be in variable err so the error code is lost.

Fixes: 6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6923,7 +6923,7 @@ again:
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		/* Only regular file could have regular/prealloc extent */
 		if (!S_ISREG(inode->i_mode)) {
-			ret = -EUCLEAN;
+			err = -EUCLEAN;
 			btrfs_crit(root->fs_info,
 		"regular/prealloc extent found for non-regular inode %llu",
 				   btrfs_ino(inode));


