Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512C71A9F4D
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441281AbgDOMIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:08:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897595AbgDOLrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:47:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E4EE21569;
        Wed, 15 Apr 2020 11:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951224;
        bh=h1ql2/BDJX9O8+6Tedw2yO7TNwFdReVLH5QvEUZ2310=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PvqCh1ALw6238zhOwyEbCVhBsKj3K2Sq1+UOQLf2LVUuy0+J56gubP6lrRs3DtR4z
         4/cR8ALX4JH521MHXZbDSICwj+4DjQe+/zE2rvtAoVKQftC0hy69vdXQMXNyuaxc9k
         mF439K2j4xE43Ix+7wUkJx9bc8JQHO5HxO6BhhqI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 35/40] ovl: fix value of i_ino for lower hardlink corner case
Date:   Wed, 15 Apr 2020 07:46:18 -0400
Message-Id: <20200415114623.14972-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114623.14972-1-sashal@kernel.org>
References: <20200415114623.14972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 300b124fcf6ad2cd99a7b721e0f096785e0a3134 ]

Commit 6dde1e42f497 ("ovl: make i_ino consistent with st_ino in more
cases"), relaxed the condition nfs_export=on in order to set the value of
i_ino to xino map of real ino.

Specifically, it also relaxed the pre-condition that index=on for
consistent i_ino. This opened the corner case of lower hardlink in
ovl_get_inode(), which calls ovl_fill_inode() with ino=0 and then
ovl_init_inode() is called to set i_ino to lower real ino without the xino
mapping.

Pass the correct values of ino;fsid in this case to ovl_fill_inode(), so it
can initialize i_ino correctly.

Fixes: 6dde1e42f497 ("ovl: make i_ino consistent with st_ino in more ...")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a138bb3bc2a5d..8b3c284ce92ea 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -884,7 +884,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
 					oip->index);
-	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
+	int fsid = bylower ? lowerpath->layer->fsid : 0;
 	bool is_dir, metacopy = false;
 	unsigned long ino = 0;
 	int err = oip->newinode ? -EEXIST : -ENOMEM;
@@ -934,6 +934,8 @@ struct inode *ovl_get_inode(struct super_block *sb,
 			err = -ENOMEM;
 			goto out_err;
 		}
+		ino = realinode->i_ino;
+		fsid = lowerpath->layer->fsid;
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
 	ovl_inode_init(inode, upperdentry, lowerdentry, oip->lowerdata);
-- 
2.20.1

