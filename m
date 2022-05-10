Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FD75219E7
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbiEJNw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343950AbiEJNso (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4531C6CF7E;
        Tue, 10 May 2022 06:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D32761889;
        Tue, 10 May 2022 13:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E56FC385A6;
        Tue, 10 May 2022 13:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189799;
        bh=06T+wi3k7GR9wZRnA1KB+vc7h+zs5j00p6E81Cpo/YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3+atyteHyDFCe6tUCT7dKhcoYsy2lgbPEC6BIailMfmC+rQlSxeji2dCkgce08sW
         BN1loa7R/yPJM0l41dxyxs7GkrrY2ZKAPDNNw+2SYd3TNwVliU8Nwb8t83SwI1TWAP
         fmukdr3vzE3ntoHW1JA1ziqSWX/osTKkr1y0vjIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Chung-Chiang Cheng <cccheng@synology.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 031/140] btrfs: export a helper for compression hard check
Date:   Tue, 10 May 2022 15:07:01 +0200
Message-Id: <20220510130742.505080142@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chung-Chiang Cheng <cccheng@synology.com>

commit e6f9d69648029e48b8f97db09368d419b5e2614a upstream.

inode_can_compress will be used outside of inode.c to check the
availability of setting compression flag by xattr. This patch moves
this function as an internal helper and renames it to
btrfs_inode_can_compress.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/btrfs_inode.h |   11 +++++++++++
 fs/btrfs/inode.c       |   15 ++-------------
 2 files changed, 13 insertions(+), 13 deletions(-)

--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -346,6 +346,17 @@ static inline bool btrfs_inode_in_log(st
 	return ret;
 }
 
+/*
+ * Check if the inode has flags compatible with compression
+ */
+static inline bool btrfs_inode_can_compress(const struct btrfs_inode *inode)
+{
+	if (inode->flags & BTRFS_INODE_NODATACOW ||
+	    inode->flags & BTRFS_INODE_NODATASUM)
+		return false;
+	return true;
+}
+
 struct btrfs_dio_private {
 	struct inode *inode;
 
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -486,17 +486,6 @@ static noinline int add_async_extent(str
 }
 
 /*
- * Check if the inode has flags compatible with compression
- */
-static inline bool inode_can_compress(struct btrfs_inode *inode)
-{
-	if (inode->flags & BTRFS_INODE_NODATACOW ||
-	    inode->flags & BTRFS_INODE_NODATASUM)
-		return false;
-	return true;
-}
-
-/*
  * Check if the inode needs to be submitted to compression, based on mount
  * options, defragmentation, properties or heuristics.
  */
@@ -505,7 +494,7 @@ static inline int inode_need_compress(st
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
-	if (!inode_can_compress(inode)) {
+	if (!btrfs_inode_can_compress(inode)) {
 		WARN(IS_ENABLED(CONFIG_BTRFS_DEBUG),
 			KERN_ERR "BTRFS: unexpected compression for ino %llu\n",
 			btrfs_ino(inode));
@@ -2015,7 +2004,7 @@ int btrfs_run_delalloc_range(struct btrf
 		       (zoned && btrfs_is_data_reloc_root(inode->root)));
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, nr_written);
-	} else if (!inode_can_compress(inode) ||
+	} else if (!btrfs_inode_can_compress(inode) ||
 		   !inode_need_compress(inode, start, end)) {
 		if (zoned)
 			ret = run_delalloc_zoned(inode, locked_page, start, end,


