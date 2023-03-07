Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BFB6AEAB6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjCGRgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbjCGRgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:36:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5094FA72B1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:32:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BD2161514
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C5BC433D2;
        Tue,  7 Mar 2023 17:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210332;
        bh=+HR9jXVGjFFlB/GhQyLngXKC9rBZihLHjHk+QGfRUOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7iSP6B/Wprnj3ffAL9P6QtNFHlPn9E70PAA1Y5Is6OF6sJ/8anMDlFJsxvRbBgSj
         6w+JiU3US84c+9teuVMLBhqBo1gxbouucJIJJmNDTOZOQu/QPPzleYvzKqb8zSjXpg
         gmmI8WqyE2KG+RRmeCnKtdR2vFwh0R0ZqXF08z8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ferry Toth <ftoth@exalondelft.nl>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0490/1001] iio: light: tsl2563: Do not hardcode interrupt trigger type
Date:   Tue,  7 Mar 2023 17:54:22 +0100
Message-Id: <20230307170042.652177548@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ferry Toth <ftoth@exalondelft.nl>

[ Upstream commit 027641b52fe37b64af61025298ce160c8b9b7a73 ]

Instead of hardcoding IRQ trigger type to IRQF_TRIGGER_RAISING,
let's respect the settings specified in the firmware description.
To be compatible with the older firmware descriptions, if trigger
type is not set up there, we'll set it to default (raising edge).

Fixes: 388be4883952 ("staging:iio: tsl2563 abi fixes and interrupt handling")
Fixes: bdab1001738f ("staging:iio:light:tsl2563 remove old style event registration.")
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221207190348.9347-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/tsl2563.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/light/tsl2563.c b/drivers/iio/light/tsl2563.c
index d0e42b73203a6..71302ae864d99 100644
--- a/drivers/iio/light/tsl2563.c
+++ b/drivers/iio/light/tsl2563.c
@@ -704,6 +704,7 @@ static int tsl2563_probe(struct i2c_client *client)
 	struct iio_dev *indio_dev;
 	struct tsl2563_chip *chip;
 	struct tsl2563_platform_data *pdata = client->dev.platform_data;
+	unsigned long irq_flags;
 	int err = 0;
 	u8 id = 0;
 
@@ -759,10 +760,15 @@ static int tsl2563_probe(struct i2c_client *client)
 		indio_dev->info = &tsl2563_info_no_irq;
 
 	if (client->irq) {
+		irq_flags = irq_get_trigger_type(client->irq);
+		if (irq_flags == IRQF_TRIGGER_NONE)
+			irq_flags = IRQF_TRIGGER_RISING;
+		irq_flags |= IRQF_ONESHOT;
+
 		err = devm_request_threaded_irq(&client->dev, client->irq,
 					   NULL,
 					   &tsl2563_event_handler,
-					   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					   irq_flags,
 					   "tsl2563_event",
 					   indio_dev);
 		if (err) {
-- 
2.39.2



