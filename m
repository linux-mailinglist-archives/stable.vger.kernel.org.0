Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D7A5305D3
	for <lists+stable@lfdr.de>; Sun, 22 May 2022 22:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345215AbiEVUWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 May 2022 16:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbiEVUWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 May 2022 16:22:33 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A560435258
        for <stable@vger.kernel.org>; Sun, 22 May 2022 13:22:31 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id n23so16838239edy.0
        for <stable@vger.kernel.org>; Sun, 22 May 2022 13:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7lqrNM9SlTA9YcyvAhtvzC37daa5Q+RkpbW0aFJMfIU=;
        b=BlHfHCkJSAKtW33s8FAp1ySSMpQuboJzj6P8ieFFoaCqyf/97IBTwIK0zmtKbswleI
         zJ14vzYi43mf7wStH2toIiem5oJBefAQwZAOy4d6je5DUCr7wPrwREZibYRfeHNU89QB
         gZb9LxW7JrUb66ev6uHSbuN+KqiEcpM+HFCmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7lqrNM9SlTA9YcyvAhtvzC37daa5Q+RkpbW0aFJMfIU=;
        b=ECuEAMTTImeXtfeKAla6ic926eT4Ki3NOh3N9OTi8Rf4ZWwZdPcOVd3HuZLCFFfidq
         HVvY5LszuqBxuNcq/MaU29quDK33+8BSzZm99cOe/RVARxURYN+4yb45dGIRF0OjMfnO
         x2+Slr1lM+13PmWnjM9KWcZWQIxKl8+3pD9xel1BX4qc0LL0/FkQya3SqRnfVetJ2GdU
         gK3bni7ojQ6lcZHyH5DeJ9JHri9tBNXjRm+W/8ubgpkgS7G0e0iveIPYWT7dI4blhU9K
         aS0ALLZ8MbnigvzwVm/1LUyfh1xrpwtmuonLWrTdPurDJ6mYpVBOWm+rzMVMT6iTWOgF
         IFiw==
X-Gm-Message-State: AOAM530nKXhM6wOQqNmEibARzmDsrGCiAO3RSbStOubzKYOmNlRz+KkR
        yRe3EHAnP7083VkTLYXLqc/e230mPGLo4Q==
X-Google-Smtp-Source: ABdhPJxknQT49oNOahOTUWp8iBADzAFc9ZTPcVm6YC6rBk/ExwJwN8tVFmO2fd4urytDDvswyAuiOQ==
X-Received: by 2002:a05:6402:1e93:b0:42b:5134:6bf6 with SMTP id f19-20020a0564021e9300b0042b51346bf6mr6648496edf.40.1653250950259;
        Sun, 22 May 2022 13:22:30 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id r17-20020a056402019100b0042abf2affebsm7269876edv.67.2022.05.22.13.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 May 2022 13:22:29 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Michael Trimarchi <michael@amarulasolutions.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] dmaengine: mxs: fix driver registering
Date:   Sun, 22 May 2022 22:22:23 +0200
Message-Id: <20220522202223.1343109-1-dario.binacchi@amarulasolutions.com>
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
control module, is not ready. Since platform_driver_probe(), as
reported by its description, is incompatible with deferred probing,
we have to use platform_driver_register().

Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

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

