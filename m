Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399D2658493
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbiL1Q62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiL1Q5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:57:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2D01DF04
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:54:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7578C6157E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6C7C433EF;
        Wed, 28 Dec 2022 16:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246445;
        bh=2vuIp7xoXRMPD2bc+HVIy5VN5APR07A+WEOo1yickug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2+aJMYwU9vEklaPZh6taLUbeqOoCdf1HXAjvvdBQ727SB687pRXtPDwxSDEFDUn5
         qWlrpZ3BYx08zi4fiF0zx7dxIUvVwRfv4gmZz32REenHCp86YgK/DiFna0giZDtuze
         8mrz2ik9xE4j7z4+NsNE+wXThNoLEWpM5NU5aq6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aniruddha TVS Rao <anrao@nvidia.com>,
        Prathamesh Shete <pshete@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1041/1146] mmc: sdhci-tegra: Issue CMD and DAT resets together
Date:   Wed, 28 Dec 2022 15:43:00 +0100
Message-Id: <20221228144358.616819006@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Prathamesh Shete <pshete@nvidia.com>

[ Upstream commit acc13958c2b2623c17e2450b8cd6881b698756d3 ]

In case of error condition to avoid system crash Tegra SDMMC controller
requires CMD and DAT resets issued together. SDHCI controller FSM goes
into bad state due to rapid SD card hot-plug event. Issuing reset on the
CMD FSM before DATA FSM results in kernel panic, hence add support to
issue CMD and DAT resets together.

This is applicable to Tegra186 and later chips.

Signed-off-by: Aniruddha TVS Rao <anrao@nvidia.com>
Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20221206165945.3551774-7-thierry.reding@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-tegra.c | 3 ++-
 drivers/mmc/host/sdhci.c       | 5 +++++
 drivers/mmc/host/sdhci.h       | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index c71000a07656..1adaa94c31ac 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -1526,7 +1526,8 @@ static const struct sdhci_pltfm_data sdhci_tegra186_pdata = {
 		  SDHCI_QUIRK_NO_HISPD_BIT |
 		  SDHCI_QUIRK_BROKEN_ADMA_ZEROLEN_DESC |
 		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
-	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN,
+	.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
+		   SDHCI_QUIRK2_ISSUE_CMD_DAT_RESET_TOGETHER,
 	.ops  = &tegra186_sdhci_ops,
 };
 
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index c7ad32a75b57..632341911b6e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -270,6 +270,11 @@ enum sdhci_reset_reason {
 
 static void sdhci_reset_for_reason(struct sdhci_host *host, enum sdhci_reset_reason reason)
 {
+	if (host->quirks2 & SDHCI_QUIRK2_ISSUE_CMD_DAT_RESET_TOGETHER) {
+		sdhci_do_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
+		return;
+	}
+
 	switch (reason) {
 	case SDHCI_RESET_FOR_INIT:
 		sdhci_do_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 87a3aaa07438..5ce7cdcc192f 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -478,6 +478,8 @@ struct sdhci_host {
  * block count.
  */
 #define SDHCI_QUIRK2_USE_32BIT_BLK_CNT			(1<<18)
+/* Issue CMD and DATA reset together */
+#define SDHCI_QUIRK2_ISSUE_CMD_DAT_RESET_TOGETHER	(1<<19)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
2.35.1



