Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD2028C986
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 09:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390370AbgJMHpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 03:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390040AbgJMHpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 03:45:33 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB53C0613D0
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 00:45:31 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id p21so1636956pju.0
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 00:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/BBYt5qfxGVTYyf9UVa21a/5NWY03nWYRJexUhXeug8=;
        b=u/wscxaz8hf5YKv6zTpS3exp0w6pt0ucRq47tr/iR4r3dm2aTQAIePScEwdTQ5PRDP
         tsXmoVHy3xNm54y5T6w+BHQwRzwPnpYJxw68A6w/0wdcNDY+lvECs5GjoET17sPT6pwu
         brLnbuO0Eb3mxJaDEst1N+YI+1NIRi4NFSFz4rQei/sxk/qkDg3uU2JrlJu6Jjblr1zC
         k3uYA7f1TQ96dY/E4FqCy4BGrTsKV9G1oE3+uy8UO39ob1SRgeKcXZYpkM0ZkDA/IEQk
         T/dtizV64zriSfBrkRFeB4g/3QOo6vSnDfxfZryXIATjtVjsJPIkEBB7dKdgirnL2JVq
         wFNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/BBYt5qfxGVTYyf9UVa21a/5NWY03nWYRJexUhXeug8=;
        b=Wp20qYhSCwAI0aVSoOMkGOS9IaVHA12i3W1q+Lg+MnfUzXHt5M0oBNUl0AM9I3B/Bz
         idjFdKPAqrFSelwms5oDw+Py6QNO4iV2uz7n/jQ5zNPvNUJdgav7NNps7hI8jWdK1x2G
         TxqimdUVM2vF10ncFn1+SQDrNrI+h+YE5T9mEG8LeDPZLPVA/5+GBRVMzq/K1/8HL9vk
         F437GLsA/kZunuC9aEg+JX2XO0HHN77lv2TgdqxXtIbTzf0ObsW/5eBk3lGElZvWs4L9
         0YV1C4wgKVyX9Q5cIc+fIrXGlIb8amPyxEFDnREFFrM7LkKhoPHmkREFPEPZqAJ774Dn
         3VjQ==
X-Gm-Message-State: AOAM5331elqX3VY2FYFZutekvZAJDMUh7ngY/+jaPvWqnasAICeZT9jn
        fq+FD1oJ4qpTqmgoP4lvDOU=
X-Google-Smtp-Source: ABdhPJwJ4TMxzEtNk1YtIm64VVnux94AB2zChk7aFB0tJ6g1gB/t09ooIj9WXMHs5pFuO1w53U/GXg==
X-Received: by 2002:a17:902:6bc4:b029:d3:f22f:aebe with SMTP id m4-20020a1709026bc4b02900d3f22faebemr27507031plt.12.1602575130959;
        Tue, 13 Oct 2020 00:45:30 -0700 (PDT)
Received: from gli-arch.genesyslogic.com.tw (60-251-58-169.HINET-IP.hinet.net. [60.251.58.169])
        by smtp.gmail.com with ESMTPSA id x4sm21260321pfx.106.2020.10.13.00.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 00:45:30 -0700 (PDT)
From:   Ben Chuang <benchuanggli@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, ben.chuang@genesyslogic.com.tw,
        greg.tu@genesyslogic.com.tw, seanhy.chen@genesyslogic.com.tw,
        Ben Chuang <benchuanggli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] mmc: sdhci-pci-gli: Set SDR104's clock to 205MHz and enable SSC for GL975x
Date:   Tue, 13 Oct 2020 15:46:00 +0800
Message-Id: <20201013074600.9784-1-benchuanggli@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Chuang <ben.chuang@genesyslogic.com.tw>

commit 786d33c887e15061ff95942db68fe5c6ca98e5fc upstream.

Set SDR104's clock to 205MHz and enable SSC for GL9750 and GL9755

Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
Link: https://lore.kernel.org/r/20200717033350.13006-1-benchuanggli@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: <stable@vger.kernel.org> # 5.4.x
---
Hi Greg and Sasha,

The patch is to improve the EMI of the hardware.
So it should be also required for some hardware devices using the v5.4.
Please tell me if have other questions.

Best regards,
Ben

 drivers/mmc/host/sdhci-pci-gli.c | 220 ++++++++++++++++++++++++++++++-
 1 file changed, 218 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci-gli.c b/drivers/mmc/host/sdhci-pci-gli.c
