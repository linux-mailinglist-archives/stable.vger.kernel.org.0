Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF280506B61
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 13:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349650AbiDSLsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 07:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351908AbiDSLrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 07:47:39 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AC962C0;
        Tue, 19 Apr 2022 04:44:56 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id bj24so12347602oib.11;
        Tue, 19 Apr 2022 04:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GhrWXEBejEoGYINmoxSt4Hg2zDfPVlPzh5IAsrk9hr4=;
        b=TCxMjKAMC9+71rvkYOvXr7pAqpfR5vi34e1w1UAKCOhGkGv0QouTFPHYOG5COXeIU1
         RJiyknrbwkpLwPm/O0BvUrt72SQ3OcInOCY67rKX+9apluM2gctJolsZIe75W4ePzya1
         E0B7CyiSgxFLdGJPQYw3OrASzApYn87ZH0zPJ5mNFooAD7L/J5yOw8S98NhuiPxvgdYC
         9m9qM2NWL1tOIJR8FqhP4C0RGqikzaCHREw5u7bONw0tkTTwFimkQu9G8vf4YuhaerHb
         UDVSVCByk4C+zCWoJhiy3t14nPqNX3aPRnMv8Ed/vdtfDnDabh8LWVtJU6RawlSLP9Dn
         ilMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GhrWXEBejEoGYINmoxSt4Hg2zDfPVlPzh5IAsrk9hr4=;
        b=sOOP6xa6In7V4lx91h/OzzSc5nRWwY0qlKxmPFoLdaTx69x59sbTww8wUulHNRgqix
         3fuuYW7afJxBitSB0Ga5p2NE1Dcixn9K7yXcriyQ8ZvGRsTsL7hK56VOrJxDi+T4g9BH
         aAGHdSbsVYgA8DMxtwruUxPh9LbMmo3wqhIJ3UIvvBjl9vdlynY6paDDHlSOm+5Do413
         3rB3QSb6X+XlTSAj5ipLSzL0QSCv8+I7s23PKh0gvPr4t/N2REBJSdfvSq++zqggiiyC
         Us811q2EvYuLVXl18tbbSlLJNRREr3CFI3UtpojqiLapCdYlqJyaE0ypJjcn8RI1yyDp
         iA+w==
X-Gm-Message-State: AOAM532OoYILmEa5RcivxZhehLc/CxwlFUQSGGAwFFnpFR79lQlN4Fkt
        JUGe+yV3jY3vUK0e31VUODuIwVvPER4=
X-Google-Smtp-Source: ABdhPJz24VZkEu+ZrwncyjJFqIb20zSy4c3vLKiE9WwJJvm6Uqim1aBTYTzEqJrjvm1imx1H1WTNMA==
X-Received: by 2002:aca:f185:0:b0:2ef:1fa6:3dca with SMTP id p127-20020acaf185000000b002ef1fa63dcamr6996766oih.140.1650368695479;
        Tue, 19 Apr 2022 04:44:55 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:7fde:d182:c6e:e90])
        by smtp.gmail.com with ESMTPSA id r19-20020a056830121300b005cdb11a7b85sm5299402otp.29.2022.04.19.04.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 04:44:54 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     horia.geanta@nxp.com, gaurav.jain@nxp.com, V.Sethi@nxp.com,
        linux-crypto@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        stable@vger.kernel.org
Subject: [PATCH v4] crypto: caam - fix i.MX6SX entropy delay value
Date:   Tue, 19 Apr 2022 08:44:44 -0300
Message-Id: <20220419114444.586113-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Cc: <stable@vger.kernel.org>
Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWNG") 
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Changes since v3:
- Add a needs_extended_entropy_delay() function
- Assign the 'ent_delay' inside the the RNG initialization area. (Horia)
- Change the terminology as per Horia's explanation.

 drivers/crypto/caam/ctrl.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ca0361b2dbb0..5b989a842ee9 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -609,6 +609,13 @@ static bool check_version(struct fsl_mc_version *mc_version, u32 major,
 }
 #endif
 
+static bool needs_extended_entropy_delay(void)
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
+			if (needs_extended_entropy_delay())
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
+			if (needs_extended_entropy_delay())
+				break;
 			if (ret == -EAGAIN)
 				/*
 				 * if here, the loop will rerun,
-- 
2.25.1

