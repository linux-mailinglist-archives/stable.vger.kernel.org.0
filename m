Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F703C3834
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhGJXyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233101AbhGJXxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DFCC613B7;
        Sat, 10 Jul 2021 23:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961048;
        bh=6HvT/XvruA45g30KjXZYhixeen6q9eCh5lcEAfjyexw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzAw1ftOmyGJXrNCiNMsTah3XAF5mW0BiGPm32F6yC35UuFfU7w6yzjfe8W6QP5i0
         XR5HDBnatfD/syAM7l5tsJ+AJh4C0M0oL+qn86QPON1R8h+FKBVpHt3RojXbGw9Hmt
         4CaEqfwL/Kk/iM4TCHYAAC5cQTqYFvdam7jxi18iPEr/BI72xZYb6RZ3vUXF8VKJ61
         1bjRNOmTOCiUQMhebdbT2h2+RaIdYuPkL+6wZWQ6mlcGshQyIqIFSDhOwn2hrvShXR
         ewVMj2FyURjeFbPliKbK/+aaDo+8FUJAEt2XJWSbhnyuC3lTTBKRvHAdOwrcGhKVqo
         y4elSZejq1mww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/37] ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty
Date:   Sat, 10 Jul 2021 19:50:01 -0400
Message-Id: <20210710235016.3221124-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 22d41cdcd3cfd467a4af074165357fcbea1c37f5 ]

The checks for page->mapping are odd, as set_page_dirty is an
address_space operation, and I don't see where it would be called on a
non-pagecache page.

The warning about the page lock also seems bogus.  The comment over
set_page_dirty() says that it can be called without the page lock in
some rare cases. I don't think we want to warn if that's the case.

Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8b0507f69c15..3465ff95cb89 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -78,10 +78,6 @@ static int ceph_set_page_dirty(struct page *page)
 	struct inode *inode;
 	struct ceph_inode_info *ci;
 	struct ceph_snap_context *snapc;
-	int ret;
-
-	if (unlikely(!mapping))
-		return !TestSetPageDirty(page);
 
 	if (PageDirty(page)) {
 		dout("%p set_page_dirty %p idx %lu -- already dirty\n",
@@ -127,11 +123,7 @@ static int ceph_set_page_dirty(struct page *page)
 	page->private = (unsigned long)snapc;
 	SetPagePrivate(page);
 
-	ret = __set_page_dirty_nobuffers(page);
-	WARN_ON(!PageLocked(page));
-	WARN_ON(!page->mapping);
-
-	return ret;
+	return __set_page_dirty_nobuffers(page);
 }
 
 /*
-- 
2.30.2

