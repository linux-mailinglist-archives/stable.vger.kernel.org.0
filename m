Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5403D6246C1
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 17:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiKJQUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 11:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiKJQUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 11:20:54 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464B51A220
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 08:20:53 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id v27so3879042eda.1
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 08:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GdcwK+eSzO30vZBClseX8YSlW2qnvr/aVA4Sk8Y6wrQ=;
        b=lmQabTN+8QKCKz3yUXpojvxqRdJ0oba9J5peWD98OhgJBpoScBRYh42GKxHS+y8UB2
         yIKE0QAXtaW0k8pTtrX/nLC1Lri7rsFdO8d4/zQ8QbEy8nOmW0WgijsPd5zkNLLxuV+t
         KkVkkGeSN3s2/O7zCdBkax+rCf9Ixjq3ZogN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GdcwK+eSzO30vZBClseX8YSlW2qnvr/aVA4Sk8Y6wrQ=;
        b=Fs7etQp7HfK06xtoMdqZEnlHPbAn05FKpISygj1bZoldxCh6S7bx8RR/XtvNwUY9IS
         tauUDHqfU81Ze2e23uxAnuF9zrS/q4AqwcCdNMJIqXCds67whBD0FSVfGECv3kQmDOwH
         kE0VOs7Tp8jGIUoUhMT36OsTT8uur88niJBXBpokj8hBu/SLK/f/Y7/lZaA8Z4IOf9TO
         LKZvrD+PCNKyQD4JQgAr4kU9bKv/N9GAtnMY5g899GyajN8uWZCZRHR3+wg8rYWhErPH
         aZp/w5QRMjBolfwmK43N4TTUDwo+NtIpF75lhp07JA85mdiBUJgPJgKyPsIjpXr/cJsd
         hDdQ==
X-Gm-Message-State: ACrzQf3UQ554U9UN4IQloHxb2JeVytP3LdrXSbxg10yFo8erWL3Wpj7a
        QiIGLo4BuAXE4ckPTpbOnGSLtQ==
X-Google-Smtp-Source: AMsMyM5u0AucTDgFazcQOyxq64FNJZJA0ahmrgw+9JbSpU2NfaEJmobqXoMZDcf1vTuX5eKi01EZQw==
X-Received: by 2002:a50:ee0a:0:b0:463:4055:9db4 with SMTP id g10-20020a50ee0a000000b0046340559db4mr57833736eds.421.1668097251847;
        Thu, 10 Nov 2022 08:20:51 -0800 (PST)
