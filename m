Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CAE657D7F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiL1Pn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbiL1Pn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:43:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B232717411
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69E22B8172C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BFDC433D2;
        Wed, 28 Dec 2022 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242225;
        bh=/WL07LK3cI0ugCJwgyw52PX4hwTm7I7iO8famkK5JNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZFS9wOdKi3uXFRohBOvdVILA0cJJEMsPaenkX+zHIHEJiJfA1LgbRjlem7O1a8ta
         A4mK4M+qGtv7ihfbODhR294n1b3xGP+b6CY3Oj1ZQkT/abG1h0mdBI5ZRNegYknEcX
         FCJKAFtpZdY/wAgr0QcMTozZ+VKe040h+R1/Ss9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Guru Das Srinagesh <gurus@codeaurora.org>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 577/731] mfd: pm8008: Fix return value check in pm8008_probe()
Date:   Wed, 28 Dec 2022 15:41:24 +0100
Message-Id: <20221228144313.279402224@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 14f8c55d48e02157519fbcb3a5de557abd8a06e2 ]

In case of error, the function devm_regmap_init_i2c() returns
ERR_PTR() and never returns NULL. The NULL test in the return
value check should be replaced with IS_ERR().

Fixes: 6b149f3310a4 ("mfd: pm8008: Add driver for QCOM PM8008 PMIC")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Guru Das Srinagesh <gurus@codeaurora.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221125073626.1868229-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/qcom-pm8008.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/qcom-pm8008.c b/drivers/mfd/qcom-pm8008.c
index 4b8ff947762f..9f3c4a01b4c1 100644
--- a/drivers/mfd/qcom-pm8008.c
+++ b/drivers/mfd/qcom-pm8008.c
@@ -215,8 +215,8 @@ static int pm8008_probe(struct i2c_client *client)
 
 	dev = &client->dev;
 	regmap = devm_regmap_init_i2c(client, &qcom_mfd_regmap_cfg);
-	if (!regmap)
-		return -ENODEV;
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
 
 	i2c_set_clientdata(client, regmap);
 
-- 
2.35.1



