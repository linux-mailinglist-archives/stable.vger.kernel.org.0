Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4033C5A27C1
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 14:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242864AbiHZMYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 08:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiHZMYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 08:24:30 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563E0E9D;
        Fri, 26 Aug 2022 05:24:29 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2405:201:10:389d:42df:ae4c:c047:294c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: shreeya)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 829BD6601EC8;
        Fri, 26 Aug 2022 13:24:25 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1661516667;
        bh=x89a8TvfcoIEzBD2+gLPAUruz1s8rtys3PetrUIb6xc=;
        h=From:To:Cc:Subject:Date:From;
        b=dbdEzMnnKG3ER31kdXrzaxxao0JBbpW386BCpHg+L5YtlTFwd+bnow3gPket6+Vsb
         B169O8KzxPR3Zv14CRcbtQb5hJGa6zqDkY5HR2B8rzSxnmqWrQOnOyS3gbHhr9SEXb
         g9hjgeqCob+dq0t/nhrYOKtU/0MO/61ycylKOJVoMqrnumjBq+QFuO24uzsoMSTSNC
         dDqBPpszKDUCdVIvakDRVFwOnoUSXzI9+mYSz9gF7rxV6TWNbDCdDAPvzkhaVM8lpk
         sh+v7To32hot+P0tKDC5mhD9cNHONafNpigivEyABYUUVKn74TjbfyWe+HsYQFz3YM
         hLUwB7RaHYGLw==
From:   Shreeya Patel <shreeya.patel@collabora.com>
To:     jic23@kernel.org, lars@metafoo.de
Cc:     krisman@collabora.com, dmitry.osipenko@collabora.com,
        kernel@collabora.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shreeya Patel <shreeya.patel@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] iio: light: tsl2583: Fix module unloading
Date:   Fri, 26 Aug 2022 17:53:52 +0530
Message-Id: <20220826122352.288438-1-shreeya.patel@collabora.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

tsl2583 uses devm_iio_device_register() function and
calling iio_device_unregister() in remove breaks the
module unloading.
Fix this by using iio_device_register() instead of
devm_iio_device_register() function in probe.

Cc: stable@vger.kernel.org
Fixes: 371894f5d1a0 ("iio: tsl2583: add runtime power management support")
Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
---
Changes in v2
  - Use iio_device_register() instead of devm_iio_device_register()
  - Add fixes and stable tags

 drivers/iio/light/tsl2583.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/tsl2583.c b/drivers/iio/light/tsl2583.c
index 82662dab87c0..94d75ec687c3 100644
--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -858,7 +858,7 @@ static int tsl2583_probe(struct i2c_client *clientp,
 					 TSL2583_POWER_OFF_DELAY_MS);
 	pm_runtime_use_autosuspend(&clientp->dev);
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret) {
 		dev_err(&clientp->dev, "%s: iio registration failed\n",
 			__func__);
-- 
2.30.2

