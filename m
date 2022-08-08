Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342E858C13B
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243823AbiHHB5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244046AbiHHB4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:56:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4C26158;
        Sun,  7 Aug 2022 18:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C306B60DF3;
        Mon,  8 Aug 2022 01:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CABBC43470;
        Mon,  8 Aug 2022 01:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922815;
        bh=oSHs8yHh+tNGuzhpCCqaUU0KUfU9rV/2vXRXlTwIgaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+pydwH87gK+NS0w2NLKYXHwtjDwgMrHO/JvpnwwxDxElDcVAONOcAsCTKadZy4kH
         UEurA5Gx0yLVoRDZXcntnm21So+uDoeClqQdac+GxggHdzxt5LUqevlk8hlU9P6dLY
         Lytg9+C3KBfg2z4wEN3rAZ1/1rUDHwfGS326jXPTsVnpm0Mt/OPwGmQOcVF1IMYKz/
         Sh+ujlfPTc1pUczghBH5L8l8jc7n/iocrO30w1SsGJidiSBVi4I2X1F2E0DUiXjpkN
         Hd8OWF0RWwo3weL5T5POY+JJgNbSxALmn1kwZ753OCFUOY55rSL9OYznNQaDrlzNhC
         FVO8CWf+BlcVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 6/8] hwmon: (sht15) Fix wrong assumptions in device remove callback
Date:   Sun,  7 Aug 2022 21:40:01 -0400
Message-Id: <20220808014005.317064-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808014005.317064-1-sashal@kernel.org>
References: <20220808014005.317064-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 7d4edccc9bbfe1dcdff641343f7b0c6763fbe774 ]

Taking a lock at the beginning of .remove() doesn't prevent new readers.
With the existing approach it can happen, that a read occurs just when
the lock was taken blocking the reader until the lock is released at the
end of the remove callback which then accessed *data that is already
freed then.

To actually fix this problem the hwmon core needs some adaption. Until
this is implemented take the optimistic approach of assuming that all
readers are gone after hwmon_device_unregister() and
sysfs_remove_group() as most other drivers do. (And once the core
implements that, taking the lock would deadlock.)

So drop the lock, move the reset to after device unregistration to keep
the device in a workable state until it's deregistered. Also add a error
message in case the reset fails and return 0 anyhow. (Returning an error
code, doesn't stop the platform device unregistration and only results
in a little helpful error message before the devm cleanup handlers are
called.)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20220725194344.150098-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht15.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index a2fdbb7d20ed..3bff2dce3123 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -1040,25 +1040,20 @@ static int sht15_probe(struct platform_device *pdev)
 static int sht15_remove(struct platform_device *pdev)
 {
 	struct sht15_data *data = platform_get_drvdata(pdev);
+	int ret;
 
-	/*
-	 * Make sure any reads from the device are done and
-	 * prevent new ones beginning
-	 */
-	mutex_lock(&data->read_lock);
-	if (sht15_soft_reset(data)) {
-		mutex_unlock(&data->read_lock);
-		return -EFAULT;
-	}
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &sht15_attr_group);
+
+	ret = sht15_soft_reset(data);
+	if (ret)
+		dev_err(&pdev->dev, "Failed to reset device (%pe)\n", ERR_PTR(ret));
+
 	if (!IS_ERR(data->reg)) {
 		regulator_unregister_notifier(data->reg, &data->nb);
 		regulator_disable(data->reg);
 	}
 
-	mutex_unlock(&data->read_lock);
-
 	return 0;
 }
 
-- 
2.35.1

