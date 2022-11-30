Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66A863DF51
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiK3SqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiK3Spt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:45:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7B12EF04
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:45:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1820D61D73
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A33EC433D6;
        Wed, 30 Nov 2022 18:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833938;
        bh=cmGg9lO5EOzcd0xbELic2ofZBztqV9txlHtyEbKMqsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WS1WiPs4rI1hLNwmvOyYhjwtgNFQM9L44MW7IGjziUWehOCydyX/C8qwyB1Xi5t7c
         QiZlU5iYWfg7iL4vvDTJCtxnFCe2VP3z1D8O4fp9n8EBQM9hz6F1dsvi8abmCsOEim
         yad6BJParydqvT1o7dfszlzowpkz0YJJbEf+ZQfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 069/289] spi: tegra210-quad: Fix duplicate resource error
Date:   Wed, 30 Nov 2022 19:20:54 +0100
Message-Id: <20221130180545.694098990@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

[ Upstream commit 2197aa6b0aa236b9896a09b9d08d6924d18b84f6 ]

controller data alloc is done with client device data causing duplicate
resource error. Allocate memory using controller device when using devm

Fixes: f89d2cc3967a ("spi: tegra210-quad: use devm call for cdata memory")

Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20221117070320.18720-1-kyarlagadda@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 10f0c5a6e0dc..9f356612ba7e 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -924,8 +924,9 @@ static int tegra_qspi_start_transfer_one(struct spi_device *spi,
 static struct tegra_qspi_client_data *tegra_qspi_parse_cdata_dt(struct spi_device *spi)
 {
 	struct tegra_qspi_client_data *cdata;
+	struct tegra_qspi *tqspi = spi_master_get_devdata(spi->master);
 
-	cdata = devm_kzalloc(&spi->dev, sizeof(*cdata), GFP_KERNEL);
+	cdata = devm_kzalloc(tqspi->dev, sizeof(*cdata), GFP_KERNEL);
 	if (!cdata)
 		return NULL;
 
-- 
2.35.1



