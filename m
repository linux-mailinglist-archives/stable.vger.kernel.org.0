Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942D55AC4AC
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 16:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiIDOKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 10:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbiIDOKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 10:10:53 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B87326DE
        for <stable@vger.kernel.org>; Sun,  4 Sep 2022 07:10:52 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id z187so6336650pfb.12
        for <stable@vger.kernel.org>; Sun, 04 Sep 2022 07:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=NvLw5KU+55jz8ItVCImcVo81PfvmbTqj67db51rQx28=;
        b=mA5YuvaEcz9geqjvbYjrvj1uTFyLPeCLOL+HNvpQHyO0Zv2nV/o1TqHc/bzTId7zL7
         d9fpPVSRB7wCgOAG2faGq1j8xKPTmmpFos9w4mt4yXKJKfkJsKLzI4MTu8izMH7fHxh6
         4xsmAxiEMQbDa00GtWWbsqCvS9Ca6O+7Xz5kE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=NvLw5KU+55jz8ItVCImcVo81PfvmbTqj67db51rQx28=;
        b=fAt6Yl3nzbeWookYbZOoc8+8XlX2WSE23vTeWIxtUpmzxGfNn+q97LEcaiJuDbP3eM
         FoNeKZfGmI8WM5hFF1JfvHsBqgTEzRMB8LTOpU4UTAkYotZiWtmb16J7L2D1PJmNgiHc
         d/xyP9jrRxXiP3qTqsSVgpv+fFnTRoqgnf/TtcPisdj1BAQLXf3la12UsHpILfkQIKkA
         C2diOqsmx/7Z76QGn35q2OqIgLuKF4otiL2wzv8Qy8IncLNlyghFe/umBPfd8RD251rk
         VnxjrLBxRZFajRqgiqSWPsFPLfiXCTBqWIpteHmD4L/iAcgs4d4OmgxMwCvfx7+ZYt/4
         49aA==
X-Gm-Message-State: ACgBeo1N+h7EvhH1b+hcZusm6ot7p5hW/eI60BL/lI9KftNllD5OjmWt
        L4VWBhZomiRD3MsGcHdwXpN1xw==
X-Google-Smtp-Source: AA6agR4USjcm3W8RIzfgrbED9CyUkSroEFickkr7JF56t7MZ5obBKpMtezqBj392uWfNcSMg9f4NQA==
X-Received: by 2002:a63:5a50:0:b0:429:8580:fc61 with SMTP id k16-20020a635a50000000b004298580fc61mr39578533pgm.215.1662300651563;
        Sun, 04 Sep 2022 07:10:51 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.pdxnet.pdxeng.ch (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id z9-20020a17090a170900b001fe136b4930sm8606760pjd.50.2022.09.04.07.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Sep 2022 07:10:50 -0700 (PDT)
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
Subject: [RESEND PATCH v5 2/2] dmaengine: mxs: fix section mismatch
Date:   Sun,  4 Sep 2022 16:10:20 +0200
Message-Id: <20220904141020.2947725-2-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220904141020.2947725-1-dario.binacchi@amarulasolutions.com>
References: <20220904141020.2947725-1-dario.binacchi@amarulasolutions.com>
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

The patch was suggested by the following modpost warning:

WARNING: modpost: vmlinux.o(.data+0xa3900): Section mismatch in reference from the variable mxs_dma_driver to the function .init.text:mxs_dma_probe()
The variable mxs_dma_driver references
the function __init mxs_dma_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: stable@vger.kernel.org
---

(no changes since v1)

 drivers/dma/mxs-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 18f8154b859b..a01953e06048 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -834,7 +834,7 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver mxs_dma_driver = {
+static struct platform_driver mxs_dma_driver __initdata = {
 	.driver		= {
 		.name	= "mxs-dma",
 		.of_match_table = mxs_dma_dt_ids,
-- 
2.32.0

