Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E465C0515
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 19:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiIURGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 13:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIURGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 13:06:47 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0AB94132
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 10:06:45 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e17so9683564edc.5
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 10:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=13KrUn/vK4OvwOsT1GyfzamKvbOZHawCA5zcRq7muWw=;
        b=K08ArTlVGsyc0SAIljgyi30InRUPlMtrNCxpDmu1hgp81UAVnxk/nCuUHorbHVEIwR
         6S29osbtR09bB8cVoWs/j3VPhB4VSJ4E57HIk3O9wj/CaNvmV/GbulyUmDtlEn5gNZ4k
         hZFUYg6ISBFf1gJp8MwoTnpoQdlhjnm8v9Rlo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=13KrUn/vK4OvwOsT1GyfzamKvbOZHawCA5zcRq7muWw=;
        b=yECvKiSsn6EAXmfze4RiEPajJEbK15ro7cZiZkOOzhs+K5Kf7GT+GeSTSOGXAV5uwn
         6FY4Z/5o6w661IdNn0sVUQ0xrGcW4gedzJjgvyBqC2oiJ08dsW+inrmacsJoBQ/gXPvG
         hF94sppkap55X/wNIqU2l1bAcPshXkizWKeFhbrPmkWV64rDZ/hGNe7APhm8C8cgJc/b
         /CsTRImRKAsofDSi2O3yq5W5sYB2brDYEN56V8lGR2TDJ7OaTc/MPuvVCfNor5iAm5zU
         ssW+1zd2ij2X/Z/99OqKUCp+yQTtzRN3J0Y3oVPUBYx18QEOKottB806SzMdWzdZqIDh
         b4cg==
X-Gm-Message-State: ACrzQf1AJ78ZMEyUYjWZOi9mMBxKlTCIplfvOU61b6Vb5y+aIl+4Xbcv
        8MMJYTEctB1R4WHO3BIw3TvdLQ==
X-Google-Smtp-Source: AMsMyM5LostbLMrQ/ZLX3Zv+Rf1hWT+t6mpBiz9T0uqd2GeK3MULwy/v1qfzz59wqxZEro4/2cgLcg==
X-Received: by 2002:a05:6402:d05:b0:425:b5c8:faeb with SMTP id eb5-20020a0564020d0500b00425b5c8faebmr25420939edb.273.1663780004402;
        Wed, 21 Sep 2022 10:06:44 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-95-232-92-192.retail.telecomitalia.it. [95.232.92.192])
        by smtp.gmail.com with ESMTPSA id t15-20020a170906608f00b0077a8fa8ba55sm1468940ejj.210.2022.09.21.10.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 10:06:43 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Michael Trimarchi <michael@amarulasolutions.com>,
        linux-amarula@amarulasolutions.com,
        Robin Murphy <robin.murphy@arm.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6] dmaengine: mxs: use platform_driver_register
Date:   Wed, 21 Sep 2022 19:05:56 +0200
Message-Id: <20220921170556.1055962-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

The __init annotation has been dropped because it is not compatible with
deferred probing. The code is not executed once and its memory cannot be
freed.

Fixes: a580b8c5429a ("dmaengine: mxs-dma: add dma support for i.MX23/28")
Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: stable@vger.kernel.org

---

Changes in v6:
- Drop __init annotation.
- Drop the "dmaengine: mxs: fix section mismatch" patch.
- Update the commit message.
- Add Sascha Hauer's Acked-by tag.

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

 drivers/dma/mxs-dma.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 994fc4d2aca4..dc147cc2436e 100644
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
+builtin_platform_driver(mxs_dma_driver);
-- 
2.32.0

