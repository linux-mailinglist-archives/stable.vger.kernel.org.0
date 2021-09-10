Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB19A406292
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhIJApf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhIJAVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B5F161167;
        Fri, 10 Sep 2021 00:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233215;
        bh=dIhQ6D+q7+4S+hd60dZ6SVU2WEjyBy8A3v6b+a3GppY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMpny/SR5ohOHyITTg+9yzxTEIJEXFUrkXkvaIUdhOw/am8eucwEC401wanrPTmzx
         V36Tpv9yAuUw4gC5Efoh+BL3NTFTum/cht9/sBfegNBzaPW59PAswmeA6PQjMaARd9
         QXgjrLAaXM9cB6UwjjSbI9d61wRXHJ0Q3QlqSvumYbozXdBj0TqO8UplLlCIChCJAe
         BA5xBmXsfSNaMDEWsjkJbaE/NP7sHDcMWa9B1MKeYwVhmLPHDZw9SGs9HHEBSEpOsk
         8PtaURmw6ZDpN2Kz9RW00DEOq78OqBQ8dSs9ZkjrbuSbdZ4NZBD59QmvV93wjt9dlo
         l9fCFODnF+OXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 81/88] fs: drop_caches: fix skipping over shadow cache inodes
Date:   Thu,  9 Sep 2021 20:18:13 -0400
Message-Id: <20210910001820.174272-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit 16e2df2a05d46c983bf310b19432c5ca4684b2bc ]

When drop_caches truncates the page cache in an inode it also includes any
shadow entries for evicted pages.  However, there is a preliminary check
on whether the inode has pages: if it has *only* shadow entries, it will
skip running truncation on the inode and leave it behind.

Fix the check to mapping_empty(), such that it runs truncation on any
inode that has cache entries at all.

Link: https://lkml.kernel.org/r/20210614211904.14420-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Roman Gushchin <guro@fb.com>
Acked-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/drop_caches.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index f00fcc4a4f72..e619c31b6bd9 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -3,6 +3,7 @@
  * Implement the manual drop-all-pagecache function
  */
 
+#include <linux/pagemap.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
@@ -27,7 +28,7 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 		 * we need to reschedule to avoid softlockups.
 		 */
 		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
-		    (inode->i_mapping->nrpages == 0 && !need_resched())) {
+		    (mapping_empty(inode->i_mapping) && !need_resched())) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-- 
2.30.2

