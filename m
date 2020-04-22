Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130101B3CA6
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgDVKHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgDVKH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:07:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7A120575;
        Wed, 22 Apr 2020 10:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550047;
        bh=9WyvV04rLgQ0yebrNVGdbfNtGMFSfW1avJLli87N90Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7D/Rkn2Hh8ONzX/nJZrTwPGcNOlOke2s1IQwbwxD62YLbMs9+Hoq6RtJ2/e22Jhz
         +heBf2FnyTE7Pvz47VOvA+acQjf0jzPeEJ8hmtHB9h4oBMfNlukDR1qxQBn31kZcKp
         0+ddeJwoOkcmTK41aGCImvy2c4GvC6YbM4yS+BP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 114/125] ext2: fix empty body warnings when -Wextra is used
Date:   Wed, 22 Apr 2020 11:57:11 +0200
Message-Id: <20200422095051.098698584@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



