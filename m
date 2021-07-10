Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCE73C3927
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhGJX5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhGJX4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B159D6140F;
        Sat, 10 Jul 2021 23:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961148;
        bh=29/d8iHVTKTqMfAj+ImN5vbWDiKq9zh5EN7smpYH6Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKIYb1sc/BHj8tcZ4qjcTn458D74g7nX4FyG3f/Uh+hLFpspFrj7vbiY6MHfqXPmf
         1UltA2mTNdCDqM98xz5nTjVZVAu0ixLVfDziQ3NTg56/XXLK5aEoThieHx1LeL/H/7
         PvjirlRmWflNai7/QuDsWr0aqQwelew3OKZs//JMlhDd5uYt8LhNvHRdwudhkTSg3T
         2nAdhw48L/1BzsxfyCouNu5lz60OorvPvI3v5YW6la2gUyFOZYjx7CaF//9c/g2maY
         8vVv3KFrp90m59drs6qGMA2n7YoyWDgioK1JIXQHS+dZQxsc3/N0YPk5Omf7je5VE8
         96aSbZj2VfJyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/21] ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty
Date:   Sat, 10 Jul 2021 19:52:03 -0400
Message-Id: <20210710235212.3222375-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235212.3222375-1-sashal@kernel.org>
References: <20210710235212.3222375-1-sashal@kernel.org>
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

