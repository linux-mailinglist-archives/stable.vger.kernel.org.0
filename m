Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6044593672
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiHOSbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242913AbiHOSaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56047F5B1;
        Mon, 15 Aug 2022 11:20:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 037CBB81072;
        Mon, 15 Aug 2022 18:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C81C433C1;
        Mon, 15 Aug 2022 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587636;
        bh=4pNbcfBY7sSXixtKDEXaS8TRXL9OvdOoDNaQXO+z7ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCdt8kkcSM0oIq91A2XsJCtjegCbHdXznNsTauq72ClB3Q63mf/d0eK9LlIpi3lf1
         giN4uEKejcVJWqoS5C9Fj7imcRw9W/D2JWw1w28P3kZxC1v2NKYHfkQPplSrN+Mvq4
         Trs1CxY0tDUrjI9TBoWFpobplfsMj2XUuJKVbqVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/779] hwmon: (sht15) Fix wrong assumptions in device remove callback
Date:   Mon, 15 Aug 2022 19:56:30 +0200
Message-Id: <20220815180343.568855910@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7f4a63959730..ae4d14257a11 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -1020,25 +1020,20 @@ static int sht15_probe(struct platform_device *pdev)
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



