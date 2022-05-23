Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC95F5312DD
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbiEWNXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 09:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236137AbiEWNXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 09:23:05 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF7B30F68
        for <stable@vger.kernel.org>; Mon, 23 May 2022 06:22:53 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id p26so19101822eds.5
        for <stable@vger.kernel.org>; Mon, 23 May 2022 06:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8WAmC01JdwEuRA91bKXEDq+9uWVDhRFE7DDNgirVT8=;
        b=W4OGyqHL2ZKqiPmC+Hr840hwTtdA9uiv+Onp5DpklXJb0lXyIYeJM41tvTV/1gafHV
         VB4Pptl9/AB1PutTxxwALFx6e9yR8tQ9dhA//i04ErhKBRAd2wdY7Guk+uMn85eVN4AA
         aK3ofPTdLy1pgcJQgFawl51XYJcZXnlp0KaMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8WAmC01JdwEuRA91bKXEDq+9uWVDhRFE7DDNgirVT8=;
        b=kVnB+vFn6LsYHfBZ3kU/eSzpvgctB+/umWS4vKRP1GKzCGjGXLYiTuWwlk26gKAD5I
         kylyZ0Ojt+nYosg7bsk0M64zQukCSqsyRaQYM1NNuyIv+/KkJId1WXmmyOLL+nL8E5i3
         n5Nod3MjXLd11okGk1eRU+FPRQ6EvNwFGU9mwaVUurSRS7K5zfeNC4NU3liYaR/eF8mw
         ah8+9d1eyzz8xRLYbIP7XXSC/FvHUyocqaZmb+V+Tfpeg3eVPbGaKIRoT96GnYbaQS3V
         0oVqRUUUpWdinxBovpX1cQ9/LyXu8ag40hWD81La5yhIU4z4G6+LWUUFwWiXzltWEIpj
         3zwQ==
X-Gm-Message-State: AOAM531qCcNnT2AFRKQurlsjyVtiXl12RPc4AMtZdOkTZYVFQPGPQufD
        WKYEtCQf/Xgs9X2lzEpblBXV8A==
X-Google-Smtp-Source: ABdhPJyzCB3wSJCVIQ8lxcYGLb927QLmAjOhNbuxRB+//y0X8LXl4qCJl+xQS+M9DHvE4XqlF/tGcw==
X-Received: by 2002:a05:6402:368b:b0:42b:42c7:f63f with SMTP id ej11-20020a056402368b00b0042b42c7f63fmr11364450edb.409.1653312171880;
        Mon, 23 May 2022 06:22:51 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.pdxnet.pdxeng.ch (host-80-116-90-174.retail.telecomitalia.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id cw12-20020a170906c78c00b006fec3b388edsm2249351ejb.95.2022.05.23.06.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 06:22:51 -0700 (PDT)
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
Subject: [PATCH v2] dmaengine: mxs: fix driver registering
Date:   Mon, 23 May 2022 15:22:47 +0200
Message-Id: <20220523132247.1429321-1-dario.binacchi@amarulasolutions.com>
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

