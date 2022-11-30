Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C45763DF48
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiK3Spo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiK3SpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:45:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAD82DAA8
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:45:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 78430CE1AD9
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D1AC433C1;
        Wed, 30 Nov 2022 18:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833916;
        bh=hwsXXzyotk1egyR3tSMYFR8ZY5nABiVPuesxAzYeNjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAAffZ9W2UAAtfFPCn4unzOlA3BqffEwnVnhaEOq1+GEGuh8r8INa6OGYKOj8/87p
         3XKW+G96C4EryD0jDVikxvAfZD/rLWakQdwOxFM0Ou0CkkbOwoTTrluGpXUh6wtz0Q
         RLNdRQdPPLTxG1yr8Izwx7ez0FM8bAQlYjqJ3VZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 062/289] regulator: core: fix kobject release warning and memory leak in regulator_register()
Date:   Wed, 30 Nov 2022 19:20:47 +0100
Message-Id: <20221130180545.536266975@linuxfoundation.org>
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

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 5f4b204b6b8153923d5be8002c5f7082985d153f ]

Here is a warning report about lack of registered release()
from kobject lib:

Device '(null)' does not have a release() function, it is broken and must be fixed.
WARNING: CPU: 0 PID: 48430 at drivers/base/core.c:2332 device_release+0x104/0x120
Call Trace:
 kobject_put+0xdc/0x180
 put_device+0x1b/0x30
 regulator_register+0x651/0x1170
 devm_regulator_register+0x4f/0xb0

When regulator_register() returns fail and directly goto `clean` symbol,
rdev->dev has not registered release() function yet (which is registered
by regulator_class in the following), so rdev needs to be freed manually.
If rdev->dev.of_node is not NULL, which means the of_node has gotten by
regulator_of_get_init_data(), it needs to call of_node_put() to avoid
refcount leak.

Otherwise, only calling put_device() would lead memory leak of rdev
in further:

unreferenced object 0xffff88810d0b1000 (size 2048):
  comm "107-i2c-rtq6752", pid 48430, jiffies 4342258431 (age 1341.780s)
  backtrace:
    kmalloc_trace+0x22/0x110
    regulator_register+0x184/0x1170
    devm_regulator_register+0x4f/0xb0

When regulator_register() returns fail and goto `wash` symbol,
rdev->dev has registered release() function, so directly call
put_device() to cleanup everything.

Fixes: d3c731564e09 ("regulator: plug of_node leak in regulator_register()'s error path")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Link: https://lore.kernel.org/r/20221116074339.1024240-1-zengheng4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c3871565fd7d..5f82a996dbea 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5616,11 +5616,15 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	mutex_lock(&regulator_list_mutex);
 	regulator_ena_gpio_free(rdev);
 	mutex_unlock(&regulator_list_mutex);
+	put_device(&rdev->dev);
+	rdev = NULL;
 clean:
 	if (dangling_of_gpiod)
 		gpiod_put(config->ena_gpiod);
+	if (rdev && rdev->dev.of_node)
+		of_node_put(rdev->dev.of_node);
+	kfree(rdev);
 	kfree(config);
-	put_device(&rdev->dev);
 rinse:
 	if (dangling_cfg_gpiod)
 		gpiod_put(cfg->ena_gpiod);
-- 
2.35.1



