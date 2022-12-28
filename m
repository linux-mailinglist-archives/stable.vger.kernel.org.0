Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7D065816E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbiL1Q2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbiL1Q2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:28:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECF81C12E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:24:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9220B81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E76C433D2;
        Wed, 28 Dec 2022 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244641;
        bh=qCQ80+QQo12orqyGZ6uPIYTEipujiuUJsbMwyPWVve8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooNOA05d4TAPzXcZabP7sKmPiJrf6lHQcWx66/MV8QpqwyJQ9ylk9ED3C1Yn4ox5i
         q1cRRLRQQA62KCruBcCwkUm7fHvZ9VjH427DlQoXDm7fmtdJ8fKPpva4/Hp63K+Ff7
         RFvznDG7nml4qwDDK0k382cp08ayoVUlWEHtKTnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0746/1073] power: supply: z2_battery: Fix possible memleak in z2_batt_probe()
Date:   Wed, 28 Dec 2022 15:38:54 +0100
Message-Id: <20221228144348.286080052@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 7ed4e4bb26ec..fd33cdf9cf12 100644
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



