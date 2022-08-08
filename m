Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEB358C073
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243240AbiHHBwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243655AbiHHBvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:51:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC91819C2D;
        Sun,  7 Aug 2022 18:38:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C9AF60E89;
        Mon,  8 Aug 2022 01:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDABC43141;
        Mon,  8 Aug 2022 01:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922705;
        bh=4pNbcfBY7sSXixtKDEXaS8TRXL9OvdOoDNaQXO+z7ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q630WT6m4/g02DG18BXvQIaArvlFx68k+zZT8XhOcbtRchaUf0FZGWmQbo8teh2bH
         wJKEFv+dfxKl9M/JG37nsdB+N6uU/p7IolZZWorK2McCFk+z5ygqZyryCoYpe2BH/1
         v1om5EHJLa9iWj+3vDXXyio7bXO5wLAANk/LxHIWPW1zi3nVsGSETM3F7qPSXoPMY1
         YYL5izXG2byDGuUT+J9CgdwWxuHI/k5Lwg176D1dp/H5/kI8kQP93mLHVYYFfm+5XF
         jsdjn2ex0WnBewuclRjzOvndyhiO8zhVviMi12BV1jqEW4j50NGBOV+A1WNQbA+w92
         9vZMCZ/6Q+vWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/29] hwmon: (sht15) Fix wrong assumptions in device remove callback
Date:   Sun,  7 Aug 2022 21:37:37 -0400
Message-Id: <20220808013741.316026-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013741.316026-1-sashal@kernel.org>
References: <20220808013741.316026-1-sashal@kernel.org>
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

