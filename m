Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1A21D845F
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733003AbgERSLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732806AbgERSEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25C6D2083E;
        Mon, 18 May 2020 18:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825075;
        bh=xutSc8A9hRxcqC+TgUIwPgptzdazbIwaCkmPOPmLn6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6KueulywNz+R1m9ffs+iCT7pRlCO9sgDl0+2+ezvA06uAVFiLufEqifkPttw1y+I
         4J4nX3mDiPa/YtfHuDona3kiRLtujxA31VrkRlleNFU1xsrBlC8Xmh6i4ArVmBM6fC
         baTsw4e/STIaTDthj/HutELKx1VMQ8pPpXlAHADU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Wysochanski <dwysocha@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 082/194] cachefiles: Fix corruption of the return value in cachefiles_read_or_alloc_pages()
Date:   Mon, 18 May 2020 19:36:12 +0200
Message-Id: <20200518173538.580068624@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit c5f9d9db83d9f84d2b4aae5a1b29d9b582ccff2f ]

The patch which changed cachefiles from calling ->bmap() to using the
bmap() wrapper overwrote the running return value with the result of
calling bmap().  This causes an assertion failure elsewhere in the code.

Fix this by using ret2 rather than ret to hold the return value.

The oops looks like:

	kernel BUG at fs/nfs/fscache.c:468!
	...
	RIP: 0010:__nfs_readpages_from_fscache+0x18b/0x190 [nfs]
	...
	Call Trace:
	 nfs_readpages+0xbf/0x1c0 [nfs]
	 ? __alloc_pages_nodemask+0x16c/0x320
	 read_pages+0x67/0x1a0
	 __do_page_cache_readahead+0x1cf/0x1f0
	 ondemand_readahead+0x172/0x2b0
	 page_cache_async_readahead+0xaa/0xe0
	 generic_file_buffered_read+0x852/0xd50
	 ? mem_cgroup_commit_charge+0x6e/0x140
	 ? nfs4_have_delegation+0x19/0x30 [nfsv4]
	 generic_file_read_iter+0x100/0x140
	 ? nfs_revalidate_mapping+0x176/0x2b0 [nfs]
	 nfs_file_read+0x6d/0xc0 [nfs]
	 new_sync_read+0x11a/0x1c0
	 __vfs_read+0x29/0x40
	 vfs_read+0x8e/0x140
	 ksys_read+0x61/0xd0
	 __x64_sys_read+0x1a/0x20
	 do_syscall_64+0x60/0x1e0
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9
	RIP: 0033:0x7f5d148267e0

Fixes: 10d83e11a582 ("cachefiles: drop direct usage of ->bmap method.")
Reported-by: David Wysochanski <dwysocha@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: David Wysochanski <dwysocha@redhat.com>
cc: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/rdwr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 1dc97f2d62013..d3d78176b23ce 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -398,7 +398,7 @@ int cachefiles_read_or_alloc_page(struct fscache_retrieval *op,
 	struct inode *inode;
 	sector_t block;
 	unsigned shift;
-	int ret;
+	int ret, ret2;
 
 	object = container_of(op->op.object,
 			      struct cachefiles_object, fscache);
@@ -430,8 +430,8 @@ int cachefiles_read_or_alloc_page(struct fscache_retrieval *op,
 	block = page->index;
 	block <<= shift;
 
-	ret = bmap(inode, &block);
-	ASSERT(ret < 0);
+	ret2 = bmap(inode, &block);
+	ASSERT(ret2 == 0);
 
 	_debug("%llx -> %llx",
 	       (unsigned long long) (page->index << shift),
@@ -739,8 +739,8 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 		block = page->index;
 		block <<= shift;
 
-		ret = bmap(inode, &block);
-		ASSERT(!ret);
+		ret2 = bmap(inode, &block);
+		ASSERT(ret2 == 0);
 
 		_debug("%llx -> %llx",
 		       (unsigned long long) (page->index << shift),
-- 
2.20.1



