Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7D64B881A
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 13:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiBPMvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 07:51:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiBPMvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 07:51:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4942A4A3E;
        Wed, 16 Feb 2022 04:50:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48029B81EDB;
        Wed, 16 Feb 2022 12:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EAEC004E1;
        Wed, 16 Feb 2022 12:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645015842;
        bh=/joVoQm5HDUj5PAbpoQr+JrUHFU8AWy/FhRmE68pUBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRefNpYV3dJq/q7sDzaIgwBLBEbBHKZhsGL85n8jksEuw8dLMmzmWSH6WTBBF6SOM
         Wxd5mWp7gycna9ArJmv0QVTcfwmxJ43i1JCj6oM95BxP40NXut2XiwgvuNcJM6eBCp
         Ma/aQiqwlxLuFojxcbqEJ4WrBSM4koJ0DPFbU3ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.267
Date:   Wed, 16 Feb 2022 13:50:31 +0100
Message-Id: <1645015830150245@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <16450158304177@kroah.com>
References: <16450158304177@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 694968c7523c..3c8f5bfdf6da 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -91,6 +91,7 @@ show up in /proc/sys/kernel:
 - sysctl_writes_strict
 - tainted
 - threads-max
+- unprivileged_bpf_disabled
 - unknown_nmi_panic
 - watchdog
 - watchdog_thresh
@@ -999,6 +1000,26 @@ available RAM pages threads-max is reduced accordingly.
 
 ==============================================================
 
+unprivileged_bpf_disabled:
+
+Writing 1 to this entry will disable unprivileged calls to bpf();
+once disabled, calling bpf() without CAP_SYS_ADMIN will return
+-EPERM. Once set to 1, this can't be cleared from the running kernel
+anymore.
+
+Writing 2 to this entry will also disable unprivileged calls to bpf(),
+however, an admin can still change this setting later on, if needed, by
+writing 0 or 1 to this entry.
+
+If BPF_UNPRIV_DEFAULT_OFF is enabled in the kernel config, then this
+entry will default to 2 instead of 0.
+
+  0 - Unprivileged calls to bpf() are enabled
+  1 - Unprivileged calls to bpf() are disabled without recovery
+  2 - Unprivileged calls to bpf() are disabled
+
+==============================================================
+
 unknown_nmi_panic:
 
 The value in this file affects behavior of handling NMI. When the
diff --git a/Makefile b/Makefile
index 1fe02d57d6a7..d953c6f478aa 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 266
+SUBLEVEL = 267
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/boot/dts/imx23-evk.dts b/arch/arm/boot/dts/imx23-evk.dts
index 57e29977ba06..acaa3a7c2fc6 100644
--- a/arch/arm/boot/dts/imx23-evk.dts
+++ b/arch/arm/boot/dts/imx23-evk.dts
@@ -48,7 +48,6 @@
 						MX23_PAD_LCD_RESET__GPIO_1_18
 						MX23_PAD_PWM3__GPIO_1_29
 						MX23_PAD_PWM4__GPIO_1_30
-						MX23_PAD_SSP1_DETECT__SSP1_DETECT
 					>;
 					fsl,drive-strength = <MXS_DRIVE_4mA>;
 					fsl,voltage = <MXS_VOLTAGE_HIGH>;
diff --git a/arch/arm/boot/dts/imx6qdl-udoo.dtsi b/arch/arm/boot/dts/imx6qdl-udoo.dtsi
index fc4ae2e423bd..b0fdcae66ead 100644
--- a/arch/arm/boot/dts/imx6qdl-udoo.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-udoo.dtsi
@@ -9,6 +9,8 @@
  *
  */
 
+#include <dt-bindings/gpio/gpio.h>
+
 / {
 	aliases {
 		backlight = &backlight;
@@ -201,6 +203,7 @@
 				MX6QDL_PAD_SD3_DAT1__SD3_DATA1		0x17059
 				MX6QDL_PAD_SD3_DAT2__SD3_DATA2		0x17059
 				MX6QDL_PAD_SD3_DAT3__SD3_DATA3		0x17059
+				MX6QDL_PAD_SD3_DAT5__GPIO7_IO00		0x1b0b0
 			>;
 		};
 
@@ -267,7 +270,7 @@
 &usdhc3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_usdhc3>;
-	non-removable;
+	cd-gpios = <&gpio7 0 GPIO_ACTIVE_LOW>;
 	status = "okay";
 };
 
