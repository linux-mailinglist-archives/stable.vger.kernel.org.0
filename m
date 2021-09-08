Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922994034BF
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 09:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344672AbhIHHHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 03:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344995AbhIHHHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 03:07:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B464B60ED8;
        Wed,  8 Sep 2021 07:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631084807;
        bh=EpaijJHMDAdCBS4KBjlLm/f6mQEuXGPgebmTTB4ZnKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pc+XRE59I2gaCMFzutThQnbJFLQBGqAlK6j4FvKtxPoqXKrf3Y/pTQqeaSJaCb9ql
         ux6tms+BiUUVFt96qR8HWSl5LAhCWspZpkEQnMFG4z4gbGlfmnD2r7cbJnj6XGtiQt
         +amwihsT1rv2t55SeHS7AH0w8Dh2tjPcQZYLsYNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.13.15
Date:   Wed,  8 Sep 2021 09:06:36 +0200
Message-Id: <163108479558214@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <163108479524870@kroah.com>
References: <163108479524870@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index de1f9c79e27a..d0ea05957da6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 13
-SUBLEVEL = 14
+SUBLEVEL = 15
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
index ec79944065c9..baea7d204639 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts
@@ -14,6 +14,10 @@ / {
 	model = "Microchip PolarFire-SoC Icicle Kit";
 	compatible = "microchip,mpfs-icicle-kit";
 
+	aliases {
+		ethernet0 = &emac1;
+	};
+
 	chosen {
 		stdout-path = &serial0;
 	};
diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
index b9819570a7d1..9d2fbbc1f777 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
@@ -317,7 +317,7 @@ emac1: ethernet@20112000 {
 			reg = <0x0 0x20112000 0x0 0x2000>;
 			interrupt-parent = <&plic>;
 			interrupts = <70 71 72 73>;
-			mac-address = [00 00 00 00 00 00];
+			local-mac-address = [00 00 00 00 00 00];
 			clocks = <&clkcfg 5>, <&clkcfg 2>;
 			status = "disabled";
 			clock-names = "pclk", "hclk";
diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 40669eac9d6d..921f47b9bb24 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -90,6 +90,7 @@ struct perf_ibs {
 	unsigned long			offset_mask[1];
 	int				offset_max;
 	unsigned int			fetch_count_reset_broken : 1;
+	unsigned int			fetch_ignore_if_zero_rip : 1;
 	struct cpu_perf_ibs __percpu	*pcpu;
 
 	struct attribute		**format_attrs;
@@ -672,6 +673,10 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	if (check_rip && (ibs_data.regs[2] & IBS_RIP_INVALID)) {
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 	} else {
+		/* Workaround for erratum #1197 */
+		if (perf_ibs->fetch_ignore_if_zero_rip && !(ibs_data.regs[1]))
+			goto out;
+
 		set_linear_ip(&regs, ibs_data.regs[1]);
 		regs.flags |= PERF_EFLAGS_EXACT;
 	}
@@ -769,6 +774,9 @@ static __init void perf_event_ibs_init(void)
 	if (boot_cpu_data.x86 >= 0x16 && boot_cpu_data.x86 <= 0x18)
 		perf_ibs_fetch.fetch_count_reset_broken = 1;
 
+	if (boot_cpu_data.x86 == 0x19 && boot_cpu_data.x86_model < 0x10)
+		perf_ibs_fetch.fetch_ignore_if_zero_rip = 1;
+
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
 
 	if (ibs_caps & IBS_CAPS_OPCNT) {
diff --git a/arch/x86/events/amd/power.c b/arch/x86/events/amd/power.c
index 16a2369c586e..37d5b380516e 100644
--- a/arch/x86/events/amd/power.c
+++ b/arch/x86/events/amd/power.c
@@ -213,6 +213,7 @@ static struct pmu pmu_class = {
 	.stop		= pmu_event_stop,
 	.read		= pmu_event_read,
 	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
+	.module		= THIS_MODULE,
 };
 
 static int power_cpu_exit(unsigned int cpu)
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 915847655c06..b044577785bb 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -62,7 +62,7 @@ static struct pt_cap_desc {
 	PT_CAP(single_range_output,	0, CPUID_ECX, BIT(2)),
 	PT_CAP(output_subsys,		0, CPUID_ECX, BIT(3)),
 	PT_CAP(payloads_lip,		0, CPUID_ECX, BIT(31)),
-	PT_CAP(num_address_ranges,	1, CPUID_EAX, 0x3),
+	PT_CAP(num_address_ranges,	1, CPUID_EAX, 0x7),
 	PT_CAP(mtc_periods,		1, CPUID_EAX, 0xffff0000),
 	PT_CAP(cycle_thresholds,	1, CPUID_EBX, 0xffff),
 	PT_CAP(psb_periods,		1, CPUID_EBX, 0xffff0000),
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 2332b2156993..1bdb55c2d0c1 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -30,7 +30,7 @@ config XTENSA
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_EXIT_THREAD
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUTEX_CMPXCHG if !MMU
+	select HAVE_FUTEX_CMPXCHG if !MMU && FUTEX
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_PCI
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 63056cfd4b62..fbb3a558139f 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -213,7 +213,7 @@ config BLK_DEV_LOOP_MIN_COUNT
 	  dynamically allocated with the /dev/loop-control interface.
 
 config BLK_DEV_CRYPTOLOOP
-	tristate "Cryptoloop Support"
+	tristate "Cryptoloop Support (DEPRECATED)"
 	select CRYPTO
 	select CRYPTO_CBC
 	depends on BLK_DEV_LOOP
@@ -225,7 +225,7 @@ config BLK_DEV_CRYPTOLOOP
 	  WARNING: This device is not safe for journaled file systems like
 	  ext3 or Reiserfs. Please use the Device Mapper crypto module
 	  instead, which can be configured to be on-disk compatible with the
-	  cryptoloop device.
+	  cryptoloop device.  cryptoloop support will be removed in Linux 5.16.
 
 source "drivers/block/drbd/Kconfig"
 
diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
index 3cabc335ae74..f0a91faa43a8 100644
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -189,6 +189,8 @@ init_cryptoloop(void)
 
 	if (rc)
 		printk(KERN_ERR "cryptoloop: loop_register_transfer failed\n");
+	else
+		pr_warn("the cryptoloop driver has been deprecated and will be removed in in Linux 5.16\n");
 	return rc;
 }
 
diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index a1c85d1521f5..82b244cb313e 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -585,21 +585,21 @@ static const struct ipu_rgb def_bgra_16 = {
 	.bits_per_pixel = 16,
 };
 
-#define Y_OFFSET(pix, x, y)	((x) + pix->width * (y))
-#define U_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
-				 (pix->width * ((y) / 2) / 2) + (x) / 2)
-#define V_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
-				 (pix->width * pix->height / 4) +	\
-				 (pix->width * ((y) / 2) / 2) + (x) / 2)
-#define U2_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
-				 (pix->width * (y) / 2) + (x) / 2)
-#define V2_OFFSET(pix, x, y)	((pix->width * pix->height) +		\
-				 (pix->width * pix->height / 2) +	\
-				 (pix->width * (y) / 2) + (x) / 2)
-#define UV_OFFSET(pix, x, y)	((pix->width * pix->height) +	\
-				 (pix->width * ((y) / 2)) + (x))
-#define UV2_OFFSET(pix, x, y)	((pix->width * pix->height) +	\
-				 (pix->width * y) + (x))
+#define Y_OFFSET(pix, x, y)	((x) + pix->bytesperline * (y))
+#define U_OFFSET(pix, x, y)	((pix->bytesperline * pix->height) +	 \
+				 (pix->bytesperline * ((y) / 2) / 2) + (x) / 2)
+#define V_OFFSET(pix, x, y)	((pix->bytesperline * pix->height) +	 \
+				 (pix->bytesperline * pix->height / 4) + \
+				 (pix->bytesperline * ((y) / 2) / 2) + (x) / 2)
+#define U2_OFFSET(pix, x, y)	((pix->bytesperline * pix->height) +	 \
+				 (pix->bytesperline * (y) / 2) + (x) / 2)
+#define V2_OFFSET(pix, x, y)	((pix->bytesperline * pix->height) +	 \
+				 (pix->bytesperline * pix->height / 2) + \
+				 (pix->bytesperline * (y) / 2) + (x) / 2)
+#define UV_OFFSET(pix, x, y)	((pix->bytesperline * pix->height) +	 \
+				 (pix->bytesperline * ((y) / 2)) + (x))
+#define UV2_OFFSET(pix, x, y)	((pix->bytesperline * pix->height) +	 \
+				 (pix->bytesperline * y) + (x))
 
 #define NUM_ALPHA_CHANNELS	7
 
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index a45d464427c4..0e231e576dc3 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1346,7 +1346,7 @@ static int stk_camera_probe(struct usb_interface *interface,
 	if (!dev->isoc_ep) {
 		pr_err("Could not find isoc-in endpoint\n");
 		err = -ENODEV;
-		goto error;
+		goto error_put;
 	}
 	dev->vsettings.palette = V4L2_PIX_FMT_RGB565;
 	dev->vsettings.mode = MODE_VGA;
@@ -1359,10 +1359,12 @@ static int stk_camera_probe(struct usb_interface *interface,
 
 	err = stk_register_video_device(dev);
 	if (err)
-		goto error;
+		goto error_put;
 
 	return 0;
 
+error_put:
+	usb_put_intf(interface);
 error:
 	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index b1d46dd8eaab..6ea003678798 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1277,15 +1277,16 @@ static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, int lane)
 	int err;
 
 	/* mv88e6393x family errata 4.6:
-	 * Cannot clear PwrDn bit on SERDES on port 0 if device is configured
-	 * CPU_MGD mode or P0_mode is configured for [x]MII.
-	 * Workaround: Set Port0 SERDES register 4.F002 bit 5=0 and bit 15=1.
+	 * Cannot clear PwrDn bit on SERDES if device is configured CPU_MGD
+	 * mode or P0_mode is configured for [x]MII.
+	 * Workaround: Set SERDES register 4.F002 bit 5=0 and bit 15=1.
 	 *
 	 * It seems that after this workaround the SERDES is automatically
 	 * powered up (the bit is cleared), so power it down.
 	 */
-	if (lane == MV88E6393X_PORT0_LANE) {
-		err = mv88e6390_serdes_read(chip, MV88E6393X_PORT0_LANE,
+	if (lane == MV88E6393X_PORT0_LANE || lane == MV88E6393X_PORT9_LANE ||
+	    lane == MV88E6393X_PORT10_LANE) {
+		err = mv88e6390_serdes_read(chip, lane,
 					    MDIO_MMD_PHYXS,
 					    MV88E6393X_SERDES_POC, &reg);
 		if (err)
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 283918aeb741..09d64a29f56e 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -275,6 +275,12 @@ void gem_ptp_rxstamp(struct macb *bp, struct sk_buff *skb,
 
 	if (GEM_BFEXT(DMA_RXVALID, desc->addr)) {
 		desc_ptp = macb_ptp_desc(bp, desc);
+		/* Unlikely but check */
+		if (!desc_ptp) {
+			dev_warn_ratelimited(&bp->pdev->dev,
+					     "Timestamp not supported in BD\n");
+			return;
+		}
 		gem_hw_timestamp(bp, desc_ptp->ts_1, desc_ptp->ts_2, &ts);
 		memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
 		shhwtstamps->hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
@@ -307,8 +313,11 @@ int gem_ptp_txstamp(struct macb_queue *queue, struct sk_buff *skb,
 	if (CIRC_SPACE(head, tail, PTP_TS_BUFFER_SIZE) == 0)
 		return -ENOMEM;
 
-	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 	desc_ptp = macb_ptp_desc(queue->bp, desc);
+	/* Unlikely but check */
+	if (!desc_ptp)
+		return -EINVAL;
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 	tx_timestamp = &queue->tx_timestamps[head];
 	tx_timestamp->skb = skb;
 	/* ensure ts_1/ts_2 is loaded after ctrl (TX_USED check) */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 5bd58c65e163..6bb9ec98a12b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -616,7 +616,12 @@ static int qed_enable_msix(struct qed_dev *cdev,
 			rc = cnt;
 	}
 
-	if (rc > 0) {
+	/* For VFs, we should return with an error in case we didn't get the
+	 * exact number of msix vectors as we requested.
+	 * Not doing that will lead to a crash when starting queues for
+	 * this VF.
+	 */
+	if ((IS_PF(cdev) && rc > 0) || (IS_VF(cdev) && rc == cnt)) {
 		/* MSI-x configuration was achieved */
 		int_params->out.int_mode = QED_INT_MODE_MSIX;
 		int_params->out.num_vectors = rc;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 7c6064baeba2..1c7f9ed6f1c1 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1874,6 +1874,7 @@ static void qede_sync_free_irqs(struct qede_dev *edev)
 	}
 
 	edev->int_info.used_cnt = 0;
+	edev->int_info.msix_cnt = 0;
 }
 
 static int qede_req_msix_irqs(struct qede_dev *edev)
@@ -2427,7 +2428,6 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 	goto out;
 err4:
 	qede_sync_free_irqs(edev);
-	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
 err3:
 	qede_napi_disable_remove(edev);
 err2:
diff --git a/drivers/reset/reset-zynqmp.c b/drivers/reset/reset-zynqmp.c
index ebd433fa09dd..8c51768e9a72 100644
--- a/drivers/reset/reset-zynqmp.c
+++ b/drivers/reset/reset-zynqmp.c
@@ -53,7 +53,8 @@ static int zynqmp_reset_status(struct reset_controller_dev *rcdev,
 			       unsigned long id)
 {
 	struct zynqmp_reset_data *priv = to_zynqmp_reset_data(rcdev);
-	int val, err;
+	int err;
+	u32 val;
 
 	err = zynqmp_pm_reset_get_status(priv->data->reset_id + id, &val);
 	if (err)
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index ea2e2d925a96..737748529482 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -1110,10 +1110,8 @@ static int cp210x_set_chars(struct usb_serial_port *port,
 
 	kfree(dmabuf);
 
-	if (result < 0) {
-		dev_err(&port->dev, "failed to set special chars: %d\n", result);
+	if (result < 0)
 		return result;
-	}
 
 	return 0;
 }
@@ -1138,6 +1136,7 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 	struct cp210x_flow_ctl flow_ctl;
 	u32 flow_repl;
 	u32 ctl_hs;
+	bool crtscts;
 	int ret;
 
 	/*
@@ -1165,8 +1164,10 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 		chars.bXoffChar = STOP_CHAR(tty);
 
 		ret = cp210x_set_chars(port, &chars);
-		if (ret)
-			return;
+		if (ret) {
+			dev_err(&port->dev, "failed to set special chars: %d\n",
+					ret);
+		}
 	}
 
 	mutex_lock(&port_priv->mutex);
@@ -1195,14 +1196,14 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 			flow_repl |= CP210X_SERIAL_RTS_FLOW_CTL;
 		else
 			flow_repl |= CP210X_SERIAL_RTS_INACTIVE;
-		port_priv->crtscts = true;
+		crtscts = true;
 	} else {
 		ctl_hs &= ~CP210X_SERIAL_CTS_HANDSHAKE;
 		if (port_priv->rts)
 			flow_repl |= CP210X_SERIAL_RTS_ACTIVE;
 		else
 			flow_repl |= CP210X_SERIAL_RTS_INACTIVE;
-		port_priv->crtscts = false;
+		crtscts = false;
 	}
 
 	if (I_IXOFF(tty)) {
@@ -1225,8 +1226,12 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 	flow_ctl.ulControlHandshake = cpu_to_le32(ctl_hs);
 	flow_ctl.ulFlowReplace = cpu_to_le32(flow_repl);
 
-	cp210x_write_reg_block(port, CP210X_SET_FLOW, &flow_ctl,
+	ret = cp210x_write_reg_block(port, CP210X_SET_FLOW, &flow_ctl,
 			sizeof(flow_ctl));
+	if (ret)
+		goto out_unlock;
+
+	port_priv->crtscts = crtscts;
 out_unlock:
 	mutex_unlock(&port_priv->mutex);
 }
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 2ce9cbf49e97..3b579966fe73 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -433,6 +433,7 @@ static int pl2303_detect_type(struct usb_serial *serial)
 		switch (bcdDevice) {
 		case 0x100:
 		case 0x305:
+		case 0x405:
 			/*
 			 * Assume it's an HXN-type if the device doesn't
 			 * support the old read request value.
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index abd9af7727ad..3c444b9cb17b 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -394,9 +394,11 @@ void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
 {
 	int i;
 
-	for (i = 0; i < m->possible_max_rank; i++)
-		kfree(m->m_info[i].export_targets);
-	kfree(m->m_info);
+	if (m->m_info) {
+		for (i = 0; i < m->possible_max_rank; i++)
+			kfree(m->m_info[i].export_targets);
+		kfree(m->m_info);
+	}
 	kfree(m->m_data_pg_pools);
 	kfree(m);
 }
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 3cf01629010d..0e85447022ae 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -750,6 +750,12 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 	ext4_write_lock_xattr(inode, &no_expand);
 	BUG_ON(!ext4_has_inline_data(inode));
 
+	/*
+	 * ei->i_inline_off may have changed since ext4_write_begin()
+	 * called ext4_try_to_write_inline_data()
+	 */
+	(void) ext4_find_inline_data_nolock(inode);
+
 	kaddr = kmap_atomic(page);
 	ext4_write_inline_data(inode, &iloc, kaddr, pos, len);
 	kunmap_atomic(kaddr);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a4e040ea9b3..079bb0f6b343 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5051,6 +5051,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei,
 					  GFP_KERNEL);
 	}
+	/*
+	 * Update the checksum after updating free space/inode
+	 * counters.  Otherwise the superblock can have an incorrect
+	 * checksum in the buffer cache until it is written out and
+	 * e2fsprogs programs trying to open a file system immediately
+	 * after it is mounted can fail.
+	 */
+	ext4_superblock_csum_set(sb);
 	if (!err)
 		err = percpu_counter_init(&sbi->s_dirs_counter,
 					  ext4_count_dirs(sb), GFP_KERNEL);
diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index b7e3d8f44511..23c58b62a58a 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1746,7 +1746,7 @@ static int snd_pcm_lib_ioctl_fifo_size(struct snd_pcm_substream *substream,
 		channels = params_channels(params);
 		frame_size = snd_pcm_format_size(format, channels);
 		if (frame_size > 0)
-			params->fifo_size /= (unsigned)frame_size;
+			params->fifo_size /= frame_size;
 	}
 	return 0;
 }
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0c6be8509855..82191d8f3d21 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8378,6 +8378,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x87f2, "HP ProBook 640 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f4, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87f6, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x8805, "HP ProBook 650 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x880d, "HP EliteBook 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
@@ -9456,6 +9457,16 @@ static int patch_alc269(struct hda_codec *codec)
 
 	snd_hda_pick_fixup(codec, alc269_fixup_models,
 		       alc269_fixup_tbl, alc269_fixups);
+	/* FIXME: both TX300 and ROG Strix G17 have the same SSID, and
+	 * the quirk breaks the latter (bko#214101).
+	 * Clear the wrong entry.
+	 */
+	if (codec->fixup_id == ALC282_FIXUP_ASUS_TX300 &&
+	    codec->core.vendor_id == 0x10ec0294) {
+		codec_dbg(codec, "Clear wrong fixup for ASUS ROG Strix G17\n");
+		codec->fixup_id = HDA_FIXUP_ID_NOT_SET;
+	}
+
 	snd_hda_pick_pin_fixup(codec, alc269_pin_fixup_tbl, alc269_fixups, true);
 	snd_hda_pick_pin_fixup(codec, alc269_fallback_pin_fixup_tbl, alc269_fixups, false);
 	snd_hda_pick_fixup(codec, NULL,	alc269_fixup_vendor_tbl,
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 014c43862826..3cb1a584bf80 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1286,6 +1286,11 @@ int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
 	 * to be set up before parameter setups
 	 */
 	iface_first = ep->cur_audiofmt->protocol == UAC_VERSION_1;
+	/* Workaround for Sony WALKMAN NW-A45 DAC;
+	 * it requires the interface setup at first like UAC1
+	 */
+	if (chip->usb_id == USB_ID(0x054c, 0x0b8c))
+		iface_first = true;
 	if (iface_first) {
 		err = endpoint_set_interface(chip, ep, true);
 		if (err < 0)
