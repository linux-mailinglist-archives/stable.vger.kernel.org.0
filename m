Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916FE57206D
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 18:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiGLQLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 12:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiGLQLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 12:11:34 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FF8BDBB2
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 09:11:33 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ss3so9151229ejc.11
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 09:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=21nZyc3bYwF/2+gU25HHeO3ZzKasf2bJUi7S16b1eWU=;
        b=pI3NbHHjeGT8cStUjzd57ZsN322xV+C9lha7C8b1wE3VuJJs/n+b0oyXQ7K8ezo7l3
         XHaUVDbZP4V7OpXayTOBsSAyezSRgijjY5vbjgL2n7O4wTaSJxOhTkpQ0DyBbuxCUsO4
         61TINg1OkvcpA+vrgA7tmlxbzRN0INNy8TVY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=21nZyc3bYwF/2+gU25HHeO3ZzKasf2bJUi7S16b1eWU=;
        b=KDCvAtqRaAm8FqAyNXNqUGHnx+mddcxL3+RbSQlgrnv9dEu5dGgVgDXPlTWHDR/YW0
         8B1bB90r4NmCo91/QxR0u7kCrk4WFIC4Ae7JtjOjbmCVUYifZre2f8ySMdMEUTJbcBwu
         ycqFEOwShmh3SDqhHeNmdYFgJ8CajrmwESFW1GTTw5S5BEWQZH1JdwaECo3zfpiZtOMW
         RFPmIvxWsXJdWyq/cWIZcS4plhbaPbMzva/mXx6NX1baDiABifzlyWmHxgvqHUUg9mbW
         16+G9CD+YW5JQ8gJbOQc0UZPSAaAFSmnjJqk5T0u/8hnEBRyCLsspZ19P3oTHdBN+nVq
         1OkA==
X-Gm-Message-State: AJIora9Chs//6REUnFMDGzdWjZ8b2mPlDFMUO7yYQPWrphmjg1ZLTbMG
        1f7PmyAQtgV50nATvrSDREsDSQ==
X-Google-Smtp-Source: AGRyM1ucFy54oRu/i+plCJT5SdHJrkvWY0f3+6DSn6RQToEjw/79AD1rdgrVryHUeqQjlsWOnkyOuA==
X-Received: by 2002:a17:906:938a:b0:726:942a:54e8 with SMTP id l10-20020a170906938a00b00726942a54e8mr24075139ejx.225.1657642291745;
        Tue, 12 Jul 2022 09:11:31 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.retail.telecomitalia.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id h4-20020a1709066d8400b00722ea7a7febsm3911498ejt.194.2022.07.12.09.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 09:11:31 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-amarula@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 1/2] dmaengine: mxs: use platform_driver_register
Date:   Tue, 12 Jul 2022 18:09:07 +0200
Message-Id: <20220712160909.2054141-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
- Create a new patch to remove the warning generated by this patch.

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