Received: from alco.roam.corp.google.com (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id e8-20020a170906314800b0077b2b0563f4sm7510193eje.173.2022.11.10.08.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 08:20:51 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Thu, 10 Nov 2022 17:20:39 +0100
Subject: [PATCH v5 1/1] i2c: Restore initial power state when we are done.
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221109-i2c-waive-v5-1-2839667f8f6a@chromium.org>
References: <20221109-i2c-waive-v5-0-2839667f8f6a@chromium.org>
In-Reply-To: <20221109-i2c-waive-v5-0-2839667f8f6a@chromium.org>
To:     Wolfram Sang <wsa@kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     Hidenori Kobayashi <hidenorik@google.com>, stable@vger.kernel.org,
        linux-i2c@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.11.0-dev-d93f8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3480; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=9UR0KCXvwEGgujXcvLJmsWuhlTeEco5WrFDyZoXy7AI=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjbSTgboLbO7ZKUNyOCb+DSb6zrvX6p3V3qvjb0Dep
 c13lUQqJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY20k4AAKCRDRN9E+zzrEiKPmD/
 9XgjLs771QO8mKlJcCcef36CvrMZYad411S3jgS5KkVZ+fCAsqbqI3ePJkT3YoCFYx8YbDys/6r4ZZ
 WJoSp4E56UsqFHMnoZuT3WSklxFlHi8wKP83gQbtl8+xjEc1FA31q6ka4Jd2NXFFGVki4CGGohBzrq
 3qzt1gww3cD+4OOO9j8m44K6g704YfvSHWi5DDmPLBNe4bqSoteOMebCWW5HHMLLaOGRJwcGBvTTGM
 ShdJ9sRFlp8bA+cROI4sp5Dk38ccJsB0H9zUlKLWNZ4YuayFE7TS2zE6ZjZGsK69MN32gx57MRUyBp
 2tD9Jk6Q7CbJ2ZwsgfXWHm18mOmHzJg2mAHXBSE0FNtGU/aPobxfIf7flwRdXpeMz5MqwhfBbvgWv2
 bwmQPrUhgQtXpfYZ9+Od9HEv1ujxG/T99EE4+P4zhdMntWI/oBCT/O1OFhtXh+ENmBOjeyt5q2Bt5P
 JfmC9AXP4slsUZIboJ+aj7oW+v1thlCzibQottue2bAEHe+cwQ1rPk9mLZIx2xTHwdz3ktwFDKnfOD
 o57+Al4ZKMRAQdHmpTX/Fj5fxTnQpDKdYi6lAto1xdlVYj1HqvV7TeBPX/s/iLrif2ULZMZ7vOyF3P
 UFxLj6HBEs8egC0lL2oHkmG6abnaAtCcgmJGexUA089A514jxjUc9xVJSSkg==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A driver that supports I2C_DRV_ACPI_WAIVE_D0_PROBE is not expected to
power off a device that it has not powered on previously.

For devices operating in "full_power" mode, the first call to
`i2c_acpi_waive_d0_probe` will return 0, which means that the device
will be turned on with `dev_pm_domain_attach`.

If probe fails or the device is removed the second call to
`i2c_acpi_waive_d0_probe` will return 1, which means that the device
will not be turned off. This is, it will be left in a different power
state. Lets fix it.

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org
Fixes: b18c1ad685d9 ("i2c: Allow an ACPI driver to manage the device's power state during probe")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index b4edf10e8fd0..6f4974c76404 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -467,6 +467,7 @@ static int i2c_device_probe(struct device *dev)
 {
 	struct i2c_client	*client = i2c_verify_client(dev);
 	struct i2c_driver	*driver;
+	bool do_power_on;
 	int status;
 
 	if (!client)
@@ -545,8 +546,8 @@ static int i2c_device_probe(struct device *dev)
 	if (status < 0)
 		goto err_clear_wakeup_irq;
 
-	status = dev_pm_domain_attach(&client->dev,
-				      !i2c_acpi_waive_d0_probe(dev));
+	do_power_on = !i2c_acpi_waive_d0_probe(dev);
+	status = dev_pm_domain_attach(&client->dev, do_power_on);
 	if (status)
 		goto err_clear_wakeup_irq;
 
@@ -580,12 +581,14 @@ static int i2c_device_probe(struct device *dev)
 	if (status)
 		goto err_release_driver_resources;
 
+	client->power_off_on_remove = do_power_on;
+
 	return 0;
 
 err_release_driver_resources:
 	devres_release_group(&client->dev, client->devres_group_id);
 err_detach_pm_domain:
-	dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
+	dev_pm_domain_detach(&client->dev, do_power_on);
 err_clear_wakeup_irq:
 	dev_pm_clear_wake_irq(&client->dev);
 	device_init_wakeup(&client->dev, false);
@@ -610,7 +613,7 @@ static void i2c_device_remove(struct device *dev)
 
 	devres_release_group(&client->dev, client->devres_group_id);
 
-	dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
+	dev_pm_domain_detach(&client->dev, client->power_off_on_remove);
 
 	dev_pm_clear_wake_irq(&client->dev);
 	device_init_wakeup(&client->dev, false);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index f7c49bbdb8a1..eba83bc5459e 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -326,6 +326,8 @@ struct i2c_driver {
  *	calls it to pass on slave events to the slave driver.
  * @devres_group_id: id of the devres group that will be created for resources
  *	acquired when probing this device.
+ * @power_off_on_remove: Record if we have turned on the device before probing
+ *	so we can turn off the device at removal.
  *
  * An i2c_client identifies a single device (i.e. chip) connected to an
  * i2c bus. The behaviour exposed to Linux is defined by the driver
@@ -355,6 +357,8 @@ struct i2c_client {
 	i2c_slave_cb_t slave_cb;	/* callback for slave mode	*/
 #endif
 	void *devres_group_id;		/* ID of probe devres group	*/
+	bool power_off_on_remove;	/* if device needs to be turned	*/
+					/* off by framework at removal	*/
 };
 #define to_i2c_client(d) container_of(d, struct i2c_client, dev)
 

-- 
b4 0.11.0-dev-d93f8
