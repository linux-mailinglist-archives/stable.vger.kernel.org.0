Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2D235BD7C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbhDLIv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhDLItz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 474196124C;
        Mon, 12 Apr 2021 08:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217343;
        bh=v7hwrZQrgSgJF+sX3GEqamI4pj0BSEKYrBZSSqXwnCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLWJTCsiWP78qipqXT366ZKuBGCvr7zYr03vaqEPFv03U76Y6JRFeiwNLXDoZ7/sI
         gthYAXcDoYkK4x/TdmiYcYdBxLn89FL6Lk1AgGA0zmwL8SG6hi6cD1CQVLJINZC9/W
         jtvOKsVfShpxcrieXDy6ZC3qbEfJHor9cWBDoXLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/111] hostfs: fix memory handling in follow_link()
Date:   Mon, 12 Apr 2021 10:40:34 +0200
Message-Id: <20210412084006.133788036@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 7f6c411c9b50cfab41cc798e003eff27608c7016 ]

1) argument should not be freed in any case - the caller already has
it as ->s_fs_info (and uses it a lot afterwards)
2) allocate readlink buffer with kmalloc() - the caller has no way
to tell if it's got that (on absolute symlink) or a result of
kasprintf().  Sure, for SLAB and SLUB kfree() works on results of
kmem_cache_alloc(), but that's not documented anywhere, might change
in the future *and* is already not true for SLOB.

Fixes: 52b209f7b848 ("get rid of hostfs_read_inode()")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hostfs/hostfs_kern.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 4f5d857f6ecb..58a972667bf8 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -142,7 +142,7 @@ static char *follow_link(char *link)
 	char *name, *resolved, *end;
 	int n;
 
-	name = __getname();
+	name = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!name) {
 		n = -ENOMEM;
 		goto out_free;
@@ -171,12 +171,11 @@ static char *follow_link(char *link)
 		goto out_free;
 	}
 
-	__putname(name);
-	kfree(link);
+	kfree(name);
 	return resolved;
 
  out_free:
-	__putname(name);
+	kfree(name);
 	return ERR_PTR(n);
 }
 
-- 
2.30.2



