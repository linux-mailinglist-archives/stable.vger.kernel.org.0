Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857DE601FAE
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiJRAiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiJRAhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:37:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F848E9A3;
        Mon, 17 Oct 2022 17:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6257FB81620;
        Tue, 18 Oct 2022 00:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E49C433D7;
        Tue, 18 Oct 2022 00:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051865;
        bh=NRxYzbakGYqdmEX9CLQwT6zIywJ3iuGNp/WtoYk+/GI=;
        h=From:To:Cc:Subject:Date:From;
        b=vCoOZxG8X9we+uHzSWN//b0TBnBg5ez8VDgH6mCHTfGt7ScbYHY5Naw+hrrNFXWh3
         Gr5mDtMVoE3LrgFTPjRJ8AFtxZlKZU7s/b9W8FObsOML1A8F5hHwnhBeFjvYWx3Fq1
         muj6KGWJ6Lx8q+DVua6cdwvYLrNFwG0sCe+ZAENSdPiKnCcTaz7b3T7ILTGBKIT/YS
         VwAN9zIKCCMFZ6tug621IoobSY7wbkum3sJ1BSipUfr4lHr5WKdOWr+LNO1uNAZ5yZ
         dGUkLDH0+Mcm7PFdx0ZwOhJnd+0CuHtmF1aBqUGqyD2GMk9/UCPeisiYqydJ6brwWS
         tvWyKlyc7rfzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        agross@kernel.org, andersson@kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/13] crypto: qcom-rng - Fix qcom_rng_of_match unused warning
Date:   Mon, 17 Oct 2022 20:10:50 -0400
Message-Id: <20221018001102.2731930-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 882aa6525cabcfa0cea61e1a19c9af4c543118ac ]

Module device tables need to be declared as maybe_unused because
they will be unused when built-in and the corresponding option is
also disabled.

This patch adds the maybe_unused attributes to OF and ACPI.  This
also allows us to remove the ifdef around the ACPI data structure.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qcom-rng.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 6cc4fd005fe0..648e3bc9c4e9 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -8,6 +8,7 @@
 #include <linux/clk.h>
 #include <linux/crypto.h>
 #include <linux/iopoll.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -200,15 +201,13 @@ static int qcom_rng_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_ACPI)
-static const struct acpi_device_id qcom_rng_acpi_match[] = {
+static const struct acpi_device_id __maybe_unused qcom_rng_acpi_match[] = {
 	{ .id = "QCOM8160", .driver_data = 1 },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, qcom_rng_acpi_match);
-#endif
 
-static const struct of_device_id qcom_rng_of_match[] = {
+static const struct of_device_id __maybe_unused qcom_rng_of_match[] = {
 	{ .compatible = "qcom,prng", .data = (void *)0},
 	{ .compatible = "qcom,prng-ee", .data = (void *)1},
 	{}
-- 
2.35.1

