Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E76C541514
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344407AbiFGU2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359544AbiFGUXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:23:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6551F1D5193;
        Tue,  7 Jun 2022 11:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 896A361501;
        Tue,  7 Jun 2022 18:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9406EC385A2;
        Tue,  7 Jun 2022 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626724;
        bh=yRHFUJLE9xSqVhgzgjZ7u51QhzkbKY04Y0WQF2bXGUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoCKntrbV3C9ONjcCf9jcZzTQwz/pa/Vl0R/OT8j33xL+YIY2p9bKUyRtFFVGxNSe
         y463Zs4zhMmLAO6p0me3K3Tx3LOKl7TzHc2fYVpCW1FBcXB9EVIW+viDpK4zWZhn1l
         uqTv5LUIkliJvonulKt6INiHYMnMaO5pIyfDdmEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 482/772] hwrng: cn10k - Make check_rng_health() return an error code
Date:   Tue,  7 Jun 2022 19:01:14 +0200
Message-Id: <20220607165003.192732982@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Vladis Dronov <vdronov@redhat.com>

[ Upstream commit 32547a6aedda132907fcd15cdc8271429609f216 ]

Currently check_rng_health() returns zero unconditionally.
Make it to output an error code and return it.

Fixes: 38e9791a0209 ("hwrng: cn10k - Add random number generator support")
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/cn10k-rng.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/cn10k-rng.c b/drivers/char/hw_random/cn10k-rng.c
index dd226630b67d..a01e9307737c 100644
--- a/drivers/char/hw_random/cn10k-rng.c
+++ b/drivers/char/hw_random/cn10k-rng.c
@@ -31,26 +31,23 @@ struct cn10k_rng {
 
 #define PLAT_OCTEONTX_RESET_RNG_EBG_HEALTH_STATE     0xc2000b0f
 
-static int reset_rng_health_state(struct cn10k_rng *rng)
+static unsigned long reset_rng_health_state(struct cn10k_rng *rng)
 {
 	struct arm_smccc_res res;
 
 	/* Send SMC service call to reset EBG health state */
 	arm_smccc_smc(PLAT_OCTEONTX_RESET_RNG_EBG_HEALTH_STATE, 0, 0, 0, 0, 0, 0, 0, &res);
-	if (res.a0 != 0UL)
-		return -EIO;
-
-	return 0;
+	return res.a0;
 }
 
 static int check_rng_health(struct cn10k_rng *rng)
 {
 	u64 status;
-	int err;
+	unsigned long err;
 
 	/* Skip checking health */
 	if (!rng->reg_base)
-		return 0;
+		return -ENODEV;
 
 	status = readq(rng->reg_base + RNM_PF_EBG_HEALTH);
 	if (status & BIT_ULL(20)) {
@@ -58,7 +55,9 @@ static int check_rng_health(struct cn10k_rng *rng)
 		if (err) {
 			dev_err(&rng->pdev->dev, "HWRNG: Health test failed (status=%llx)\n",
 					status);
-			dev_err(&rng->pdev->dev, "HWRNG: error during reset\n");
+			dev_err(&rng->pdev->dev, "HWRNG: error during reset (error=%lx)\n",
+					err);
+			return -EIO;
 		}
 	}
 	return 0;
-- 
2.35.1



