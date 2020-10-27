Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AB229C594
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753568AbgJ0OB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753678AbgJ0OB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:01:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA4C6221F8;
        Tue, 27 Oct 2020 14:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807286;
        bh=rlLzz3Jh8H+CytRmdH/a8fvAOVgqamMizoyS7i1vZm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEYpibT5QnhN+SoyB+PGQp1wR2iDXJiPiS6jKvBfYON98zD9Yc2dGNVweXwtoEx5g
         SDxAKVJw3ds6Cx5b2zSLyVnVXey2Gi2T52bcJFB/2Z1mPjIH2lD1UUWpShd9mAVj6h
         5iEmITCfi+PC9FL8b8aBtjrdvwzdhGgRXRlqQDqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+91f02b28f9bb5f5f1341@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 093/112] udf: Avoid accessing uninitialized data on failed inode read
Date:   Tue, 27 Oct 2020 14:50:03 +0100
Message-Id: <20201027134904.948048940@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
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
index 3876448ec0dcb..2c39c1c81196c 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -140,21 +140,24 @@ void udf_evict_inode(struct inode *inode)
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



