Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD20B4CF958
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbiCGKEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240519AbiCGKBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7782617;
        Mon,  7 Mar 2022 01:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB977B8102B;
        Mon,  7 Mar 2022 09:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACE4C340F7;
        Mon,  7 Mar 2022 09:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646592;
        bh=nSBScjLwDnnYYus0dcXkbfFcQ4AK2NVjbpG/fiVlMl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrjQP6N2Vwl//WcnZbM67ybJt3d1o5ViaadS/lyYsXazDH0NKr1ZGfgeRfsWOALzc
         5rt8n4JUinj1fVulL4lfF0FvnYPjM+vogR7FHx6sVnaEL11b3DhWkSOv6Qk/zgFEOr
         vj65hv74KhVpZ645G1fqEn/Z6+pnFK26ZdFTgJ/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Christophe Vu-Brugier <christophe.vu-brugier@seagate.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 031/186] exfat: fix i_blocks for files truncated over 4 GiB
Date:   Mon,  7 Mar 2022 10:17:49 +0100
Message-Id: <20220307091654.964143171@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Vu-Brugier <christophe.vu-brugier@seagate.com>

[ Upstream commit 92fba084b79e6bc7b12fc118209f1922c1a2df56 ]

In exfat_truncate(), the computation of inode->i_blocks is wrong if
the file is larger than 4 GiB because a 32-bit variable is used as a
mask. This is fixed and simplified by using round_up().

Also fix the same buggy computation in exfat_read_root() and another
(correct) one in exfat_fill_inode(). The latter was fixed another way
last month but can be simplified by using round_up() as well. See:

  commit 0c336d6e33f4 ("exfat: fix incorrect loading of i_blocks for
                        large files")

Fixes: 98d917047e8b ("exfat: add file operations")
Cc: stable@vger.kernel.org # v5.7+
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Christophe Vu-Brugier <christophe.vu-brugier@seagate.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c  | 4 ++--
 fs/exfat/inode.c | 4 ++--
 fs/exfat/super.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 848166d6d5e9d..d890fd34bb2d0 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -251,8 +251,8 @@ void exfat_truncate(struct inode *inode, loff_t size)
 	else
 		mark_inode_dirty(inode);
 
-	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1)) &
-			~(sbi->cluster_size - 1)) >> inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
+				inode->i_blkbits;
 write_size:
 	aligned_size = i_size_read(inode);
 	if (aligned_size & (blocksize - 1)) {
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index aca2e64d045b6..72a0ccfb616c3 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -602,8 +602,8 @@ static int exfat_fill_inode(struct inode *inode, struct exfat_dir_entry *info)
 
 	exfat_save_attr(inode, info->attr);
 
-	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1)) &
-		~((loff_t)sbi->cluster_size - 1)) >> inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
+				inode->i_blkbits;
 	inode->i_mtime = info->mtime;
 	inode->i_ctime = info->mtime;
 	ei->i_crtime = info->crtime;
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 1a2115d73a48a..4b5d02b1df585 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -364,8 +364,8 @@ static int exfat_read_root(struct inode *inode)
 	inode->i_op = &exfat_dir_inode_operations;
 	inode->i_fop = &exfat_dir_operations;
 
-	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1))
-			& ~(sbi->cluster_size - 1)) >> inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
+				inode->i_blkbits;
 	ei->i_pos = ((loff_t)sbi->root_dir << 32) | 0xffffffff;
 	ei->i_size_aligned = i_size_read(inode);
 	ei->i_size_ondisk = i_size_read(inode);
-- 
2.34.1



