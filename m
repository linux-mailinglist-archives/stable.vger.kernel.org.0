Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A142D5900C4
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbiHKPq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbiHKPpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:45:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62D494EE1;
        Thu, 11 Aug 2022 08:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6650D6148F;
        Thu, 11 Aug 2022 15:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D742FC43143;
        Thu, 11 Aug 2022 15:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232371;
        bh=XlGk8IX1wN1ZNzCe5TFWky6S5v+Ns8c93X8nxKeGupM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRMyaxnj1H2R2cNQx31pgxgV/yZXCfYzCJaQ1svzDmFkIdUN0lMvm84vNz3OD7nYP
         MNd88g/PDSiejN3rNZDXUtG8cqM2JN1mZ/X1m3xcg4agCQ1TQm0GE+hDyPKD0Q2Dfx
         wxhou3ORCsjbVOS0x0hxoACEu772ANu9AOiRavIXTyskx8I4XHG+wy88sLA5aANdGs
         60pTWrpLOogzGhcA8zf9PUf2w0HWqkKsmvbG/aJzgROTtFw54JZVaMok6xgrJQjLNc
         46gMh/7LHgsyn/h6YpaX0FX2oE/2XPOiJ12eAXMOeSsaUHvUEc9alUEbuzfwx9Lx3J
         yPykjdbICWcDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuan Can <yuancan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, gilad@benyossef.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 072/105] crypto: ccree - Add missing clk_disable_unprepare() in cc_pm_resume()
Date:   Thu, 11 Aug 2022 11:27:56 -0400
Message-Id: <20220811152851.1520029-72-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 30fb034361ff1b9bfc569b2d8d66b544ea3eb18f ]

Add clk_disable_unprepare() on error path in cc_pm_resume().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_pm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index d5421b0c6831..6124fbbbed94 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -41,6 +41,7 @@ static int cc_pm_resume(struct device *dev)
 	/* wait for Cryptocell reset completion */
 	if (!cc_wait_for_reset_completion(drvdata)) {
 		dev_err(dev, "Cryptocell reset not completed");
+		clk_disable_unprepare(drvdata->clk);
 		return -EBUSY;
 	}
 
@@ -48,6 +49,7 @@ static int cc_pm_resume(struct device *dev)
 	rc = init_cc_regs(drvdata);
 	if (rc) {
 		dev_err(dev, "init_cc_regs (%x)\n", rc);
+		clk_disable_unprepare(drvdata->clk);
 		return rc;
 	}
 	/* check if tee fips error occurred during power down */
-- 
2.35.1

