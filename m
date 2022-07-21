Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290B357D3D3
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 21:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiGUTI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 15:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGUTIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 15:08:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8935B87F74;
        Thu, 21 Jul 2022 12:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC96EB82648;
        Thu, 21 Jul 2022 19:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35AFC3411E;
        Thu, 21 Jul 2022 19:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658430525;
        bh=B0TbctNeMDP8E34yJ2eVpyIQBK1lT+TIXf/x30sukVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNcWn7QDcOeLH5Q4mvrZv5xlTm8gQF6e+OvG4RT0EMK92bUpcK4KqY4GaZOZwkKti
         DNgaYqwfKpXGNHysOecA0glODdfkXEGjbxSQr3lBwlpWpcyKx9vJX3XZqxrei0NK46
         FgGV4/5fIQFfnM05qXk3NSg6616gF1cSjoTjgtfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.289
Date:   Thu, 21 Jul 2022 21:08:14 +0200
Message-Id: <1658430493216216@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <165843049358168@kroah.com>
References: <165843049358168@kroah.com>
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
index 5f1e3dc567f1..5849c119e0ef 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -781,7 +781,7 @@ cipso_cache_enable - BOOLEAN
 cipso_cache_bucket_size - INTEGER
 	The CIPSO label cache consists of a fixed size hash table with each
 	hash bucket containing a number of cache entries.  This variable limits
-	the number of entries in each hash bucket; the larger the value the
+	the number of entries in each hash bucket; the larger the value is, the
 	more CIPSO label mappings that can be cached.  When the number of
 	entries in a given hash bucket reaches this limit adding new entries
 	causes the oldest entry in the bucket to be removed to make room.
@@ -858,7 +858,7 @@ ip_nonlocal_bind - BOOLEAN
 	which can be quite useful - but may break some applications.
 	Default: 0
 
-ip_dynaddr - BOOLEAN
+ip_dynaddr - INTEGER
 	If set non-zero, enables support for dynamic addresses.
 	If set to a non-zero value larger than 1, a kernel log
 	message will be printed when dynamic address rewriting
diff --git a/Makefile b/Makefile
index de73407a1bc3..fad6bf5e3c69 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 288
+SUBLEVEL = 289
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
index b1502df7b509..0368b73b2501 100644
--- a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
+++ b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
@@ -149,7 +149,7 @@
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
index 96b17a870b91..2486d043d2ba 100644
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
index 8b78694d56b8..4af4195eed76 100644
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
@@ -218,10 +217,10 @@ static int spectre_bhb_install_workaround(int method)
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
index e00ccbcc2913..59aa1d0646e4 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -292,6 +292,8 @@ static void __init clear_bss(void)
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
index c50452af4ded..92e862cdd89f 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1420,8 +1420,6 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 					 M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
 
-		can_put_echo_skb(skb, dev, 0);
-
 		if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 			cccr = m_can_read(priv, M_CAN_CCCR);
 			cccr &= ~(CCCR_CMR_MASK << CCCR_CMR_SHIFT);
@@ -1438,6 +1436,9 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 			m_can_write(priv, M_CAN_CCCR, cccr);
 		}
 		m_can_write(priv, M_CAN_TXBTIE, 0x1);
+
+		can_put_echo_skb(skb, dev, 0);
+
 		m_can_write(priv, M_CAN_TXBAR, 0x1);
 		/* End of xmit function for version 3.0.x */
 	} else {
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 11a72c4cbb92..2279e5e2deee 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -625,7 +625,9 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->port_sts[port].eee;
 	u32 id_mode_dis = 0, port_mode;
+	u16 lcl_adv = 0, rmt_adv = 0;
 	const char *str = NULL;
+	u8 flowctrl = 0;
 	u32 reg, offset;
 
 	if (priv->type == BCM7445_DEVICE_ID)
@@ -697,10 +699,27 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
 		break;
 	}
 
