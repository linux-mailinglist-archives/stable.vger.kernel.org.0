Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261096BB34E
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbjCOMnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbjCOMnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:43:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3512C62FEC
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37FEE61D66
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6BDC433EF;
        Wed, 15 Mar 2023 12:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884099;
        bh=YCiaxZq2SVJH5A/l+iyK6Xqo5Ui+qe+X9yrP4Y/FeXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOW06CypuCNblW+A4TuvnUHIDyi3apQo8rFvdilOwmdhGDLXToP3YQnL5x5pR/thP
         kvH0tgdl4xDXAVBFS3CcNnKDGJomOnSmDCUu+HxSX/9v5QmdMDiIgY+Y5+Xgsq5+++
         Bi6IsP2WBwbAWYa1cbeF3UTttj/i46XQDvb70F8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 107/141] erofs: Revert "erofs: fix kvcalloc() misuse with __GFP_NOFAIL"
Date:   Wed, 15 Mar 2023 13:13:30 +0100
Message-Id: <20230315115743.259078846@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 647dd2c3f0e16b71a1a77897d038164d48eea154 ]

Let's revert commit 12724ba38992 ("erofs: fix kvcalloc() misuse with
__GFP_NOFAIL") since kvmalloc() already supports __GFP_NOFAIL in commit
a421ef303008 ("mm: allow !GFP_KERNEL allocations for kvmalloc").  So
the original fix was wrong.

Actually there was some issue as [1] discussed, so before that mm fix
is landed, the warn could still happen but applying this commit first
will cause less.

[1] https://lore.kernel.org/r/20230305053035.1911-1-hsiangkao@linux.alibaba.com

Fixes: 12724ba38992 ("erofs: fix kvcalloc() misuse with __GFP_NOFAIL")
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230309053148.9223-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 5200bb86e2643..ccf7c55d477fe 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1032,12 +1032,12 @@ static int z_erofs_decompress_pcluster(struct z_erofs_decompress_backend *be,
 
 	if (!be->decompressed_pages)
 		be->decompressed_pages =
-			kcalloc(be->nr_pages, sizeof(struct page *),
-				GFP_KERNEL | __GFP_NOFAIL);
+			kvcalloc(be->nr_pages, sizeof(struct page *),
+				 GFP_KERNEL | __GFP_NOFAIL);
 	if (!be->compressed_pages)
 		be->compressed_pages =
-			kcalloc(pclusterpages, sizeof(struct page *),
-				GFP_KERNEL | __GFP_NOFAIL);
+			kvcalloc(pclusterpages, sizeof(struct page *),
+				 GFP_KERNEL | __GFP_NOFAIL);
 
 	z_erofs_parse_out_bvecs(be);
 	err2 = z_erofs_parse_in_bvecs(be, &overlapped);
@@ -1085,7 +1085,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_decompress_backend *be,
 	}
 	if (be->compressed_pages < be->onstack_pages ||
 	    be->compressed_pages >= be->onstack_pages + Z_EROFS_ONSTACK_PAGES)
-		kfree(be->compressed_pages);
+		kvfree(be->compressed_pages);
 	z_erofs_fill_other_copies(be, err);
 
 	for (i = 0; i < be->nr_pages; ++i) {
@@ -1104,7 +1104,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_decompress_backend *be,
 	}
 
 	if (be->decompressed_pages != be->onstack_pages)
-		kfree(be->decompressed_pages);
+		kvfree(be->decompressed_pages);
 
 	pcl->length = 0;
 	pcl->partial = true;
-- 
2.39.2



