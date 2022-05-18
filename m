Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B0C52C0BD
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 19:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240290AbiERQfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 12:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240350AbiERQfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 12:35:00 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116C81FB576;
        Wed, 18 May 2022 09:34:55 -0700 (PDT)
Received: from tr.lan (ip-86-49-12-201.net.upcbroadband.cz [86.49.12.201])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 8BA0584293;
        Wed, 18 May 2022 18:34:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1652891693;
        bh=I/UAMHKRHLAz0ec0igZgJ+KfCIC77AzCAKBjSNJB0oQ=;
        h=From:To:Cc:Subject:Date:From;
        b=nUZTshLt4oNrfnbn4ORq0ZfQmmJ9VkF2+uQw7344//wsH4iLieaNXpsq2E2ZF3Coe
         lkZ6A0wMhmGYb7p3T73OO9BEOkRq27ZPE8Ah/rJ/xOzAo5FR47DT2Am/EPB2dyEW07
         +CuZT9Km8Hh6ZPbDcYpJa+wSl599aqo2q9WrfODdF+AU3s1sUMLaMszKcZwBP8PQQ+
         S5NHC5Oyab6/bsBjAOTHdZ1mwO7UvUSpj7K9H1UcMM/X4R5BDPORyP5G74g1I/PE5v
         EU6x/vkOx+Al1UT/eZ34ENOZK9T3Qvzh1UpMTPEzJHHkBRmxSq7PZtAsXn/f03eudK
         h6JBglMpmIUsA==
From:   Marek Vasut <marex@denx.de>
To:     linux-input@vger.kernel.org
Cc:     stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] Input: ili210x - Fix reset timing
Date:   Wed, 18 May 2022 18:34:30 +0200
Message-Id: <20220518163430.41192-1-marex@denx.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to Ilitek "231x & ILI251x Programming Guide" Version: 2.30
"2.1. Power Sequence", "T4 Chip Reset and discharge time" is minimum
10ms and "T2 Chip initial time" is maximum 150ms. Adjust the reset
timings such that T4 is 15ms and T2 is 160ms to fit those figures.

This prevents sporadic touch controller start up failures when some
systems with at least ILI251x controller boot, without this patch
the systems sometimes fail to communicate with the touch controller.

Fixes: 201f3c803544c ("Input: ili210x - add reset GPIO support")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/ili210x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/ili210x.c b/drivers/input/touchscreen/ili210x.c
index 2bd407d86bae5..131cb648a82ae 100644
--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -951,9 +951,9 @@ static int ili210x_i2c_probe(struct i2c_client *client,
 		if (error)
 			return error;
 
-		usleep_range(50, 100);
+		msleep(15);
 		gpiod_set_value_cansleep(reset_gpio, 0);
-		msleep(100);
+		msleep(160);
 	}
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-- 
2.35.1