index fd76aa672e02..29d982eb44fc 100644
--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -31,10 +31,18 @@
 #define   SDHCI_GLI_9750_ALL_RST      (BIT(24)|BIT(25)|BIT(28)|BIT(30))
 
 #define SDHCI_GLI_9750_PLL	      0x864
+#define   SDHCI_GLI_9750_PLL_LDIV       GENMASK(9, 0)
+#define   SDHCI_GLI_9750_PLL_PDIV       GENMASK(14, 12)
+#define   SDHCI_GLI_9750_PLL_DIR        BIT(15)
 #define   SDHCI_GLI_9750_PLL_TX2_INV    BIT(23)
 #define   SDHCI_GLI_9750_PLL_TX2_DLY    GENMASK(22, 20)
 #define   GLI_9750_PLL_TX2_INV_VALUE    0x1
 #define   GLI_9750_PLL_TX2_DLY_VALUE    0x0
+#define   SDHCI_GLI_9750_PLLSSC_STEP    GENMASK(28, 24)
+#define   SDHCI_GLI_9750_PLLSSC_EN      BIT(31)
+
+#define SDHCI_GLI_9750_PLLSSC        0x86C
+#define   SDHCI_GLI_9750_PLLSSC_PPM    GENMASK(31, 16)
 
 #define SDHCI_GLI_9750_SW_CTRL      0x874
 #define   SDHCI_GLI_9750_SW_CTRL_4    GENMASK(7, 6)
@@ -63,6 +71,21 @@
 #define   SDHCI_GLI_9750_TUNING_PARAMETERS_RX_DLY    GENMASK(2, 0)
 #define   GLI_9750_TUNING_PARAMETERS_RX_DLY_VALUE    0x1
 
+#define PCI_GLI_9755_WT       0x800
+#define   PCI_GLI_9755_WT_EN    BIT(0)
+#define   GLI_9755_WT_EN_ON     0x1
+#define   GLI_9755_WT_EN_OFF    0x0
+
+#define PCI_GLI_9755_PLL            0x64
+#define   PCI_GLI_9755_PLL_LDIV       GENMASK(9, 0)
+#define   PCI_GLI_9755_PLL_PDIV       GENMASK(14, 12)
+#define   PCI_GLI_9755_PLL_DIR        BIT(15)
+#define   PCI_GLI_9755_PLLSSC_STEP    GENMASK(28, 24)
+#define   PCI_GLI_9755_PLLSSC_EN      BIT(31)
+
+#define PCI_GLI_9755_PLLSSC        0x68
+#define   PCI_GLI_9755_PLLSSC_PPM    GENMASK(15, 0)
+
 #define GLI_MAX_TUNING_LOOP 40
 
 /* Genesys Logic chipset */
@@ -267,6 +290,84 @@ static int gl9750_execute_tuning(struct sdhci_host *host, u32 opcode)
 	return 0;
 }
 
