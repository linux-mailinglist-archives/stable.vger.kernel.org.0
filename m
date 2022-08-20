Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980E159ACB3
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 10:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344726AbiHTIpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 04:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343849AbiHTIpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 04:45:06 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658F472EE5
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 01:45:05 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id q2so5987155edb.6
        for <stable@vger.kernel.org>; Sat, 20 Aug 2022 01:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=C3neU1AtxmqWdDSuYqkB7lF7A3shUmwSCsbgD00NRVo=;
        b=eThpM9uxRwJzTuhVFBRMNJ9H0vTr2TRrapx/uMb8SXuMEM0TzA5O4w/AzUVnfw8+3n
         7nQ5CmprNuO1C8uBjy+7pNZiEdrlbPmrWvBNxXoT1gE7ZCj8uNcIQLC0FgtjwkVcHjYH
         6Jx9/6JQFwfLzdsSVWBmswc57cxIcKa9k/qF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=C3neU1AtxmqWdDSuYqkB7lF7A3shUmwSCsbgD00NRVo=;
        b=s6+A8Auxu1017P/91GAvZtIu5itU8ejDYEjC6E7WckEdJTzW0TPP5NfC5w/OZEjeXq
         md4r7tG5iDC4D7Hh95ZGHvGvvlX/X1ZIezxVcAaJOsDbUKyPD4OVBJ7lCASp0p1Enkj7
         j0Hr2SfYhosq6tpkvWEQQHmp964zFJVR7FrJR4NGnJCVqT/WaGssv6XFLOwhl93bWPcC
         erwnJlD0AnIPfyKkHafuzXB0gJD5yBNPXSPu/6ehrp6i1+10dZFDY0yM2T+0+H6nN5Nf
         4GtUa5EEJt9CZSwBAlCUK8wbKHftw8CMpwoUmfHckdZ6zXLLEsXmU6Sr+Ncqsu7rcXdP
         64jA==
X-Gm-Message-State: ACgBeo3rF7k/Y/JC2JPWx20mB7KBcVVMH0BZsLIaEfT9U+LHPpXFdWUu
        ld+cqZj6ETtNlLMLMik97appUQ==
X-Google-Smtp-Source: AA6agR5oabpEWO5QscsCqYPMks7b1iYiqWxeVRvCi+N5mOHWAK+GrXRSzxRY5E99PWwWo7LsPzOhxA==
X-Received: by 2002:aa7:dc13:0:b0:443:3f15:8440 with SMTP id b19-20020aa7dc13000000b004433f158440mr8563131edu.274.1660985103939;
        Sat, 20 Aug 2022 01:45:03 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id k8-20020a17090632c800b0073cd7cc2c81sm2170821ejk.181.2022.08.20.01.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 01:45:03 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-amarula@amarulasolutions.com,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RESEND PATCH v5 1/2] dmaengine: mxs: use platform_driver_register
Date:   Sat, 20 Aug 2022 10:44:59 +0200
Message-Id: <20220820084500.689445-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
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

Driver registration fails on SOC imx8mn as its supplier, the clock
control module, is probed later than subsys initcall level. This driver
uses platform_driver_probe which is not compatible with deferred probing
and won't be probed again later if probe function fails due to clock not
being available at that time.

This patch replaces the use of platform_driver_probe with
platform_driver_register which will allow probing the driver later again
when the clock control module will be available.

Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: stable@vger.kernel.org

---

Changes in v5:
- Update the commit message.
- Add the patch "dmaengine: mxs: fix section mismatch" to remove the
  warning raised by this patch.

Changes in v4:
- Restore __init in front of mxs_dma_probe() definition.
- Rename the mxs_dma_driver variable to mxs_dma_driver_probe.
- Update the commit message.
- Use builtin_platform_driver() instead of module_platform_driver().

Changes in v3:
- Restore __init in front of mxs_dma_init() definition.

Changes in v2:
- Add the tag "Cc: stable@vger.kernel.org" in the sign-off area.

 drivers/dma/mxs-dma.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 994fc4d2aca4..18f8154b859b 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -839,10 +839,6 @@ static struct platform_driver mxs_dma_driver = {
 		.name	= "mxs-dma",
 		.of_match_table = mxs_dma_dt_ids,
 	},
+	.probe = mxs_dma_probe,
 };
-
-static int __init mxs_dma_module_init(void)
-{
-	return platform_driver_probe(&mxs_dma_driver, mxs_dma_probe);
-}
-subsys_initcall(mxs_dma_module_init);
+builtin_platform_driver(mxs_dma_driver);
-- 
2.32.0