+	if (phydev->duplex == DUPLEX_FULL &&
+	    phydev->autoneg == AUTONEG_ENABLE) {
+		if (phydev->pause)
+			rmt_adv = LPA_PAUSE_CAP;
+		if (phydev->asym_pause)
+			rmt_adv |= LPA_PAUSE_ASYM;
+		if (phydev->advertising & ADVERTISED_Pause)
+			lcl_adv = ADVERTISE_PAUSE_CAP;
+		if (phydev->advertising & ADVERTISED_Asym_Pause)
+			lcl_adv |= ADVERTISE_PAUSE_ASYM;
+		flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
+	}
+
 	if (phydev->link)
 		reg |= LINK_STS;
 	if (phydev->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
+	if (flowctrl & FLOW_CTRL_TX)
+		reg |= TXFLOW_CNTL;
+	if (flowctrl & FLOW_CTRL_RX)
+		reg |= RXFLOW_CNTL;
 
 	core_writel(priv, reg, offset);
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 4f0da3963b01..1dfb14a035f9 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1896,7 +1896,10 @@ static int efx_ef10_try_update_nic_stats_vf(struct efx_nic *efx)
 
 	efx_update_sw_stats(efx, stats);
 out:
+	/* releasing a DMA coherent buffer with BH disabled can panic */
+	spin_unlock_bh(&efx->stats_lock);
 	efx_nic_free_buffer(efx, &stats_buf);
+	spin_lock_bh(&efx->stats_lock);
 	return rc;
 }
 
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 2f36b18fd109..93fac5fde093 100644
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
index 9f6e737d9fc9..c0f9de3be217 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -830,7 +830,7 @@ static int sfp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sfp);
 
-	err = devm_add_action(sfp->dev, sfp_cleanup, sfp);
+	err = devm_add_action_or_reset(sfp->dev, sfp_cleanup, sfp);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index 29c7645f5780..2612810eadaf 100644
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
index 871ad23d05c0..f93571d776a8 100644
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
index 1aca30a3f716..5d614d645e81 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2884,8 +2884,10 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
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
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 3886d4799603..3a105b2b7937 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -241,8 +241,7 @@ static void enable_tx_dma(struct s3c24xx_uart_port *ourport)
 	/* Enable tx dma mode */
 	ucon = rd_regl(port, S3C2410_UCON);
 	ucon &= ~(S3C64XX_UCON_TXBURST_MASK | S3C64XX_UCON_TXMODE_MASK);
-	ucon |= (dma_get_cache_alignment() >= 16) ?
-		S3C64XX_UCON_TXBURST_16 : S3C64XX_UCON_TXBURST_1;
+	ucon |= S3C64XX_UCON_TXBURST_1;
 	ucon |= S3C64XX_UCON_TXMODE_DMA;
 	wr_regl(port,  S3C2410_UCON, ucon);
 
@@ -515,7 +514,7 @@ static void enable_rx_dma(struct s3c24xx_uart_port *ourport)
 			S3C64XX_UCON_DMASUS_EN |
 			S3C64XX_UCON_TIMEOUT_EN |
 			S3C64XX_UCON_RXMODE_MASK);
-	ucon |= S3C64XX_UCON_RXBURST_16 |
+	ucon |= S3C64XX_UCON_RXBURST_1 |
 			0xf << S3C64XX_UCON_TIMEOUT_SHIFT |
 			S3C64XX_UCON_EMPTYINT_EN |
 			S3C64XX_UCON_TIMEOUT_EN |
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 0273a1649f23..2915ed402520 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3130,7 +3130,6 @@ static irqreturn_t dwc3_process_event_buf(struct dwc3_event_buffer *evt)
 	}
 
 	evt->count = 0;
-	evt->flags &= ~DWC3_EVENT_PENDING;
 	ret = IRQ_HANDLED;
 
 	/* Unmask interrupt */
@@ -3143,6 +3142,9 @@ static irqreturn_t dwc3_process_event_buf(struct dwc3_event_buffer *evt)
 		dwc3_writel(dwc->regs, DWC3_DEV_IMOD(0), dwc->imod_interval);
 	}
 
+	/* Keep the clearing of DWC3_EVENT_PENDING at the end */
+	evt->flags &= ~DWC3_EVENT_PENDING;
+
 	return ret;
 }
 
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index ad82d10d9cf5..b2083dcf3bd2 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -683,7 +683,7 @@ static int xhci_exit_test_mode(struct xhci_hcd *xhci)
 	}
 	pm_runtime_allow(xhci_to_hcd(xhci)->self.controller);
 	xhci->test_mode = 0;
