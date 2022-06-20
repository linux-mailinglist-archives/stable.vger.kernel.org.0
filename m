Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6D8551C92
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343677AbiFTNYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345781AbiFTNYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:24:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA6C228;
        Mon, 20 Jun 2022 06:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1E43B811CB;
        Mon, 20 Jun 2022 13:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFF0C3411B;
        Mon, 20 Jun 2022 13:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730523;
        bh=ni7uSd0ziEG5gbRMaDnpNk2R56zF5Go17AlnR1BptgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdpDdfRhudSoTj6erlKE0RtEw53Zd9qTcPCeCskvCm+f44XHKxytR13V4lPExSso1
         Lm3AEC37YnaRH+V9AqTkr2wBMwoBdJgmhQEsv8T9MxRHOEAo6pEppkQvbWLTNw2/kB
         MW4upaOqDsPNH6xO/KtLNh/73bXYxUXNm9Ul0BZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/106] i2c: designware: Use standard optional ref clock implementation
Date:   Mon, 20 Jun 2022 14:51:39 +0200
Message-Id: <20220620124726.762400792@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 27071b5cbca59d8e8f8750c199a6cbf8c9799963 ]

Even though the DW I2C controller reference clock source is requested by
the method devm_clk_get() with non-optional clock requirement the way the
clock handler is used afterwards has a pure optional clock semantic
(though in some circumstances we can get a warning about the clock missing
printed in the system console). There is no point in reimplementing that
functionality seeing the kernel clock framework already supports the
optional interface from scratch. Thus let's convert the platform driver to
using it.

Note by providing this commit we get to fix two problems. The first one
was introduced in commit c62ebb3d5f0d ("i2c: designware: Add support for
an interface clock"). It causes not having the interface clock (pclk)
enabled/disabled in case if the reference clock isn't provided. The second
problem was first introduced in commit b33af11de236 ("i2c: designware: Do
not require clock when SSCN and FFCN are provided"). Since that
modification the deferred probe procedure has been unsupported in case if
the interface clock isn't ready.

Fixes: c62ebb3d5f0d ("i2c: designware: Add support for an interface clock")
Fixes: b33af11de236 ("i2c: designware: Do not require clock when SSCN and FFCN are provided")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-common.c  |  3 ---
 drivers/i2c/busses/i2c-designware-platdrv.c | 13 +++++++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index bf2a4920638a..a1100e37626e 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -477,9 +477,6 @@ int i2c_dw_prepare_clk(struct dw_i2c_dev *dev, bool prepare)
 {
 	int ret;
 
-	if (IS_ERR(dev->clk))
-		return PTR_ERR(dev->clk);
-
 	if (prepare) {
 		/* Optional interface clock */
 		ret = clk_prepare_enable(dev->pclk);
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 21113665ddea..718bebe4fb87 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -262,8 +262,17 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 		goto exit_reset;
 	}
 
-	dev->clk = devm_clk_get(&pdev->dev, NULL);
-	if (!i2c_dw_prepare_clk(dev, true)) {
+	dev->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(dev->clk)) {
+		ret = PTR_ERR(dev->clk);
+		goto exit_reset;
+	}
+
+	ret = i2c_dw_prepare_clk(dev, true);
+	if (ret)
+		goto exit_reset;
+
+	if (dev->clk) {
 		u64 clk_khz;
 
 		dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
-- 
2.35.1



