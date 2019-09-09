Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA829AE0E6
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 00:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388446AbfIIWRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 18:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392067AbfIIWRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 18:17:08 -0400
Received: from sasha-vm.mshome.net (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 608E421D7B;
        Mon,  9 Sep 2019 22:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568067427;
        bh=MxqU5SPmj5mtY7IY3nIDrBdvk0zA/H/zTaOVX7PF5Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wfnm9pPKQvR9mKS8OFlTMVOrHvKCCTCwfIS3kU9M/q3epBV4zWqaEybcevKPBwXtv
         C30t2JEhpAnqt4lLrDHWPJPAfg7hdg/SaohpQ4Ol054v5dpDP7Xiv04g6JbyUmOcDb
         2d7fDY79STxd8pR5kVZPjjM0KM6JZitfhPqK08hc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 5/8] configfs_register_group() shouldn't be (and isn't) called in rmdirable parts
Date:   Mon,  9 Sep 2019 11:41:42 -0400
Message-Id: <20190909154145.31263-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909154145.31263-1-sashal@kernel.org>
References: <20190909154145.31263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit f19e4ed1e1edbfa3c9ccb9fed17759b7d6db24c6 ]

revert cc57c07343bd "configfs: fix registered group removal"
It was an attempt to handle something that fundamentally doesn't
work - configfs_register_group() should never be done in a part
of tree that can be rmdir'ed.  And in mainline it never had been,
so let's not borrow trouble; the fix was racy anyway, it would take
a lot more to make that work and desired semantics is not clear.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index a1985a9ad2d64..64fdb12e6ad61 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1782,16 +1782,6 @@ void configfs_unregister_group(struct config_group *group)
 	struct dentry *dentry = group->cg_item.ci_dentry;
 	struct dentry *parent = group->cg_item.ci_parent->ci_dentry;
 
-	mutex_lock(&subsys->su_mutex);
-	if (!group->cg_item.ci_parent->ci_group) {
-		/*
-		 * The parent has already been unlinked and detached
-		 * due to a rmdir.
-		 */
-		goto unlink_group;
-	}
-	mutex_unlock(&subsys->su_mutex);
-
 	inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
 	spin_lock(&configfs_dirent_lock);
 	configfs_detach_prep(dentry, NULL);
@@ -1806,7 +1796,6 @@ void configfs_unregister_group(struct config_group *group)
 	dput(dentry);
 
 	mutex_lock(&subsys->su_mutex);
-unlink_group:
 	unlink_group(group);
 	mutex_unlock(&subsys->su_mutex);
 }
-- 
2.20.1

