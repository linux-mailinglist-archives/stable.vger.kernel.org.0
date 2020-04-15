Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2141A9FDF
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368873AbgDOMS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409269AbgDOLqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:46:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE73120768;
        Wed, 15 Apr 2020 11:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951172;
        bh=5Ci5tuTv9+UalY7YeLpOUErdM7aSS+N8D1vX52ppM9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9IZ5hX2Xyr+AR/q8MEK+NLwKcpGgKqKvEluETTkEFp9GQACF2UTzIfOZgXQYb8wU
         t8YzFpcNPQ77LRbMqcXLkexrDeoS6WeUQdYkHGUBM0Sq1+dLHjO7oNvPhgpgszLAHw
         p5gXHN+W/Iau5KfTRN2m0bECnwfFE9JGH83lEa/Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 76/84] ext2: fix debug reference to ext2_xattr_cache
Date:   Wed, 15 Apr 2020 07:44:33 -0400
Message-Id: <20200415114442.14166-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 32302085a8d90859c40cf1a5e8313f575d06ec75 ]

Fix a debug-only build error in ext2/xattr.c:

When building without extra debugging, (and with another patch that uses
no_printk() instead of <empty> for the ext2-xattr debug-print macros,
this build error happens:

../fs/ext2/xattr.c: In function ‘ext2_xattr_cache_insert’:
../fs/ext2/xattr.c:869:18: error: ‘ext2_xattr_cache’ undeclared (first use in
this function); did you mean ‘ext2_xattr_list’?
     atomic_read(&ext2_xattr_cache->c_entry_count));

Fix the problem by removing cached entry count from the debug message
since otherwise we'd have to export the mbcache structure just for that.

Fixes: be0726d33cb8 ("ext2: convert to mbcache2")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index b91f99d9482e9..62acbe27d8bf4 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -865,8 +865,7 @@ ext2_xattr_cache_insert(struct mb_cache *cache, struct buffer_head *bh)
 				      true);
 	if (error) {
 		if (error == -EBUSY) {
-			ea_bdebug(bh, "already in cache (%d cache entries)",
-				atomic_read(&ext2_xattr_cache->c_entry_count));
+			ea_bdebug(bh, "already in cache");
 			error = 0;
 		}
 	} else
-- 
2.20.1

