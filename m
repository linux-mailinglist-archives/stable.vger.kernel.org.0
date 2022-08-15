Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C565D59517B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbiHPE6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbiHPE5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:57:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1007BC10A;
        Mon, 15 Aug 2022 13:51:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 588D2B811AB;
        Mon, 15 Aug 2022 20:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE332C433C1;
        Mon, 15 Aug 2022 20:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596688;
        bh=KhMDwJOQg4vOSTjVp5iqBX9AP8GhSSqZWa6KYBVpmTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ezb8CCN6TqlR/00R6TISF4uajzwBK5kzlraEz1KTz2gFFwBPgM1N7XIgh+V/qqLfE
         AE7UvYMaeLw6cWSqFoDXMfO3AZg/3yN6SAgvy5uRMAczvd4hVTvirVNQY3ioK3IyRP
         j/dk/2DkqKKzmxSu5wZuNzlvCd2082xvZMvf1rHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Torge Matthies <openglfreak@googlemail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1116/1157] ext4: fix reading leftover inlined symlinks
Date:   Mon, 15 Aug 2022 20:07:52 +0200
Message-Id: <20220815180524.972316753@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 5a57bca9050d740ca37184302e23d0e7633e3ebc ]

Since commit 6493792d3299 ("ext4: convert symlink external data block
mapping to bdev"), create new symlink with inline_data is not supported,
but it missing to handle the leftover inlined symlinks, which could
cause below error message and fail to read symlink.

 ls: cannot read symbolic link 'foo': Structure needs cleaning

 EXT4-fs error (device sda): ext4_map_blocks:605: inode #12: block
 2021161080: comm ls: lblock 0 mapped to illegal pblock 2021161080
 (length 1)

Fix this regression by adding ext4_read_inline_link(), which read the
inline data directly and convert it through a kmalloced buffer.

Fixes: 6493792d3299 ("ext4: convert symlink external data block mapping to bdev")
Cc: stable@kernel.org
Reported-by: Torge Matthies <openglfreak@googlemail.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Tested-by: Torge Matthies <openglfreak@googlemail.com>
Link: https://lore.kernel.org/r/20220630090100.2769490-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h    |  1 +
 fs/ext4/inline.c  | 30 ++++++++++++++++++++++++++++++
 fs/ext4/symlink.c | 15 +++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 75b8d81b2469..adfc30ee4b7b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3583,6 +3583,7 @@ extern struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
 extern int ext4_inline_data_fiemap(struct inode *inode,
 				   struct fiemap_extent_info *fieinfo,
 				   int *has_inline, __u64 start, __u64 len);
+extern void *ext4_read_inline_link(struct inode *inode);
 
 struct iomap;
 extern int ext4_inline_data_iomap(struct inode *inode, struct iomap *iomap);
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index cff52ff6549d..1fa36cbe09ec 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -6,6 +6,7 @@
 
 #include <linux/iomap.h>
 #include <linux/fiemap.h>
+#include <linux/namei.h>
 #include <linux/iversion.h>
 #include <linux/sched/mm.h>
 
@@ -1588,6 +1589,35 @@ int ext4_read_inline_dir(struct file *file,
 	return ret;
 }
 
+void *ext4_read_inline_link(struct inode *inode)
+{
+	struct ext4_iloc iloc;
+	int ret, inline_size;
+	void *link;
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = -ENOMEM;
+	inline_size = ext4_get_inline_size(inode);
+	link = kmalloc(inline_size + 1, GFP_NOFS);
+	if (!link)
+		goto out;
+
+	ret = ext4_read_inline_data(inode, link, inline_size, &iloc);
+	if (ret < 0) {
+		kfree(link);
+		goto out;
+	}
+	nd_terminate_link(link, inode->i_size, ret);
+out:
+	if (ret < 0)
+		link = ERR_PTR(ret);
+	brelse(iloc.bh);
+	return link;
+}
+
 struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
 					struct ext4_dir_entry_2 **parent_de,
 					int *retval)
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index d281f5bcc526..3d3ed3c38f56 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -74,6 +74,21 @@ static const char *ext4_get_link(struct dentry *dentry, struct inode *inode,
 				 struct delayed_call *callback)
 {
 	struct buffer_head *bh;
+	char *inline_link;
+
+	/*
+	 * Create a new inlined symlink is not supported, just provide a
+	 * method to read the leftovers.
+	 */
+	if (ext4_has_inline_data(inode)) {
+		if (!dentry)
+			return ERR_PTR(-ECHILD);
+
+		inline_link = ext4_read_inline_link(inode);
+		if (!IS_ERR(inline_link))
+			set_delayed_call(callback, kfree_link, inline_link);
+		return inline_link;
+	}
 
 	if (!dentry) {
 		bh = ext4_getblk(NULL, inode, 0, EXT4_GET_BLOCKS_CACHED_NOWAIT);
-- 
2.35.1