diff --git a/arch/arm/boot/dts/meson.dtsi b/arch/arm/boot/dts/meson.dtsi
index cd6ad072e72c..05dfd74a4004 100644
--- a/arch/arm/boot/dts/meson.dtsi
+++ b/arch/arm/boot/dts/meson.dtsi
@@ -86,14 +86,14 @@
 			};
 
 			uart_A: serial@84c0 {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart";
 				reg = <0x84c0 0x18>;
 				interrupts = <GIC_SPI 26 IRQ_TYPE_EDGE_RISING>;
 				status = "disabled";
 			};
 
 			uart_B: serial@84dc {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart";
 				reg = <0x84dc 0x18>;
 				interrupts = <GIC_SPI 75 IRQ_TYPE_EDGE_RISING>;
 				status = "disabled";
@@ -131,7 +131,7 @@
 			};
 
 			uart_C: serial@8700 {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart";
 				reg = <0x8700 0x18>;
 				interrupts = <GIC_SPI 93 IRQ_TYPE_EDGE_RISING>;
 				status = "disabled";
@@ -196,7 +196,7 @@
 			};
 
 			uart_AO: serial@4c0 {
-				compatible = "amlogic,meson6-uart", "amlogic,meson-ao-uart", "amlogic,meson-uart";
+				compatible = "amlogic,meson6-uart", "amlogic,meson-ao-uart";
 				reg = <0x4c0 0x18>;
 				interrupts = <GIC_SPI 90 IRQ_TYPE_EDGE_RISING>;
 				status = "disabled";
diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 123b870728fb..987a1a37f097 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -294,7 +294,7 @@ static int i8k_get_fan_nominal_speed(int fan, int speed)
 }
 
 /*
- * Set the fan speed (off, low, high). Returns the new fan status.
+ * Set the fan speed (off, low, high, ...).
  */
 static int i8k_set_fan(int fan, int speed)
 {
@@ -303,7 +303,7 @@ static int i8k_set_fan(int fan, int speed)
 	speed = (speed < 0) ? 0 : ((speed > i8k_fan_max) ? i8k_fan_max : speed);
 	regs.ebx = (fan & 0xff) | (speed << 8);
 
-	return i8k_smm(&regs) ? : i8k_get_fan_status(fan);
+	return i8k_smm(&regs);
 }
 
 static int i8k_get_temp_type(int sensor)
@@ -417,7 +417,7 @@ static int
 i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	int val = 0;
-	int speed;
+	int speed, err;
 	unsigned char buff[16];
 	int __user *argp = (int __user *)arg;
 
@@ -478,7 +478,11 @@ i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&speed, argp + 1, sizeof(int)))
 			return -EFAULT;
 
-		val = i8k_set_fan(val, speed);
+		err = i8k_set_fan(val, speed);
+		if (err < 0)
+			return err;
+
+		val = i8k_get_fan_status(val);
 		break;
 
 	default:
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 9a1ab39ee35e..3f00a7fc79b5 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -427,12 +427,16 @@ static void esdhc_of_adma_workaround(struct sdhci_host *host, u32 intmask)
 
 static int esdhc_of_enable_dma(struct sdhci_host *host)
 {
+	int ret;
 	u32 value;
 	struct device *dev = mmc_dev(host->mmc);
 
 	if (of_device_is_compatible(dev->of_node, "fsl,ls1043a-esdhc") ||
-	    of_device_is_compatible(dev->of_node, "fsl,ls1046a-esdhc"))
-		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
+	    of_device_is_compatible(dev->of_node, "fsl,ls1046a-esdhc")) {
+		ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
+		if (ret)
+			return ret;
+	}
 
 	value = sdhci_readl(host, ESDHC_DMA_SYSCTL);
 
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 93dfcef8afc4..035923876c61 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1012,8 +1012,8 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 				if (port->aggregator &&
 				    port->aggregator->is_active &&
 				    !__port_is_enabled(port)) {
-
 					__enable_port(port);
+					*update_slave_arr = true;
 				}
 			}
 			break;
@@ -1760,6 +1760,7 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 			     port = port->next_port_in_aggregator) {
 				__enable_port(port);
 			}
+			*update_slave_arr = true;
 		}
 	}
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 82d1f416ee2a..569e6d3d066b 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -400,6 +400,9 @@ static void xgbe_pci_remove(struct pci_dev *pdev)
 
 	pci_free_irq_vectors(pdata->pcidev);
 
+	/* Disable all interrupts in the hardware */
+	XP_IOWRITE(pdata, XP_INT_EN, 0x0);
+
 	xgbe_free_pdata(pdata);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 8e60315a087c..1027831e5d81 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -630,7 +630,7 @@ static int sun8i_dwmac_reset(struct stmmac_priv *priv)
 
 	if (err) {
 		dev_err(priv->device, "EMAC reset timeout\n");
-		return -EFAULT;
+		return err;
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index d2ba466613c0..7876e56a5b5d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -279,16 +279,6 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
 
-	/* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has finished */
-	ret = read_poll_timeout(axienet_ior, value,
-				value & XAE_INT_PHYRSTCMPLT_MASK,
-				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
-				XAE_IS_OFFSET);
-	if (ret) {
-		dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n", __func__);
-		return ret;
-	}
-
 	return 0;
 out:
 	axienet_dma_bd_release(ndev);
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 3d8d76593293..ffa769323c3e 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -907,16 +907,15 @@ static int m88e1118_config_aneg(struct phy_device *phydev)
 {
 	int err;
 
-	err = genphy_soft_reset(phydev);
+	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
 	if (err < 0)
 		return err;
 
-	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
+	err = genphy_config_aneg(phydev);
 	if (err < 0)
 		return err;
 
-	err = genphy_config_aneg(phydev);
-	return 0;
+	return genphy_soft_reset(phydev);
 }
 
 static int m88e1118_config_init(struct phy_device *phydev)
diff --git a/drivers/staging/fbtft/fbtft.h b/drivers/staging/fbtft/fbtft.h
index 488ab788138e..b086e8e5b4dd 100644
--- a/drivers/staging/fbtft/fbtft.h
+++ b/drivers/staging/fbtft/fbtft.h
@@ -342,7 +342,10 @@ static int __init fbtft_driver_module_init(void)                           \
 	ret = spi_register_driver(&fbtft_driver_spi_driver);               \
 	if (ret < 0)                                                       \
 		return ret;                                                \
-	return platform_driver_register(&fbtft_driver_platform_driver);    \
+	ret = platform_driver_register(&fbtft_driver_platform_driver);     \
+	if (ret < 0)                                                       \
+		spi_unregister_driver(&fbtft_driver_spi_driver);           \
+	return ret;                                                        \
 }                                                                          \
 									   \
 static void __exit fbtft_driver_module_exit(void)                          \
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 16e7516052a4..2b78843091a2 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -448,6 +448,9 @@ static bool iscsit_tpg_check_network_portal(
 				break;
 		}
 		spin_unlock(&tpg->tpg_np_lock);
