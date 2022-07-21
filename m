Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEC457D407
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 21:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiGUTVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 15:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiGUTVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 15:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0DC33347;
        Thu, 21 Jul 2022 12:21:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BBCD62087;
        Thu, 21 Jul 2022 19:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61550C3411E;
        Thu, 21 Jul 2022 19:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658431298;
        bh=yXfsCDQqDLgLcmJO0eUDOSmCtv87nT7np57ZWA7iWIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+NVgpIGtBfG4meyuEb5a2kFPhfPBetPL/HabcLbCiXcxfH8bYAxraws3Ft5Ce+ix
         h/6AaW5tTW4jfnYWvNmNGDD5t0o9TlqC1MZPWTqyngJ6HuKj56PrA+7ZrlhxwTsACg
         UAXKRHMeHuL7LSNaiRyqrEg5TGAHL7uWp731z4uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.253
Date:   Thu, 21 Jul 2022 21:20:51 +0200
Message-Id: <165843125012109@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <165843125056101@kroah.com>
References: <165843125056101@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 3c617d620b6f..e315e6052b9f 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -810,7 +810,7 @@ cipso_cache_enable - BOOLEAN
 cipso_cache_bucket_size - INTEGER
 	The CIPSO label cache consists of a fixed size hash table with each
 	hash bucket containing a number of cache entries.  This variable limits
-	the number of entries in each hash bucket; the larger the value the
+	the number of entries in each hash bucket; the larger the value is, the
 	more CIPSO label mappings that can be cached.  When the number of
 	entries in a given hash bucket reaches this limit adding new entries
 	causes the oldest entry in the bucket to be removed to make room.
@@ -887,7 +887,7 @@ ip_nonlocal_bind - BOOLEAN
 	which can be quite useful - but may break some applications.
 	Default: 0
 
-ip_dynaddr - BOOLEAN
+ip_dynaddr - INTEGER
 	If set non-zero, enables support for dynamic addresses.
 	If set to a non-zero value larger than 1, a kernel log
 	message will be printed when dynamic address rewriting
diff --git a/Makefile b/Makefile
index 73a75363bba0..7ae832b9156f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 252
+SUBLEVEL = 253
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/arm/boot/dts/imx6qdl-ts7970.dtsi b/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
index f0be516dc28e..9181fbeb833d 100644
--- a/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-ts7970.dtsi
@@ -226,7 +226,7 @@
 		reg = <0x28>;
 		#gpio-cells = <2>;
 		gpio-controller;
-		ngpio = <32>;
+		ngpios = <62>;
 	};
 
 	sgtl5000: codec@a {
diff --git a/arch/arm/boot/dts/stm32mp157c.dtsi b/arch/arm/boot/dts/stm32mp157c.dtsi
index 4278a4b22860..7c5b2727ba2e 100644
--- a/arch/arm/boot/dts/stm32mp157c.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c.dtsi
@@ -413,7 +413,7 @@
 			compatible = "st,stm32-cec";
 			reg = <0x40016000 0x400>;
 			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc CEC_K>, <&clk_lse>;
+			clocks = <&rcc CEC_K>, <&rcc CEC>;
 			clock-names = "cec", "hdmi-cec";
 			status = "disabled";
 		};
diff --git a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
index 84cd9c061227..afc94dbc0752 100644
--- a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
+++ b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
@@ -170,7 +170,7 @@
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "mxicy,mx25l1606e", "winbond,w25q128";
+		compatible = "mxicy,mx25l1606e", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <40000000>;
 	};
diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index c7cdbb43ae7c..15e850aeaecb 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -167,5 +167,31 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 		((current_stack_pointer | (THREAD_SIZE - 1)) - 7) - 1;	\
 })
 
+
+/*
+ * Update ITSTATE after normal execution of an IT block instruction.
+ *
+ * The 8 IT state bits are split into two parts in CPSR:
+ *	ITSTATE<1:0> are in CPSR<26:25>
+ *	ITSTATE<7:2> are in CPSR<15:10>
+ */
+static inline unsigned long it_advance(unsigned long cpsr)
+{
+	if ((cpsr & 0x06000400) == 0) {
+		/* ITSTATE<2:0> == 0 means end of IT block, so clear IT state */
+		cpsr &= ~PSR_IT_MASK;
+	} else {
+		/* We need to shift left ITSTATE<4:0> */
+		const unsigned long mask = 0x06001c00;  /* Mask ITSTATE<4:0> */
+		unsigned long it = cpsr & mask;
+		it <<= 1;
+		it |= it >> (27 - 10);  /* Carry ITSTATE<2> to correct place */
+		it &= mask;
+		cpsr &= ~mask;
+		cpsr |= it;
+	}
+	return cpsr;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 84a6bbaf8cb2..633d47028695 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -936,6 +936,9 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (type == TYPE_LDST)
 		do_alignment_finish_ldst(addr, instr, regs, offset);
 
+	if (thumb_mode(regs))
+		regs->ARM_cpsr = it_advance(regs->ARM_cpsr);
+
 	return 0;
 
  bad_or_fault:
diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 0381e1495486..e53f824a2583 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -110,8 +110,7 @@ static unsigned int spectre_v2_install_workaround(unsigned int method)
 #else
 static unsigned int spectre_v2_install_workaround(unsigned int method)
 {
-	pr_info("CPU%u: Spectre V2: workarounds disabled by configuration\n",
-		smp_processor_id());
+	pr_info_once("Spectre V2: workarounds disabled by configuration\n");
 
 	return SPECTRE_VULNERABLE;
 }
@@ -223,10 +222,10 @@ static int spectre_bhb_install_workaround(int method)
 			return SPECTRE_VULNERABLE;
 
 		spectre_bhb_method = method;
-	}
 
