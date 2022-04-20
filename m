Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC065081FB
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 09:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359736AbiDTHZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 03:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359700AbiDTHYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 03:24:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8944525C5F;
        Wed, 20 Apr 2022 00:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9F05B81D5B;
        Wed, 20 Apr 2022 07:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABA4C385A0;
        Wed, 20 Apr 2022 07:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650439320;
        bh=hvrz8wwBHArt0KOLxaOb0VNUx8fwAVFUBtSJQG84mPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaVP2UTpyB1JHoJ+lQ79CK23Ug1oBaHuXiStZFSD8LtQTBXzspCnbHy/DsL73nY/C
         TBHGbgE1C6an99G6EtOMRvAqohzo7CiNl1lpPqSKGfiG9uGh3h/HXgGJ8rtJqx8TwP
         aRiNGrze4RnNOxlSvCBOZeIPOqvzIadIFvFZl6uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.276
Date:   Wed, 20 Apr 2022 09:21:45 +0200
Message-Id: <165043930416211@kroah.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <16504393043175@kroah.com>
References: <16504393043175@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index 36a2dded525b..09a269fb8aa2 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -171,7 +171,16 @@ Trees
  - The finalized and tagged releases of all stable kernels can be found
    in separate branches per version at:
 
-	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
+	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
+
+ - The release candidate of all stable kernel versions can be found at:
+
+        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/
+
+   .. warning::
+      The -stable-rc tree is a snapshot in time of the stable-queue tree and
+      will change frequently, hence will be rebased often. It should only be
+      used for testing purposes (e.g. to be consumed by CI systems).
 
 
 Review committee
diff --git a/Makefile b/Makefile
index cad522127bb9..ce295ec15975 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 275
+SUBLEVEL = 276
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/boot/dts/bcm2837.dtsi b/arch/arm/boot/dts/bcm2837.dtsi
index d5d058a568c3..20407a5aafc8 100644
--- a/arch/arm/boot/dts/bcm2837.dtsi
+++ b/arch/arm/boot/dts/bcm2837.dtsi
@@ -32,12 +32,26 @@
 		#size-cells = <0>;
 		enable-method = "brcm,bcm2836-smp"; // for ARM 32-bit
 
+		/* Source for d/i-cache-line-size and d/i-cache-sets
+		 * https://developer.arm.com/documentation/ddi0500/e/level-1-memory-system
+		 * /about-the-l1-memory-system?lang=en
+		 *
+		 * Source for d/i-cache-size
+		 * https://magpi.raspberrypi.com/articles/raspberry-pi-3-specs-benchmarks
+		 */
 		cpu0: cpu@0 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a53";
 			reg = <0>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000d8>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>; // 32KiB(size)/64(line-size)=512ways/4-way set
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			next-level-cache = <&l2>;
 		};
 
 		cpu1: cpu@1 {
@@ -46,6 +60,13 @@
 			reg = <1>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000e0>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>; // 32KiB(size)/64(line-size)=512ways/4-way set
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			next-level-cache = <&l2>;
 		};
 
 		cpu2: cpu@2 {
@@ -54,6 +75,13 @@
 			reg = <2>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000e8>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>; // 32KiB(size)/64(line-size)=512ways/4-way set
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			next-level-cache = <&l2>;
 		};
 
 		cpu3: cpu@3 {
@@ -62,6 +90,27 @@
 			reg = <3>;
 			enable-method = "spin-table";
 			cpu-release-addr = <0x0 0x000000f0>;
+			d-cache-size = <0x8000>;
+			d-cache-line-size = <64>;
+			d-cache-sets = <128>; // 32KiB(size)/64(line-size)=512ways/4-way set
+			i-cache-size = <0x8000>;
+			i-cache-line-size = <64>;
+			i-cache-sets = <256>; // 32KiB(size)/64(line-size)=512ways/2-way set
+			next-level-cache = <&l2>;
+		};
+
+		/* Source for cache-line-size + cache-sets
+		 * https://developer.arm.com/documentation/ddi0500
+		 * /e/level-2-memory-system/about-the-l2-memory-system?lang=en
+		 * Source for cache-size
+		 * https://datasheets.raspberrypi.com/cm/cm1-and-cm3-datasheet.pdf
+		 */
+		l2: l2-cache0 {
+			compatible = "cache";
+			cache-size = <0x80000>;
+			cache-line-size = <64>;
+			cache-sets = <512>; // 512KiB(size)/64(line-size)=8192ways/16-way set
+			cache-level = <2>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
index 1fd122db18e6..48096768e33a 100644
--- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
@@ -257,7 +257,7 @@
 	};
 
 	uart3_data: uart3-data {
-		samsung,pins = "gpa1-4", "gpa1-4";
+		samsung,pins = "gpa1-4", "gpa1-5";
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
 		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 5065e6bf3778..a3c4b9e03fbf 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -117,6 +117,9 @@
 
 &hdmi {
 	hpd-gpios = <&gpx3 7 GPIO_ACTIVE_HIGH>;
+	vdd-supply = <&ldo8_reg>;
+	vdd_osc-supply = <&ldo10_reg>;
+	vdd_pll-supply = <&ldo8_reg>;
 };
 
 &i2c_0 {
diff --git a/arch/arm/boot/dts/exynos5420-smdk5420.dts b/arch/arm/boot/dts/exynos5420-smdk5420.dts
index 08c8ab173e87..9bd317aee6a1 100644
--- a/arch/arm/boot/dts/exynos5420-smdk5420.dts
+++ b/arch/arm/boot/dts/exynos5420-smdk5420.dts
@@ -133,6 +133,9 @@
 	hpd-gpios = <&gpx3 7 GPIO_ACTIVE_HIGH>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&hdmi_hpd_irq>;
+	vdd-supply = <&ldo6_reg>;
+	vdd_osc-supply = <&ldo7_reg>;
+	vdd_pll-supply = <&ldo6_reg>;
 };
 
 &hsi2c_4 {
diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index 19156cbb6003..ed218425a059 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -93,7 +93,8 @@
 	clocks {
 		sleep_clk: sleep_clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32768>;
+			clock-frequency = <32000>;
+			clock-output-names = "gcc_sleep_clk_src";
 			#clock-cells = <0>;
 		};
 
diff --git a/arch/arm/boot/dts/qcom-msm8960.dtsi b/arch/arm/boot/dts/qcom-msm8960.dtsi
index 1733d8f40ab1..b256fda0f5ea 100644
--- a/arch/arm/boot/dts/qcom-msm8960.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8960.dtsi
@@ -140,7 +140,9 @@
 			reg		= <0x108000 0x1000>;
 			qcom,ipc	= <&l2cc 0x8 2>;
 
-			interrupts	= <0 19 0>, <0 21 0>, <0 22 0>;
+			interrupts	= <GIC_SPI 19 IRQ_TYPE_EDGE_RISING>,
+					  <GIC_SPI 21 IRQ_TYPE_EDGE_RISING>,
+					  <GIC_SPI 22 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names	= "ack", "err", "wakeup";
 
 			regulators {
@@ -186,7 +188,7 @@
 				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 				reg = <0x16440000 0x1000>,
 				      <0x16400000 0x1000>;
-				interrupts = <0 154 0x0>;
+				interrupts = <GIC_SPI 154 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GSBI5_UART_CLK>, <&gcc GSBI5_H_CLK>;
 				clock-names = "core", "iface";
 				status = "disabled";
@@ -312,7 +314,7 @@
 				#address-cells = <1>;
 				#size-cells = <0>;
 				reg = <0x16080000 0x1000>;
-				interrupts = <0 147 0>;
+				interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
 				spi-max-frequency = <24000000>;
 				cs-gpios = <&msmgpio 8 0>;
 
diff --git a/arch/arm/boot/dts/sama5d2.dtsi b/arch/arm/boot/dts/sama5d2.dtsi
index d6e3f975323d..4c9869750efd 100644
--- a/arch/arm/boot/dts/sama5d2.dtsi
+++ b/arch/arm/boot/dts/sama5d2.dtsi
@@ -1121,7 +1121,7 @@
 				pmecc: ecc-engine@f8014070 {
 					compatible = "atmel,sama5d2-pmecc";
 					reg = <0xf8014070 0x490>,
-					      <0xf8014500 0x100>;
+					      <0xf8014500 0x200>;
 				};
 			};
 
diff --git a/arch/arm/boot/dts/spear1340.dtsi b/arch/arm/boot/dts/spear1340.dtsi
index d4dbc4098653..cf1139973bda 100644
--- a/arch/arm/boot/dts/spear1340.dtsi
+++ b/arch/arm/boot/dts/spear1340.dtsi
@@ -142,9 +142,9 @@
 				reg = <0xb4100000 0x1000>;
 				interrupts = <0 105 0x4>;
 				status = "disabled";
-				dmas = <&dwdma0 12 0 1>,
-					<&dwdma0 13 1 0>;
-				dma-names = "tx", "rx";
+				dmas = <&dwdma0 13 0 1>,
+					<&dwdma0 12 1 0>;
+				dma-names = "rx", "tx";
 			};
 
 			thermal@e07008c4 {
diff --git a/arch/arm/boot/dts/spear13xx.dtsi b/arch/arm/boot/dts/spear13xx.dtsi
index 086b4b333249..06eb7245d93e 100644
--- a/arch/arm/boot/dts/spear13xx.dtsi
+++ b/arch/arm/boot/dts/spear13xx.dtsi
@@ -290,9 +290,9 @@
 				#size-cells = <0>;
 				interrupts = <0 31 0x4>;
 				status = "disabled";
-				dmas = <&dwdma0 4 0 0>,
-					<&dwdma0 5 0 0>;
-				dma-names = "tx", "rx";
+				dmas = <&dwdma0 5 0 0>,
+					<&dwdma0 4 0 0>;
+				dma-names = "rx", "tx";
 			};
 
 			rtc@e0580000 {
diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 4d69d67792d1..b919ca29bb78 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -183,8 +183,8 @@
 			};
 			conf_ata {
 				nvidia,pins = "ata", "atb", "atc", "atd", "ate",
-					"cdev1", "cdev2", "dap1", "dtb", "gma",
-					"gmb", "gmc", "gmd", "gme", "gpu7",
+					"cdev1", "cdev2", "dap1", "dtb", "dtf",
+					"gma", "gmb", "gmc", "gmd", "gme", "gpu7",
 					"gpv", "i2cp", "irrx", "irtx", "pta",
 					"rm", "slxa", "slxk", "spia", "spib",
 					"uac";
@@ -203,7 +203,7 @@
 			};
 			conf_crtp {
 				nvidia,pins = "crtp", "dap2", "dap3", "dap4",
-					"dtc", "dte", "dtf", "gpu", "sdio1",
+					"dtc", "dte", "gpu", "sdio1",
 					"slxc", "slxd", "spdi", "spdo", "spig",
 					"uda";
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 686e7e6f2eb3..a29233da8e50 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1035,11 +1035,13 @@ static int __init da850_evm_config_emac(void)
 	int ret;
 	u32 val;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
-	u8 rmii_en = soc_info->emac_pdata->rmii_en;
+	u8 rmii_en;
 
 	if (!machine_is_davinci_da850_evm())
 		return 0;
 
+	rmii_en = soc_info->emac_pdata->rmii_en;
+
 	cfg_chip3_base = DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP3_REG);
 
 	val = __raw_readl(cfg_chip3_base);
diff --git a/arch/arm/mach-mmp/sram.c b/arch/arm/mach-mmp/sram.c
index bf5e64906e65..a41162dc4af4 100644
--- a/arch/arm/mach-mmp/sram.c
+++ b/arch/arm/mach-mmp/sram.c
@@ -75,6 +75,8 @@ static int sram_probe(struct platform_device *pdev)
 	if (!info)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, info);
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no memory resource defined\n");
@@ -110,8 +112,6 @@ static int sram_probe(struct platform_device *pdev)
 	list_add(&info->node, &sram_bank_list);
 	mutex_unlock(&sram_lock);
 
-	platform_set_drvdata(pdev, info);
-
 	dev_info(&pdev->dev, "initialized\n");
 	return 0;
 
@@ -130,17 +130,19 @@ static int sram_remove(struct platform_device *pdev)
 	struct sram_bank_info *info;
 
 	info = platform_get_drvdata(pdev);
-	if (info == NULL)
-		return -ENODEV;
 
-	mutex_lock(&sram_lock);
-	list_del(&info->node);
-	mutex_unlock(&sram_lock);
+	if (info->sram_size) {
+		mutex_lock(&sram_lock);
+		list_del(&info->node);
+		mutex_unlock(&sram_lock);
+
+		gen_pool_destroy(info->gpool);
+		iounmap(info->sram_virt);
+		kfree(info->pool_name);
+	}
 
-	gen_pool_destroy(info->gpool);
-	iounmap(info->sram_virt);
-	kfree(info->pool_name);
 	kfree(info);
+
 	return 0;
 }
 
diff --git a/arch/arm/mach-s3c24xx/mach-jive.c b/arch/arm/mach-s3c24xx/mach-jive.c
index 17821976f769..5de514940a9c 100644
--- a/arch/arm/mach-s3c24xx/mach-jive.c
+++ b/arch/arm/mach-s3c24xx/mach-jive.c
@@ -241,11 +241,11 @@ static int __init jive_mtdset(char *options)
 	unsigned long set;
 
 	if (options == NULL || options[0] == '\0')
-		return 0;
+		return 1;
 
 	if (kstrtoul(options, 10, &set)) {
 		printk(KERN_ERR "failed to parse mtdset=%s\n", options);
-		return 0;
+		return 1;
 	}
 
 	switch (set) {
@@ -260,7 +260,7 @@ static int __init jive_mtdset(char *options)
 		       "using default.", set);
 	}
 
-	return 0;
+	return 1;
 }
 
 /* parse the mtdset= option given to the kernel command line */
diff --git a/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts b/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts
index ec19fbf928a1..12a4b1c03390 100644
--- a/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts
+++ b/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts
@@ -111,8 +111,8 @@
 		compatible = "silabs,si3226x";
 		reg = <0>;
 		spi-max-frequency = <5000000>;
-		spi-cpha = <1>;
-		spi-cpol = <1>;
+		spi-cpha;
+		spi-cpol;
 		pl022,hierarchy = <0>;
 		pl022,interface = <0>;
 		pl022,slave-tx-disable = <0>;
@@ -135,8 +135,8 @@
 		at25,byte-len = <0x8000>;
 		at25,addr-mode = <2>;
 		at25,page-size = <64>;
-		spi-cpha = <1>;
-		spi-cpol = <1>;
+		spi-cpha;
+		spi-cpol;
 		pl022,hierarchy = <0>;
 		pl022,interface = <0>;
 		pl022,slave-tx-disable = <0>;
diff --git a/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi b/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
index 05f82819ae2d..46676af48c31 100644
--- a/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
+++ b/arch/arm64/boot/dts/broadcom/northstar2/ns2.dtsi
@@ -687,7 +687,7 @@
 			};
 		};
 
