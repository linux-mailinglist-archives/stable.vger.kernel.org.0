Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814275B4991
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiIJVVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiIJVUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:20:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C574F66C;
        Sat, 10 Sep 2022 14:18:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEE9E60EB6;
        Sat, 10 Sep 2022 21:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F295C43142;
        Sat, 10 Sep 2022 21:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844679;
        bh=vmKrB7uWruve/xUlBF9Cg4D2v9bGJBJGykfyeN0wSKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHn2ALugHJzaQQUWMVLERmDRhey91UF33hFkheQQ5sNxSW/Dmt5yK8pBrs1PBoMIu
         JlomFxYYs2Yeqi7IRLoIZLD3tYvlyTMfrZ9j4e/6VXLsNyyfJ1GubH3mnTHIluqJou
         R0N5g9CnGEAmT/ZiD/fIH53OZheTCCVAslu9maaBhjOt3+5zaW8SmbNVboBAwOKzOB
         hXQbiG8lUfe7hHpP5Dh7kJ7aOC9uKJ/ierhU4KzQAxgxJHnbXDfTMaz/J3llBlaRAF
         DgPX8pKg+6Jo4W1zbxYTDDqsN1eaA57tUo05C+Ryo9Ym8fkEeZv1jMVVHo2tI2QhdN
         AcpnYrqwd6qIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/21] hwmon: (pmbus) Use dev_err_probe() to filter -EPROBE_DEFER error messages
Date:   Sat, 10 Sep 2022 17:17:35 -0400
Message-Id: <20220910211752.70291-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211752.70291-1-sashal@kernel.org>
References: <20220910211752.70291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 09e52d17b72d3a4bf6951a90ccd8c97fae04e5cf ]

devm_regulator_register() can return -EPROBE_DEFER, so better use
dev_err_probe() instead of dev_err(), it is less verbose in such a case.

It is also more informative, which can't hurt.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/3adf1cea6e32e54c0f71f4604b4e98d992beaa71.1660741419.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 63b616ce3a6e9..6d5b228032cad 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -2463,11 +2463,10 @@ static int pmbus_regulator_register(struct pmbus_data *data)
 
 		rdev = devm_regulator_register(dev, &info->reg_desc[i],
 					       &config);
-		if (IS_ERR(rdev)) {
-			dev_err(dev, "Failed to register %s regulator\n",
-				info->reg_desc[i].name);
-			return PTR_ERR(rdev);
-		}
+		if (IS_ERR(rdev))
+			return dev_err_probe(dev, PTR_ERR(rdev),
+					     "Failed to register %s regulator\n",
+					     info->reg_desc[i].name);
 	}
 
 	return 0;
-- 
2.35.1

