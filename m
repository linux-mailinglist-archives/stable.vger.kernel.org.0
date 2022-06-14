Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4515554A5EF
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353510AbiFNCPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353885AbiFNCOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:14:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC2C3B01D;
        Mon, 13 Jun 2022 19:08:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 554DCB80D19;
        Tue, 14 Jun 2022 02:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8698C385A2;
        Tue, 14 Jun 2022 02:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172489;
        bh=ceZJEENNoKNIYwuVdeFITBK2jzsqnH64tuUTXDorleo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nK++9ItlsrdHcf5fC6uICR/y9Wp1RKRhoGNHb1ELPpi+poNvStauMsRPLbA+N0EeO
         IJ2dn18U519m3C519w9wDXrTQKUS9FeU1n8zbgWjlnYTfNirloG5sa1dymvbfK10xs
         rRiETPIElnG8r+Knbw/mUfxEi6XFX2CfCovCPU7JDhc1+/HSSsomoe1AkdNuF2gYdF
         QwK82UJahqVh2jlBXwfCClw8+wxacksef5AEey8GB7wjDNA/Diq6DxwXVtXrSnRJaz
         PDpbEuzBxknIz877Zn0kJvpuliOtSeja2D6apxJI6ZxeTSkhw+tiA/U0ggpdoDNZnF
         3aGFpzXfjjPoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>, linus.walleij@linaro.org,
        gnurou@gmail.com, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 37/41] gpio: dwapb: Don't print error on -EPROBE_DEFER
Date:   Mon, 13 Jun 2022 22:07:02 -0400
Message-Id: <20220614020707.1099487-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020707.1099487-1-sashal@kernel.org>
References: <20220614020707.1099487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 77006f6edc0e0f58617eb25e53731f78641e820d ]

Currently if the APB or Debounce clocks aren't yet ready to be requested
the DW GPIO driver will correctly handle that by deferring the probe
procedure, but the error is still printed to the system log. It needlessly
pollutes the log since there was no real error but a request to postpone
the clock request procedure since the clocks subsystem hasn't been fully
initialized yet. Let's fix that by using the dev_err_probe method to print
the APB/clock request error status. It will correctly handle the deferred
probe situation and print the error if it actually happens.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-dwapb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index f98fa33e1679..e981e7a46fc1 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -653,10 +653,9 @@ static int dwapb_get_clks(struct dwapb_gpio *gpio)
 	gpio->clks[1].id = "db";
 	err = devm_clk_bulk_get_optional(gpio->dev, DWAPB_NR_CLOCKS,
 					 gpio->clks);
-	if (err) {
-		dev_err(gpio->dev, "Cannot get APB/Debounce clocks\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(gpio->dev, err,
+				     "Cannot get APB/Debounce clocks\n");
 
 	err = clk_bulk_prepare_enable(DWAPB_NR_CLOCKS, gpio->clks);
 	if (err) {
-- 
2.35.1

