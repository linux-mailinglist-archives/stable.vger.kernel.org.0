Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8D66B564A
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 01:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCKAXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 19:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjCKAXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 19:23:03 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C39B1FD0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 16:22:55 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id cu4so1016033qvb.3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 16:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678494174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HafAvVfPi40ywIy7mcLGZZ7DnFj4XpXONhSNPVRF/Bo=;
        b=PHRlOKW8Qi27WA04xGObtWiLvK460VN8JnQa27YPrBHdgZ0syFyT2y1R2ejjSCvQGb
         sWrm/wuP3sL7q1tnllTsutaRfXf15/KqJpyMT8h7NLddPNjOal20X5Z7MLQCH30KYoL2
         wLqzlTTwbbsy/uS8NJq2+Wo3Dhp/W7aX1HDs8LVcjouSUJzMymTzW4HMawhYntHsEHmB
         TTN3s+qyktPQCKtMfUXGwfK5ukKk3+MLsv7oPIsiLXJcMTflHE0Dvcvn3YPxjhfeFGzU
         7ll1djfHv+3WauH9Y/zyomC/KcqwMfN5tP7w2+puxzgugMfqtshutfbnuTBES1JdM3B6
         OJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HafAvVfPi40ywIy7mcLGZZ7DnFj4XpXONhSNPVRF/Bo=;
        b=HRLUm4gIv81LxnLtkE/lCHij4tjHYtahUNJwEE/Dqf9x42Z3KfpT8Y32Z5qWoVB+UD
         Boe/mLGm2x/puVZQKGr5yBgoS1lMKlWC+E2MOTXXarGpxHkwr/0bq6hXT9Ig1hCY2cqj
         XG04XqI+kzPKDAnuguXWlTmfs2PcUTS4g5hPNhwVG+DyTQPsZK6hSm/vQS+at22Jf+mk
         m36zg5NfDGnyUSVEYswDAxC+6pZHL5SO2SP2eEnE8dJXaUNqInQCOWEEsp06ajTIZgOI
         /HhAoichARZjedR9+vyWX2harqdlfcXz5axf9akkekQd/YeW2pvSOze28qGPC7KdiegU
         /x6A==
X-Gm-Message-State: AO0yUKUjoyg3hOGJPiG9fDj3b4eL9Gr8SsgYAGRCPfdZftk+mrnQzmg/
        P80oEvxIqNwSFvGG7ec6pUghEg==
X-Google-Smtp-Source: AK7set/0j0WVg//8nl3RrzKyyTBjZzoCztF+YRMgAJzwAqVXb6gcu+qdJCdgCq6Q5BOKGxf4OjR4jg==
X-Received: by 2002:a05:6214:2aa7:b0:56e:ac19:a879 with SMTP id js7-20020a0562142aa700b0056eac19a879mr1592192qvb.8.1678494174079;
        Fri, 10 Mar 2023 16:22:54 -0800 (PST)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id 140-20020a370792000000b0073b69922cfesm775432qkh.85.2023.03.10.16.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 16:22:53 -0800 (PST)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     jic23@kernel.org, lars@metafoo.de
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] iio: dac: cio-dac: Fix max DAC write value check for 12-bit
Date:   Fri, 10 Mar 2023 19:22:48 -0500
Message-Id: <20230311002248.8548-1-william.gray@linaro.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The CIO-DAC series of devices only supports DAC values up to 12-bit
rather than 16-bit. Trying to write a 16-bit value results in only the
lower 12 bits affecting the DAC output which is not what the user
expects. Instead, adjust the DAC write value check to reject values
larger than 12-bit so that they fail explicitly as invalid for the user.

Fixes: 3b8df5fd526e ("iio: Add IIO support for the Measurement Computing CIO-DAC family")
Cc: stable@vger.kernel.org
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/iio/dac/cio-dac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/cio-dac.c b/drivers/iio/dac/cio-dac.c
index 791dd999cf29..18a64f72fc18 100644
--- a/drivers/iio/dac/cio-dac.c
+++ b/drivers/iio/dac/cio-dac.c
@@ -66,8 +66,8 @@ static int cio_dac_write_raw(struct iio_dev *indio_dev,
 	if (mask != IIO_CHAN_INFO_RAW)
 		return -EINVAL;
 
-	/* DAC can only accept up to a 16-bit value */
-	if ((unsigned int)val > 65535)
+	/* DAC can only accept up to a 12-bit value */
+	if ((unsigned int)val > 4095)
 		return -EINVAL;
 
 	priv->chan_out_states[chan->channel] = val;

base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
-- 
2.39.2

