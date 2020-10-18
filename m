Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F58291A14
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgJRTV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729343AbgJRTV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3288222E9;
        Sun, 18 Oct 2020 19:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048886;
        bh=My1jZhxrhaIwPxyYadbJWkFqJCp8iFABq5AI9LDc2wU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccE50y5k5xoKMhmB3kaIU6doW3AWUSKV7LM7Ll2P44q8/THFf9De4GrMU2ca6jl3V
         K+jWHMnO8glc50MVc9OmmmMNkB4UhjNH09iKpfkAcxt9rNmiDpI8cl31t27GBv234i
         +/O44akUkgAmpnDkKttOsmwEqYdcLdLTmn95oORs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>,
        syzbot+91f02b28f9bb5f5f1341@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 049/101] udf: Avoid accessing uninitialized data on failed inode read
Date:   Sun, 18 Oct 2020 15:19:34 -0400
Message-Id: <20201018192026.4053674-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 044e2e26f214e5ab26af85faffd8d1e4ec066931 ]

When we fail to read inode, some data accessed in udf_evict_inode() may
be uninitialized. Move the accesses to !is_bad_inode() branch.

Reported-by: syzbot+91f02b28f9bb5f5f1341@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index adaba8e8b326e..566118417e562 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -139,21 +139,24 @@ void udf_evict_inode(struct inode *inode)
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	int want_delete = 0;
 
-	if (!inode->i_nlink && !is_bad_inode(inode)) {
-		want_delete = 1;
-		udf_setsize(inode, 0);
-		udf_update_inode(inode, IS_SYNC(inode));
+	if (!is_bad_inode(inode)) {
+		if (!inode->i_nlink) {
+			want_delete = 1;
+			udf_setsize(inode, 0);
+			udf_update_inode(inode, IS_SYNC(inode));
+		}
+		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
+		    inode->i_size != iinfo->i_lenExtents) {
+			udf_warn(inode->i_sb,
+				 "Inode %lu (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
+				 inode->i_ino, inode->i_mode,
+				 (unsigned long long)inode->i_size,
+				 (unsigned long long)iinfo->i_lenExtents);
+		}
 	}
 	truncate_inode_pages_final(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
-	    inode->i_size != iinfo->i_lenExtents) {
-		udf_warn(inode->i_sb, "Inode %lu (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
-			 inode->i_ino, inode->i_mode,
-			 (unsigned long long)inode->i_size,
-			 (unsigned long long)iinfo->i_lenExtents);
-	}
 	kfree(iinfo->i_ext.i_data);
 	iinfo->i_ext.i_data = NULL;
 	udf_clear_extent_cache(inode);
-- 
2.25.1

