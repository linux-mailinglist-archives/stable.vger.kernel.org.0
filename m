Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2175C53BB4F
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 17:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiFBPCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 11:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbiFBPCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 11:02:18 -0400
X-Greylist: delayed 133 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Jun 2022 08:02:17 PDT
Received: from mail1.wrs.com (unknown-3-146.windriver.com [147.11.3.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A765411E1F8;
        Thu,  2 Jun 2022 08:02:17 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.corp.ad.wrs.com [147.11.82.252])
        by mail1.wrs.com (8.15.2/8.15.2) with ESMTPS id 252F2AvY010739
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jun 2022 08:02:10 -0700
Received: from otp-dpanait-l2.corp.ad.wrs.com (128.224.125.150) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Jun 2022 08:02:08 -0700
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     <stable@vger.kernel.org>
CC:     Haimin Zhang <tcs.kernel@gmail.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Dragos-Marian Panait <dragos.panait@windriver.com>
Subject: [PATCH 4.14 1/1] block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern
Date:   Thu, 2 Jun 2022 18:01:57 +0300
Message-ID: <20220602150157.2255674-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602150157.2255674-1-dragos.panait@windriver.com>
References: <20220602150157.2255674-1-dragos.panait@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [128.224.125.150]
X-ClientProxiedBy: ala-exchng01.corp.ad.wrs.com (147.11.82.252) To
 ala-exchng01.corp.ad.wrs.com (147.11.82.252)
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haimin Zhang <tcs.kernel@gmail.com>

commit cc8f7fe1f5eab010191aa4570f27641876fa1267 upstream.

Add __GFP_ZERO flag for alloc_page in function bio_copy_kern to initialize
the buffer of a bio.

Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220216084038.15635-1-tcs.kernel@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[DP: Backported to 4.14: Manually added __GFP_ZERO flag]
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 30df1b45dde8..1eaf31976702 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1657,7 +1657,7 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | gfp_mask);
+		page = alloc_page(q->bounce_gfp | __GFP_ZERO | gfp_mask);
 		if (!page)
 			goto cleanup;
 
-- 
2.36.1

