Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F1E28C057
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 21:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390858AbgJLTD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 15:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390065AbgJLTDJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 943C12073A;
        Mon, 12 Oct 2020 19:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529388;
        bh=KyFwZq91g0c69Vtm1zs1HoCWvTLdAGjQ987vXshT4rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOaIM8kuiYRRtVKh+yZFV16ckGXnJbepaSp/mRVRG9gM/3grfBLQFuaV6tXptazwL
         oAkHEiadVJJbXe4OMT7w+FtU3OyLLeAjPcuhjNjG5vWQ+UOyZcvagVFP10qhPHjE0N
         GWPxKOu3Ugb9psa3iVN+2NdOXSvfdbIzmErDgK6w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuhiro Kohada <kohada.t2@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 22/24] exfat: fix pointer error checking
Date:   Mon, 12 Oct 2020 15:02:37 -0400
Message-Id: <20201012190239.3279198-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuhiro Kohada <kohada.t2@gmail.com>

[ Upstream commit d6c9efd92443b23307995f34246c2374056ebbd8 ]

Fix missing result check of exfat_build_inode().
And use PTR_ERR_OR_ZERO instead of PTR_ERR.

Signed-off-by: Tetsuhiro Kohada <kohada.t2@gmail.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 2b9e21094a96d..4b53a3efd6d46 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -578,7 +578,8 @@ static int exfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	i_pos = exfat_make_i_pos(&info);
 	inode = exfat_build_inode(sb, &info, i_pos);
-	if (IS_ERR(inode))
+	err = PTR_ERR_OR_ZERO(inode);
+	if (err)
 		goto unlock;
 
 	inode_inc_iversion(inode);
@@ -745,10 +746,9 @@ static struct dentry *exfat_lookup(struct inode *dir, struct dentry *dentry,
 
 	i_pos = exfat_make_i_pos(&info);
 	inode = exfat_build_inode(sb, &info, i_pos);
-	if (IS_ERR(inode)) {
-		err = PTR_ERR(inode);
+	err = PTR_ERR_OR_ZERO(inode);
+	if (err)
 		goto unlock;
-	}
 
 	i_mode = inode->i_mode;
 	alias = d_find_alias(inode);
@@ -890,10 +890,9 @@ static int exfat_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 	i_pos = exfat_make_i_pos(&info);
 	inode = exfat_build_inode(sb, &info, i_pos);
-	if (IS_ERR(inode)) {
-		err = PTR_ERR(inode);
+	err = PTR_ERR_OR_ZERO(inode);
+	if (err)
 		goto unlock;
-	}
 
 	inode_inc_iversion(inode);
 	inode->i_mtime = inode->i_atime = inode->i_ctime =
-- 
2.25.1

