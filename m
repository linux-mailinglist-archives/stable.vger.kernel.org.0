Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D58A6215ED
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiKHOQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbiKHOQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3B769DFF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4724A60025
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530A5C433C1;
        Tue,  8 Nov 2022 14:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667917006;
        bh=VWDr+OrVOnvZbcEUUfFEyKZvIdniehIUvNa3RRprMOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oV0ga5DEoELLAcFOCJZjle6SelXZ2CYgRS75JB1sD1h0ciL336S2Kp35efHVZfdHz
         eXvhpGYW4I+8UmWNHFMND0+XXd2IfMeLw39QuZ4CQrZy+OO/aL2n4RPuNI5nwYIG9p
         FnXBTDS7tV8ZFR9v5udbB53UhNXU7SXX7Shoa9Fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jintao Yin <nicememory@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.0 188/197] ext4,f2fs: fix readahead of verity data
Date:   Tue,  8 Nov 2022 14:40:26 +0100
Message-Id: <20221108133403.445462269@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

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
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/verity.c |    3 ++-
 fs/f2fs/verity.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -365,13 +365,14 @@ static struct page *ext4_read_merkle_tre
 					       pgoff_t index,
 					       unsigned long num_ra_pages)
 {
-	DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
 	struct page *page;
 
 	index += ext4_verity_metadata_pos(inode) >> PAGE_SHIFT;
 
 	page = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
 	if (!page || !PageUptodate(page)) {
+		DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
+
 		if (page)
 			put_page(page);
 		else if (num_ra_pages > 1)
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -262,13 +262,14 @@ static struct page *f2fs_read_merkle_tre
 					       pgoff_t index,
 					       unsigned long num_ra_pages)
 {
-	DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
 	struct page *page;
 
 	index += f2fs_verity_metadata_pos(inode) >> PAGE_SHIFT;
 
 	page = find_get_page_flags(inode->i_mapping, index, FGP_ACCESSED);
 	if (!page || !PageUptodate(page)) {
+		DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, index);
+
 		if (page)
 			put_page(page);
 		else if (num_ra_pages > 1)


