Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E14615E911
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392596AbgBNREe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391683AbgBNQP3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 490BD246DC;
        Fri, 14 Feb 2020 16:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696929;
        bh=2D+nHV/qWbnw3vJE7DODLZI9JPpNMJQPog1FXaKPbDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRrUgwwWiDVNfo+wefxWc0y4pxPytsJ/hf44wXTQ93And4cbPLDbehPVgIJ1Ce9B1
         B6r6OlqGd6PhrLnnR1qufVK3nVhuClZlk/6SJVJcJXZqrXe+c3s27qd+2jYA7OxWzD
         A33m8LDkAqukrjTqqPQoH/gXgdeZdolYOprgJ9iY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 175/252] NFS: Revalidate the file size on a fatal write error
Date:   Fri, 14 Feb 2020 11:10:30 -0500
Message-Id: <20200214161147.15842-175-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 0df68ced55443243951d02cc497be31fadf28173 ]

If we suffer a fatal error upon writing a file, which causes us to
need to revalidate the entire mapping, then we should also revalidate
the file size.

Fixes: d2ceb7e57086 ("NFS: Don't use page_file_mapping after removing the page")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index e27637fa0f790..e8152781814dd 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -240,7 +240,15 @@ static void nfs_grow_file(struct page *page, unsigned int offset, unsigned int c
 /* A writeback failed: mark the page as bad, and invalidate the page cache */
 static void nfs_set_pageerror(struct address_space *mapping)
 {
+	struct inode *inode = mapping->host;
+
 	nfs_zap_mapping(mapping->host, mapping);
+	/* Force file size revalidation */
+	spin_lock(&inode->i_lock);
+	NFS_I(inode)->cache_validity |= NFS_INO_REVAL_FORCED |
+					NFS_INO_REVAL_PAGECACHE |
+					NFS_INO_INVALID_SIZE;
+	spin_unlock(&inode->i_lock);
 }
 
 /*
-- 
2.20.1

