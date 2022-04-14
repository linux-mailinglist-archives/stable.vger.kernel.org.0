Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BA95010AE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345817AbiDNNyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345330AbiDNNpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:45:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DDD2DE0;
        Thu, 14 Apr 2022 06:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E43DBB828E6;
        Thu, 14 Apr 2022 13:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B92AC385A5;
        Thu, 14 Apr 2022 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943807;
        bh=xbI6SF3AS1uEAFxgbMH2vX6QKFyd3eXgDbqdslNprtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPlom1EY2fyyo5RBaDUfDh5oIxf/ZfD3mvj2vdh8RWJYsTqd9NCm79JCKEURSpFUI
         K1EWlxL48FOKpzkCvkJvJKB501JZr8lOhpKQu5XYi0bk8N4T9pcDVqg9jj7Obka2pB
         dxS491suJguHaraaLN+a8ubqO5wJPWcBPLaYqpk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 288/475] spi: tegra20: Use of_device_get_match_data()
Date:   Thu, 14 Apr 2022 15:11:13 +0200
Message-Id: <20220414110903.157658649@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index 9b59539c8735..e6b12f78c8f0 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1011,14 +1011,8 @@ static int tegra_slink_probe(struct platform_device *pdev)
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



