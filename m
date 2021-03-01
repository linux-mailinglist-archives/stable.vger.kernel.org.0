Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076D4328391
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhCAQV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237739AbhCAQTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:19:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A518464EDE;
        Mon,  1 Mar 2021 16:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615467;
        bh=3gw/aUdt7iJWovuAIdHc1iNkCndxBO6Jk1QbTfB83MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0MuPnaT/IsxrzyM8KEFYYul1LShzsQ/+//I5EuSNPiG/uziDyKdCc33oXpRS2Qc2
         UpeUw1GOv9cxxx5dwv3OpIK4/HkNayHHKQVxrnn5zCVbFGwBIeE2V8Syhlx8ByElUu
         wZt/J7xQqRIf52T8PB0IEELUzB2NHoOdGkLMPjm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 40/93] isofs: release buffer head before return
Date:   Mon,  1 Mar 2021 17:12:52 +0100
Message-Id: <20210301161008.880790919@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
index b943cbd963bb9..2e7d74c7beed8 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -151,6 +151,7 @@ static int do_isofs_readdir(struct inode *inode, struct file *file,
 			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
 			       " in block %lu of inode %lu\n", block,
 			       inode->i_ino);
+			brelse(bh);
 			return -EIO;
 		}
 
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index 7b543e6b6526d..696f255d15325 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -101,6 +101,7 @@ isofs_find_entry(struct inode *dir, struct dentry *dentry,
 			printk(KERN_NOTICE "iso9660: Corrupted directory entry"
 			       " in block %lu of inode %lu\n", block,
 			       dir->i_ino);
+			brelse(bh);
 			return 0;
 		}
 
-- 
2.27.0



