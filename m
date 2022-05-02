Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AD65178D6
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 23:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiEBVMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 17:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387557AbiEBVMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 17:12:30 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAB7DFE4
        for <stable@vger.kernel.org>; Mon,  2 May 2022 14:09:00 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 15so12570149pgf.4
        for <stable@vger.kernel.org>; Mon, 02 May 2022 14:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txaJV3dRNivG0NhQ8k6fgkkv9GXMKI0xKoeOEZVcpBA=;
        b=OMUOJdST+dvUnnVGFp2+FaA5H2l3LP29+HkC14csGRlQnEAJhmjbkjs0HwpfMmycp2
         I3SglPp4bwHWZJm7HlP6gp4yv9rEtXa0+uBv4PYpUybL6HsuYcYmpMvyNpHRaZtAieJk
         m3io1XTZWbNQPGL9ubBllICMRhpKPkcXhwPFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txaJV3dRNivG0NhQ8k6fgkkv9GXMKI0xKoeOEZVcpBA=;
        b=8NB4c9mpyzGkVikV2SXg98snfYO+A8ggbMZOawS0hAVzwKHt13E4JVOO2vyMqYJ/hO
         XAlZEF/Reuyn3zX3ReV+Qh1LIUIV1b8TOmBhuhAYFt346Ebf9iFixNX85gp6XY+kL7av
         +7ePuGoCnUxwM0bAD5LfjtbLmdv8O9e3jpA5T2GCR3DXdFbkM0rmW0xWtmAvaqbWtI/D
         I9uQZDIT7cjUplQp/moGd06iG+Id74Buk6r0DHWx9CWdVy4GNr1ynBlZ/KXQrxPKvTJH
         O8NB8MKrOp5gYzu8KmSa0rKdyhgWDd9LJmrWm0hyfXmR09DW2SwdAhztbfAn0J77fDz9
         h3bg==
X-Gm-Message-State: AOAM530mu756OVVHwU6VO0V/XLxA6gWnL1iF/Na6zUQxsRr7BSXw4xmu
        ++uyhU00wNAXReo2PE+G5TyJwqbiCX7VHQ==
X-Google-Smtp-Source: ABdhPJyLhNfT4wJssP/9HEx9GbXsbFV1WJMQKfg68czKh2y4qLKTONEURq/1HUf46yfcZ9nbnVr55w==
X-Received: by 2002:a63:512:0:b0:3c2:2f7c:cc73 with SMTP id 18-20020a630512000000b003c22f7ccc73mr4589256pgf.96.1651525739830;
        Mon, 02 May 2022 14:08:59 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:c718:98e4:f528:12ec])
        by smtp.gmail.com with ESMTPSA id j22-20020a17090a7e9600b001d903861194sm140331pjl.30.2022.05.02.14.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 14:08:59 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Gwendal Grignou <gwendal@chromium.org>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH] iio:proximity:sx_common: Fix device property parsing on DT systems
Date:   Mon,  2 May 2022 14:08:58 -0700
Message-Id: <20220502210858.3377574-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 74a53a959028e5f28e3c0e9445a876e5c8da147c upstream.

After commit 7a3605bef878 ("iio: sx9310: Support ACPI property") we
started using the 'indio_dev->dev' to extract device properties for
various register settings in sx9310_get_default_reg(). This broke DT
based systems because dev_fwnode() used in the device_property*() APIs
can't find an 'of_node'. That's because the 'indio_dev->dev.of_node'
pointer isn't set until iio_device_register() is called. Set the pointer
earlier, next to where the ACPI companion is set, so that the device
property APIs work on DT systems.

Cc: Gwendal Grignou <gwendal@chromium.org>
Fixes: 7a3605bef878 ("iio: sx9310: Support ACPI property")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
Link: https://lore.kernel.org/r/20220331210425.3908278-1-swboyd@chromium.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[swboyd@chromium.org: Move to sx9310 probe because we don't have commit
caa8ce7f6149 ("iio:proximity:sx9310: Extract common Semtech sensor
logic") applied]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

This applies cleanly to 5.15.y as well.

 drivers/iio/proximity/sx9310.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/proximity/sx9310.c b/drivers/iio/proximity/sx9310.c
index a3fdb59b06d2..976220bdf81a 100644
--- a/drivers/iio/proximity/sx9310.c
+++ b/drivers/iio/proximity/sx9310.c
@@ -1436,6 +1436,7 @@ static int sx9310_probe(struct i2c_client *client)
 		return ret;
 
 	ACPI_COMPANION_SET(&indio_dev->dev, ACPI_COMPANION(dev));
+	indio_dev->dev.of_node = client->dev.of_node;
 	indio_dev->channels = sx9310_channels;
 	indio_dev->num_channels = ARRAY_SIZE(sx9310_channels);
 	indio_dev->info = &sx9310_info;
-- 
https://chromeos.dev

