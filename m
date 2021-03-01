Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4129D328D21
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbhCATGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:06:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240918AbhCAS6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:58:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D39DA65080;
        Mon,  1 Mar 2021 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621050;
        bh=WoD5ce5uh/pym10JLGNNgMoW+LvIveEE/HyLPg4+iB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bS9OoAgnr0P9/VPSEDUjNOm0irhAF7Dq5VvfVZyNpqLufyl0qzPSLyYjlKYgkOEyo
         TqOc8uHHFxqNWYvICmMFF2UFYm98N3PibiVQoANHpyTq3cfmYDNT8w6laIZQqQxyuq
         lY+dS6deYjvRao9YLUG4n/3ARRK7r8+U9GT/63QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 376/775] isofs: release buffer head before return
Date:   Mon,  1 Mar 2021 17:09:04 +0100
Message-Id: <20210301161220.178524840@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 0a6dc67a6aa45f19bd4ff89b4f468fc50c4b8daa ]

Release the buffer_head before returning error code in
do_isofs_readdir() and isofs_find_entry().

Fixes: 2deb1acc653c ("isofs: fix access to unallocated memory when reading corrupted filesystem")
Link: https://lore.kernel.org/r/20210118120455.118955-1-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/dir.c   | 1 +
 fs/isofs/namei.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index f0fe641893a5e..b9e6a7ec78be4 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -152,6 +152,7 @@ static int do_isofs_readdir(struct inode *inode, struct file *file,
 			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
 			       " in block %lu of inode %lu\n", block,
 			       inode->i_ino);
+			brelse(bh);
 			return -EIO;
 		}
 
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index 402769881c32b..58f80e1b3ac0d 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -102,6 +102,7 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
 			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
 			       " in block %lu of inode %lu\n", block,
 			       dir->i_ino);
+			brelse(bh);
 			return 0;
 		}
 
-- 
2.27.0



