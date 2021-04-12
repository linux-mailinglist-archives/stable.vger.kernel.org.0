Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2418035C048
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbhDLJMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239397AbhDLJHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:07:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AFBD61243;
        Mon, 12 Apr 2021 09:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218228;
        bh=NUu29+rwEObPp4yN3HMgWsXu/hc19Vop9ONF4LdYmJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjQqTg8HOALwuUuWUrHny7WQJg1WG0sPF+K06SaplSC+9Gb2bmXdgkH+jrl6W1Zid
         lKis0piY01XHPzPOhZKm+QdoR276k+xTHDxSanjOI54+6zPp7BkmgC/pHwamOZfrNp
         USkvvzyRCXYun2erjxQTTHghj0QDBSBSw3DjeOC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 118/210] hostfs: fix memory handling in follow_link()
Date:   Mon, 12 Apr 2021 10:40:23 +0200
Message-Id: <20210412084019.938245631@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
index aea35459d390..07467ca0f71d 100644
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



