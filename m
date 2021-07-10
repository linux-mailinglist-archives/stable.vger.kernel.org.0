Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3726D3C3963
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhGJX7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234357AbhGJX5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:57:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85A0C61429;
        Sat, 10 Jul 2021 23:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961174;
        bh=UI8arizcMZt0jWWuWkWK+1dPrCxJSzyeFbsb5TRcol0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irBmwLtkx0h3rOyib1mrhxgT8RyQPxoQ1xy9WxW6V+cD+vdsTRt/b5rO7qVssrDvP
         kOeuoi+dNpwi2BczSLeabf0TIdJctiKf9HUqHZgpbY3Cy9GKTRVRP13hatZNfeSb7n
         Ogyq8tCtfpJeY3rSrhwZtZjRLvQqviBTz4cjCZtniiTEblkdDeTRlzxHvP4lmQgx9e
         PJoK9SgQxXECmbezOq61UAY4jH4h3IHvwyY2qdfQR4FsvjkPqYVUkRq+IWpwMqAsq/
         w8NrnFPdqQuKqgFvx1XL1EBx4zD9cHqFtVjtcOhY7YsseTP/j8yF7ggk9lGk+9jIwP
         f+EeiiXgubZ2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/16] ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty
Date:   Sat, 10 Jul 2021 19:52:34 -0400
Message-Id: <20210710235240.3222618-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235240.3222618-1-sashal@kernel.org>
References: <20210710235240.3222618-1-sashal@kernel.org>
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
index 36aa6d8cdff7..9791de2dc773 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -72,10 +72,6 @@ static int ceph_set_page_dirty(struct page *page)
 	struct inode *inode;
 	struct ceph_inode_info *ci;
 	struct ceph_snap_context *snapc;
-	int ret;
-
-	if (unlikely(!mapping))
-		return !TestSetPageDirty(page);
 
 	if (PageDirty(page)) {
 		dout("%p set_page_dirty %p idx %lu -- already dirty\n",
@@ -121,11 +117,7 @@ static int ceph_set_page_dirty(struct page *page)
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

