Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F7B59A142
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351146AbiHSQDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351638AbiHSQCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:02:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B81FD51E0;
        Fri, 19 Aug 2022 08:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8B5A4CE26B8;
        Fri, 19 Aug 2022 15:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BC2C433D6;
        Fri, 19 Aug 2022 15:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924450;
        bh=KH+LbbLmVGf4w93XlXej3XCKb8SjTDmLrLAJpeWu4S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19n0/eQnZJUIZVRFo9DlqZoSkzcUSJfFSha0II5NdKgdwpVbeooVojzGC79mk+n4e
         wJ4CPRBmvfU8nkt3iQzvsgNt4I8CU1jN18p+RgCVBoFzU5883h16aZaY6HckWH7RzK
         6Nme2Iyo2NAi1lXrMoidt/doBRhrAqg93MM7M+GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/545] crypto: sun8i-ss - fix error codes in allocate_flows()
Date:   Fri, 19 Aug 2022 17:39:04 +0200
Message-Id: <20220819153837.137864411@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d2765e1b9ac4b2d5a5d5bf17f468c9b3566c3770 ]

These failure paths should return -ENOMEM.  Currently they return
success.

Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
Fixes: 8eec4563f152 ("crypto: sun8i-ss - do not allocate memory when handling hash requests")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c    | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 786b6f5cf300..47b5828e35c3 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -476,25 +476,33 @@ static int allocate_flows(struct sun8i_ss_dev *ss)
 
 		ss->flows[i].biv = devm_kmalloc(ss->dev, AES_BLOCK_SIZE,
 						GFP_KERNEL | GFP_DMA);
-		if (!ss->flows[i].biv)
+		if (!ss->flows[i].biv) {
+			err = -ENOMEM;
 			goto error_engine;
+		}
 
 		for (j = 0; j < MAX_SG; j++) {
 			ss->flows[i].iv[j] = devm_kmalloc(ss->dev, AES_BLOCK_SIZE,
 							  GFP_KERNEL | GFP_DMA);
-			if (!ss->flows[i].iv[j])
+			if (!ss->flows[i].iv[j]) {
+				err = -ENOMEM;
 				goto error_engine;
+			}
 		}
 
 		/* the padding could be up to two block. */
 		ss->flows[i].pad = devm_kmalloc(ss->dev, SHA256_BLOCK_SIZE * 2,
 						GFP_KERNEL | GFP_DMA);
-		if (!ss->flows[i].pad)
+		if (!ss->flows[i].pad) {
+			err = -ENOMEM;
 			goto error_engine;
+		}
 		ss->flows[i].result = devm_kmalloc(ss->dev, SHA256_DIGEST_SIZE,
 						   GFP_KERNEL | GFP_DMA);
-		if (!ss->flows[i].result)
+		if (!ss->flows[i].result) {
+			err = -ENOMEM;
 			goto error_engine;
+		}
 
 		ss->flows[i].engine = crypto_engine_alloc_init(ss->dev, true);
 		if (!ss->flows[i].engine) {
-- 
2.35.1



