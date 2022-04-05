Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9444F397E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbiDELev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351925AbiDEKDb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:03:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF90A0BD3;
        Tue,  5 Apr 2022 02:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AB4D616D0;
        Tue,  5 Apr 2022 09:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DBDC385A3;
        Tue,  5 Apr 2022 09:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152353;
        bh=mNU03RKrGsnhzrcliWEfwHVOO2UBDTTyYWKYpovJnz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKX8R5E2ep9BFWCBFi59DEh4gs6OvlPqRD6DDLDc1WpI/YTrpQfm0mmcb9bHzQl69
         W0W7UgcAXLnlR3gVIti0umqf/+qd2VtWcrMNZT4Kjp8N/kgw55sjYrxhzo98ZQB+8n
         Id0h0s7FSDzJ48LftyAjGwIIkXcGHrX1Cvv6tUUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 708/913] spi: tegra20: Use of_device_get_match_data()
Date:   Tue,  5 Apr 2022 09:29:30 +0200
Message-Id: <20220405070401.057175696@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Minghao Chi <chi.minghao@zte.com.cn>

[ Upstream commit c9839acfcbe20ce43d363c2a9d0772472d9921c0 ]

Use of_device_get_match_data() to simplify the code.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Link: https://lore.kernel.org/r/20220315023138.2118293-1-chi.minghao@zte.com.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-slink.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 3226c4e1c7c0..3b44ca455049 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1003,14 +1003,8 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	struct resource		*r;
 	int ret, spi_irq;
 	const struct tegra_slink_chip_data *cdata = NULL;
-	const struct of_device_id *match;
 
-	match = of_match_device(tegra_slink_of_match, &pdev->dev);
-	if (!match) {
-		dev_err(&pdev->dev, "Error: No device match found\n");
-		return -ENODEV;
-	}
-	cdata = match->data;
+	cdata = of_device_get_match_data(&pdev->dev);
 
 	master = spi_alloc_master(&pdev->dev, sizeof(*tspi));
 	if (!master) {
-- 
2.34.1



