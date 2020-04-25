Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DF61B8655
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 13:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgDYLwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 07:52:07 -0400
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:47882 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgDYLwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Apr 2020 07:52:07 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id DA4A818014A21;
        Sat, 25 Apr 2020 11:43:35 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 0343D62C4;
        Sat, 25 Apr 2020 11:43:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:69:152:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3870:3871:3872:3874:4321:4605:5007:6119:7576:7903:10004:10400:10450:10455:10848:11026:11232:11473:11658:11914:12043:12296:12297:12438:12555:12740:12895:12986:13894:14181:14659:14721:19904:19999:21080:21451:21627:30012:30054:30056:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: quiet09_1d6cd28fe21e
X-Filterd-Recvd-Size: 4666
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Apr 2020 11:43:32 +0000 (UTC)
Message-ID: <326458310dc7c982d2f2210e057f69d6bc0169c7.camel@perches.com>
Subject: Re: [PATCH 4.4 091/100] ext2: fix empty body warnings when -Wextra
 is used
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Date:   Sat, 25 Apr 2020 04:43:31 -0700
In-Reply-To: <20200422095039.371486451@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
         <20200422095039.371486451@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-04-22 at 11:57 +0200, Greg Kroah-Hartman wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> [ Upstream commit 44a52022e7f15cbaab957df1c14f7a4f527ef7cf ]
> 
> When EXT2_ATTR_DEBUG is not defined, modify the 2 debug macros
> to use the no_printk() macro instead of <nothing>.
> This fixes gcc warnings when -Wextra is used:
> 
> ../fs/ext2/xattr.c:252:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> ../fs/ext2/xattr.c:258:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> ../fs/ext2/xattr.c:330:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> ../fs/ext2/xattr.c:872:45: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
> 
> I have verified that the only object code change (with gcc 7.5.0) is
> the reversal of some instructions from 'cmp a,b' to 'cmp b,a'.

It'd be better to use the ext4 style defines:

fs/ext4/xattr.c:# define ea_idebug(inode, fmt, ...)                                     \
fs/ext4/xattr.c-        printk(KERN_DEBUG "inode %s:%lu: " fmt "\n",                    \
fs/ext4/xattr.c-               inode->i_sb->s_id, inode->i_ino, ##__VA_ARGS__)
fs/ext4/xattr.c:# define ea_bdebug(bh, fmt, ...)                                        \
fs/ext4/xattr.c-        printk(KERN_DEBUG "block %pg:%lu: " fmt "\n",                   \
fs/ext4/xattr.c-               bh->b_bdev, (unsigned long)bh->b_blocknr, ##__VA_ARGS__)
--
fs/ext4/xattr.c:# define ea_idebug(inode, fmt, ...)     no_printk(fmt, ##__VA_ARGS__)
fs/ext4/xattr.c:# define ea_bdebug(bh, fmt, ...)        no_printk(fmt, ##__VA_ARGS__)

So the output logging won't be split across multiple lines.

> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
[]
> @@ -55,6 +55,7 @@
>  
>  #include <linux/buffer_head.h>
>  #include <linux/init.h>
> +#include <linux/printk.h>
>  #include <linux/slab.h>
>  #include <linux/mbcache.h>
>  #include <linux/quotaops.h>
> @@ -85,8 +86,8 @@
>  		printk("\n"); \
>  	} while (0)
>  #else
> -# define ea_idebug(f...)
> -# define ea_bdebug(f...)
> +# define ea_idebug(inode, f...)	no_printk(f)
> +# define ea_bdebug(bh, f...)	no_printk(f)
>  #endif
>  
>  static int ext2_xattr_set2(struct inode *, struct buffer_head *,

---
 fs/ext2/xattr.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 943cc46..7740582 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -72,21 +72,15 @@
 #define IS_LAST_ENTRY(entry) (*(__u32 *)(entry) == 0)
 
 #ifdef EXT2_XATTR_DEBUG
-# define ea_idebug(inode, f...) do { \
-		printk(KERN_DEBUG "inode %s:%ld: ", \
-			inode->i_sb->s_id, inode->i_ino); \
-		printk(f); \
-		printk("\n"); \
-	} while (0)
-# define ea_bdebug(bh, f...) do { \
-		printk(KERN_DEBUG "block %pg:%lu: ", \
-			bh->b_bdev, (unsigned long) bh->b_blocknr); \
-		printk(f); \
-		printk("\n"); \
-	} while (0)
+# define ea_idebug(inode, fmt, ...)					\
+	printk(KERN_DEBUG "inode %s:%lu: " fmt "\n",			\
+	       inode->i_sb->s_id, inode->i_ino, ##__VA_ARGS__)
+# define ea_bdebug(bh, fmt, ...)					\
+	printk(KERN_DEBUG "block %pg:%lu: " fmt "\n",			\
+	       bh->b_bdev, (unsigned long)bh->b_blocknr, ##__VA_ARGS__)
 #else
-# define ea_idebug(inode, f...)	no_printk(f)
-# define ea_bdebug(bh, f...)	no_printk(f)
+# define ea_idebug(inode, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
+# define ea_bdebug(bh, fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 static int ext2_xattr_set2(struct inode *, struct buffer_head *,


