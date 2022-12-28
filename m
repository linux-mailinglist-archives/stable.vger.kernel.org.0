Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBB2658219
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbiL1QdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbiL1Qct (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A6DB1A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:29:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90383B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CD3C433D2;
        Wed, 28 Dec 2022 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244991;
        bh=fYGogO0W5og6kOolC05ykxiXLbbUq0VIOR0T8RkaTGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xdya4JT7PQGWAcDjhz2a0Mg4Fnr5E5cZh9vvu+YO0JVceDcbjdnQ4+hHJkvSK78Q3
         cmS52VXpDfYWZXvmUAuE05+NTE5G3gYKemHz5YedjwC0qPkJpgVXHLEiIZiPhLdd/H
         Gdtz22WVNZdWD/QDKt50C1gpMybnqKN+/q9GFhno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0774/1146] power: supply: z2_battery: Fix possible memleak in z2_batt_probe()
Date:   Wed, 28 Dec 2022 15:38:33 +0100
Message-Id: <20221228144351.172301188@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 955bee204f3dd307642c101b75e370662987e735 ]

If devm_gpiod_get_optional() returns error, the charger should be
freed before z2_batt_probe returns according to the context. We
fix it by just gotoing to 'err' branch.

Fixes: a3b4388ea19b ("power: supply: z2_battery: Convert to GPIO descriptors")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/z2_battery.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/z2_battery.c b/drivers/power/supply/z2_battery.c
index 1897c2984860..d033c1d3ee42 100644
--- a/drivers/power/supply/z2_battery.c
+++ b/drivers/power/supply/z2_battery.c
@@ -206,10 +206,12 @@ static int z2_batt_probe(struct i2c_client *client,
 
 	charger->charge_gpiod = devm_gpiod_get_optional(&client->dev,
 							NULL, GPIOD_IN);
-	if (IS_ERR(charger->charge_gpiod))
-		return dev_err_probe(&client->dev,
+	if (IS_ERR(charger->charge_gpiod)) {
+		ret = dev_err_probe(&client->dev,
 				     PTR_ERR(charger->charge_gpiod),
 				     "failed to get charge GPIO\n");
+		goto err;
+	}
 
 	if (charger->charge_gpiod) {
 		gpiod_set_consumer_name(charger->charge_gpiod, "BATT CHRG");
-- 
2.35.1



