Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4994A551C5C
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346283AbiFTNhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346282AbiFTNgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:36:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4850027FDE;
        Mon, 20 Jun 2022 06:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4546BB811E0;
        Mon, 20 Jun 2022 13:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84378C3411B;
        Mon, 20 Jun 2022 13:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730501;
        bh=ceZJEENNoKNIYwuVdeFITBK2jzsqnH64tuUTXDorleo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=opmLMnksOyktSr4u7VaN1ZTovhv2UPkgzjDXyzWj/sBlzC8mBxQo5OYLlmVOfHdIi
         1AtBuFlnB0/vBUxahI/a/02LiXklF86okzUfQhMmF7woZPrwOdC67+m6FY7p3BUvqN
         /1MwlfzrlUvHUW1UZoh1C7I2BRpEYfulm85eHTmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/106] gpio: dwapb: Dont print error on -EPROBE_DEFER
Date:   Mon, 20 Jun 2022 14:50:59 +0200
Message-Id: <20220620124725.574535879@linuxfoundation.org>
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



