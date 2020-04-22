Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE441B3FF3
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731714AbgDVKmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729664AbgDVKTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:19:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BEA720776;
        Wed, 22 Apr 2020 10:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550785;
        bh=5Ci5tuTv9+UalY7YeLpOUErdM7aSS+N8D1vX52ppM9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9bT7Wt/Qz1bDtnAfV8nBNeIkduvKEp94uCICyZkGI5WvtJSWIkIaZQs5AXsdZ1zj
         Wwb4/kwStiUdv1CZ+j+K2iUW3lpunOzgb5DyVJaTc/8pp6BNw8FqWHzhuzYyCPG59b
         F6YQt0lDmGi2OAhsUAxtcf/7PfyArvCpiykWlWbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/118] ext2: fix debug reference to ext2_xattr_cache
Date:   Wed, 22 Apr 2020 11:57:34 +0200
Message-Id: <20200422095046.620926988@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



