Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88BEE61FD48
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 19:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiKGSUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 13:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbiKGSTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 13:19:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B811D33B;
        Mon,  7 Nov 2022 10:19:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6F6461222;
        Mon,  7 Nov 2022 18:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238AEC433D6;
        Mon,  7 Nov 2022 18:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667845164;
        bh=wLbrU0DRRdx4w58LlSRl76Dc06HHfli1tgQtQg9pkQ4=;
        h=From:To:Cc:Subject:Date:From;
        b=evLUl6/VPoeNP8AiBPRupPhjgwGRi0tkfqweFWCbY4dCxpunFqK3yHB9u+LE3xbB1
         nG22uXdpzobJNXxstOFBMn6rImhY8PbzXEPBNPmwBxaTugEquONzgn7JKPvEXYWSe5
         J7D6nJfqtG+BNB+brf11no4ltAOAo8xiK5fvowjZeAooKbNwFu5rmUYTJ2IWQ7TK/Z
         /Ay2/Bqf+jePpifFrvuyjSUmyh2tsFcv8zrGCZAONJFMctPWNTl2q5ICExW+Vo7Q9B
         lTmhjRUiPpDR6XGdk2Q0i9bDNjSNqGefgsLm94rxIVuBIHXvVoAo3VUzBBFPKidERo
         xoTtab/cMxs9w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jintao Yin <nicememory@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10] ext4,f2fs: fix readahead of verity data
Date:   Mon,  7 Nov 2022 10:18:55 -0800
Message-Id: <20221107181855.62545-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

commit 4fa0e3ff217f775cb58d2d6d51820ec519243fb9 upstream.

The recent change of page_cache_ra_unbounded() arguments was buggy in the
two callers, causing us to readahead the wrong pages.  Move the definition
of ractl down to after the index is set correctly.  This affected
performance on configurations that use fs-verity.

Link: https://lkml.kernel.org/r/20221012193419.1453558-1-willy@infradead.org
Fixes: 73bb49da50cd ("mm/readahead: make page_cache_ra_unbounded take a readahead_control")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Jintao Yin <nicememory@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/verity.c | 3 ++-
 fs/f2fs/verity.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 00e3cbde472e4..35be8e7ec2a04 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -370,13 +370,14 @@ static struct page *ext4_read_merkle_tree_page(struct inode *inode,
 					       pgoff_t index,
 					       unsigned long num_ra_pages)
 {
-	DEFINE_READAHEAD(ractl, NULL, inode->i_mapping, index);
 	struct page *page;
 
 	index += ext4_verity_metadata_pos(inode) >> PAGE_SHIFT;
 
 	page = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
 	if (!page || !PageUptodate(page)) {
+		DEFINE_READAHEAD(ractl, NULL, inode->i_mapping, index);
+
 		if (page)
 			put_page(page);
 		else if (num_ra_pages > 1)
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 15ba36926fad7..cff94d095d0fe 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -261,13 +261,14 @@ static struct page *f2fs_read_merkle_tree_page(struct inode *inode,
 					       pgoff_t index,
 					       unsigned long num_ra_pages)
 {
-	DEFINE_READAHEAD(ractl, NULL, inode->i_mapping, index);
 	struct page *page;
 
 	index += f2fs_verity_metadata_pos(inode) >> PAGE_SHIFT;
 
 	page = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
 	if (!page || !PageUptodate(page)) {
+		DEFINE_READAHEAD(ractl, NULL, inode->i_mapping, index);
+
 		if (page)
 			put_page(page);
 		else if (num_ra_pages > 1)
-- 
2.38.1