-	return xhci_reset(xhci);
+	return xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 }
 
 void xhci_set_link_state(struct xhci_hcd *xhci, __le32 __iomem **port_array,
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 5fd1e95f5400..e930e2777c87 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2574,7 +2574,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 
 fail:
 	xhci_halt(xhci);
-	xhci_reset(xhci);
+	xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	xhci_mem_cleanup(xhci);
 	return -ENOMEM;
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 9724888196e3..3da9cd3791c6 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -76,7 +76,7 @@ static bool td_on_ring(struct xhci_td *td, struct xhci_ring *ring)
  * handshake done).  There are two failure modes:  "usec" have passed (major
  * hardware flakeout), or the register reads as all-ones (hardware removed).
  */
-int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec)
+int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, u64 timeout_us)
 {
 	u32	result;
 	int	ret;
@@ -84,7 +84,7 @@ int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec)
 	ret = readl_poll_timeout_atomic(ptr, result,
 					(result & mask) == done ||
 					result == U32_MAX,
-					1, usec);
+					1, timeout_us);
 	if (result == U32_MAX)		/* card removed */
 		return -ENODEV;
 
@@ -173,7 +173,7 @@ int xhci_start(struct xhci_hcd *xhci)
  * Transactions will be terminated immediately, and operational registers
  * will be set to their defaults.
  */
