Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE05B35BE43
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbhDLI5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239010AbhDLIzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2744D60241;
        Mon, 12 Apr 2021 08:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217683;
        bh=nD1wYYd8GyeP2whV1NZOh4o2J55w3Drtk2N/AHn7La4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Gb0UWpLqslT2iUO8ItYgp3ezloraDq9i32LlHmaSkEqSN1/NGjQJk9dZ3vFQit+o
         HRCoqT9KNnG3NCxMwm4yIftoo1ZWmh6Id61Yq3Mt+f4WqB5OYnev4rXZi0rCmjGiTV
         8lCuqv4HUaBKzuVc39Ue7aKa629mqexM/AY12ROc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/188] hostfs: fix memory handling in follow_link()
Date:   Mon, 12 Apr 2021 10:40:22 +0200
Message-Id: <20210412084017.232221816@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index c070c0d8e3e9..d4e360234579 100644
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