-		sata: ahci@663f2000 {
+		sata: sata@663f2000 {
 			compatible = "brcm,iproc-ahci", "generic-ahci";
 			reg = <0x663f2000 0x1000>;
 			dma-coherent;
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 4381aa7b071d..8ac4f47cde33 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -233,8 +233,8 @@ static int __kprobes aarch64_insn_patch_text_cb(void *arg)
 	int i, ret = 0;
 	struct aarch64_insn_patch *pp = arg;
 
-	/* The first CPU becomes master */
-	if (atomic_inc_return(&pp->cpu_count) == 1) {
+	/* The last CPU becomes master */
+	if (atomic_inc_return(&pp->cpu_count) == num_online_cpus()) {
 		for (i = 0; ret == 0 && i < pp->insn_cnt; i++)
 			ret = aarch64_insn_patch_text_nosync(pp->text_addrs[i],
 							     pp->new_insns[i]);
diff --git a/arch/arm64/kernel/module.lds b/arch/arm64/kernel/module.lds
index 09a0eef71d12..9371abe2f4c2 100644
--- a/arch/arm64/kernel/module.lds
+++ b/arch/arm64/kernel/module.lds
@@ -1,5 +1,5 @@
 SECTIONS {
-	.plt 0 (NOLOAD) : { BYTE(0) }
-	.init.plt 0 (NOLOAD) : { BYTE(0) }
-	.text.ftrace_trampoline 0 (NOLOAD) : { BYTE(0) }
+	.plt 0 : { BYTE(0) }
+	.init.plt 0 : { BYTE(0) }
+	.text.ftrace_trampoline 0 : { BYTE(0) }
 }
diff --git a/arch/mips/dec/prom/Makefile b/arch/mips/dec/prom/Makefile
index ae73e42ac20b..4c369359cdab 100644
--- a/arch/mips/dec/prom/Makefile
+++ b/arch/mips/dec/prom/Makefile
@@ -5,4 +5,4 @@
 
 lib-y			+= init.o memory.o cmdline.o identify.o console.o
 
-lib-$(CONFIG_32BIT)	+= locore.o
+lib-$(CONFIG_CPU_R3000)	+= locore.o
diff --git a/arch/mips/include/asm/dec/prom.h b/arch/mips/include/asm/dec/prom.h
index b59a2103b61a..09538ff5e924 100644
--- a/arch/mips/include/asm/dec/prom.h
+++ b/arch/mips/include/asm/dec/prom.h
@@ -47,16 +47,11 @@
  */
 #define REX_PROM_MAGIC		0x30464354
 
-#ifdef CONFIG_64BIT
-
-#define prom_is_rex(magic)	1	/* KN04 and KN05 are REX PROMs.  */
-
-#else /* !CONFIG_64BIT */
-
-#define prom_is_rex(magic)	((magic) == REX_PROM_MAGIC)
-
-#endif /* !CONFIG_64BIT */
-
+/* KN04 and KN05 are REX PROMs, so only do the check for R3k systems.  */
+static inline bool prom_is_rex(u32 magic)
+{
+	return !IS_ENABLED(CONFIG_CPU_R3000) || magic == REX_PROM_MAGIC;
+}
 
 /*
  * 3MIN/MAXINE PROM entry points for DS5000/1xx's, DS5000/xx's and
diff --git a/arch/mips/include/asm/setup.h b/arch/mips/include/asm/setup.h
index d49d247d48a1..d48a5f18a267 100644
--- a/arch/mips/include/asm/setup.h
+++ b/arch/mips/include/asm/setup.h
@@ -14,7 +14,7 @@ static inline void setup_8250_early_printk_port(unsigned long base,
 	unsigned int reg_shift, unsigned int timeout) {}
 #endif
 
-extern void set_handler(unsigned long offset, void *addr, unsigned long len);
+void set_handler(unsigned long offset, const void *addr, unsigned long len);
 extern void set_uncached_handler(unsigned long offset, void *addr, unsigned long len);
 
 typedef void (*vi_handler_t)(void);
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 4a23d89e251c..abbc64788008 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -2017,19 +2017,19 @@ static void *set_vi_srs_handler(int n, vi_handler_t addr, int srs)
 		 * If no shadow set is selected then use the default handler
 		 * that does normal register saving and standard interrupt exit
 		 */
-		extern char except_vec_vi, except_vec_vi_lui;
-		extern char except_vec_vi_ori, except_vec_vi_end;
-		extern char rollback_except_vec_vi;
-		char *vec_start = using_rollback_handler() ?
-			&rollback_except_vec_vi : &except_vec_vi;
+		extern const u8 except_vec_vi[], except_vec_vi_lui[];
+		extern const u8 except_vec_vi_ori[], except_vec_vi_end[];
+		extern const u8 rollback_except_vec_vi[];
+		const u8 *vec_start = using_rollback_handler() ?
+				      rollback_except_vec_vi : except_vec_vi;
 #if defined(CONFIG_CPU_MICROMIPS) || defined(CONFIG_CPU_BIG_ENDIAN)
-		const int lui_offset = &except_vec_vi_lui - vec_start + 2;
-		const int ori_offset = &except_vec_vi_ori - vec_start + 2;
+		const int lui_offset = except_vec_vi_lui - vec_start + 2;
+		const int ori_offset = except_vec_vi_ori - vec_start + 2;
 #else
-		const int lui_offset = &except_vec_vi_lui - vec_start;
-		const int ori_offset = &except_vec_vi_ori - vec_start;
+		const int lui_offset = except_vec_vi_lui - vec_start;
+		const int ori_offset = except_vec_vi_ori - vec_start;
 #endif
-		const int handler_len = &except_vec_vi_end - vec_start;
+		const int handler_len = except_vec_vi_end - vec_start;
 
 		if (handler_len > VECTORSPACING) {
 			/*
@@ -2249,7 +2249,7 @@ void per_cpu_trap_init(bool is_boot_cpu)
 }
 
 /* Install CPU exception handler */
-void set_handler(unsigned long offset, void *addr, unsigned long size)
+void set_handler(unsigned long offset, const void *addr, unsigned long size)
 {
 #ifdef CONFIG_CPU_MICROMIPS
 	memcpy((void *)(ebase + offset), ((unsigned char *)addr - 1), size);
diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
index 32ea3e6731d6..ea500873f023 100644
--- a/arch/mips/rb532/devices.c
+++ b/arch/mips/rb532/devices.c
@@ -313,11 +313,9 @@ static int __init plat_setup_devices(void)
 static int __init setup_kmac(char *s)
 {
 	printk(KERN_INFO "korina mac = %s\n", s);
-	if (!mac_pton(s, korina_dev0_data.mac)) {
+	if (!mac_pton(s, korina_dev0_data.mac))
 		printk(KERN_ERR "Invalid mac\n");
-		return -EINVAL;
-	}
-	return 0;
+	return 1;
 }
 
 __setup("kmac=", setup_kmac);
diff --git a/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi b/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
index 5fdddbd2a62b..b0a9beab1c26 100644
--- a/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
@@ -139,12 +139,12 @@
 		fman@400000 {
 			ethernet@e6000 {
 				phy-handle = <&phy_rgmii_0>;
-				phy-connection-type = "rgmii";
+				phy-connection-type = "rgmii-id";
 			};
 
 			ethernet@e8000 {
 				phy-handle = <&phy_rgmii_1>;
-				phy-connection-type = "rgmii";
+				phy-connection-type = "rgmii-id";
 			};
 
 			mdio0: mdio@fc000 {
diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index cb4d6cd949fc..101b0fb7a80e 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -145,11 +145,18 @@ void __init reserve_crashkernel(void)
 	if (!crashk_res.start) {
 #ifdef CONFIG_PPC64
 		/*
-		 * On 64bit we split the RMO in half but cap it at half of
-		 * a small SLB (128MB) since the crash kernel needs to place
-		 * itself and some stacks to be in the first segment.
+		 * On the LPAR platform place the crash kernel to mid of
+		 * RMA size (512MB or more) to ensure the crash kernel
+		 * gets enough space to place itself and some stack to be
+		 * in the first segment. At the same time normal kernel
+		 * also get enough space to allocate memory for essential
+		 * system resource in the first segment. Keep the crash
+		 * kernel starts at 128MB offset on other platforms.
 		 */
-		crashk_res.start = min(0x8000000ULL, (ppc64_rma_size / 2));
+		if (firmware_has_feature(FW_FEATURE_LPAR))
+			crashk_res.start = ppc64_rma_size / 2;
+		else
+			crashk_res.start = min(0x8000000ULL, (ppc64_rma_size / 2));
 #else
 		crashk_res.start = KDUMP_KERNELBASE;
 #endif
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 55b266d7afe1..912e7f69266e 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -1356,6 +1356,12 @@ int __init early_init_dt_scan_rtas(unsigned long node,
 	entryp = of_get_flat_dt_prop(node, "linux,rtas-entry", NULL);
 	sizep  = of_get_flat_dt_prop(node, "rtas-size", NULL);
 
+#ifdef CONFIG_PPC64
+	/* need this feature to decide the crashkernel offset */
+	if (of_get_flat_dt_prop(node, "ibm,hypertas-functions", NULL))
+		powerpc_firmware_features |= FW_FEATURE_LPAR;
+#endif
+
 	if (basep && entryp && sizep) {
 		rtas.base = *basep;
 		rtas.entry = *entryp;
diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index eb3f7237d09a..e9bfd9751246 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -908,7 +908,10 @@ NOKPROBE_SYMBOL(emulate_dcbz);
 
 #define __put_user_asmx(x, addr, err, op, cr)		\
 	__asm__ __volatile__(				\
+		".machine push\n"			\
+		".machine power8\n"			\
 		"1:	" op " %2,0,%3\n"		\
+		".machine pop\n"			\
 		"	mfcr	%1\n"			\
 		"2:\n"					\
 		".section .fixup,\"ax\"\n"		\
@@ -921,7 +924,10 @@ NOKPROBE_SYMBOL(emulate_dcbz);
 
 #define __get_user_asmx(x, addr, err, op)		\
 	__asm__ __volatile__(				\
+		".machine push\n"			\
+		".machine power8\n"			\
 		"1:	"op" %1,0,%2\n"			\
+		".machine pop\n"			\
 		"2:\n"					\
 		".section .fixup,\"ax\"\n"		\
 		"3:	li	%0,%3\n"		\
@@ -2776,7 +2782,7 @@ int emulate_loadstore(struct pt_regs *regs, struct instruction_op *op)
 			__put_user_asmx(op->val, ea, err, "stbcx.", cr);
 			break;
 		case 2:
-			__put_user_asmx(op->val, ea, err, "stbcx.", cr);
+			__put_user_asmx(op->val, ea, err, "sthcx.", cr);
 			break;
 #endif
 		case 4:
diff --git a/arch/powerpc/sysdev/fsl_gtm.c b/arch/powerpc/sysdev/fsl_gtm.c
index d902306f4718..42fe959f6fc2 100644
--- a/arch/powerpc/sysdev/fsl_gtm.c
+++ b/arch/powerpc/sysdev/fsl_gtm.c
@@ -90,7 +90,7 @@ static LIST_HEAD(gtms);
  */
 struct gtm_timer *gtm_get_timer16(void)
 {
-	struct gtm *gtm = NULL;
+	struct gtm *gtm;
 	int i;
 
 	list_for_each_entry(gtm, &gtms, list_node) {
@@ -107,7 +107,7 @@ struct gtm_timer *gtm_get_timer16(void)
 		spin_unlock_irq(&gtm->lock);
 	}
 
-	if (gtm)
+	if (!list_empty(&gtms))
 		return ERR_PTR(-EBUSY);
 	return ERR_PTR(-ENODEV);
 }
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 990ca9614b23..ad273bba5126 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -460,7 +460,7 @@ static u64 pt_config_filters(struct perf_event *event)
 			pt->filters.filter[range].msr_b = filter->msr_b;
 		}
 
-		rtit_ctl |= filter->config << pt_address_ranges[range].reg_off;
+		rtit_ctl |= (u64)filter->config << pt_address_ranges[range].reg_off;
 	}
 
 	return rtit_ctl;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 23d3329e1c73..c5f2a72343e3 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1682,11 +1682,6 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		goto exception;
 	}
 
-	if (!seg_desc.p) {
-		err_vec = (seg == VCPU_SREG_SS) ? SS_VECTOR : NP_VECTOR;
-		goto exception;
-	}
-
 	dpl = seg_desc.dpl;
 
 	switch (seg) {
@@ -1726,6 +1721,10 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	case VCPU_SREG_TR:
 		if (seg_desc.s || (seg_desc.type != 1 && seg_desc.type != 9))
 			goto exception;
+		if (!seg_desc.p) {
+			err_vec = NP_VECTOR;
+			goto exception;
+		}
 		old_desc = seg_desc;
 		seg_desc.type |= 2; /* busy */
 		ret = ctxt->ops->cmpxchg_emulated(ctxt, desc_addr, &old_desc, &seg_desc,
@@ -1750,6 +1749,11 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		break;
 	}
 
+	if (!seg_desc.p) {
+		err_vec = (seg == VCPU_SREG_SS) ? SS_VECTOR : NP_VECTOR;
+		goto exception;
+	}
+
 	if (seg_desc.s) {
 		/* mark segment as accessed */
 		if (!(seg_desc.type & 1)) {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2fba82b06c2d..5497eeef4e70 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -260,6 +260,9 @@ static int synic_set_msr(struct kvm_vcpu_hv_synic *synic,
 	case HV_X64_MSR_EOM: {
 		int i;
 
+		if (!synic->active)
+			break;
+
 		for (i = 0; i < ARRAY_SIZE(synic->sint); i++)
 			kvm_hv_notify_acked_sint(vcpu, i);
 		break;
@@ -520,6 +523,12 @@ static int stimer_start(struct kvm_vcpu_hv_stimer *stimer)
 static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 			     bool host)
 {
+	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+
+	if (!synic->active && (!host || config))
+		return 1;
+
 	trace_kvm_hv_stimer_set_config(stimer_to_vcpu(stimer)->vcpu_id,
 				       stimer->index, config, host);
 
@@ -534,6 +543,12 @@ static int stimer_set_config(struct kvm_vcpu_hv_stimer *stimer, u64 config,
 static int stimer_set_count(struct kvm_vcpu_hv_stimer *stimer, u64 count,
 			    bool host)
 {
+	struct kvm_vcpu *vcpu = stimer_to_vcpu(stimer);
+	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
+
+	if (!synic->active && (!host || count))
+		return 1;
+
 	trace_kvm_hv_stimer_set_count(stimer_to_vcpu(stimer)->vcpu_id,
 				      stimer->index, count, host);
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d4fdf0e52144..99b3fa3a29bf 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1929,10 +1929,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
-
-	apic_set_tpr(apic, ((cr8 & 0x0f) << 4)
-		     | (kvm_lapic_get_reg(apic, APIC_TASKPRI) & 4));
+	apic_set_tpr(vcpu->arch.apic, (cr8 & 0x0f) << 4);
 }
 
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index cd944435dfbd..e0473c72062e 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -139,12 +139,10 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	/* MSR_K7_EVNTSELn */
 	pmc = get_gp_pmc(pmu, msr, MSR_K7_EVNTSEL0);
 	if (pmc) {
-		if (data == pmc->eventsel)
-			return 0;
-		if (!(data & pmu->reserved_bits)) {
+		data &= ~pmu->reserved_bits;
+		if (data != pmc->eventsel)
 			reprogram_gp_counter(pmc, data);
-			return 0;
-		}
+		return 0;
 	}
 
 	return 1;
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 3aa3149df07f..e00b8c36ab72 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -41,7 +41,8 @@ static void msr_save_context(struct saved_context *ctxt)
 	struct saved_msr *end = msr + ctxt->saved_msrs.num;
 
 	while (msr < end) {
-		msr->valid = !rdmsrl_safe(msr->info.msr_no, &msr->info.reg.q);
+		if (msr->valid)
+			rdmsrl(msr->info.msr_no, msr->info.reg.q);
 		msr++;
 	}
 }
@@ -426,8 +427,10 @@ static int msr_build_context(const u32 *msr_id, const int num)
 	}
 
 	for (i = saved_msrs->num, j = 0; i < total_num; i++, j++) {
+		u64 dummy;
+
 		msr_array[i].info.msr_no	= msr_id[j];
-		msr_array[i].valid		= false;
+		msr_array[i].valid		= !rdmsrl_safe(msr_id[j], &dummy);
 		msr_array[i].info.reg.q		= 0;
 	}
 	saved_msrs->num   = total_num;
@@ -514,10 +517,24 @@ static int pm_cpu_check(const struct x86_cpu_id *c)
 	return ret;
 }
 
+static void pm_save_spec_msr(void)
+{
+	u32 spec_msr_id[] = {
+		MSR_IA32_SPEC_CTRL,
+		MSR_IA32_TSX_CTRL,
+		MSR_TSX_FORCE_ABORT,
+		MSR_IA32_MCU_OPT_CTRL,
+		MSR_AMD64_LS_CFG,
+	};
+
+	msr_build_context(spec_msr_id, ARRAY_SIZE(spec_msr_id));
+}
+
 static int pm_check_save_msr(void)
 {
 	dmi_check_system(msr_save_dmi_table);
 	pm_cpu_check(msr_save_cpu_table);
+	pm_save_spec_msr();
 
 	return 0;
 }
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index 95997e6c0696..9813298ba57d 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -505,10 +505,7 @@ irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id)
 	return ret;
 }
 
-bool is_xen_pmu(int cpu)
-{
-	return (get_xenpmu_data() != NULL);
-}
+bool is_xen_pmu;
 
 void xen_pmu_init(int cpu)
 {
@@ -519,7 +516,7 @@ void xen_pmu_init(int cpu)
 
 	BUILD_BUG_ON(sizeof(struct xen_pmu_data) > PAGE_SIZE);
 
-	if (xen_hvm_domain())
+	if (xen_hvm_domain() || (cpu != 0 && !is_xen_pmu))
 		return;
 
 	xenpmu_data = (struct xen_pmu_data *)get_zeroed_page(GFP_KERNEL);
@@ -540,7 +537,8 @@ void xen_pmu_init(int cpu)
 	per_cpu(xenpmu_shared, cpu).xenpmu_data = xenpmu_data;
 	per_cpu(xenpmu_shared, cpu).flags = 0;
 
-	if (cpu == 0) {
+	if (!is_xen_pmu) {
+		is_xen_pmu = true;
 		perf_register_guest_info_callbacks(&xen_guest_cbs);
 		xen_pmu_arch_init();
 	}
diff --git a/arch/x86/xen/pmu.h b/arch/x86/xen/pmu.h
index 0e83a160589b..65c58894fc79 100644
--- a/arch/x86/xen/pmu.h
+++ b/arch/x86/xen/pmu.h
@@ -4,6 +4,8 @@
 
 #include <xen/interface/xenpmu.h>
 
+extern bool is_xen_pmu;
+
 irqreturn_t xen_pmu_irq_handler(int irq, void *dev_id);
 #ifdef CONFIG_XEN_HAVE_VPMU
 void xen_pmu_init(int cpu);
@@ -12,7 +14,6 @@ void xen_pmu_finish(int cpu);
 static inline void xen_pmu_init(int cpu) {}
 static inline void xen_pmu_finish(int cpu) {}
 #endif
-bool is_xen_pmu(int cpu);
 bool pmu_msr_read(unsigned int msr, uint64_t *val, int *err);
 bool pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err);
 int pmu_apic_update(uint32_t reg);
diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index f779d2a5b04c..54ffe4ddf9f9 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -126,7 +126,7 @@ int xen_smp_intr_init_pv(unsigned int cpu)
 	per_cpu(xen_irq_work, cpu).irq = rc;
 	per_cpu(xen_irq_work, cpu).name = callfunc_name;
 
-	if (is_xen_pmu(cpu)) {
+	if (is_xen_pmu) {
 		pmu_name = kasprintf(GFP_KERNEL, "pmu%d", cpu);
 		rc = bind_virq_to_irqhandler(VIRQ_XENPMU, cpu,
 					     xen_pmu_irq_handler,
diff --git a/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
index 9bf8bad1dd18..c33932568aa7 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
@@ -8,19 +8,19 @@
 			reg = <0x00000000 0x08000000>;
 			bank-width = <2>;
 			device-width = <2>;
-			partition@0x0 {
+			partition@0 {
 				label = "data";
 				reg = <0x00000000 0x06000000>;
 			};
-			partition@0x6000000 {
+			partition@6000000 {
 				label = "boot loader area";
 				reg = <0x06000000 0x00800000>;
 			};
-			partition@0x6800000 {
+			partition@6800000 {
 				label = "kernel image";
 				reg = <0x06800000 0x017e0000>;
 			};
-			partition@0x7fe0000 {
+			partition@7fe0000 {
 				label = "boot environment";
 				reg = <0x07fe0000 0x00020000>;
 			};
diff --git a/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
index 40c2f81f7cb6..7bde2ab2d6fb 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
@@ -8,19 +8,19 @@
 			reg = <0x08000000 0x01000000>;
 			bank-width = <2>;
 			device-width = <2>;
-			partition@0x0 {
+			partition@0 {
 				label = "boot loader area";
 				reg = <0x00000000 0x00400000>;
 			};
-			partition@0x400000 {
+			partition@400000 {
 				label = "kernel image";
 				reg = <0x00400000 0x00600000>;
 			};
-			partition@0xa00000 {
+			partition@a00000 {
 				label = "data";
 				reg = <0x00a00000 0x005e0000>;
 			};
-			partition@0xfe0000 {
+			partition@fe0000 {
 				label = "boot environment";
 				reg = <0x00fe0000 0x00020000>;
 			};
diff --git a/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
index fb8d3a9f33c2..0655b868749a 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
@@ -8,11 +8,11 @@
 			reg = <0x08000000 0x00400000>;
 			bank-width = <2>;
 			device-width = <2>;
-			partition@0x0 {
+			partition@0 {
 				label = "boot loader area";
 				reg = <0x00000000 0x003f0000>;
 			};
-			partition@0x3f0000 {
+			partition@3f0000 {
 				label = "boot environment";
 				reg = <0x003f0000 0x00010000>;
 			};
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 053287dfad65..533e811a0899 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -268,7 +268,7 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
-	skcipher_request_set_callback(skreq, aead_request_flags(req),
+	skcipher_request_set_callback(skreq, flags,
 				      req->base.complete, req->base.data);
 	skcipher_request_set_crypt(skreq, src, dst,
 				   req->cryptlen - authsize, req->iv);
diff --git a/drivers/acpi/acpica/nswalk.c b/drivers/acpi/acpica/nswalk.c
index 6b6e6f498cff..129fc61f14c4 100644
--- a/drivers/acpi/acpica/nswalk.c
+++ b/drivers/acpi/acpica/nswalk.c
@@ -203,6 +203,9 @@ acpi_ns_walk_namespace(acpi_object_type type,
 
 	if (start_node == ACPI_ROOT_OBJECT) {
 		start_node = acpi_gbl_root_node;
+		if (!start_node) {
+			return_ACPI_STATUS(AE_NO_NAMESPACE);
+		}
 	}
 
 	/* Null child means "get first node" */
diff --git a/drivers/acpi/apei/bert.c b/drivers/acpi/apei/bert.c
index 12771fcf0417..d2212e092c50 100644
--- a/drivers/acpi/apei/bert.c
+++ b/drivers/acpi/apei/bert.c
@@ -31,6 +31,7 @@
 
 #undef pr_fmt
 #define pr_fmt(fmt) "BERT: " fmt
+#define ACPI_BERT_PRINT_MAX_LEN 1024
 
 static int bert_disable;
 
@@ -59,8 +60,11 @@ static void __init bert_print_all(struct acpi_bert_region *region,
 		}
 
 		pr_info_once("Error records from previous boot:\n");
-
-		cper_estatus_print(KERN_INFO HW_ERR, estatus);
+		if (region_len < ACPI_BERT_PRINT_MAX_LEN)
+			cper_estatus_print(KERN_INFO HW_ERR, estatus);
+		else
+			pr_info_once("Max print length exceeded, table data is available at:\n"
+				     "/sys/firmware/acpi/tables/data/BERT");
 
 		/*
 		 * Because the boot error source is "one-time polled" type,
@@ -82,7 +86,7 @@ static int __init setup_bert_disable(char *str)
 {
 	bert_disable = 1;
 
-	return 0;
+	return 1;
 }
 __setup("bert_disable", setup_bert_disable);
 
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 5b149d2d52f4..575c63260fc8 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -898,7 +898,7 @@ EXPORT_SYMBOL_GPL(erst_clear);
 static int __init setup_erst_disable(char *str)
 {
 	erst_disable = 1;
-	return 0;
+	return 1;
 }
 
 __setup("erst_disable", setup_erst_disable);
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index 9cb74115a43d..3af53ae1f276 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -214,7 +214,7 @@ static int __init hest_ghes_dev_register(unsigned int ghes_count)
 static int __init setup_hest_disable(char *str)
 {
 	hest_disable = HEST_DISABLED;
-	return 0;
+	return 1;
 }
 
 __setup("hest_disable", setup_hest_disable);
diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 5b2e58cbeb35..54ec4e191a8e 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -678,6 +678,11 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 	cpc_obj = &out_obj->package.elements[0];
 	if (cpc_obj->type == ACPI_TYPE_INTEGER)	{
 		num_ent = cpc_obj->integer.value;
+		if (num_ent <= 1) {
+			pr_debug("Unexpected _CPC NumEntries value (%d) for CPU:%d\n",
+				 num_ent, pr->id);
+			goto out_free;
+		}
 	} else {
 		pr_debug("Unexpected entry type(%d) for NumEntries\n",
 				cpc_obj->type);
diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index da39117032df..94e1cac3997d 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -601,7 +601,7 @@ int __acpi_node_get_property_reference(const struct fwnode_handle *fwnode,
 	 */
 	if (obj->type == ACPI_TYPE_LOCAL_REFERENCE) {
 		if (index)
-			return -EINVAL;
+			return -ENOENT;
 
 		ret = acpi_bus_get_device(obj->reference.handle, &device);
 		if (ret)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 791374199e22..d3a7b3bb5043 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4588,6 +4588,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Crucial_CT*MX100*",		"MU01",	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+	{ "Samsung SSD 840 EVO*",	NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_NO_DMA_LOG |
+						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 840*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 4fd49d55bc3e..3d51e457a4cd 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1901,7 +1901,9 @@ static bool pm_ops_is_empty(const struct dev_pm_ops *ops)
 
 void device_pm_check_callbacks(struct device *dev)
 {
-	spin_lock_irq(&dev->power.lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
 	dev->power.no_pm_callbacks =
 		(!dev->bus || (pm_ops_is_empty(dev->bus->pm) &&
 		 !dev->bus->suspend && !dev->bus->resume)) &&
@@ -1911,5 +1913,5 @@ void device_pm_check_callbacks(struct device *dev)
 		(!dev->pm_domain || pm_ops_is_empty(&dev->pm_domain->ops)) &&
 		(!dev->driver || (pm_ops_is_empty(dev->driver->pm) &&
 		 !dev->driver->suspend && !dev->driver->resume));
-	spin_unlock_irq(&dev->power.lock);
+	spin_unlock_irqrestore(&dev->power.lock, flags);
 }
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 7e8589ce631c..204b4a84bdbb 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1690,22 +1690,22 @@ struct sib_info {
 };
 void drbd_bcast_event(struct drbd_device *device, const struct sib_info *sib);
 
-extern void notify_resource_state(struct sk_buff *,
+extern int notify_resource_state(struct sk_buff *,
 				  unsigned int,
 				  struct drbd_resource *,
 				  struct resource_info *,
 				  enum drbd_notification_type);
-extern void notify_device_state(struct sk_buff *,
+extern int notify_device_state(struct sk_buff *,
 				unsigned int,
 				struct drbd_device *,
 				struct device_info *,
 				enum drbd_notification_type);
-extern void notify_connection_state(struct sk_buff *,
+extern int notify_connection_state(struct sk_buff *,
 				    unsigned int,
 				    struct drbd_connection *,
 				    struct connection_info *,
 				    enum drbd_notification_type);
-extern void notify_peer_device_state(struct sk_buff *,
+extern int notify_peer_device_state(struct sk_buff *,
 				     unsigned int,
 				     struct drbd_peer_device *,
 				     struct peer_device_info *,
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 31d7fe4480af..5543876ec0e2 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -4598,7 +4598,7 @@ static int nla_put_notification_header(struct sk_buff *msg,
 	return drbd_notification_header_to_skb(msg, &nh, true);
 }
 
-void notify_resource_state(struct sk_buff *skb,
+int notify_resource_state(struct sk_buff *skb,
 			   unsigned int seq,
 			   struct drbd_resource *resource,
 			   struct resource_info *resource_info,
@@ -4640,16 +4640,17 @@ void notify_resource_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(resource, "Error %d while broadcasting event. Event seq:%u\n",
 			err, seq);
+	return err;
 }
 
-void notify_device_state(struct sk_buff *skb,
+int notify_device_state(struct sk_buff *skb,
 			 unsigned int seq,
 			 struct drbd_device *device,
 			 struct device_info *device_info,
@@ -4689,16 +4690,17 @@ void notify_device_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(device, "Error %d while broadcasting event. Event seq:%u\n",
 		 err, seq);
+	return err;
 }
 
-void notify_connection_state(struct sk_buff *skb,
+int notify_connection_state(struct sk_buff *skb,
 			     unsigned int seq,
 			     struct drbd_connection *connection,
 			     struct connection_info *connection_info,
@@ -4738,16 +4740,17 @@ void notify_connection_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(connection, "Error %d while broadcasting event. Event seq:%u\n",
 		 err, seq);
+	return err;
 }
 
-void notify_peer_device_state(struct sk_buff *skb,
+int notify_peer_device_state(struct sk_buff *skb,
 			      unsigned int seq,
 			      struct drbd_peer_device *peer_device,
 			      struct peer_device_info *peer_device_info,
@@ -4788,13 +4791,14 @@ void notify_peer_device_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(peer_device, "Error %d while broadcasting event. Event seq:%u\n",
 		 err, seq);
+	return err;
 }
 
 void notify_helper(enum drbd_notification_type type,
@@ -4845,7 +4849,7 @@ void notify_helper(enum drbd_notification_type type,
 		 err, seq);
 }
 
-static void notify_initial_state_done(struct sk_buff *skb, unsigned int seq)
+static int notify_initial_state_done(struct sk_buff *skb, unsigned int seq)
 {
 	struct drbd_genlmsghdr *dh;
 	int err;
@@ -4859,11 +4863,12 @@ static void notify_initial_state_done(struct sk_buff *skb, unsigned int seq)
 	if (nla_put_notification_header(skb, NOTIFY_EXISTS))
 		goto nla_put_failure;
 	genlmsg_end(skb, dh);
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 	pr_err("Error %d sending event. Event seq:%u\n", err, seq);
+	return err;
 }
 
 static void free_state_changes(struct list_head *list)
@@ -4890,6 +4895,7 @@ static int get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
 	unsigned int seq = cb->args[2];
 	unsigned int n;
 	enum drbd_notification_type flags = 0;
+	int err = 0;
 
 	/* There is no need for taking notification_mutex here: it doesn't
 	   matter if the initial state events mix with later state chage
@@ -4898,32 +4904,32 @@ static int get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
 
 	cb->args[5]--;
 	if (cb->args[5] == 1) {
-		notify_initial_state_done(skb, seq);
+		err = notify_initial_state_done(skb, seq);
 		goto out;
 	}
 	n = cb->args[4]++;
 	if (cb->args[4] < cb->args[3])
 		flags |= NOTIFY_CONTINUES;
 	if (n < 1) {
-		notify_resource_state_change(skb, seq, state_change->resource,
+		err = notify_resource_state_change(skb, seq, state_change->resource,
 					     NOTIFY_EXISTS | flags);
 		goto next;
 	}
 	n--;
 	if (n < state_change->n_connections) {
-		notify_connection_state_change(skb, seq, &state_change->connections[n],
+		err = notify_connection_state_change(skb, seq, &state_change->connections[n],
 					       NOTIFY_EXISTS | flags);
 		goto next;
 	}
 	n -= state_change->n_connections;
 	if (n < state_change->n_devices) {
-		notify_device_state_change(skb, seq, &state_change->devices[n],
+		err = notify_device_state_change(skb, seq, &state_change->devices[n],
 					   NOTIFY_EXISTS | flags);
 		goto next;
 	}
 	n -= state_change->n_devices;
 	if (n < state_change->n_devices * state_change->n_connections) {
-		notify_peer_device_state_change(skb, seq, &state_change->peer_devices[n],
+		err = notify_peer_device_state_change(skb, seq, &state_change->peer_devices[n],
 						NOTIFY_EXISTS | flags);
 		goto next;
 	}
@@ -4938,7 +4944,10 @@ static int get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
 		cb->args[4] = 0;
 	}
 out:
-	return skb->len;
+	if (err)
+		return err;
+	else
+		return skb->len;
 }
 
 int drbd_adm_get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index c72071c300bb..9b179b3d203a 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -207,7 +207,8 @@ void start_new_tl_epoch(struct drbd_connection *connection)
 void complete_master_bio(struct drbd_device *device,
 		struct bio_and_error *m)
 {
-	m->bio->bi_status = errno_to_blk_status(m->error);
+	if (unlikely(m->error))
+		m->bio->bi_status = errno_to_blk_status(m->error);
 	bio_endio(m->bio);
 	dec_ap_bio(device);
 }
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index b452359b6aae..1474250f9440 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1549,7 +1549,7 @@ int drbd_bitmap_io_from_worker(struct drbd_device *device,
 	return rv;
 }
 
-void notify_resource_state_change(struct sk_buff *skb,
+int notify_resource_state_change(struct sk_buff *skb,
 				  unsigned int seq,
 				  struct drbd_resource_state_change *resource_state_change,
 				  enum drbd_notification_type type)
@@ -1562,10 +1562,10 @@ void notify_resource_state_change(struct sk_buff *skb,
 		.res_susp_fen = resource_state_change->susp_fen[NEW],
 	};
 
-	notify_resource_state(skb, seq, resource, &resource_info, type);
+	return notify_resource_state(skb, seq, resource, &resource_info, type);
 }
 
-void notify_connection_state_change(struct sk_buff *skb,
+int notify_connection_state_change(struct sk_buff *skb,
 				    unsigned int seq,
 				    struct drbd_connection_state_change *connection_state_change,
 				    enum drbd_notification_type type)
@@ -1576,10 +1576,10 @@ void notify_connection_state_change(struct sk_buff *skb,
 		.conn_role = connection_state_change->peer_role[NEW],
 	};
 
-	notify_connection_state(skb, seq, connection, &connection_info, type);
+	return notify_connection_state(skb, seq, connection, &connection_info, type);
 }
 
-void notify_device_state_change(struct sk_buff *skb,
+int notify_device_state_change(struct sk_buff *skb,
 				unsigned int seq,
 				struct drbd_device_state_change *device_state_change,
 				enum drbd_notification_type type)
@@ -1589,10 +1589,10 @@ void notify_device_state_change(struct sk_buff *skb,
 		.dev_disk_state = device_state_change->disk_state[NEW],
 	};
 
-	notify_device_state(skb, seq, device, &device_info, type);
+	return notify_device_state(skb, seq, device, &device_info, type);
 }
 
-void notify_peer_device_state_change(struct sk_buff *skb,
+int notify_peer_device_state_change(struct sk_buff *skb,
 				     unsigned int seq,
 				     struct drbd_peer_device_state_change *p,
 				     enum drbd_notification_type type)
@@ -1606,7 +1606,7 @@ void notify_peer_device_state_change(struct sk_buff *skb,
 		.peer_resync_susp_dependency = p->resync_susp_dependency[NEW],
 	};
 
-	notify_peer_device_state(skb, seq, peer_device, &peer_device_info, type);
+	return notify_peer_device_state(skb, seq, peer_device, &peer_device_info, type);
 }
 
 static void broadcast_state_change(struct drbd_state_change *state_change)
@@ -1614,7 +1614,7 @@ static void broadcast_state_change(struct drbd_state_change *state_change)
 	struct drbd_resource_state_change *resource_state_change = &state_change->resource[0];
 	bool resource_state_has_changed;
 	unsigned int n_device, n_connection, n_peer_device, n_peer_devices;
-	void (*last_func)(struct sk_buff *, unsigned int, void *,
+	int (*last_func)(struct sk_buff *, unsigned int, void *,
 			  enum drbd_notification_type) = NULL;
 	void *uninitialized_var(last_arg);
 
diff --git a/drivers/block/drbd/drbd_state_change.h b/drivers/block/drbd/drbd_state_change.h
index ba80f612d6ab..d5b0479bc9a6 100644
--- a/drivers/block/drbd/drbd_state_change.h
+++ b/drivers/block/drbd/drbd_state_change.h
@@ -44,19 +44,19 @@ extern struct drbd_state_change *remember_old_state(struct drbd_resource *, gfp_
 extern void copy_old_to_new_state_change(struct drbd_state_change *);
 extern void forget_state_change(struct drbd_state_change *);
 
-extern void notify_resource_state_change(struct sk_buff *,
+extern int notify_resource_state_change(struct sk_buff *,
 					 unsigned int,
 					 struct drbd_resource_state_change *,
 					 enum drbd_notification_type type);
-extern void notify_connection_state_change(struct sk_buff *,
+extern int notify_connection_state_change(struct sk_buff *,
 					   unsigned int,
 					   struct drbd_connection_state_change *,
 					   enum drbd_notification_type type);
-extern void notify_device_state_change(struct sk_buff *,
+extern int notify_device_state_change(struct sk_buff *,
 				       unsigned int,
 				       struct drbd_device_state_change *,
 				       enum drbd_notification_type type);
-extern void notify_peer_device_state_change(struct sk_buff *,
+extern int notify_peer_device_state_change(struct sk_buff *,
 					    unsigned int,
 					    struct drbd_peer_device_state_change *,
 					    enum drbd_notification_type type);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c6157ccb9498..4c115c1e9209 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -765,33 +765,33 @@ static ssize_t loop_attr_backing_file_show(struct loop_device *lo, char *buf)
 
 static ssize_t loop_attr_offset_show(struct loop_device *lo, char *buf)
 {
-	return sprintf(buf, "%llu\n", (unsigned long long)lo->lo_offset);
+	return sysfs_emit(buf, "%llu\n", (unsigned long long)lo->lo_offset);
 }
 
 static ssize_t loop_attr_sizelimit_show(struct loop_device *lo, char *buf)
 {
-	return sprintf(buf, "%llu\n", (unsigned long long)lo->lo_sizelimit);
+	return sysfs_emit(buf, "%llu\n", (unsigned long long)lo->lo_sizelimit);
 }
 
 static ssize_t loop_attr_autoclear_show(struct loop_device *lo, char *buf)
 {
 	int autoclear = (lo->lo_flags & LO_FLAGS_AUTOCLEAR);
 
-	return sprintf(buf, "%s\n", autoclear ? "1" : "0");
+	return sysfs_emit(buf, "%s\n", autoclear ? "1" : "0");
 }
 
 static ssize_t loop_attr_partscan_show(struct loop_device *lo, char *buf)
 {
 	int partscan = (lo->lo_flags & LO_FLAGS_PARTSCAN);
 
-	return sprintf(buf, "%s\n", partscan ? "1" : "0");
+	return sysfs_emit(buf, "%s\n", partscan ? "1" : "0");
 }
 
 static ssize_t loop_attr_dio_show(struct loop_device *lo, char *buf)
 {
 	int dio = (lo->lo_flags & LO_FLAGS_DIRECT_IO);
 
-	return sprintf(buf, "%s\n", dio ? "1" : "0");
+	return sysfs_emit(buf, "%s\n", dio ? "1" : "0");
 }
 
 LOOP_ATTR_RO(backing_file);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 437d43747c6d..7e8f58c2f65b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -822,9 +822,17 @@ static int virtblk_probe(struct virtio_device *vdev)
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
 				   struct virtio_blk_config, blk_size,
 				   &blk_size);
-	if (!err)
+	if (!err) {
+		err = blk_validate_block_size(blk_size);
+		if (err) {
+			dev_err(&vdev->dev,
+				"virtio_blk: invalid block size: 0x%x\n",
+				blk_size);
+			goto out_free_tags;
+		}
+
 		blk_queue_logical_block_size(q, blk_size);
-	else
+	} else
 		blk_size = queue_logical_block_size(q);
 
 	/* Use topology information if available */
diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 661c82cde0f2..92a8960ceba5 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -95,6 +95,7 @@ static int atmel_trng_probe(struct platform_device *pdev)
 
 err_register:
 	clk_disable_unprepare(trng->clk);
+	atmel_trng_disable(trng);
 	return ret;
 }
 
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 11ec5c2715a9..d91a795ad432 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -134,14 +134,6 @@ static void tpm_dev_release(struct device *dev)
 	kfree(chip);
 }
 
-static void tpm_devs_release(struct device *dev)
-{
-	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
-
-	/* release the master device reference */
-	put_device(&chip->dev);
-}
-
 /**
  * tpm_class_shutdown() - prepare the TPM device for loss of power.
  * @dev: device to which the chip is associated.
@@ -205,7 +197,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->dev_num = rc;
 
 	device_initialize(&chip->dev);
-	device_initialize(&chip->devs);
 
 	chip->dev.class = tpm_class;
 	chip->dev.class->shutdown_pre = tpm_class_shutdown;
@@ -213,29 +204,12 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->dev.parent = pdev;
 	chip->dev.groups = chip->groups;
 
-	chip->devs.parent = pdev;
-	chip->devs.class = tpmrm_class;
-	chip->devs.release = tpm_devs_release;
-	/* get extra reference on main device to hold on
-	 * behalf of devs.  This holds the chip structure
-	 * while cdevs is in use.  The corresponding put
-	 * is in the tpm_devs_release (TPM2 only)
-	 */
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		get_device(&chip->dev);
-
 	if (chip->dev_num == 0)
 		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
-	chip->devs.devt =
-		MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
-
 	rc = dev_set_name(&chip->dev, "tpm%d", chip->dev_num);
-	if (rc)
-		goto out;
-	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
 	if (rc)
 		goto out;
 
@@ -243,9 +217,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
 
 	cdev_init(&chip->cdev, &tpm_fops);
-	cdev_init(&chip->cdevs, &tpmrm_fops);
 	chip->cdev.owner = THIS_MODULE;
-	chip->cdevs.owner = THIS_MODULE;
 
 	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
 	if (rc) {
@@ -257,7 +229,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	return chip;
 
 out:
-	put_device(&chip->devs);
 	put_device(&chip->dev);
 	return ERR_PTR(rc);
 }
@@ -306,14 +277,9 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 	}
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		rc = cdev_device_add(&chip->cdevs, &chip->devs);
-		if (rc) {
-			dev_err(&chip->devs,
-				"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
-				dev_name(&chip->devs), MAJOR(chip->devs.devt),
-				MINOR(chip->devs.devt), rc);
-			return rc;
-		}
+		rc = tpm_devs_add(chip);
+		if (rc)
+			goto err_del_cdev;
 	}
 
 	/* Make the chip available. */
@@ -321,6 +287,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
 	idr_replace(&dev_nums_idr, chip, chip->dev_num);
 	mutex_unlock(&idr_lock);
 
+	return 0;
+
+err_del_cdev:
+	cdev_device_del(&chip->cdev, &chip->dev);
 	return rc;
 }
 
@@ -449,7 +419,7 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	tpm_del_legacy_sysfs(chip);
 	tpm_bios_log_teardown(chip);
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		cdev_device_del(&chip->cdevs, &chip->devs);
+		tpm_devs_remove(chip);
 	tpm_del_char_device(chip);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_unregister);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 019fe80fedd8..7436da043040 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -593,4 +593,6 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
 		       u8 *cmd);
 int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 		      u32 cc, u8 *buf, size_t *bufsiz);
+int tpm_devs_add(struct tpm_chip *chip);
+void tpm_devs_remove(struct tpm_chip *chip);
 #endif
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index c7763a96cbaf..8e42bc096e83 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -540,3 +540,68 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 
 	return 0;
 }
+
+/*
+ * Put the reference to the main device.
+ */
+static void tpm_devs_release(struct device *dev)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devs);
+
+	/* release the master device reference */
+	put_device(&chip->dev);
+}
+
+/*
+ * Remove the device file for exposed TPM spaces and release the device
+ * reference. This may also release the reference to the master device.
+ */
+void tpm_devs_remove(struct tpm_chip *chip)
+{
+	cdev_device_del(&chip->cdevs, &chip->devs);
+	put_device(&chip->devs);
+}
+
+/*
+ * Add a device file to expose TPM spaces. Also take a reference to the
+ * main device.
+ */
+int tpm_devs_add(struct tpm_chip *chip)
+{
+	int rc;
+
+	device_initialize(&chip->devs);
+	chip->devs.parent = chip->dev.parent;
+	chip->devs.class = tpmrm_class;
+
+	/*
+	 * Get extra reference on main device to hold on behalf of devs.
+	 * This holds the chip structure while cdevs is in use. The
+	 * corresponding put is in the tpm_devs_release.
+	 */
+	get_device(&chip->dev);
+	chip->devs.release = tpm_devs_release;
+	chip->devs.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num + TPM_NUM_DEVICES);
+	cdev_init(&chip->cdevs, &tpmrm_fops);
+	chip->cdevs.owner = THIS_MODULE;
+
+	rc = dev_set_name(&chip->devs, "tpmrm%d", chip->dev_num);
+	if (rc)
+		goto err_put_devs;
+
+	rc = cdev_device_add(&chip->cdevs, &chip->devs);
+	if (rc) {
+		dev_err(&chip->devs,
+			"unable to cdev_device_add() %s, major %d, minor %d, err=%d\n",
+			dev_name(&chip->devs), MAJOR(chip->devs.devt),
+			MINOR(chip->devs.devt), rc);
+		goto err_put_devs;
+	}
+
+	return 0;
+
+err_put_devs:
+	put_device(&chip->devs);
+
+	return rc;
+}
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 0fb3a8e62e62..fa103e7a43b7 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2001,6 +2001,13 @@ static void virtcons_remove(struct virtio_device *vdev)
 	list_del(&portdev->list);
 	spin_unlock_irq(&pdrvdata_lock);
 
+	/* Device is going away, exit any polling for buffers */
+	virtio_break_device(vdev);
+	if (use_multiport(portdev))
+		flush_work(&portdev->control_work);
+	else
+		flush_work(&portdev->config_work);
+
 	/* Disable interrupts for vqs */
 	vdev->config->reset(vdev);
 	/* Finish up work that's lined up */
@@ -2274,7 +2281,7 @@ static struct virtio_driver virtio_rproc_serial = {
 	.remove =	virtcons_remove,
 };
 
-static int __init init(void)
+static int __init virtio_console_init(void)
 {
 	int err;
 
@@ -2311,7 +2318,7 @@ static int __init init(void)
 	return err;
 }
 
-static void __exit fini(void)
+static void __exit virtio_console_fini(void)
 {
 	reclaim_dma_bufs();
 
@@ -2321,8 +2328,8 @@ static void __exit fini(void)
 	class_destroy(pdrvdata.class);
 	debugfs_remove_recursive(pdrvdata.debugfs_dir);
 }
-module_init(init);
-module_exit(fini);
+module_init(virtio_console_init);
+module_exit(virtio_console_fini);
 
 MODULE_DESCRIPTION("Virtio console driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/clk/clk-clps711x.c b/drivers/clk/clk-clps711x.c
index 9193f64561f6..4dcf15a88269 100644
--- a/drivers/clk/clk-clps711x.c
+++ b/drivers/clk/clk-clps711x.c
@@ -32,11 +32,13 @@ static const struct clk_div_table spi_div_table[] = {
 	{ .val = 1, .div = 8, },
 	{ .val = 2, .div = 2, },
 	{ .val = 3, .div = 1, },
+	{ /* sentinel */ }
 };
 
 static const struct clk_div_table timer_div_table[] = {
 	{ .val = 0, .div = 256, },
 	{ .val = 1, .div = 1, },
+	{ /* sentinel */ }
 };
 
 struct clps711x_clk {
diff --git a/drivers/clk/loongson1/clk-loongson1c.c b/drivers/clk/loongson1/clk-loongson1c.c
index 3466f7320b40..e3aa502761a3 100644
--- a/drivers/clk/loongson1/clk-loongson1c.c
+++ b/drivers/clk/loongson1/clk-loongson1c.c
@@ -40,6 +40,7 @@ static const struct clk_div_table ahb_div_table[] = {
 	[1] = { .val = 1, .div = 4 },
 	[2] = { .val = 2, .div = 3 },
 	[3] = { .val = 3, .div = 3 },
+	[4] = { /* sentinel */ }
 };
 
 void __init ls1x_clk_init(void)
diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 6091d9b6a27b..9743af6ae84f 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -702,6 +702,7 @@ static const struct frac_entry frac_table_pixel[] = {
 	{ 2, 9 },
 	{ 4, 9 },
 	{ 1, 1 },
+	{ 2, 3 },
 	{ }
 };
 
diff --git a/drivers/clk/tegra/clk-emc.c b/drivers/clk/tegra/clk-emc.c
index 11a5066e5c27..8b47d57cad17 100644
--- a/drivers/clk/tegra/clk-emc.c
+++ b/drivers/clk/tegra/clk-emc.c
@@ -190,6 +190,7 @@ static struct tegra_emc *emc_ensure_emc_driver(struct tegra_clk_emc *tegra)
 
 	tegra->emc = platform_get_drvdata(pdev);
 	if (!tegra->emc) {
+		put_device(&pdev->dev);
 		pr_err("%s: cannot find EMC driver\n", __func__);
 		return NULL;
 	}
diff --git a/drivers/clk/uniphier/clk-uniphier-fixed-rate.c b/drivers/clk/uniphier/clk-uniphier-fixed-rate.c
index 0ad0d46173c0..225de2302cb7 100644
--- a/drivers/clk/uniphier/clk-uniphier-fixed-rate.c
+++ b/drivers/clk/uniphier/clk-uniphier-fixed-rate.c
@@ -33,6 +33,7 @@ struct clk_hw *uniphier_clk_register_fixed_rate(struct device *dev,
 
 	init.name = name;
 	init.ops = &clk_fixed_rate_ops;
+	init.flags = 0;
 	init.parent_names = NULL;
 	init.num_parents = 0;
 
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 1961e3539b57..05cc8d4e49ad 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -230,8 +230,10 @@ static int __init parse_pmtmr(char *arg)
 	int ret;
 
 	ret = kstrtouint(arg, 16, &base);
-	if (ret)
-		return ret;
+	if (ret) {
+		pr_warn("PMTMR: invalid 'pmtmr=' value: '%s'\n", arg);
+		return 1;
+	}
 
 	pr_info("PMTMR IOPort override: 0x%04x -> 0x%04x\n", pmtmr_ioport,
 		base);
diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index df82af3dd970..27a738c57119 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -632,6 +632,20 @@ static int ccp_terminate_all(struct dma_chan *dma_chan)
 	return 0;
 }
 
+static void ccp_dma_release(struct ccp_device *ccp)
+{
+	struct ccp_dma_chan *chan;
+	struct dma_chan *dma_chan;
+	unsigned int i;
+
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		chan = ccp->ccp_dma_chan + i;
+		dma_chan = &chan->dma_chan;
+		tasklet_kill(&chan->cleanup_tasklet);
+		list_del_rcu(&dma_chan->device_node);
+	}
+}
+
 int ccp_dmaengine_register(struct ccp_device *ccp)
 {
 	struct ccp_dma_chan *chan;
@@ -733,6 +747,7 @@ int ccp_dmaengine_register(struct ccp_device *ccp)
 	return 0;
 
 err_reg:
+	ccp_dma_release(ccp);
 	kmem_cache_destroy(ccp->dma_desc_cache);
 
 err_cache:
@@ -746,6 +761,7 @@ void ccp_dmaengine_unregister(struct ccp_device *ccp)
 	struct dma_device *dma_dev = &ccp->dma_dev;
 
 	dma_async_device_unregister(dma_dev);
+	ccp_dma_release(ccp);
 
 	kmem_cache_destroy(ccp->dma_desc_cache);
 	kmem_cache_destroy(ccp->dma_cmd_cache);
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index e986be405411..3e4068badffd 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -328,7 +328,7 @@ static int mxs_dcp_aes_block_crypt(struct crypto_async_request *arq)
 		memset(key + AES_KEYSIZE_128, 0, AES_KEYSIZE_128);
 	}
 
-	for_each_sg(req->src, src, sg_nents(src), i) {
+	for_each_sg(req->src, src, sg_nents(req->src), i) {
 		src_buf = sg_virt(src);
 		len = sg_dma_len(src);
 		tlen += len;
diff --git a/drivers/crypto/vmx/Kconfig b/drivers/crypto/vmx/Kconfig
index c3d524ea6998..f39eeca87932 100644
--- a/drivers/crypto/vmx/Kconfig
+++ b/drivers/crypto/vmx/Kconfig
@@ -1,7 +1,11 @@
 config CRYPTO_DEV_VMX_ENCRYPT
 	tristate "Encryption acceleration support on P8 CPU"
 	depends on CRYPTO_DEV_VMX
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_CTR
 	select CRYPTO_GHASH
+	select CRYPTO_XTS
 	default m
 	help
 	  Support for VMX cryptographic acceleration instructions on Power8 CPU.
diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 4f8dfe77da3c..12fa48e380cf 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -118,10 +118,8 @@ static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
 		ret = pm_runtime_get(schan->dev);
 
 		spin_unlock_irq(&schan->chan_lock);
-		if (ret < 0) {
+		if (ret < 0)
 			dev_err(schan->dev, "%s(): GET = %d\n", __func__, ret);
-			pm_runtime_put(schan->dev);
-		}
 
 		pm_runtime_barrier(schan->dev);
 
diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 60e394da9709..713dc43024c9 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -335,8 +335,8 @@ static acpi_status acpi_gpiochip_alloc_event(struct acpi_resource *ares,
 	pin = agpio->pin_table[0];
 
 	if (pin <= 255) {
-		char ev_name[5];
-		sprintf(ev_name, "_%c%02hhX",
+		char ev_name[8];
+		sprintf(ev_name, "_%c%02X",
 			agpio->triggering == ACPI_EDGE_SENSITIVE ? 'E' : 'L',
 			pin);
 		if (ACPI_SUCCESS(acpi_get_handle(handle, ev_name, &evt_handle)))
diff --git a/drivers/gpu/drm/amd/amdgpu/ObjectID.h b/drivers/gpu/drm/amd/amdgpu/ObjectID.h
index 06192698bd96..c90567de8bf7 100644
--- a/drivers/gpu/drm/amd/amdgpu/ObjectID.h
+++ b/drivers/gpu/drm/amd/amdgpu/ObjectID.h
@@ -119,6 +119,7 @@
 #define CONNECTOR_OBJECT_ID_eDP                   0x14
 #define CONNECTOR_OBJECT_ID_MXM                   0x15
 #define CONNECTOR_OBJECT_ID_LVDS_eDP              0x16
+#define CONNECTOR_OBJECT_ID_USBC                  0x17
 
 /* deleted */
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 4f6c68fc1dd9..f3bdd14e13a0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -157,7 +157,7 @@ static int amdgpu_gfx_kiq_acquire(struct amdgpu_device *adev,
 		    * adev->gfx.mec.num_pipe_per_mec
 		    * adev->gfx.mec.num_queue_per_pipe;
 
-	while (queue_bit-- >= 0) {
+	while (--queue_bit >= 0) {
 		if (test_bit(queue_bit, adev->gfx.mec.queue_bitmap))
 			continue;
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 944abfad39c1..1d8dd81dfc70 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -607,6 +607,8 @@ static struct kfd_event_waiter *alloc_event_waiters(uint32_t num_events)
 	event_waiters = kmalloc_array(num_events,
 					sizeof(struct kfd_event_waiter),
 					GFP_KERNEL);
+	if (!event_waiters)
+		return NULL;
 
 	for (i = 0; (event_waiters) && (i < num_events) ; i++) {
 		INIT_LIST_HEAD(&event_waiters[i].waiters);
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 4824c775dd7d..de5fc79379e8 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -4319,16 +4319,8 @@ static void drm_parse_hdmi_deep_color_info(struct drm_connector *connector,
 		  connector->name, dc_bpc);
 	info->bpc = dc_bpc;
 
-	/*
-	 * Deep color support mandates RGB444 support for all video
-	 * modes and forbids YCRCB422 support for all video modes per
-	 * HDMI 1.3 spec.
-	 */
-	info->color_formats = DRM_COLOR_FORMAT_RGB444;
-
 	/* YCRCB444 is optional according to spec. */
 	if (hdmi[6] & DRM_EDID_HDMI_DC_Y444) {
-		info->color_formats |= DRM_COLOR_FORMAT_YCRCB444;
 		DRM_DEBUG("%s: HDMI sink does YCRCB444 in deep color.\n",
 			  connector->name);
 	}
diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index 8def97d75030..6420dec6cc00 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -77,8 +77,10 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 		ret = of_get_drm_display_mode(np, &imxpd->mode,
 					      &imxpd->bus_flags,
 					      OF_USE_NATIVE_MODE);
-		if (ret)
+		if (ret) {
+			drm_mode_destroy(connector->dev, mode);
 			return ret;
+		}
 
 		drm_mode_copy(mode, &imxpd->mode);
 		mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED,
diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 046649ec9441..4e06af34c048 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -1480,8 +1480,10 @@ static int tegra_dsi_ganged_probe(struct tegra_dsi *dsi)
 		dsi->slave = platform_get_drvdata(gangster);
 		of_node_put(np);
 
-		if (!dsi->slave)
+		if (!dsi->slave) {
+			put_device(&gangster->dev);
 			return -EPROBE_DEFER;
+		}
 
 		dsi->slave->master = dsi;
 	}
diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
index d2f1bd9d3deb..c498dc7d8838 100644
--- a/drivers/gpu/ipu-v3/ipu-di.c
+++ b/drivers/gpu/ipu-v3/ipu-di.c
@@ -460,8 +460,9 @@ static void ipu_di_config_clock(struct ipu_di *di,
 
 		error = rate / (sig->mode.pixelclock / 1000);
 
-		dev_dbg(di->ipu->dev, "  IPU clock can give %lu with divider %u, error %d.%u%%\n",
-			rate, div, (signed)(error - 1000) / 10, error % 10);
+		dev_dbg(di->ipu->dev, "  IPU clock can give %lu with divider %u, error %c%d.%d%%\n",
+			rate, div, error < 1000 ? '-' : '+',
+			abs(error - 1000) / 10, abs(error - 1000) % 10);
 
 		/* Allow a 1% error */
 		if (error < 1010 && error >= 990) {
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index b16bf4358485..9a070d65ed34 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -582,6 +582,17 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
 	if (report_type == HID_OUTPUT_REPORT)
 		return -EINVAL;
 
+	/*
+	 * In case of unnumbered reports the response from the device will
+	 * not have the report ID that the upper layers expect, so we need
+	 * to stash it the buffer ourselves and adjust the data size.
+	 */
+	if (!report_number) {
+		buf[0] = 0;
+		buf++;
+		count--;
+	}
+
 	/* +2 bytes to include the size of the reply in the query buffer */
 	ask_count = min(count + 2, (size_t)ihid->bufsize);
 
@@ -603,6 +614,9 @@ static int i2c_hid_get_raw_report(struct hid_device *hid,
 	count = min(count, ret_count - 2);
 	memcpy(buf, ihid->rawbuf + 2, count);
 
+	if (!report_number)
+		count++;
+
 	return count;
 }
 
@@ -619,17 +633,19 @@ static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
 
 	mutex_lock(&ihid->reset_lock);
 
-	if (report_id) {
-		buf++;
-		count--;
-	}
-
+	/*
+	 * Note that both numbered and unnumbered reports passed here
+	 * are supposed to have report ID stored in the 1st byte of the
+	 * buffer, so we strip it off unconditionally before passing payload
+	 * to i2c_hid_set_or_send_report which takes care of encoding
+	 * everything properly.
+	 */
 	ret = i2c_hid_set_or_send_report(client,
 				report_type == HID_FEATURE_REPORT ? 0x03 : 0x02,
-				report_id, buf, count, use_data);
+				report_id, buf + 1, count - 1, use_data);
 
-	if (report_id && ret >= 0)
-		ret++; /* add report_id to the number of transfered bytes */
+	if (ret >= 0)
+		ret++; /* add report_id to the number of transferred bytes */
 
 	mutex_unlock(&ihid->reset_lock);
 
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 74c1dfb8183b..6b08e9d9b382 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -340,7 +340,16 @@ int hv_ringbuffer_read(struct vmbus_channel *channel,
 static u32 hv_pkt_iter_avail(const struct hv_ring_buffer_info *rbi)
 {
 	u32 priv_read_loc = rbi->priv_read_index;
-	u32 write_loc = READ_ONCE(rbi->ring_buffer->write_index);
+	u32 write_loc;
+
+	/*
+	 * The Hyper-V host writes the packet data, then uses
+	 * store_release() to update the write_index.  Use load_acquire()
+	 * here to prevent loads of the packet data from being re-ordered
+	 * before the read of the write_index and potentially getting
+	 * stale data.
+	 */
+	write_loc = virt_load_acquire(&rbi->ring_buffer->write_index);
 
 	if (write_loc >= priv_read_loc)
 		return write_loc - priv_read_loc;
diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
index fa613bd209e3..1fed8ed36d5e 100644
--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -262,6 +262,7 @@ enum pmbus_regs {
 /*
  * STATUS_VOUT, STATUS_INPUT
  */
+#define PB_VOLTAGE_VIN_OFF		BIT(3)
 #define PB_VOLTAGE_UV_FAULT		BIT(4)
 #define PB_VOLTAGE_UV_WARNING		BIT(5)
 #define PB_VOLTAGE_OV_WARNING		BIT(6)
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index cb9064ac4977..b736fe1a05b7 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1162,7 +1162,7 @@ static const struct pmbus_limit_attr vin_limit_attrs[] = {
 		.reg = PMBUS_VIN_UV_FAULT_LIMIT,
 		.attr = "lcrit",
 		.alarm = "lcrit_alarm",
-		.sbit = PB_VOLTAGE_UV_FAULT,
+		.sbit = PB_VOLTAGE_UV_FAULT | PB_VOLTAGE_VIN_OFF,
 	}, {
 		.reg = PMBUS_VIN_OV_WARN_LIMIT,
 		.attr = "max",
@@ -1861,10 +1861,14 @@ static int pmbus_regulator_is_enabled(struct regulator_dev *rdev)
 {
 	struct device *dev = rdev_get_dev(rdev);
 	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct pmbus_data *data = i2c_get_clientdata(client);
 	u8 page = rdev_get_id(rdev);
 	int ret;
 
+	mutex_lock(&data->update_lock);
 	ret = pmbus_read_byte_data(client, page, PMBUS_OPERATION);
+	mutex_unlock(&data->update_lock);
+
 	if (ret < 0)
 		return ret;
 
@@ -1875,11 +1879,17 @@ static int _pmbus_regulator_on_off(struct regulator_dev *rdev, bool enable)
 {
 	struct device *dev = rdev_get_dev(rdev);
 	struct i2c_client *client = to_i2c_client(dev->parent);
+	struct pmbus_data *data = i2c_get_clientdata(client);
 	u8 page = rdev_get_id(rdev);
+	int ret;
 
-	return pmbus_update_byte_data(client, page, PMBUS_OPERATION,
-				      PB_OPERATION_CONTROL_ON,
-				      enable ? PB_OPERATION_CONTROL_ON : 0);
+	mutex_lock(&data->update_lock);
+	ret = pmbus_update_byte_data(client, page, PMBUS_OPERATION,
+				     PB_OPERATION_CONTROL_ON,
+				     enable ? PB_OPERATION_CONTROL_ON : 0);
+	mutex_unlock(&data->update_lock);
+
+	return ret;
 }
 
 static int pmbus_regulator_enable(struct regulator_dev *rdev)
diff --git a/drivers/hwmon/sch56xx-common.c b/drivers/hwmon/sch56xx-common.c
index bda3d5285586..e1c4e6937a64 100644
--- a/drivers/hwmon/sch56xx-common.c
+++ b/drivers/hwmon/sch56xx-common.c
@@ -437,7 +437,7 @@ struct sch56xx_watchdog_data *sch56xx_watchdog_register(struct device *parent,
 	if (nowayout)
 		set_bit(WDOG_NO_WAY_OUT, &data->wddev.status);
 	if (output_enable & SCH56XX_WDOG_OUTPUT_ENABLE)
-		set_bit(WDOG_ACTIVE, &data->wddev.status);
+		set_bit(WDOG_HW_RUNNING, &data->wddev.status);
 
 	/* Since the watchdog uses a downcounter there is no register to read
 	   the BIOS set timeout from (if any was set at all) ->
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index 2f021c1a2fa6..c51447344393 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -379,8 +379,12 @@ static ssize_t mode_store(struct device *dev,
 	mode = ETM_MODE_QELEM(config->mode);
 	/* start by clearing QE bits */
 	config->cfg &= ~(BIT(13) | BIT(14));
-	/* if supported, Q elements with instruction counts are enabled */
-	if ((mode & BIT(0)) && (drvdata->q_support & BIT(0)))
+	/*
+	 * if supported, Q elements with instruction counts are enabled.
+	 * Always set the low bit for any requested mode. Valid combos are
+	 * 0b00, 0b01 and 0b11.
+	 */
+	if (mode && drvdata->q_support)
 		config->cfg |= BIT(13);
 	/*
 	 * if supported, Q elements with and without instruction
diff --git a/drivers/i2c/busses/i2c-pasemi.c b/drivers/i2c/busses/i2c-pasemi.c
index df1dbc92a024..25c877654c32 100644
--- a/drivers/i2c/busses/i2c-pasemi.c
+++ b/drivers/i2c/busses/i2c-pasemi.c
@@ -145,6 +145,12 @@ static int pasemi_i2c_xfer_msg(struct i2c_adapter *adapter,
 
 		TXFIFO_WR(smbus, msg->buf[msg->len-1] |
 			  (stop ? MTXFIFO_STOP : 0));
+
+		if (stop) {
+			err = pasemi_smb_waitready(smbus);
+			if (err)
+				goto reset_out;
+		}
 	}
 
 	return 0;
diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 5a94f732049e..da526cc471cc 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -731,7 +731,6 @@ static const struct i2c_adapter_quirks xiic_quirks = {
 
 static const struct i2c_adapter xiic_adapter = {
 	.owner = THIS_MODULE,
-	.name = DRIVER_NAME,
 	.class = I2C_CLASS_DEPRECATED,
 	.algo = &xiic_algorithm,
 	.quirks = &xiic_quirks,
@@ -768,6 +767,8 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	i2c_set_adapdata(&i2c->adap, i2c);
 	i2c->adap.dev.parent = &pdev->dev;
 	i2c->adap.dev.of_node = pdev->dev.of_node;
+	snprintf(i2c->adap.name, sizeof(i2c->adap.name),
+		 DRIVER_NAME " %s", pdev->name);
 
 	mutex_init(&i2c->lock);
 	init_waitqueue_head(&i2c->wait);
diff --git a/drivers/i2c/muxes/i2c-demux-pinctrl.c b/drivers/i2c/muxes/i2c-demux-pinctrl.c
index 0c637ae81404..c638b2fc7fa2 100644
--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -259,7 +259,7 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 
 	err = device_create_file(&pdev->dev, &dev_attr_available_masters);
 	if (err)
-		goto err_rollback;
+		goto err_rollback_activation;
 
 	err = device_create_file(&pdev->dev, &dev_attr_current_master);
 	if (err)
@@ -269,8 +269,9 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 
 err_rollback_available:
 	device_remove_file(&pdev->dev, &dev_attr_available_masters);
-err_rollback:
+err_rollback_activation:
 	i2c_demux_deactivate_master(priv);
+err_rollback:
 	for (j = 0; j < i; j++) {
 		of_node_put(priv->chan[j].parent_np);
 		of_changeset_destroy(&priv->chan[j].chgset);
diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
index bc0e60b9da45..6a4ec58eb9c5 100644
--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -927,6 +927,8 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 	ret = devm_request_threaded_irq(dev, irq, NULL,
 				twl6030_gpadc_irq_handler,
 				IRQF_ONESHOT, "twl6030_gpadc", indio_dev);
+	if (ret)
+		return ret;
 
 	ret = twl6030_gpadc_enable_irq(TWL6030_GPADC_RT_SW1_EOC_MASK);
 	if (ret < 0) {
diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 069defcc6d9b..f12bad60a581 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -591,28 +591,50 @@ EXPORT_SYMBOL_GPL(iio_read_channel_average_raw);
 static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 	int raw, int *processed, unsigned int scale)
 {
-	int scale_type, scale_val, scale_val2, offset;
+	int scale_type, scale_val, scale_val2;
+	int offset_type, offset_val, offset_val2;
 	s64 raw64 = raw;
-	int ret;
 
-	ret = iio_channel_read(chan, &offset, NULL, IIO_CHAN_INFO_OFFSET);
-	if (ret >= 0)
-		raw64 += offset;
+	offset_type = iio_channel_read(chan, &offset_val, &offset_val2,
+				       IIO_CHAN_INFO_OFFSET);
+	if (offset_type >= 0) {
+		switch (offset_type) {
+		case IIO_VAL_INT:
+			break;
+		case IIO_VAL_INT_PLUS_MICRO:
+		case IIO_VAL_INT_PLUS_NANO:
+			/*
+			 * Both IIO_VAL_INT_PLUS_MICRO and IIO_VAL_INT_PLUS_NANO
+			 * implicitely truncate the offset to it's integer form.
+			 */
+			break;
+		case IIO_VAL_FRACTIONAL:
+			offset_val /= offset_val2;
+			break;
+		case IIO_VAL_FRACTIONAL_LOG2:
+			offset_val >>= offset_val2;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		raw64 += offset_val;
+	}
 
 	scale_type = iio_channel_read(chan, &scale_val, &scale_val2,
 					IIO_CHAN_INFO_SCALE);
 	if (scale_type < 0) {
 		/*
-		 * Just pass raw values as processed if no scaling is
-		 * available.
+		 * If no channel scaling is available apply consumer scale to
+		 * raw value and return.
 		 */
-		*processed = raw;
+		*processed = raw * scale;
 		return 0;
 	}
 
 	switch (scale_type) {
 	case IIO_VAL_INT:
-		*processed = raw64 * scale_val;
+		*processed = raw64 * scale_val * scale;
 		break;
 	case IIO_VAL_INT_PLUS_MICRO:
 		if (scale_val2 < 0)
diff --git a/drivers/input/input.c b/drivers/input/input.c
index cb8ff919ba82..cadb368be8ef 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2120,12 +2120,6 @@ int input_register_device(struct input_dev *dev)
 	/* KEY_RESERVED is not supposed to be transmitted to userspace. */
 	__clear_bit(KEY_RESERVED, dev->keybit);
 
-	/* Buttonpads should not map BTN_RIGHT and/or BTN_MIDDLE. */
-	if (test_bit(INPUT_PROP_BUTTONPAD, dev->propbit)) {
-		__clear_bit(BTN_RIGHT, dev->keybit);
-		__clear_bit(BTN_MIDDLE, dev->keybit);
-	}
-
 	/* Make sure that bitmasks not mentioned in dev->evbit are clean. */
 	input_cleanse_bitmasks(dev);
 
diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 29feafa8007f..878087b9ddfe 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -1210,6 +1210,7 @@ static irqreturn_t arm_smmu_evtq_thread(int irq, void *dev)
 				dev_info(smmu->dev, "\t0x%016llx\n",
 					 (unsigned long long)evt[i]);
 
+			cond_resched();
 		}
 
 		/*
diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
index 9694529b709d..330beb62d015 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -108,6 +108,7 @@ static int __init nvic_of_init(struct device_node *node,
 
 	if (!nvic_irq_domain) {
 		pr_warn("Failed to allocate irq domain\n");
+		iounmap(nvic_base);
 		return -ENOMEM;
 	}
 
@@ -117,6 +118,7 @@ static int __init nvic_of_init(struct device_node *node,
 	if (ret) {
 		pr_warn("Failed to allocate irq chips\n");
 		irq_domain_remove(nvic_irq_domain);
+		iounmap(nvic_base);
 		return ret;
 	}
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b8a9695af141..0b6d4337aaab 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2114,7 +2114,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 static int get_key_size(char **key_string)
 {
-	return (*key_string[0] == ':') ? -EINVAL : strlen(*key_string) >> 1;
+	return (*key_string[0] == ':') ? -EINVAL : (int)(strlen(*key_string) >> 1);
 }
 
 #endif
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2f020401d5ba..ddfea5324b58 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/dm-ioctl.h>
 #include <linux/hdreg.h>
 #include <linux/compat.h>
+#include <linux/nospec.h>
 
 #include <linux/uaccess.h>
 
@@ -1669,6 +1670,7 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
 		return NULL;
 
+	cmd = array_index_nospec(cmd, ARRAY_SIZE(_ioctls));
 	*ioctl_flags = _ioctls[cmd].flags;
 	return _ioctls[cmd].fn;
 }
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 52ff00ebd4bd..281eca525340 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -171,6 +171,9 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 	cx_write(MO_TS_GPCNTRL, GP_COUNT_CONTROL_RESET);
 	q->count = 0;
 
+	/* clear interrupt status register */
+	cx_write(MO_TS_INTSTAT,  0x1f1111);
+
 	/* enable irqs */
 	dprintk(1, "setting the interrupt mask\n");
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask | PCI_INT_TSINT);
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 5b87c488ee11..993208944ace 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -360,6 +360,7 @@ static struct vdoa_data *coda_get_vdoa_data(void)
 	if (!vdoa_data)
 		vdoa_data = ERR_PTR(-EPROBE_DEFER);
 
+	put_device(&vdoa_pdev->dev);
 out:
 	if (vdoa_node)
 		of_node_put(vdoa_node);
diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 07e89a4985a6..4ac0893282f5 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -495,6 +495,7 @@ static int vpif_probe(struct platform_device *pdev)
 
 static int vpif_remove(struct platform_device *pdev)
 {
+	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return 0;
 }
diff --git a/drivers/media/usb/go7007/s2250-board.c b/drivers/media/usb/go7007/s2250-board.c
index 1466db150d82..625e77f4dbd2 100644
--- a/drivers/media/usb/go7007/s2250-board.c
+++ b/drivers/media/usb/go7007/s2250-board.c
@@ -512,6 +512,7 @@ static int s2250_probe(struct i2c_client *client,
 	u8 *data;
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct go7007_usb *usb = go->hpi_context;
+	int err = -EIO;
 
 	audio = i2c_new_dummy(adapter, TLV320_ADDRESS >> 1);
 	if (audio == NULL)
@@ -540,11 +541,8 @@ static int s2250_probe(struct i2c_client *client,
 		V4L2_CID_HUE, -512, 511, 1, 0);
 	sd->ctrl_handler = &state->hdl;
 	if (state->hdl.error) {
-		int err = state->hdl.error;
-
-		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
-		return err;
+		err = state->hdl.error;
+		goto fail;
 	}
 
 	state->std = V4L2_STD_NTSC;
@@ -608,7 +606,7 @@ static int s2250_probe(struct i2c_client *client,
 	i2c_unregister_device(audio);
 	v4l2_ctrl_handler_free(&state->hdl);
 	kfree(state);
-	return -EIO;
+	return err;
 }
 
 static int s2250_remove(struct i2c_client *client)
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 991f820a4530..1cecb37e16d2 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -312,7 +312,6 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
 
 	dev->status = STATUS_STREAMING;
 
-	INIT_WORK(&dev->worker, hdpvr_transmit_buffers);
 	schedule_work(&dev->worker);
 
 	v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
@@ -1175,6 +1174,9 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 	bool ac3 = dev->flags & HDPVR_FLAG_AC3_CAP;
 	int res;
 
+	// initialize dev->worker
+	INIT_WORK(&dev->worker, hdpvr_transmit_buffers);
+
 	dev->cur_std = V4L2_STD_525_60;
 	dev->width = 720;
 	dev->height = 480;
diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index 8e434b31cb98..7f02c2739ec2 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -410,7 +410,7 @@ static void stk1160_disconnect(struct usb_interface *interface)
 	/* Here is the only place where isoc get released */
 	stk1160_uninit_isoc(dev);
 
-	stk1160_clear_queue(dev);
+	stk1160_clear_queue(dev, VB2_BUF_STATE_ERROR);
 
 	video_unregister_device(&dev->vdev);
 	v4l2_device_disconnect(&dev->v4l2_dev);
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 77b759a0bcd9..43676abc1694 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -269,7 +269,7 @@ static int stk1160_start_streaming(struct stk1160 *dev)
 	stk1160_uninit_isoc(dev);
 out_stop_hw:
 	usb_set_interface(dev->udev, 0, 0);
-	stk1160_clear_queue(dev);
+	stk1160_clear_queue(dev, VB2_BUF_STATE_QUEUED);
 
 	mutex_unlock(&dev->v4l_lock);
 
@@ -317,7 +317,7 @@ static int stk1160_stop_streaming(struct stk1160 *dev)
 
 	stk1160_stop_hw(dev);
 
-	stk1160_clear_queue(dev);
+	stk1160_clear_queue(dev, VB2_BUF_STATE_ERROR);
 
 	stk1160_dbg("streaming stopped\n");
 
@@ -762,7 +762,7 @@ static const struct video_device v4l_template = {
 /********************************************************************/
 
 /* Must be called with both v4l_lock and vb_queue_lock hold */
-void stk1160_clear_queue(struct stk1160 *dev)
+void stk1160_clear_queue(struct stk1160 *dev, enum vb2_buffer_state vb2_state)
 {
 	struct stk1160_buffer *buf;
 	unsigned long flags;
@@ -773,7 +773,7 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		buf = list_first_entry(&dev->avail_bufs,
 			struct stk1160_buffer, list);
 		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, vb2_state);
 		stk1160_dbg("buffer [%p/%d] aborted\n",
 			    buf, buf->vb.vb2_buf.index);
 	}
@@ -783,7 +783,7 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		buf = dev->isoc_ctl.buf;
 		dev->isoc_ctl.buf = NULL;
 
-		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+		vb2_buffer_done(&buf->vb.vb2_buf, vb2_state);
 		stk1160_dbg("buffer [%p/%d] aborted\n",
 			    buf, buf->vb.vb2_buf.index);
 	}
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index acd1c811db08..54a046aacd33 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -177,7 +177,7 @@ struct regval {
 int stk1160_vb2_setup(struct stk1160 *dev);
 int stk1160_video_register(struct stk1160 *dev);
 void stk1160_video_unregister(struct stk1160 *dev);
-void stk1160_clear_queue(struct stk1160 *dev);
+void stk1160_clear_queue(struct stk1160 *dev, enum vb2_buffer_state vb2_state);
 
 /* Provided by stk1160-video.c */
 int stk1160_alloc_isoc(struct stk1160 *dev);
diff --git a/drivers/memory/atmel-ebi.c b/drivers/memory/atmel-ebi.c
index 2b9283d4fcb1..8e7b5a1d2983 100644
--- a/drivers/memory/atmel-ebi.c
+++ b/drivers/memory/atmel-ebi.c
@@ -524,20 +524,27 @@ static int atmel_ebi_probe(struct platform_device *pdev)
 	smc_np = of_parse_phandle(dev->of_node, "atmel,smc", 0);
 
 	ebi->smc.regmap = syscon_node_to_regmap(smc_np);
-	if (IS_ERR(ebi->smc.regmap))
-		return PTR_ERR(ebi->smc.regmap);
+	if (IS_ERR(ebi->smc.regmap)) {
+		ret = PTR_ERR(ebi->smc.regmap);
+		goto put_node;
+	}
 
 	ebi->smc.layout = atmel_hsmc_get_reg_layout(smc_np);
-	if (IS_ERR(ebi->smc.layout))
-		return PTR_ERR(ebi->smc.layout);
+	if (IS_ERR(ebi->smc.layout)) {
+		ret = PTR_ERR(ebi->smc.layout);
+		goto put_node;
+	}
 
 	ebi->smc.clk = of_clk_get(smc_np, 0);
 	if (IS_ERR(ebi->smc.clk)) {
-		if (PTR_ERR(ebi->smc.clk) != -ENOENT)
-			return PTR_ERR(ebi->smc.clk);
+		if (PTR_ERR(ebi->smc.clk) != -ENOENT) {
+			ret = PTR_ERR(ebi->smc.clk);
+			goto put_node;
+		}
 
 		ebi->smc.clk = NULL;
 	}
+	of_node_put(smc_np);
 	ret = clk_prepare_enable(ebi->smc.clk);
 	if (ret)
 		return ret;
@@ -587,6 +594,10 @@ static int atmel_ebi_probe(struct platform_device *pdev)
 	}
 
 	return of_platform_populate(np, NULL, NULL, dev);
+
+put_node:
+	of_node_put(smc_np);
+	return ret;
 }
 
 static __maybe_unused int atmel_ebi_resume(struct device *dev)
diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 88c32b8dc88a..9f293b931144 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1425,7 +1425,7 @@ static struct emif_data *__init_or_module get_device_details(
 	temp	= devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
 	dev_info = devm_kzalloc(dev, sizeof(*dev_info), GFP_KERNEL);
 
-	if (!emif || !pd || !dev_info) {
+	if (!emif || !temp || !dev_info) {
 		dev_err(dev, "%s:%d: allocation error\n", __func__, __LINE__);
 		goto error;
 	}
@@ -1517,7 +1517,7 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 {
 	struct emif_data	*emif;
 	struct resource		*res;
-	int			irq;
+	int			irq, ret;
 
 	if (pdev->dev.of_node)
 		emif = of_get_memory_device_details(pdev->dev.of_node, &pdev->dev);
@@ -1551,7 +1551,9 @@ static int __init_or_module emif_probe(struct platform_device *pdev)
 	emif_onetime_settings(emif);
 	emif_debugfs_init(emif);
 	disable_and_clear_all_interrupts(emif);
-	setup_interrupts(emif, irq);
+	ret = setup_interrupts(emif, irq);
+	if (ret)
+		goto error;
 
 	/* One-time actions taken on probing the first device */
 	if (!emif1) {
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index cf2e25ab2940..21424c43ba72 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -915,14 +915,14 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 		ret = mfd_add_devices(&pdev->dev, pdev->id,
 			&asic3_cell_ds1wm, 1, mem, asic->irq_base, NULL);
 		if (ret < 0)
-			goto out;
+			goto out_unmap;
 	}
 
 	if (mem_sdio && (irq >= 0)) {
 		ret = mfd_add_devices(&pdev->dev, pdev->id,
 			&asic3_cell_mmc, 1, mem_sdio, irq, NULL);
 		if (ret < 0)
-			goto out;
+			goto out_unmap;
 	}
 
 	ret = 0;
@@ -936,8 +936,12 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 		ret = mfd_add_devices(&pdev->dev, 0,
 			asic3_cell_leds, ASIC3_NUM_LEDS, NULL, 0, NULL);
 	}
+	return ret;
 
- out:
+out_unmap:
+	if (asic->tmio_cnf)
+		iounmap(asic->tmio_cnf);
+out:
 	return ret;
 }
 
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 75d52034f89d..5b4faebdcae2 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -313,8 +313,10 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 		adc1 |= MC13783_ADC1_ATOX;
 
 	dev_dbg(mc13xxx->dev, "%s: request irq\n", __func__);
-	mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_ADCDONE,
+	ret = mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_ADCDONE,
 			mc13xxx_handler_adcdone, __func__, &adcdone_data);
+	if (ret)
+		goto out;
 
 	mc13xxx_reg_write(mc13xxx, MC13XXX_ADC0, adc0);
 	mc13xxx_reg_write(mc13xxx, MC13XXX_ADC1, adc1);
diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index aa70e22e247b..d14b4b0a1d7c 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -1068,10 +1068,10 @@ static int kgdbts_option_setup(char *opt)
 {
 	if (strlen(opt) >= MAX_CONFIG_LEN) {
 		printk(KERN_ERR "kgdbts: config string too long\n");
-		return -ENOSPC;
+		return 1;
 	}
 	strcpy(config, opt);
-	return 0;
+	return 1;
 }
 
 __setup("kgdbts=", kgdbts_option_setup);
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 3740fb0052a4..4da2bcfd0649 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -401,6 +401,16 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 
 EXPORT_SYMBOL(mmc_alloc_host);
 
+static int mmc_validate_host_caps(struct mmc_host *host)
+{
+	if (host->caps & MMC_CAP_SDIO_IRQ && !host->ops->enable_sdio_irq) {
+		dev_warn(host->parent, "missing ->enable_sdio_irq() ops\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  *	mmc_add_host - initialise host hardware
  *	@host: mmc host
@@ -413,8 +423,9 @@ int mmc_add_host(struct mmc_host *host)
 {
 	int err;
 
-	WARN_ON((host->caps & MMC_CAP_SDIO_IRQ) &&
-		!host->ops->enable_sdio_irq);
+	err = mmc_validate_host_caps(host);
+	if (err)
+		return err;
 
 	err = device_add(&host->class_dev);
 	if (err)
diff --git a/drivers/mmc/host/sdhci-xenon.c b/drivers/mmc/host/sdhci-xenon.c
index ca34fa424634..bd7d15936836 100644
--- a/drivers/mmc/host/sdhci-xenon.c
+++ b/drivers/mmc/host/sdhci-xenon.c
@@ -243,16 +243,6 @@ static void xenon_voltage_switch(struct sdhci_host *host)
 {
 	/* Wait for 5ms after set 1.8V signal enable bit */
 	usleep_range(5000, 5500);
-
-	/*
-	 * For some reason the controller's Host Control2 register reports
-	 * the bit representing 1.8V signaling as 0 when read after it was
-	 * written as 1. Subsequent read reports 1.
-	 *
-	 * Since this may cause some issues, do an empty read of the Host
-	 * Control2 register here to circumvent this.
-	 */
-	sdhci_readw(host, SDHCI_HOST_CONTROL2);
 }
 
 static const struct sdhci_ops sdhci_xenon_ops = {
diff --git a/drivers/mtd/nand/atmel/nand-controller.c b/drivers/mtd/nand/atmel/nand-controller.c
index d5a493e8ee08..475c751f2d1e 100644
--- a/drivers/mtd/nand/atmel/nand-controller.c
+++ b/drivers/mtd/nand/atmel/nand-controller.c
@@ -1998,13 +1998,15 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	nc->mck = of_clk_get(dev->parent->of_node, 0);
 	if (IS_ERR(nc->mck)) {
 		dev_err(dev, "Failed to retrieve MCK clk\n");
-		return PTR_ERR(nc->mck);
+		ret = PTR_ERR(nc->mck);
+		goto out_release_dma;
 	}
 
 	np = of_parse_phandle(dev->parent->of_node, "atmel,smc", 0);
 	if (!np) {
 		dev_err(dev, "Missing or invalid atmel,smc property\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_release_dma;
 	}
 
 	nc->smc = syscon_node_to_regmap(np);
@@ -2012,10 +2014,16 @@ static int atmel_nand_controller_init(struct atmel_nand_controller *nc,
 	if (IS_ERR(nc->smc)) {
 		ret = PTR_ERR(nc->smc);
 		dev_err(dev, "Could not get SMC regmap (err = %d)\n", ret);
-		return ret;
+		goto out_release_dma;
 	}
 
 	return 0;
+
+out_release_dma:
+	if (nc->dmac)
+		dma_release_channel(nc->dmac);
+
+	return ret;
 }
 
 static int
diff --git a/drivers/mtd/onenand/generic.c b/drivers/mtd/onenand/generic.c
index 125da34d8ff9..23a878e7974e 100644
--- a/drivers/mtd/onenand/generic.c
+++ b/drivers/mtd/onenand/generic.c
@@ -58,7 +58,12 @@ static int generic_onenand_probe(struct platform_device *pdev)
 	}
 
 	info->onenand.mmcontrol = pdata ? pdata->mmcontrol : NULL;
-	info->onenand.irq = platform_get_irq(pdev, 0);
+
+	err = platform_get_irq(pdev, 0);
+	if (err < 0)
+		goto out_iounmap;
+
+	info->onenand.irq = err;
 
 	info->mtd.dev.parent = &pdev->dev;
 	info->mtd.priv = &info->onenand;
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 0104d9537329..933c4de39dce 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -363,9 +363,6 @@ static ssize_t dev_attribute_show(struct device *dev,
 	 * we still can use 'ubi->ubi_num'.
 	 */
 	ubi = container_of(dev, struct ubi_device, dev);
-	ubi = ubi_get_device(ubi->ubi_num);
-	if (!ubi)
-		return -ENODEV;
 
 	if (attr == &dev_eraseblock_size)
 		ret = sprintf(buf, "%d\n", ubi->leb_size);
@@ -394,7 +391,6 @@ static ssize_t dev_attribute_show(struct device *dev,
 	else
 		ret = -EINVAL;
 
-	ubi_put_device(ubi);
 	return ret;
 }
 
@@ -960,9 +956,6 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 			goto out_detach;
 	}
 
-	/* Make device "available" before it becomes accessible via sysfs */
-	ubi_devices[ubi_num] = ubi;
-
 	err = uif_init(ubi);
 	if (err)
 		goto out_detach;
@@ -1007,6 +1000,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	wake_up_process(ubi->bgt_thread);
 	spin_unlock(&ubi->wl_lock);
 
+	ubi_devices[ubi_num] = ubi;
 	ubi_notify_all(ubi, UBI_VOLUME_ADDED, NULL);
 	return ubi_num;
 
@@ -1015,7 +1009,6 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 out_uif:
 	uif_close(ubi);
 out_detach:
-	ubi_devices[ubi_num] = NULL;
 	ubi_wl_close(ubi);
 	ubi_free_internal_volumes(ubi);
 	vfree(ubi->vtbl);
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 18aba1cf8acc..2882a575a74f 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -478,7 +478,9 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			if (err == UBI_IO_FF_BITFLIPS)
 				scrub = 1;
 
-			add_aeb(ai, free, pnum, ec, scrub);
+			ret = add_aeb(ai, free, pnum, ec, scrub);
+			if (ret)
+				goto out;
 			continue;
 		} else if (err == 0 || err == UBI_IO_BITFLIPS) {
 			dbg_bld("Found non empty PEB:%i in pool", pnum);
@@ -648,8 +650,10 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		if (fm_pos >= fm_size)
 			goto fail_bad;
 
-		add_aeb(ai, &ai->free, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 0);
+		ret = add_aeb(ai, &ai->free, be32_to_cpu(fmec->pnum),
+			      be32_to_cpu(fmec->ec), 0);
+		if (ret)
+			goto fail;
 	}
 
 	/* read EC values from used list */
@@ -659,8 +663,10 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		if (fm_pos >= fm_size)
 			goto fail_bad;
 
-		add_aeb(ai, &used, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 0);
+		ret = add_aeb(ai, &used, be32_to_cpu(fmec->pnum),
+			      be32_to_cpu(fmec->ec), 0);
+		if (ret)
+			goto fail;
 	}
 
 	/* read EC values from scrub list */
@@ -670,8 +676,10 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		if (fm_pos >= fm_size)
 			goto fail_bad;
 
-		add_aeb(ai, &used, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 1);
+		ret = add_aeb(ai, &used, be32_to_cpu(fmec->pnum),
+			      be32_to_cpu(fmec->ec), 1);
+		if (ret)
+			goto fail;
 	}
 
 	/* read EC values from erase list */
@@ -681,8 +689,10 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		if (fm_pos >= fm_size)
 			goto fail_bad;
 
-		add_aeb(ai, &ai->erase, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 1);
+		ret = add_aeb(ai, &ai->erase, be32_to_cpu(fmec->pnum),
+			      be32_to_cpu(fmec->ec), 1);
+		if (ret)
+			goto fail;
 	}
 
 	ai->mean_ec = div_u64(ai->ec_sum, ai->ec_count);
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 0be516780e92..8f641448a97a 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -69,16 +69,11 @@ static ssize_t vol_attribute_show(struct device *dev,
 {
 	int ret;
 	struct ubi_volume *vol = container_of(dev, struct ubi_volume, dev);
-	struct ubi_device *ubi;
-
-	ubi = ubi_get_device(vol->ubi->ubi_num);
-	if (!ubi)
-		return -ENODEV;
+	struct ubi_device *ubi = vol->ubi;
 
 	spin_lock(&ubi->volumes_lock);
 	if (!ubi->volumes[vol->vol_id]) {
 		spin_unlock(&ubi->volumes_lock);
-		ubi_put_device(ubi);
 		return -ENODEV;
 	}
 	/* Take a reference to prevent volume removal */
@@ -116,7 +111,6 @@ static ssize_t vol_attribute_show(struct device *dev,
 	vol->ref_count -= 1;
 	ubi_assert(vol->ref_count >= 0);
 	spin_unlock(&ubi->volumes_lock);
-	ubi_put_device(ubi);
 	return ret;
 }
 
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index d62d61d734ea..4d01b6cbf0eb 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -834,7 +834,6 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 
 		usb_unanchor_urb(urb);
 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
-		dev_kfree_skb(skb);
 
 		atomic_dec(&dev->active_tx_urbs);
 
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 9e43fbb4cc9d..f7c3fc3dabfe 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -44,10 +44,6 @@
 #define MCBA_USB_RX_BUFF_SIZE 64
 #define MCBA_USB_TX_BUFF_SIZE (sizeof(struct mcba_usb_msg))
 
-/* MCBA endpoint numbers */
-#define MCBA_USB_EP_IN 1
-#define MCBA_USB_EP_OUT 1
-
 /* Microchip command id */
 #define MBCA_CMD_RECEIVE_MESSAGE 0xE3
 #define MBCA_CMD_I_AM_ALIVE_FROM_CAN 0xF5
@@ -95,6 +91,8 @@ struct mcba_priv {
 	atomic_t free_ctx_cnt;
 	void *rxbuf[MCBA_MAX_RX_URBS];
 	dma_addr_t rxbuf_dma[MCBA_MAX_RX_URBS];
+	int rx_pipe;
+	int tx_pipe;
 };
 
 /* CAN frame */
@@ -283,10 +281,8 @@ static netdev_tx_t mcba_usb_xmit(struct mcba_priv *priv,
 
 	memcpy(buf, usb_msg, MCBA_USB_TX_BUFF_SIZE);
 
-	usb_fill_bulk_urb(urb, priv->udev,
-			  usb_sndbulkpipe(priv->udev, MCBA_USB_EP_OUT), buf,
-			  MCBA_USB_TX_BUFF_SIZE, mcba_usb_write_bulk_callback,
-			  ctx);
+	usb_fill_bulk_urb(urb, priv->udev, priv->tx_pipe, buf, MCBA_USB_TX_BUFF_SIZE,
+			  mcba_usb_write_bulk_callback, ctx);
 
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	usb_anchor_urb(urb, &priv->tx_submitted);
@@ -379,7 +375,6 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
 xmit_failed:
 	can_free_echo_skb(priv->netdev, ctx->ndx);
 	mcba_usb_free_ctx(ctx);
-	dev_kfree_skb(skb);
 	stats->tx_dropped++;
 
 	return NETDEV_TX_OK;
@@ -622,7 +617,7 @@ static void mcba_usb_read_bulk_callback(struct urb *urb)
 resubmit_urb:
 
 	usb_fill_bulk_urb(urb, priv->udev,
-			  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_OUT),
+			  priv->rx_pipe,
 			  urb->transfer_buffer, MCBA_USB_RX_BUFF_SIZE,
 			  mcba_usb_read_bulk_callback, priv);
 
@@ -667,7 +662,7 @@ static int mcba_usb_start(struct mcba_priv *priv)
 		urb->transfer_dma = buf_dma;
 
 		usb_fill_bulk_urb(urb, priv->udev,
-				  usb_rcvbulkpipe(priv->udev, MCBA_USB_EP_IN),
+				  priv->rx_pipe,
 				  buf, MCBA_USB_RX_BUFF_SIZE,
 				  mcba_usb_read_bulk_callback, priv);
 		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
@@ -821,6 +816,13 @@ static int mcba_usb_probe(struct usb_interface *intf,
 	struct mcba_priv *priv;
 	int err = -ENOMEM;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
+	struct usb_endpoint_descriptor *in, *out;
+
+	err = usb_find_common_endpoints(intf->cur_altsetting, &in, &out, NULL, NULL);
+	if (err) {
+		dev_err(&intf->dev, "Can't find endpoints\n");
+		return err;
+	}
 
 	netdev = alloc_candev(sizeof(struct mcba_priv), MCBA_MAX_TX_URBS);
 	if (!netdev) {
@@ -866,6 +868,9 @@ static int mcba_usb_probe(struct usb_interface *intf,
 		goto cleanup_free_candev;
 	}
 
+	priv->rx_pipe = usb_rcvbulkpipe(priv->udev, in->bEndpointAddress);
+	priv->tx_pipe = usb_sndbulkpipe(priv->udev, out->bEndpointAddress);
+
 	devm_can_led_init(netdev);
 
 	/* Start USB dev only if we have successfully registered CAN device */
diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index fc9197f14a3f..4b5355226f58 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -156,7 +156,7 @@ static void vxcan_setup(struct net_device *dev)
 	dev->hard_header_len	= 0;
 	dev->addr_len		= 0;
 	dev->tx_queue_len	= 0;
-	dev->flags		= (IFF_NOARP|IFF_ECHO);
+	dev->flags		= IFF_NOARP;
 	dev->netdev_ops		= &vxcan_netdev_ops;
 	dev->needs_free_netdev	= true;
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index e3123cb0fb70..82e16b2d1f7a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1272,9 +1272,7 @@ static int bnxt_set_pauseparam(struct net_device *dev,
 		}
 
 		link_info->autoneg |= BNXT_AUTONEG_FLOW_CTRL;
-		if (bp->hwrm_spec_code >= 0x10201)
-			link_info->req_flow_ctrl =
-				PORT_PHY_CFG_REQ_AUTO_PAUSE_AUTONEG_PAUSE;
+		link_info->req_flow_ctrl = 0;
 	} else {
 		/* when transition from auto pause to force pause,
 		 * force a link change
diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index c0dcfa05b077..3d10e6100748 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -548,6 +548,7 @@ static int mlxsw_i2c_probe(struct i2c_client *client,
 	return 0;
 
 errout:
+	mutex_destroy(&mlxsw_i2c->cmd.lock);
 	i2c_set_clientdata(client, NULL);
 
 	return err;
diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
index b7e2f49696b7..aa12bace8673 100644
--- a/drivers/net/ethernet/micrel/Kconfig
+++ b/drivers/net/ethernet/micrel/Kconfig
@@ -45,6 +45,7 @@ config KS8851
 config KS8851_MLL
 	tristate "Micrel KS8851 MLL"
 	depends on HAS_IOMEM
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select MII
 	---help---
 	  This platform driver is for Micrel KS8851 Address/data bus
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 5e7e977c62b6..3dbea6be4e55 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -2996,12 +2996,16 @@ static int qed_iov_pre_update_vport(struct qed_hwfn *hwfn,
 	u8 mask = QED_ACCEPT_UCAST_UNMATCHED | QED_ACCEPT_MCAST_UNMATCHED;
 	struct qed_filter_accept_flags *flags = &params->accept_flags;
 	struct qed_public_vf_info *vf_info;
+	u16 tlv_mask;
+
+	tlv_mask = BIT(QED_IOV_VP_UPDATE_ACCEPT_PARAM) |
+		   BIT(QED_IOV_VP_UPDATE_ACCEPT_ANY_VLAN);
 
 	/* Untrusted VFs can't even be trusted to know that fact.
 	 * Simply indicate everything is configured fine, and trace
 	 * configuration 'behind their back'.
 	 */
-	if (!(*tlvs & BIT(QED_IOV_VP_UPDATE_ACCEPT_PARAM)))
+	if (!(*tlvs & tlv_mask))
 		return 0;
 
 	vf_info = qed_iov_get_public_vf_info(hwfn, vfid, true);
@@ -3018,6 +3022,13 @@ static int qed_iov_pre_update_vport(struct qed_hwfn *hwfn,
 			flags->tx_accept_filter &= ~mask;
 	}
 
+	if (params->update_accept_any_vlan_flg) {
+		vf_info->accept_any_vlan = params->accept_any_vlan;
+
+		if (vf_info->forced_vlan && !vf_info->is_trusted_configured)
+			params->accept_any_vlan = false;
+	}
+
 	return 0;
 }
 
@@ -4587,6 +4598,7 @@ static int qed_get_vf_config(struct qed_dev *cdev,
 	tx_rate = vf_info->tx_rate;
 	ivi->max_tx_rate = tx_rate ? tx_rate : link.speed;
 	ivi->min_tx_rate = qed_iov_get_vf_min_rate(hwfn, vf_id);
+	ivi->trusted = vf_info->is_trusted_request;
 
 	return 0;
 }
@@ -4919,6 +4931,12 @@ static void qed_iov_handle_trust_change(struct qed_hwfn *hwfn)
 
 		params.update_ctl_frame_check = 1;
 		params.mac_chk_en = !vf_info->is_trusted_configured;
+		params.update_accept_any_vlan_flg = 0;
+
+		if (vf_info->accept_any_vlan && vf_info->forced_vlan) {
+			params.update_accept_any_vlan_flg = 1;
+			params.accept_any_vlan = vf_info->accept_any_vlan;
+		}
 
 		if (vf_info->rx_accept_mode & mask) {
 			flags->update_rx_mode_config = 1;
@@ -4934,13 +4952,20 @@ static void qed_iov_handle_trust_change(struct qed_hwfn *hwfn)
 		if (!vf_info->is_trusted_configured) {
 			flags->rx_accept_filter &= ~mask;
 			flags->tx_accept_filter &= ~mask;
+			params.accept_any_vlan = false;
 		}
 
 		if (flags->update_rx_mode_config ||
 		    flags->update_tx_mode_config ||
-		    params.update_ctl_frame_check)
+		    params.update_ctl_frame_check ||
+		    params.update_accept_any_vlan_flg) {
+			DP_VERBOSE(hwfn, QED_MSG_IOV,
+				   "vport update config for %s VF[abs 0x%x rel 0x%x]\n",
+				   vf_info->is_trusted_configured ? "trusted" : "untrusted",
+				   vf->abs_vf_id, vf->relative_vf_id);
 			qed_sp_vport_update(hwfn, &params,
 					    QED_SPQ_MODE_EBLOCK, NULL);
+		}
 	}
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.h b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
index 3955929ba892..a17ac595331f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
@@ -88,6 +88,7 @@ struct qed_public_vf_info {
 	bool is_trusted_request;
 	u8 rx_accept_mode;
 	u8 tx_accept_mode;
+	bool accept_any_vlan;
 };
 
 struct qed_iov_vf_init_params {
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
index f4aa6331b367..0a9d24e86715 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
@@ -52,7 +52,7 @@ static inline int qlcnic_dcb_get_hw_capability(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->get_hw_capability)
 		return dcb->ops->get_hw_capability(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_free(struct qlcnic_dcb *dcb)
@@ -66,7 +66,7 @@ static inline int qlcnic_dcb_attach(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->attach)
 		return dcb->ops->attach(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline int
@@ -75,7 +75,7 @@ qlcnic_dcb_query_hw_capability(struct qlcnic_dcb *dcb, char *buf)
 	if (dcb && dcb->ops->query_hw_capability)
 		return dcb->ops->query_hw_capability(dcb, buf);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_get_info(struct qlcnic_dcb *dcb)
@@ -90,7 +90,7 @@ qlcnic_dcb_query_cee_param(struct qlcnic_dcb *dcb, char *buf, u8 type)
 	if (dcb && dcb->ops->query_cee_param)
 		return dcb->ops->query_cee_param(dcb, buf, type);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline int qlcnic_dcb_get_cee_cfg(struct qlcnic_dcb *dcb)
@@ -98,7 +98,7 @@ static inline int qlcnic_dcb_get_cee_cfg(struct qlcnic_dcb *dcb)
 	if (dcb && dcb->ops->get_cee_cfg)
 		return dcb->ops->get_cee_cfg(dcb);
 
-	return 0;
+	return -EOPNOTSUPP;
 }
 
 static inline void qlcnic_dcb_aen_handler(struct qlcnic_dcb *dcb, void *msg)
diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
index 6a9c954492f2..6ca428a702f1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
@@ -68,10 +68,6 @@
 #define TSE_PCS_USE_SGMII_ENA				BIT(0)
 #define TSE_PCS_IF_USE_SGMII				0x03
 
-#define SGMII_ADAPTER_CTRL_REG				0x00
-#define SGMII_ADAPTER_DISABLE				0x0001
-#define SGMII_ADAPTER_ENABLE				0x0000
-
 #define AUTONEGO_LINK_TIMER				20
 
 static int tse_pcs_reset(void __iomem *base, struct tse_pcs *pcs)
@@ -215,12 +211,8 @@ void tse_pcs_fix_mac_speed(struct tse_pcs *pcs, struct phy_device *phy_dev,
 			   unsigned int speed)
 {
 	void __iomem *tse_pcs_base = pcs->tse_pcs_base;
-	void __iomem *sgmii_adapter_base = pcs->sgmii_adapter_base;
 	u32 val;
 
-	writew(SGMII_ADAPTER_ENABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-
 	pcs->autoneg = phy_dev->autoneg;
 
 	if (phy_dev->autoneg == AUTONEG_ENABLE) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
index 2f5882450b06..254199f2efdb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
@@ -21,6 +21,10 @@
 #include <linux/phy.h>
 #include <linux/timer.h>
 
+#define SGMII_ADAPTER_CTRL_REG		0x00
+#define SGMII_ADAPTER_ENABLE		0x0000
+#define SGMII_ADAPTER_DISABLE		0x0001
+
 struct tse_pcs {
 	struct device *dev;
 	void __iomem *tse_pcs_base;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 33407df6bea6..32ead4a4b460 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -29,9 +29,6 @@
 
 #include "altr_tse_pcs.h"
 
-#define SGMII_ADAPTER_CTRL_REG                          0x00
-#define SGMII_ADAPTER_DISABLE                           0x0001
-
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII 0x0
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII 0x1
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII 0x2
@@ -65,16 +62,14 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 {
 	struct socfpga_dwmac *dwmac = (struct socfpga_dwmac *)priv;
 	void __iomem *splitter_base = dwmac->splitter_base;
-	void __iomem *tse_pcs_base = dwmac->pcs.tse_pcs_base;
 	void __iomem *sgmii_adapter_base = dwmac->pcs.sgmii_adapter_base;
 	struct device *dev = dwmac->dev;
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct phy_device *phy_dev = ndev->phydev;
 	u32 val;
 
-	if ((tse_pcs_base) && (sgmii_adapter_base))
-		writew(SGMII_ADAPTER_DISABLE,
-		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	writew(SGMII_ADAPTER_DISABLE,
+	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
 
 	if (splitter_base) {
 		val = readl(splitter_base + EMAC_SPLITTER_CTRL_REG);
@@ -96,7 +91,9 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 		writel(val, splitter_base + EMAC_SPLITTER_CTRL_REG);
 	}
 
-	if (tse_pcs_base && sgmii_adapter_base)
+	writew(SGMII_ADAPTER_ENABLE,
+	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	if (phy_dev)
 		tse_pcs_fix_mac_speed(&dwmac->pcs, phy_dev, speed);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index d008e9d1518b..14d11f9fcbe8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -388,8 +388,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	plat->interface = of_get_phy_mode(np);
 
 	/* Get max speed of operation from device tree */
-	if (of_property_read_u32(np, "max-speed", &plat->max_speed))
-		plat->max_speed = -1;
+	of_property_read_u32(np, "max-speed", &plat->max_speed);
 
 	plat->bus_id = of_alias_get_id(np, "ethernet");
 	if (plat->bus_id < 0)
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 9e983e1d8249..7522f277e912 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -3165,7 +3165,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	if (err) {
 		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
 		       "aborting.\n");
-		goto err_out_iounmap;
+		goto err_out_free_coherent;
 	}
 
 	pci_set_drvdata(pdev, hp);
@@ -3198,6 +3198,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
+err_out_free_coherent:
+	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
+			  hp->happy_block, hp->hblock_dvma);
+
 err_out_iounmap:
 	iounmap(hp->gregs);
 
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 7e430300818e..3d5b2b4899ec 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -685,14 +685,14 @@ static void sixpack_close(struct tty_struct *tty)
 	 */
 	netif_stop_queue(sp->dev);
 
+	unregister_netdev(sp->dev);
+
 	del_timer_sync(&sp->tx_t);
 	del_timer_sync(&sp->resync_t);
 
 	/* Free all 6pack frame buffers. */
 	kfree(sp->rbuff);
 	kfree(sp->xbuff);
-
-	unregister_netdev(sp->dev);
 }
 
 /* Perform I/O control on an active 6pack channel. */
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index cba5cb3b849a..dc89019ca876 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -132,11 +132,17 @@ static void macvtap_setup(struct net_device *dev)
 	dev->tx_queue_len = TUN_READQ_SIZE;
 }
 
+static struct net *macvtap_link_net(const struct net_device *dev)
+{
+	return dev_net(macvlan_dev_real_dev(dev));
+}
+
 static struct rtnl_link_ops macvtap_link_ops __read_mostly = {
 	.kind		= "macvtap",
 	.setup		= macvtap_setup,
 	.newlink	= macvtap_newlink,
 	.dellink	= macvtap_dellink,
+	.get_link_net	= macvtap_link_net,
 	.priv_size      = sizeof(struct macvtap_dev),
 };
 
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 1e9ad30a35c8..97e017a54eb5 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -15,6 +15,7 @@
  */
 
 #include "bcm-phy-lib.h"
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/brcmphy.h>
@@ -444,6 +445,26 @@ static int brcm_fet_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
+	/* The datasheet indicates the PHY needs up to 1us to complete a reset,
+	 * build some slack here.
+	 */
+	usleep_range(1000, 2000);
+
+	/* The PHY requires 65 MDC clock cycles to complete a write operation
+	 * and turnaround the line properly.
+	 *
+	 * We ignore -EIO here as the MDIO controller (e.g.: mdio-bcm-unimac)
+	 * may flag the lack of turn-around as a read failure. This is
+	 * particularly true with this combination since the MDIO controller
+	 * only used 64 MDC cycles. This is not a critical failure in this
+	 * specific case and it has no functional impact otherwise, so we let
+	 * that one go through. If there is a genuine bus error, the next read
+	 * of MII_BRCM_FET_INTREG will error out.
+	 */
+	err = phy_read(phydev, MII_BMCR);
+	if (err < 0 && err != -EIO)
+		return err;
+
 	reg = phy_read(phydev, MII_BRCM_FET_INTREG);
 	if (reg < 0)
 		return reg;
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index d7882b548b79..dd95d6181afa 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -471,7 +471,7 @@ static void sl_tx_timeout(struct net_device *dev)
 	spin_lock(&sl->lock);
 
 	if (netif_queue_stopped(dev)) {
-		if (!netif_running(dev))
+		if (!netif_running(dev) || !sl->tty)
 			goto out;
 
 		/* May be we must check transmitter timeout here ?
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index a69ad39ee57e..f0b26768a639 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -106,7 +106,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	rcu_read_lock();
 	rcv = rcu_dereference(priv->peer);
-	if (unlikely(!rcv)) {
+	if (unlikely(!rcv) || !pskb_may_pull(skb, ETH_HLEN)) {
 		kfree_skb(skb);
 		goto drop;
 	}
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 94d34ee02265..01163b333945 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -746,6 +746,9 @@ ath5k_eeprom_convert_pcal_info_5111(struct ath5k_hw *ah, int mode,
 			}
 		}
 
+		if (idx == AR5K_EEPROM_N_PD_CURVES)
+			goto err_out;
+
 		ee->ee_pd_gains[mode] = 1;
 
 		pd = &chinfo[pier].pd_curves[idx];
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 05fca38b38ed..e37de14bc502 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -30,6 +30,7 @@ static int htc_issue_send(struct htc_target *target, struct sk_buff* skb,
 	hdr->endpoint_id = epid;
 	hdr->flags = flags;
 	hdr->payload_len = cpu_to_be16(len);
+	memset(hdr->control, 0, sizeof(hdr->control));
 
 	status = target->hif->send(target->hif_dev, endpoint->ul_pipeid, skb);
 
@@ -274,6 +275,10 @@ int htc_connect_service(struct htc_target *target,
 	conn_msg->dl_pipeid = endpoint->dl_pipeid;
 	conn_msg->ul_pipeid = endpoint->ul_pipeid;
 
+	/* To prevent infoleak */
+	conn_msg->svc_meta_len = 0;
+	conn_msg->pad = 0;
+
 	ret = htc_issue_send(target, skb, skb->len, 0, ENDPOINT0);
 	if (ret)
 		goto err;
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 80312b2fddb1..39f4bde6c2a0 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1922,7 +1922,7 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 		WARN_ON(!(tx_streams >= 1 && tx_streams <=
 			IEEE80211_HT_MCS_TX_MAX_STREAMS));
 
-		tx_params = (tx_streams - 1) <<
+		tx_params |= (tx_streams - 1) <<
 			    IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
 
 		carl9170_band_2GHz.ht_cap.mcs.tx_params |= tx_params;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 091b52979e03..13c25798f39a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -216,6 +216,8 @@ static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
 		size = BRCMF_FW_MAX_NVRAM_SIZE;
 	else
 		size = data_len;
+	/* Add space for properties we may add */
+	size += strlen(BRCMF_FW_DEFAULT_BOARDREV) + 1;
 	/* Alloc for extra 0 byte + roundup by 4 + length field */
 	size += 1 + 3 + sizeof(u32);
 	nvp->nvram = kzalloc(size, GFP_KERNEL);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index e6e9b00b79d7..fbaec4ea5988 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/bcma/bcma.h>
 #include <linux/sched.h>
+#include <linux/io.h>
 #include <asm/unaligned.h>
 
 #include <soc.h>
@@ -428,47 +429,6 @@ brcmf_pcie_write_ram32(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
 }
 
 
-static void
-brcmf_pcie_copy_mem_todev(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
-			  void *srcaddr, u32 len)
-{
-	void __iomem *address = devinfo->tcm + mem_offset;
-	__le32 *src32;
-	__le16 *src16;
-	u8 *src8;
-
-	if (((ulong)address & 4) || ((ulong)srcaddr & 4) || (len & 4)) {
-		if (((ulong)address & 2) || ((ulong)srcaddr & 2) || (len & 2)) {
-			src8 = (u8 *)srcaddr;
-			while (len) {
-				iowrite8(*src8, address);
-				address++;
-				src8++;
-				len--;
-			}
-		} else {
-			len = len / 2;
-			src16 = (__le16 *)srcaddr;
-			while (len) {
-				iowrite16(le16_to_cpu(*src16), address);
-				address += 2;
-				src16++;
-				len--;
-			}
-		}
-	} else {
-		len = len / 4;
-		src32 = (__le32 *)srcaddr;
-		while (len) {
-			iowrite32(le32_to_cpu(*src32), address);
-			address += 4;
-			src32++;
-			len--;
-		}
-	}
-}
-
-
 static void
 brcmf_pcie_copy_dev_tomem(struct brcmf_pciedev_info *devinfo, u32 mem_offset,
 			  void *dstaddr, u32 len)
@@ -1454,8 +1414,8 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 		return err;
 
 	brcmf_dbg(PCIE, "Download FW %s\n", devinfo->fw_name);
-	brcmf_pcie_copy_mem_todev(devinfo, devinfo->ci->rambase,
-				  (void *)fw->data, fw->size);
+	memcpy_toio(devinfo->tcm + devinfo->ci->rambase,
+		    (void *)fw->data, fw->size);
 
 	resetintr = get_unaligned_le32(fw->data);
 	release_firmware(fw);
@@ -1469,7 +1429,7 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 		brcmf_dbg(PCIE, "Download NVRAM %s\n", devinfo->nvram_name);
 		address = devinfo->ci->rambase + devinfo->ci->ramsize -
 			  nvram_len;
-		brcmf_pcie_copy_mem_todev(devinfo, address, nvram, nvram_len);
+		memcpy_toio(devinfo->tcm + address, nvram, nvram_len);
 		brcmf_fw_nvram_free(nvram);
 	} else {
 		brcmf_dbg(PCIE, "No matching NVRAM file found %s\n",
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 82caae02dd09..f2e0cfa2f4a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -317,7 +317,7 @@ static int iwlagn_mac_start(struct ieee80211_hw *hw)
 
 	priv->is_open = 1;
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return 0;
+	return ret;
 }
 
 static void iwlagn_mac_stop(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 170cd504e8ff..1ee150563260 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -395,6 +395,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->sram = ioremap(link->resource[2]->start,
 			resource_size(link->resource[2]));
+	if (!local->sram)
+		goto failed;
 
 /*** Set up 16k window for shared memory (receive buffer) ***************/
 	link->resource[3]->flags |=
@@ -409,6 +411,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->rmem = ioremap(link->resource[3]->start,
 			resource_size(link->resource[3]));
+	if (!local->rmem)
+		goto failed;
 
 /*** Set up window for attribute memory ***********************************/
 	link->resource[4]->flags |=
@@ -423,6 +427,8 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->amem = ioremap(link->resource[4]->start,
 			resource_size(link->resource[4]));
+	if (!local->amem)
+		goto failed;
 
 	dev_dbg(&link->dev, "ray_config sram=%p\n", local->sram);
 	dev_dbg(&link->dev, "ray_config rmem=%p\n", local->rmem);
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index c11515bdac83..4cc84c3b7602 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -144,9 +144,8 @@ struct dino_device
 {
 	struct pci_hba_data	hba;	/* 'C' inheritance - must be first */
 	spinlock_t		dinosaur_pen;
-	unsigned long		txn_addr; /* EIR addr to generate interrupt */ 
-	u32			txn_data; /* EIR data assign to each dino */ 
 	u32 			imr;	  /* IRQ's which are enabled */ 
+	struct gsc_irq		gsc_irq;
 	int			global_irq[DINO_LOCAL_IRQS]; /* map IMR bit to global irq */
 #ifdef DINO_DEBUG
 	unsigned int		dino_irr0; /* save most recent IRQ line stat */
@@ -343,14 +342,43 @@ static void dino_unmask_irq(struct irq_data *d)
 	if (tmp & DINO_MASK_IRQ(local_irq)) {
 		DBG(KERN_WARNING "%s(): IRQ asserted! (ILR 0x%x)\n",
 				__func__, tmp);
-		gsc_writel(dino_dev->txn_data, dino_dev->txn_addr);
+		gsc_writel(dino_dev->gsc_irq.txn_data, dino_dev->gsc_irq.txn_addr);
 	}
 }
 
+#ifdef CONFIG_SMP
+static int dino_set_affinity_irq(struct irq_data *d, const struct cpumask *dest,
+				bool force)
+{
+	struct dino_device *dino_dev = irq_data_get_irq_chip_data(d);
+	struct cpumask tmask;
+	int cpu_irq;
+	u32 eim;
+
+	if (!cpumask_and(&tmask, dest, cpu_online_mask))
+		return -EINVAL;
+
+	cpu_irq = cpu_check_affinity(d, &tmask);
+	if (cpu_irq < 0)
+		return cpu_irq;
+
+	dino_dev->gsc_irq.txn_addr = txn_affinity_addr(d->irq, cpu_irq);
+	eim = ((u32) dino_dev->gsc_irq.txn_addr) | dino_dev->gsc_irq.txn_data;
+	__raw_writel(eim, dino_dev->hba.base_addr+DINO_IAR0);
+
+	irq_data_update_effective_affinity(d, &tmask);
+
+	return IRQ_SET_MASK_OK;
+}
+#endif
+
 static struct irq_chip dino_interrupt_type = {
 	.name		= "GSC-PCI",
 	.irq_unmask	= dino_unmask_irq,
 	.irq_mask	= dino_mask_irq,
+#ifdef CONFIG_SMP
+	.irq_set_affinity = dino_set_affinity_irq,
+#endif
 };
 
 
@@ -811,7 +839,6 @@ static int __init dino_common_init(struct parisc_device *dev,
 {
 	int status;
 	u32 eim;
-	struct gsc_irq gsc_irq;
 	struct resource *res;
 
 	pcibios_register_hba(&dino_dev->hba);
@@ -826,10 +853,8 @@ static int __init dino_common_init(struct parisc_device *dev,
 	**   still only has 11 IRQ input lines - just map some of them
 	**   to a different processor.
 	*/
-	dev->irq = gsc_alloc_irq(&gsc_irq);
-	dino_dev->txn_addr = gsc_irq.txn_addr;
-	dino_dev->txn_data = gsc_irq.txn_data;
-	eim = ((u32) gsc_irq.txn_addr) | gsc_irq.txn_data;
+	dev->irq = gsc_alloc_irq(&dino_dev->gsc_irq);
+	eim = ((u32) dino_dev->gsc_irq.txn_addr) | dino_dev->gsc_irq.txn_data;
 
 	/* 
 	** Dino needs a PA "IRQ" to get a processor's attention.
diff --git a/drivers/parisc/gsc.c b/drivers/parisc/gsc.c
index 1bab5a2cd359..a0cae6194591 100644
--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -139,10 +139,41 @@ static void gsc_asic_unmask_irq(struct irq_data *d)
 	 */
 }
 
+#ifdef CONFIG_SMP
+static int gsc_set_affinity_irq(struct irq_data *d, const struct cpumask *dest,
+				bool force)
+{
+	struct gsc_asic *gsc_dev = irq_data_get_irq_chip_data(d);
+	struct cpumask tmask;
+	int cpu_irq;
+
+	if (!cpumask_and(&tmask, dest, cpu_online_mask))
+		return -EINVAL;
+
+	cpu_irq = cpu_check_affinity(d, &tmask);
+	if (cpu_irq < 0)
+		return cpu_irq;
+
+	gsc_dev->gsc_irq.txn_addr = txn_affinity_addr(d->irq, cpu_irq);
+	gsc_dev->eim = ((u32) gsc_dev->gsc_irq.txn_addr) | gsc_dev->gsc_irq.txn_data;
+
+	/* switch IRQ's for devices below LASI/WAX to other CPU */
+	gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
+
+	irq_data_update_effective_affinity(d, &tmask);
+
+	return IRQ_SET_MASK_OK;
+}
+#endif
+
+
 static struct irq_chip gsc_asic_interrupt_type = {
 	.name		=	"GSC-ASIC",
 	.irq_unmask	=	gsc_asic_unmask_irq,
 	.irq_mask	=	gsc_asic_mask_irq,
+#ifdef CONFIG_SMP
+	.irq_set_affinity =	gsc_set_affinity_irq,
+#endif
 };
 
 int gsc_assign_irq(struct irq_chip *type, void *data)
diff --git a/drivers/parisc/gsc.h b/drivers/parisc/gsc.h
index b9d7bfb68e24..9a364a4d09a5 100644
--- a/drivers/parisc/gsc.h
+++ b/drivers/parisc/gsc.h
@@ -32,6 +32,7 @@ struct gsc_asic {
 	int version;
 	int type;
 	int eim;
+	struct gsc_irq gsc_irq;
 	int global_irq[32];
 };
 
diff --git a/drivers/parisc/lasi.c b/drivers/parisc/lasi.c
index 4c9225431500..07ac0b8ee4fe 100644
--- a/drivers/parisc/lasi.c
+++ b/drivers/parisc/lasi.c
@@ -167,7 +167,6 @@ static int __init lasi_init_chip(struct parisc_device *dev)
 {
 	extern void (*chassis_power_off)(void);
 	struct gsc_asic *lasi;
-	struct gsc_irq gsc_irq;
 	int ret;
 
 	lasi = kzalloc(sizeof(*lasi), GFP_KERNEL);
@@ -189,7 +188,7 @@ static int __init lasi_init_chip(struct parisc_device *dev)
 	lasi_init_irq(lasi);
 
 	/* the IRQ lasi should use */
-	dev->irq = gsc_alloc_irq(&gsc_irq);
+	dev->irq = gsc_alloc_irq(&lasi->gsc_irq);
 	if (dev->irq < 0) {
 		printk(KERN_ERR "%s(): cannot get GSC irq\n",
 				__func__);
@@ -197,9 +196,9 @@ static int __init lasi_init_chip(struct parisc_device *dev)
 		return -EBUSY;
 	}
 
-	lasi->eim = ((u32) gsc_irq.txn_addr) | gsc_irq.txn_data;
+	lasi->eim = ((u32) lasi->gsc_irq.txn_addr) | lasi->gsc_irq.txn_data;
 
-	ret = request_irq(gsc_irq.irq, gsc_asic_intr, 0, "lasi", lasi);
+	ret = request_irq(lasi->gsc_irq.irq, gsc_asic_intr, 0, "lasi", lasi);
 	if (ret < 0) {
 		kfree(lasi);
 		return ret;
diff --git a/drivers/parisc/wax.c b/drivers/parisc/wax.c
index 6a3e40702b3b..5c42bfa83398 100644
--- a/drivers/parisc/wax.c
+++ b/drivers/parisc/wax.c
@@ -72,7 +72,6 @@ static int __init wax_init_chip(struct parisc_device *dev)
 {
 	struct gsc_asic *wax;
 	struct parisc_device *parent;
-	struct gsc_irq gsc_irq;
 	int ret;
 
 	wax = kzalloc(sizeof(*wax), GFP_KERNEL);
@@ -89,7 +88,7 @@ static int __init wax_init_chip(struct parisc_device *dev)
 	wax_init_irq(wax);
 
 	/* the IRQ wax should use */
-	dev->irq = gsc_claim_irq(&gsc_irq, WAX_GSC_IRQ);
+	dev->irq = gsc_claim_irq(&wax->gsc_irq, WAX_GSC_IRQ);
 	if (dev->irq < 0) {
 		printk(KERN_ERR "%s(): cannot get GSC irq\n",
 				__func__);
@@ -97,9 +96,9 @@ static int __init wax_init_chip(struct parisc_device *dev)
 		return -EBUSY;
 	}
 
-	wax->eim = ((u32) gsc_irq.txn_addr) | gsc_irq.txn_data;
+	wax->eim = ((u32) wax->gsc_irq.txn_addr) | wax->gsc_irq.txn_data;
 
-	ret = request_irq(gsc_irq.irq, gsc_asic_intr, 0, "wax", wax);
+	ret = request_irq(wax->gsc_irq.irq, gsc_asic_intr, 0, "wax", wax);
 	if (ret < 0) {
 		kfree(wax);
 		return ret;
diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 8c585e7ca520..9ae710a63d38 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -161,9 +161,12 @@ int pci_generic_config_write32(struct pci_bus *bus, unsigned int devfn,
 	 * write happen to have any RW1C (write-one-to-clear) bits set, we
 	 * just inadvertently cleared something we shouldn't have.
 	 */
-	dev_warn_ratelimited(&bus->dev, "%d-byte config write to %04x:%02x:%02x.%d offset %#x may corrupt adjacent RW1C bits\n",
-			     size, pci_domain_nr(bus), bus->number,
-			     PCI_SLOT(devfn), PCI_FUNC(devfn), where);
+	if (!bus->unsafe_warn) {
+		dev_warn(&bus->dev, "%d-byte config write to %04x:%02x:%02x.%d offset %#x may corrupt adjacent RW1C bits\n",
+			 size, pci_domain_nr(bus), bus->number,
+			 PCI_SLOT(devfn), PCI_FUNC(devfn), where);
+		bus->unsafe_warn = 1;
+	}
 
 	mask = ~(((1 << (size * 8)) - 1) << ((where & 0x3) * 8));
 	tmp = readl(addr) & mask;
diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index 9ae544e113dc..124fd7cb5da5 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -834,7 +834,7 @@ static void advk_msi_irq_compose_msi_msg(struct irq_data *data,
 
 	msg->address_lo = lower_32_bits(msi_msg);
 	msg->address_hi = upper_32_bits(msi_msg);
-	msg->data = data->irq;
+	msg->data = data->hwirq;
 }
 
 static int advk_msi_set_affinity(struct irq_data *irq_data,
@@ -851,15 +851,11 @@ static int advk_msi_irq_domain_alloc(struct irq_domain *domain,
 	int hwirq, i;
 
 	mutex_lock(&pcie->msi_used_lock);
-	hwirq = bitmap_find_next_zero_area(pcie->msi_used, MSI_IRQ_NUM,
-					   0, nr_irqs, 0);
-	if (hwirq >= MSI_IRQ_NUM) {
-		mutex_unlock(&pcie->msi_used_lock);
-		return -ENOSPC;
-	}
-
-	bitmap_set(pcie->msi_used, hwirq, nr_irqs);
+	hwirq = bitmap_find_free_region(pcie->msi_used, MSI_IRQ_NUM,
+					order_base_2(nr_irqs));
 	mutex_unlock(&pcie->msi_used_lock);
+	if (hwirq < 0)
+		return -ENOSPC;
 
 	for (i = 0; i < nr_irqs; i++)
 		irq_domain_set_info(domain, virq + i, hwirq + i,
@@ -877,7 +873,7 @@ static void advk_msi_irq_domain_free(struct irq_domain *domain,
 	struct advk_pcie *pcie = domain->host_data;
 
 	mutex_lock(&pcie->msi_used_lock);
-	bitmap_clear(pcie->msi_used, d->hwirq, nr_irqs);
+	bitmap_release_region(pcie->msi_used, d->hwirq, order_base_2(nr_irqs));
 	mutex_unlock(&pcie->msi_used_lock);
 }
 
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 2fa830727362..c2dd297d4007 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -120,6 +120,8 @@ static int pcie_poll_cmd(struct controller *ctrl, int timeout)
 		if (slot_status & PCI_EXP_SLTSTA_CC) {
 			pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
 						   PCI_EXP_SLTSTA_CC);
+			ctrl->cmd_busy = 0;
+			smp_mb();
 			return 1;
 		}
 		if (timeout < 0)
diff --git a/drivers/perf/qcom_l2_pmu.c b/drivers/perf/qcom_l2_pmu.c
index b242cce10468..ab313c0adb2b 100644
--- a/drivers/perf/qcom_l2_pmu.c
+++ b/drivers/perf/qcom_l2_pmu.c
@@ -744,7 +744,7 @@ static struct cluster_pmu *l2_cache_associate_cpu_with_cluster(
 {
 	u64 mpidr;
 	int cpu_cluster_id;
-	struct cluster_pmu *cluster = NULL;
+	struct cluster_pmu *cluster;
 
 	/*
 	 * This assumes that the cluster_id is in MPIDR[aff1] for
@@ -766,10 +766,10 @@ static struct cluster_pmu *l2_cache_associate_cpu_with_cluster(
 			 cluster->cluster_id);
 		cpumask_set_cpu(cpu, &cluster->cluster_cpus);
 		*per_cpu_ptr(l2cache_pmu->pmu_cluster, cpu) = cluster;
-		break;
+		return cluster;
 	}
 
-	return cluster;
+	return NULL;
 }
 
 static int l2cache_pmu_online_cpu(unsigned int cpu, struct hlist_node *node)
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
index 3cf384f8b122..8b07439bb694 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1367,6 +1367,7 @@ int mtk_pctrl_init(struct platform_device *pdev,
 	node = of_parse_phandle(np, "mediatek,pctl-regmap", 0);
 	if (node) {
 		pctl->regmap1 = syscon_node_to_regmap(node);
+		of_node_put(node);
 		if (IS_ERR(pctl->regmap1))
 			return PTR_ERR(pctl->regmap1);
 	} else if (regmap) {
@@ -1380,6 +1381,7 @@ int mtk_pctrl_init(struct platform_device *pdev,
 	node = of_parse_phandle(np, "mediatek,pctl-regmap", 1);
 	if (node) {
 		pctl->regmap2 = syscon_node_to_regmap(node);
+		of_node_put(node);
 		if (IS_ERR(pctl->regmap2))
 			return PTR_ERR(pctl->regmap2);
 	}
diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
index a53f1a9b1ed2..69c702b366bc 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -1916,8 +1916,10 @@ static int nmk_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	prcm_np = of_parse_phandle(np, "prcm", 0);
-	if (prcm_np)
+	if (prcm_np) {
 		npct->prcm_base = of_iomap(prcm_np, 0);
+		of_node_put(prcm_np);
+	}
 	if (!npct->prcm_base) {
 		if (version == PINCTRL_NMK_STN8815) {
 			dev_info(&pdev->dev,
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 8eaa25c3384f..6f6fd5e6b68c 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -31,10 +31,10 @@ static const struct pin_config_item conf_items[] = {
 	PCONFDUMP(PIN_CONFIG_BIAS_BUS_HOLD, "input bias bus hold", NULL, false),
 	PCONFDUMP(PIN_CONFIG_BIAS_DISABLE, "input bias disabled", NULL, false),
 	PCONFDUMP(PIN_CONFIG_BIAS_HIGH_IMPEDANCE, "input bias high impedance", NULL, false),
-	PCONFDUMP(PIN_CONFIG_BIAS_PULL_DOWN, "input bias pull down", NULL, false),
+	PCONFDUMP(PIN_CONFIG_BIAS_PULL_DOWN, "input bias pull down", "ohms", true),
 	PCONFDUMP(PIN_CONFIG_BIAS_PULL_PIN_DEFAULT,
-				"input bias pull to pin specific state", NULL, false),
-	PCONFDUMP(PIN_CONFIG_BIAS_PULL_UP, "input bias pull up", NULL, false),
+				"input bias pull to pin specific state", "ohms", true),
+	PCONFDUMP(PIN_CONFIG_BIAS_PULL_UP, "input bias pull up", "ohms", true),
 	PCONFDUMP(PIN_CONFIG_DRIVE_OPEN_DRAIN, "output drive open drain", NULL, false),
 	PCONFDUMP(PIN_CONFIG_DRIVE_OPEN_SOURCE, "output drive open source", NULL, false),
 	PCONFDUMP(PIN_CONFIG_DRIVE_PUSH_PULL, "output drive push pull", NULL, false),
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index d6b344163448..0c237dd13f2f 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -3168,6 +3168,7 @@ static int rockchip_pinctrl_probe(struct platform_device *pdev)
 	node = of_parse_phandle(np, "rockchip,grf", 0);
 	if (node) {
 		info->regmap_base = syscon_node_to_regmap(node);
+		of_node_put(node);
 		if (IS_ERR(info->regmap_base))
 			return PTR_ERR(info->regmap_base);
 	} else {
@@ -3204,6 +3205,7 @@ static int rockchip_pinctrl_probe(struct platform_device *pdev)
 	node = of_parse_phandle(np, "rockchip,pmu", 0);
 	if (node) {
 		info->regmap_pmu = syscon_node_to_regmap(node);
+		of_node_put(node);
 		if (IS_ERR(info->regmap_pmu))
 			return PTR_ERR(info->regmap_pmu);
 	}
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index ab04d4c4941d..eecc024a96a5 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -975,6 +975,16 @@ samsung_pinctrl_get_soc_data_for_of_alias(struct platform_device *pdev)
 	return &(of_data->ctrl[id]);
 }
 
+static void samsung_banks_of_node_put(struct samsung_pinctrl_drv_data *d)
+{
+	struct samsung_pin_bank *bank;
+	unsigned int i;
+
+	bank = d->pin_banks;
+	for (i = 0; i < d->nr_banks; ++i, ++bank)
+		of_node_put(bank->of_node);
+}
+
 /* retrieve the soc specific data */
 static const struct samsung_pin_ctrl *
 samsung_pinctrl_get_soc_data(struct samsung_pinctrl_drv_data *d,
@@ -1089,19 +1099,19 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 	if (ctrl->retention_data) {
 		drvdata->retention_ctrl = ctrl->retention_data->init(drvdata,
 							  ctrl->retention_data);
-		if (IS_ERR(drvdata->retention_ctrl))
-			return PTR_ERR(drvdata->retention_ctrl);
+		if (IS_ERR(drvdata->retention_ctrl)) {
+			ret = PTR_ERR(drvdata->retention_ctrl);
+			goto err_put_banks;
+		}
 	}
 
 	ret = samsung_pinctrl_register(pdev, drvdata);
 	if (ret)
-		return ret;
+		goto err_put_banks;
 
 	ret = samsung_gpiolib_register(pdev, drvdata);
-	if (ret) {
-		samsung_pinctrl_unregister(pdev, drvdata);
-		return ret;
-	}
+	if (ret)
+		goto err_unregister;
 
 	if (ctrl->eint_gpio_init)
 		ctrl->eint_gpio_init(drvdata);
@@ -1111,6 +1121,12 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, drvdata);
 
 	return 0;
+
+err_unregister:
+	samsung_pinctrl_unregister(pdev, drvdata);
+err_put_banks:
+	samsung_banks_of_node_put(drvdata);
+	return ret;
 }
 
 /**
diff --git a/drivers/power/reset/gemini-poweroff.c b/drivers/power/reset/gemini-poweroff.c
index ff75af5abbc5..95d48edf0605 100644
--- a/drivers/power/reset/gemini-poweroff.c
+++ b/drivers/power/reset/gemini-poweroff.c
@@ -103,8 +103,8 @@ static int gemini_poweroff_probe(struct platform_device *pdev)
 		return PTR_ERR(gpw->base);
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq)
-		return -EINVAL;
+	if (irq < 0)
+		return irq;
 
 	gpw->dev = dev;
 
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 2677592ed7af..b00844103a07 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -2545,8 +2545,10 @@ static int ab8500_fg_sysfs_init(struct ab8500_fg *di)
 	ret = kobject_init_and_add(&di->fg_kobject,
 		&ab8500_fg_ktype,
 		NULL, "battery");
-	if (ret < 0)
+	if (ret < 0) {
+		kobject_put(&di->fg_kobject);
 		dev_err(di->dev, "failed to create sysfs entry\n");
+	}
 
 	return ret;
 }
diff --git a/drivers/power/supply/axp20x_battery.c b/drivers/power/supply/axp20x_battery.c
index 7494f0f0eadb..a2e2443357fa 100644
--- a/drivers/power/supply/axp20x_battery.c
+++ b/drivers/power/supply/axp20x_battery.c
@@ -160,7 +160,6 @@ static int axp20x_battery_get_prop(struct power_supply *psy,
 				   union power_supply_propval *val)
 {
 	struct axp20x_batt_ps *axp20x_batt = power_supply_get_drvdata(psy);
-	struct iio_channel *chan;
 	int ret = 0, reg, val1;
 
 	switch (psp) {
@@ -240,12 +239,12 @@ static int axp20x_battery_get_prop(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		if (reg & AXP20X_PWR_STATUS_BAT_CHARGING)
-			chan = axp20x_batt->batt_chrg_i;
-		else
-			chan = axp20x_batt->batt_dischrg_i;
-
-		ret = iio_read_channel_processed(chan, &val->intval);
+		if (reg & AXP20X_PWR_STATUS_BAT_CHARGING) {
+			ret = iio_read_channel_processed(axp20x_batt->batt_chrg_i, &val->intval);
+		} else {
+			ret = iio_read_channel_processed(axp20x_batt->batt_dischrg_i, &val1);
+			val->intval = -val1;
+		}
 		if (ret)
 			return ret;
 
diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 0906f6b562bc..32bd28f68983 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -44,6 +44,7 @@
 #define BQ24190_REG_POC_CHG_CONFIG_DISABLE		0x0
 #define BQ24190_REG_POC_CHG_CONFIG_CHARGE		0x1
 #define BQ24190_REG_POC_CHG_CONFIG_OTG			0x2
+#define BQ24190_REG_POC_CHG_CONFIG_OTG_ALT		0x3
 #define BQ24190_REG_POC_SYS_MIN_MASK		(BIT(3) | BIT(2) | BIT(1))
 #define BQ24190_REG_POC_SYS_MIN_SHIFT		1
 #define BQ24190_REG_POC_SYS_MIN_MIN			3000
@@ -572,7 +573,11 @@ static int bq24190_vbus_is_enabled(struct regulator_dev *dev)
 	pm_runtime_mark_last_busy(bdi->dev);
 	pm_runtime_put_autosuspend(bdi->dev);
 
-	return ret ? ret : val == BQ24190_REG_POC_CHG_CONFIG_OTG;
+	if (ret)
+		return ret;
+
+	return (val == BQ24190_REG_POC_CHG_CONFIG_OTG ||
+		val == BQ24190_REG_POC_CHG_CONFIG_OTG_ALT);
 }
 
 static const struct regulator_ops bq24190_vbus_ops = {
diff --git a/drivers/power/supply/wm8350_power.c b/drivers/power/supply/wm8350_power.c
index a2740cf57ad3..5d025fcd8f3f 100644
--- a/drivers/power/supply/wm8350_power.c
+++ b/drivers/power/supply/wm8350_power.c
@@ -410,44 +410,112 @@ static const struct power_supply_desc wm8350_usb_desc = {
  *		Initialisation
  *********************************************************************/
 
-static void wm8350_init_charger(struct wm8350 *wm8350)
+static int wm8350_init_charger(struct wm8350 *wm8350)
 {
+	int ret;
+
 	/* register our interest in charger events */
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT,
 			    wm8350_charger_handler, 0, "Battery hot", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD,
+	if (ret)
+		goto err;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD,
 			    wm8350_charger_handler, 0, "Battery cold", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL,
+	if (ret)
+		goto free_chg_bat_hot;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL,
 			    wm8350_charger_handler, 0, "Battery fail", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_TO,
+	if (ret)
+		goto free_chg_bat_cold;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_TO,
 			    wm8350_charger_handler, 0,
 			    "Charger timeout", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_END,
+	if (ret)
+		goto free_chg_bat_fail;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_END,
 			    wm8350_charger_handler, 0,
 			    "Charge end", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_START,
+	if (ret)
+		goto free_chg_to;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_START,
 			    wm8350_charger_handler, 0,
 			    "Charge start", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY,
+	if (ret)
+		goto free_chg_end;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY,
 			    wm8350_charger_handler, 0,
 			    "Fast charge ready", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9,
+	if (ret)
+		goto free_chg_start;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9,
 			    wm8350_charger_handler, 0,
 			    "Battery <3.9V", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1,
+	if (ret)
+		goto free_chg_fast_rdy;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1,
 			    wm8350_charger_handler, 0,
 			    "Battery <3.1V", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85,
+	if (ret)
+		goto free_chg_vbatt_lt_3p9;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85,
 			    wm8350_charger_handler, 0,
 			    "Battery <2.85V", wm8350);
+	if (ret)
+		goto free_chg_vbatt_lt_3p1;
 
 	/* and supply change events */
-	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_USB_FB,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_EXT_USB_FB,
 			    wm8350_charger_handler, 0, "USB", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_WALL_FB,
+	if (ret)
+		goto free_chg_vbatt_lt_2p85;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_EXT_WALL_FB,
 			    wm8350_charger_handler, 0, "Wall", wm8350);
-	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_BAT_FB,
+	if (ret)
+		goto free_ext_usb_fb;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_EXT_BAT_FB,
 			    wm8350_charger_handler, 0, "Battery", wm8350);
+	if (ret)
+		goto free_ext_wall_fb;
+
+	return 0;
+
+free_ext_wall_fb:
+	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_WALL_FB, wm8350);
+free_ext_usb_fb:
+	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_USB_FB, wm8350);
+free_chg_vbatt_lt_2p85:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85, wm8350);
+free_chg_vbatt_lt_3p1:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1, wm8350);
+free_chg_vbatt_lt_3p9:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9, wm8350);
+free_chg_fast_rdy:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY, wm8350);
+free_chg_start:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_START, wm8350);
+free_chg_end:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_END, wm8350);
+free_chg_to:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_TO, wm8350);
+free_chg_bat_fail:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL, wm8350);
+free_chg_bat_cold:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD, wm8350);
+free_chg_bat_hot:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT, wm8350);
+err:
+	return ret;
 }
 
 static void free_charger_irq(struct wm8350 *wm8350)
@@ -458,6 +526,7 @@ static void free_charger_irq(struct wm8350 *wm8350)
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_TO, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_END, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_START, wm8350);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1, wm8350);
 	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85, wm8350);
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 48401dfcd999..f97a5eefa2e2 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -26,7 +26,7 @@ static ssize_t clock_name_show(struct device *dev,
 			       struct device_attribute *attr, char *page)
 {
 	struct ptp_clock *ptp = dev_get_drvdata(dev);
-	return snprintf(page, PAGE_SIZE-1, "%s\n", ptp->info->name);
+	return sysfs_emit(page, "%s\n", ptp->info->name);
 }
 static DEVICE_ATTR_RO(clock_name);
 
@@ -240,7 +240,7 @@ static ssize_t ptp_pin_show(struct device *dev, struct device_attribute *attr,
 
 	mutex_unlock(&ptp->pincfg_mux);
 
-	return snprintf(page, PAGE_SIZE, "%u %u\n", func, chan);
+	return sysfs_emit(page, "%u %u\n", func, chan);
 }
 
 static ssize_t ptp_pin_store(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/pwm/pwm-lpc18xx-sct.c b/drivers/pwm/pwm-lpc18xx-sct.c
index d7f5f7de030d..8b3aad06e236 100644
--- a/drivers/pwm/pwm-lpc18xx-sct.c
+++ b/drivers/pwm/pwm-lpc18xx-sct.c
@@ -406,12 +406,6 @@ static int lpc18xx_pwm_probe(struct platform_device *pdev)
 	lpc18xx_pwm_writel(lpc18xx_pwm, LPC18XX_PWM_LIMIT,
 			   BIT(lpc18xx_pwm->period_event));
 
-	ret = pwmchip_add(&lpc18xx_pwm->chip);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "pwmchip_add failed: %d\n", ret);
-		goto disable_pwmclk;
-	}
-
 	for (i = 0; i < lpc18xx_pwm->chip.npwm; i++) {
 		struct lpc18xx_pwm_data *data;
 
@@ -421,14 +415,12 @@ static int lpc18xx_pwm_probe(struct platform_device *pdev)
 				    GFP_KERNEL);
 		if (!data) {
 			ret = -ENOMEM;
-			goto remove_pwmchip;
+			goto disable_pwmclk;
 		}
 
 		pwm_set_chip_data(pwm, data);
 	}
 
-	platform_set_drvdata(pdev, lpc18xx_pwm);
-
 	val = lpc18xx_pwm_readl(lpc18xx_pwm, LPC18XX_PWM_CTRL);
 	val &= ~LPC18XX_PWM_BIDIR;
 	val &= ~LPC18XX_PWM_CTRL_HALT;
@@ -436,10 +428,16 @@ static int lpc18xx_pwm_probe(struct platform_device *pdev)
 	val |= LPC18XX_PWM_PRE(0);
 	lpc18xx_pwm_writel(lpc18xx_pwm, LPC18XX_PWM_CTRL, val);
 
+	ret = pwmchip_add(&lpc18xx_pwm->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "pwmchip_add failed: %d\n", ret);
+		goto disable_pwmclk;
+	}
+
+	platform_set_drvdata(pdev, lpc18xx_pwm);
+
 	return 0;
 
-remove_pwmchip:
-	pwmchip_remove(&lpc18xx_pwm->chip);
 disable_pwmclk:
 	clk_disable_unprepare(lpc18xx_pwm->pwm_clk);
 	return ret;
diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index c7686393d505..bc399fb29592 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -451,6 +451,7 @@ static int wcnss_alloc_memory_region(struct qcom_wcnss *wcnss)
 	}
 
 	ret = of_address_to_resource(node, 0, &r);
+	of_node_put(node);
 	if (ret)
 		return ret;
 
diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index 483c7993516b..ed874e5c5fc8 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -441,14 +441,21 @@ static int wm8350_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	wm8350_register_irq(wm8350, WM8350_IRQ_RTC_SEC,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_RTC_SEC,
 			    wm8350_rtc_update_handler, 0,
 			    "RTC Seconds", wm8350);
+	if (ret)
+		return ret;
+
 	wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
 
-	wm8350_register_irq(wm8350, WM8350_IRQ_RTC_ALM,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_RTC_ALM,
 			    wm8350_rtc_alarm_handler, 0,
 			    "RTC Alarm", wm8350);
+	if (ret) {
+		wm8350_free_irq(wm8350, WM8350_IRQ_RTC_SEC, wm8350);
+		return ret;
+	}
 
 	return 0;
 }
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index bc0058df31c6..24ef8e326ee5 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3374,13 +3374,11 @@ static int __init aha152x_setup(char *str)
 	setup[setup_count].synchronous = ints[0] >= 6 ? ints[6] : 1;
 	setup[setup_count].delay       = ints[0] >= 7 ? ints[7] : DELAY_DEFAULT;
 	setup[setup_count].ext_trans   = ints[0] >= 8 ? ints[8] : 0;
-	if (ints[0] > 8) {                                                /*}*/
+	if (ints[0] > 8)
 		printk(KERN_NOTICE "aha152x: usage: aha152x=<IOBASE>[,<IRQ>[,<SCSI ID>"
 		       "[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY>[,<EXT_TRANS>]]]]]]]\n");
-	} else {
+	else
 		setup_count++;
-		return 0;
-	}
 
 	return 1;
 }
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 0a70d54a4df6..47e599352468 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -722,7 +722,7 @@ bfad_im_serial_num_show(struct device *dev, struct device_attribute *attr,
 	char serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
 
 	bfa_get_adapter_serial_num(&bfad->bfa, serial_num);
-	return snprintf(buf, PAGE_SIZE, "%s\n", serial_num);
+	return sysfs_emit(buf, "%s\n", serial_num);
 }
 
 static ssize_t
@@ -736,7 +736,7 @@ bfad_im_model_show(struct device *dev, struct device_attribute *attr,
 	char model[BFA_ADAPTER_MODEL_NAME_LEN];
 
 	bfa_get_adapter_model(&bfad->bfa, model);
-	return snprintf(buf, PAGE_SIZE, "%s\n", model);
+	return sysfs_emit(buf, "%s\n", model);
 }
 
 static ssize_t
@@ -816,7 +816,7 @@ bfad_im_model_desc_show(struct device *dev, struct device_attribute *attr,
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
 			"Invalid Model");
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", model_descr);
+	return sysfs_emit(buf, "%s\n", model_descr);
 }
 
 static ssize_t
@@ -830,7 +830,7 @@ bfad_im_node_name_show(struct device *dev, struct device_attribute *attr,
 	u64        nwwn;
 
 	nwwn = bfa_fcs_lport_get_nwwn(port->fcs_port);
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n", cpu_to_be64(nwwn));
+	return sysfs_emit(buf, "0x%llx\n", cpu_to_be64(nwwn));
 }
 
 static ssize_t
@@ -847,7 +847,7 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
 	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
 	strlcpy(symname, port_attr.port_cfg.sym_name.symname,
 			BFA_SYMNAME_MAXLEN);
-	return snprintf(buf, PAGE_SIZE, "%s\n", symname);
+	return sysfs_emit(buf, "%s\n", symname);
 }
 
 static ssize_t
@@ -861,14 +861,14 @@ bfad_im_hw_version_show(struct device *dev, struct device_attribute *attr,
 	char hw_ver[BFA_VERSION_LEN];
 
 	bfa_get_pci_chip_rev(&bfad->bfa, hw_ver);
-	return snprintf(buf, PAGE_SIZE, "%s\n", hw_ver);
+	return sysfs_emit(buf, "%s\n", hw_ver);
 }
 
 static ssize_t
 bfad_im_drv_version_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_VERSION);
+	return sysfs_emit(buf, "%s\n", BFAD_DRIVER_VERSION);
 }
 
 static ssize_t
@@ -882,7 +882,7 @@ bfad_im_optionrom_version_show(struct device *dev,
 	char optrom_ver[BFA_VERSION_LEN];
 
 	bfa_get_adapter_optrom_ver(&bfad->bfa, optrom_ver);
-	return snprintf(buf, PAGE_SIZE, "%s\n", optrom_ver);
+	return sysfs_emit(buf, "%s\n", optrom_ver);
 }
 
 static ssize_t
@@ -896,7 +896,7 @@ bfad_im_fw_version_show(struct device *dev, struct device_attribute *attr,
 	char fw_ver[BFA_VERSION_LEN];
 
 	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
-	return snprintf(buf, PAGE_SIZE, "%s\n", fw_ver);
+	return sysfs_emit(buf, "%s\n", fw_ver);
 }
 
 static ssize_t
@@ -908,7 +908,7 @@ bfad_im_num_of_ports_show(struct device *dev, struct device_attribute *attr,
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
+	return sysfs_emit(buf, "%d\n",
 			bfa_get_nports(&bfad->bfa));
 }
 
@@ -916,7 +916,7 @@ static ssize_t
 bfad_im_drv_name_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_NAME);
+	return sysfs_emit(buf, "%s\n", BFAD_DRIVER_NAME);
 }
 
 static ssize_t
@@ -935,14 +935,14 @@ bfad_im_num_of_discovered_ports_show(struct device *dev,
 	rports = kzalloc(sizeof(struct bfa_rport_qualifier_s) * nrports,
 			 GFP_ATOMIC);
 	if (rports == NULL)
-		return snprintf(buf, PAGE_SIZE, "Failed\n");
+		return sysfs_emit(buf, "Failed\n");
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	bfa_fcs_lport_get_rport_quals(port->fcs_port, rports, &nrports);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	kfree(rports);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", nrports);
+	return sysfs_emit(buf, "%d\n", nrports);
 }
 
 static          DEVICE_ATTR(serial_number, S_IRUGO,
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 25d2741cdf96..b97140661119 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -44,7 +44,7 @@
 
 #define IBMVSCSIS_VERSION	"v0.2"
 
-#define	INITIAL_SRP_LIMIT	800
+#define	INITIAL_SRP_LIMIT	1024
 #define	DEFAULT_MAX_SECTORS	256
 #define MAX_TXU			1024 * 1024
 
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 384458d1f73c..9fa0aa235cb4 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1709,6 +1709,7 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	if (cancel_delayed_work_sync(&ep->timeout_work)) {
 		FC_EXCH_DBG(ep, "Exchange timer canceled due to ABTS response\n");
 		fc_exch_release(ep);	/* release from pending timer hold */
+		return;
 	}
 
 	spin_lock_bh(&ep->ex_lock);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 9eb61a41be24..1afb4402a799 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -220,7 +220,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 		task->total_xfer_len = qc->nbytes;
 		task->num_scatter = qc->n_elem;
 		task->data_dir = qc->dma_dir;
-	} else if (qc->tf.protocol == ATA_PROT_NODATA) {
+	} else if (!ata_is_data(qc->tf.protocol)) {
 		task->data_dir = DMA_NONE;
 	} else {
 		for_each_sg(qc->sg, sg, qc->n_elem, si)
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 718c88de328b..b03fdff72adb 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -678,6 +678,7 @@ static struct pci_device_id mvs_pci_table[] = {
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
 	{ PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },
+	{ PCI_VDEVICE(TTI, 0x2640), chip_6440 },
 	{ PCI_VDEVICE(TTI, 0x2710), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2720), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2721), chip_9480 },
@@ -729,7 +730,7 @@ static ssize_t
 mvs_show_driver_version(struct device *cdev,
 		struct device_attribute *attr,  char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%s\n", DRV_VERSION);
+	return sysfs_emit(buffer, "%s\n", DRV_VERSION);
 }
 
 static DEVICE_ATTR(driver_version,
@@ -781,7 +782,7 @@ mvs_store_interrupt_coalescing(struct device *cdev,
 static ssize_t mvs_show_interrupt_coalescing(struct device *cdev,
 			struct device_attribute *attr, char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%d\n", interrupt_coalescing);
+	return sysfs_emit(buffer, "%d\n", interrupt_coalescing);
 }
 
 static DEVICE_ATTR(interrupt_coalescing,
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index f374abfb7f1f..cc90b5c8d462 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1748,6 +1748,7 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	ccb->device = pm8001_ha_dev;
 	ccb->ccb_tag = ccb_tag;
 	ccb->task = task;
+	ccb->n_elem = 0;
 
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 
@@ -1810,6 +1811,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	ccb->device = pm8001_ha_dev;
 	ccb->ccb_tag = ccb_tag;
 	ccb->task = task;
+	ccb->n_elem = 0;
 	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
 	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
 
@@ -1826,7 +1828,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	sata_cmd.tag = cpu_to_le32(ccb_tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m |= ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m = cpu_to_le32((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
@@ -3766,12 +3768,11 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	mb();
 
 	if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
-		pm8001_tag_free(pm8001_ha, tag);
 		sas_free_task(t);
-		/* clear the flag */
-		pm8001_dev->id &= 0xBFFFFFFF;
-	} else
+		pm8001_dev->id &= ~NCQ_ABORT_ALL_FLAG;
+	} else {
 		t->task_done(t);
+	}
 
 	return 0;
 }
@@ -4718,7 +4719,7 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *pm8001_ha,
 	memcpy(sspTMCmd.lun, task->ssp_task.LUN, 8);
 	sspTMCmd.tag = cpu_to_le32(ccb->ccb_tag);
 	if (pm8001_ha->chip_id != chip_8001)
-		sspTMCmd.ds_ads_m = 0x08;
+		sspTMCmd.ds_ads_m = cpu_to_le32(0x08);
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd, 0);
 	return ret;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index df5f0bc29587..4eae727ccfbc 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -870,9 +870,11 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
 	else
 		page_code = THERMAL_PAGE_CODE_8H;
 
-	payload.cfg_pg[0] = (THERMAL_LOG_ENABLE << 9) |
-				(THERMAL_ENABLE << 8) | page_code;
-	payload.cfg_pg[1] = (LTEMPHIL << 24) | (RTEMPHIL << 8);
+	payload.cfg_pg[0] =
+		cpu_to_le32((THERMAL_LOG_ENABLE << 9) |
+			    (THERMAL_ENABLE << 8) | page_code);
+	payload.cfg_pg[1] =
+		cpu_to_le32((LTEMPHIL << 24) | (RTEMPHIL << 8));
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 	if (rc)
@@ -1424,6 +1426,7 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	ccb->device = pm8001_ha_dev;
 	ccb->ccb_tag = ccb_tag;
 	ccb->task = task;
+	ccb->n_elem = 0;
 
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 
@@ -1504,7 +1507,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	sata_cmd.tag = cpu_to_le32(ccb_tag);
 	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m_dad |= ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m_dad = cpu_to_le32(((0x1 << 7) | (0x5 << 9)));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a66f7cec797c..0de22299df4e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8037,7 +8037,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
 		qpair->rsp->req = qpair->req;
 		qpair->rsp->qpair = qpair;
 		/* init qpair to this cpu. Will adjust at run time. */
-		qla_cpu_update(qpair, smp_processor_id());
+		qla_cpu_update(qpair, raw_smp_processor_id());
 
 		if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
 			if (ha->fw_attributes & BIT_4)
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cb2db1c1e9f2..97a0c2384aee 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3095,6 +3095,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			"RESET-RSP online/active/old-count/new-count = %d/%d/%d/%d.\n",
 			vha->flags.online, qla2x00_reset_active(vha),
 			cmd->reset_count, qpair->chip_reset);
+		res = 0;
 		goto out_unmap_unlock;
 	}
 
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index aff31991aea9..ee6d97473853 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -158,6 +158,8 @@ static void zorro7xx_remove_one(struct zorro_dev *z)
 	scsi_remove_host(host);
 
 	NCR_700_release(host);
+	if (host->base > 0x01000000)
+		iounmap(hostdata->base);
 	kfree(hostdata);
 	free_irq(host->irq, host);
 	zorro_release_device(z);
diff --git a/drivers/soc/ti/wkup_m3_ipc.c b/drivers/soc/ti/wkup_m3_ipc.c
index 651827c6ee6f..1223eed329ea 100644
--- a/drivers/soc/ti/wkup_m3_ipc.c
+++ b/drivers/soc/ti/wkup_m3_ipc.c
@@ -403,9 +403,9 @@ static int wkup_m3_ipc_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (!irq) {
+	if (irq < 0) {
 		dev_err(&pdev->dev, "no irq resource\n");
-		return -ENXIO;
+		return irq;
 	}
 
 	ret = devm_request_irq(dev, irq, wkup_m3_txev_handler,
diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index 1736a48bbcce..54e316eb0891 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -72,14 +72,23 @@ static bool lpss_dma_filter(struct dma_chan *chan, void *param)
 	return true;
 }
 
+static void lpss_dma_put_device(void *dma_dev)
+{
+	pci_dev_put(dma_dev);
+}
+
 static int lpss_spi_setup(struct pci_dev *dev, struct pxa_spi_info *c)
 {
 	struct pci_dev *dma_dev;
+	int ret;
 
 	c->num_chipselect = 1;
 	c->max_clk_rate = 50000000;
 
 	dma_dev = pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
+	ret = devm_add_action_or_reset(&dev->dev, lpss_dma_put_device, dma_dev);
+	if (ret)
+		return ret;
 
 	if (c->tx_param) {
 		struct dw_dma_slave *slave = c->tx_param;
@@ -103,8 +112,9 @@ static int lpss_spi_setup(struct pci_dev *dev, struct pxa_spi_info *c)
 
 static int mrfld_spi_setup(struct pci_dev *dev, struct pxa_spi_info *c)
 {
-	struct pci_dev *dma_dev = pci_get_slot(dev->bus, PCI_DEVFN(21, 0));
 	struct dw_dma_slave *tx, *rx;
+	struct pci_dev *dma_dev;
+	int ret;
 
 	switch (PCI_FUNC(dev->devfn)) {
 	case 0:
@@ -129,6 +139,11 @@ static int mrfld_spi_setup(struct pci_dev *dev, struct pxa_spi_info *c)
 		return -ENODEV;
 	}
 
+	dma_dev = pci_get_slot(dev->bus, PCI_DEVFN(21, 0));
+	ret = devm_add_action_or_reset(&dev->dev, lpss_dma_put_device, dma_dev);
+	if (ret)
+		return ret;
+
 	tx = c->tx_param;
 	tx->dma_dev = &dma_dev->dev;
 
diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 0e1a8d7aa322..9758b7f7e92f 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1136,6 +1136,10 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	tspi->phys = r->start;
 
 	spi_irq = platform_get_irq(pdev, 0);
+	if (spi_irq < 0) {
+		ret = spi_irq;
+		goto exit_free_master;
+	}
 	tspi->irq = spi_irq;
 
 	tspi->clk = devm_clk_get(&pdev->dev, "spi");
diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 1548f7b738c1..b520525df246 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1016,14 +1016,8 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	struct resource		*r;
 	int ret, spi_irq;
 	const struct tegra_slink_chip_data *cdata = NULL;
-	const struct of_device_id *match;
 
-	match = of_match_device(tegra_slink_of_match, &pdev->dev);
-	if (!match) {
-		dev_err(&pdev->dev, "Error: No device match found\n");
-		return -ENODEV;
-	}
-	cdata = match->data;
+	cdata = of_device_get_match_data(&pdev->dev);
 
 	master = spi_alloc_master(&pdev->dev, sizeof(*tspi));
 	if (!master) {
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 71f74015efb9..1031c8e38144 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -774,10 +774,10 @@ static int spi_map_buf(struct spi_controller *ctlr, struct device *dev,
 	int i, ret;
 
 	if (vmalloced_buf || kmap_buf) {
-		desc_len = min_t(int, max_seg_size, PAGE_SIZE);
+		desc_len = min_t(unsigned long, max_seg_size, PAGE_SIZE);
 		sgs = DIV_ROUND_UP(len + offset_in_page(buf), desc_len);
 	} else if (virt_addr_valid(buf)) {
-		desc_len = min_t(int, max_seg_size, ctlr->max_dma_len);
+		desc_len = min_t(size_t, max_seg_size, ctlr->max_dma_len);
 		sgs = DIV_ROUND_UP(len, desc_len);
 	} else {
 		return -EINVAL;
diff --git a/drivers/staging/iio/adc/ad7280a.c b/drivers/staging/iio/adc/ad7280a.c
index f17f700ea04f..0b639da562d9 100644
--- a/drivers/staging/iio/adc/ad7280a.c
+++ b/drivers/staging/iio/adc/ad7280a.c
@@ -102,9 +102,9 @@
 static unsigned int ad7280a_devaddr(unsigned int addr)
 {
 	return ((addr & 0x1) << 4) |
-	       ((addr & 0x2) << 3) |
+	       ((addr & 0x2) << 2) |
 	       (addr & 0x4) |
-	       ((addr & 0x8) >> 3) |
+	       ((addr & 0x8) >> 2) |
 	       ((addr & 0x10) >> 4);
 }
 
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 96601fda47b1..f687481ccfdc 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1165,6 +1165,7 @@ static struct page *tcmu_try_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 	mutex_lock(&udev->cmdr_lock);
 	page = tcmu_get_block_page(udev, dbi);
 	if (likely(page)) {
+		get_page(page);
 		mutex_unlock(&udev->cmdr_lock);
 		return page;
 	}
@@ -1233,6 +1234,7 @@ static int tcmu_vma_fault(struct vm_fault *vmf)
 		/* For the vmalloc()ed cmd area pages */
 		addr = (void *)(unsigned long)info->mem[mi].addr + offset;
 		page = vmalloc_to_page(addr);
+		get_page(page);
 	} else {
 		uint32_t dbi;
 
@@ -1243,7 +1245,6 @@ static int tcmu_vma_fault(struct vm_fault *vmf)
 			return VM_FAULT_NOPAGE;
 	}
 
-	get_page(page);
 	vmf->page = page;
 	return 0;
 }
diff --git a/drivers/thermal/int340x_thermal/int3400_thermal.c b/drivers/thermal/int340x_thermal/int3400_thermal.c
index d7cd86116084..72fd878b20f8 100644
--- a/drivers/thermal/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/int340x_thermal/int3400_thermal.c
@@ -53,7 +53,7 @@ struct int3400_thermal_priv {
 	struct art *arts;
 	int trt_count;
 	struct trt *trts;
-	u8 uuid_bitmap;
+	u32 uuid_bitmap;
 	int rel_misc_dev_res;
 	int current_uuid_index;
 };
diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index a74680729825..be1bef7896a5 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -1470,7 +1470,9 @@ static int __init hvc_iucv_init(void)
  */
 static	int __init hvc_iucv_config(char *val)
 {
-	 return kstrtoul(val, 10, &hvc_iucv_devices);
+	if (kstrtoul(val, 10, &hvc_iucv_devices))
+		pr_warn("hvc_iucv= invalid parameter value '%s'\n", val);
+	return 1;
 }
 
 
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 7dd38047ba23..31d5a4d95c2d 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -866,6 +866,7 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
 	struct mxser_port *info = container_of(port, struct mxser_port, port);
 	unsigned long page;
 	unsigned long flags;
+	int ret;
 
 	page = __get_free_page(GFP_KERNEL);
 	if (!page)
@@ -875,9 +876,9 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
 
 	if (!info->ioaddr || !info->type) {
 		set_bit(TTY_IO_ERROR, &tty->flags);
-		free_page(page);
 		spin_unlock_irqrestore(&info->slock, flags);
-		return 0;
+		ret = 0;
+		goto err_free_xmit;
 	}
 	info->port.xmit_buf = (unsigned char *) page;
 
@@ -903,8 +904,10 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
 		if (capable(CAP_SYS_ADMIN)) {
 			set_bit(TTY_IO_ERROR, &tty->flags);
 			return 0;
-		} else
-			return -ENODEV;
+		}
+
+		ret = -ENODEV;
+		goto err_free_xmit;
 	}
 
 	/*
@@ -949,6 +952,10 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
 	spin_unlock_irqrestore(&info->slock, flags);
 
 	return 0;
+err_free_xmit:
+	free_page(page);
+	info->port.xmit_buf = NULL;
+	return ret;
 }
 
 /*
diff --git a/drivers/tty/serial/8250/8250_mid.c b/drivers/tty/serial/8250/8250_mid.c
index ec957cce8c9a..83446e7ceec7 100644
--- a/drivers/tty/serial/8250/8250_mid.c
+++ b/drivers/tty/serial/8250/8250_mid.c
@@ -75,6 +75,11 @@ static int pnw_setup(struct mid8250 *mid, struct uart_port *p)
 	return 0;
 }
 
+static void pnw_exit(struct mid8250 *mid)
+{
+	pci_dev_put(mid->dma_dev);
+}
+
 static int tng_handle_irq(struct uart_port *p)
 {
 	struct mid8250 *mid = p->private_data;
@@ -126,6 +131,11 @@ static int tng_setup(struct mid8250 *mid, struct uart_port *p)
 	return 0;
 }
 
+static void tng_exit(struct mid8250 *mid)
+{
+	pci_dev_put(mid->dma_dev);
+}
+
 static int dnv_handle_irq(struct uart_port *p)
 {
 	struct mid8250 *mid = p->private_data;
@@ -332,9 +342,9 @@ static int mid8250_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, mid);
 	return 0;
+
 err:
-	if (mid->board->exit)
-		mid->board->exit(mid);
+	mid->board->exit(mid);
 	return ret;
 }
 
@@ -344,8 +354,7 @@ static void mid8250_remove(struct pci_dev *pdev)
 
 	serial8250_unregister_port(mid->line);
 
-	if (mid->board->exit)
-		mid->board->exit(mid);
+	mid->board->exit(mid);
 }
 
 static const struct mid8250_board pnw_board = {
@@ -353,6 +362,7 @@ static const struct mid8250_board pnw_board = {
 	.freq = 50000000,
 	.base_baud = 115200,
 	.setup = pnw_setup,
+	.exit = pnw_exit,
 };
 
 static const struct mid8250_board tng_board = {
@@ -360,6 +370,7 @@ static const struct mid8250_board tng_board = {
 	.freq = 38400000,
 	.base_baud = 1843200,
 	.setup = tng_setup,
+	.exit = tng_exit,
 };
 
 static const struct mid8250_board dnv_board = {
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 7ac6bb38948f..9758d3b0c9fc 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1596,6 +1596,18 @@ static inline void start_tx_rs485(struct uart_port *port)
 	if (!(up->port.rs485.flags & SER_RS485_RX_DURING_TX))
 		serial8250_stop_rx(&up->port);
 
+	/*
+	 * While serial8250_em485_handle_stop_tx() is a noop if
+	 * em485->active_timer != &em485->stop_tx_timer, it might happen that
+	 * the timer is still armed and triggers only after the current bunch of
+	 * chars is send and em485->active_timer == &em485->stop_tx_timer again.
+	 * So cancel the timer. There is still a theoretical race condition if
+	 * the timer is already running and only comes around to check for
+	 * em485->active_timer when &em485->stop_tx_timer is armed again.
+	 */
+	if (em485->active_timer == &em485->stop_tx_timer)
+		hrtimer_try_to_cancel(&em485->stop_tx_timer);
+
 	em485->active_timer = NULL;
 
 	mcr = serial8250_in_MCR(up);
diff --git a/drivers/tty/serial/kgdboc.c b/drivers/tty/serial/kgdboc.c
index 0314e78e31ff..72b89702d008 100644
--- a/drivers/tty/serial/kgdboc.c
+++ b/drivers/tty/serial/kgdboc.c
@@ -304,16 +304,16 @@ static int kgdboc_option_setup(char *opt)
 {
 	if (!opt) {
 		pr_err("config string not provided\n");
-		return -EINVAL;
+		return 1;
 	}
 
 	if (strlen(opt) >= MAX_CONFIG_LEN) {
 		pr_err("config string too long\n");
-		return -ENOSPC;
+		return 1;
 	}
 	strcpy(config, opt);
 
-	return 0;
+	return 1;
 }
 
 __setup("kgdboc=", kgdboc_option_setup);
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 70d29b697e82..3886d4799603 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -764,11 +764,8 @@ static irqreturn_t s3c24xx_serial_tx_chars(int irq, void *id)
 		goto out;
 	}
 
-	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS) {
-		spin_unlock(&port->lock);
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
-		spin_lock(&port->lock);
-	}
 
 	if (uart_circ_empty(xmit))
 		s3c24xx_serial_stop_tx(port);
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 830ef7333750..6fbaa0d1bcd2 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -245,7 +245,7 @@ static void dwc3_omap_set_mailbox(struct dwc3_omap *omap,
 		break;
 
 	case OMAP_DWC3_ID_FLOAT:
-		if (omap->vbus_reg)
+		if (omap->vbus_reg && regulator_is_enabled(omap->vbus_reg))
 			regulator_disable(omap->vbus_reg);
 		val = dwc3_omap_read_utmi_ctrl(omap);
 		val |= USBOTGSS_UTMI_OTG_CTRL_IDDIG;
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index c508e2d7104b..72d5de424d49 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -65,6 +65,7 @@ config USB_SERIAL_SIMPLE
 		- Libtransistor USB console
 		- a number of Motorola phones
 		- Motorola Tetra devices
+		- Nokia mobile phones
 		- Novatel Wireless GPS receivers
 		- Siemens USB/MPI adapter.
 		- ViVOtech ViVOpay USB device.
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index f37dc4cfce27..103b77f56aec 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -113,6 +113,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(ADLINK_VENDOR_ID, ADLINK_ND6530GC_PRODUCT_ID) },
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ USB_DEVICE(AT_VENDOR_ID, AT_VTKIT3_PRODUCT_ID) },
+	{ USB_DEVICE(IBM_VENDOR_ID, IBM_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index c65c6c079544..c1b93d101990 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -34,6 +34,9 @@
 #define ATEN_PRODUCT_UC232B	0x2022
 #define ATEN_PRODUCT_ID2	0x2118
 
+#define IBM_VENDOR_ID		0x04b3
+#define IBM_PRODUCT_ID		0x4016
+
 #define IODATA_VENDOR_ID	0x04bb
 #define IODATA_PRODUCT_ID	0x0a03
 #define IODATA_PRODUCT_ID_RSAQ5	0x0a0e
diff --git a/drivers/usb/serial/usb-serial-simple.c b/drivers/usb/serial/usb-serial-simple.c
index 15e05ebf37ac..3681e6418262 100644
--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -94,6 +94,11 @@ DEVICE(moto_modem, MOTO_IDS);
 	{ USB_DEVICE(0x0cad, 0x9016) }	/* TPG2200 */
 DEVICE(motorola_tetra, MOTOROLA_TETRA_IDS);
 
+/* Nokia mobile phone driver */
+#define NOKIA_IDS()			\
+	{ USB_DEVICE(0x0421, 0x069a) }	/* Nokia 130 (RM-1035) */
+DEVICE(nokia, NOKIA_IDS);
+
 /* Novatel Wireless GPS driver */
 #define NOVATEL_IDS()			\
 	{ USB_DEVICE(0x09d7, 0x0100) }	/* NovAtel FlexPack GPS */
@@ -126,6 +131,7 @@ static struct usb_serial_driver * const serial_drivers[] = {
 	&vivopay_device,
 	&moto_modem_device,
 	&motorola_tetra_device,
+	&nokia_device,
 	&novatel_gps_device,
 	&hp4x_device,
 	&suunto_device,
@@ -143,6 +149,7 @@ static const struct usb_device_id id_table[] = {
 	VIVOPAY_IDS(),
 	MOTO_IDS(),
 	MOTOROLA_TETRA_IDS(),
+	NOKIA_IDS(),
 	NOVATEL_IDS(),
 	HP4X_IDS(),
 	SUUNTO_IDS(),
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 28100374f7bd..79f77179fd9b 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -251,36 +251,33 @@ static struct us_unusual_dev ene_ub6250_unusual_dev_list[] = {
 #define memstick_logaddr(logadr1, logadr0) ((((u16)(logadr1)) << 8) | (logadr0))
 
 
-struct SD_STATUS {
-	u8    Insert:1;
-	u8    Ready:1;
-	u8    MediaChange:1;
-	u8    IsMMC:1;
-	u8    HiCapacity:1;
-	u8    HiSpeed:1;
-	u8    WtP:1;
-	u8    Reserved:1;
-};
-
-struct MS_STATUS {
-	u8    Insert:1;
-	u8    Ready:1;
-	u8    MediaChange:1;
-	u8    IsMSPro:1;
-	u8    IsMSPHG:1;
-	u8    Reserved1:1;
-	u8    WtP:1;
-	u8    Reserved2:1;
-};
-
-struct SM_STATUS {
-	u8    Insert:1;
-	u8    Ready:1;
-	u8    MediaChange:1;
-	u8    Reserved:3;
-	u8    WtP:1;
-	u8    IsMS:1;
-};
+/* SD_STATUS bits */
+#define SD_Insert	BIT(0)
+#define SD_Ready	BIT(1)
+#define SD_MediaChange	BIT(2)
+#define SD_IsMMC	BIT(3)
+#define SD_HiCapacity	BIT(4)
+#define SD_HiSpeed	BIT(5)
+#define SD_WtP		BIT(6)
+			/* Bit 7 reserved */
+
+/* MS_STATUS bits */
+#define MS_Insert	BIT(0)
+#define MS_Ready	BIT(1)
+#define MS_MediaChange	BIT(2)
+#define MS_IsMSPro	BIT(3)
+#define MS_IsMSPHG	BIT(4)
+			/* Bit 5 reserved */
+#define MS_WtP		BIT(6)
+			/* Bit 7 reserved */
+
+/* SM_STATUS bits */
+#define SM_Insert	BIT(0)
+#define SM_Ready	BIT(1)
+#define SM_MediaChange	BIT(2)
+			/* Bits 3-5 reserved */
+#define SM_WtP		BIT(6)
+#define SM_IsMS		BIT(7)
 
 struct ms_bootblock_cis {
 	u8 bCistplDEVICE[6];    /* 0 */
@@ -451,9 +448,9 @@ struct ene_ub6250_info {
 	u8		*bbuf;
 
 	/* for 6250 code */
-	struct SD_STATUS	SD_Status;
-	struct MS_STATUS	MS_Status;
-	struct SM_STATUS	SM_Status;
+	u8		SD_Status;
+	u8		MS_Status;
+	u8		SM_Status;
 
 	/* ----- SD Control Data ---------------- */
 	/*SD_REGISTER SD_Regs; */
@@ -616,7 +613,7 @@ static int sd_scsi_test_unit_ready(struct us_data *us, struct scsi_cmnd *srb)
 {
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
-	if (info->SD_Status.Insert && info->SD_Status.Ready)
+	if ((info->SD_Status & SD_Insert) && (info->SD_Status & SD_Ready))
 		return USB_STOR_TRANSPORT_GOOD;
 	else {
 		ene_sd_init(us);
@@ -636,7 +633,7 @@ static int sd_scsi_mode_sense(struct us_data *us, struct scsi_cmnd *srb)
 		0x0b, 0x00, 0x80, 0x08, 0x00, 0x00,
 		0x71, 0xc0, 0x00, 0x00, 0x02, 0x00 };
 
-	if (info->SD_Status.WtP)
+	if (info->SD_Status & SD_WtP)
 		usb_stor_set_xfer_buf(mediaWP, 12, srb);
 	else
 		usb_stor_set_xfer_buf(mediaNoWP, 12, srb);
@@ -655,9 +652,9 @@ static int sd_scsi_read_capacity(struct us_data *us, struct scsi_cmnd *srb)
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
 	usb_stor_dbg(us, "sd_scsi_read_capacity\n");
-	if (info->SD_Status.HiCapacity) {
+	if (info->SD_Status & SD_HiCapacity) {
 		bl_len = 0x200;
-		if (info->SD_Status.IsMMC)
+		if (info->SD_Status & SD_IsMMC)
 			bl_num = info->HC_C_SIZE-1;
 		else
 			bl_num = (info->HC_C_SIZE + 1) * 1024 - 1;
@@ -707,7 +704,7 @@ static int sd_scsi_read(struct us_data *us, struct scsi_cmnd *srb)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	if (info->SD_Status.HiCapacity)
+	if (info->SD_Status & SD_HiCapacity)
 		bnByte = bn;
 
 	/* set up the command wrapper */
@@ -747,7 +744,7 @@ static int sd_scsi_write(struct us_data *us, struct scsi_cmnd *srb)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	if (info->SD_Status.HiCapacity)
+	if (info->SD_Status & SD_HiCapacity)
 		bnByte = bn;
 
 	/* set up the command wrapper */
@@ -1461,7 +1458,7 @@ static int ms_scsi_test_unit_ready(struct us_data *us, struct scsi_cmnd *srb)
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *)(us->extra);
 
 	/* pr_info("MS_SCSI_Test_Unit_Ready\n"); */
-	if (info->MS_Status.Insert && info->MS_Status.Ready) {
+	if ((info->MS_Status & MS_Insert) && (info->MS_Status & MS_Ready)) {
 		return USB_STOR_TRANSPORT_GOOD;
 	} else {
 		ene_ms_init(us);
@@ -1481,7 +1478,7 @@ static int ms_scsi_mode_sense(struct us_data *us, struct scsi_cmnd *srb)
 		0x0b, 0x00, 0x80, 0x08, 0x00, 0x00,
 		0x71, 0xc0, 0x00, 0x00, 0x02, 0x00 };
 
-	if (info->MS_Status.WtP)
+	if (info->MS_Status & MS_WtP)
 		usb_stor_set_xfer_buf(mediaWP, 12, srb);
 	else
 		usb_stor_set_xfer_buf(mediaNoWP, 12, srb);
@@ -1500,7 +1497,7 @@ static int ms_scsi_read_capacity(struct us_data *us, struct scsi_cmnd *srb)
 
 	usb_stor_dbg(us, "ms_scsi_read_capacity\n");
 	bl_len = 0x200;
-	if (info->MS_Status.IsMSPro)
+	if (info->MS_Status & MS_IsMSPro)
 		bl_num = info->MSP_TotalBlock - 1;
 	else
 		bl_num = info->MS_Lib.NumberOfLogBlock * info->MS_Lib.blockSize * 2 - 1;
@@ -1655,7 +1652,7 @@ static int ms_scsi_read(struct us_data *us, struct scsi_cmnd *srb)
 	if (bn > info->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	if (info->MS_Status.IsMSPro) {
+	if (info->MS_Status & MS_IsMSPro) {
 		result = ene_load_bincode(us, MSP_RW_PATTERN);
 		if (result != USB_STOR_XFER_GOOD) {
 			usb_stor_dbg(us, "Load MPS RW pattern Fail !!\n");
@@ -1756,7 +1753,7 @@ static int ms_scsi_write(struct us_data *us, struct scsi_cmnd *srb)
 	if (bn > info->bl_num)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	if (info->MS_Status.IsMSPro) {
+	if (info->MS_Status & MS_IsMSPro) {
 		result = ene_load_bincode(us, MSP_RW_PATTERN);
 		if (result != USB_STOR_XFER_GOOD) {
 			pr_info("Load MSP RW pattern Fail !!\n");
@@ -1864,12 +1861,12 @@ static int ene_get_card_status(struct us_data *us, u8 *buf)
 
 	tmpreg = (u16) reg4b;
 	reg4b = *(u32 *)(&buf[0x14]);
-	if (info->SD_Status.HiCapacity && !info->SD_Status.IsMMC)
+	if ((info->SD_Status & SD_HiCapacity) && !(info->SD_Status & SD_IsMMC))
 		info->HC_C_SIZE = (reg4b >> 8) & 0x3fffff;
 
 	info->SD_C_SIZE = ((tmpreg & 0x03) << 10) | (u16)(reg4b >> 22);
 	info->SD_C_SIZE_MULT = (u8)(reg4b >> 7)  & 0x07;
-	if (info->SD_Status.HiCapacity && info->SD_Status.IsMMC)
+	if ((info->SD_Status & SD_HiCapacity) && (info->SD_Status & SD_IsMMC))
 		info->HC_C_SIZE = *(u32 *)(&buf[0x100]);
 
 	if (info->SD_READ_BL_LEN > SD_BLOCK_LEN) {
@@ -2081,6 +2078,7 @@ static int ene_ms_init(struct us_data *us)
 	u16 MSP_BlockSize, MSP_UserAreaBlocks;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 	u8 *bbuf = info->bbuf;
+	unsigned int s;
 
 	printk(KERN_INFO "transport --- ENE_MSInit\n");
 
@@ -2105,15 +2103,16 @@ static int ene_ms_init(struct us_data *us)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 	/* the same part to test ENE */
-	info->MS_Status = *(struct MS_STATUS *) bbuf;
-
-	if (info->MS_Status.Insert && info->MS_Status.Ready) {
-		printk(KERN_INFO "Insert     = %x\n", info->MS_Status.Insert);
-		printk(KERN_INFO "Ready      = %x\n", info->MS_Status.Ready);
-		printk(KERN_INFO "IsMSPro    = %x\n", info->MS_Status.IsMSPro);
-		printk(KERN_INFO "IsMSPHG    = %x\n", info->MS_Status.IsMSPHG);
-		printk(KERN_INFO "WtP= %x\n", info->MS_Status.WtP);
-		if (info->MS_Status.IsMSPro) {
+	info->MS_Status = bbuf[0];
+
+	s = info->MS_Status;
+	if ((s & MS_Insert) && (s & MS_Ready)) {
+		printk(KERN_INFO "Insert     = %x\n", !!(s & MS_Insert));
+		printk(KERN_INFO "Ready      = %x\n", !!(s & MS_Ready));
+		printk(KERN_INFO "IsMSPro    = %x\n", !!(s & MS_IsMSPro));
+		printk(KERN_INFO "IsMSPHG    = %x\n", !!(s & MS_IsMSPHG));
+		printk(KERN_INFO "WtP= %x\n", !!(s & MS_WtP));
+		if (s & MS_IsMSPro) {
 			MSP_BlockSize      = (bbuf[6] << 8) | bbuf[7];
 			MSP_UserAreaBlocks = (bbuf[10] << 8) | bbuf[11];
 			info->MSP_TotalBlock = MSP_BlockSize * MSP_UserAreaBlocks;
@@ -2174,17 +2173,17 @@ static int ene_sd_init(struct us_data *us)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	info->SD_Status =  *(struct SD_STATUS *) bbuf;
-	if (info->SD_Status.Insert && info->SD_Status.Ready) {
-		struct SD_STATUS *s = &info->SD_Status;
+	info->SD_Status = bbuf[0];
+	if ((info->SD_Status & SD_Insert) && (info->SD_Status & SD_Ready)) {
+		unsigned int s = info->SD_Status;
 
 		ene_get_card_status(us, bbuf);
-		usb_stor_dbg(us, "Insert     = %x\n", s->Insert);
-		usb_stor_dbg(us, "Ready      = %x\n", s->Ready);
-		usb_stor_dbg(us, "IsMMC      = %x\n", s->IsMMC);
-		usb_stor_dbg(us, "HiCapacity = %x\n", s->HiCapacity);
-		usb_stor_dbg(us, "HiSpeed    = %x\n", s->HiSpeed);
-		usb_stor_dbg(us, "WtP        = %x\n", s->WtP);
+		usb_stor_dbg(us, "Insert     = %x\n", !!(s & SD_Insert));
+		usb_stor_dbg(us, "Ready      = %x\n", !!(s & SD_Ready));
+		usb_stor_dbg(us, "IsMMC      = %x\n", !!(s & SD_IsMMC));
+		usb_stor_dbg(us, "HiCapacity = %x\n", !!(s & SD_HiCapacity));
+		usb_stor_dbg(us, "HiSpeed    = %x\n", !!(s & SD_HiSpeed));
+		usb_stor_dbg(us, "WtP        = %x\n", !!(s & SD_WtP));
 	} else {
 		usb_stor_dbg(us, "SD Card Not Ready --- %x\n", bbuf[0]);
 		return USB_STOR_TRANSPORT_ERROR;
@@ -2206,14 +2205,14 @@ static int ene_init(struct us_data *us)
 
 	misc_reg03 = bbuf[0];
 	if (misc_reg03 & 0x01) {
-		if (!info->SD_Status.Ready) {
+		if (!(info->SD_Status & SD_Ready)) {
 			result = ene_sd_init(us);
 			if (result != USB_STOR_XFER_GOOD)
 				return USB_STOR_TRANSPORT_ERROR;
 		}
 	}
 	if (misc_reg03 & 0x02) {
-		if (!info->MS_Status.Ready) {
+		if (!(info->MS_Status & MS_Ready)) {
 			result = ene_ms_init(us);
 			if (result != USB_STOR_XFER_GOOD)
 				return USB_STOR_TRANSPORT_ERROR;
@@ -2312,14 +2311,14 @@ static int ene_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	/*US_DEBUG(usb_stor_show_command(us, srb)); */
 	scsi_set_resid(srb, 0);
-	if (unlikely(!(info->SD_Status.Ready || info->MS_Status.Ready)))
+	if (unlikely(!(info->SD_Status & SD_Ready) || (info->MS_Status & MS_Ready)))
 		result = ene_init(us);
 	if (result == USB_STOR_XFER_GOOD) {
 		result = USB_STOR_TRANSPORT_ERROR;
-		if (info->SD_Status.Ready)
+		if (info->SD_Status & SD_Ready)
 			result = sd_scsi_irp(us, srb);
 
-		if (info->MS_Status.Ready)
+		if (info->MS_Status & MS_Ready)
 			result = ms_scsi_irp(us, srb);
 	}
 	return result;
@@ -2383,7 +2382,6 @@ static int ene_ub6250_probe(struct usb_interface *intf,
 
 static int ene_ub6250_resume(struct usb_interface *iface)
 {
-	u8 tmp = 0;
 	struct us_data *us = usb_get_intfdata(iface);
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *)(us->extra);
 
@@ -2395,17 +2393,16 @@ static int ene_ub6250_resume(struct usb_interface *iface)
 	mutex_unlock(&us->dev_mutex);
 
 	info->Power_IsResum = true;
-	/*info->SD_Status.Ready = 0; */
-	info->SD_Status = *(struct SD_STATUS *)&tmp;
-	info->MS_Status = *(struct MS_STATUS *)&tmp;
-	info->SM_Status = *(struct SM_STATUS *)&tmp;
+	/* info->SD_Status &= ~SD_Ready; */
+	info->SD_Status = 0;
+	info->MS_Status = 0;
+	info->SM_Status = 0;
 
 	return 0;
 }
 
 static int ene_ub6250_reset_resume(struct usb_interface *iface)
 {
-	u8 tmp = 0;
 	struct us_data *us = usb_get_intfdata(iface);
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *)(us->extra);
 
@@ -2417,10 +2414,10 @@ static int ene_ub6250_reset_resume(struct usb_interface *iface)
 	 * the device
 	 */
 	info->Power_IsResum = true;
-	/*info->SD_Status.Ready = 0; */
-	info->SD_Status = *(struct SD_STATUS *)&tmp;
-	info->MS_Status = *(struct MS_STATUS *)&tmp;
-	info->SM_Status = *(struct SM_STATUS *)&tmp;
+	/* info->SD_Status &= ~SD_Ready; */
+	info->SD_Status = 0;
+	info->MS_Status = 0;
+	info->SM_Status = 0;
 
 	return 0;
 }
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 8e0b12cc084a..0c5f1db24ee8 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -376,7 +376,7 @@ static int rts51x_read_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 
 	buf = kmalloc(len, GFP_NOIO);
 	if (buf == NULL)
-		return USB_STOR_TRANSPORT_ERROR;
+		return -ENOMEM;
 
 	usb_stor_dbg(us, "addr = 0x%x, len = %d\n", addr, len);
 
diff --git a/drivers/video/fbdev/atafb.c b/drivers/video/fbdev/atafb.c
index fcd2dd670a65..770f77055682 100644
--- a/drivers/video/fbdev/atafb.c
+++ b/drivers/video/fbdev/atafb.c
@@ -1713,9 +1713,9 @@ static int falcon_setcolreg(unsigned int regno, unsigned int red,
 			   ((blue & 0xfc00) >> 8));
 	if (regno < 16) {
 		shifter_tt.color_reg[regno] =
-			(((red & 0xe000) >> 13) | ((red & 0x1000) >> 12) << 8) |
-			(((green & 0xe000) >> 13) | ((green & 0x1000) >> 12) << 4) |
-			((blue & 0xe000) >> 13) | ((blue & 0x1000) >> 12);
+			((((red & 0xe000) >> 13)   | ((red & 0x1000) >> 12)) << 8)   |
+			((((green & 0xe000) >> 13) | ((green & 0x1000) >> 12)) << 4) |
+			   ((blue & 0xe000) >> 13) | ((blue & 0x1000) >> 12);
 		((u32 *)info->pseudo_palette)[regno] = ((red & 0xf800) |
 						       ((green & 0xfc00) >> 5) |
 						       ((blue & 0xf800) >> 11));
@@ -2001,9 +2001,9 @@ static int stste_setcolreg(unsigned int regno, unsigned int red,
 	green >>= 12;
 	if (ATARIHW_PRESENT(EXTD_SHIFTER))
 		shifter_tt.color_reg[regno] =
-			(((red & 0xe) >> 1) | ((red & 1) << 3) << 8) |
-			(((green & 0xe) >> 1) | ((green & 1) << 3) << 4) |
-			((blue & 0xe) >> 1) | ((blue & 1) << 3);
+			((((red & 0xe)   >> 1) | ((red & 1)   << 3)) << 8) |
+			((((green & 0xe) >> 1) | ((green & 1) << 3)) << 4) |
+			  ((blue & 0xe)  >> 1) | ((blue & 1)  << 3);
 	else
 		shifter_tt.color_reg[regno] =
 			((red & 0xe) << 7) |
diff --git a/drivers/video/fbdev/cirrusfb.c b/drivers/video/fbdev/cirrusfb.c
index d992aa5eb3f0..a8f4967de798 100644
--- a/drivers/video/fbdev/cirrusfb.c
+++ b/drivers/video/fbdev/cirrusfb.c
@@ -470,7 +470,7 @@ static int cirrusfb_check_mclk(struct fb_info *info, long freq)
 	return 0;
 }
 
-static int cirrusfb_check_pixclock(const struct fb_var_screeninfo *var,
+static int cirrusfb_check_pixclock(struct fb_var_screeninfo *var,
 				   struct fb_info *info)
 {
 	long freq;
@@ -479,9 +479,7 @@ static int cirrusfb_check_pixclock(const struct fb_var_screeninfo *var,
 	unsigned maxclockidx = var->bits_per_pixel >> 3;
 
 	/* convert from ps to kHz */
-	freq = PICOS2KHZ(var->pixclock);
-
-	dev_dbg(info->device, "desired pixclock: %ld kHz\n", freq);
+	freq = PICOS2KHZ(var->pixclock ? : 1);
 
 	maxclock = cirrusfb_board_info[cinfo->btype].maxclock[maxclockidx];
 	cinfo->multiplexing = 0;
@@ -489,11 +487,13 @@ static int cirrusfb_check_pixclock(const struct fb_var_screeninfo *var,
 	/* If the frequency is greater than we can support, we might be able
 	 * to use multiplexing for the video mode */
 	if (freq > maxclock) {
-		dev_err(info->device,
-			"Frequency greater than maxclock (%ld kHz)\n",
-			maxclock);
-		return -EINVAL;
+		var->pixclock = KHZ2PICOS(maxclock);
+
+		while ((freq = PICOS2KHZ(var->pixclock)) > maxclock)
+			var->pixclock++;
 	}
+	dev_dbg(info->device, "desired pixclock: %ld kHz\n", freq);
+
 	/*
 	 * Additional constraint: 8bpp uses DAC clock doubling to allow maximum
 	 * pixel clock
diff --git a/drivers/video/fbdev/core/fbcvt.c b/drivers/video/fbdev/core/fbcvt.c
index 55d2bd0ce5c0..64843464c661 100644
--- a/drivers/video/fbdev/core/fbcvt.c
+++ b/drivers/video/fbdev/core/fbcvt.c
@@ -214,9 +214,11 @@ static u32 fb_cvt_aspect_ratio(struct fb_cvt_data *cvt)
 static void fb_cvt_print_name(struct fb_cvt_data *cvt)
 {
 	u32 pixcount, pixcount_mod;
-	int cnt = 255, offset = 0, read = 0;
-	u8 *buf = kzalloc(256, GFP_KERNEL);
+	int size = 256;
+	int off = 0;
+	u8 *buf;
 
+	buf = kzalloc(size, GFP_KERNEL);
 	if (!buf)
 		return;
 
@@ -224,43 +226,30 @@ static void fb_cvt_print_name(struct fb_cvt_data *cvt)
 	pixcount_mod = (cvt->xres * (cvt->yres/cvt->interlace)) % 1000000;
 	pixcount_mod /= 1000;
 
-	read = snprintf(buf+offset, cnt, "fbcvt: %dx%d@%d: CVT Name - ",
-			cvt->xres, cvt->yres, cvt->refresh);
-	offset += read;
-	cnt -= read;
+	off += scnprintf(buf + off, size - off, "fbcvt: %dx%d@%d: CVT Name - ",
+			    cvt->xres, cvt->yres, cvt->refresh);
 
-	if (cvt->status)
-		snprintf(buf+offset, cnt, "Not a CVT standard - %d.%03d Mega "
-			 "Pixel Image\n", pixcount, pixcount_mod);
-	else {
-		if (pixcount) {
-			read = snprintf(buf+offset, cnt, "%d", pixcount);
-			cnt -= read;
-			offset += read;
-		}
+	if (cvt->status) {
+		off += scnprintf(buf + off, size - off,
+				 "Not a CVT standard - %d.%03d Mega Pixel Image\n",
+				 pixcount, pixcount_mod);
+	} else {
+		if (pixcount)
+			off += scnprintf(buf + off, size - off, "%d", pixcount);
 
-		read = snprintf(buf+offset, cnt, ".%03dM", pixcount_mod);
-		cnt -= read;
-		offset += read;
+		off += scnprintf(buf + off, size - off, ".%03dM", pixcount_mod);
 
 		if (cvt->aspect_ratio == 0)
-			read = snprintf(buf+offset, cnt, "3");
+			off += scnprintf(buf + off, size - off, "3");
 		else if (cvt->aspect_ratio == 3)
-			read = snprintf(buf+offset, cnt, "4");
+			off += scnprintf(buf + off, size - off, "4");
 		else if (cvt->aspect_ratio == 1 || cvt->aspect_ratio == 4)
-			read = snprintf(buf+offset, cnt, "9");
+			off += scnprintf(buf + off, size - off, "9");
 		else if (cvt->aspect_ratio == 2)
-			read = snprintf(buf+offset, cnt, "A");
-		else
-			read = 0;
-		cnt -= read;
-		offset += read;
-
-		if (cvt->flags & FB_CVT_FLAG_REDUCED_BLANK) {
-			read = snprintf(buf+offset, cnt, "-R");
-			cnt -= read;
-			offset += read;
-		}
+			off += scnprintf(buf + off, size - off, "A");
+
+		if (cvt->flags & FB_CVT_FLAG_REDUCED_BLANK)
+			off += scnprintf(buf + off, size - off, "-R");
 	}
 
 	printk(KERN_INFO "%s\n", buf);
diff --git a/drivers/video/fbdev/nvidia/nv_i2c.c b/drivers/video/fbdev/nvidia/nv_i2c.c
index d7994a173245..0b48965a6420 100644
--- a/drivers/video/fbdev/nvidia/nv_i2c.c
+++ b/drivers/video/fbdev/nvidia/nv_i2c.c
@@ -86,7 +86,7 @@ static int nvidia_setup_i2c_bus(struct nvidia_i2c_chan *chan, const char *name,
 {
 	int rc;
 
-	strcpy(chan->adapter.name, name);
+	strscpy(chan->adapter.name, name, sizeof(chan->adapter.name));
 	chan->adapter.owner = THIS_MODULE;
 	chan->adapter.class = i2c_class;
 	chan->adapter.algo_data = &chan->algo;
diff --git a/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c b/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c
index 06e1db34541e..41b0db0cc047 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c
@@ -254,6 +254,7 @@ static int dvic_probe_of(struct platform_device *pdev)
 	adapter_node = of_parse_phandle(node, "ddc-i2c-bus", 0);
 	if (adapter_node) {
 		adapter = of_get_i2c_adapter_by_node(adapter_node);
+		of_node_put(adapter_node);
 		if (adapter == NULL) {
 			dev_err(&pdev->dev, "failed to parse ddc-i2c-bus\n");
 			omap_dss_put_device(ddata->in);
diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
index bef431530090..25cc0bcdfe19 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c
@@ -413,7 +413,7 @@ static ssize_t dsicm_num_errors_show(struct device *dev,
 	if (r)
 		return r;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", errors);
+	return sysfs_emit(buf, "%d\n", errors);
 }
 
 static ssize_t dsicm_hw_revision_show(struct device *dev,
@@ -444,7 +444,7 @@ static ssize_t dsicm_hw_revision_show(struct device *dev,
 	if (r)
 		return r;
 
-	return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x\n", id1, id2, id3);
+	return sysfs_emit(buf, "%02x.%02x.%02x\n", id1, id2, id3);
 }
 
 static ssize_t dsicm_store_ulps(struct device *dev,
@@ -494,7 +494,7 @@ static ssize_t dsicm_show_ulps(struct device *dev,
 	t = ddata->ulps_enabled;
 	mutex_unlock(&ddata->lock);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", t);
+	return sysfs_emit(buf, "%u\n", t);
 }
 
 static ssize_t dsicm_store_ulps_timeout(struct device *dev,
@@ -541,7 +541,7 @@ static ssize_t dsicm_show_ulps_timeout(struct device *dev,
 	t = ddata->ulps_timeout;
 	mutex_unlock(&ddata->lock);
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", t);
+	return sysfs_emit(buf, "%u\n", t);
 }
 
 static DEVICE_ATTR(num_dsi_errors, S_IRUGO, dsicm_num_errors_show, NULL);
diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
index f2c2fef3db74..87c4f420a9d9 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
@@ -487,7 +487,7 @@ static ssize_t show_cabc_available_modes(struct device *dev,
 	int i;
 
 	if (!ddata->has_cabc)
-		return snprintf(buf, PAGE_SIZE, "%s\n", cabc_modes[0]);
+		return sysfs_emit(buf, "%s\n", cabc_modes[0]);
 
 	for (i = 0, len = 0;
 	     len < PAGE_SIZE && i < ARRAY_SIZE(cabc_modes); i++)
diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
index ea8c79a42b41..3f1389bfba6f 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
@@ -173,7 +173,7 @@ static ssize_t tpo_td043_vmirror_show(struct device *dev,
 {
 	struct panel_drv_data *ddata = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", ddata->vmirror);
+	return sysfs_emit(buf, "%d\n", ddata->vmirror);
 }
 
 static ssize_t tpo_td043_vmirror_store(struct device *dev,
@@ -203,7 +203,7 @@ static ssize_t tpo_td043_mode_show(struct device *dev,
 {
 	struct panel_drv_data *ddata = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", ddata->mode);
+	return sysfs_emit(buf, "%d\n", ddata->mode);
 }
 
 static ssize_t tpo_td043_mode_store(struct device *dev,
diff --git a/drivers/video/fbdev/sm712fb.c b/drivers/video/fbdev/sm712fb.c
index 1781ca697f66..f4396d1389e4 100644
--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1047,7 +1047,7 @@ static ssize_t smtcfb_read(struct fb_info *info, char __user *buf,
 	if (count + p > total_size)
 		count = total_size - p;
 
-	buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count, GFP_KERNEL);
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -1059,25 +1059,14 @@ static ssize_t smtcfb_read(struct fb_info *info, char __user *buf,
 	while (count) {
 		c = (count > PAGE_SIZE) ? PAGE_SIZE : count;
 		dst = buffer;
-		for (i = c >> 2; i--;) {
-			*dst = fb_readl(src++);
-			*dst = big_swap(*dst);
+		for (i = (c + 3) >> 2; i--;) {
+			u32 val;
+
+			val = fb_readl(src);
+			*dst = big_swap(val);
+			src++;
 			dst++;
 		}
-		if (c & 3) {
-			u8 *dst8 = (u8 *)dst;
-			u8 __iomem *src8 = (u8 __iomem *)src;
-
-			for (i = c & 3; i--;) {
-				if (i & 1) {
-					*dst8++ = fb_readb(++src8);
-				} else {
-					*dst8++ = fb_readb(--src8);
-					src8 += 2;
-				}
-			}
-			src = (u32 __iomem *)src8;
-		}
 
 		if (copy_to_user(buf, buffer, c)) {
 			err = -EFAULT;
@@ -1130,7 +1119,7 @@ static ssize_t smtcfb_write(struct fb_info *info, const char __user *buf,
 		count = total_size - p;
 	}
 
-	buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count, GFP_KERNEL);
+	buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -1148,24 +1137,11 @@ static ssize_t smtcfb_write(struct fb_info *info, const char __user *buf,
 			break;
 		}
 
-		for (i = c >> 2; i--;) {
-			fb_writel(big_swap(*src), dst++);
+		for (i = (c + 3) >> 2; i--;) {
+			fb_writel(big_swap(*src), dst);
+			dst++;
 			src++;
 		}
-		if (c & 3) {
-			u8 *src8 = (u8 *)src;
-			u8 __iomem *dst8 = (u8 __iomem *)dst;
-
-			for (i = c & 3; i--;) {
-				if (i & 1) {
-					fb_writeb(*src8++, ++dst8);
-				} else {
-					fb_writeb(*src8++, --dst8);
-					dst8 += 2;
-				}
-			}
-			dst = (u32 __iomem *)dst8;
-		}
 
 		*ppos += c;
 		buf += c;
diff --git a/drivers/video/fbdev/smscufx.c b/drivers/video/fbdev/smscufx.c
index 2275e80b5776..1b244bea24b8 100644
--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -1672,6 +1672,7 @@ static int ufx_usb_probe(struct usb_interface *interface,
 	info->par = dev;
 	info->pseudo_palette = dev->pseudo_palette;
 	info->fbops = &ufx_ops;
+	INIT_LIST_HEAD(&info->modelist);
 
 	retval = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (retval < 0) {
@@ -1682,8 +1683,6 @@ static int ufx_usb_probe(struct usb_interface *interface,
 	INIT_DELAYED_WORK(&dev->free_framebuffer_work,
 			  ufx_free_framebuffer_work);
 
-	INIT_LIST_HEAD(&info->modelist);
-
 	retval = ufx_reg_read(dev, 0x3000, &id_rev);
 	check_warn_goto_error(retval, "error %d reading 0x3000 register from device", retval);
 	dev_dbg(dev->gdev, "ID_REV register value 0x%08x", id_rev);
diff --git a/drivers/video/fbdev/w100fb.c b/drivers/video/fbdev/w100fb.c
index ffda1d68fb05..566eacd903a3 100644
--- a/drivers/video/fbdev/w100fb.c
+++ b/drivers/video/fbdev/w100fb.c
@@ -772,12 +772,18 @@ int w100fb_probe(struct platform_device *pdev)
 		fb_dealloc_cmap(&info->cmap);
 		kfree(info->pseudo_palette);
 	}
-	if (remapped_fbuf != NULL)
+	if (remapped_fbuf != NULL) {
 		iounmap(remapped_fbuf);
-	if (remapped_regs != NULL)
+		remapped_fbuf = NULL;
+	}
+	if (remapped_regs != NULL) {
 		iounmap(remapped_regs);
-	if (remapped_base != NULL)
+		remapped_regs = NULL;
+	}
+	if (remapped_base != NULL) {
 		iounmap(remapped_base);
+		remapped_base = NULL;
+	}
 	if (info)
 		framebuffer_release(info);
 	return err;
@@ -802,8 +808,11 @@ static int w100fb_remove(struct platform_device *pdev)
 	fb_dealloc_cmap(&info->cmap);
 
 	iounmap(remapped_base);
+	remapped_base = NULL;
 	iounmap(remapped_regs);
+	remapped_regs = NULL;
 	iounmap(remapped_fbuf);
+	remapped_fbuf = NULL;
 
 	framebuffer_release(info);
 
diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 259525c3382a..9b9870ba01cd 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -690,16 +690,20 @@ static ssize_t w1_seq_show(struct device *device,
 		if (sl->reg_num.id == reg_num->id)
 			seq = i;
 
+		if (w1_reset_bus(sl->master))
+			goto error;
+
+		/* Put the device into chain DONE state */
+		w1_write_8(sl->master, W1_MATCH_ROM);
+		w1_write_block(sl->master, (u8 *)&rn, 8);
 		w1_write_8(sl->master, W1_42_CHAIN);
 		w1_write_8(sl->master, W1_42_CHAIN_DONE);
 		w1_write_8(sl->master, W1_42_CHAIN_DONE_INV);
-		w1_read_block(sl->master, &ack, sizeof(ack));
 
 		/* check for acknowledgment */
 		ack = w1_read_8(sl->master);
 		if (ack != W1_42_SUCCESS_CONFIRM_BYTE)
 			goto error;
-
 	}
 
 	/* Exit from CHAIN state */
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 90c5095ae97e..c8945be9f63a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -210,7 +210,7 @@ struct extent_buffer {
  */
 struct extent_changeset {
 	/* How many bytes are set/cleared in this operation */
-	unsigned int bytes_changed;
+	u64 bytes_changed;
 
 	/* Changed ranges */
 	struct ulist range_changed;
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 9451a7f6893d..a89b8ff82040 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -97,6 +97,9 @@ parse_mf_symlink(const u8 *buf, unsigned int buf_len, unsigned int *_link_len,
 	if (rc != 1)
 		return -EINVAL;
 
+	if (link_len > CIFS_MF_SYMLINK_LINK_MAXLEN)
+		return -EINVAL;
+
 	rc = symlink_hash(link_len, link_str, md5_hash);
 	if (rc) {
 		cifs_dbg(FYI, "%s: MD5 hash failure: %d\n", __func__, rc);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 4a338576ebb1..f3d55f1c0ce4 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -773,8 +773,12 @@ static loff_t ext2_max_size(int bits)
 	res += 1LL << (bits-2);
 	res += 1LL << (2*(bits-2));
 	res += 1LL << (3*(bits-2));
+	/* Compute how many metadata blocks are needed */
+	meta_blocks = 1;
+	meta_blocks += 1 + ppb;
+	meta_blocks += 1 + ppb + ppb * ppb;
 	/* Does block tree limit file size? */
-	if (res < upper_limit)
+	if (res + meta_blocks <= upper_limit)
 		goto check_lfs;
 
 	res = upper_limit;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9c07c8674b21..4d3eefff3c84 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2147,6 +2147,15 @@ static int ext4_writepage(struct page *page,
 	else
 		len = PAGE_SIZE;
 
+	/* Should never happen but for bugs in other kernel subsystems */
+	if (!page_has_buffers(page)) {
+		ext4_warning_inode(inode,
+		   "page %lu does not have buffers attached", page->index);
+		ClearPageDirty(page);
+		unlock_page(page);
+		return 0;
+	}
+
 	page_bufs = page_buffers(page);
 	/*
 	 * We cannot do block allocation or other extent handling in this
@@ -2706,6 +2715,22 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			wait_on_page_writeback(page);
 			BUG_ON(PageWriteback(page));
 
+			/*
+			 * Should never happen but for buggy code in
+			 * other subsystems that call
+			 * set_page_dirty() without properly warning
+			 * the file system first.  See [1] for more
+			 * information.
+			 *
+			 * [1] https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz
+			 */
+			if (!page_has_buffers(page)) {
+				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", page->index);
+				ClearPageDirty(page);
+				unlock_page(page);
+				continue;
+			}
+
 			if (mpd->map.m_len == 0)
 				mpd->first_page = page->index;
 			mpd->next_page = page->index + 1;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index db7d746633cf..1c98b5b7bead 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -991,7 +991,17 @@ static int fuse_copy_page(struct fuse_copy_state *cs, struct page **pagep,
 
 	while (count) {
 		if (cs->write && cs->pipebufs && page) {
-			return fuse_ref_page(cs, page, offset, count);
+			/*
+			 * Can't control lifetime of pipe buffers, so always
+			 * copy user pages.
+			 */
+			if (cs->req->user_pages) {
+				err = fuse_copy_fill(cs);
+				if (err)
+					return err;
+			} else {
+				return fuse_ref_page(cs, page, offset, count);
+			}
 		} else if (!cs->len) {
 			if (cs->move_pages && page &&
 			    offset == 0 && count == PAGE_SIZE) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 5f5da2911cea..a32b2ca3de6f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1325,6 +1325,7 @@ static int fuse_get_user_pages(struct fuse_req *req, struct iov_iter *ii,
 			(PAGE_SIZE - ret) & (PAGE_SIZE - 1);
 	}
 
+	req->user_pages = true;
 	if (write)
 		req->in.argpages = 1;
 	else
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index fac1f08dd32e..30fdede2ea64 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -312,6 +312,8 @@ struct fuse_req {
 	/** refcount */
 	refcount_t count;
 
+	bool user_pages;
+
 	/** Unique ID for the interrupt request */
 	u64 intr_unique;
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 87656030ec7d..f4a26759ca38 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1380,7 +1380,8 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 
 	start = r.start >> bs_shift;
 	end = start + (r.len >> bs_shift);
-	minlen = max_t(u64, r.minlen,
+	minlen = max_t(u64, r.minlen, sdp->sd_sb.sb_bsize);
+	minlen = max_t(u64, minlen,
 		       q->limits.discard_granularity) >> bs_shift;
 
 	if (end <= start || minlen > sdp->sd_max_rg_data)
diff --git a/fs/jffs2/build.c b/fs/jffs2/build.c
index b288c8ae1236..837cd55fd4c5 100644
--- a/fs/jffs2/build.c
+++ b/fs/jffs2/build.c
@@ -415,13 +415,15 @@ int jffs2_do_mount_fs(struct jffs2_sb_info *c)
 		jffs2_free_ino_caches(c);
 		jffs2_free_raw_node_refs(c);
 		ret = -EIO;
-		goto out_free;
+		goto out_sum_exit;
 	}
 
 	jffs2_calc_trigger_levels(c);
 
 	return 0;
 
+ out_sum_exit:
+	jffs2_sum_exit(c);
  out_free:
 	kvfree(c->blocks);
 
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 3c96f4bdc549..b7df9e34ccfd 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -597,8 +597,8 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 	jffs2_free_ino_caches(c);
 	jffs2_free_raw_node_refs(c);
 	kvfree(c->blocks);
- out_inohash:
 	jffs2_clear_xattr_subsystem(c);
+ out_inohash:
 	kfree(c->inocache_list);
  out_wbuf:
 	jffs2_flash_cleanup(c);
diff --git a/fs/jffs2/scan.c b/fs/jffs2/scan.c
index 08813789fcf0..664384dac6e5 100644
--- a/fs/jffs2/scan.c
+++ b/fs/jffs2/scan.c
@@ -136,7 +136,7 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 		if (!s) {
 			JFFS2_WARNING("Can't allocate memory for summary\n");
 			ret = -ENOMEM;
-			goto out;
+			goto out_buf;
 		}
 	}
 
@@ -274,13 +274,15 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 	}
 	ret = 0;
  out:
+	jffs2_sum_reset_collected(s);
+	kfree(s);
+ out_buf:
 	if (buf_size)
 		kfree(flashbuf);
 #ifndef __ECOS
 	else
 		mtd_unpoint(c->mtd, 0, c->mtd->size);
 #endif
-	kfree(s);
 	return ret;
 }
 
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 87b41edc800d..68779cc3609a 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -156,12 +156,13 @@ void jfs_evict_inode(struct inode *inode)
 		dquot_initialize(inode);
 
 		if (JFS_IP(inode)->fileset == FILESYSTEM_I) {
+			struct inode *ipimap = JFS_SBI(inode->i_sb)->ipimap;
 			truncate_inode_pages_final(&inode->i_data);
 
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
 
-			if (JFS_SBI(inode->i_sb)->ipimap)
+			if (ipimap && JFS_IP(ipimap)->i_imap)
 				diFree(inode);
 
 			/*
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 9ff510a489cb..6dac48e29d28 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -161,6 +161,7 @@ static const s8 budtab[256] = {
  *	0	- success
  *	-ENOMEM	- insufficient memory
  *	-EIO	- i/o error
+ *	-EINVAL - wrong bmap data
  */
 int dbMount(struct inode *ipbmap)
 {
@@ -192,6 +193,12 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_nfree = le64_to_cpu(dbmp_le->dn_nfree);
 	bmp->db_l2nbperpage = le32_to_cpu(dbmp_le->dn_l2nbperpage);
 	bmp->db_numag = le32_to_cpu(dbmp_le->dn_numag);
+	if (!bmp->db_numag) {
+		release_metapage(mp);
+		kfree(bmp);
+		return -EINVAL;
+	}
+
 	bmp->db_maxlevel = le32_to_cpu(dbmp_le->dn_maxlevel);
 	bmp->db_maxag = le32_to_cpu(dbmp_le->dn_maxag);
 	bmp->db_agpref = le32_to_cpu(dbmp_le->dn_agpref);
diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index 3998b432e1b9..825b3166605d 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -355,12 +355,11 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
 				  struct cb_process_state *cps)
 {
 	struct cb_devicenotifyargs *args = argp;
+	const struct pnfs_layoutdriver_type *ld = NULL;
 	uint32_t i;
 	__be32 res = 0;
-	struct nfs_client *clp = cps->clp;
-	struct nfs_server *server = NULL;
 
-	if (!clp) {
+	if (!cps->clp) {
 		res = cpu_to_be32(NFS4ERR_OP_NOT_IN_SESSION);
 		goto out;
 	}
@@ -368,23 +367,15 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
 	for (i = 0; i < args->ndevs; i++) {
 		struct cb_devicenotifyitem *dev = &args->devs[i];
 
-		if (!server ||
-		    server->pnfs_curr_ld->id != dev->cbd_layout_type) {
-			rcu_read_lock();
-			list_for_each_entry_rcu(server, &clp->cl_superblocks, client_link)
-				if (server->pnfs_curr_ld &&
-				    server->pnfs_curr_ld->id == dev->cbd_layout_type) {
-					rcu_read_unlock();
-					goto found;
-				}
-			rcu_read_unlock();
-			continue;
+		if (!ld || ld->id != dev->cbd_layout_type) {
+			pnfs_put_layoutdriver(ld);
+			ld = pnfs_find_layoutdriver(dev->cbd_layout_type);
+			if (!ld)
+				continue;
 		}
-
-	found:
-		nfs4_delete_deviceid(server->pnfs_curr_ld, clp, &dev->cbd_dev_id);
+		nfs4_delete_deviceid(ld, cps->clp, &dev->cbd_dev_id);
 	}
-
+	pnfs_put_layoutdriver(ld);
 out:
 	kfree(args->devs);
 	return res;
diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 36c34be839d0..737c37603fb1 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -278,10 +278,6 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 	n = ntohl(*p++);
 	if (n == 0)
 		goto out;
-	if (n > ULONG_MAX / sizeof(*args->devs)) {
-		status = htonl(NFS4ERR_BADXDR);
-		goto out;
-	}
 
 	args->devs = kmalloc_array(n, sizeof(*args->devs), GFP_KERNEL);
 	if (!args->devs) {
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index e6ea4511c41c..8acff8f6678e 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -288,8 +288,8 @@ ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	VM_BUG_ON(iov_iter_count(iter) != PAGE_SIZE);
 
 	if (iov_iter_rw(iter) == READ)
-		return nfs_file_direct_read(iocb, iter);
-	return nfs_file_direct_write(iocb, iter);
+		return nfs_file_direct_read(iocb, iter, true);
+	return nfs_file_direct_write(iocb, iter, true);
 }
 
 static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
@@ -553,6 +553,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
  * nfs_file_direct_read - file direct read operation for NFS files
  * @iocb: target I/O control block
  * @iter: vector of user buffers into which to read data
+ * @swap: flag indicating this is swap IO, not O_DIRECT IO
  *
  * We use this function for direct reads instead of calling
  * generic_file_aio_read() in order to avoid gfar's check to see if
@@ -568,7 +569,8 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
  * client must read the updated atime from the server back into its
  * cache.
  */
-ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter)
+ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
+			     bool swap)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -610,12 +612,14 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter)
 	if (iter_is_iovec(iter))
 		dreq->flags = NFS_ODIRECT_SHOULD_DIRTY;
 
-	nfs_start_io_direct(inode);
+	if (!swap)
+		nfs_start_io_direct(inode);
 
 	NFS_I(inode)->read_io += count;
 	requested = nfs_direct_read_schedule_iovec(dreq, iter, iocb->ki_pos);
 
-	nfs_end_io_direct(inode);
+	if (!swap)
+		nfs_end_io_direct(inode);
 
 	if (requested > 0) {
 		result = nfs_direct_wait(dreq);
@@ -884,7 +888,7 @@ static const struct nfs_pgio_completion_ops nfs_direct_write_completion_ops = {
  */
 static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 					       struct iov_iter *iter,
-					       loff_t pos)
+					       loff_t pos, int ioflags)
 {
 	struct nfs_pageio_descriptor desc;
 	struct inode *inode = dreq->inode;
@@ -892,7 +896,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 	size_t requested_bytes = 0;
 	size_t wsize = max_t(size_t, NFS_SERVER(inode)->wsize, PAGE_SIZE);
 
-	nfs_pageio_init_write(&desc, inode, FLUSH_COND_STABLE, false,
+	nfs_pageio_init_write(&desc, inode, ioflags, false,
 			      &nfs_direct_write_completion_ops);
 	desc.pg_dreq = dreq;
 	get_dreq(dreq);
@@ -971,6 +975,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
  * nfs_file_direct_write - file direct write operation for NFS files
  * @iocb: target I/O control block
  * @iter: vector of user buffers from which to write data
+ * @swap: flag indicating this is swap IO, not O_DIRECT IO
  *
  * We use this function for direct writes instead of calling
  * generic_file_aio_write() in order to avoid taking the inode
@@ -987,7 +992,8 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
  * Note that O_APPEND is not supported for NFS direct writes, as there
  * is no atomic O_APPEND write facility in the NFS protocol.
  */
-ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
+ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter,
+			      bool swap)
 {
 	ssize_t result = -EINVAL, requested;
 	size_t count;
@@ -1001,7 +1007,11 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
 	dfprintk(FILE, "NFS: direct write(%pD2, %zd@%Ld)\n",
 		file, iov_iter_count(iter), (long long) iocb->ki_pos);
 
-	result = generic_write_checks(iocb, iter);
+	if (swap)
+		/* bypass generic checks */
+		result =  iov_iter_count(iter);
+	else
+		result = generic_write_checks(iocb, iter);
 	if (result <= 0)
 		return result;
 	count = result;
@@ -1031,16 +1041,22 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
 	if (!is_sync_kiocb(iocb))
 		dreq->iocb = iocb;
 
-	nfs_start_io_direct(inode);
+	if (swap) {
+		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos,
+							    FLUSH_STABLE);
+	} else {
+		nfs_start_io_direct(inode);
 
-	requested = nfs_direct_write_schedule_iovec(dreq, iter, pos);
+		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos,
+							    FLUSH_COND_STABLE);
 
-	if (mapping->nrpages) {
-		invalidate_inode_pages2_range(mapping,
-					      pos >> PAGE_SHIFT, end);
-	}
+		if (mapping->nrpages) {
+			invalidate_inode_pages2_range(mapping,
+						      pos >> PAGE_SHIFT, end);
+		}
 
-	nfs_end_io_direct(inode);
+		nfs_end_io_direct(inode);
+	}
 
 	if (requested > 0) {
 		result = nfs_direct_wait(dreq);
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 81cca49a8375..4d847fcbedcf 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -157,7 +157,7 @@ nfs_file_read(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t result;
 
 	if (iocb->ki_flags & IOCB_DIRECT)
-		return nfs_file_direct_read(iocb, to);
+		return nfs_file_direct_read(iocb, to, false);
 
 	dprintk("NFS: read(%pD2, %zu@%lu)\n",
 		iocb->ki_filp,
@@ -606,7 +606,7 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 		return result;
 
 	if (iocb->ki_flags & IOCB_DIRECT)
-		return nfs_file_direct_write(iocb, from);
+		return nfs_file_direct_write(iocb, from, false);
 
 	dprintk("NFS: write(%pD2, %zu@%Ld)\n",
 		file, iov_iter_count(from), (long long) iocb->ki_pos);
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 619fc5c4c82c..18bbdaefd940 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -91,6 +91,17 @@ find_pnfs_driver(u32 id)
 	return local;
 }
 
+const struct pnfs_layoutdriver_type *pnfs_find_layoutdriver(u32 id)
+{
+	return find_pnfs_driver(id);
+}
+
+void pnfs_put_layoutdriver(const struct pnfs_layoutdriver_type *ld)
+{
+	if (ld)
+		module_put(ld->owner);
+}
+
 void
 unset_pnfs_layoutdriver(struct nfs_server *nfss)
 {
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 965d657086c8..3504826c1ee7 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -219,6 +219,8 @@ struct pnfs_devicelist {
 
 extern int pnfs_register_layoutdriver(struct pnfs_layoutdriver_type *);
 extern void pnfs_unregister_layoutdriver(struct pnfs_layoutdriver_type *);
+extern const struct pnfs_layoutdriver_type *pnfs_find_layoutdriver(u32 id);
+extern void pnfs_put_layoutdriver(const struct pnfs_layoutdriver_type *ld);
 
 /* nfs4proc.c */
 extern int nfs4_proc_getdeviceinfo(struct nfs_server *server,
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index fc6282181a1f..65d1aae9bfde 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -227,7 +227,7 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 	__be32	nfserr;
 	unsigned long cnt = argp->len;
 
-	dprintk("nfsd: WRITE    %s %d bytes at %d\n",
+	dprintk("nfsd: WRITE    %s %u bytes at %d\n",
 		SVCFH_fmt(&argp->fh),
 		argp->len, argp->offset);
 
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index 2f4f22e6b8cb..046454a62156 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -33,7 +33,7 @@ struct nfsd_readargs {
 struct nfsd_writeargs {
 	svc_fh			fh;
 	__u32			offset;
-	int			len;
+	__u32			len;
 	int			vlen;
 };
 
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 8cd134750ebb..4150b3633f77 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1915,6 +1915,10 @@ int ntfs_read_inode_mount(struct inode *vi)
 		}
 		/* Now allocate memory for the attribute list. */
 		ni->attr_list_size = (u32)ntfs_attr_size(a);
+		if (!ni->attr_list_size) {
+			ntfs_error(sb, "Attr_list_size is zero");
+			goto put_err_out;
+		}
 		ni->attr_list = ntfs_malloc_nofs(ni->attr_list_size);
 		if (!ni->attr_list) {
 			ntfs_error(sb, "Not enough memory to allocate buffer "
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index de0d63a347ac..299611052bbf 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -390,15 +390,18 @@ static int do_tmpfile(struct inode *dir, struct dentry *dentry,
 {
 	struct inode *inode;
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
-	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1};
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
+					.dirtied_ino = 1};
 	struct ubifs_budget_req ino_req = { .dirtied_ino = 1 };
 	struct ubifs_inode *ui, *dir_ui = ubifs_inode(dir);
 	int err, instantiated = 0;
 	struct fscrypt_name nm;
 
 	/*
-	 * Budget request settings: new dirty inode, new direntry,
-	 * budget for dirtied inode will be released via writeback.
+	 * Budget request settings: new inode, new direntry, changing the
+	 * parent directory inode.
+	 * Allocate budget separately for new dirtied inode, the budget will
+	 * be released via writeback.
 	 */
 
 	dbg_gen("dent '%pd', mode %#hx in dir ino %lu",
@@ -468,6 +471,8 @@ static int do_tmpfile(struct inode *dir, struct dentry *dentry,
 	make_bad_inode(inode);
 	if (!instantiated)
 		iput(inode);
+	else if (whiteout)
+		iput(*whiteout);
 out_budg:
 	ubifs_release_budget(c, &req);
 	if (!instantiated)
@@ -988,7 +993,8 @@ static int ubifs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct ubifs_inode *dir_ui = ubifs_inode(dir);
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
 	int err, sz_change;
-	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1 };
+	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
+					.dirtied_ino = 1};
 	struct fscrypt_name nm;
 
 	/*
@@ -1450,6 +1456,9 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 			if (unlink)
 				drop_nlink(old_dir);
 		}
+
+		/* Add the old_dentry size to the old_dir size. */
+		old_sz -= CALC_DENT_SIZE(fname_len(&old_nm));
 	}
 
 	old_dir->i_size -= old_sz;
@@ -1496,8 +1505,6 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 		err = ubifs_budget_space(c, &wht_req);
 		if (err) {
-			kfree(whiteout_ui->data);
-			whiteout_ui->data_len = 0;
 			iput(whiteout);
 			goto out_release;
 		}
diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
index 1f6d16105990..ae05bca197bd 100644
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -110,7 +110,7 @@ static int setflags(struct inode *inode, int flags)
 	struct ubifs_inode *ui = ubifs_inode(inode);
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	struct ubifs_budget_req req = { .dirtied_ino = 1,
-					.dirtied_ino_d = ui->data_len };
+			.dirtied_ino_d = ALIGN(ui->data_len, 8) };
 
 	err = ubifs_budget_space(c, &req);
 	if (err)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1c3d774d3c83..afbe2fcc476a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -56,6 +56,14 @@ struct blk_stat_callback;
  */
 #define BLKCG_MAX_POLS		3
 
+static inline int blk_validate_block_size(unsigned int bsize)
+{
+	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
+		return -EINVAL;
+
+	return 0;
+}
+
 typedef void (rq_end_io_fn)(struct request *, blk_status_t);
 
 #define BLK_RL_SYNCFULL		(1U << 0)
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f679f5268467..3727053d13fc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1160,13 +1160,16 @@ extern struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT];
 
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
+	unsigned long root = SECTION_NR_TO_ROOT(nr);
+
+	if (unlikely(root >= NR_SECTION_ROOTS))
+		return NULL;
+
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (!mem_section)
+	if (!mem_section || !mem_section[root])
 		return NULL;
 #endif
-	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
-		return NULL;
-	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
+	return &mem_section[root][nr & SECTION_ROOT_MASK];
 }
 extern int __section_nr(struct mem_section* ms);
 extern unsigned long usemap_size(void);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7972aac9264c..1edc2af51e03 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3378,7 +3378,8 @@ void netdev_run_todo(void);
  */
 static inline void dev_put(struct net_device *dev)
 {
-	this_cpu_dec(*dev->pcpu_refcnt);
+	if (dev)
+		this_cpu_dec(*dev->pcpu_refcnt);
 }
 
 /**
@@ -3389,7 +3390,8 @@ static inline void dev_put(struct net_device *dev)
  */
 static inline void dev_hold(struct net_device *dev)
 {
-	this_cpu_inc(*dev->pcpu_refcnt);
+	if (dev)
+		this_cpu_inc(*dev->pcpu_refcnt);
 }
 
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index e51292d9e1a2..b32347453679 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -442,10 +442,10 @@ static inline struct rpc_cred *nfs_file_cred(struct file *file)
  * linux/fs/nfs/direct.c
  */
 extern ssize_t nfs_direct_IO(struct kiocb *, struct iov_iter *);
-extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
-			struct iov_iter *iter);
-extern ssize_t nfs_file_direct_write(struct kiocb *iocb,
-			struct iov_iter *iter);
+ssize_t nfs_file_direct_read(struct kiocb *iocb,
+			     struct iov_iter *iter, bool swap);
+ssize_t nfs_file_direct_write(struct kiocb *iocb,
+			      struct iov_iter *iter, bool swap);
 
 /*
  * linux/fs/nfs/dir.c
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 66c0d5fad0cb..521030233c8d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -569,6 +569,7 @@ struct pci_bus {
 	struct bin_attribute	*legacy_io; /* legacy I/O for this bus */
 	struct bin_attribute	*legacy_mem; /* legacy mem */
 	unsigned int		is_added:1;
+	unsigned int		unsafe_warn:1;	/* warned about RW1C config write */
 };
 
 #define to_pci_bus(n)	container_of(n, struct pci_bus, dev)
diff --git a/include/net/sock.h b/include/net/sock.h
index f72753391acc..f729ccfe756a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2311,22 +2311,39 @@ static inline void sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
 void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags);
 
 /**
- * sock_tx_timestamp - checks whether the outgoing packet is to be time stamped
+ * _sock_tx_timestamp - checks whether the outgoing packet is to be time stamped
  * @sk:		socket sending this packet
  * @tsflags:	timestamping flags to use
  * @tx_flags:	completed with instructions for time stamping
+ * @tskey:      filled in with next sk_tskey (not for TCP, which uses seqno)
  *
  * Note: callers should take care of initial ``*tx_flags`` value (usually 0)
  */
-static inline void sock_tx_timestamp(const struct sock *sk, __u16 tsflags,
-				     __u8 *tx_flags)
+static inline void _sock_tx_timestamp(struct sock *sk, __u16 tsflags,
+				      __u8 *tx_flags, __u32 *tskey)
 {
-	if (unlikely(tsflags))
+	if (unlikely(tsflags)) {
 		__sock_tx_timestamp(tsflags, tx_flags);
+		if (tsflags & SOF_TIMESTAMPING_OPT_ID && tskey &&
+		    tsflags & SOF_TIMESTAMPING_TX_RECORD_MASK)
+			*tskey = sk->sk_tskey++;
+	}
 	if (unlikely(sock_flag(sk, SOCK_WIFI_STATUS)))
 		*tx_flags |= SKBTX_WIFI_STATUS;
 }
 
+static inline void sock_tx_timestamp(struct sock *sk, __u16 tsflags,
+				     __u8 *tx_flags)
+{
+	_sock_tx_timestamp(sk, tsflags, tx_flags, NULL);
+}
+
+static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
+{
+	_sock_tx_timestamp(skb->sk, tsflags, &skb_shinfo(skb)->tx_flags,
+			   &skb_shinfo(skb)->tskey);
+}
+
 /**
  * sk_eat_skb - Release a skb if it is no longer needed
  * @sk: socket to eat this skb from
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 86ff11157449..fe45e5ab2601 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1674,13 +1674,16 @@ int xfrm_policy_walk(struct net *net, struct xfrm_policy_walk *walk,
 		     void *);
 void xfrm_policy_walk_done(struct xfrm_policy_walk *walk, struct net *net);
 int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl);
-struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark,
+struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net,
+					  const struct xfrm_mark *mark,
 					  u8 type, int dir,
 					  struct xfrm_selector *sel,
 					  struct xfrm_sec_ctx *ctx, int delete,
 					  int *err);
-struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u8, int dir,
-				     u32 id, int delete, int *err);
+struct xfrm_policy *xfrm_policy_byid(struct net *net,
+				     const struct xfrm_mark *mark,
+				     u8 type, int dir, u32 id, int delete,
+				     int *err);
 int xfrm_policy_flush(struct net *net, u8 type, bool task_valid);
 void xfrm_policy_hash_rebuild(struct net *net);
 u32 xfrm_get_acqseq(void);
diff --git a/init/main.c b/init/main.c
index f0b2411a5fbf..621cedd9173a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -749,7 +749,7 @@ static int __init initcall_blacklist(char *str)
 		}
 	} while (str_entry);
 
-	return 0;
+	return 1;
 }
 
 static bool __init_or_module initcall_blacklisted(initcall_t fn)
@@ -965,7 +965,9 @@ static noinline void __init kernel_init_freeable(void);
 bool rodata_enabled __ro_after_init = true;
 static int __init set_debug_rodata(char *str)
 {
-	return strtobool(str, &rodata_enabled);
+	if (strtobool(str, &rodata_enabled))
+		pr_warn("Invalid option string for rodata: '%s'\n", str);
+	return 1;
 }
 __setup("rodata=", set_debug_rodata);
 #endif
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index bf54ade001be..421c01590cb5 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -8,6 +8,25 @@
 #include <linux/list.h>
 #include <linux/refcount.h>
 
+struct cgroup_pidlist;
+
+struct cgroup_file_ctx {
+	struct cgroup_namespace	*ns;
+
+	struct {
+		void			*trigger;
+	} psi;
+
+	struct {
+		bool			started;
+		struct css_task_iter	iter;
+	} procs;
+
+	struct {
+		struct cgroup_pidlist	*pidlist;
+	} procs1;
+};
+
 /*
  * A cgroup can be associated with multiple css_sets as different tasks may
  * belong to different cgroups on different hierarchies.  In the other
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 105f5b2f5978..a14182e90f57 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -426,6 +426,7 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 	 * next pid to display, if any
 	 */
 	struct kernfs_open_file *of = s->private;
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
 	struct cgroup_pidlist *l;
 	enum cgroup_filetype type = seq_cft(s)->private;
@@ -435,25 +436,24 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 	mutex_lock(&cgrp->pidlist_mutex);
 
 	/*
-	 * !NULL @of->priv indicates that this isn't the first start()
-	 * after open.  If the matching pidlist is around, we can use that.
-	 * Look for it.  Note that @of->priv can't be used directly.  It
-	 * could already have been destroyed.
+	 * !NULL @ctx->procs1.pidlist indicates that this isn't the first
+	 * start() after open. If the matching pidlist is around, we can use
+	 * that. Look for it. Note that @ctx->procs1.pidlist can't be used
+	 * directly. It could already have been destroyed.
 	 */
-	if (of->priv)
-		of->priv = cgroup_pidlist_find(cgrp, type);
+	if (ctx->procs1.pidlist)
+		ctx->procs1.pidlist = cgroup_pidlist_find(cgrp, type);
 
 	/*
 	 * Either this is the first start() after open or the matching
 	 * pidlist has been destroyed inbetween.  Create a new one.
 	 */
-	if (!of->priv) {
-		ret = pidlist_array_load(cgrp, type,
-					 (struct cgroup_pidlist **)&of->priv);
+	if (!ctx->procs1.pidlist) {
+		ret = pidlist_array_load(cgrp, type, &ctx->procs1.pidlist);
 		if (ret)
 			return ERR_PTR(ret);
 	}
-	l = of->priv;
+	l = ctx->procs1.pidlist;
 
 	if (pid) {
 		int end = l->length;
@@ -481,7 +481,8 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 static void cgroup_pidlist_stop(struct seq_file *s, void *v)
 {
 	struct kernfs_open_file *of = s->private;
-	struct cgroup_pidlist *l = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct cgroup_pidlist *l = ctx->procs1.pidlist;
 
 	if (l)
 		mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork,
@@ -492,7 +493,8 @@ static void cgroup_pidlist_stop(struct seq_file *s, void *v)
 static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kernfs_open_file *of = s->private;
-	struct cgroup_pidlist *l = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct cgroup_pidlist *l = ctx->procs1.pidlist;
 	pid_t *p = v;
 	pid_t *end = l->list + l->length;
 	/*
@@ -535,10 +537,11 @@ static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
 		goto out_unlock;
 
 	/*
-	 * Even if we're attaching all tasks in the thread group, we only
-	 * need to check permissions on one of them.
+	 * Even if we're attaching all tasks in the thread group, we only need
+	 * to check permissions on one of them. Check permissions using the
+	 * credentials from file open to protect against inherited fd attacks.
 	 */
-	cred = current_cred();
+	cred = of->file->f_cred;
 	tcred = get_task_cred(task);
 	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
 	    !uid_eq(cred->euid, tcred->uid) &&
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d5044ca33bd0..63d1349a17a3 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3364,24 +3364,43 @@ static int cgroup_stat_show(struct seq_file *seq, void *v)
 static int cgroup_file_open(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
+	struct cgroup_file_ctx *ctx;
+	int ret;
 
-	if (cft->open)
-		return cft->open(of);
-	return 0;
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->ns = current->nsproxy->cgroup_ns;
+	get_cgroup_ns(ctx->ns);
+	of->priv = ctx;
+
+	if (!cft->open)
+		return 0;
+
+	ret = cft->open(of);
+	if (ret) {
+		put_cgroup_ns(ctx->ns);
+		kfree(ctx);
+	}
+	return ret;
 }
 
 static void cgroup_file_release(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
 
 	if (cft->release)
 		cft->release(of);
+	put_cgroup_ns(ctx->ns);
+	kfree(ctx);
 }
 
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 				 size_t nbytes, loff_t off)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *cgrp = of->kn->parent->priv;
 	struct cftype *cft = of->kn->priv;
 	struct cgroup_subsys_state *css;
@@ -3395,7 +3414,7 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 	 */
 	if ((cgrp->root->flags & CGRP_ROOT_NS_DELEGATE) &&
 	    !(cft->flags & CFTYPE_NS_DELEGATABLE) &&
-	    ns != &init_cgroup_ns && ns->root_cset->dfl_cgrp == cgrp)
+	    ctx->ns != &init_cgroup_ns && ctx->ns->root_cset->dfl_cgrp == cgrp)
 		return -EPERM;
 
 	if (cft->write)
@@ -4270,21 +4289,21 @@ void css_task_iter_end(struct css_task_iter *it)
 
 static void cgroup_procs_release(struct kernfs_open_file *of)
 {
-	if (of->priv) {
-		css_task_iter_end(of->priv);
-		kfree(of->priv);
-	}
+	struct cgroup_file_ctx *ctx = of->priv;
+
+	if (ctx->procs.started)
+		css_task_iter_end(&ctx->procs.iter);
 }
 
 static void *cgroup_procs_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kernfs_open_file *of = s->private;
-	struct css_task_iter *it = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
 
 	if (pos)
 		(*pos)++;
 
-	return css_task_iter_next(it);
+	return css_task_iter_next(&ctx->procs.iter);
 }
 
 static void *__cgroup_procs_start(struct seq_file *s, loff_t *pos,
@@ -4292,21 +4311,18 @@ static void *__cgroup_procs_start(struct seq_file *s, loff_t *pos,
 {
 	struct kernfs_open_file *of = s->private;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
-	struct css_task_iter *it = of->priv;
+	struct cgroup_file_ctx *ctx = of->priv;
+	struct css_task_iter *it = &ctx->procs.iter;
 
 	/*
 	 * When a seq_file is seeked, it's always traversed sequentially
 	 * from position 0, so we can simply keep iterating on !0 *pos.
 	 */
-	if (!it) {
+	if (!ctx->procs.started) {
 		if (WARN_ON_ONCE((*pos)))
 			return ERR_PTR(-EINVAL);
-
-		it = kzalloc(sizeof(*it), GFP_KERNEL);
-		if (!it)
-			return ERR_PTR(-ENOMEM);
-		of->priv = it;
 		css_task_iter_start(&cgrp->self, iter_flags, it);
+		ctx->procs.started = true;
 	} else if (!(*pos)) {
 		css_task_iter_end(it);
 		css_task_iter_start(&cgrp->self, iter_flags, it);
@@ -4341,9 +4357,9 @@ static int cgroup_procs_show(struct seq_file *s, void *v)
 
 static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 					 struct cgroup *dst_cgrp,
-					 struct super_block *sb)
+					 struct super_block *sb,
+					 struct cgroup_namespace *ns)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup *com_cgrp = src_cgrp;
 	struct inode *inode;
 	int ret;
@@ -4379,8 +4395,10 @@ static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 				  char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	const struct cred *saved_cred;
 	ssize_t ret;
 
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
@@ -4397,8 +4415,16 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
 	spin_unlock_irq(&css_set_lock);
 
+	/*
+	 * Process and thread migrations follow same delegation rule. Check
+	 * permissions using the credentials from file open to protect against
+	 * inherited fd attacks.
+	 */
+	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
-					    of->file->f_path.dentry->d_sb);
+					    of->file->f_path.dentry->d_sb,
+					    ctx->ns);
+	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
 
@@ -4420,8 +4446,10 @@ static void *cgroup_threads_start(struct seq_file *s, loff_t *pos)
 static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
+	const struct cred *saved_cred;
 	ssize_t ret;
 
 	buf = strstrip(buf);
@@ -4440,9 +4468,16 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
 	spin_unlock_irq(&css_set_lock);
 
-	/* thread migrations follow the cgroup.procs delegation rule */
+	/*
+	 * Process and thread migrations follow same delegation rule. Check
+	 * permissions using the credentials from file open to protect against
+	 * inherited fd attacks.
+	 */
+	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
-					    of->file->f_path.dentry->d_sb);
+					    of->file->f_path.dentry->d_sb,
+					    ctx->ns);
+	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 54da9e12381f..0f49ab48cb14 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8641,8 +8641,11 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
 			}
 
 			/* ready to consume more filters */
+			kfree(filename);
+			filename = NULL;
 			state = IF_STATE_ACTION;
 			filter = NULL;
+			kernel = 0;
 		}
 	}
 
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index e68b1c20ad3d..f4ecb23c9194 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -1186,7 +1186,7 @@ static int __init resumedelay_setup(char *str)
 	int rc = kstrtouint(str, 0, &resume_delay);
 
 	if (rc)
-		return rc;
+		pr_warn("resumedelay: bad option string '%s'\n", str);
 	return 1;
 }
 
diff --git a/kernel/power/suspend_test.c b/kernel/power/suspend_test.c
index 6a897e8b2a88..3f6345d60256 100644
--- a/kernel/power/suspend_test.c
+++ b/kernel/power/suspend_test.c
@@ -158,22 +158,22 @@ static int __init setup_test_suspend(char *value)
 	value++;
 	suspend_type = strsep(&value, ",");
 	if (!suspend_type)
-		return 0;
+		return 1;
 
 	repeat = strsep(&value, ",");
 	if (repeat) {
 		if (kstrtou32(repeat, 0, &test_repeat_count_max))
-			return 0;
+			return 1;
 	}
 
 	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++)
 		if (!strcmp(pm_labels[i], suspend_type)) {
 			test_state_label = pm_labels[i];
-			return 0;
+			return 1;
 		}
 
 	printk(warn_bad_state, suspend_type);
-	return 0;
+	return 1;
 }
 __setup("test_suspend", setup_test_suspend);
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 31b5e7919d62..11173d0b51bc 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -125,8 +125,10 @@ static int __control_devkmsg(char *str)
 
 static int __init control_devkmsg(char *str)
 {
-	if (__control_devkmsg(str) < 0)
+	if (__control_devkmsg(str) < 0) {
+		pr_warn("printk.devkmsg: bad option string '%s'\n", str);
 		return 1;
+	}
 
 	/*
 	 * Set sysctl string accordingly:
@@ -148,7 +150,7 @@ static int __init control_devkmsg(char *str)
 	 */
 	devkmsg_log |= DEVKMSG_LOG_MASK_LOCK;
 
-	return 0;
+	return 1;
 }
 __setup("printk.devkmsg=", control_devkmsg);
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index b28f3c66c6fe..cf03de0a7cc6 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -370,6 +370,26 @@ bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 	return !err;
 }
 
+static int check_ptrace_options(unsigned long data)
+{
+	if (data & ~(unsigned long)PTRACE_O_MASK)
+		return -EINVAL;
+
+	if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
+		if (!IS_ENABLED(CONFIG_CHECKPOINT_RESTORE) ||
+		    !IS_ENABLED(CONFIG_SECCOMP))
+			return -EINVAL;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (seccomp_mode(&current->seccomp) != SECCOMP_MODE_DISABLED ||
+		    current->ptrace & PT_SUSPEND_SECCOMP)
+			return -EPERM;
+	}
+	return 0;
+}
+
 static int ptrace_attach(struct task_struct *task, long request,
 			 unsigned long addr,
 			 unsigned long flags)
@@ -381,8 +401,16 @@ static int ptrace_attach(struct task_struct *task, long request,
 	if (seize) {
 		if (addr != 0)
 			goto out;
+		/*
+		 * This duplicates the check in check_ptrace_options() because
+		 * ptrace_attach() and ptrace_setoptions() have historically
+		 * used different error codes for unknown ptrace options.
+		 */
 		if (flags & ~(unsigned long)PTRACE_O_MASK)
 			goto out;
+		retval = check_ptrace_options(flags);
+		if (retval)
+			return retval;
 		flags = PT_PTRACED | PT_SEIZED | (flags << PT_OPT_FLAG_SHIFT);
 	} else {
 		flags = PT_PTRACED;
@@ -655,22 +683,11 @@ int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long ds
 static int ptrace_setoptions(struct task_struct *child, unsigned long data)
 {
 	unsigned flags;
+	int ret;
 
-	if (data & ~(unsigned long)PTRACE_O_MASK)
-		return -EINVAL;
-
-	if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
-		if (!IS_ENABLED(CONFIG_CHECKPOINT_RESTORE) ||
-		    !IS_ENABLED(CONFIG_SECCOMP))
-			return -EINVAL;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (seccomp_mode(&current->seccomp) != SECCOMP_MODE_DISABLED ||
-		    current->ptrace & PT_SUSPEND_SECCOMP)
-			return -EPERM;
-	}
+	ret = check_ptrace_options(data);
+	if (ret)
+		return ret;
 
 	/* Avoid intermediate state when all opts are cleared */
 	flags = child->ptrace;
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 187c04a34ba1..053c480f5382 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -899,25 +899,15 @@ void print_numa_stats(struct seq_file *m, int node, unsigned long tsf,
 static void sched_show_numa(struct task_struct *p, struct seq_file *m)
 {
 #ifdef CONFIG_NUMA_BALANCING
-	struct mempolicy *pol;
-
 	if (p->mm)
 		P(mm->numa_scan_seq);
 
-	task_lock(p);
-	pol = p->mempolicy;
-	if (pol && !(pol->flags & MPOL_F_MORON))
-		pol = NULL;
-	mpol_get(pol);
-	task_unlock(p);
-
 	P(numa_pages_migrated);
 	P(numa_preferred_nid);
 	P(total_numa_faults);
 	SEQ_printf(m, "current_node=%d, numa_group_id=%d\n",
 			task_node(p), task_numa_group_id(p));
 	show_numa_stats(p, m);
-	mpol_put(pol);
 #endif
 }
 
diff --git a/kernel/smp.c b/kernel/smp.c
index f9d95d59b7ed..d519c792c9d5 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -221,7 +221,7 @@ static void flush_smp_call_function_queue(bool warn_cpu_offline)
 
 	/* There shouldn't be any pending callbacks on an offline CPU. */
 	if (unlikely(warn_cpu_offline && !cpu_online(smp_processor_id()) &&
-		     !warned && !llist_empty(head))) {
+		     !warned && entry != NULL)) {
 		warned = true;
 		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
 
diff --git a/lib/raid6/test/test.c b/lib/raid6/test/test.c
index b07f4d8e6b03..a7e937248299 100644
--- a/lib/raid6/test/test.c
+++ b/lib/raid6/test/test.c
@@ -22,7 +22,6 @@
 #define NDISKS		16	/* Including P and Q */
 
 const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-struct raid6_calls raid6_call;
 
 char *dataptrs[NDISKS];
 char data[NDISKS][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
diff --git a/lib/test_kmod.c b/lib/test_kmod.c
index c0ce0156d54b..74f8d386f85e 100644
--- a/lib/test_kmod.c
+++ b/lib/test_kmod.c
@@ -1162,6 +1162,7 @@ static struct kmod_test_device *register_test_dev_kmod(void)
 	if (ret) {
 		pr_err("could not register misc device: %d\n", ret);
 		free_test_dev_kmod(test_dev);
+		test_dev = NULL;
 		goto out;
 	}
 
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 0b842160168b..d279d8be0dca 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1192,7 +1192,7 @@ EXPORT_SYMBOL(kmemleak_no_scan);
 void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
 			       gfp_t gfp)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_alloc(__va(phys), size, min_count, gfp);
 }
 EXPORT_SYMBOL(kmemleak_alloc_phys);
@@ -1203,7 +1203,7 @@ EXPORT_SYMBOL(kmemleak_alloc_phys);
  */
 void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_free_part(__va(phys), size);
 }
 EXPORT_SYMBOL(kmemleak_free_part_phys);
@@ -1214,7 +1214,7 @@ EXPORT_SYMBOL(kmemleak_free_part_phys);
  */
 void __ref kmemleak_not_leak_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_not_leak(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_not_leak_phys);
@@ -1225,7 +1225,7 @@ EXPORT_SYMBOL(kmemleak_not_leak_phys);
  */
 void __ref kmemleak_ignore_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_ignore(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_ignore_phys);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5e8b8e1b7d90..637e1eb59a0b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5978,7 +5978,7 @@ static int __init cgroup_memory(char *s)
 		if (!strcmp(token, "nokmem"))
 			cgroup_memory_nokmem = true;
 	}
-	return 0;
+	return 1;
 }
 __setup("cgroup.memory=", cgroup_memory);
 
diff --git a/mm/memory.c b/mm/memory.c
index b001670c9615..cec495ecffae 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1306,6 +1306,17 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	return ret;
 }
 
+/* Whether we should zap all COWed (private) pages too */
+static inline bool should_zap_cows(struct zap_details *details)
+{
+	/* By default, zap all pages */
+	if (!details)
+		return true;
+
+	/* Or, we zap COWed pages only if the caller wants to */
+	return !details->check_mapping;
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -1394,17 +1405,19 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 			continue;
 		}
 
-		/* If details->check_mapping, we leave swap entries. */
-		if (unlikely(details))
-			continue;
-
 		entry = pte_to_swp_entry(ptent);
-		if (!non_swap_entry(entry))
+		if (!non_swap_entry(entry)) {
+			/* Genuine swap entry, hence a private anon page */
+			if (!should_zap_cows(details))
+				continue;
 			rss[MM_SWAPENTS]--;
-		else if (is_migration_entry(entry)) {
+		} else if (is_migration_entry(entry)) {
 			struct page *page;
 
 			page = migration_entry_to_page(entry);
+			if (details && details->check_mapping &&
+			    details->check_mapping != page_rmapping(page))
+				continue;
 			rss[mm_counter(page)]--;
 		}
 		if (unlikely(!free_swap_and_cache(entry)))
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e30d23943d5..5a6bfadef40e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -727,7 +727,6 @@ static int vma_replace_policy(struct vm_area_struct *vma,
 static int mbind_range(struct mm_struct *mm, unsigned long start,
 		       unsigned long end, struct mempolicy *new_pol)
 {
-	struct vm_area_struct *next;
 	struct vm_area_struct *prev;
 	struct vm_area_struct *vma;
 	int err = 0;
@@ -743,8 +742,7 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 	if (start > vma->vm_start)
 		prev = vma;
 
-	for (; vma && vma->vm_start < end; prev = vma, vma = next) {
-		next = vma->vm_next;
+	for (; vma && vma->vm_start < end; prev = vma, vma = vma->vm_next) {
 		vmstart = max(start, vma->vm_start);
 		vmend   = min(end, vma->vm_end);
 
@@ -758,10 +756,6 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
 				 new_pol, vma->vm_userfaultfd_ctx);
 		if (prev) {
 			vma = prev;
-			next = vma->vm_next;
-			if (mpol_equal(vma_policy(vma), new_pol))
-				continue;
-			/* vma_merge() joined vma && vma->next, case 8 */
 			goto replace;
 		}
 		if (vma->vm_start != vmstart) {
@@ -2485,6 +2479,7 @@ static int shared_policy_replace(struct shared_policy *sp, unsigned long start,
 	mpol_new = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!mpol_new)
 		goto err_out;
+	atomic_set(&mpol_new->refcnt, 1);
 	goto restart;
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index c389fd258384..64d1d133af79 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2426,7 +2426,7 @@ static int __init cmdline_parse_stack_guard_gap(char *p)
 	if (!*endptr)
 		stack_guard_gap = val << PAGE_SHIFT;
 
-	return 0;
+	return 1;
 }
 __setup("stack_guard_gap=", cmdline_parse_stack_guard_gap);
 
diff --git a/mm/mremap.c b/mm/mremap.c
index 3c7fcd5d5794..2bdb255cde9a 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -203,6 +203,9 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 
+	if (!len)
+		return 0;
+
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9c467ac4b72d..e3d205f2a3ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4879,7 +4879,7 @@ static int build_zonerefs_node(pg_data_t *pgdat, struct zoneref *zonerefs)
 	do {
 		zone_type--;
 		zone = pgdat->node_zones + zone_type;
-		if (managed_zone(zone)) {
+		if (populated_zone(zone)) {
 			zoneref_set_zone(zone, &zonerefs[nr_zones++]);
 			check_highest_zone(zone_type);
 		}
@@ -6502,10 +6502,17 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 
 out2:
 	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
-	for (nid = 0; nid < MAX_NUMNODES; nid++)
+	for (nid = 0; nid < MAX_NUMNODES; nid++) {
+		unsigned long start_pfn, end_pfn;
+
 		zone_movable_pfn[nid] =
 			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
 
+		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+		if (zone_movable_pfn[nid] >= end_pfn)
+			zone_movable_pfn[nid] = 0;
+	}
+
 out:
 	/* restore the node_state */
 	node_states[N_MEMORY] = saved_node_state;
diff --git a/mm/rmap.c b/mm/rmap.c
index 8ed8ec113d5a..65de683e7f7c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1564,7 +1564,30 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 
 			/* MADV_FREE page check */
 			if (!PageSwapBacked(page)) {
-				if (!PageDirty(page)) {
+				int ref_count, map_count;
+
+				/*
+				 * Synchronize with gup_pte_range():
+				 * - clear PTE; barrier; read refcount
+				 * - inc refcount; barrier; read PTE
+				 */
+				smp_mb();
+
+				ref_count = page_ref_count(page);
+				map_count = page_mapcount(page);
+
+				/*
+				 * Order reads for page refcount and dirty flag
+				 * (see comments in __remove_mapping()).
+				 */
+				smp_rmb();
+
+				/*
+				 * The only page refs must be one from isolation
+				 * plus the rmap(s) (dropped by discard:).
+				 */
+				if (ref_count == 1 + map_count &&
+				    !PageDirty(page)) {
 					dec_mm_counter(mm, MM_ANONPAGES);
 					goto discard;
 				}
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 39e222fb3004..4eeba9dfb38f 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4470,8 +4470,9 @@ static void hci_disconn_phylink_complete_evt(struct hci_dev *hdev,
 	hci_dev_lock(hdev);
 
 	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
-	if (hcon) {
+	if (hcon && hcon->type == AMP_LINK) {
 		hcon->state = BT_CLOSED;
+		hci_disconn_cfm(hcon, ev->reason);
 		hci_conn_del(hcon);
 	}
 
diff --git a/net/can/raw.c b/net/can/raw.c
index 2a987a6ea6d7..bda2113a8529 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -814,7 +814,7 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (err < 0)
 		goto free_skb;
 
-	sock_tx_timestamp(sk, sk->sk_tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sk->sk_tsflags);
 
 	skb->dev = dev;
 	skb->sk  = sk;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 9c4b2c0dc68a..19a6ec2adc6c 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -390,7 +390,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 99ab936a9cd3..83c0e859bb33 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3419,6 +3419,7 @@ static void tcp_connect_queue_skb(struct sock *sk, struct sk_buff *skb)
  */
 static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_fastopen_request *fo = tp->fastopen_req;
 	int space, err = 0;
@@ -3433,8 +3434,10 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 	 * private TCP options. The cost is reduced data space in SYN :(
 	 */
 	tp->rx_opt.mss_clamp = tcp_mss_clamp(tp, tp->rx_opt.mss_clamp);
+	/* Sync mss_cache after updating the mss_clamp */
+	tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
 
-	space = __tcp_mtu_to_mss(sk, inet_csk(sk)->icsk_pmtu_cookie) -
+	space = __tcp_mtu_to_mss(sk, icsk->icsk_pmtu_cookie) -
 		MAX_TCP_OPTION_SPACE;
 
 	space = min_t(size_t, space, fo->size);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 3d9d20074203..e8926ebfe74c 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -622,7 +622,7 @@ static int rawv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 
 static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 			struct flowi6 *fl6, struct dst_entry **dstp,
-			unsigned int flags)
+			unsigned int flags, const struct sockcm_cookie *sockc)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct net *net = sock_net(sk);
@@ -659,6 +659,8 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
+
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
 
@@ -945,7 +947,8 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 back_from_confirm:
 	if (hdrincl)
-		err = rawv6_send_hdrinc(sk, msg, len, &fl6, &dst, msg->msg_flags);
+		err = rawv6_send_hdrinc(sk, msg, len, &fl6, &dst,
+					msg->msg_flags, &sockc);
 	else {
 		ipc6.opt = opt;
 		lock_sock(sk);
diff --git a/net/key/af_key.c b/net/key/af_key.c
index a10336cd7f97..d7adac31b0fd 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1709,7 +1709,7 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
 
 	xfrm_probe_algs();
 
-	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL);
+	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);
 	if (!supp_skb) {
 		if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
 			pfk->registered &= ~(1<<hdr->sadb_msg_satype);
@@ -2411,7 +2411,7 @@ static int pfkey_spddelete(struct sock *sk, struct sk_buff *skb, const struct sa
 			return err;
 	}
 
-	xp = xfrm_policy_bysel_ctx(net, DUMMY_MARK, XFRM_POLICY_TYPE_MAIN,
+	xp = xfrm_policy_bysel_ctx(net, &dummy_mark, XFRM_POLICY_TYPE_MAIN,
 				   pol->sadb_x_policy_dir - 1, &sel, pol_ctx,
 				   1, &err);
 	security_xfrm_policy_free(pol_ctx);
@@ -2662,7 +2662,7 @@ static int pfkey_spdget(struct sock *sk, struct sk_buff *skb, const struct sadb_
 		return -EINVAL;
 
 	delete = (hdr->sadb_msg_type == SADB_X_SPDDELETE2);
-	xp = xfrm_policy_byid(net, DUMMY_MARK, XFRM_POLICY_TYPE_MAIN,
+	xp = xfrm_policy_byid(net, &dummy_mark, XFRM_POLICY_TYPE_MAIN,
 			      dir, pol->sadb_x_policy_id, delete, &err);
 	if (xp == NULL)
 		return -ENOENT;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index cba1c6ffe51a..5239c502c016 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -383,8 +383,8 @@ static void tcp_options(const struct sk_buff *skb,
 				 length, buff);
 	BUG_ON(ptr == NULL);
 
-	state->td_scale =
-	state->flags = 0;
+	state->td_scale = 0;
+	state->flags &= IP_CT_TCP_FLAG_BE_LIBERAL;
 
 	while (length > 0) {
 		int opcode=*ptr++;
@@ -797,6 +797,16 @@ static unsigned int *tcp_get_timeouts(struct net *net)
 	return tcp_pernet(net)->timeouts;
 }
 
+static void nf_ct_tcp_state_reset(struct ip_ct_tcp_state *state)
+{
+	state->td_end		= 0;
+	state->td_maxend	= 0;
+	state->td_maxwin	= 0;
+	state->td_maxack	= 0;
+	state->td_scale		= 0;
+	state->flags		&= IP_CT_TCP_FLAG_BE_LIBERAL;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct nf_conn *ct,
 		      const struct sk_buff *skb,
@@ -897,8 +907,7 @@ static int tcp_packet(struct nf_conn *ct,
 			ct->proto.tcp.last_flags &= ~IP_CT_EXP_CHALLENGE_ACK;
 			ct->proto.tcp.seen[ct->proto.tcp.last_dir].flags =
 				ct->proto.tcp.last_flags;
-			memset(&ct->proto.tcp.seen[dir], 0,
-			       sizeof(struct ip_ct_tcp_state));
+			nf_ct_tcp_state_reset(&ct->proto.tcp.seen[dir]);
 			break;
 		}
 		ct->proto.tcp.last_index = index;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 0563b4d34eae..24e8ac2b724e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -154,6 +154,8 @@ static const struct rhashtable_params netlink_rhashtable_params;
 
 static inline u32 netlink_group_mask(u32 group)
 {
+	if (group > 32)
+		return 0;
 	return group ? 1 << (group - 1) : 0;
 }
 
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index c6dc82f66bd9..99f4573fd917 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -560,6 +560,10 @@ static int nci_close_device(struct nci_dev *ndev)
 	mutex_lock(&ndev->req_lock);
 
 	if (!test_and_clear_bit(NCI_UP, &ndev->flags)) {
+		/* Need to flush the cmd wq in case
+		 * there is a queued/running cmd_work
+		 */
+		flush_workqueue(ndev->cmd_wq);
 		del_timer_sync(&ndev->cmd_timer);
 		del_timer_sync(&ndev->data_timer);
 		mutex_unlock(&ndev->req_lock);
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index f5deae2ccb79..ed3528aec15f 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -1827,8 +1827,8 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 			icmpv6_key->icmpv6_type = ntohs(output->tp.src);
 			icmpv6_key->icmpv6_code = ntohs(output->tp.dst);
 
-			if (icmpv6_key->icmpv6_type == NDISC_NEIGHBOUR_SOLICITATION ||
-			    icmpv6_key->icmpv6_type == NDISC_NEIGHBOUR_ADVERTISEMENT) {
+			if (swkey->tp.src == htons(NDISC_NEIGHBOUR_SOLICITATION) ||
+			    swkey->tp.src == htons(NDISC_NEIGHBOUR_ADVERTISEMENT)) {
 				struct ovs_key_nd *nd_key;
 
 				nla = nla_reserve(skb, OVS_KEY_ATTR_ND, sizeof(*nd_key));
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 92394595920c..b0dd17d1992e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2017,7 +2017,7 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
 	skb->priority = sk->sk_priority;
 	skb->mark = sk->sk_mark;
 
-	sock_tx_timestamp(sk, sockc.tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
 	if (unlikely(extra_len == 4))
 		skb->no_fcs = 1;
@@ -2539,7 +2539,7 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	skb->dev = dev;
 	skb->priority = po->sk.sk_priority;
 	skb->mark = po->sk.sk_mark;
-	sock_tx_timestamp(&po->sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc->tsflags);
 	skb_zcopy_set_nouarg(skb, ph.raw);
 
 	skb_reserve(skb, hlen);
@@ -3002,7 +3002,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out_free;
 	}
 
-	sock_tx_timestamp(sk, sockc.tsflags, &skb_shinfo(skb)->tx_flags);
+	skb_setup_tx_timestamp(skb, sockc.tsflags);
 
 	if (!vnet_hdr.gso_type && (len > dev->mtu + reserve + extra_len) &&
 	    !packet_extra_vlan_len_allowed(dev, skb)) {
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 7dc907a45c68..a28e06c70e52 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -499,7 +499,7 @@ struct smc_buf_desc *smc_buf_get_slot(struct smc_link_group *lgr,
  */
 static inline int smc_rmb_wnd_update_limit(int rmbe_size)
 {
-	return min_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
+	return max_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
 }
 
 static struct smc_buf_desc *smc_new_buf_create(struct smc_link_group *lgr,
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 253132130c42..4e0ebb4780df 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -883,8 +883,10 @@ int rpc_malloc(struct rpc_task *task)
 	struct rpc_buffer *buf;
 	gfp_t gfp = GFP_NOIO | __GFP_NOWARN;
 
+	if (RPC_IS_ASYNC(task))
+		gfp = GFP_NOWAIT | __GFP_NOWARN;
 	if (RPC_IS_SWAPPER(task))
-		gfp = __GFP_MEMALLOC | GFP_NOWAIT | __GFP_NOWARN;
+		gfp |= __GFP_MEMALLOC;
 
 	size += sizeof(struct rpc_buffer);
 	if (size <= RPC_BUFFER_MAXSIZE)
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 7b1213be3e81..e7d55d63d4f1 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1520,7 +1520,14 @@ static void xprt_destroy(struct rpc_xprt *xprt)
 	 */
 	wait_on_bit_lock(&xprt->state, XPRT_LOCKED, TASK_UNINTERRUPTIBLE);
 
+	/*
+	 * xprt_schedule_autodisconnect() can run after XPRT_LOCKED
+	 * is cleared.  We use ->transport_lock to ensure the mod_timer()
+	 * can only run *before* del_time_sync(), never after.
+	 */
+	spin_lock(&xprt->transport_lock);
 	del_timer_sync(&xprt->timer);
+	spin_unlock(&xprt->transport_lock);
 
 	/*
 	 * Destroy sockets etc from the system workqueue so they can
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index ead20e6754ab..90c99919ea30 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -645,8 +645,10 @@ xprt_rdma_allocate(struct rpc_task *task)
 		return -ENOMEM;
 
 	flags = RPCRDMA_DEF_GFP;
+	if (RPC_IS_ASYNC(task))
+		flags = GFP_NOWAIT | __GFP_NOWARN;
 	if (RPC_IS_SWAPPER(task))
-		flags = __GFP_MEMALLOC | GFP_NOWAIT | __GFP_NOWARN;
+		flags |= __GFP_MEMALLOC;
 
 	if (!rpcrdma_get_rdmabuf(r_xprt, req, flags))
 		goto out_fail;
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index fd0a6c6c77b6..e103ec39759f 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1796,10 +1796,15 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
 
 	write_lock_bh(&x25_list_lock);
 
-	sk_for_each(s, &x25_list)
-		if (x25_sk(s)->neighbour == nb)
+	sk_for_each(s, &x25_list) {
+		if (x25_sk(s)->neighbour == nb) {
+			write_unlock_bh(&x25_list_lock);
+			lock_sock(s);
 			x25_disconnect(s, ENETUNREACH, 0, 0);
-
+			release_sock(s);
+			write_lock_bh(&x25_list_lock);
+		}
+	}
 	write_unlock_bh(&x25_list_lock);
 
 	/* Remove any related forwards */
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f8fd0aebf771..d87121d61a2b 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -719,14 +719,10 @@ static void xfrm_policy_requeue(struct xfrm_policy *old,
 	spin_unlock_bh(&pq->hold_queue.lock);
 }
 
-static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
-				   struct xfrm_policy *pol)
+static inline bool xfrm_policy_mark_match(const struct xfrm_mark *mark,
+					  struct xfrm_policy *pol)
 {
-	if (policy->mark.v == pol->mark.v &&
-	    policy->priority == pol->priority)
-		return true;
-
-	return false;
+	return mark->v == pol->mark.v && mark->m == pol->mark.m;
 }
 
 int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
@@ -744,7 +740,7 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 	hlist_for_each_entry(pol, chain, bydst) {
 		if (pol->type == policy->type &&
 		    !selector_cmp(&pol->selector, &policy->selector) &&
-		    xfrm_policy_mark_match(policy, pol) &&
+		    xfrm_policy_mark_match(&policy->mark, pol) &&
 		    xfrm_sec_ctx_match(pol->security, policy->security) &&
 		    !WARN_ON(delpol)) {
 			if (excl) {
@@ -794,8 +790,8 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 }
 EXPORT_SYMBOL(xfrm_policy_insert);
 
-struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u8 type,
-					  int dir, struct xfrm_selector *sel,
+struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, const struct xfrm_mark *mark,
+					  u8 type, int dir, struct xfrm_selector *sel,
 					  struct xfrm_sec_ctx *ctx, int delete,
 					  int *err)
 {
@@ -808,7 +804,7 @@ struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u8 type,
 	ret = NULL;
 	hlist_for_each_entry(pol, chain, bydst) {
 		if (pol->type == type &&
-		    (mark & pol->mark.m) == pol->mark.v &&
+		    xfrm_policy_mark_match(mark, pol) &&
 		    !selector_cmp(sel, &pol->selector) &&
 		    xfrm_sec_ctx_match(ctx, pol->security)) {
 			xfrm_pol_hold(pol);
@@ -833,8 +829,8 @@ struct xfrm_policy *xfrm_policy_bysel_ctx(struct net *net, u32 mark, u8 type,
 }
 EXPORT_SYMBOL(xfrm_policy_bysel_ctx);
 
-struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u8 type,
-				     int dir, u32 id, int delete, int *err)
+struct xfrm_policy *xfrm_policy_byid(struct net *net, const struct xfrm_mark *mark,
+					 u8 type, int dir, u32 id, int delete, int *err)
 {
 	struct xfrm_policy *pol, *ret;
 	struct hlist_head *chain;
@@ -849,7 +845,7 @@ struct xfrm_policy *xfrm_policy_byid(struct net *net, u32 mark, u8 type,
 	ret = NULL;
 	hlist_for_each_entry(pol, chain, byidx) {
 		if (pol->type == type && pol->index == id &&
-		    (mark & pol->mark.m) == pol->mark.v) {
+		    xfrm_policy_mark_match(mark, pol)) {
 			xfrm_pol_hold(pol);
 			if (delete) {
 				*err = security_xfrm_policy_delete(
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 321fd881c638..ad30e0d8b28e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1814,7 +1814,6 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct km_event c;
 	int delete;
 	struct xfrm_mark m;
-	u32 mark = xfrm_mark_get(attrs, &m);
 
 	p = nlmsg_data(nlh);
 	delete = nlh->nlmsg_type == XFRM_MSG_DELPOLICY;
@@ -1827,8 +1826,10 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
+	xfrm_mark_get(attrs, &m);
+
 	if (p->index)
-		xp = xfrm_policy_byid(net, mark, type, p->dir, p->index, delete, &err);
+		xp = xfrm_policy_byid(net, &m, type, p->dir, p->index, delete, &err);
 	else {
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
@@ -1845,7 +1846,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 			if (err)
 				return err;
 		}
-		xp = xfrm_policy_bysel_ctx(net, mark, type, p->dir, &p->sel,
+		xp = xfrm_policy_bysel_ctx(net, &m, type, p->dir, &p->sel,
 					   ctx, delete, &err);
 		security_xfrm_policy_free(ctx);
 	}
@@ -2108,7 +2109,6 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u8 type = XFRM_POLICY_TYPE_MAIN;
 	int err = -ENOENT;
 	struct xfrm_mark m;
-	u32 mark = xfrm_mark_get(attrs, &m);
 
 	err = copy_from_user_policy_type(&type, attrs);
 	if (err)
@@ -2118,8 +2118,10 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
+	xfrm_mark_get(attrs, &m);
+
 	if (p->index)
-		xp = xfrm_policy_byid(net, mark, type, p->dir, p->index, 0, &err);
+		xp = xfrm_policy_byid(net, &m, type, p->dir, p->index, 0, &err);
 	else {
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
@@ -2136,7 +2138,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 			if (err)
 				return err;
 		}
-		xp = xfrm_policy_bysel_ctx(net, mark, type, p->dir,
+		xp = xfrm_policy_bysel_ctx(net, &m, type, p->dir,
 					   &p->sel, ctx, 0, &err);
 		security_xfrm_policy_free(ctx);
 	}
diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index cbe1d6c4b1a5..c84bef1d2895 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -86,25 +86,31 @@ static struct plugin_info latent_entropy_plugin_info = {
 	.help		= "disable\tturn off latent entropy instrumentation\n",
 };
 
-static unsigned HOST_WIDE_INT seed;
-/*
- * get_random_seed() (this is a GCC function) generates the seed.
- * This is a simple random generator without any cryptographic security because
- * the entropy doesn't come from here.
- */
+static unsigned HOST_WIDE_INT deterministic_seed;
+static unsigned HOST_WIDE_INT rnd_buf[32];
+static size_t rnd_idx = ARRAY_SIZE(rnd_buf);
+static int urandom_fd = -1;
+
 static unsigned HOST_WIDE_INT get_random_const(void)
 {
-	unsigned int i;
-	unsigned HOST_WIDE_INT ret = 0;
-
-	for (i = 0; i < 8 * sizeof(ret); i++) {
-		ret = (ret << 1) | (seed & 1);
-		seed >>= 1;
-		if (ret & 1)
-			seed ^= 0xD800000000000000ULL;
+	if (deterministic_seed) {
+		unsigned HOST_WIDE_INT w = deterministic_seed;
+		w ^= w << 13;
+		w ^= w >> 7;
+		w ^= w << 17;
+		deterministic_seed = w;
+		return deterministic_seed;
 	}
 
-	return ret;
+	if (urandom_fd < 0) {
+		urandom_fd = open("/dev/urandom", O_RDONLY);
+		gcc_assert(urandom_fd >= 0);
+	}
+	if (rnd_idx >= ARRAY_SIZE(rnd_buf)) {
+		gcc_assert(read(urandom_fd, rnd_buf, sizeof(rnd_buf)) == sizeof(rnd_buf));
+		rnd_idx = 0;
+	}
+	return rnd_buf[rnd_idx++];
 }
 
 static tree tree_get_random_const(tree type)
@@ -549,8 +555,6 @@ static void latent_entropy_start_unit(void *gcc_data __unused,
 	tree type, id;
 	int quals;
 
-	seed = get_random_seed(false);
-
 	if (in_lto_p)
 		return;
 
@@ -585,6 +589,12 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
 	const struct plugin_argument * const argv = plugin_info->argv;
 	int i;
 
+	/*
+	 * Call get_random_seed() with noinit=true, so that this returns
+	 * 0 in the case where no seed has been passed via -frandom-seed.
+	 */
+	deterministic_seed = get_random_seed(true);
+
 	static const struct ggc_root_tab gt_ggc_r_gt_latent_entropy[] = {
 		{
 			.base = &latent_entropy_decl,
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 56e354fcdfc6..5304dd49e054 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -344,7 +344,7 @@ int selinux_xfrm_state_alloc_acquire(struct xfrm_state *x,
 	int rc;
 	struct xfrm_sec_ctx *ctx;
 	char *ctx_str = NULL;
-	int str_len;
+	u32 str_len;
 
 	if (!polsec)
 		return 0;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index a0e1b99212b2..fe070669dc18 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2563,7 +2563,7 @@ static int smk_ipv6_check(struct smack_known *subject,
 #ifdef CONFIG_AUDIT
 	smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 	ad.a.u.net->family = PF_INET6;
-	ad.a.u.net->dport = ntohs(address->sin6_port);
+	ad.a.u.net->dport = address->sin6_port;
 	if (act == SMK_RECEIVING)
 		ad.a.u.net->v6info.saddr = address->sin6_addr;
 	else
diff --git a/security/tomoyo/load_policy.c b/security/tomoyo/load_policy.c
index 81b951652051..f8baef1f3277 100644
--- a/security/tomoyo/load_policy.c
+++ b/security/tomoyo/load_policy.c
@@ -24,7 +24,7 @@ static const char *tomoyo_loader;
 static int __init tomoyo_loader_setup(char *str)
 {
 	tomoyo_loader = str;
-	return 0;
+	return 1;
 }
 
 __setup("TOMOYO_loader=", tomoyo_loader_setup);
@@ -63,7 +63,7 @@ static const char *tomoyo_trigger;
 static int __init tomoyo_trigger_setup(char *str)
 {
 	tomoyo_trigger = str;
-	return 0;
+	return 1;
 }
 
 __setup("TOMOYO_trigger=", tomoyo_trigger_setup);
diff --git a/sound/core/pcm_misc.c b/sound/core/pcm_misc.c
index 9be81025372f..8412d1cbd009 100644
--- a/sound/core/pcm_misc.c
+++ b/sound/core/pcm_misc.c
@@ -406,7 +406,7 @@ int snd_pcm_format_set_silence(snd_pcm_format_t format, void *data, unsigned int
 		return 0;
 	width = pcm_formats[(INT)format].phys; /* physical width */
 	pat = pcm_formats[(INT)format].silence;
-	if (! width)
+	if (!width || !pat)
 		return -EINVAL;
 	/* signed or 1 byte data */
 	if (pcm_formats[(INT)format].signd == 1 || width <= 8) {
diff --git a/sound/firewire/fcp.c b/sound/firewire/fcp.c
index 61dda828f767..c8fbb54269cb 100644
--- a/sound/firewire/fcp.c
+++ b/sound/firewire/fcp.c
@@ -240,9 +240,7 @@ int fcp_avc_transaction(struct fw_unit *unit,
 	t.response_match_bytes = response_match_bytes;
 	t.state = STATE_PENDING;
 	init_waitqueue_head(&t.wait);
-
-	if (*(const u8 *)command == 0x00 || *(const u8 *)command == 0x03)
-		t.deferrable = true;
+	t.deferrable = (*(const u8 *)command == 0x00 || *(const u8 *)command == 0x03);
 
 	spin_lock_irq(&transactions_lock);
 	list_add_tail(&t.list, &transactions);
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index 7d4e18cb6351..6fff77fe34a8 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -559,7 +559,7 @@ static int snd_cs423x_pnpbios_detect(struct pnp_dev *pdev,
 	static int dev;
 	int err;
 	struct snd_card *card;
-	struct pnp_dev *cdev;
+	struct pnp_dev *cdev, *iter;
 	char cid[PNP_ID_LEN];
 
 	if (pnp_device_is_isapnp(pdev))
@@ -575,9 +575,11 @@ static int snd_cs423x_pnpbios_detect(struct pnp_dev *pdev,
 	strcpy(cid, pdev->id[0].id);
 	cid[5] = '1';
 	cdev = NULL;
-	list_for_each_entry(cdev, &(pdev->protocol->devices), protocol_list) {
-		if (!strcmp(cdev->id[0].id, cid))
+	list_for_each_entry(iter, &(pdev->protocol->devices), protocol_list) {
+		if (!strcmp(iter->id[0].id, cid)) {
+			cdev = iter;
 			break;
+		}
 	}
 	err = snd_cs423x_card_new(&pdev->dev, dev, &card);
 	if (err < 0)
diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
index a1e2c5682dcd..6741ae42b598 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -296,7 +296,10 @@ static int atmel_ssc_startup(struct snd_pcm_substream *substream,
 
 	/* Enable PMC peripheral clock for this SSC */
 	pr_debug("atmel_ssc_dai: Starting clock\n");
-	clk_enable(ssc_p->ssc->clk);
+	ret = clk_enable(ssc_p->ssc->clk);
+	if (ret)
+		return ret;
+
 	ssc_p->mck_rate = clk_get_rate(ssc_p->ssc->clk);
 
 	/* Reset the SSC unless initialized to keep it in a clean state */
diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
index d7469cdd90dc..39365319c351 100644
--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -226,6 +226,7 @@ static int at91sam9g20ek_audio_probe(struct platform_device *pdev)
 	cpu_np = of_parse_phandle(np, "atmel,ssc-controller", 0);
 	if (!cpu_np) {
 		dev_err(&pdev->dev, "dai and pcm info missing\n");
+		of_node_put(codec_np);
 		return -EINVAL;
 	}
 	at91sam9g20ek_dai.cpu_of_node = cpu_np;
diff --git a/sound/soc/codecs/msm8916-wcd-digital.c b/sound/soc/codecs/msm8916-wcd-digital.c
index 13354d6304a8..b2571ab13ea1 100644
--- a/sound/soc/codecs/msm8916-wcd-digital.c
+++ b/sound/soc/codecs/msm8916-wcd-digital.c
@@ -910,7 +910,7 @@ static int msm8916_wcd_digital_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(priv->mclk);
 	if (ret < 0) {
 		dev_err(dev, "failed to enable mclk %d\n", ret);
-		return ret;
+		goto err_clk;
 	}
 
 	dev_set_drvdata(dev, priv);
@@ -918,6 +918,9 @@ static int msm8916_wcd_digital_probe(struct platform_device *pdev)
 	return snd_soc_register_codec(dev, &msm8916_wcd_digital,
 				      msm8916_wcd_digital_dai,
 				      ARRAY_SIZE(msm8916_wcd_digital_dai));
+err_clk:
+	clk_disable_unprepare(priv->ahbclk);
+	return ret;
 }
 
 static int msm8916_wcd_digital_remove(struct platform_device *pdev)
diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index 2efc5b41ad0f..6d719392cdbe 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -1536,18 +1536,38 @@ static  int wm8350_codec_probe(struct snd_soc_codec *codec)
 	wm8350_clear_bits(wm8350, WM8350_JACK_DETECT,
 			  WM8350_JDL_ENA | WM8350_JDR_ENA);
 
-	wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L,
 			    wm8350_hpl_jack_handler, 0, "Left jack detect",
 			    priv);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R,
+	if (ret != 0)
+		goto err;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R,
 			    wm8350_hpr_jack_handler, 0, "Right jack detect",
 			    priv);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_MICSCD,
+	if (ret != 0)
+		goto free_jck_det_l;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_MICSCD,
 			    wm8350_mic_handler, 0, "Microphone short", priv);
-	wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_MICD,
+	if (ret != 0)
+		goto free_jck_det_r;
+
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_CODEC_MICD,
 			    wm8350_mic_handler, 0, "Microphone detect", priv);
+	if (ret != 0)
+		goto free_micscd;
 
 	return 0;
+
+free_micscd:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_MICSCD, priv);
+free_jck_det_r:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_R, priv);
+free_jck_det_l:
+	wm8350_free_irq(wm8350, WM8350_IRQ_CODEC_JCK_DET_L, priv);
+err:
+	return ret;
 }
 
 static int  wm8350_codec_remove(struct snd_soc_codec *codec)
diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2s.c
index 384961651904..e5f61f1499c6 100644
--- a/sound/soc/davinci/davinci-i2s.c
+++ b/sound/soc/davinci/davinci-i2s.c
@@ -719,7 +719,9 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 	dev->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dev->clk))
 		return -ENODEV;
-	clk_enable(dev->clk);
+	ret = clk_enable(dev->clk);
+	if (ret)
+		goto err_put_clk;
 
 	dev->dev = &pdev->dev;
 	dev_set_drvdata(&pdev->dev, dev);
@@ -741,6 +743,7 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 	snd_soc_unregister_component(&pdev->dev);
 err_release_clk:
 	clk_disable(dev->clk);
+err_put_clk:
 	clk_put(dev->clk);
 	return ret;
 }
diff --git a/sound/soc/fsl/imx-es8328.c b/sound/soc/fsl/imx-es8328.c
index 9953438086e4..735693274f49 100644
--- a/sound/soc/fsl/imx-es8328.c
+++ b/sound/soc/fsl/imx-es8328.c
@@ -93,6 +93,7 @@ static int imx_es8328_probe(struct platform_device *pdev)
 	if (int_port > MUX_PORT_MAX || int_port == 0) {
 		dev_err(dev, "mux-int-port: hardware only has %d mux ports\n",
 			MUX_PORT_MAX);
+		ret = -EINVAL;
 		goto fail;
 	}
 
diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 156aa7c00787..93c019670199 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -467,7 +467,10 @@ static int mxs_saif_hw_params(struct snd_pcm_substream *substream,
 		* basic clock which should be fast enough for the internal
 		* logic.
 		*/
-		clk_enable(saif->clk);
+		ret = clk_enable(saif->clk);
+		if (ret)
+			return ret;
+
 		ret = clk_set_rate(saif->clk, 24000000);
 		clk_disable(saif->clk);
 		if (ret)
diff --git a/sound/soc/mxs/mxs-sgtl5000.c b/sound/soc/mxs/mxs-sgtl5000.c
index 2ed3240cc682..d5e1a5e7c238 100644
--- a/sound/soc/mxs/mxs-sgtl5000.c
+++ b/sound/soc/mxs/mxs-sgtl5000.c
@@ -112,6 +112,9 @@ static int mxs_sgtl5000_probe(struct platform_device *pdev)
 	codec_np = of_parse_phandle(np, "audio-codec", 0);
 	if (!saif_np[0] || !saif_np[1] || !codec_np) {
 		dev_err(&pdev->dev, "phandle missing or invalid\n");
+		of_node_put(codec_np);
+		of_node_put(saif_np[0]);
+		of_node_put(saif_np[1]);
 		return -EINVAL;
 	}
 
diff --git a/sound/soc/sh/fsi.c b/sound/soc/sh/fsi.c
index 6d3c7706d93f..b564accb6098 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -820,14 +820,27 @@ static int fsi_clk_enable(struct device *dev,
 			return ret;
 		}
 
-		clk_enable(clock->xck);
-		clk_enable(clock->ick);
-		clk_enable(clock->div);
+		ret = clk_enable(clock->xck);
+		if (ret)
+			goto err;
+		ret = clk_enable(clock->ick);
+		if (ret)
+			goto disable_xck;
+		ret = clk_enable(clock->div);
+		if (ret)
+			goto disable_ick;
 
 		clock->count++;
 	}
 
 	return ret;
+
+disable_ick:
+	clk_disable(clock->ick);
+disable_xck:
+	clk_disable(clock->xck);
+err:
+	return ret;
 }
 
 static int fsi_clk_disable(struct device *dev,
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 2a172de37466..febf2b649b96 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4243,7 +4243,7 @@ int snd_soc_get_dai_name(struct of_phandle_args *args,
 		if (!component_of_node && pos->dev->parent)
 			component_of_node = pos->dev->parent->of_node;
 
-		if (component_of_node != args->np)
+		if (component_of_node != args->np || !pos->num_dai)
 			continue;
 
 		if (pos->driver->of_xlate_dai_name) {
diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index 052778c6afad..5362ceccbd45 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -98,10 +98,10 @@ static int dmaengine_pcm_hw_params(struct snd_pcm_substream *substream,
 
 	memset(&slave_config, 0, sizeof(slave_config));
 
-	if (!pcm->config)
-		prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config;
-	else
+	if (pcm->config && pcm->config->prepare_slave_config)
 		prepare_slave_config = pcm->config->prepare_slave_config;
+	else
+		prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config;
 
 	if (prepare_slave_config) {
 		ret = prepare_slave_config(substream, params, &slave_config);
diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 0fbe50502699..3de4ee51029c 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -599,7 +599,8 @@ static int soc_tplg_kcontrol_bind_io(struct snd_soc_tplg_ctl_hdr *hdr,
 
 	if (hdr->ops.info == SND_SOC_TPLG_CTL_BYTES
 		&& k->iface & SNDRV_CTL_ELEM_IFACE_MIXER
-		&& k->access & SNDRV_CTL_ELEM_ACCESS_TLV_READWRITE
+		&& (k->access & SNDRV_CTL_ELEM_ACCESS_TLV_READ
+		    || k->access & SNDRV_CTL_ELEM_ACCESS_TLV_WRITE)
 		&& k->access & SNDRV_CTL_ELEM_ACCESS_TLV_CALLBACK) {
 		struct soc_bytes_ext *sbe;
 		struct snd_soc_tplg_bytes_control *be;
diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
index 1ef52edeb538..3763f06ed784 100644
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -221,7 +221,9 @@ static int snd_at73c213_pcm_open(struct snd_pcm_substream *substream)
 	runtime->hw = snd_at73c213_playback_hw;
 	chip->substream = substream;
 
-	clk_enable(chip->ssc->clk);
+	err = clk_enable(chip->ssc->clk);
+	if (err)
+		return err;
 
 	return 0;
 }
@@ -787,7 +789,9 @@ static int snd_at73c213_chip_init(struct snd_at73c213 *chip)
 		goto out;
 
 	/* Enable DAC master clock. */
-	clk_enable(chip->board->dac_clk);
+	retval = clk_enable(chip->board->dac_clk);
+	if (retval)
+		goto out;
 
 	/* Initialize at73c213 on SPI bus. */
 	retval = snd_at73c213_write_reg(chip, DAC_RST, 0x04);
@@ -900,7 +904,9 @@ static int snd_at73c213_dev_init(struct snd_card *card,
 	chip->card = card;
 	chip->irq = -1;
 
-	clk_enable(chip->ssc->clk);
+	retval = clk_enable(chip->ssc->clk);
+	if (retval)
+		return retval;
 
 	retval = request_irq(irq, snd_at73c213_interrupt, 0, "at73c213", chip);
 	if (retval) {
@@ -1019,7 +1025,9 @@ static int snd_at73c213_remove(struct spi_device *spi)
 	int retval;
 
 	/* Stop playback. */
-	clk_enable(chip->ssc->clk);
+	retval = clk_enable(chip->ssc->clk);
+	if (retval)
+		goto out;
 	ssc_writel(chip->ssc->regs, CR, SSC_BIT(CR_TXDIS));
 	clk_disable(chip->ssc->clk);
 
@@ -1099,9 +1107,16 @@ static int snd_at73c213_resume(struct device *dev)
 {
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct snd_at73c213 *chip = card->private_data;
+	int retval;
 
-	clk_enable(chip->board->dac_clk);
-	clk_enable(chip->ssc->clk);
+	retval = clk_enable(chip->board->dac_clk);
+	if (retval)
+		return retval;
+	retval = clk_enable(chip->ssc->clk);
+	if (retval) {
+		clk_disable(chip->board->dac_clk);
+		return retval;
+	}
 	ssc_writel(chip->ssc->regs, CR, SSC_BIT(CR_TXEN));
 
 	return 0;
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index a1a3eb8fe52e..652e6c92e1db 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -184,7 +184,7 @@ strip-libs = $(filter-out -l%,$(1))
 PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
 PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
 PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
-PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+PERL_EMBED_CCOPTS = $(shell perl -MExtUtils::Embed -e ccopts 2>/dev/null)
 FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
 $(OUTPUT)test-libperl.bin:
diff --git a/tools/testing/selftests/x86/check_cc.sh b/tools/testing/selftests/x86/check_cc.sh
index 172d3293fb7b..356689c56397 100755
--- a/tools/testing/selftests/x86/check_cc.sh
+++ b/tools/testing/selftests/x86/check_cc.sh
@@ -7,7 +7,7 @@ CC="$1"
 TESTPROG="$2"
 shift 2
 
-if "$CC" -o /dev/null "$TESTPROG" -O0 "$@" 2>/dev/null; then
+if [ -n "$CC" ] && $CC -o /dev/null "$TESTPROG" -O0 "$@" 2>/dev/null; then
     echo 1
 else
     echo 0
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 36b9f2b29071..87d522eefbb4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -112,6 +112,8 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
 static int kvm_debugfs_num_entries;
 static const struct file_operations *stat_fops_per_vm[];
 
+static struct file_operations kvm_chardev_ops;
+
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 #ifdef CONFIG_KVM_COMPAT
@@ -716,6 +718,16 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	preempt_notifier_inc();
 
+	/*
+	 * When the fd passed to this ioctl() is opened it pins the module,
+	 * but try_module_get() also prevents getting a reference if the module
+	 * is in MODULE_STATE_GOING (e.g. if someone ran "rmmod --wait").
+	 */
+	if (!try_module_get(kvm_chardev_ops.owner)) {
+		r = -ENODEV;
+		goto out_err;
+	}
+
 	return kvm;
 
 out_err:
@@ -792,6 +804,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	preempt_notifier_dec();
 	hardware_disable_all();
 	mmdrop(mm);
+	module_put(kvm_chardev_ops.owner);
 }
 
 void kvm_get_kvm(struct kvm *kvm)