-int xhci_reset(struct xhci_hcd *xhci)
+int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 {
 	u32 command;
 	u32 state;
@@ -206,8 +206,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	if (xhci->quirks & XHCI_INTEL_HOST)
 		udelay(1000);
 
-	ret = xhci_handshake(&xhci->op_regs->command,
-			CMD_RESET, 0, 10 * 1000 * 1000);
+	ret = xhci_handshake(&xhci->op_regs->command, CMD_RESET, 0, timeout_us);
 	if (ret)
 		return ret;
 
@@ -220,8 +219,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	 * xHCI cannot write to any doorbells or operational registers other
 	 * than status until the "Controller Not Ready" flag is cleared.
 	 */
-	ret = xhci_handshake(&xhci->op_regs->status,
-			STS_CNR, 0, 10 * 1000 * 1000);
+	ret = xhci_handshake(&xhci->op_regs->status, STS_CNR, 0, timeout_us);
 
 	for (i = 0; i < 2; i++) {
 		xhci->bus_state[i].port_c_suspend = 0;
@@ -675,7 +673,7 @@ static void xhci_stop(struct usb_hcd *hcd)
 	xhci->xhc_state |= XHCI_STATE_HALTED;
 	xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
 	xhci_halt(xhci);
-	xhci_reset(xhci);
+	xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
@@ -739,7 +737,7 @@ void xhci_shutdown(struct usb_hcd *hcd)
 	xhci_halt(xhci);
 	/* Workaround for spurious wakeups at shutdown with HSW */
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
-		xhci_reset(xhci);
+		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
@@ -1111,8 +1109,10 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
-		xhci_reset(xhci);
+		retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
 		spin_unlock_irq(&xhci->lock);
+		if (retval)
+			return retval;
 		xhci_cleanup_msix(xhci);
 
 		xhci_dbg(xhci, "// Disabling event ring interrupts\n");
@@ -4988,7 +4988,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 
 	xhci_dbg(xhci, "Resetting HCD\n");
 	/* Reset the internal HC memory state and registers. */
-	retval = xhci_reset(xhci);
+	retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
 	if (retval)
 		return retval;
 	xhci_dbg(xhci, "Reset complete\n");
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 300506de0c7a..59167d4f98d0 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -236,6 +236,9 @@ struct xhci_op_regs {
 #define CMD_ETE		(1 << 14)
 /* bits 15:31 are reserved (and should be preserved on writes). */
 
+#define XHCI_RESET_LONG_USEC		(10 * 1000 * 1000)
+#define XHCI_RESET_SHORT_USEC		(250 * 1000)
+
 /* IMAN - Interrupt Management Register */
 #define IMAN_IE		(1 << 1)
 #define IMAN_IP		(1 << 0)
@@ -2016,11 +2019,11 @@ void xhci_free_command(struct xhci_hcd *xhci,
 
 /* xHCI host controller glue */
 typedef void (*xhci_get_quirks_t)(struct device *, struct xhci_hcd *);
-int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec);
+int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, u64 timeout_us);
 void xhci_quiesce(struct xhci_hcd *xhci);
 int xhci_halt(struct xhci_hcd *xhci);
 int xhci_start(struct xhci_hcd *xhci);
-int xhci_reset(struct xhci_hcd *xhci);
+int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us);
 int xhci_run(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
 void xhci_shutdown(struct usb_hcd *hcd);
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 4857e79d0744..f0a0820e4df1 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1018,6 +1018,9 @@ static const struct usb_device_id id_table_combined[] = {
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
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 181386e06cb7..0cd9e29d7f98 100644
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
@@ -492,6 +493,28 @@ static const struct virtio_config_ops virtio_mmio_config_ops = {
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
 
 static void virtio_mmio_release_dev_empty(struct device *_d) {}
 
@@ -735,6 +758,9 @@ static struct platform_driver virtio_mmio_driver = {
 		.name	= "virtio-mmio",
 		.of_match_table	= virtio_mmio_match,
 		.acpi_match_table = ACPI_PTR(virtio_mmio_acpi_match),
+#ifdef CONFIG_PM_SLEEP
+		.pm	= &virtio_mmio_pm_ops,
+#endif
 	},
 };
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 33f8c8fc96e8..a89704271428 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -212,6 +212,9 @@ static inline int nilfs_acl_chmod(struct inode *inode)
 
 static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 {
+	if (S_ISLNK(inode->i_mode))
+		return 0;
+
 	inode->i_mode &= ~current_umask();
 	return 0;
 }
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 9e1ff02d6c4e..58dbe0b58377 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -235,7 +235,8 @@ struct css_set {
 	 * List of csets participating in the on-going migration either as
 	 * source or destination.  Protected by cgroup_mutex.
 	 */
-	struct list_head mg_preload_node;
+	struct list_head mg_src_preload_node;
+	struct list_head mg_dst_preload_node;
 	struct list_head mg_node;
 
 	/*
diff --git a/include/net/sock.h b/include/net/sock.h
index f729ccfe756a..dfeaa8deba96 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1340,7 +1340,7 @@ void __sk_mem_reclaim(struct sock *sk, int amount);
 /* sysctl_mem values are in pages, we convert them in SK_MEM_QUANTUM units */
 static inline long sk_prot_mem_limits(const struct sock *sk, int index)
 {
-	long val = sk->sk_prot->sysctl_mem[index];
+	long val = READ_ONCE(sk->sk_prot->sysctl_mem[index]);
 
 #if PAGE_SIZE > SK_MEM_QUANTUM
 	val <<= PAGE_SHIFT - SK_MEM_QUANTUM_SHIFT;
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 6d31c0520ef3..3a0f00474371 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -38,7 +38,7 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_STRUCT__entry(
 		__array(char, name, 32)
-		__field(long *, sysctl_mem)
+		__array(long, sysctl_mem, 3)
 		__field(long, allocated)
 		__field(int, sysctl_rmem)
 		__field(int, rmem_alloc)
@@ -46,7 +46,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
 
 	TP_fast_assign(
 		strncpy(__entry->name, prot->name, 32);
-		__entry->sysctl_mem = prot->sysctl_mem;
+		__entry->sysctl_mem[0] = READ_ONCE(prot->sysctl_mem[0]);
+		__entry->sysctl_mem[1] = READ_ONCE(prot->sysctl_mem[1]);
+		__entry->sysctl_mem[2] = READ_ONCE(prot->sysctl_mem[2]);
 		__entry->allocated = allocated;
 		__entry->sysctl_rmem = prot->sysctl_rmem[0];
 		__entry->rmem_alloc = atomic_read(&sk->sk_rmem_alloc);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 63d1349a17a3..4b835deab3d1 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -647,7 +647,8 @@ struct css_set init_css_set = {
 	.task_iters		= LIST_HEAD_INIT(init_css_set.task_iters),
 	.threaded_csets		= LIST_HEAD_INIT(init_css_set.threaded_csets),
 	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
-	.mg_preload_node	= LIST_HEAD_INIT(init_css_set.mg_preload_node),
+	.mg_src_preload_node	= LIST_HEAD_INIT(init_css_set.mg_src_preload_node),
+	.mg_dst_preload_node	= LIST_HEAD_INIT(init_css_set.mg_dst_preload_node),
 	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
 };
 
@@ -1113,7 +1114,8 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	INIT_LIST_HEAD(&cset->threaded_csets);
 	INIT_HLIST_NODE(&cset->hlist);
 	INIT_LIST_HEAD(&cset->cgrp_links);
-	INIT_LIST_HEAD(&cset->mg_preload_node);
+	INIT_LIST_HEAD(&cset->mg_src_preload_node);
+	INIT_LIST_HEAD(&cset->mg_dst_preload_node);
 	INIT_LIST_HEAD(&cset->mg_node);
 
 	/* Copy the set of subsystem state objects generated in
@@ -2399,21 +2401,27 @@ int cgroup_migrate_vet_dst(struct cgroup *dst_cgrp)
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
 
@@ -2455,7 +2463,7 @@ void cgroup_migrate_add_src(struct css_set *src_cset,
 
 	src_cgrp = cset_cgroup_from_root(src_cset, dst_cgrp->root);
 
-	if (!list_empty(&src_cset->mg_preload_node))
+	if (!list_empty(&src_cset->mg_src_preload_node))
 		return;
 
 	WARN_ON(src_cset->mg_src_cgrp);
@@ -2466,7 +2474,7 @@ void cgroup_migrate_add_src(struct css_set *src_cset,
 	src_cset->mg_src_cgrp = src_cgrp;
 	src_cset->mg_dst_cgrp = dst_cgrp;
 	get_css_set(src_cset);
-	list_add_tail(&src_cset->mg_preload_node, &mgctx->preloaded_src_csets);
+	list_add_tail(&src_cset->mg_src_preload_node, &mgctx->preloaded_src_csets);
 }
 
 /**
@@ -2491,7 +2499,7 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 
 	/* look up the dst cset for each src cset and link it to src */
 	list_for_each_entry_safe(src_cset, tmp_cset, &mgctx->preloaded_src_csets,
-				 mg_preload_node) {
+				 mg_src_preload_node) {
 		struct css_set *dst_cset;
 		struct cgroup_subsys *ss;
 		int ssid;
@@ -2510,7 +2518,7 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 		if (src_cset == dst_cset) {
 			src_cset->mg_src_cgrp = NULL;
 			src_cset->mg_dst_cgrp = NULL;
-			list_del_init(&src_cset->mg_preload_node);
+			list_del_init(&src_cset->mg_src_preload_node);
 			put_css_set(src_cset);
 			put_css_set(dst_cset);
 			continue;
@@ -2518,8 +2526,8 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 
 		src_cset->mg_dst_cset = dst_cset;
 
-		if (list_empty(&dst_cset->mg_preload_node))
-			list_add_tail(&dst_cset->mg_preload_node,
+		if (list_empty(&dst_cset->mg_dst_preload_node))
+			list_add_tail(&dst_cset->mg_dst_preload_node,
 				      &mgctx->preloaded_dst_csets);
 		else
 			put_css_set(dst_cset);
@@ -2753,7 +2761,8 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 		goto out_finish;
 
 	spin_lock_irq(&css_set_lock);
-	list_for_each_entry(src_cset, &mgctx.preloaded_src_csets, mg_preload_node) {
+	list_for_each_entry(src_cset, &mgctx.preloaded_src_csets,
+			    mg_src_preload_node) {
 		struct task_struct *task, *ntask;
 
 		/* all tasks in src_csets need to be migrated */
diff --git a/kernel/signal.c b/kernel/signal.c
index 3619ab24644f..7c3fe8e0230a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1662,12 +1662,12 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
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
diff --git a/mm/memory.c b/mm/memory.c
index 4154fb45ac0f..615cb3fe763d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3342,11 +3342,16 @@ static int __do_fault(struct vm_fault *vmf)
 		return ret;
 
 	if (unlikely(PageHWPoison(vmf->page))) {
-		if (ret & VM_FAULT_LOCKED)
+		int poisonret = VM_FAULT_HWPOISON;
+		if (ret & VM_FAULT_LOCKED) {
+			/* Retry if a clean page was removed from the cache. */
+			if (invalidate_inode_page(vmf->page))
+				poisonret = 0;
 			unlock_page(vmf->page);
+		}
 		put_page(vmf->page);
 		vmf->page = NULL;
-		return VM_FAULT_HWPOISON;
+		return poisonret;
 	}
 
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 7e50bd9f3611..ee7a03ff89f3 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -998,9 +998,24 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
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
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index ee42907f4827..93dea10ef9a6 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1152,7 +1152,7 @@ static int inet_sk_reselect_saddr(struct sock *sk)
 	if (new_saddr == old_saddr)
 		return 0;
 
-	if (sock_net(sk)->ipv4.sysctl_ip_dynaddr > 1) {
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_ip_dynaddr) > 1) {
 		pr_info("%s(): shifting inet->saddr from %pI4 to %pI4\n",
 			__func__, &old_saddr, &new_saddr);
 	}
@@ -1207,7 +1207,7 @@ int inet_sk_rebuild_header(struct sock *sk)
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
index dc99b40da48d..1748dfb1dc0a 100644
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
index f94881412d5b..fcccc2f6fa9a 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -147,16 +147,20 @@ static void inet_peer_gc(struct inet_peer_base *base,
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
index 1d641e21f23f..3f43a4688602 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -156,6 +156,8 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	}
 #endif
 
+	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+
 	skb_postpush_rcsum(skb, hdr, tot_len);
 
 	return 0;
@@ -208,6 +210,8 @@ int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
 	}
 #endif
 
+	hdr->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+
 	skb_postpush_rcsum(skb, hdr, sizeof(struct ipv6hdr) + hdrlen);
 
 	return 0;
@@ -269,7 +273,6 @@ static int seg6_do_srh(struct sk_buff *skb)
 		break;
 	}
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	return 0;
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 9a01f72d907f..8f8ea7a76b99 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -405,7 +405,6 @@ static int input_action_end_b6(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	if (err)
 		goto drop;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	lookup_nexthop(skb, NULL, 0);
@@ -437,7 +436,6 @@ static int input_action_end_b6_encap(struct sk_buff *skb,
 	if (err)
 		goto drop;
 
-	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
 	lookup_nexthop(skb, NULL, 0);
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 94e74987fe65..40002d2afb8a 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -440,6 +440,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	sock_init_data(sock, sk);
 	tipc_set_sk_state(sk, TIPC_OPEN);
 	if (tipc_sk_insert(tsk)) {
+		sk_free(sk);
 		pr_warn("Socket create failed; port number exhausted\n");
 		return -EINVAL;
 	}
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index a888e3593d5f..068557c5b20a 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -955,6 +955,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x103c, 0x82b4, "HP ProDesk 600 G3", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x836e, "HP ProBook 455 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x837f, "HP ProBook 470 G5", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1f954d3ce499..a97c9810a765 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6480,6 +6480,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
 	SND_PCI_QUIRK(0x1025, 0x106d, "Acer Cloudbook 14", ALC283_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
+	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),
 	SND_PCI_QUIRK(0x1028, 0x05bd, "Dell Latitude E6440", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x05be, "Dell Latitude E6540", ALC292_FIXUP_DELL_E7X),
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index 858a24fc28e8..9d099d75021c 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -406,6 +406,7 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	unsigned int rnew = (!!ucontrol->value.integer.value[1]) << mc->rshift;
 	unsigned int lold, rold;
 	unsigned int lena, rena;
+	bool change = false;
 	int ret;
 
 	snd_soc_dapm_mutex_lock(dapm);
@@ -433,8 +434,8 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 		goto err;
 	}
 
-	ret = regmap_update_bits(arizona->regmap, ARIZONA_DRE_ENABLE,
-				 mask, lnew | rnew);
+	ret = regmap_update_bits_check(arizona->regmap, ARIZONA_DRE_ENABLE,
+				       mask, lnew | rnew, &change);
 	if (ret) {
 		dev_err(arizona->dev, "Failed to set DRE: %d\n", ret);
 		goto err;
@@ -447,6 +448,9 @@ static int wm5110_put_dre(struct snd_kcontrol *kcontrol,
 	if (!rnew && rold)
 		wm5110_clear_pga_volume(arizona, mc->rshift);
 
+	if (change)
+		ret = 1;
+
 err:
 	snd_soc_dapm_mutex_unlock(dapm);
 
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 0848aec1bd24..81c9ecfa7c7f 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -535,7 +535,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 		return -EINVAL;
 	if (mc->platform_max && tmp > mc->platform_max)
 		return -EINVAL;
-	if (tmp > mc->max - mc->min + 1)
+	if (tmp > mc->max - mc->min)
 		return -EINVAL;
 
 	if (invert)
@@ -556,7 +556,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 			return -EINVAL;
 		if (mc->platform_max && tmp > mc->platform_max)
 			return -EINVAL;
-		if (tmp > mc->max - mc->min + 1)
+		if (tmp > mc->max - mc->min)
 			return -EINVAL;
 
 		if (invert)