+static void gl9750_disable_ssc_pll(struct sdhci_host *host)
+{
+	u32 pll;
+
+	gl9750_wt_on(host);
+	pll = sdhci_readl(host, SDHCI_GLI_9750_PLL);
+	pll &= ~(SDHCI_GLI_9750_PLL_DIR | SDHCI_GLI_9750_PLLSSC_EN);
+	sdhci_writel(host, pll, SDHCI_GLI_9750_PLL);
+	gl9750_wt_off(host);
+}
+
+static void gl9750_set_pll(struct sdhci_host *host, u8 dir, u16 ldiv, u8 pdiv)
+{
+	u32 pll;
+
+	gl9750_wt_on(host);
+	pll = sdhci_readl(host, SDHCI_GLI_9750_PLL);
+	pll &= ~(SDHCI_GLI_9750_PLL_LDIV |
+		 SDHCI_GLI_9750_PLL_PDIV |
+		 SDHCI_GLI_9750_PLL_DIR);
+	pll |= FIELD_PREP(SDHCI_GLI_9750_PLL_LDIV, ldiv) |
+	       FIELD_PREP(SDHCI_GLI_9750_PLL_PDIV, pdiv) |
+	       FIELD_PREP(SDHCI_GLI_9750_PLL_DIR, dir);
+	sdhci_writel(host, pll, SDHCI_GLI_9750_PLL);
+	gl9750_wt_off(host);
+
+	/* wait for pll stable */
+	mdelay(1);
+}
+
+static void gl9750_set_ssc(struct sdhci_host *host, u8 enable, u8 step, u16 ppm)
+{
+	u32 pll;
+	u32 ssc;
+
+	gl9750_wt_on(host);
+	pll = sdhci_readl(host, SDHCI_GLI_9750_PLL);
+	ssc = sdhci_readl(host, SDHCI_GLI_9750_PLLSSC);
+	pll &= ~(SDHCI_GLI_9750_PLLSSC_STEP |
+		 SDHCI_GLI_9750_PLLSSC_EN);
+	ssc &= ~SDHCI_GLI_9750_PLLSSC_PPM;
+	pll |= FIELD_PREP(SDHCI_GLI_9750_PLLSSC_STEP, step) |
+	       FIELD_PREP(SDHCI_GLI_9750_PLLSSC_EN, enable);
+	ssc |= FIELD_PREP(SDHCI_GLI_9750_PLLSSC_PPM, ppm);
+	sdhci_writel(host, ssc, SDHCI_GLI_9750_PLLSSC);
+	sdhci_writel(host, pll, SDHCI_GLI_9750_PLL);
+	gl9750_wt_off(host);
+}
+
+static void gl9750_set_ssc_pll_205mhz(struct sdhci_host *host)
+{
+	/* set pll to 205MHz and enable ssc */
+	gl9750_set_ssc(host, 0x1, 0x1F, 0xFFE7);
+	gl9750_set_pll(host, 0x1, 0x246, 0x0);
+}
+
+static void sdhci_gl9750_set_clock(struct sdhci_host *host, unsigned int clock)
+{
+	struct mmc_ios *ios = &host->mmc->ios;
+	u16 clk;
+
+	host->mmc->actual_clock = 0;
+
+	gl9750_disable_ssc_pll(host);
+	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
+
+	if (clock == 0)
+		return;
+
+	clk = sdhci_calc_clk(host, clock, &host->mmc->actual_clock);
+	if (clock == 200000000 && ios->timing == MMC_TIMING_UHS_SDR104) {
+		host->mmc->actual_clock = 205000000;
+		gl9750_set_ssc_pll_205mhz(host);
+	}
+
+	sdhci_enable_clk(host, clk);
+}
+
 static void gli_pcie_enable_msi(struct sdhci_pci_slot *slot)
 {
 	int ret;
@@ -282,6 +383,121 @@ static void gli_pcie_enable_msi(struct sdhci_pci_slot *slot)
 	slot->host->irq = pci_irq_vector(slot->chip->pdev, 0);
 }
 
