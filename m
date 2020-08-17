Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090962474F8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbgHQPiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730590AbgHQPiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:38:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A22D208E4;
        Mon, 17 Aug 2020 15:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678701;
        bh=pfviu27H9hD2OYEl1DDN8ZQ7SZqNjtL9YSu3pGx/A6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjrqfWEZLe/yk0+QgipK6FrIy2tax7WY4Qut3UzPyGLwVVfjwng1bphuncp0RZBvB
         IO3GabpgiaQb6Umohe1w7/BrhH2z6oXS8c6SkI0aKgizJ/qq8JPxqF50wteS23U0EG
         WyajWUAF+P7/mWNnd3DYYKQsyJMRPPnujWpFSR58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a9ac3de1b5de5fb10efc@syzkaller.appspotmail.com,
        syzbot+df958cf5688a96ad3287@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Qiujun Huang <anenbupt@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 417/464] fs/minix: dont allow getting deleted inodes
Date:   Mon, 17 Aug 2020 17:16:10 +0200
Message-Id: <20200817143853.753734174@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit facb03dddec04e4aac1bb2139accdceb04deb1f3 upstream.

If an inode has no links, we need to mark it bad rather than allowing it
to be accessed.  This avoids WARNINGs in inc_nlink() and drop_nlink() when
doing directory operations on a fuzzed filesystem.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+a9ac3de1b5de5fb10efc@syzkaller.appspotmail.com
Reported-by: syzbot+df958cf5688a96ad3287@syzkaller.appspotmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qiujun Huang <anenbupt@gmail.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200628060846.682158-3-ebiggers@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/minix/inode.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
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


