Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E6F627D8E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbiKNMUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237114AbiKNMUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:20:51 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8116B23171
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:20:49 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ft34so27751615ejc.12
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NXTfftd5xWKKp33nFP7X0CH1DPM11ekgxqWBKgLeVyk=;
        b=UyNyOvb73DVmmdW4A6hUI7xOJ4F5Us/ZAk8Oqo9EG8VFaLxxLKlo5jNKM83PhMn8ZR
         BTf2wzXNaRbeDdFleR60losKp5kaoHjGMcSanDaDbd72yS1w9apSMh0TENIHpym8c3gx
         4QOrTpOY/fLmBKSHZzFi/JkW6THJbTGDRupC8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NXTfftd5xWKKp33nFP7X0CH1DPM11ekgxqWBKgLeVyk=;
        b=hlUQS4Ux/e5r33gL66KCelbbrXo3//Y5GKJX3YvSRN7nZBDOKQDvfoS8VDiw/D+qTK
         tapyun7/u7TqxMF/XlRFyp/xndiAfPIibn5NR+jhVj6DbSL1vttljRjb2XkfBmilFGpV
         skTkaf++5oKMMBF8LX9KqJcGOjM+gCavFQiz1k6bzTQK2bZa880DQ1oNrcJp/FKEdWYP
         AfmG41Di/qcE5b6X8jByWrKIstgF+AEYuUQvKWHFunqk4knYG7UG+gJ+xenfZCiHjEOZ
         cgn/4P7q2P09VV5EJogBQ8VcQ5a2s6NJfV7U68fX8EPC0quyZELERKfL58cZOB67zo2M
         7a7g==
X-Gm-Message-State: ANoB5pnXcYXNA4/B29PNnpMSL5I/oFsb91FiX1Uj7SEd7AznhEgc35jT
        q0ifCnNxxtLE67gqrl9t4BL40A==
X-Google-Smtp-Source: AA0mqf5Ht/3BL0OuAwlHt8jP8JpfLV/F97qpyxulz4U4uDihYbO+0TBkPaDxY2XKrdJ8Md5nlJk+pg==
X-Received: by 2002:a17:906:8587:b0:78d:b367:20c1 with SMTP id v7-20020a170906858700b0078db36720c1mr9487437ejx.530.1668428448108;
        Mon, 14 Nov 2022 04:20:48 -0800 (PST)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:c205:5c4e:7456:c8cc])
        by smtp.gmail.com with ESMTPSA id v19-20020aa7cd53000000b0045bd14e241csm4718483edw.76.2022.11.14.04.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 04:20:47 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 14 Nov 2022 13:20:34 +0100
Subject: [PATCH v6 1/1] i2c: Restore initial power state if probe fails
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20221109-i2c-waive-v6-1-bc059fb7e8fa@chromium.org>
References: <20221109-i2c-waive-v6-0-bc059fb7e8fa@chromium.org>
In-Reply-To: <20221109-i2c-waive-v6-0-bc059fb7e8fa@chromium.org>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>
Cc:     Hidenori Kobayashi <hidenorik@chromium.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-kernel@vger.kernel.org,
        Hidenori Kobayashi <hidenorik@google.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        linux-i2c@vger.kernel.org
X-Mailer: b4 0.11.0-dev-d93f8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2430; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=gQQQ17pxlEydPjxn9eYK5duBq8Uy+tbFVh7ak1smjBs=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjcjKcATxE9rHnIjhO8bAZEgAp2AddQ2TEduJ2Jkyo
 yDF+Q9mJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY3IynAAKCRDRN9E+zzrEiG4vD/
 9Txh5QCN7Z+PkLIS7rncSO86jir/kGHzeNS3F1NBsG9Jqnj/cX7dEntCPT9ctXq04nDN+aHanNgNfr
 4fU3Wsa9VIwChG2DMKlxbSlZZKGxK9XTpnVR/RN2EfocnLdySeuZlxU1PMEENPUZG28zOMpvkmjRl7
 Kv8/KBKR1Fd7BrmozVWKyY4HUlJLxdc+eNfEJ7+AZw2688qUyPgVjwFj97vdNhkemdZVnBujop39c9
 dpzxW4Of3RRsl9/UYxneWlLvd76WDScEzm7/qDn8XaDM9o8ot8286tSael/EuSrxzsIfF85K0qgJkv
 WAcUmtXb2bTwHm65fIAVV5Az76pOmfZwiUvHHZB1V46tfLUPy3fZFgUXfjz/prpyQZV61CxcRYIS33
 REk5XJDtj5F0JoMrCEUCeIIjFsibY8zlxIKANTj34ceiQpxoOJHECOdz2rkTao0aZqLTAs9FTp2DLa
 aNRjMvaLR65xNPrBFYMOI3udYugphY7SvCj2ADnnBTu9492cPZkC7Sm0woUCYERnhvPKp/bM35X4y+
 HF1fxEWzCqAvPGqX0Bp+ZgzwKEOEnD2snoKBl6wd1XqvSQVGxMRezSCxTvTOHOQsFkwIBQcPnp42rR
 LqIlM+7AmnDRGabMFb8Gx9nU+BoBgxx0iTkzJ4wTr665MFHcYyVMQe7TudXw==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

If probe fails the second call to `i2c_acpi_waive_d0_probe` will
return 1, which means that the device will not be turned off.
This is, it will be left in a different power state. Lets fix it.

Reviewed-by: Hidenori Kobayashi <hidenorik@chromium.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org
Fixes: b18c1ad685d9 ("i2c: Allow an ACPI driver to manage the device's power state during probe")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index b4edf10e8fd0..7539b0740351 100644
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
 
@@ -585,7 +586,7 @@ static int i2c_device_probe(struct device *dev)
 err_release_driver_resources:
 	devres_release_group(&client->dev, client->devres_group_id);
 err_detach_pm_domain:
-	dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
+	dev_pm_domain_detach(&client->dev, do_power_on);
 err_clear_wakeup_irq:
 	dev_pm_clear_wake_irq(&client->dev);
 	device_init_wakeup(&client->dev, false);
@@ -610,7 +611,7 @@ static void i2c_device_remove(struct device *dev)
 
 	devres_release_group(&client->dev, client->devres_group_id);
 
-	dev_pm_domain_detach(&client->dev, !i2c_acpi_waive_d0_probe(dev));
+	dev_pm_domain_detach(&client->dev, true);
 
 	dev_pm_clear_wake_irq(&client->dev);
 	device_init_wakeup(&client->dev, false);

-- 
b4 0.11.0-dev-d93f8
