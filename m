Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6917D20C663
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 08:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgF1GKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 02:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgF1GKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jun 2020 02:10:35 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8CF22071A;
        Sun, 28 Jun 2020 06:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593324635;
        bh=4KTwlwAS3yf9rIisW3dStoZMc/64VWd7yIvASpVgF40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tys1hkuGTt37lRSXE/p9UQUesp1Q878EE0/Bh+8Rr1uBrMOLeeQuoHS07uJ9+Xejn
         wYzY1rOxJEaJkR0jPswIE1d2ygau1oCcvrZmR+CFkKwaAVtvmmpffNjjxCM98vYE4/
         BmDoz86MXWDaSEKqc70KxAswCR9MLwvR4r7SRS2g=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        stable@vger.kernel.org,
        syzbot+a9ac3de1b5de5fb10efc@syzkaller.appspotmail.com,
        syzbot+df958cf5688a96ad3287@syzkaller.appspotmail.com
Subject: [PATCH 2/6] fs/minix: don't allow getting deleted inodes
Date:   Sat, 27 Jun 2020 23:08:41 -0700
Message-Id: <20200628060846.682158-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628060846.682158-1-ebiggers@kernel.org>
References: <20200628060846.682158-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

If an inode has no links, we need to mark it bad rather than allowing it
to be accessed.  This avoids WARNINGs in inc_nlink() and drop_nlink()
when doing directory operations on a fuzzed filesystem.

Reported-by: syzbot+a9ac3de1b5de5fb10efc@syzkaller.appspotmail.com
Reported-by: syzbot+df958cf5688a96ad3287@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/minix/inode.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 7cb5fd38eb14..2bca95abe8f4 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -468,6 +468,13 @@ static struct inode *V1_minix_iget(struct inode *inode)
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
@@ -501,6 +508,13 @@ static struct inode *V2_minix_iget(struct inode *inode)
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
-- 
2.27.0

