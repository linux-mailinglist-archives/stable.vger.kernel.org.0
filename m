Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1013B66CB0E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbjAPRKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234286AbjAPRJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:09:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF282B2A8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:50:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FD3B61086
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B51C433F1;
        Mon, 16 Jan 2023 16:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887802;
        bh=rkxcV86p09gZ/0QYcozZ7sZv55MK94rnaMHa4bNzZ1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUJdgdtqFjhvZLMQvynT68uU/dzjhcGO+OUJL5zhmrP9NnXwlBQS2japslXk5y0DX
         nA6m8+2SgUnRAvbZvyYbVRm++kEXSdXKhd6WRblEdMtdHQUwLX88wOKPYhDNHSA3uh
         wU9LO/tppr63pBAXnZysKwJfbDHvKv0fg6cXFZcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rohit kumar <rohitkr@codeaurora.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 287/521] remoteproc: qcom: Rename Hexagon v5 PAS driver
Date:   Mon, 16 Jan 2023 16:49:09 +0100
Message-Id: <20230116154859.980090017@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 9e004f97161d637d2dc82299be494bcfd07043bb ]

The Hexagon v5 ADSP driver is used for more than only the ADSP and
there's an upcoming non-PAS ADSP PIL for SDM845, so rename the driver to
qcom_q6v5_pas in order to better suite this.

Cc: Rohit kumar <rohitkr@codeaurora.org>
Reviewed-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: 38e7d9c19276 ("remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/Kconfig                    | 27 ++++++++++---------
 drivers/remoteproc/Makefile                   |  2 +-
 .../{qcom_adsp_pil.c => qcom_q6v5_pas.c}      |  4 +--
 3 files changed, 17 insertions(+), 16 deletions(-)
 rename drivers/remoteproc/{qcom_adsp_pil.c => qcom_q6v5_pas.c} (98%)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 052d4dd347f9..425e502c6471 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -84,8 +84,16 @@ config KEYSTONE_REMOTEPROC
 	  It's safe to say N here if you're not interested in the Keystone
 	  DSPs or just want to use a bare minimum kernel.
 
-config QCOM_ADSP_PIL
-	tristate "Qualcomm ADSP Peripheral Image Loader"
+config QCOM_RPROC_COMMON
+	tristate
+
+config QCOM_Q6V5_COMMON
+	tristate
+	depends on ARCH_QCOM
+	depends on QCOM_SMEM
+
+config QCOM_Q6V5_PAS
+	tristate "Qualcomm Hexagon v5 Peripheral Authentication Service support"
 	depends on OF && ARCH_QCOM
 	depends on QCOM_SMEM
 	depends on RPMSG_QCOM_SMD || (COMPILE_TEST && RPMSG_QCOM_SMD=n)
@@ -98,15 +106,7 @@ config QCOM_ADSP_PIL
 	select QCOM_SCM
 	help
 	  Say y here to support the TrustZone based Peripherial Image Loader
-	  for the Qualcomm ADSP remote processors.
-
-config QCOM_RPROC_COMMON
-	tristate
-
-config QCOM_Q6V5_COMMON
-	tristate
-	depends on ARCH_QCOM
-	depends on QCOM_SMEM
+	  for the Qualcomm Hexagon v5 based remote processors.
 
 config QCOM_Q6V5_PIL
 	tristate "Qualcomm Hexagon V5 Peripherial Image Loader"
@@ -120,8 +120,9 @@ config QCOM_Q6V5_PIL
 	select QCOM_RPROC_COMMON
 	select QCOM_SCM
 	help
-	  Say y here to support the Qualcomm Peripherial Image Loader for the
-	  Hexagon V5 based remote processors.
+	  Say y here to support the TrustZone based Peripherial Image Loader
+	  for the Qualcomm Hexagon v5 based remote processors. This is commonly
+	  used to control subsystems such as ADSP, Compute and Sensor.
 
 config QCOM_Q6V5_WCSS
 	tristate "Qualcomm Hexagon based WCSS Peripheral Image Loader"
diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
index 03332fa7e2ee..eb86c8ba5a87 100644
--- a/drivers/remoteproc/Makefile
+++ b/drivers/remoteproc/Makefile
@@ -14,9 +14,9 @@ obj-$(CONFIG_OMAP_REMOTEPROC)		+= omap_remoteproc.o
 obj-$(CONFIG_WKUP_M3_RPROC)		+= wkup_m3_rproc.o
 obj-$(CONFIG_DA8XX_REMOTEPROC)		+= da8xx_remoteproc.o
 obj-$(CONFIG_KEYSTONE_REMOTEPROC)	+= keystone_remoteproc.o
-obj-$(CONFIG_QCOM_ADSP_PIL)		+= qcom_adsp_pil.o
 obj-$(CONFIG_QCOM_RPROC_COMMON)		+= qcom_common.o
 obj-$(CONFIG_QCOM_Q6V5_COMMON)		+= qcom_q6v5.o
+obj-$(CONFIG_QCOM_Q6V5_PAS)		+= qcom_q6v5_pas.o
 obj-$(CONFIG_QCOM_Q6V5_PIL)		+= qcom_q6v5_pil.o
 obj-$(CONFIG_QCOM_Q6V5_WCSS)		+= qcom_q6v5_wcss.o
 obj-$(CONFIG_QCOM_SYSMON)		+= qcom_sysmon.o
diff --git a/drivers/remoteproc/qcom_adsp_pil.c b/drivers/remoteproc/qcom_q6v5_pas.c
similarity index 98%
rename from drivers/remoteproc/qcom_adsp_pil.c
rename to drivers/remoteproc/qcom_q6v5_pas.c
index d4339a6da616..2478ef3cd519 100644
--- a/drivers/remoteproc/qcom_adsp_pil.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -364,11 +364,11 @@ static struct platform_driver adsp_driver = {
 	.probe = adsp_probe,
 	.remove = adsp_remove,
 	.driver = {
-		.name = "qcom_adsp_pil",
+		.name = "qcom_q6v5_pas",
 		.of_match_table = adsp_of_match,
 	},
 };
 
 module_platform_driver(adsp_driver);
-MODULE_DESCRIPTION("Qualcomm MSM8974/MSM8996 ADSP Peripherial Image Loader");
+MODULE_DESCRIPTION("Qualcomm Hexagon v5 Peripheral Authentication Service driver");
 MODULE_LICENSE("GPL v2");
-- 
2.35.1



