Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3095BAA74
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiIPKSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbiIPKRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:17:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BC6AEDAF;
        Fri, 16 Sep 2022 03:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F5A2B8253E;
        Fri, 16 Sep 2022 10:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7207C433D6;
        Fri, 16 Sep 2022 10:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323105;
        bh=vmKrB7uWruve/xUlBF9Cg4D2v9bGJBJGykfyeN0wSKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOKVMnce6M1HHKuCHGIINIEVD4/6TY/G7r9hMaBSNDYP7r16z3y+CayhN4J4Ybs3j
         KFrLK3dmMcRlevbFxniX1OdxhBmSHBFIvDq6PhJ2GtThur4/ogznskV1ycNKy08yO3
         mChjE+/9CZZf7b9lDys6E8PrbpNsCxHcR8gyqges=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/35] hwmon: (pmbus) Use dev_err_probe() to filter -EPROBE_DEFER error messages
Date:   Fri, 16 Sep 2022 12:08:39 +0200
Message-Id: <20220916100447.621806325@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
References: <20220916100446.916515275@linuxfoundation.org>
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



