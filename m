Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE49E13FF69
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388562AbgAPX0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:26:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388576AbgAPX0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 811182073A;
        Thu, 16 Jan 2020 23:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217171;
        bh=SQLaG+Rhvxl7OCgsAARRdSQ0xmHBXEP/Q3RysXc5wEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwRQBHX7SP+LR/DX0HWFoZLieAuaLChYrWfd7SeLs6bXhFxnWa+GdrEWK67bjKh4L
         tp003UaiIUTYq37ybNqoaga/gQWPg0nt/YYcSD2JH08HLzpJ/J5j0m4qL9VEyowa3N
         6mAAInqlV33mnNhLPPuIU6XV5ZucG7Gcvkvrfr+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.4 176/203] f2fs: fix potential overflow
Date:   Fri, 17 Jan 2020 00:18:13 +0100
Message-Id: <20200116231759.851132096@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
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
@@ -2098,7 +2098,7 @@ static int __write_data_page(struct page
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
@@ -1139,7 +1139,7 @@ static int __clone_blkaddrs(struct inode
 				}
 				dn.ofs_in_node++;
 				i++;
-				new_size = (dst + i) << PAGE_SHIFT;
+				new_size = (loff_t)(dst + i) << PAGE_SHIFT;
 				if (dst_inode->i_size < new_size)
 					f2fs_i_size_write(dst_inode, new_size);
 			} while (--ilen && (do_replace[i] || blkaddr[i] == NULL_ADDR));


