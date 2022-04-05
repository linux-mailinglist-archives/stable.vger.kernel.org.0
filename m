Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1384F4657
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382522AbiDEMPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243469AbiDEKgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:36:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5800A546A7;
        Tue,  5 Apr 2022 03:22:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAFD0B81C99;
        Tue,  5 Apr 2022 10:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371DFC385A0;
        Tue,  5 Apr 2022 10:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154132;
        bh=gOYcQZhMbYIltHyjL+vacfpeKJfRnGNxkVJECrSSfcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlKoE5UGjC5Ed9eliV9cerxrTxVfxrQna6FZk71dFUTk0Ui1HNSQwNDUoU27JjraJ
         PtVCSDhwqLGrn6q8OPB2kqUZC+aUnY2MK8Rwxr1T2zJPO05a9KwS8NT54IxQhi0Bl6
         beFJNSlYky7aqpJ5myx+kQ+ci7Q62BqQ/mGrqyAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 469/599] spi: tegra20: Use of_device_get_match_data()
Date:   Tue,  5 Apr 2022 09:32:43 +0200
Message-Id: <20220405070312.783892607@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 669fc4286231..9e2b812b9025 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1006,14 +1006,8 @@ static int tegra_slink_probe(struct platform_device *pdev)
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



