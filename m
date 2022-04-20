Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A645087AE
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 14:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378392AbiDTMJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 08:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378390AbiDTMJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 08:09:06 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA5436B5E;
        Wed, 20 Apr 2022 05:06:16 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id q129so1780876oif.4;
        Wed, 20 Apr 2022 05:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3vowEc/UcKrf0koZfGRpVEA6e8Y7oEc/jUqdJ2tAL84=;
        b=jcyJFLN7iLtNwhQplscp/7lkiD3lUsBJYoMNER1K9C8tMZVQBnOjD9ZHTDGFenS3iw
         KRHuFRotqrp3XdXYb8yNkWqZ4rgUAk7HPBm1X3knRHXgqhuSvp9sY/gpeZq2Dly2JDZe
         6g0bQbPRv+vQfwV86livDx9BGKlLkj9bM15OZhXZiwUXDoiDccf7v3JAJ2L8x+uk5vtS
         DsnUvuCalpEopSXZeqm34KQfpljHx1H1xqOjb7u9aklTn0b7xroirqjbUSX3IZA9YIjY
         eSWJ++j+eNdJV0TRcYsmVGvoLuHusCJ3Eoho1V0kPHL4eLUW/IVjmlUjIfMEMKeBybk9
         gzZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3vowEc/UcKrf0koZfGRpVEA6e8Y7oEc/jUqdJ2tAL84=;
        b=VCZo7wsioP6AIGKD3Yn0JuxqKiKrJCaAir1+fED4+Q6rn8rAmg4Isvs58Ch9RW6mCk
         bfvheB/u62uFIJmB/V7UWlp5LLsPMN4KmHZyQrOumvhcEVmAfBv449u6vIMkBtJwIkmD
         +HyHuaPf9zN8yi4GTxVwmQNB6uMDmy4ksZeSRXCHoUpr0ZqseSEIowM2IeOHCtEWCQrQ
         gIH69EyhVs6qfFZ333BO1gCFbtE5wgG397WKjswSYc5uwMXWec516ZbFrTDz7LZie1/2
         ItT6ClNT5tPu+A/5pvo7ZQh/jznRezCzmu1cZKlko1wKgL3erLyPyQ78/GHI6YKu8LI+
         Vm7Q==
X-Gm-Message-State: AOAM530ttWcPZHHDmv2koN2/suiZsyqiHyqoayrWeDG0PNc9XC3+M087
        dNZVEPwSyQp5M1mj8I6tc6w=
X-Google-Smtp-Source: ABdhPJwsNWZ8orbLQ9FaPtyH2jT9tIe9jmb2LyslC/t4DMOVlyEoawNvgSZg6apMloqb/NonKCgNnw==
X-Received: by 2002:a05:6808:128c:b0:2da:3751:7639 with SMTP id a12-20020a056808128c00b002da37517639mr1552321oiw.294.1650456375325;
        Wed, 20 Apr 2022 05:06:15 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:3ce1:a87b:51c0:189d])
        by smtp.gmail.com with ESMTPSA id o19-20020a4a9593000000b0032176119e65sm6530117ooi.34.2022.04.20.05.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 05:06:14 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     horia.geanta@nxp.com, gaurav.jain@nxp.com, V.Sethi@nxp.com,
        linux-crypto@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        stable@vger.kernel.org
Subject: [PATCH v5] crypto: caam - fix i.MX6SX entropy delay value
Date:   Wed, 20 Apr 2022 09:06:01 -0300
Message-Id: <20220420120601.1015362-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
in HRWNG") the following CAAM errors can be seen on i.MX6SX:

caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
hwrng: no data available

This error is due to an incorrect entropy delay for i.MX6SX.

Fix it by increasing the minimum entropy delay for i.MX6SX
as done in U-Boot:
https://patchwork.ozlabs.org/project/uboot/patch/20220415111049.2565744-1-gaurav.jain@nxp.com/

As explained in the U-Boot patch:

"RNG self tests are run to determine the correct entropy delay.
Such tests are executed with different voltages and temperatures to identify
the worst case value for the entropy delay. For i.MX6SX, it was determined
that after adding a margin value of 1000 the minimum entropy delay should be
at least 12000."

Cc: <stable@vger.kernel.org>
Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWNG") 
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
---
Changes since v4:
- Change the function name to needs_entropy_delay_adjustment() - Vabhav
- Improve the commit log by adding the explanation from the U-Boot
patch - Vabhav

 drivers/crypto/caam/ctrl.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ca0361b2dbb0..f87aa2169e5f 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -609,6 +609,13 @@ static bool check_version(struct fsl_mc_version *mc_version, u32 major,
 }
 #endif
 
+static bool needs_entropy_delay_adjustment(void)
+{
+	if (of_machine_is_compatible("fsl,imx6sx"))
+		return true;
+	return false;
+}
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
@@ -855,6 +862,8 @@ static int caam_probe(struct platform_device *pdev)
 			 * Also, if a handle was instantiated, do not change
 			 * the TRNG parameters.
 			 */
+			if (needs_entropy_delay_adjustment())
+				ent_delay = 12000;
 			if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
 				dev_info(dev,
 					 "Entropy delay = %u\n",
@@ -871,6 +880,15 @@ static int caam_probe(struct platform_device *pdev)
 			 */
 			ret = instantiate_rng(dev, inst_handles,
 					      gen_sk);
+			/*
+			 * Entropy delay is determined via TRNG characterization.
+			 * TRNG characterization is run across different voltages
+			 * and temperatures.
+			 * If worst case value for ent_dly is identified,
+			 * the loop can be skipped for that platform.
+			 */
+			if (needs_entropy_delay_adjustment())
+				break;
 			if (ret == -EAGAIN)
 				/*
 				 * if here, the loop will rerun,
-- 
2.25.1

