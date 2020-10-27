Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ADB29BA1F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368903AbgJ0P4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802645AbgJ0Pul (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:50:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 419F92065C;
        Tue, 27 Oct 2020 15:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813838;
        bh=My1jZhxrhaIwPxyYadbJWkFqJCp8iFABq5AI9LDc2wU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cG6e5JTizHwC2EOxuCFd8tiiELRQaylvFGXxdXXTePj8G/IKv0VHMo6b0VPOcQ/GH
         FKSu715g6tC5B4uAX+hzqt9y8UTvWEPrgyRsCtZFTj30+VhTJix1yUbTSbmXTAVT2W
         5sjEo9D006ru3dMglm8WdSi+Q6sdwGQqEW/jYPgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+91f02b28f9bb5f5f1341@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 688/757] udf: Avoid accessing uninitialized data on failed inode read
Date:   Tue, 27 Oct 2020 14:55:38 +0100
Message-Id: <20201027135522.802116802@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



