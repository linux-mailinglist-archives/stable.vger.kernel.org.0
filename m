Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A04D4F70BC
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239027AbiDGBWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240461AbiDGBUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:20:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9B019059E;
        Wed,  6 Apr 2022 18:16:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99F8F61DCF;
        Thu,  7 Apr 2022 01:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE83DC385A8;
        Thu,  7 Apr 2022 01:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294188;
        bh=rtSw1l7QdPTLRBp089iUJcQX1L9N+GkfaDN1OeqXWJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKJd6gA5a1JKgxjHsjUk/tTNgbOV+cREJGlqIV9PSBceCH31QBHU4YA3dlEuxWnD/
         OIAGQqyRj8XrrpyJNOlx8zFUYh7pDjl5rX9PcjxoJidgT5iPoBorLa5SCUM97KwmZF
         O4pTlqq1UGnUi3Kx1pnOz8/lQeFi37umEURymbZlVwjlOsciEuj84Nm5yEkImvP873
         abepI95O6bd+nb+jA2qEXSKGWJFpDsKwbmRNyE8Hv+uG0Y6OU+3mCxYDjmcq/5V/Bh
         CuOI0ToVLaqLr/QbugxleHQREFjzI3dx0621dp7RxufR6jBqNzySSVp9uEoqwZ3ttW
         ESTMDgI3KvEtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 06/11] crypto: stm32 - fix reference leak in stm32_crc_remove
Date:   Wed,  6 Apr 2022 21:16:03 -0400
Message-Id: <20220407011609.115258-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011609.115258-1-sashal@kernel.org>
References: <20220407011609.115258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit e9a36feecee0ee5845f2e0656f50f9942dd0bed3 ]

pm_runtime_get_sync() will increment pm usage counter even it
failed. Forgetting to call pm_runtime_put_noidle will result
in reference leak in stm32_crc_remove, so we should fix it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32_crc32.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32_crc32.c b/drivers/crypto/stm32/stm32_crc32.c
index 6848f34a9e66..de645bf84980 100644
--- a/drivers/crypto/stm32/stm32_crc32.c
+++ b/drivers/crypto/stm32/stm32_crc32.c
@@ -334,8 +334,10 @@ static int stm32_crc_remove(struct platform_device *pdev)
 	struct stm32_crc *crc = platform_get_drvdata(pdev);
 	int ret = pm_runtime_get_sync(crc->dev);
 
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(crc->dev);
 		return ret;
+	}
 
 	spin_lock(&crc_list.lock);
 	list_del(&crc->list);
-- 
2.35.1

