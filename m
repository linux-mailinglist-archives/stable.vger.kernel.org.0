Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7608460FDC2
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbiJ0Q6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbiJ0Q6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:58:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699F017D28B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29DD3B826F9
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6ACC433D6;
        Thu, 27 Oct 2022 16:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889922;
        bh=pWiV8Tmp/KIOIQPBVARcWydTDsV02OYcpU/5BkcnBk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5i2S20nYzAdbPF8EzUGdq0Hra8nRHY3bv/gw+ZmKLfTzAk+rv8Kw09fFCeIQY89L
         QQuaHLxjwa8AHszR2+eNbtBNZXH5LISHqWGkaqd1m9+QBUg5QLt9BSd2qt78j/EuS5
         mNxw7JAoSh/u9yAKPO3+omxHkX5knWSk7WcOAGE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 49/94] erofs: shouldnt churn the mapping page for duplicated copies
Date:   Thu, 27 Oct 2022 18:54:51 +0200
Message-Id: <20221027165059.136406999@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 63bbb85658ea43dd35dbfde6d4150b47c407fc87 ]

If other duplicated copies exist in one decompression shot, should
leave the old page as is rather than replace it with the new duplicated
one.  Otherwise, the following cold path to deal with duplicated copies
will use the invalid bvec.  It impacts compressed data deduplication.

Also, shift the onlinepage EIO bit to avoid touching the signed bit.

Fixes: 267f2492c8f7 ("erofs: introduce multi-reference pclusters (fully-referenced)")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20221012045056.13421-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 8 +++-----
 fs/erofs/zdata.h | 6 +++---
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 5792ca9e0d5e..6e663275aeb1 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -838,15 +838,13 @@ static void z_erofs_do_decompressed_bvec(struct z_erofs_decompress_backend *be,
 
 	if (!((bvec->offset + be->pcl->pageofs_out) & ~PAGE_MASK)) {
 		unsigned int pgnr;
-		struct page *oldpage;
 
 		pgnr = (bvec->offset + be->pcl->pageofs_out) >> PAGE_SHIFT;
 		DBG_BUGON(pgnr >= be->nr_pages);
-		oldpage = be->decompressed_pages[pgnr];
-		be->decompressed_pages[pgnr] = bvec->page;
-
-		if (!oldpage)
+		if (!be->decompressed_pages[pgnr]) {
+			be->decompressed_pages[pgnr] = bvec->page;
 			return;
+		}
 	}
 
 	/* (cold path) one pcluster is requested multiple times */
diff --git a/fs/erofs/zdata.h b/fs/erofs/zdata.h
index e7f04c4fbb81..d98c95212985 100644
--- a/fs/erofs/zdata.h
+++ b/fs/erofs/zdata.h
@@ -126,10 +126,10 @@ static inline unsigned int z_erofs_pclusterpages(struct z_erofs_pcluster *pcl)
 }
 
 /*
- * bit 31: I/O error occurred on this page
- * bit 0 - 30: remaining parts to complete this page
+ * bit 30: I/O error occurred on this page
+ * bit 0 - 29: remaining parts to complete this page
  */
-#define Z_EROFS_PAGE_EIO			(1 << 31)
+#define Z_EROFS_PAGE_EIO			(1 << 30)
 
 static inline void z_erofs_onlinepage_init(struct page *page)
 {
-- 
2.35.1