+static inline void gl9755_wt_on(struct pci_dev *pdev)
+{
+	u32 wt_value;
+	u32 wt_enable;
+
+	pci_read_config_dword(pdev, PCI_GLI_9755_WT, &wt_value);
+	wt_enable = FIELD_GET(PCI_GLI_9755_WT_EN, wt_value);
+
+	if (wt_enable == GLI_9755_WT_EN_ON)
+		return;
+
+	wt_value &= ~PCI_GLI_9755_WT_EN;
+	wt_value |= FIELD_PREP(PCI_GLI_9755_WT_EN, GLI_9755_WT_EN_ON);
+
+	pci_write_config_dword(pdev, PCI_GLI_9755_WT, wt_value);
+}
+
+static inline void gl9755_wt_off(struct pci_dev *pdev)
+{
+	u32 wt_value;
+	u32 wt_enable;
+
+	pci_read_config_dword(pdev, PCI_GLI_9755_WT, &wt_value);
+	wt_enable = FIELD_GET(PCI_GLI_9755_WT_EN, wt_value);
+
+	if (wt_enable == GLI_9755_WT_EN_OFF)
+		return;
+
+	wt_value &= ~PCI_GLI_9755_WT_EN;
+	wt_value |= FIELD_PREP(PCI_GLI_9755_WT_EN, GLI_9755_WT_EN_OFF);
+
+	pci_write_config_dword(pdev, PCI_GLI_9755_WT, wt_value);
+}
+
+static void gl9755_disable_ssc_pll(struct pci_dev *pdev)
+{
+	u32 pll;
+
+	gl9755_wt_on(pdev);
+	pci_read_config_dword(pdev, PCI_GLI_9755_PLL, &pll);
+	pll &= ~(PCI_GLI_9755_PLL_DIR | PCI_GLI_9755_PLLSSC_EN);
+	pci_write_config_dword(pdev, PCI_GLI_9755_PLL, pll);
+	gl9755_wt_off(pdev);
+}
+
+static void gl9755_set_pll(struct pci_dev *pdev, u8 dir, u16 ldiv, u8 pdiv)
+{
+	u32 pll;
+
+	gl9755_wt_on(pdev);
+	pci_read_config_dword(pdev, PCI_GLI_9755_PLL, &pll);
+	pll &= ~(PCI_GLI_9755_PLL_LDIV |
+		 PCI_GLI_9755_PLL_PDIV |
+		 PCI_GLI_9755_PLL_DIR);
+	pll |= FIELD_PREP(PCI_GLI_9755_PLL_LDIV, ldiv) |
+	       FIELD_PREP(PCI_GLI_9755_PLL_PDIV, pdiv) |
+	       FIELD_PREP(PCI_GLI_9755_PLL_DIR, dir);
+	pci_write_config_dword(pdev, PCI_GLI_9755_PLL, pll);
+	gl9755_wt_off(pdev);
+
+	/* wait for pll stable */
+	mdelay(1);
+}
+
+static void gl9755_set_ssc(struct pci_dev *pdev, u8 enable, u8 step, u16 ppm)
+{
+	u32 pll;
+	u32 ssc;
+
+	gl9755_wt_on(pdev);
+	pci_read_config_dword(pdev, PCI_GLI_9755_PLL, &pll);
+	pci_read_config_dword(pdev, PCI_GLI_9755_PLLSSC, &ssc);
+	pll &= ~(PCI_GLI_9755_PLLSSC_STEP |
+		 PCI_GLI_9755_PLLSSC_EN);
+	ssc &= ~PCI_GLI_9755_PLLSSC_PPM;
+	pll |= FIELD_PREP(PCI_GLI_9755_PLLSSC_STEP, step) |
+	       FIELD_PREP(PCI_GLI_9755_PLLSSC_EN, enable);
+	ssc |= FIELD_PREP(PCI_GLI_9755_PLLSSC_PPM, ppm);
+	pci_write_config_dword(pdev, PCI_GLI_9755_PLLSSC, ssc);
+	pci_write_config_dword(pdev, PCI_GLI_9755_PLL, pll);
+	gl9755_wt_off(pdev);
+}
+
+static void gl9755_set_ssc_pll_205mhz(struct pci_dev *pdev)
+{
+	/* set pll to 205MHz and enable ssc */
+	gl9755_set_ssc(pdev, 0x1, 0x1F, 0xFFE7);
+	gl9755_set_pll(pdev, 0x1, 0x246, 0x0);
+}
+
+static void sdhci_gl9755_set_clock(struct sdhci_host *host, unsigned int clock)
+{
+	struct sdhci_pci_slot *slot = sdhci_priv(host);
+	struct mmc_ios *ios = &host->mmc->ios;
+	struct pci_dev *pdev;
+	u16 clk;
+
+	pdev = slot->chip->pdev;
+	host->mmc->actual_clock = 0;
+
+	gl9755_disable_ssc_pll(pdev);
+	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
+
+	if (clock == 0)
+		return;
+
+	clk = sdhci_calc_clk(host, clock, &host->mmc->actual_clock);
+	if (clock == 200000000 && ios->timing == MMC_TIMING_UHS_SDR104) {
+		host->mmc->actual_clock = 205000000;
+		gl9755_set_ssc_pll_205mhz(pdev);
+	}
+
+	sdhci_enable_clk(host, clk);
+}
+
 static int gli_probe_slot_gl9750(struct sdhci_pci_slot *slot)
 {
 	struct sdhci_host *host = slot->host;
@@ -352,7 +568,7 @@ static int sdhci_pci_gli_resume(struct sdhci_pci_chip *chip)
 #endif
 
 static const struct sdhci_ops sdhci_gl9755_ops = {
-	.set_clock		= sdhci_set_clock,
+	.set_clock		= sdhci_gl9755_set_clock,
 	.enable_dma		= sdhci_pci_enable_dma,
 	.set_bus_width		= sdhci_set_bus_width,
 	.reset			= sdhci_reset,
@@ -372,7 +588,7 @@ const struct sdhci_pci_fixes sdhci_gl9755 = {
 
 static const struct sdhci_ops sdhci_gl9750_ops = {
 	.read_l                 = sdhci_gl9750_readl,
-	.set_clock		= sdhci_set_clock,
+	.set_clock		= sdhci_gl9750_set_clock,
 	.enable_dma		= sdhci_pci_enable_dma,
 	.set_bus_width		= sdhci_set_bus_width,
 	.reset			= sdhci_gl9750_reset,
-- 
2.28.0

