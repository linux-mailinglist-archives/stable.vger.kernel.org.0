Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FBB3CDC0E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241094AbhGSOvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343990AbhGSOsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38828613D3;
        Mon, 19 Jul 2021 15:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708351;
        bh=29/d8iHVTKTqMfAj+ImN5vbWDiKq9zh5EN7smpYH6Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNBjq3o3tKi8E6PWOVkI71iwR6n7SSzxHeeXLNeXFSjwnguwyN5CqQyNLIZZJNxun
         Uq8RL0UBvUnH9lQw7QkVi8p55BnA47G3F5+K+ggNHqlWGKcwk5CuAqfAV1/I8iUYew
         zRfU1h0JfM3N0SmQvz41GwI4TqPE3yLPlANcrOqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 277/315] ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty
Date:   Mon, 19 Jul 2021 16:52:46 +0200
Message-Id: <20210719144952.528325480@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ae1435c12d2b..1dba2b95fe8e 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -74,10 +74,6 @@ static int ceph_set_page_dirty(struct page *page)
 	struct inode *inode;
 	struct ceph_inode_info *ci;
 	struct ceph_snap_context *snapc;
-	int ret;
-
-	if (unlikely(!mapping))
-		return !TestSetPageDirty(page);
 
 	if (PageDirty(page)) {
 		dout("%p set_page_dirty %p idx %lu -- already dirty\n",
@@ -123,11 +119,7 @@ static int ceph_set_page_dirty(struct page *page)
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



