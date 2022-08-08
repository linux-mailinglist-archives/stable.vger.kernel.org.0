Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCAAC58C088
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243320AbiHHBwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243546AbiHHBvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:51:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCA5BE26;
        Sun,  7 Aug 2022 18:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79B87B80E10;
        Mon,  8 Aug 2022 01:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D63EC43470;
        Mon,  8 Aug 2022 01:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922691;
        bh=Shks8rDUt6fwvZCiVNN+z/KX40yACmnhgAaxaywLQ9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLoHKtjlx4BBZO+ZM57CvP8F4Cc2u5QaWYWnR4Qn94fyuCQGPLp/4J0kKhjGBZ2E5
         XLjFTmstEsROghUDnmHwg2MltNIOeHt/+lx/XeJj+BtNLvygBE9M6BmWGiRkA/re2f
         l4jmc+ObKRX6cvBGgLvfxdMYzyTy/GjymeMHPe4KSQxBcy40Ri8WctYCWZO9YSLjE8
         lMZJu+jFzk3uVMsMbcVcRf6PXaWbM5lF5NXqRpbKUMr9aBPCBxJHr7pcvIiEFAbsUR
         zDnPJ35pPDa1ERlixZ8IGqcL29mrVcRDeJNUqLOBxAjyst3Nl4HdpuOiCtdm5m3K3b
         M6ugJWV4ZtV3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Mengqi <guomengqi3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, masahisa.kojima@linaro.org,
        jaswinder.singh@linaro.org, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/29] spi: synquacer: Add missing clk_disable_unprepare()
Date:   Sun,  7 Aug 2022 21:37:27 -0400
Message-Id: <20220808013741.316026-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013741.316026-1-sashal@kernel.org>
References: <20220808013741.316026-1-sashal@kernel.org>
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

From: Guo Mengqi <guomengqi3@huawei.com>

[ Upstream commit 917e43de2a56d9b82576f1cc94748261f1988458 ]

Add missing clk_disable_unprepare() in synquacer_spi_resume().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Guo Mengqi <guomengqi3@huawei.com>
Link: https://lore.kernel.org/r/20220624005614.49434-1-guomengqi3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-synquacer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-synquacer.c b/drivers/spi/spi-synquacer.c
index ea706d9629cb..47cbe73137c2 100644
--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -783,6 +783,7 @@ static int __maybe_unused synquacer_spi_resume(struct device *dev)
 
 		ret = synquacer_spi_enable(master);
 		if (ret) {
+			clk_disable_unprepare(sspi->clk);
 			dev_err(dev, "failed to enable spi (%d)\n", ret);
 			return ret;
 		}
-- 
2.35.1

