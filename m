Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6D035BD7E
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbhDLIv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238460AbhDLItz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF7A061220;
        Mon, 12 Apr 2021 08:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217341;
        bh=eCT4XfdWQT7cD/mHkwI4t5VeBUC8QrmNaP8hpcHFXvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDw4+En5mM08/yGIITEVGT9GB5mASYqSahjEAW5w9Ln/fvg5S08vDD+X7TryuJU1d
         OyqOZmBKoE3IxkF3PBAReRxLvbX6tG6/+cDJrwAtgg8Kiye68tjYLwdVolDLS19L8a
         m7XfdDNRl2/L11dGkNMypJ0EAn/mdUscKR2At2Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/111] hostfs: Use kasprintf() instead of fixed buffer formatting
Date:   Mon, 12 Apr 2021 10:40:33 +0200
Message-Id: <20210412084006.093780735@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit b58c4e96192ee7c47d5c67853b1557306cfa0e7f ]

Improve readability and maintainability by replacing a hardcoded string
allocation and formatting by the use of the kasprintf() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hostfs/hostfs_kern.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 5a7eb0c79839..4f5d857f6ecb 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -139,8 +139,8 @@ static char *inode_name(struct inode *ino)
 
 static char *follow_link(char *link)
 {
-	int len, n;
 	char *name, *resolved, *end;
+	int n;
 
 	name = __getname();
 	if (!name) {
@@ -164,15 +164,13 @@ static char *follow_link(char *link)
 		return name;
 
 	*(end + 1) = '\0';
-	len = strlen(link) + strlen(name) + 1;
 
-	resolved = kmalloc(len, GFP_KERNEL);
+	resolved = kasprintf(GFP_KERNEL, "%s%s", link, name);
 	if (resolved == NULL) {
 		n = -ENOMEM;
 		goto out_free;
 	}
 
-	sprintf(resolved, "%s%s", link, name);
 	__putname(name);
 	kfree(link);
 	return resolved;
@@ -918,18 +916,16 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 	sb->s_d_op = &simple_dentry_operations;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 
-	/* NULL is printed as <NULL> by sprintf: avoid that. */
+	/* NULL is printed as '(null)' by printf(): avoid that. */
 	if (req_root == NULL)
 		req_root = "";
 
 	err = -ENOMEM;
 	sb->s_fs_info = host_root_path =
-		kmalloc(strlen(root_ino) + strlen(req_root) + 2, GFP_KERNEL);
+		kasprintf(GFP_KERNEL, "%s/%s", root_ino, req_root);
 	if (host_root_path == NULL)
 		goto out;
 
-	sprintf(host_root_path, "%s/%s", root_ino, req_root);
-
 	root_inode = new_inode(sb);
 	if (!root_inode)
 		goto out;
-- 
2.30.2



