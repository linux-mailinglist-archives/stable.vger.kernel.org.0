Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF12153FAA2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240457AbiFGJ6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240569AbiFGJ6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:58:48 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1F5EAD17
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 02:58:40 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id p10so23379954wrg.12
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 02:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8WAmC01JdwEuRA91bKXEDq+9uWVDhRFE7DDNgirVT8=;
        b=E7D78HbCN6AmI9t71qky707VuevSEMGvFMRyGOrT2ImNwmNaQ4RY1xL17EaNrhKQCJ
         aoAQacZuFFKkG7Y0697B3F7i5+7Y7X2b3cQAbOg6/KUCIbWsBNODN+gmTCPElHtj7Bxj
         DBwviyJLIDP/4xY+k1pEQ9wdAlTXKURDuH4Xo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8WAmC01JdwEuRA91bKXEDq+9uWVDhRFE7DDNgirVT8=;
        b=FIPT5kkycQeoXf4oq0y67GbRhcatRvAXB47MN5TPTsaCvrXpKSjGwwc8S/I8OM9BjU
         mjntGBwcwIfH21Yuc3BafZnCxPC+qG4T5Gzu/MkOdBt8Xj0IHQguRyleyX3P8aNqPFyy
         zT1iYrgjEeMlDiSdyytnaSf1P1Wt1hy9sG/GYRCieLKR899NhDuoMQQZwMin1/NJFyPb
         Etdt2q3/De1Zy1XoiLaeAoHPcbiVYMCgIONw85SLtMVxcIfp6fUc5sZIJ3IoauUy6hoM
         WZbb4VIyw6z5WojOZGMaCQFAN9zP501s5lg1xxASjZRPQy+MtJQnMDld1uNj21/2aQ70
         UX4Q==
X-Gm-Message-State: AOAM532Gsu6c1NtTlpTZsj4fz+hY4qTefo/BnmOV5/zR+tqYfR69wAJy
        JGrH2s1pHcuEx5FigHdLTfAgHw==
X-Google-Smtp-Source: ABdhPJy1vrfKTI+2dpohRIslhCweHyfE/FNWgeeTlATJcEIYD0SERXLXG3AX+PCAyNSeIy60+DiDlw==
X-Received: by 2002:a05:6000:1d86:b0:218:3cfc:4ca2 with SMTP id bk6-20020a0560001d8600b002183cfc4ca2mr10765322wrb.133.1654595918844;
        Tue, 07 Jun 2022 02:58:38 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.pdxnet.pdxeng.ch (mob-5-90-137-51.net.vodafone.it. [5.90.137.51])
        by smtp.gmail.com with ESMTPSA id c186-20020a1c35c3000000b0039bc95cf4b2sm19958382wma.11.2022.06.07.02.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:58:38 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RESEND PATCH v2] dmaengine: mxs: fix driver registering
Date:   Tue,  7 Jun 2022 11:58:29 +0200
Message-Id: <20220607095829.1035903-1-dario.binacchi@amarulasolutions.com>
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
control module, is not ready. Since platform_driver_probe(), as
reported by its description, is incompatible with deferred probing,
we have to use platform_driver_register().

Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: stable@vger.kernel.org

---

Changes in v2:
- Add the tag "Cc: stable@vger.kernel.org" in the sign-off area.

 drivers/dma/mxs-dma.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 994fc4d2aca4..b8a3e692330d 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -670,7 +670,7 @@ static enum dma_status mxs_dma_tx_status(struct dma_chan *chan,
 	return mxs_chan->status;
 }
 
-static int __init mxs_dma_init(struct mxs_dma_engine *mxs_dma)
+static int mxs_dma_init(struct mxs_dma_engine *mxs_dma)
 {
 	int ret;
 
@@ -741,7 +741,7 @@ static struct dma_chan *mxs_dma_xlate(struct of_phandle_args *dma_spec,
 				     ofdma->of_node);
 }
 
-static int __init mxs_dma_probe(struct platform_device *pdev)
+static int mxs_dma_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	const struct mxs_dma_type *dma_type;
@@ -839,10 +839,7 @@ static struct platform_driver mxs_dma_driver = {
 		.name	= "mxs-dma",
 		.of_match_table = mxs_dma_dt_ids,
 	},
+	.probe = mxs_dma_probe,
 };
 
-static int __init mxs_dma_module_init(void)
-{
-	return platform_driver_probe(&mxs_dma_driver, mxs_dma_probe);
-}
-subsys_initcall(mxs_dma_module_init);
+module_platform_driver(mxs_dma_driver);
-- 
2.32.0

