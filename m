Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869453288A0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238657AbhCARnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234701AbhCARfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:35:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2858650B0;
        Mon,  1 Mar 2021 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617683;
        bh=1vjf1GnEQvKDh9+CljdWgBAV7koWt9PVFb4eKHyN8Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eR+THfk4/ZsOhOsIuSHinDTKVOS4i3o5ivZN26MSURd5iL64BGzbCGK8g3vh2Tv+f
         Xu//rB/cQrPn+zFBJKAse5vbU84AV3FFOypzQMh1C1u9q/5GJe1611KNkdgg/1W4ko
         pULtYzc34pCIRxnL5MN8SujbC5CTzlUg/7bOQLXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 158/340] isofs: release buffer head before return
Date:   Mon,  1 Mar 2021 17:11:42 +0100
Message-Id: <20210301161056.091673223@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index cac468f04820e..558e7c51ce0d4 100644
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



