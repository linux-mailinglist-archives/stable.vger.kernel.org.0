Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DF258C03B
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbiHHBte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243047AbiHHBsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:48:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1295717074;
        Sun,  7 Aug 2022 18:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3256A60DF3;
        Mon,  8 Aug 2022 01:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9395DC433D7;
        Mon,  8 Aug 2022 01:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922625;
        bh=Shks8rDUt6fwvZCiVNN+z/KX40yACmnhgAaxaywLQ9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYr8P4BaCn3w3SOw0iUCY9M723S6hmHBHSgkCsU42nuM12zdmyPhji19kmdZTeqtA
         mvVqyYH2jhqyCYm6MV6X9WmXq66QqWSzy8nsgy5ppJyHB+6Q2g1M77pvY4JkDlVVD7
         sk9mjdBdFSIRMs2etStGXuJeWl+RjPndfZXLuPkZihUPEXzosl6ElihNKQP5Kp0qo1
         6UmvCOPEj7G25k9RfzuWDPXaejdknPYGc18XNWLaQKEhv0zbx2CJMUwJmbmebvN5g0
         tsscraTaoXaRKejoUEVST7P0AOfY7XKwSp3UshBZXXLJDrDJZkiqivbDj/m1DGA/Y8
         LoGvUV9QXD+Ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Mengqi <guomengqi3@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, masahisa.kojima@linaro.org,
        jaswinder.singh@linaro.org, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 27/45] spi: synquacer: Add missing clk_disable_unprepare()
Date:   Sun,  7 Aug 2022 21:35:31 -0400
Message-Id: <20220808013551.315446-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013551.315446-1-sashal@kernel.org>
References: <20220808013551.315446-1-sashal@kernel.org>
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

