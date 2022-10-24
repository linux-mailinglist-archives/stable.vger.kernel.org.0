Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D7660A442
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiJXMHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiJXMFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:05:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFF37D7AF;
        Mon, 24 Oct 2022 04:51:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8611612CE;
        Mon, 24 Oct 2022 11:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD2AC433D6;
        Mon, 24 Oct 2022 11:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612271;
        bh=a8l/I2TuFnDZ2LIT3P89OUO8cHanDUNMh7fG1SpkHa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eh+3wf2yBzhC1Tn7nq2JcTWgZ6y6XJqqqDjK2Pt4YDq3xmeBSATSf+/eBbeiwKqcH
         WJRhV9bgsnhWDDd7tD/O24sExFLFAwMP9ECBtk78arVThNK3qTYDTN4XV2pAtaBsWv
         Cvk4N+aDIuA0EgaqzUAIJ15rqam+gYfTq09P5LHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Kelin Wang <wangkelin2023@163.com>
Subject: [PATCH 4.14 103/210] ASoC: eureka-tlv320: Hold reference returned from of_find_xxx API
Date:   Mon, 24 Oct 2022 13:30:20 +0200
Message-Id: <20221024113000.357615385@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit bfb735a3ceff0bab6473bac275da96f9b2a06dec ]

In eukrea_tlv320_probe(), we need to hold the reference returned
from of_find_compatible_node() which has increased the refcount
and then call of_node_put() with it when done.

Fixes: 66f232908de2 ("ASoC: eukrea-tlv320: Add DT support.")
Co-authored-by: Kelin Wang <wangkelin2023@163.com>
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220914134354.3995587-1-windhl@126.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/eukrea-tlv320.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/eukrea-tlv320.c b/sound/soc/fsl/eukrea-tlv320.c
index 4c6f19ef98b2..04ef886f71b2 100644
--- a/sound/soc/fsl/eukrea-tlv320.c
+++ b/sound/soc/fsl/eukrea-tlv320.c
@@ -88,7 +88,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 	int ret;
 	int int_port = 0, ext_port;
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *ssi_np = NULL, *codec_np = NULL;
+	struct device_node *ssi_np = NULL, *codec_np = NULL, *tmp_np = NULL;
 
 	eukrea_tlv320.dev = &pdev->dev;
 	if (np) {
@@ -145,7 +145,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 	}
 
 	if (machine_is_eukrea_cpuimx27() ||
-	    of_find_compatible_node(NULL, NULL, "fsl,imx21-audmux")) {
+	    (tmp_np = of_find_compatible_node(NULL, NULL, "fsl,imx21-audmux"))) {
 		imx_audmux_v1_configure_port(MX27_AUDMUX_HPCR1_SSI0,
 			IMX_AUDMUX_V1_PCR_SYN |
 			IMX_AUDMUX_V1_PCR_TFSDIR |
@@ -160,10 +160,11 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 			IMX_AUDMUX_V1_PCR_SYN |
 			IMX_AUDMUX_V1_PCR_RXDSEL(MX27_AUDMUX_HPCR1_SSI0)
 		);
+		of_node_put(tmp_np);
 	} else if (machine_is_eukrea_cpuimx25sd() ||
 		   machine_is_eukrea_cpuimx35sd() ||
 		   machine_is_eukrea_cpuimx51sd() ||
-		   of_find_compatible_node(NULL, NULL, "fsl,imx31-audmux")) {
+		   (tmp_np = of_find_compatible_node(NULL, NULL, "fsl,imx31-audmux"))) {
 		if (!np)
 			ext_port = machine_is_eukrea_cpuimx25sd() ?
 				4 : 3;
@@ -180,6 +181,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 			IMX_AUDMUX_V2_PTCR_SYN,
 			IMX_AUDMUX_V2_PDCR_RXDSEL(int_port)
 		);
+		of_node_put(tmp_np);
 	} else {
 		if (np) {
 			/* The eukrea,asoc-tlv320 driver was explicitly
-- 
2.35.1



