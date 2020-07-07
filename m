Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C2D2177E3
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 21:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgGGTZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 15:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbgGGTZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 15:25:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C987F206E9;
        Tue,  7 Jul 2020 19:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594149924;
        bh=bTBNoRYBuCFKnzAjlSX5BmR0J/AUl5+N4MJbQ9y2U7A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dxlU8N90Am1S5BTjDJPZBhauzNm1QWQzZ9j9hAq/fuxF0ykM1vV5STKT8cycn1CbW
         wdZU0vVvqfB3MGu+gOtTyqnzhiwiiol1LRkFRlgliit/zwh8x98PRmA6kT43t+W6oZ
         VL2pLKysEpfsjKFodNsdIy1S+kK6XeZQrl2zKYD8=
Date:   Tue, 07 Jul 2020 12:25:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     anenbupt@gmail.com, ebiggers@google.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  + fs-minix-dont-allow-getting-deleted-inodes.patch added
 to -mm tree
Message-ID: <20200707192523.vcoGxzMBy%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/minix: don't allow getting deleted inodes
has been added to the -mm tree.  Its filename is
     fs-minix-dont-allow-getting-deleted-inodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-minix-dont-allow-getting-deleted-inodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-minix-dont-allow-getting-deleted-inodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: fs/minix: don't allow getting deleted inodes

If an inode has no links, we need to mark it bad rather than allowing it
to be accessed.  This avoids WARNINGs in inc_nlink() and drop_nlink() when
doing directory operations on a fuzzed filesystem.

Link: http://lkml.kernel.org/r/20200628060846.682158-3-ebiggers@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+a9ac3de1b5de5fb10efc@syzkaller.appspotmail.com
Reported-by: syzbot+df958cf5688a96ad3287@syzkaller.appspotmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qiujun Huang <anenbupt@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/minix/inode.c~fs-minix-dont-allow-getting-deleted-inodes
+++ a/fs/minix/inode.c
@@ -468,6 +468,13 @@ static struct inode *V1_minix_iget(struc
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
 	}
+	if (raw_inode->i_nlinks == 0) {
+		printk("MINIX-fs: deleted inode referenced: %lu\n",
+		       inode->i_ino);
+		brelse(bh);
+		iget_failed(inode);
+		return ERR_PTR(-ESTALE);
+	}
 	inode->i_mode = raw_inode->i_mode;
 	i_uid_write(inode, raw_inode->i_uid);
 	i_gid_write(inode, raw_inode->i_gid);
@@ -501,6 +508,13 @@ static struct inode *V2_minix_iget(struc
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
 	}
+	if (raw_inode->i_nlinks == 0) {
+		printk("MINIX-fs: deleted inode referenced: %lu\n",
+		       inode->i_ino);
+		brelse(bh);
+		iget_failed(inode);
+		return ERR_PTR(-ESTALE);
+	}
 	inode->i_mode = raw_inode->i_mode;
 	i_uid_write(inode, raw_inode->i_uid);
 	i_gid_write(inode, raw_inode->i_gid);
_

Patches currently in -mm which might be from ebiggers@google.com are

fs-minix-check-return-value-of-sb_getblk.patch
fs-minix-dont-allow-getting-deleted-inodes.patch
fs-minix-reject-too-large-maximum-file-size.patch
fs-minix-set-s_maxbytes-correctly.patch
fs-minix-fix-block-limit-check-for-v1-filesystems.patch
fs-minix-remove-expected-error-message-in-block_to_path.patch

