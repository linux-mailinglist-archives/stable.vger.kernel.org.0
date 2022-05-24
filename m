Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D3D53248E
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 09:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiEXH5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 03:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbiEXH45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 03:56:57 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A241DA44
        for <stable@vger.kernel.org>; Tue, 24 May 2022 00:56:54 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id v8so27532753lfd.8
        for <stable@vger.kernel.org>; Tue, 24 May 2022 00:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pBgGkkAH7mvQXF9WylQ4T7piOJca/zTRdkEUSZA985A=;
        b=FO0V0vfetXtV6gZayJqmNkvBKjiUfH6zZRU3a3zGGRK3mmmMsjdvRPvrl9zB6Wpr6F
         ja9AHcilquUQA3SKDZfDzJs2kSTS0jNin/IEUxVqhn7rfpdO2ecu4TnkY74nWz9D0ivp
         g5UMdEvf6M7mj3kkaNdZbFtOsa7MD5IytTPnt5lS8EwPF42+jtYUDMC89rM3BDjyidr3
         t87wILw+slu8VKDBo+HuX7jj5JMOwWp4utoCG8kcZ/Yz4tezECRK+4PfUzF4qHmFjpfg
         4+fm03aVgUpZx9cBCwCdTlCTMO2P1OBfUoZPtePZEDn3QgPFTuMeKrYvreCiLGuEyfEx
         7wig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pBgGkkAH7mvQXF9WylQ4T7piOJca/zTRdkEUSZA985A=;
        b=Ky2LFs7Cx3XxEgaL9lUGUlUpCmpcCxZLbJb0SEwzUkvZ6b5aVm76vRetyQo0j90fIl
         UDhp9FEDmDaQuX0Ub+zAO2C8ZB+JUdco8R1twI6jGdcctFYfiGaQNuI0n6DhYVk+F1mE
         o+PX/u0QLE4DQBwbhksOnDNy6g5mh7bxUjK9mDyxSAD/RUeKP8Sdf/jydgjyNOpH+GR/
         zXeQrNP50lYLviVnUtTZE97KRRP2Bkr7VE6c/GBCxrX3cXiTfRn2BIx6SsWby7TkESEi
         CS4Ym8saCr2EpGM+24Rc/XrMUHNgrcWPCHQNqY0aSraKTUDK5SGvagk3lYZiG/5qovZs
         w5tA==
X-Gm-Message-State: AOAM5335Ni5sBcyd6wK2Gq2R84TbY2FbTnf2w7psqj8S4xUZU2iTQNtl
        u0YG8KXuFJyuuKvfmY2VV0s49w==
X-Google-Smtp-Source: ABdhPJw6EqaoAwa2V3tEe9Vm8F4/YqgEreO3L30XjeM0sFYK1sD92DBzq48KKmekbCd+05AC8A0EbQ==
X-Received: by 2002:a05:6512:a85:b0:478:6f48:6371 with SMTP id m5-20020a0565120a8500b004786f486371mr6457046lfu.655.1653379012676;
        Tue, 24 May 2022 00:56:52 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id y11-20020a2e7d0b000000b00253d95eebe4sm2326486ljc.21.2022.05.24.00.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 00:56:52 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Peter Rosin <peda@axentia.se>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org
Cc:     Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Beguin <liambeguin@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] iio: afe: rescale: Fix logic bug
Date:   Tue, 24 May 2022 09:54:48 +0200
Message-Id: <20220524075448.140238-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When introducing support for processed channels I needed
to invert the expression:

  if (!iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
      !iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE))
        dev_err(dev, "source channel does not support raw/scale\n");

To the inverse, meaning detect when we can usse raw+scale
rather than when we can not. This was the result:

  if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
      iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE))
       dev_info(dev, "using raw+scale source channel\n");

Ooops. Spot the error. Yep old George Boole came up and bit me.
That should be an &&.

The current code "mostly works" because we have not run into
systems supporting only raw but not scale or only scale but not
raw, and I doubt there are few using the rescaler on anything
such, but let's fix the logic.

Cc: Liam Beguin <liambeguin@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 53ebee949980 ("iio: afe: iio-rescale: Support processed channels")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/iio/afe/iio-rescale.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/afe/iio-rescale.c b/drivers/iio/afe/iio-rescale.c
index 7e511293d6d1..dc426e1484f0 100644
--- a/drivers/iio/afe/iio-rescale.c
+++ b/drivers/iio/afe/iio-rescale.c
@@ -278,7 +278,7 @@ static int rescale_configure_channel(struct device *dev,
 	chan->ext_info = rescale->ext_info;
 	chan->type = rescale->cfg->type;
 
-	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) ||
+	if (iio_channel_has_info(schan, IIO_CHAN_INFO_RAW) &&
 	    iio_channel_has_info(schan, IIO_CHAN_INFO_SCALE)) {
 		dev_info(dev, "using raw+scale source channel\n");
 	} else if (iio_channel_has_info(schan, IIO_CHAN_INFO_PROCESSED)) {
-- 
2.35.3

