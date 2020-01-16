Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5A313FDEC
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404156AbgAPXal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:30:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391366AbgAPXaG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:30:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 075F52072E;
        Thu, 16 Jan 2020 23:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217405;
        bh=aO7qYF9fBvj0Ws7iK4BpxtcIgvZOMDtzdIeVgfd0YsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wq5MFaXbrn45nq/4sKRHqL8y8NCCvcWDWu2xd4r9p3IvCvqymQ7uotCznSP+RgGjD
         beUtPWZB/bg/u9BmEyP7qHM5SeMjTPNHGa4UiHVAoGoFG9PMu0RtPI9hVVO9EWv8DF
         T1oo873aC5FkeZFiywukxiQWf/B2aNabUHdij1M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.19 70/84] f2fs: fix potential overflow
Date:   Fri, 17 Jan 2020 00:18:44 +0100
Message-Id: <20200116231721.809019996@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
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
@@ -1857,7 +1857,7 @@ static int __write_data_page(struct page
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
@@ -1101,7 +1101,7 @@ static int __clone_blkaddrs(struct inode
 				}
 				dn.ofs_in_node++;
 				i++;
-				new_size = (dst + i) << PAGE_SHIFT;
+				new_size = (loff_t)(dst + i) << PAGE_SHIFT;
 				if (dst_inode->i_size < new_size)
 					f2fs_i_size_write(dst_inode, new_size);
 			} while (--ilen && (do_replace[i] || blkaddr[i] == NULL_ADDR));


