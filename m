Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AFF38A0D3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhETJ0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231602AbhETJ0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF2BF6121E;
        Thu, 20 May 2021 09:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502691;
        bh=SWOh5zPaInouRtpsUUTvjV31cyhlFujmn+hBDt84PjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+mazN6HaYBFIQI1ZJ2O6EIIK5C3q5uQuSasVyQV1ay4wVbHASrohww7ub88fO4QC
         1TiD9jC/po76O64wBtBHlM3YJK4iTJsoYeU+A0ae/B9zj4lQC9+zsKs2HEjarvGD6n
         lqQgUWzH1YM+XJ8kMfWGcV7TzHLRgOvLqXiPdqeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Ge Qiu <qiuge@huawei.com>, Dehe Gu <gudehe@huawei.com>,
        Yi Chen <chenyi77@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 16/45] f2fs: fix to avoid NULL pointer dereference
Date:   Thu, 20 May 2021 11:22:04 +0200
Message-Id: <20210520092054.052523304@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi Chen <chenyi77@huawei.com>

[ Upstream commit 594b6d0428ae304e0b44457398beb458b938f005 ]

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
pc : f2fs_put_page+0x1c/0x26c
lr : __revoke_inmem_pages+0x544/0x75c
f2fs_put_page+0x1c/0x26c
__revoke_inmem_pages+0x544/0x75c
__f2fs_commit_inmem_pages+0x364/0x3c0
f2fs_commit_inmem_pages+0xc8/0x1a0
f2fs_ioc_commit_atomic_write+0xa4/0x15c
f2fs_ioctl+0x5b0/0x1574
file_ioctl+0x154/0x320
do_vfs_ioctl+0x164/0x740
__arm64_sys_ioctl+0x78/0xa4
el0_svc_common+0xbc/0x1d0
el0_svc_handler+0x74/0x98
el0_svc+0x8/0xc

In f2fs_put_page, we access page->mapping is NULL.
The root cause is:
In some cases, the page refcount and ATOMIC_WRITTEN_PAGE
flag miss set for page-priavte flag has been set.
We add f2fs_bug_on like this:

f2fs_register_inmem_page()
{
	...
	f2fs_set_page_private(page, ATOMIC_WRITTEN_PAGE);

	f2fs_bug_on(F2FS_I_SB(inode), !IS_ATOMIC_WRITTEN_PAGE(page));
	...
}

The bug on stack follow link this:
PC is at f2fs_register_inmem_page+0x238/0x2b4
LR is at f2fs_register_inmem_page+0x2a8/0x2b4
f2fs_register_inmem_page+0x238/0x2b4
f2fs_set_data_page_dirty+0x104/0x164
set_page_dirty+0x78/0xc8
f2fs_write_end+0x1b4/0x444
generic_perform_write+0x144/0x1cc
__generic_file_write_iter+0xc4/0x174
f2fs_file_write_iter+0x2c0/0x350
__vfs_write+0x104/0x134
vfs_write+0xe8/0x19c
SyS_pwrite64+0x78/0xb8

To fix this issue, let's add page refcount add page-priavte flag.
The page-private flag is not cleared and needs further analysis.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Ge Qiu <qiuge@huawei.com>
Signed-off-by: Dehe Gu <gudehe@huawei.com>
Signed-off-by: Yi Chen <chenyi77@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 77456d228f2a..bb6d86255741 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -186,7 +186,10 @@ void f2fs_register_inmem_page(struct inode *inode, struct page *page)
 {
 	struct inmem_pages *new;
 
-	f2fs_set_page_private(page, ATOMIC_WRITTEN_PAGE);
+	if (PagePrivate(page))
+		set_page_private(page, (unsigned long)ATOMIC_WRITTEN_PAGE);
+	else
+		f2fs_set_page_private(page, ATOMIC_WRITTEN_PAGE);
 
 	new = f2fs_kmem_cache_alloc(inmem_entry_slab, GFP_NOFS);
 
-- 
2.30.2



