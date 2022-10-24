Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB7F60A741
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbiJXMsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234644AbiJXMpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:45:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFDA28E06;
        Mon, 24 Oct 2022 05:09:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1E49612DF;
        Mon, 24 Oct 2022 12:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A42C433D7;
        Mon, 24 Oct 2022 12:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613340;
        bh=RhZY3f/cNX48ieii4f+tk/Br9qS6MllaouL23ztsNwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhHwUlGi+8zAk30SeKcfPSIeISYF01r+Ewl8sKtPayrlmvvjmEmt0HYkzzA0aapNz
         0A7BteM0wqM2QaVrLW755W9kOrzY65jyZgRr/DCm4NSeefysQWpILmg+qS/wAYqCaG
         MWIl5SDdMZIZNiVoPpFEulrrgPZwZ7rRi/Yq21B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Kelin Wang <wangkelin2023@163.com>
Subject: [PATCH 5.4 100/255] ASoC: eureka-tlv320: Hold reference returned from of_find_xxx API
Date:   Mon, 24 Oct 2022 13:30:10 +0200
Message-Id: <20221024113005.806514427@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
index 6f3b768489f6..bf3d3f0aa858 100644
--- a/sound/soc/fsl/eukrea-tlv320.c
+++ b/sound/soc/fsl/eukrea-tlv320.c
@@ -86,7 +86,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 	int ret;
 	int int_port = 0, ext_port;
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *ssi_np = NULL, *codec_np = NULL;
+	struct device_node *ssi_np = NULL, *codec_np = NULL, *tmp_np = NULL;
 
 	eukrea_tlv320.dev = &pdev->dev;
 	if (np) {
@@ -143,7 +143,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 	}
 
 	if (machine_is_eukrea_cpuimx27() ||
-	    of_find_compatible_node(NULL, NULL, "fsl,imx21-audmux")) {
+	    (tmp_np = of_find_compatible_node(NULL, NULL, "fsl,imx21-audmux"))) {
 		imx_audmux_v1_configure_port(MX27_AUDMUX_HPCR1_SSI0,
 			IMX_AUDMUX_V1_PCR_SYN |
 			IMX_AUDMUX_V1_PCR_TFSDIR |
@@ -158,10 +158,11 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
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
@@ -178,6 +179,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 			IMX_AUDMUX_V2_PTCR_SYN,
 			IMX_AUDMUX_V2_PDCR_RXDSEL(int_port)
 		);
+		of_node_put(tmp_np);
 	} else {
 		if (np) {
 			/* The eukrea,asoc-tlv320 driver was explicitly
-- 
2.35.1



