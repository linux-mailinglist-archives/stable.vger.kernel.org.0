Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A8468B665
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 08:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjBFH15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 02:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjBFH1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 02:27:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28141ABF9;
        Sun,  5 Feb 2023 23:27:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB8EB80D4C;
        Mon,  6 Feb 2023 07:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6267FC4339B;
        Mon,  6 Feb 2023 07:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675668430;
        bh=aobv/Bq3+mar1DfGuCuA+LUSKfROmQaFquwRj+bnILc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAqlWLErPKFQg5XVt519L3wbDA3M/jWpV7hp3WSRcsYGzwM6ikPj+n8Zd9kT8nlfJ
         QmAWJiGm1xJUTvbqPtGu3RJ4FR/7EpjdtRcbZ29khUZaHu2Z5mHF4ESylOZZEOo4py
         6QHkxjcT92LlxRKIJhsxD8lGVVYSVUM4sDIHmf7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.92
Date:   Mon,  6 Feb 2023 08:26:56 +0100
Message-Id: <167566841624154@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <1675668416536@kroah.com>
References: <1675668416536@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 02b2ade89c51..13f41e446294 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 91
+SUBLEVEL = 92
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/boot/dts/imx53-ppd.dts b/arch/arm/boot/dts/imx53-ppd.dts
index 37d0cffea99c..70c4a4852256 100644
--- a/arch/arm/boot/dts/imx53-ppd.dts
+++ b/arch/arm/boot/dts/imx53-ppd.dts
@@ -488,7 +488,7 @@ &i2c1 {
 	scl-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 
-	i2c-switch@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9547";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
index 043ddd70372f..36d5299b2baa 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
@@ -343,7 +343,7 @@ gpio6: io-expander@22 {
 };
 
 &i2c2 {
-	tca9548@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9548";
 		pinctrl-0 = <&pinctrl_i2c_mux_reset>;
 		pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
index de79dcfd32e6..ba2001f37315 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
@@ -340,7 +340,7 @@ eeprom@50 {
 };
 
 &i2c2 {
-	tca9548@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9548";
 		pinctrl-0 = <&pinctrl_i2c_mux_reset>;
 		pinctrl-names = "default";
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
index e22c5e77fecd..9615f3b9ee60 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1012a-qds.dts
@@ -110,7 +110,7 @@ &esdhc1 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
index fea167d222cf..14856bc79b22 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a-qds.dts
@@ -70,7 +70,7 @@ fpga: board-control@2,0 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
index eec62c63dafe..9ee9928f71b4 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-qds.dts
@@ -76,7 +76,7 @@ &duart1 {
 &i2c0 {
 	status = "okay";
 
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
index 41d8b15f25a5..aa52ff73ff9e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-qds.dts
@@ -53,7 +53,7 @@ flash@2 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
index 1bfbce69cc8b..ee8e932628d1 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-rdb.dts
@@ -136,7 +136,7 @@ mdio2_aquantia_phy: ethernet-phy@0 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts b/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
index d3f03dcbb8c3..a9c6682a3955 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
@@ -245,7 +245,7 @@ rx8035: rtc@32 {
 &i2c3 {
 	status = "okay";
 
-	i2c-switch@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9540";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
index 10d2fe091965..8d96d18c3697 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa-qds.dtsi
@@ -44,7 +44,7 @@ cpld@3,0 {
 
 &i2c0 {
 	status = "okay";
-	pca9547@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		reg = <0x77>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
index 4b71c4fcb35f..787e408da002 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa-rdb.dtsi
@@ -44,7 +44,7 @@ cpld@3,0 {
 
 &i2c0 {
 	status = "okay";
-	pca9547@75 {
+	i2c-mux@75 {
 		compatible = "nxp,pca9547";
 		reg = <0x75>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
index afb455210bd0..d32a52ab00a4 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-cex7.dtsi
@@ -54,7 +54,7 @@ &esdhc1 {
 &i2c0 {
 	status = "okay";
 
-	i2c-switch@77 {
+	i2c-mux@77 {
 		compatible = "nxp,pca9547";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts b/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
index 74c09891600f..6357078185ed 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dts
@@ -214,7 +214,7 @@ &i2c3 {
 	pinctrl-0 = <&pinctrl_i2c3>;
 	status = "okay";
 
-	i2cmux@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9540";
 		reg = <0x70>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts b/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
index f70fb32b96b0..cf14ab5f7404 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dts
@@ -133,7 +133,7 @@ &i2c1 {
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
 
-	i2cmux@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9546";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_i2c1_pca9546>;
@@ -216,7 +216,7 @@ &i2c4 {
 	pinctrl-0 = <&pinctrl_i2c4>;
 	status = "okay";
 
-	pca9546: i2cmux@70 {
+	pca9546: i2c-mux@70 {
 		compatible = "nxp,pca9546";
 		reg = <0x70>;
 		#address-cells = <1>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mq-thor96.dts b/arch/arm64/boot/dts/freescale/imx8mq-thor96.dts
index 5d5aa6537225..6e6182709d22 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-thor96.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-thor96.dts
@@ -339,7 +339,7 @@ &usdhc1 {
 	bus-width = <4>;
 	non-removable;
 	no-sd;
-	no-emmc;
+	no-mmc;
 	status = "okay";
 
 	brcmf: wifi@1 {
@@ -359,7 +359,7 @@ &usdhc2 {
 	cd-gpios = <&gpio2 12 GPIO_ACTIVE_LOW>;
 	bus-width = <4>;
 	no-sdio;
-	no-emmc;
+	no-mmc;
 	disable-wp;
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
index 863232a47004..4497763d57cc 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -61,7 +61,7 @@ &i2c1 {
 	pinctrl-0 = <&pinctrl_lpi2c1 &pinctrl_ioexp_rst>;
 	status = "okay";
 
-	i2c-switch@71 {
+	i2c-mux@71 {
 		compatible = "nxp,pca9646", "nxp,pca9546";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ce5858dadca5..3ee4c1217b63 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1360,6 +1360,10 @@ int blkcg_activate_policy(struct request_queue *q,
 		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
 			pol->pd_init_fn(blkg->pd[pol->plid]);
 
+	if (pol->pd_online_fn)
+		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
+			pol->pd_online_fn(blkg->pd[pol->plid]);
+
 	__set_bit(pol->plid, q->blkcg_pols);
 	ret = 0;
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index dc880dad2ade..e9116db1e352 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -531,10 +531,27 @@ static void wait_for_freeze(void)
 	/* No delay is needed if we are in guest */
 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return;
+	/*
+	 * Modern (>=Nehalem) Intel systems use ACPI via intel_idle,
+	 * not this code.  Assume that any Intel systems using this
+	 * are ancient and may need the dummy wait.  This also assumes
+	 * that the motivating chipset issue was Intel-only.
+	 */
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return;
 #endif
-	/* Dummy wait op - must do something useless after P_LVL2 read
-	   because chipsets cannot guarantee that STPCLK# signal
-	   gets asserted in time to freeze execution properly. */
+	/*
+	 * Dummy wait op - must do something useless after P_LVL2 read
+	 * because chipsets cannot guarantee that STPCLK# signal gets
+	 * asserted in time to freeze execution properly
+	 *
+	 * This workaround has been in place since the original ACPI
+	 * implementation was merged, circa 2002.
+	 *
+	 * If a profile is pointing to this instruction, please first
+	 * consider moving your system to a more modern idle
+	 * mechanism.
+	 */
 	inl(acpi_gbl_FADT.xpm_timer_block.address);
 }
 
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 5215a5e39f3c..292f4c9a963d 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1428,10 +1428,12 @@ static struct sdma_desc *sdma_transfer_init(struct sdma_channel *sdmac,
 		sdma_config_ownership(sdmac, false, true, false);
 
 	if (sdma_load_context(sdmac))
-		goto err_desc_out;
+		goto err_bd_out;
 
 	return desc;
 
+err_bd_out:
+	sdma_free_bd(desc);
 err_desc_out:
 	kfree(desc);
 err_out:
diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
index 7223c4b9dc70..9dfa545427ca 100644
--- a/drivers/extcon/extcon-usbc-tusb320.c
+++ b/drivers/extcon/extcon-usbc-tusb320.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/**
+/*
  * drivers/extcon/extcon-tusb320.c - TUSB320 extcon driver
  *
  * Copyright (C) 2020 National Instruments Corporation
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index a8ff4c9508b7..11842497b226 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -783,6 +783,8 @@ static int do_xfer(const struct scmi_protocol_handle *ph,
 			      xfer->hdr.protocol_id, xfer->hdr.seq,
 			      xfer->hdr.poll_completion);
 
+	/* Clear any stale status */
+	xfer->hdr.status = SCMI_SUCCESS;
 	xfer->state = SCMI_XFER_SENT_OK;
 	/*
 	 * Even though spinlocking is not needed here since no race is possible
diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index bd0e0fe2f627..944e5e5ff134 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -626,6 +626,7 @@ static const struct attribute_group ps_device_attribute_group = {
 
 static int dualsense_get_calibration_data(struct dualsense *ds)
 {
+	struct hid_device *hdev = ds->base.hdev;
 	short gyro_pitch_bias, gyro_pitch_plus, gyro_pitch_minus;
 	short gyro_yaw_bias, gyro_yaw_plus, gyro_yaw_minus;
 	short gyro_roll_bias, gyro_roll_plus, gyro_roll_minus;
@@ -636,6 +637,7 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	int speed_2x;
 	int range_2g;
 	int ret = 0;
+	int i;
 	uint8_t *buf;
 
 	buf = kzalloc(DS_FEATURE_REPORT_CALIBRATION_SIZE, GFP_KERNEL);
@@ -687,6 +689,21 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	ds->gyro_calib_data[2].sens_numer = speed_2x*DS_GYRO_RES_PER_DEG_S;
 	ds->gyro_calib_data[2].sens_denom = gyro_roll_plus - gyro_roll_minus;
 
+	/*
+	 * Sanity check gyro calibration data. This is needed to prevent crashes
+	 * during report handling of virtual, clone or broken devices not implementing
+	 * calibration data properly.
+	 */
+	for (i = 0; i < ARRAY_SIZE(ds->gyro_calib_data); i++) {
+		if (ds->gyro_calib_data[i].sens_denom == 0) {
+			hid_warn(hdev, "Invalid gyro calibration data for axis (%d), disabling calibration.",
+					ds->gyro_calib_data[i].abs_code);
+			ds->gyro_calib_data[i].bias = 0;
+			ds->gyro_calib_data[i].sens_numer = DS_GYRO_RANGE;
+			ds->gyro_calib_data[i].sens_denom = S16_MAX;
+		}
+	}
+
 	/*
 	 * Set accelerometer calibration and normalization parameters.
 	 * Data values will be normalized to 1/DS_ACC_RES_PER_G g.
@@ -709,6 +726,21 @@ static int dualsense_get_calibration_data(struct dualsense *ds)
 	ds->accel_calib_data[2].sens_numer = 2*DS_ACC_RES_PER_G;
 	ds->accel_calib_data[2].sens_denom = range_2g;
 
+	/*
+	 * Sanity check accelerometer calibration data. This is needed to prevent crashes
+	 * during report handling of virtual, clone or broken devices not implementing calibration
+	 * data properly.
+	 */
+	for (i = 0; i < ARRAY_SIZE(ds->accel_calib_data); i++) {
+		if (ds->accel_calib_data[i].sens_denom == 0) {
+			hid_warn(hdev, "Invalid accelerometer calibration data for axis (%d), disabling calibration.",
+					ds->accel_calib_data[i].abs_code);
+			ds->accel_calib_data[i].bias = 0;
+			ds->accel_calib_data[i].sens_numer = DS_ACC_RANGE;
+			ds->accel_calib_data[i].sens_denom = S16_MAX;
+		}
+	}
+
 err_free:
 	kfree(buf);
 	return ret;
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 8c98fa507768..1864bdadf3dd 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1050,10 +1050,10 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 			     const struct nls_table *cp, int remap, const char *path,
 			     const struct dfs_cache_tgt_iterator *it)
 {
-	int rc;
-	const char *npath;
-	struct cache_entry *ce;
 	struct cache_dfs_tgt *t;
+	struct cache_entry *ce;
+	const char *npath;
+	int rc = 0;
 
 	npath = dfs_cache_canonical_path(path, cp, remap);
 	if (IS_ERR(npath))
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 7a6df35fdc91..73b86b5c1a75 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -700,12 +700,16 @@ static int z_erofs_iomap_begin_report(struct inode *inode, loff_t offset,
 		iomap->type = IOMAP_HOLE;
 		iomap->addr = IOMAP_NULL_ADDR;
 		/*
-		 * No strict rule how to describe extents for post EOF, yet
-		 * we need do like below. Otherwise, iomap itself will get
+		 * No strict rule on how to describe extents for post EOF, yet
+		 * we need to do like below. Otherwise, iomap itself will get
 		 * into an endless loop on post EOF.
+		 *
+		 * Calculate the effective offset by subtracting extent start
+		 * (map.m_la) from the requested offset, and add it to length.
+		 * (NB: offset >= map.m_la always)
 		 */
 		if (iomap->offset >= inode->i_size)
-			iomap->length = length + map.m_la - offset;
+			iomap->length = length + offset - map.m_la;
 	}
 	iomap->flags = 0;
 	return 0;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 405c68085055..589ed99856f3 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1445,8 +1445,6 @@ static void ext4_update_super(struct super_block *sb,
 	 * active. */
 	ext4_r_blocks_count_set(es, ext4_r_blocks_count(es) +
 				reserved_blocks);
-	ext4_superblock_csum_set(sb);
-	unlock_buffer(sbi->s_sbh);
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeclusters_counter,
@@ -1474,6 +1472,8 @@ static void ext4_update_super(struct super_block *sb,
 	ext4_calculate_overhead(sb);
 	es->s_overhead_clusters = cpu_to_le32(sbi->s_overhead);
 
+	ext4_superblock_csum_set(sb);
+	unlock_buffer(sbi->s_sbh);
 	if (test_opt(sb, DEBUG))
 		printk(KERN_DEBUG "EXT4-fs: added group %u:"
 		       "%llu blocks(%llu free %llu reserved)\n", flex_gd->count,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c289010b0964..4daf1e044556 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -793,6 +793,9 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 		return -EPERM;
 	if (unlikely(!nmi_uaccess_okay()))
 		return -EPERM;
+	/* Task should not be pid=1 to avoid kernel panic. */
+	if (unlikely(is_global_init(current)))
+		return -EPERM;
 
 	if (irqs_disabled()) {
 		/* Do an early check on signal validity. Otherwise,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 2337e9275863..9f82fe0e6270 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4415,6 +4415,19 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 	struct hci_ev_sync_conn_complete *ev = (void *) skb->data;
 	struct hci_conn *conn;
 
+	switch (ev->link_type) {
+	case SCO_LINK:
+	case ESCO_LINK:
+		break;
+	default:
+		/* As per Core 5.3 Vol 4 Part E 7.7.35 (p.2219), Link_Type
+		 * for HCI_Synchronous_Connection_Complete is limited to
+		 * either SCO or eSCO
+		 */
+		bt_dev_err(hdev, "Ignoring connect complete event for invalid link type");
+		return;
+	}
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 058ec2f17da6..2d3f82b62236 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3884,7 +3884,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 
 	skb_shinfo(skb)->frag_list = NULL;
 
-	do {
+	while (list_skb) {
 		nskb = list_skb;
 		list_skb = list_skb->next;
 
@@ -3930,8 +3930,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		if (skb_needs_linearize(nskb, features) &&
 		    __skb_linearize(nskb))
 			goto err_linearize;
-
-	} while (list_skb);
+	}
 
 	skb->truesize = skb->truesize - delta_truesize;
 	skb->data_len = skb->data_len - delta_len;
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index a77fafbc31cf..77137a8627d0 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -294,6 +294,11 @@ static void mctp_sk_unhash(struct sock *sk)
 	synchronize_rcu();
 }
 
+static void mctp_sk_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+}
+
 static struct proto mctp_proto = {
 	.name		= "MCTP",
 	.owner		= THIS_MODULE,
@@ -330,6 +335,7 @@ static int mctp_pf_create(struct net *net, struct socket *sock,
 		return -ENOMEM;
 
 	sock_init_data(sock, sk);
+	sk->sk_destruct = mctp_sk_destruct;
 
 	rc = 0;
 	if (sk->sk_prot->init)
diff --git a/tools/include/linux/kernel.h b/tools/include/linux/kernel.h
index c2e109860fbc..5a79572f8b2d 100644
--- a/tools/include/linux/kernel.h
+++ b/tools/include/linux/kernel.h
@@ -108,7 +108,9 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
 int scnprintf(char * buf, size_t size, const char * fmt, ...);
 int scnprintf_pad(char * buf, size_t size, const char * fmt, ...);
 
+#ifndef ARRAY_SIZE
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#endif
 
 /*
  * This looks more complex than it should be. But we need to
diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
index 8d50483fe204..898d7b2fac6c 100644
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -48,6 +48,25 @@
 #include <stdarg.h>
 #include <stdio.h>
 
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#endif
+
+/*
+ * gcc cpuid.h provides __cpuid_count() since v4.4.
+ * Clang/LLVM cpuid.h provides  __cpuid_count() since v3.4.0.
+ *
+ * Provide local define for tests needing __cpuid_count() because
+ * selftests need to work in older environments that do not yet
+ * have __cpuid_count().
+ */
+#ifndef __cpuid_count
+#define __cpuid_count(level, count, a, b, c, d)				\
+	__asm__ __volatile__ ("cpuid\n\t"				\
+			      : "=a" (a), "=b" (b), "=c" (c), "=d" (d)	\
+			      : "0" (level), "2" (count))
+#endif
+
 /* define kselftest exit codes */
 #define KSFT_PASS  0
 #define KSFT_FAIL  1
diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 78e59620d28d..11779405dc80 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -671,7 +671,9 @@
 #define EXPECT_STRNE(expected, seen) \
 	__EXPECT_STR(expected, seen, !=, 0)
 
+#ifndef ARRAY_SIZE
 #define ARRAY_SIZE(a)	(sizeof(a) / sizeof(a[0]))
+#endif
 
 /* Support an optional handler after and ASSERT_* or EXPECT_*.  The approach is
  * not thread-safe, but it should be fine in most sane test scenarios.
diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index e3ce33a9954e..58775dab3cc6 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -22,7 +22,6 @@
 #define VALIDATION_DEFAULT_THRESHOLD 4	/* 4MB */
 #define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
 
 struct config {
diff --git a/tools/testing/selftests/vm/pkey-helpers.h b/tools/testing/selftests/vm/pkey-helpers.h
index 622a85848f61..92f3be3dd8e5 100644
--- a/tools/testing/selftests/vm/pkey-helpers.h
+++ b/tools/testing/selftests/vm/pkey-helpers.h
@@ -13,6 +13,8 @@
 #include <ucontext.h>
 #include <sys/mman.h>
 
+#include "../kselftest.h"
+
 /* Define some kernel-like types */
 #define  u8 __u8
 #define u16 __u16
@@ -175,7 +177,6 @@ static inline void __pkey_write_allow(int pkey, int do_allow_write)
 	dprintf4("pkey_reg now: %016llx\n", read_pkey_reg());
 }
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
 #define ALIGN_UP(x, align_to)	(((x) + ((align_to)-1)) & ~((align_to)-1))
 #define ALIGN_DOWN(x, align_to) ((x) & ~((align_to)-1))
 #define ALIGN_PTR_UP(p, ptr_align_to)	\
diff --git a/tools/testing/selftests/vm/va_128TBswitch.c b/tools/testing/selftests/vm/va_128TBswitch.c
index 83acdff26a13..da6ec3b53ea8 100644
--- a/tools/testing/selftests/vm/va_128TBswitch.c
+++ b/tools/testing/selftests/vm/va_128TBswitch.c
@@ -9,7 +9,7 @@
 #include <sys/mman.h>
 #include <string.h>
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#include "../kselftest.h"
 
 #ifdef __powerpc64__
 #define PAGE_SIZE	(64 << 10)
