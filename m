Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFF01A9E55
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897844AbgDOLx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409430AbgDOLsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:48:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 870A820775;
        Wed, 15 Apr 2020 11:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951290;
        bh=9WyvV04rLgQ0yebrNVGdbfNtGMFSfW1avJLli87N90Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPQKRYm5KUKOEAuKCtuGOtqm3VU+ZirnpG4uHTZDyJ2JssmruqaWXHB7bf2MbVxpL
         KazUxaeq7+RVzYe7paOSnL6bZ7o3jEauqc92kXfB3tuF+QFicIeywqMcIjoKy1Ch4g
         Nby00Su3cCks2j1bSY40AnXN1WE5EF3wd9FS7Ul4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 18/21] ext2: fix empty body warnings when -Wextra is used
Date:   Wed, 15 Apr 2020 07:47:45 -0400
Message-Id: <20200415114748.15713-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114748.15713-1-sashal@kernel.org>
References: <20200415114748.15713-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 44a52022e7f15cbaab957df1c14f7a4f527ef7cf ]

When EXT2_ATTR_DEBUG is not defined, modify the 2 debug macros
to use the no_printk() macro instead of <nothing>.
This fixes gcc warnings when -Wextra is used:

../fs/ext2/xattr.c:252:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
../fs/ext2/xattr.c:258:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
../fs/ext2/xattr.c:330:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
../fs/ext2/xattr.c:872:45: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]

I have verified that the only object code change (with gcc 7.5.0) is
the reversal of some instructions from 'cmp a,b' to 'cmp b,a'.

Link: https://lore.kernel.org/r/e18a7395-61fb-2093-18e8-ed4f8cf56248@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/xattr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index babef30d440b1..a54037df2c8a8 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -55,6 +55,7 @@
 
 #include <linux/buffer_head.h>
 #include <linux/init.h>
+#include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/mbcache.h>
 #include <linux/quotaops.h>
@@ -83,8 +84,8 @@
 		printk("\n"); \
 	} while (0)
 #else
-# define ea_idebug(f...)
-# define ea_bdebug(f...)
+# define ea_idebug(inode, f...)	no_printk(f)
+# define ea_bdebug(bh, f...)	no_printk(f)
 #endif
 
 static int ext2_xattr_set2(struct inode *, struct buffer_head *,
-- 
2.20.1