-	pr_info("CPU%u: Spectre BHB: using %s workaround\n",
-		smp_processor_id(), spectre_bhb_method_name(method));
+		pr_info("CPU%u: Spectre BHB: enabling %s workaround for all CPUs\n",
+			smp_processor_id(), spectre_bhb_method_name(method));
+	}
 
 	return SPECTRE_MITIGATED;
 }
diff --git a/arch/arm/probes/decode.h b/arch/arm/probes/decode.h
index 548d622a3159..81360638d188 100644
--- a/arch/arm/probes/decode.h
+++ b/arch/arm/probes/decode.h
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <asm/probes.h>
+#include <asm/ptrace.h>
 #include <asm/kprobes.h>
 
 void __init arm_probes_decode_init(void);
@@ -43,31 +44,6 @@ void __init find_str_pc_offset(void);
 #endif
 
 
-/*
- * Update ITSTATE after normal execution of an IT block instruction.
- *
- * The 8 IT state bits are split into two parts in CPSR:
- *	ITSTATE<1:0> are in CPSR<26:25>
- *	ITSTATE<7:2> are in CPSR<15:10>
- */
-static inline unsigned long it_advance(unsigned long cpsr)
-	{
-	if ((cpsr & 0x06000400) == 0) {
-		/* ITSTATE<2:0> == 0 means end of IT block, so clear IT state */
-		cpsr &= ~PSR_IT_MASK;
-	} else {
-		/* We need to shift left ITSTATE<4:0> */
-		const unsigned long mask = 0x06001c00;  /* Mask ITSTATE<4:0> */
-		unsigned long it = cpsr & mask;
-		it <<= 1;
-		it |= it >> (27 - 10);  /* Carry ITSTATE<2> to correct place */
-		it &= mask;
-		cpsr &= ~mask;
-		cpsr |= it;
-	}
-	return cpsr;
-}
-
 static inline void __kprobes bx_write_pc(long pcv, struct pt_regs *regs)
 {
 	long cpsr = regs->ARM_cpsr;
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 88dc38b4a147..90c2613af36b 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -383,6 +383,8 @@ static void __init clear_bss(void)
 {
 	memset(__bss_start, 0,
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
+	memset(__brk_base, 0,
+	       (unsigned long) __brk_limit - (unsigned long) __brk_base);
 }
 
 static unsigned long get_cmd_line_ptr(void)
diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index e225edb5c359..ce0dda1a4241 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -474,6 +474,10 @@ static int pmac_cpufreq_init_MacRISC3(struct device_node *cpunode)
 	if (slew_done_gpio_np)
 		slew_done_gpio = read_gpio(slew_done_gpio_np);
 
+	of_node_put(volt_gpio_np);
+	of_node_put(freq_gpio_np);
+	of_node_put(slew_done_gpio_np);
+
 	/* If we use the frequency GPIOs, calculate the min/max speeds based
 	 * on the bus frequencies
 	 */
diff --git a/drivers/irqchip/irq-or1k-pic.c b/drivers/irqchip/irq-or1k-pic.c
index dd9d5d12fea2..05931fdedbb9 100644
--- a/drivers/irqchip/irq-or1k-pic.c
+++ b/drivers/irqchip/irq-or1k-pic.c
@@ -70,7 +70,6 @@ static struct or1k_pic_dev or1k_pic_level = {
 		.name = "or1k-PIC-level",
 		.irq_unmask = or1k_pic_unmask,
 		.irq_mask = or1k_pic_mask,
-		.irq_mask_ack = or1k_pic_mask_ack,
 	},
 	.handle = handle_level_irq,
 	.flags = IRQ_LEVEL | IRQ_NOPROBE,
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index f5f1367d40d5..4b88fabbdcba 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1438,8 +1438,6 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 					 M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
 
-		can_put_echo_skb(skb, dev, 0);
-
 		if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 			cccr = m_can_read(priv, M_CAN_CCCR);
 			cccr &= ~(CCCR_CMR_MASK << CCCR_CMR_SHIFT);
@@ -1456,6 +1454,9 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 			m_can_write(priv, M_CAN_CCCR, cccr);
 		}
 		m_can_write(priv, M_CAN_TXBTIE, 0x1);
+
+		can_put_echo_skb(skb, dev, 0);
+
 		m_can_write(priv, M_CAN_TXBAR, 0x1);
 		/* End of xmit function for version 3.0.x */
 	} else {
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 6b0a4dc1ced1..5462827d9cbb 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2059,7 +2059,10 @@ static int efx_ef10_try_update_nic_stats_vf(struct efx_nic *efx)
 
 	efx_update_sw_stats(efx, stats);
 out:
+	/* releasing a DMA coherent buffer with BH disabled can panic */
+	spin_unlock_bh(&efx->stats_lock);
 	efx_nic_free_buffer(efx, &stats_buf);
+	spin_lock_bh(&efx->stats_lock);
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index f074986a13b1..fc3cb26f7112 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -415,8 +415,9 @@ static int efx_ef10_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
 static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 {
 	struct pci_dev *dev = efx->pci_dev;
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	unsigned int vfs_assigned = pci_vfs_assigned(dev);
-	int rc = 0;
+	int i, rc = 0;
 
 	if (vfs_assigned && !force) {
 		netif_info(efx, drv, efx->net_dev, "VFs are assigned to guests; "
@@ -424,10 +425,13 @@ static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 		return -EBUSY;
 	}
 
-	if (!vfs_assigned)
+	if (!vfs_assigned) {
+		for (i = 0; i < efx->vf_count; i++)
+			nic_data->vf[i].pci_dev = NULL;
 		pci_disable_sriov(dev);
-	else
+	} else {
 		rc = -EBUSY;
+	}
 
 	efx_ef10_sriov_free_vf_vswitching(efx);
 	efx->vf_count = 0;
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 71bafc8f5ed0..e7af73ad8a44 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1811,7 +1811,7 @@ static int sfp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sfp);
 
-	err = devm_add_action(sfp->dev, sfp_cleanup, sfp);
+	err = devm_add_action_or_reset(sfp->dev, sfp_cleanup, sfp);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index 7f68067c0174..85a5a622ec18 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -482,6 +482,7 @@ void xenvif_rx_action(struct xenvif_queue *queue)
 	queue->rx_copy.completed = &completed_skbs;
 
 	while (xenvif_rx_ring_slots_available(queue) &&
+	       !skb_queue_empty(&queue->rx_queue) &&
 	       work_done < RX_BATCH_SIZE) {
 		xenvif_rx_skb(queue);
 		work_done++;
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 16c52d4c833c..e4e0744e2470 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -138,7 +138,9 @@ static int nxp_nci_i2c_fw_read(struct nxp_nci_i2c_phy *phy,
 	skb_put_data(*skb, &header, NXP_NCI_FW_HDR_LEN);
 
 	r = i2c_master_recv(client, skb_put(*skb, frame_len), frame_len);
-	if (r != frame_len) {
+	if (r < 0) {
+		goto fw_read_exit_free_skb;
+	} else if (r != frame_len) {
 		nfc_err(&client->dev,
 			"Invalid frame length: %u (expected %zu)\n",
 			r, frame_len);
@@ -182,7 +184,9 @@ static int nxp_nci_i2c_nci_read(struct nxp_nci_i2c_phy *phy,
 		return 0;
 
 	r = i2c_master_recv(client, skb_put(*skb, header.plen), header.plen);
-	if (r != header.plen) {
+	if (r < 0) {
+		goto nci_read_exit_free_skb;
+	} else if (r != header.plen) {
 		nfc_err(&client->dev,
 			"Invalid frame payload length: %u (expected %u)\n",
 			r, header.plen);
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 93fadd4abf14..f911410bb4c7 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -75,6 +75,7 @@ enum hp_wmi_event_ids {
 	HPWMI_BACKLIT_KB_BRIGHTNESS	= 0x0D,
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
+	HPWMI_SANITIZATION_MODE		= 0x17,
 };
 
 struct bios_args {
@@ -631,6 +632,8 @@ static void hp_wmi_notify(u32 value, void *context)
 		break;
 	case HPWMI_BATTERY_CHARGE_PERIOD:
 		break;
+	case HPWMI_SANITIZATION_MODE:
+		break;
 	default:
 		pr_info("Unknown event_id - %d - 0x%x\n", event_id, event_data);
 		break;
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 5a2e67a8ddc7..f11d1202566e 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2917,8 +2917,10 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
 	case UPIO_MEM32BE:
 	case UPIO_MEM16:
 	case UPIO_MEM:
-		if (!port->mapbase)
+		if (!port->mapbase) {
+			ret = -EINVAL;
 			break;
+		}
 
 		if (!request_mem_region(port->mapbase, size, "serial")) {
 			ret = -EBUSY;
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 5edc3813a9b9..7de4bed1ddba 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1335,6 +1335,15 @@ static void pl011_stop_rx(struct uart_port *port)
 	pl011_dma_rx_stop(uap);
 }
 
+static void pl011_throttle_rx(struct uart_port *port)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	pl011_stop_rx(port);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
 static void pl011_enable_ms(struct uart_port *port)
 {
 	struct uart_amba_port *uap =
@@ -1728,9 +1737,10 @@ static int pl011_allocate_irq(struct uart_amba_port *uap)
  */
 static void pl011_enable_interrupts(struct uart_amba_port *uap)
 {
+	unsigned long flags;
 	unsigned int i;
 
-	spin_lock_irq(&uap->port.lock);
+	spin_lock_irqsave(&uap->port.lock, flags);
 
 	/* Clear out any spuriously appearing RX interrupts */
 	pl011_write(UART011_RTIS | UART011_RXIS, uap, REG_ICR);
@@ -1752,7 +1762,14 @@ static void pl011_enable_interrupts(struct uart_amba_port *uap)
 	if (!pl011_dma_rx_running(uap))
 		uap->im |= UART011_RXIM;
 	pl011_write(uap->im, uap, REG_IMSC);
-	spin_unlock_irq(&uap->port.lock);
+	spin_unlock_irqrestore(&uap->port.lock, flags);
+}
+
+static void pl011_unthrottle_rx(struct uart_port *port)
+{
+	struct uart_amba_port *uap = container_of(port, struct uart_amba_port, port);
+
+	pl011_enable_interrupts(uap);
 }
 
 static int pl011_startup(struct uart_port *port)
@@ -2127,6 +2144,8 @@ static const struct uart_ops amba_pl011_pops = {
 	.stop_tx	= pl011_stop_tx,
 	.start_tx	= pl011_start_tx,
 	.stop_rx	= pl011_stop_rx,
+	.throttle	= pl011_throttle_rx,
+	.unthrottle	= pl011_unthrottle_rx,
 	.enable_ms	= pl011_enable_ms,
 	.break_ctl	= pl011_break_ctl,
 	.startup	= pl011_startup,
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 49661cef5469..964d6d33b609 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -238,8 +238,7 @@ static void enable_tx_dma(struct s3c24xx_uart_port *ourport)
 	/* Enable tx dma mode */
 	ucon = rd_regl(port, S3C2410_UCON);
 	ucon &= ~(S3C64XX_UCON_TXBURST_MASK | S3C64XX_UCON_TXMODE_MASK);
-	ucon |= (dma_get_cache_alignment() >= 16) ?
-		S3C64XX_UCON_TXBURST_16 : S3C64XX_UCON_TXBURST_1;
+	ucon |= S3C64XX_UCON_TXBURST_1;
 	ucon |= S3C64XX_UCON_TXMODE_DMA;
 	wr_regl(port,  S3C2410_UCON, ucon);
 
@@ -512,7 +511,7 @@ static void enable_rx_dma(struct s3c24xx_uart_port *ourport)
 			S3C64XX_UCON_DMASUS_EN |
 			S3C64XX_UCON_TIMEOUT_EN |
 			S3C64XX_UCON_RXMODE_MASK);
-	ucon |= S3C64XX_UCON_RXBURST_16 |
+	ucon |= S3C64XX_UCON_RXBURST_1 |
 			0xf << S3C64XX_UCON_TIMEOUT_SHIFT |
 			S3C64XX_UCON_EMPTYINT_EN |
 			S3C64XX_UCON_TIMEOUT_EN |
diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index bb2f6f02ce23..d8e1b0356e33 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -72,6 +72,8 @@ static void stm32_config_reg_rs485(u32 *cr1, u32 *cr3, u32 delay_ADE,
 	*cr3 |= USART_CR3_DEM;
 	over8 = *cr1 & USART_CR1_OVER8;
 
+	*cr1 &= ~(USART_CR1_DEDT_MASK | USART_CR1_DEAT_MASK);
+
 	if (over8)
 		rs485_deat_dedt = delay_ADE * baud * 8;
 	else
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 8be95ca95ef9..3c8ec1c07ef3 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3187,7 +3187,6 @@ static irqreturn_t dwc3_process_event_buf(struct dwc3_event_buffer *evt)
 	}
 
 	evt->count = 0;
-	evt->flags &= ~DWC3_EVENT_PENDING;
 	ret = IRQ_HANDLED;
 
 	/* Unmask interrupt */
@@ -3200,6 +3199,9 @@ static irqreturn_t dwc3_process_event_buf(struct dwc3_event_buffer *evt)
 		dwc3_writel(dwc->regs, DWC3_DEV_IMOD(0), dwc->imod_interval);
 	}
 
+	/* Keep the clearing of DWC3_EVENT_PENDING at the end */
+	evt->flags &= ~DWC3_EVENT_PENDING;
+
 	return ret;
 }
 
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index d966836e7df8..7fa56728696d 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1013,6 +1013,9 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_DISPLAY_PID) },
 	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_LITE_PID) },
 	{ USB_DEVICE(FTDI_VID, CHETCO_SEASMART_ANALOG_PID) },
+	/* Belimo Automation devices */
+	{ USB_DEVICE(FTDI_VID, BELIMO_ZTH_PID) },
+	{ USB_DEVICE(FTDI_VID, BELIMO_ZIP_PID) },
 	/* ICP DAS I-756xU devices */
 	{ USB_DEVICE(ICPDAS_VID, ICPDAS_I7560U_PID) },
 	{ USB_DEVICE(ICPDAS_VID, ICPDAS_I7561U_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index d1a9564697a4..4e92c165c86b 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1568,6 +1568,12 @@
 #define CHETCO_SEASMART_LITE_PID	0xA5AE /* SeaSmart Lite USB Adapter */
 #define CHETCO_SEASMART_ANALOG_PID	0xA5AF /* SeaSmart Analog Adapter */
 
+/*
+ * Belimo Automation
+ */
+#define BELIMO_ZTH_PID			0x8050
+#define BELIMO_ZIP_PID			0xC811
+
 /*
  * Unjo AB
  */
diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index 8dae6ff2377c..2ede329ce594 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1377,6 +1377,7 @@ void typec_set_pwr_opmode(struct typec_port *port,
 			partner->usb_pd = 1;
 			sysfs_notify(&partner_dev->kobj, NULL,
 				     "supports_usb_power_delivery");
+			kobject_uevent(&partner_dev->kobj, KOBJ_CHANGE);
 		}
 		put_device(partner_dev);
 	}
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index c69c755bf553..17cd682acc22 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -66,6 +66,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
@@ -508,6 +509,28 @@ static const struct virtio_config_ops virtio_mmio_config_ops = {
 	.bus_name	= vm_bus_name,
 };
 
+#ifdef CONFIG_PM_SLEEP
+static int virtio_mmio_freeze(struct device *dev)
+{
+	struct virtio_mmio_device *vm_dev = dev_get_drvdata(dev);
+
+	return virtio_device_freeze(&vm_dev->vdev);
+}
+
+static int virtio_mmio_restore(struct device *dev)
+{
+	struct virtio_mmio_device *vm_dev = dev_get_drvdata(dev);
+
+	if (vm_dev->version == 1)
+		writel(PAGE_SIZE, vm_dev->base + VIRTIO_MMIO_GUEST_PAGE_SIZE);
+
+	return virtio_device_restore(&vm_dev->vdev);
+}
+
+static const struct dev_pm_ops virtio_mmio_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(virtio_mmio_freeze, virtio_mmio_restore)
+};
+#endif
 
 static void virtio_mmio_release_dev(struct device *_d)
 {
@@ -761,6 +784,9 @@ static struct platform_driver virtio_mmio_driver = {
 		.name	= "virtio-mmio",
 		.of_match_table	= virtio_mmio_match,
 		.acpi_match_table = ACPI_PTR(virtio_mmio_acpi_match),
+#ifdef CONFIG_PM_SLEEP
+		.pm	= &virtio_mmio_pm_ops,
+#endif
 	},
 };
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 8699bdc9e391..cca30f0f965c 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -198,6 +198,9 @@ static inline int nilfs_acl_chmod(struct inode *inode)
 
 static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 {
+	if (S_ISLNK(inode->i_mode))
+		return 0;
+
 	inode->i_mode &= ~current_umask();
 	return 0;
 }
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index f92264d1ed4f..56442d3b651d 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -241,7 +241,8 @@ struct css_set {
 	 * List of csets participating in the on-going migration either as
 	 * source or destination.  Protected by cgroup_mutex.
 	 */
-	struct list_head mg_preload_node;
+	struct list_head mg_src_preload_node;
+	struct list_head mg_dst_preload_node;
 	struct list_head mg_node;
 
 	/*
diff --git a/include/net/sock.h b/include/net/sock.h
index 7d3a4c2eea95..98946f90781d 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1381,7 +1381,7 @@ void __sk_mem_reclaim(struct sock *sk, int amount);
 /* sysctl_mem values are in pages, we convert them in SK_MEM_QUANTUM units */
 static inline long sk_prot_mem_limits(const struct sock *sk, int index)
 {
-	long val = sk->sk_prot->sysctl_mem[index];
+	long val = READ_ONCE(sk->sk_prot->sysctl_mem[index]);
 
 #if PAGE_SIZE > SK_MEM_QUANTUM
 	val <<= PAGE_SHIFT - SK_MEM_QUANTUM_SHIFT;
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index a0c4b8a30966..3c85bed74420 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -97,7 +97,7 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_STRUCT__entry(
 		__array(char, name, 32)
-		__field(long *, sysctl_mem)
+		__array(long, sysctl_mem, 3)
 		__field(long, allocated)
 		__field(int, sysctl_rmem)
 		__field(int, rmem_alloc)
@@ -109,7 +109,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_fast_assign(
 		strncpy(__entry->name, prot->name, 32);
-		__entry->sysctl_mem = prot->sysctl_mem;
+		__entry->sysctl_mem[0] = READ_ONCE(prot->sysctl_mem[0]);
+		__entry->sysctl_mem[1] = READ_ONCE(prot->sysctl_mem[1]);
+		__entry->sysctl_mem[2] = READ_ONCE(prot->sysctl_mem[2]);
 		__entry->allocated = allocated;
 		__entry->sysctl_rmem = sk_get_rmem0(sk, prot);
 		__entry->rmem_alloc = atomic_read(&sk->sk_rmem_alloc);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 4e8284d8cacc..a892a99eb4bf 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -677,7 +677,8 @@ struct css_set init_css_set = {
 	.task_iters		= LIST_HEAD_INIT(init_css_set.task_iters),
 	.threaded_csets		= LIST_HEAD_INIT(init_css_set.threaded_csets),
 	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
-	.mg_preload_node	= LIST_HEAD_INIT(init_css_set.mg_preload_node),
+	.mg_src_preload_node	= LIST_HEAD_INIT(init_css_set.mg_src_preload_node),
+	.mg_dst_preload_node	= LIST_HEAD_INIT(init_css_set.mg_dst_preload_node),
 	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
 
 	/*
@@ -1151,7 +1152,8 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	INIT_LIST_HEAD(&cset->threaded_csets);
 	INIT_HLIST_NODE(&cset->hlist);
 	INIT_LIST_HEAD(&cset->cgrp_links);
-	INIT_LIST_HEAD(&cset->mg_preload_node);
+	INIT_LIST_HEAD(&cset->mg_src_preload_node);
+	INIT_LIST_HEAD(&cset->mg_dst_preload_node);
 	INIT_LIST_HEAD(&cset->mg_node);
 
 	/* Copy the set of subsystem state objects generated in
@@ -2455,21 +2457,27 @@ int cgroup_migrate_vet_dst(struct cgroup *dst_cgrp)
  */
 void cgroup_migrate_finish(struct cgroup_mgctx *mgctx)
 {
-	LIST_HEAD(preloaded);
 	struct css_set *cset, *tmp_cset;
 
 	lockdep_assert_held(&cgroup_mutex);
 
 	spin_lock_irq(&css_set_lock);
 
-	list_splice_tail_init(&mgctx->preloaded_src_csets, &preloaded);
-	list_splice_tail_init(&mgctx->preloaded_dst_csets, &preloaded);
+	list_for_each_entry_safe(cset, tmp_cset, &mgctx->preloaded_src_csets,
+				 mg_src_preload_node) {
+		cset->mg_src_cgrp = NULL;
+		cset->mg_dst_cgrp = NULL;
+		cset->mg_dst_cset = NULL;
+		list_del_init(&cset->mg_src_preload_node);
+		put_css_set_locked(cset);
+	}
 
-	list_for_each_entry_safe(cset, tmp_cset, &preloaded, mg_preload_node) {
+	list_for_each_entry_safe(cset, tmp_cset, &mgctx->preloaded_dst_csets,
+				 mg_dst_preload_node) {
 		cset->mg_src_cgrp = NULL;
 		cset->mg_dst_cgrp = NULL;
 		cset->mg_dst_cset = NULL;
-		list_del_init(&cset->mg_preload_node);
+		list_del_init(&cset->mg_dst_preload_node);
 		put_css_set_locked(cset);
 	}
 
@@ -2511,7 +2519,7 @@ void cgroup_migrate_add_src(struct css_set *src_cset,
 
 	src_cgrp = cset_cgroup_from_root(src_cset, dst_cgrp->root);
 
-	if (!list_empty(&src_cset->mg_preload_node))
+	if (!list_empty(&src_cset->mg_src_preload_node))
 		return;
 
 	WARN_ON(src_cset->mg_src_cgrp);
@@ -2522,7 +2530,7 @@ void cgroup_migrate_add_src(struct css_set *src_cset,
 	src_cset->mg_src_cgrp = src_cgrp;
 	src_cset->mg_dst_cgrp = dst_cgrp;
 	get_css_set(src_cset);
-	list_add_tail(&src_cset->mg_preload_node, &mgctx->preloaded_src_csets);
+	list_add_tail(&src_cset->mg_src_preload_node, &mgctx->preloaded_src_csets);
 }
 
 /**
@@ -2547,7 +2555,7 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 
 	/* look up the dst cset for each src cset and link it to src */
 	list_for_each_entry_safe(src_cset, tmp_cset, &mgctx->preloaded_src_csets,
-				 mg_preload_node) {
+				 mg_src_preload_node) {
 		struct css_set *dst_cset;
 		struct cgroup_subsys *ss;
 		int ssid;
@@ -2566,7 +2574,7 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 		if (src_cset == dst_cset) {
 			src_cset->mg_src_cgrp = NULL;
 			src_cset->mg_dst_cgrp = NULL;
-			list_del_init(&src_cset->mg_preload_node);
+			list_del_init(&src_cset->mg_src_preload_node);
 			put_css_set(src_cset);
 			put_css_set(dst_cset);
 			continue;
@@ -2574,8 +2582,8 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 
 		src_cset->mg_dst_cset = dst_cset;
 
-		if (list_empty(&dst_cset->mg_preload_node))
-			list_add_tail(&dst_cset->mg_preload_node,
+		if (list_empty(&dst_cset->mg_dst_preload_node))
+			list_add_tail(&dst_cset->mg_dst_preload_node,
 				      &mgctx->preloaded_dst_csets);
 		else
 			put_css_set(dst_cset);
@@ -2809,7 +2817,8 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 		goto out_finish;
 
 	spin_lock_irq(&css_set_lock);
-	list_for_each_entry(src_cset, &mgctx.preloaded_src_csets, mg_preload_node) {
+	list_for_each_entry(src_cset, &mgctx.preloaded_src_csets,
+			    mg_src_preload_node) {
 		struct task_struct *task, *ntask;
 
 		/* all tasks in src_csets need to be migrated */
diff --git a/kernel/signal.c b/kernel/signal.c
index 4cc3f3ba13a9..c79b87ac1041 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1825,12 +1825,12 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	bool autoreap = false;
 	u64 utime, stime;
 
-	BUG_ON(sig == -1);
+	WARN_ON_ONCE(sig == -1);
 
- 	/* do_notify_parent_cldstop should have been called instead.  */
- 	BUG_ON(task_is_stopped_or_traced(tsk));
+	/* do_notify_parent_cldstop should have been called instead.  */
+	WARN_ON_ONCE(task_is_stopped_or_traced(tsk));
 
-	BUG_ON(!tsk->ptrace &&
+	WARN_ON_ONCE(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
 	if (sig != SIGCHLD) {
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index e25bc917ec6c..48f85dab9ef1 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4266,6 +4266,8 @@ static int parse_var_defs(struct hist_trigger_data *hist_data)
 
 			s = kstrdup(field_str, GFP_KERNEL);
 			if (!s) {
+				kfree(hist_data->attrs->var_defs.name[n_vars]);
+				hist_data->attrs->var_defs.name[n_vars] = NULL;
 				ret = -ENOMEM;
 				goto free;
 			}
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 4b9d1d6bbf6f..55c7cdf5e7b8 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -1001,9 +1001,24 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 		return okfn(net, sk, skb);
 
 	ops = nf_hook_entries_get_hook_ops(e);
-	for (i = 0; i < e->num_hook_entries &&
-	      ops[i]->priority <= NF_BR_PRI_BRNF; i++)
-		;
+	for (i = 0; i < e->num_hook_entries; i++) {
+		/* These hooks have already been called */
+		if (ops[i]->priority < NF_BR_PRI_BRNF)
+			continue;
+
+		/* These hooks have not been called yet, run them. */
+		if (ops[i]->priority > NF_BR_PRI_BRNF)
+			break;
+
+		/* take a closer look at NF_BR_PRI_BRNF. */
+		if (ops[i]->hook == br_nf_pre_routing) {
+			/* This hook diverted the skb to this function,
+			 * hooks after this have not been run yet.
+			 */
+			i++;
+			break;
+		}
+	}
 
 	nf_hook_state_init(&state, hook, NFPROTO_BRIDGE, indev, outdev,
 			   sk, net, okfn);
diff --git a/net/core/filter.c b/net/core/filter.c
index c1310c9d1b90..5129e89f52bb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4570,7 +4570,6 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
 	if (err)
 		return err;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	return seg6_lookup_nexthop(skb, NULL, 0);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index d8c22246629a..dadd42a07c07 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1209,7 +1209,7 @@ static int inet_sk_reselect_saddr(struct sock *sk)
 	if (new_saddr == old_saddr)
 		return 0;
 
-	if (sock_net(sk)->ipv4.sysctl_ip_dynaddr > 1) {
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_ip_dynaddr) > 1) {
 		pr_info("%s(): shifting inet->saddr from %pI4 to %pI4\n",
 			__func__, &old_saddr, &new_saddr);
 	}
@@ -1264,7 +1264,7 @@ int inet_sk_rebuild_header(struct sock *sk)
 		 * Other protocols have to map its equivalent state to TCP_SYN_SENT.
 		 * DCCP maps its DCCP_REQUESTING state to TCP_SYN_SENT. -acme
 		 */
-		if (!sock_net(sk)->ipv4.sysctl_ip_dynaddr ||
+		if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_ip_dynaddr) ||
 		    sk->sk_state != TCP_SYN_SENT ||
 		    (sk->sk_userlocks & SOCK_BINDADDR_LOCK) ||
 		    (err = inet_sk_reselect_saddr(sk)) != 0)
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index e8b8dd1cb157..8dcf9aec7b77 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -254,7 +254,7 @@ static int cipso_v4_cache_check(const unsigned char *key,
 	struct cipso_v4_map_cache_entry *prev_entry = NULL;
 	u32 hash;
 
-	if (!cipso_v4_cache_enabled)
+	if (!READ_ONCE(cipso_v4_cache_enabled))
 		return -ENOENT;
 
 	hash = cipso_v4_map_cache_hash(key, key_len);
@@ -311,13 +311,14 @@ static int cipso_v4_cache_check(const unsigned char *key,
 int cipso_v4_cache_add(const unsigned char *cipso_ptr,
 		       const struct netlbl_lsm_secattr *secattr)
 {
+	int bkt_size = READ_ONCE(cipso_v4_cache_bucketsize);
 	int ret_val = -EPERM;
 	u32 bkt;
 	struct cipso_v4_map_cache_entry *entry = NULL;
 	struct cipso_v4_map_cache_entry *old_entry = NULL;
 	u32 cipso_ptr_len;
 
-	if (!cipso_v4_cache_enabled || cipso_v4_cache_bucketsize <= 0)
+	if (!READ_ONCE(cipso_v4_cache_enabled) || bkt_size <= 0)
 		return 0;
 
 	cipso_ptr_len = cipso_ptr[1];
@@ -337,7 +338,7 @@ int cipso_v4_cache_add(const unsigned char *cipso_ptr,
 
 	bkt = entry->hash & (CIPSO_V4_CACHE_BUCKETS - 1);
 	spin_lock_bh(&cipso_v4_cache[bkt].lock);
-	if (cipso_v4_cache[bkt].size < cipso_v4_cache_bucketsize) {
+	if (cipso_v4_cache[bkt].size < bkt_size) {
 		list_add(&entry->list, &cipso_v4_cache[bkt].list);
 		cipso_v4_cache[bkt].size += 1;
 	} else {
@@ -1214,7 +1215,8 @@ static int cipso_v4_gentag_rbm(const struct cipso_v4_doi *doi_def,
 		/* This will send packets using the "optimized" format when
 		 * possible as specified in  section 3.4.2.6 of the
 		 * CIPSO draft. */
-		if (cipso_v4_rbm_optfmt && ret_val > 0 && ret_val <= 10)
+		if (READ_ONCE(cipso_v4_rbm_optfmt) && ret_val > 0 &&
+		    ret_val <= 10)
 			tag_len = 14;
 		else
 			tag_len = 4 + ret_val;
@@ -1617,7 +1619,7 @@ int cipso_v4_validate(const struct sk_buff *skb, unsigned char **option)
 			 * all the CIPSO validations here but it doesn't
 			 * really specify _exactly_ what we need to validate
 			 * ... so, just make it a sysctl tunable. */
-			if (cipso_v4_rbm_strictvalid) {
+			if (READ_ONCE(cipso_v4_rbm_strictvalid)) {
 				if (cipso_v4_map_lvl_valid(doi_def,
 							   tag[3]) < 0) {
 					err_offset = opt_iter + 3;
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index fe10a565b7d8..aa179e6461e1 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -266,11 +266,12 @@ bool icmp_global_allow(void)
 	spin_lock(&icmp_global.lock);
 	delta = min_t(u32, now - icmp_global.stamp, HZ);
 	if (delta >= HZ / 50) {
-		incr = sysctl_icmp_msgs_per_sec * delta / HZ ;
+		incr = READ_ONCE(sysctl_icmp_msgs_per_sec) * delta / HZ;
 		if (incr)
 			WRITE_ONCE(icmp_global.stamp, now);
 	}
-	credit = min_t(u32, icmp_global.credit + incr, sysctl_icmp_msgs_burst);
+	credit = min_t(u32, icmp_global.credit + incr,
+		       READ_ONCE(sysctl_icmp_msgs_burst));
 	if (credit) {
 		/* We want to use a credit of one in average, but need to randomize
 		 * it for security reasons.
@@ -294,7 +295,7 @@ static bool icmpv4_mask_allow(struct net *net, int type, int code)
 		return true;
 
 	/* Limit if icmp type is enabled in ratemask. */
-	if (!((1 << type) & net->ipv4.sysctl_icmp_ratemask))
+	if (!((1 << type) & READ_ONCE(net->ipv4.sysctl_icmp_ratemask)))
 		return true;
 
 	return false;
@@ -332,7 +333,8 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
 
 	vif = l3mdev_master_ifindex(dst->dev);
 	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr, vif, 1);
-	rc = inet_peer_xrlim_allow(peer, net->ipv4.sysctl_icmp_ratelimit);
+	rc = inet_peer_xrlim_allow(peer,
+				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
 	if (peer)
 		inet_putpeer(peer);
 out:
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index ff327a62c9ce..a18668552d33 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -148,16 +148,20 @@ static void inet_peer_gc(struct inet_peer_base *base,
 			 struct inet_peer *gc_stack[],
 			 unsigned int gc_cnt)
 {
+	int peer_threshold, peer_maxttl, peer_minttl;
 	struct inet_peer *p;
 	__u32 delta, ttl;
 	int i;
 
-	if (base->total >= inet_peer_threshold)
+	peer_threshold = READ_ONCE(inet_peer_threshold);
+	peer_maxttl = READ_ONCE(inet_peer_maxttl);
+	peer_minttl = READ_ONCE(inet_peer_minttl);
+
+	if (base->total >= peer_threshold)
 		ttl = 0; /* be aggressive */
 	else
-		ttl = inet_peer_maxttl
-				- (inet_peer_maxttl - inet_peer_minttl) / HZ *
-					base->total / inet_peer_threshold * HZ;
+		ttl = peer_maxttl - (peer_maxttl - peer_minttl) / HZ *
+			base->total / peer_threshold * HZ;
 	for (i = 0; i < gc_cnt; i++) {
 		p = gc_stack[i];
 
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 26882fd9323a..2e90672852c8 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -176,6 +176,8 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	}
 #endif
 
+	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+
 	skb_postpush_rcsum(skb, hdr, tot_len);
 
 	return 0;
@@ -228,6 +230,8 @@ int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
 	}
 #endif
 
+	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+
 	skb_postpush_rcsum(skb, hdr, sizeof(struct ipv6hdr) + hdrlen);
 
 	return 0;
@@ -289,7 +293,6 @@ static int seg6_do_srh(struct sk_buff *skb)
 		break;
 	}
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	return 0;
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 607709a8847c..18970f6a68c6 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -415,7 +415,6 @@ static int input_action_end_b6(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	if (err)
 		goto drop;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	seg6_lookup_nexthop(skb, NULL, 0);
@@ -447,7 +446,6 @@ static int input_action_end_b6_encap(struct sk_buff *skb,
 	if (err)
 		goto drop;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	seg6_lookup_nexthop(skb, NULL, 0);
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 6c18b4565ab5..8266452c143b 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -453,6 +453,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	sock_init_data(sock, sk);
 	tipc_set_sk_state(sk, TIPC_OPEN);
 	if (tipc_sk_insert(tsk)) {
+		sk_free(sk);
 		pr_warn("Socket create failed; port number exhausted\n");
 		return -EINVAL;
 	}
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 9b7f474ee6ca..b4cd42643e1e 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -918,6 +918,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x103c, 0x82b4, "HP ProDesk 600 G3", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2915bf0857df..9670db6ad1e1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5844,6 +5844,7 @@ enum {
 	ALC298_FIXUP_LENOVO_SPK_VOLUME,
 	ALC256_FIXUP_DELL_INSPIRON_7559_SUBWOOFER,
 	ALC269_FIXUP_ATIV_BOOK_8,
+	ALC221_FIXUP_HP_288PRO_MIC_NO_PRESENCE,
 	ALC221_FIXUP_HP_MIC_NO_PRESENCE,
 	ALC256_FIXUP_ASUS_HEADSET_MODE,
 	ALC256_FIXUP_ASUS_MIC,
@@ -6642,6 +6643,16 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_NO_SHUTUP
 	},
+	[ALC221_FIXUP_HP_288PRO_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ 0x1a, 0x01813030 }, /* use as headphone mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE
+	},
 	[ALC221_FIXUP_HP_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7029,6 +7040,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
+	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),
 	SND_PCI_QUIRK(0x1028, 0x05bd, "Dell Latitude E6440", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x05be, "Dell Latitude E6540", ALC292_FIXUP_DELL_E7X),
@@ -7135,6 +7147,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x2335, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2336, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2337, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x2b5e, "HP 288 Pro G2 MT", ALC221_FIXUP_HP_288PRO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x802e, "HP Z240 SFF", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x802f, "HP Z240", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x820d, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 17255e9683f5..13e752f8b3f7 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1769,6 +1769,9 @@ static int sgtl5000_i2c_remove(struct i2c_client *client)
 {
 	struct sgtl5000_priv *sgtl5000 = i2c_get_clientdata(client);
 
+	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_DIG_POWER, SGTL5000_DIG_POWER_DEFAULT);
+	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_ANA_POWER, SGTL5000_ANA_POWER_DEFAULT);
+
 	clk_disable_unprepare(sgtl5000->mclk);
 	regulator_bulk_disable(sgtl5000->num_supplies, sgtl5000->supplies);
 	regulator_bulk_free(sgtl5000->num_supplies, sgtl5000->supplies);
@@ -1776,6 +1779,11 @@ static int sgtl5000_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
+static void sgtl5000_i2c_shutdown(struct i2c_client *client)
+{
+	sgtl5000_i2c_remove(client);
+}
+
 static const struct i2c_device_id sgtl5000_id[] = {
 	{"sgtl5000", 0},
 	{},
@@ -1796,6 +1804,7 @@ static struct i2c_driver sgtl5000_i2c_driver = {
 		   },
 	.probe = sgtl5000_i2c_probe,
 	.remove = sgtl5000_i2c_remove,
+	.shutdown = sgtl5000_i2c_shutdown,
 	.id_table = sgtl5000_id,
 };
 
diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index 066517e352a7..0ed4bad92cd1 100644
--- a/sound/soc/codecs/sgtl5000.h
+++ b/sound/soc/codecs/sgtl5000.h
@@ -80,6 +80,7 @@
 /*
  * SGTL5000_CHIP_DIG_POWER
  */
+#define SGTL5000_DIG_POWER_DEFAULT		0x0000
 #define SGTL5000_ADC_EN				0x0040
 #define SGTL5000_DAC_EN				0x0020
 #define SGTL5000_DAP_POWERUP			0x0010
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index b0789a03d699..e510aca55163 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -414,6 +414,7 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	unsigned int rnew = (!!ucontrol->value.integer.value[1]) << mc->rshift;
 	unsigned int lold, rold;
 	unsigned int lena, rena;
+	bool change = false;
 	int ret;
 
 	snd_soc_dapm_mutex_lock(dapm);
@@ -441,8 +442,8 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 		goto err;
 	}
 
-	ret = regmap_update_bits(arizona->regmap, ARIZONA_DRE_ENABLE,
-				 mask, lnew | rnew);
+	ret = regmap_update_bits_check(arizona->regmap, ARIZONA_DRE_ENABLE,
+				       mask, lnew | rnew, &change);
 	if (ret) {
 		dev_err(arizona->dev, "Failed to set DRE: %d\n", ret);
 		goto err;
@@ -455,6 +456,9 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	if (!rnew && rold)
 		wm5110_clear_pga_volume(arizona, mc->rshift);
 
+	if (change)
+		ret = 1;
+
 err:
 	snd_soc_dapm_mutex_unlock(dapm);
 
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 7a37312c8e0c..453b61b42dd9 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -530,7 +530,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 		return -EINVAL;
 	if (mc->platform_max && tmp > mc->platform_max)
 		return -EINVAL;
-	if (tmp > mc->max - mc->min + 1)
+	if (tmp > mc->max - mc->min)
 		return -EINVAL;
 
 	if (invert)
@@ -551,7 +551,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 			return -EINVAL;
 		if (mc->platform_max && tmp > mc->platform_max)
 			return -EINVAL;
-		if (tmp > mc->max - mc->min + 1)
+		if (tmp > mc->max - mc->min)
 			return -EINVAL;
 
 		if (invert)