+
+		if (match)
+			break;
 	}
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 8214b0326b3a..690cb5a63f9a 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1377,7 +1377,7 @@ n_tty_receive_char_special(struct tty_struct *tty, unsigned char c)
 			put_tty_queue(c, ldata);
 			smp_store_release(&ldata->canon_head, ldata->read_head);
 			kill_fasync(&tty->fasync, SIGIO, POLL_IN);
-			wake_up_interruptible_poll(&tty->read_wait, POLLIN);
+			wake_up_interruptible_poll(&tty->read_wait, POLLIN | POLLRDNORM);
 			return 0;
 		}
 	}
@@ -1658,7 +1658,7 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 
 	if (read_cnt(ldata)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
-		wake_up_interruptible_poll(&tty->read_wait, POLLIN);
+		wake_up_interruptible_poll(&tty->read_wait, POLLIN | POLLRDNORM);
 	}
 }
 
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index cca8c84edfbc..6bc9af583d6d 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -691,6 +691,7 @@ int vt_ioctl(struct tty_struct *tty,
 			ret =  -ENXIO;
 		else {
 			arg--;
+			arg = array_index_nospec(arg, MAX_NR_CONSOLES);
 			console_lock();
 			ret = vc_allocate(arg);
 			console_unlock();
@@ -715,9 +716,9 @@ int vt_ioctl(struct tty_struct *tty,
 		if (vsa.console == 0 || vsa.console > MAX_NR_CONSOLES)
 			ret = -ENXIO;
 		else {
-			vsa.console = array_index_nospec(vsa.console,
-							 MAX_NR_CONSOLES + 1);
 			vsa.console--;
+			vsa.console = array_index_nospec(vsa.console,
+							 MAX_NR_CONSOLES);
 			console_lock();
 			ret = vc_allocate(vsa.console);
 			if (ret == 0) {
diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index 4f6e131a3d58..21b012813376 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -135,6 +135,7 @@ static const struct attribute_group *ulpi_dev_attr_groups[] = {
 
 static void ulpi_dev_release(struct device *dev)
 {
+	of_node_put(dev->of_node);
 	kfree(to_ulpi_dev(dev));
 }
 
@@ -251,12 +252,16 @@ static int ulpi_register(struct device *dev, struct ulpi *ulpi)
 		return ret;
 
 	ret = ulpi_read_id(ulpi);
-	if (ret)
+	if (ret) {
+		of_node_put(ulpi->dev.of_node);
 		return ret;
+	}
 
 	ret = device_register(&ulpi->dev);
-	if (ret)
+	if (ret) {
+		put_device(&ulpi->dev);
 		return ret;
+	}
 
 	dev_dbg(&ulpi->dev, "registered ULPI PHY: vendor %04x, product %04x\n",
 		ulpi->id.vendor, ulpi->id.product);
@@ -303,7 +308,6 @@ EXPORT_SYMBOL_GPL(ulpi_register_interface);
  */
 void ulpi_unregister_interface(struct ulpi *ulpi)
 {
-	of_node_put(ulpi->dev.of_node);
 	device_unregister(&ulpi->dev);
 }
 EXPORT_SYMBOL_GPL(ulpi_unregister_interface);
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index f1edc5727000..dddc5d02b552 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4783,7 +4783,7 @@ int dwc2_hsotg_suspend(struct dwc2_hsotg *hsotg)
 		hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 		spin_unlock_irqrestore(&hsotg->lock, flags);
 
-		for (ep = 0; ep < hsotg->num_of_eps; ep++) {
+		for (ep = 1; ep < hsotg->num_of_eps; ep++) {
 			if (hsotg->eps_in[ep])
 				dwc2_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
 			if (hsotg->eps_out[ep])
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index d0cfd3a0819d..dcbd3e0ec2d9 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1004,6 +1004,19 @@ static void __dwc3_prepare_one_trb(struct dwc3_ep *dep, struct dwc3_trb *trb,
 	if (usb_endpoint_xfer_bulk(dep->endpoint.desc) && dep->stream_capable)
 		trb->ctrl |= DWC3_TRB_CTRL_SID_SOFN(stream_id);
 
+	/*
+	 * As per data book 4.2.3.2TRB Control Bit Rules section
+	 *
+	 * The controller autonomously checks the HWO field of a TRB to determine if the
+	 * entire TRB is valid. Therefore, software must ensure that the rest of the TRB
+	 * is valid before setting the HWO field to '1'. In most systems, this means that
+	 * software must update the fourth DWORD of a TRB last.
+	 *
+	 * However there is a possibility of CPU re-ordering here which can cause
+	 * controller to observe the HWO bit set prematurely.
+	 * Add a write memory barrier to prevent CPU re-ordering.
+	 */
+	wmb();
 	trb->ctrl |= DWC3_TRB_CTRL_HWO;
 
 	dwc3_ep_inc_enq(dep);
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index b407f907d655..537af6769b40 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1940,6 +1940,9 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 				if (w_index != 0x5 || (w_value >> 8))
 					break;
 				interface = w_value & 0xFF;
+				if (interface >= MAX_CONFIG_INTERFACES ||
+				    !os_desc_cfg->interface[interface])
+					break;
 				buf[6] = w_index;
 				if (w_length == 0x0A) {
 					count = count_ext_prop(os_desc_cfg,
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 61795025f11b..13a38ed806df 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1626,16 +1626,24 @@ static void ffs_data_put(struct ffs_data *ffs)
 
 static void ffs_data_closed(struct ffs_data *ffs)
 {
+	struct ffs_epfile *epfiles;
+	unsigned long flags;
+
 	ENTER();
 
 	if (atomic_dec_and_test(&ffs->opened)) {
 		if (ffs->no_disconnect) {
 			ffs->state = FFS_DEACTIVATED;
-			if (ffs->epfiles) {
-				ffs_epfiles_destroy(ffs->epfiles,
-						   ffs->eps_count);
-				ffs->epfiles = NULL;
-			}
+			spin_lock_irqsave(&ffs->eps_lock, flags);
+			epfiles = ffs->epfiles;
+			ffs->epfiles = NULL;
+			spin_unlock_irqrestore(&ffs->eps_lock,
+							flags);
+
+			if (epfiles)
+				ffs_epfiles_destroy(epfiles,
+						 ffs->eps_count);
+
 			if (ffs->setup_state == FFS_SETUP_PENDING)
 				__ffs_ep0_stall(ffs);
 		} else {
@@ -1682,14 +1690,27 @@ static struct ffs_data *ffs_data_new(const char *dev_name)
 
 static void ffs_data_clear(struct ffs_data *ffs)
 {
+	struct ffs_epfile *epfiles;
+	unsigned long flags;
+
 	ENTER();
 
 	ffs_closed(ffs);
 
 	BUG_ON(ffs->gadget);
 
-	if (ffs->epfiles) {
-		ffs_epfiles_destroy(ffs->epfiles, ffs->eps_count);
+	spin_lock_irqsave(&ffs->eps_lock, flags);
+	epfiles = ffs->epfiles;
+	ffs->epfiles = NULL;
+	spin_unlock_irqrestore(&ffs->eps_lock, flags);
+
+	/*
+	 * potential race possible between ffs_func_eps_disable
+	 * & ffs_epfile_release therefore maintaining a local
+	 * copy of epfile will save us from use-after-free.
+	 */
+	if (epfiles) {
+		ffs_epfiles_destroy(epfiles, ffs->eps_count);
 		ffs->epfiles = NULL;
 	}
 
@@ -1837,12 +1858,15 @@ static void ffs_epfiles_destroy(struct ffs_epfile *epfiles, unsigned count)
 
 static void ffs_func_eps_disable(struct ffs_function *func)
 {
-	struct ffs_ep *ep         = func->eps;
-	struct ffs_epfile *epfile = func->ffs->epfiles;
-	unsigned count            = func->ffs->eps_count;
+	struct ffs_ep *ep;
+	struct ffs_epfile *epfile;
+	unsigned short count;
 	unsigned long flags;
 
 	spin_lock_irqsave(&func->ffs->eps_lock, flags);
+	count = func->ffs->eps_count;
+	epfile = func->ffs->epfiles;
+	ep = func->eps;
 	while (count--) {
 		/* pending requests get nuked */
 		if (likely(ep->ep))
@@ -1860,14 +1884,18 @@ static void ffs_func_eps_disable(struct ffs_function *func)
 
 static int ffs_func_eps_enable(struct ffs_function *func)
 {
-	struct ffs_data *ffs      = func->ffs;
-	struct ffs_ep *ep         = func->eps;
-	struct ffs_epfile *epfile = ffs->epfiles;
-	unsigned count            = ffs->eps_count;
+	struct ffs_data *ffs;
+	struct ffs_ep *ep;
+	struct ffs_epfile *epfile;
+	unsigned short count;
 	unsigned long flags;
 	int ret = 0;
 
 	spin_lock_irqsave(&func->ffs->eps_lock, flags);
+	ffs = func->ffs;
+	ep = func->eps;
+	epfile = ffs->epfiles;
+	count = ffs->eps_count;
 	while(count--) {
 		ep->ep->driver_data = ep;
 
diff --git a/drivers/usb/gadget/function/rndis.c b/drivers/usb/gadget/function/rndis.c
index d6341045c631..743d41c6952b 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -640,14 +640,17 @@ static int rndis_set_response(struct rndis_params *params,
 	rndis_set_cmplt_type *resp;
 	rndis_resp_t *r;
 
+	BufLength = le32_to_cpu(buf->InformationBufferLength);
+	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
+	if ((BufLength > RNDIS_MAX_TOTAL_SIZE) ||
+	    (BufOffset + 8 >= RNDIS_MAX_TOTAL_SIZE))
+		    return -EINVAL;
+
 	r = rndis_add_response(params, sizeof(rndis_set_cmplt_type));
 	if (!r)
 		return -ENOMEM;
 	resp = (rndis_set_cmplt_type *)r->buf;
 
-	BufLength = le32_to_cpu(buf->InformationBufferLength);
-	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
-
 #ifdef	VERBOSE_DEBUG
 	pr_debug("%s: Length: %d\n", __func__, BufLength);
 	pr_debug("%s: Offset: %d\n", __func__, BufOffset);
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 4ae7afc68bde..71da297e148d 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -87,6 +87,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7522) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
+	{ USB_DEVICE(0x2184, 0x0057) },
 	{ USB_DEVICE(0x4348, 0x5523) },
 	{ USB_DEVICE(0x9986, 0x7523) },
 	{ },
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 6f00b11969c8..e3e711953a8a 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -55,6 +55,7 @@ static int cp210x_port_remove(struct usb_serial_port *);
 static void cp210x_dtr_rts(struct usb_serial_port *p, int on);
 
 static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE(0x0404, 0x034C) },	/* NCR Retail IO Box */
 	{ USB_DEVICE(0x045B, 0x0053) }, /* Renesas RX610 RX-Stick */
 	{ USB_DEVICE(0x0471, 0x066A) }, /* AKTAKOM ACE-1001 cable */
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
@@ -72,6 +73,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0FCF, 0x1004) }, /* Dynastream ANT2USB */
 	{ USB_DEVICE(0x0FCF, 0x1006) }, /* Dynastream ANT development board */
 	{ USB_DEVICE(0x0FDE, 0xCA05) }, /* OWL Wireless Electricity Monitor CM-160 */
+	{ USB_DEVICE(0x106F, 0x0003) },	/* CPI / Money Controls Bulk Coin Recycler */
 	{ USB_DEVICE(0x10A6, 0xAA26) }, /* Knock-off DCU-11 cable */
 	{ USB_DEVICE(0x10AB, 0x10C5) }, /* Siemens MC60 Cable */
 	{ USB_DEVICE(0x10B5, 0xAC70) }, /* Nokia CA-42 USB */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index bcf4ba4f9819..4857e79d0744 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -964,6 +964,7 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_VX_023_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_VX_034_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_101_PID) },
+	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_159_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_1_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_3_PID) },
@@ -972,12 +973,14 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_6_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_7_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_160_8_PID) },
+	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_235_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_257_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_1_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_2_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_3_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_279_4_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_313_PID) },
+	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_320_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_324_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_346_1_PID) },
 	{ USB_DEVICE(BRAINBOXES_VID, BRAINBOXES_US_346_2_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 755858ca20ba..d1a9564697a4 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1506,6 +1506,9 @@
 #define BRAINBOXES_VX_023_PID		0x1003 /* VX-023 ExpressCard 1 Port RS422/485 */
 #define BRAINBOXES_VX_034_PID		0x1004 /* VX-034 ExpressCard 2 Port RS422/485 */
 #define BRAINBOXES_US_101_PID		0x1011 /* US-101 1xRS232 */
+#define BRAINBOXES_US_159_PID		0x1021 /* US-159 1xRS232 */
+#define BRAINBOXES_US_235_PID		0x1017 /* US-235 1xRS232 */
+#define BRAINBOXES_US_320_PID		0x1019 /* US-320 1xRS422/485 */
 #define BRAINBOXES_US_324_PID		0x1013 /* US-324 1xRS422/485 1Mbaud */
 #define BRAINBOXES_US_606_1_PID		0x2001 /* US-606 6 Port RS232 Serial Port 1 and 2 */
 #define BRAINBOXES_US_606_2_PID		0x2002 /* US-606 6 Port RS232 Serial Port 3 and 4 */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index b101a505c74b..2a951793e08b 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1652,6 +1652,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(2) },
 	{ USB_DEVICE_INTERFACE_CLASS(ZTE_VENDOR_ID, 0x1476, 0xff) },	/* GosunCn ZTE WeLink ME3630 (ECM/NCM mode) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1481, 0xff, 0x00, 0x00) }, /* ZTE MF871A */
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1485, 0xff, 0xff, 0xff),  /* ZTE MF286D */
+	  .driver_info = RSVD(5) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1533, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1534, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1535, 0xff, 0xff, 0xff) },
diff --git a/fs/nfs/callback.h b/fs/nfs/callback.h
index a20a0bce40a4..80ad04abcf30 100644
--- a/fs/nfs/callback.h
+++ b/fs/nfs/callback.h
@@ -168,7 +168,7 @@ struct cb_devicenotifyitem {
 };
 
 struct cb_devicenotifyargs {
-	int				 ndevs;
+	uint32_t			 ndevs;
 	struct cb_devicenotifyitem	 *devs;
 };
 
diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index 440ff8e7082b..3998b432e1b9 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -355,7 +355,7 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
 				  struct cb_process_state *cps)
 {
 	struct cb_devicenotifyargs *args = argp;
-	int i;
+	uint32_t i;
 	__be32 res = 0;
 	struct nfs_client *clp = cps->clp;
 	struct nfs_server *server = NULL;
diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 57de914630bc..36c34be839d0 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -265,11 +265,9 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 				void *argp)
 {
 	struct cb_devicenotifyargs *args = argp;
+	uint32_t tmp, n, i;
 	__be32 *p;
 	__be32 status = 0;
-	u32 tmp;
-	int n, i;
-	args->ndevs = 0;
 
 	/* Num of device notifications */
 	p = read_buf(xdr, sizeof(uint32_t));
@@ -278,7 +276,7 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 		goto out;
 	}
 	n = ntohl(*p++);
-	if (n <= 0)
+	if (n == 0)
 		goto out;
 	if (n > ULONG_MAX / sizeof(*args->devs)) {
 		status = htonl(NFS4ERR_BADXDR);
@@ -336,19 +334,21 @@ __be32 decode_devicenotify_args(struct svc_rqst *rqstp,
 			dev->cbd_immediate = 0;
 		}
 
-		args->ndevs++;
-
 		dprintk("%s: type %d layout 0x%x immediate %d\n",
 			__func__, dev->cbd_notify_type, dev->cbd_layout_type,
 			dev->cbd_immediate);
 	}
+	args->ndevs = n;
+	dprintk("%s: ndevs %d\n", __func__, args->ndevs);
+	return 0;
+err:
+	kfree(args->devs);
 out:
+	args->devs = NULL;
+	args->ndevs = 0;
 	dprintk("%s: status %d ndevs %d\n",
 		__func__, ntohl(status), args->ndevs);
 	return status;
-err:
-	kfree(args->devs);
-	goto out;
 }
 
 static __be32 decode_sessionid(struct xdr_stream *xdr,
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 1f74893b2b0c..29072c83fab9 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -179,6 +179,7 @@ struct nfs_client *nfs_alloc_client(const struct nfs_client_initdata *cl_init)
 	INIT_LIST_HEAD(&clp->cl_superblocks);
 	clp->cl_rpcclient = ERR_PTR(-EINVAL);
 
+	clp->cl_flags = cl_init->init_flags;
 	clp->cl_proto = cl_init->proto;
 	clp->cl_net = get_net(cl_init->net);
 
@@ -426,7 +427,6 @@ struct nfs_client *nfs_get_client(const struct nfs_client_initdata *cl_init)
 			list_add_tail(&new->cl_share_link,
 					&nn->nfs_client_list);
 			spin_unlock(&nn->nfs_client_lock);
-			new->cl_flags = cl_init->init_flags;
 			return rpc_ops->init_client(new, cl_init);
 		}
 
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 22cff39cca29..c9ca2237c3fe 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -242,7 +242,8 @@ struct vfsmount *nfs4_submount(struct nfs_server *, struct dentry *,
 			       struct nfs_fh *, struct nfs_fattr *);
 int nfs4_replace_transport(struct nfs_server *server,
 				const struct nfs4_fs_locations *locations);
-
+size_t nfs_parse_server_name(char *string, size_t len, struct sockaddr *sa,
+			     size_t salen, struct net *net);
 /* nfs4proc.c */
 extern int nfs4_handle_exception(struct nfs_server *, int, struct nfs4_exception *);
 extern int nfs4_call_sync(struct rpc_clnt *, struct nfs_server *,
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 02b01b4025f6..c7672c89b967 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1241,8 +1241,11 @@ int nfs4_update_server(struct nfs_server *server, const char *hostname,
 	}
 	nfs_put_client(clp);
 
-	if (server->nfs_client->cl_hostname == NULL)
+	if (server->nfs_client->cl_hostname == NULL) {
 		server->nfs_client->cl_hostname = kstrdup(hostname, GFP_KERNEL);
+		if (server->nfs_client->cl_hostname == NULL)
+			return -ENOMEM;
+	}
 	nfs_server_insert_lists(server);
 
 	return nfs_probe_destination(server);
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index 8c3f327d858d..b36361ca0d36 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -121,8 +121,8 @@ static int nfs4_validate_fspath(struct dentry *dentry,
 	return 0;
 }
 
-static size_t nfs_parse_server_name(char *string, size_t len,
-		struct sockaddr *sa, size_t salen, struct net *net)
+size_t nfs_parse_server_name(char *string, size_t len, struct sockaddr *sa,
+			     size_t salen, struct net *net)
 {
 	ssize_t ret;
 
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index f92bfc787c5f..c0987557d4ab 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2003,6 +2003,9 @@ static int nfs4_try_migration(struct nfs_server *server, struct rpc_cred *cred)
 	}
 
 	result = -NFS4ERR_NXIO;
+	if (!locations->nlocations)
+		goto out;
+
 	if (!(locations->fattr.valid & NFS_ATTR_FATTR_V4_LOCATIONS)) {
 		dprintk("<-- %s: No fs_locations data, migration skipped\n",
 			__func__);
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 3cd04c98da6b..ccdc0ca699c3 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -3731,8 +3731,6 @@ static int decode_attr_fs_locations(struct xdr_stream *xdr, uint32_t *bitmap, st
 	if (unlikely(!p))
 		goto out_overflow;
 	n = be32_to_cpup(p);
-	if (n <= 0)
-		goto out_eio;
 	for (res->nlocations = 0; res->nlocations < n; res->nlocations++) {
 		u32 m;
 		struct nfs4_fs_location *loc;
@@ -4272,10 +4270,11 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 		} else
 			printk(KERN_WARNING "%s: label too long (%u)!\n",
 					__func__, len);
+		if (label && label->label)
+			dprintk("%s: label=%.*s, len=%d, PI=%d, LFS=%d\n",
+				__func__, label->len, (char *)label->label,
+				label->len, label->pi, label->lfs);
 	}
-	if (label && label->label)
-		dprintk("%s: label=%s, len=%d, PI=%d, LFS=%d\n", __func__,
-			(char *)label->label, label->len, label->pi, label->lfs);
 	return status;
 
 out_overflow:
diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index c0de4d6cd857..abd70b672b96 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -199,6 +199,11 @@ nfsd3_proc_write(struct svc_rqst *rqstp)
 				(unsigned long long) argp->offset,
 				argp->stable? " stable" : "");
 
+	resp->status = nfserr_fbig;
+	if (argp->offset > (u64)OFFSET_MAX ||
+	    argp->offset + argp->len > (u64)OFFSET_MAX)
+		return rpc_success;
+
 	fh_copy(&resp->fh, &argp->fh);
 	resp->committed = argp->stable;
 	nfserr = nfsd_write(rqstp, &resp->fh, argp->offset,
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index ee765abad2ef..aec99cd4080a 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1015,8 +1015,9 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	unsigned long cnt;
 	int nvecs;
 
-	if (write->wr_offset >= OFFSET_MAX)
-		return nfserr_inval;
+	if (write->wr_offset > (u64)OFFSET_MAX ||
+	    write->wr_offset + write->wr_buflen > (u64)OFFSET_MAX)
+		return nfserr_fbig;
 
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 						stateid, WR_STATE, &filp, NULL);
diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 0b3c2aaed3c8..177b1aabf95d 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -121,8 +121,20 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 
 	memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
 	       sizeof(struct ip_tunnel_info) + md_size);
+#ifdef CONFIG_DST_CACHE
+	/* Unclone the dst cache if there is one */
+	if (new_md->u.tun_info.dst_cache.cache) {
+		int ret;
+
+		ret = dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
+		if (ret) {
+			metadata_dst_free(new_md);
+			return ERR_PTR(ret);
+		}
+	}
+#endif
+
 	skb_dst_drop(skb);
-	dst_hold(&new_md->dst);
 	skb_dst_set(skb, &new_md->dst);
 	return new_md;
 }
diff --git a/init/Kconfig b/init/Kconfig
index be58f0449c68..c87858c434cc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1378,6 +1378,16 @@ config ADVISE_SYSCALLS
 	  applications use these syscalls, you can disable this option to save
 	  space.
 
+config BPF_UNPRIV_DEFAULT_OFF
+	bool "Disable unprivileged BPF by default"
+	depends on BPF_SYSCALL
+	help
+	  Disables unprivileged BPF by default by setting the corresponding
+	  /proc/sys/kernel/unprivileged_bpf_disabled knob to 2. An admin can
+	  still reenable it by setting it to 0 later on, or permanently
+	  disable it by setting it to 1 (from which no other transition to
+	  0 is possible anymore).
+
 config USERFAULTFD
 	bool "Enable userfaultfd() system call"
 	select ANON_INODES
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 21073682061d..59d44f1ad958 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -37,7 +37,8 @@ static DEFINE_SPINLOCK(prog_idr_lock);
 static DEFINE_IDR(map_idr);
 static DEFINE_SPINLOCK(map_idr_lock);
 
-int sysctl_unprivileged_bpf_disabled __read_mostly;
+int sysctl_unprivileged_bpf_disabled __read_mostly =
+	IS_BUILTIN(CONFIG_BPF_UNPRIV_DEFAULT_OFF) ? 2 : 0;
 
 static const struct bpf_map_ops * const bpf_map_types[] = {
 #define BPF_PROG_TYPE(_id, _ops)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0736508d595b..54da9e12381f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -716,7 +716,7 @@ static DEFINE_PER_CPU(struct list_head, cgrp_cpuctx_list);
  */
 static void perf_cgroup_switch(struct task_struct *task, int mode)
 {
-	struct perf_cpu_context *cpuctx;
+	struct perf_cpu_context *cpuctx, *tmp;
 	struct list_head *list;
 	unsigned long flags;
 
@@ -727,7 +727,7 @@ static void perf_cgroup_switch(struct task_struct *task, int mode)
 	local_irq_save(flags);
 
 	list = this_cpu_ptr(&cgrp_cpuctx_list);
-	list_for_each_entry(cpuctx, list, cgrp_cpuctx_entry) {
+	list_for_each_entry_safe(cpuctx, tmp, list, cgrp_cpuctx_entry) {
 		WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);
 
 		perf_ctx_lock(cpuctx, cpuctx->task_ctx);
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 4270ff81184d..158ae456e8b1 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -28,6 +28,9 @@
 #include <linux/syscalls.h>
 #include <linux/sysctl.h>
 
+/* Not exposed in headers: strictly internal use only. */
+#define SECCOMP_MODE_DEAD	(SECCOMP_MODE_FILTER + 1)
+
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 #include <asm/syscall.h>
 #endif
@@ -632,6 +635,7 @@ static void __secure_computing_strict(int this_syscall)
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
+	current->seccomp.mode = SECCOMP_MODE_DEAD;
 	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL_THREAD, true);
 	do_exit(SIGKILL);
 }
@@ -746,6 +750,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	case SECCOMP_RET_KILL_THREAD:
 	case SECCOMP_RET_KILL_PROCESS:
 	default:
+		current->seccomp.mode = SECCOMP_MODE_DEAD;
 		seccomp_log(this_syscall, SIGSYS, action, true);
 		/* Dump core only if this is the last remaining thread. */
 		if (action == SECCOMP_RET_KILL_PROCESS ||
@@ -798,6 +803,11 @@ int __secure_computing(const struct seccomp_data *sd)
 		return 0;
 	case SECCOMP_MODE_FILTER:
 		return __seccomp_filter(this_syscall, sd, false);
+	/* Surviving SECCOMP_RET_KILL_* must be proactively impossible. */
+	case SECCOMP_MODE_DEAD:
+		WARN_ON_ONCE(1);
+		do_exit(SIGKILL);
+		return -1;
 	default:
 		BUG();
 	}
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 74fc3a9d1923..c9a3e61c88f8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -242,6 +242,28 @@ static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 
 #endif
 
+#ifdef CONFIG_BPF_SYSCALL
+static int bpf_unpriv_handler(struct ctl_table *table, int write,
+                             void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret, unpriv_enable = *(int *)table->data;
+	bool locked_state = unpriv_enable == 1;
+	struct ctl_table tmp = *table;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	tmp.data = &unpriv_enable;
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (write && !ret) {
+		if (locked_state && unpriv_enable != 1)
+			return -EPERM;
+		*(int *)table->data = unpriv_enable;
+	}
+	return ret;
+}
+#endif
+
 static struct ctl_table kern_table[];
 static struct ctl_table vm_table[];
 static struct ctl_table fs_table[];
@@ -1201,10 +1223,9 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_unprivileged_bpf_disabled,
 		.maxlen		= sizeof(sysctl_unprivileged_bpf_disabled),
 		.mode		= 0644,
-		/* only handle a transition from default "0" to "1" */
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &one,
-		.extra2		= &one,
+		.proc_handler	= bpf_unpriv_handler,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 #endif
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU)
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index ce3d5f734fdb..0a68020d1de1 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -248,7 +248,9 @@ static int __net_init ipmr_rules_init(struct net *net)
 	return 0;
 
 err2:
+	rtnl_lock();
 	ipmr_free_table(mrt);
+	rtnl_unlock();
 err1:
 	fib_rules_unregister(ops);
 	return err;
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 459f282d90e1..f8d60d511d3e 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -252,7 +252,9 @@ static int __net_init ip6mr_rules_init(struct net *net)
 	return 0;
 
 err2:
+	rtnl_lock();
 	ip6mr_free_table(mrt);
+	rtnl_unlock();
 err1:
 	fib_rules_unregister(ops);
 	return err;
diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 7ebcaff8c1c4..963f607b3499 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -288,7 +288,7 @@ static bool tipc_update_nametbl(struct net *net, struct distr_item *i,
 			return true;
 		}
 	} else {
-		pr_warn("Unrecognized name table message received\n");
+		pr_warn_ratelimited("Unknown name table message received\n");
 	}
 	return false;
 }
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index d37f9ac46670..5306e6ae7950 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -486,11 +486,11 @@ int __init ima_fs_init(void)
 
 	return 0;
 out:
+	securityfs_remove(ima_policy);
 	securityfs_remove(violations);
 	securityfs_remove(runtime_measurements_count);
 	securityfs_remove(ascii_runtime_measurements);
 	securityfs_remove(binary_runtime_measurements);
 	securityfs_remove(ima_dir);
-	securityfs_remove(ima_policy);
 	return -1;
 }
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 7412d0291ab9..8687882277a1 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -31,6 +31,7 @@ static struct ima_template_desc builtin_templates[] = {
 
 static LIST_HEAD(defined_templates);
 static DEFINE_SPINLOCK(template_list);
+static int template_setup_done;
 
 static struct ima_template_field supported_fields[] = {
 	{.field_id = "d", .field_init = ima_eventdigest_init,
@@ -57,10 +58,11 @@ static int __init ima_template_setup(char *str)
 	struct ima_template_desc *template_desc;
 	int template_len = strlen(str);
 
-	if (ima_template)
+	if (template_setup_done)
 		return 1;
 
-	ima_init_template_list();
+	if (!ima_template)
+		ima_init_template_list();
 
 	/*
 	 * Verify that a template with the supplied name exists.
@@ -84,6 +86,7 @@ static int __init ima_template_setup(char *str)
 	}
 
 	ima_template = template_desc;
+	template_setup_done = 1;
 	return 1;
 }
 __setup("ima_template=", ima_template_setup);
@@ -92,7 +95,7 @@ static int __init ima_template_fmt_setup(char *str)
 {
 	int num_templates = ARRAY_SIZE(builtin_templates);
 
-	if (ima_template)
+	if (template_setup_done)
 		return 1;
 
 	if (template_desc_init_fields(str, NULL, NULL) < 0) {
@@ -103,6 +106,7 @@ static int __init ima_template_fmt_setup(char *str)
 
 	builtin_templates[num_templates - 1].fmt = str;
 	ima_template = builtin_templates + num_templates - 1;
+	template_setup_done = 1;
 
 	return 1;
 }
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 90987d15b6fe..6c415667ba67 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -39,6 +39,8 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 		return;
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
+	if (!ab)
+		return;
 	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
 			 task_pid_nr(current),
 			 from_kuid(&init_user_ns, current_cred()->uid),
