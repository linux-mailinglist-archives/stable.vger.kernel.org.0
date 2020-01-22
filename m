Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5430D144F21
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbgAVJe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:34:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729501AbgAVJez (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:34:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 868F624672;
        Wed, 22 Jan 2020 09:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685695;
        bh=VqYTQ/EVXNQCQEPMUf5UiPyaW8ywvEElTwnUB3IJ4oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MMO50b/Vvbbnxrjp2lu9G/iSaH5GubBd3LKZs4K8btgrDLqPr8NJZGpoIIcZLK8X
         /tHIk0grdxpJPQa77WBHm/DbYn1X5fMs0VlcCyee15ZdluVyqOrChsdIgVLIJBvkGQ
         2/Tvq2l9BLbDL5A/i9Fob7MsHtn9vp5ioTT5v0CA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.9 41/97] f2fs: fix potential overflow
Date:   Wed, 22 Jan 2020 10:28:45 +0100
Message-Id: <20200122092803.183124960@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit 1f0d5c911b64165c9754139a26c8c2fad352c132 upstream.

We expect 64-bit calculation result from below statement, however
in 32-bit machine, looped left shift operation on pgoff_t type
variable may cause overflow issue, fix it by forcing type cast.

page->index << PAGE_SHIFT;

Fixes: 26de9b117130 ("f2fs: avoid unnecessary updating inode during fsync")
Fixes: 0a2aa8fbb969 ("f2fs: refactor __exchange_data_block for speed up")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/data.c |    2 +-
 fs/f2fs/file.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1267,7 +1267,7 @@ static int f2fs_write_data_page(struct p
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = ((unsigned long long) i_size)
 							>> PAGE_SHIFT;
-	loff_t psize = (page->index + 1) << PAGE_SHIFT;
+	loff_t psize = (loff_t)(page->index + 1) << PAGE_SHIFT;
 	unsigned offset = 0;
 	bool need_balance_fs = false;
 	int err = 0;
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -980,7 +980,7 @@ static int __clone_blkaddrs(struct inode
 				}
 				dn.ofs_in_node++;
 				i++;
-				new_size = (dst + i) << PAGE_SHIFT;
+				new_size = (loff_t)(dst + i) << PAGE_SHIFT;
 				if (dst_inode->i_size < new_size)
 					f2fs_i_size_write(dst_inode, new_size);
 			} while (--ilen && (do_replace[i] || blkaddr[i] == NULL_ADDR));


