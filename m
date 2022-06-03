Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B93B53CFDC
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345947AbiFCR53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345878AbiFCR41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:56:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAEC1FA65;
        Fri,  3 Jun 2022 10:53:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 746D660A54;
        Fri,  3 Jun 2022 17:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72438C385A9;
        Fri,  3 Jun 2022 17:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278828;
        bh=tSQXz/ZFbI2pYTh4TigjjrPwJuuXCKdaX9A7q3dypck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkTaUJvMiNp+MANtIrszTc/TW3YQZ1D8QYdqHWNBAbVX+N4YL6ozD0ndJyi6Yp1RL
         5CqirfLC2aSrNpl9NRyli8RFX+otCr3YQKOTFKbXkZ32d8mv4U+uzE9IBMoBpLYWaX
         jdqWDll4UT8Kxsg6lgSTR3sKg5A+G5IQJ13RQR0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Vabhav Sharma <vabhav.sharma@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.17 40/75] crypto: caam - fix i.MX6SX entropy delay value
Date:   Fri,  3 Jun 2022 19:43:24 +0200
Message-Id: <20220603173822.883275707@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

commit 4ee4cdad368a26de3967f2975806a9ee2fa245df upstream.

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
Reviewed-by: Vabhav Sharma <vabhav.sharma@nxp.com>
Reviewed-by: Gaurav Jain <gaurav.jain@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/caam/ctrl.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -609,6 +609,13 @@ static bool check_version(struct fsl_mc_
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
@@ -855,6 +862,8 @@ static int caam_probe(struct platform_de
 			 * Also, if a handle was instantiated, do not change
 			 * the TRNG parameters.
 			 */
+			if (needs_entropy_delay_adjustment())
+				ent_delay = 12000;
 			if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
 				dev_info(dev,
 					 "Entropy delay = %u\n",
@@ -871,6 +880,15 @@ static int caam_probe(struct platform_de
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


