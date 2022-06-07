Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241F1540DCF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354100AbiFGSuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353974AbiFGSqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01AE18DAE9;
        Tue,  7 Jun 2022 10:59:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ADEF618E5;
        Tue,  7 Jun 2022 17:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4FCC36B00;
        Tue,  7 Jun 2022 17:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624791;
        bh=gdWMOUDKVAqi6yCejsLZGzwhdUsyVmA79NthQ2UU4Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLCpCRAQr421UQQiteHvU4tAE0VuPSV827F6a2mhuscFh+wikJ8ih+DKHOOqLZ+bR
         w7McxenPan0lc3jkCJDK3LJA54FRLjfh8iUECfYwVagbJOKQZQagypOkmCMtEqUKPk
         /z5K79p5JV6fZHmQrn94OoLp6AKN8ojwjFHA1SbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 455/667] crypto: sun8i-ss - handle zero sized sg
Date:   Tue,  7 Jun 2022 19:02:00 +0200
Message-Id: <20220607164948.359558265@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit c149e4763d28bb4c0e5daae8a59f2c74e889f407 ]

sun8i-ss does not handle well the possible zero sized sg.

Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 1a71ed49d233..ca4f280af35d 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -380,13 +380,21 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	}
 
 	len = areq->nbytes;
-	for_each_sg(areq->src, sg, nr_sgs, i) {
+	sg = areq->src;
+	i = 0;
+	while (len > 0 && sg) {
+		if (sg_dma_len(sg) == 0) {
+			sg = sg_next(sg);
+			continue;
+		}
 		rctx->t_src[i].addr = sg_dma_address(sg);
 		todo = min(len, sg_dma_len(sg));
 		rctx->t_src[i].len = todo / 4;
 		len -= todo;
 		rctx->t_dst[i].addr = addr_res;
 		rctx->t_dst[i].len = digestsize / 4;
+		sg = sg_next(sg);
+		i++;
 	}
 	if (len > 0) {
 		dev_err(ss->dev, "remaining len %d\n", len);
-- 
2.35.1



