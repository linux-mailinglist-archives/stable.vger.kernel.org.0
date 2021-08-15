Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB233EC8C3
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 13:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238145AbhHOLkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 07:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237967AbhHOLkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 07:40:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD69961042;
        Sun, 15 Aug 2021 11:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629027622;
        bh=dzEO33ySwUXPM8bXU67BR76HKJXi1wgtrMBTKRg0VGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XmqOsDZBgsfdR5Fzzwrf3iVZWZpZZycoKeeOAxy1bTgoQc2z6S7NIRKKlmmhrcK5
         ofBT8MKjl4Bu5MEqPp6JtlJa7dhMCySdIBdUNwxq+oDpdXkkxzJBERwQxVViT22Y5A
         YS9r1YkXCD98IeB9gT19fBzXItn6MyU8yqRB+W7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.244
Date:   Sun, 15 Aug 2021 13:40:14 +0200
Message-Id: <1629027614116124@kroah.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <16290276146511@kroah.com>
References: <16290276146511@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index c0664d65f9ef..ef77eb6d5d29 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 243
+SUBLEVEL = 244
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index d0dccae53ba9..8a89b9adb4fe 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -585,7 +585,7 @@ void
 smp_send_stop(void)
 {
 	cpumask_t to_whom;
-	cpumask_copy(&to_whom, cpu_possible_mask);
+	cpumask_copy(&to_whom, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), &to_whom);
 #ifdef DEBUG_IPI_MSG
 	if (hard_smp_processor_id() != boot_cpu_id)
diff --git a/arch/arm/boot/dts/omap5-board-common.dtsi b/arch/arm/boot/dts/omap5-board-common.dtsi
index c58f14de0145..7d1877c9c361 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -29,14 +29,6 @@
 		regulator-max-microvolt = <5000000>;
 	};
 
-	vdds_1v8_main: fixedregulator-vdds_1v8_main {
-		compatible = "regulator-fixed";
-		regulator-name = "vdds_1v8_main";
-		vin-supply = <&smps7_reg>;
-		regulator-min-microvolt = <1800000>;
-		regulator-max-microvolt = <1800000>;
-	};
-
 	vmmcsd_fixed: fixedregulator-mmcsd {
 		compatible = "regulator-fixed";
 		regulator-name = "vmmcsd_fixed";
@@ -482,6 +474,7 @@
 					regulator-boot-on;
 				};
 
+				vdds_1v8_main:
 				smps7_reg: smps7 {
 					/* VDDS_1v8_OMAP over VDDS_1v8_MAIN */
 					regulator-name = "smps7";
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index a4a06d173858..1190e6f75d4b 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -314,7 +314,7 @@ LDFLAGS			+= -m $(ld-emul)
 
 ifdef CONFIG_MIPS
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
-	egrep -vw '__GNUC_(|MINOR_|PATCHLEVEL_)_' | \
+	egrep -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
 ifdef CONFIG_64BIT
 CHECKFLAGS		+= -m64
diff --git a/arch/mips/mti-malta/malta-platform.c b/arch/mips/mti-malta/malta-platform.c
index 11e9527c6e44..62ffac500eb5 100644
--- a/arch/mips/mti-malta/malta-platform.c
+++ b/arch/mips/mti-malta/malta-platform.c
@@ -47,7 +47,8 @@ static struct plat_serial8250_port uart8250_data[] = {
 		.mapbase	= 0x1f000900,	/* The CBUS UART */
 		.irq		= MIPS_CPU_IRQ_BASE + MIPSCPU_INT_MB2,
 		.uartclk	= 3686400,	/* Twice the usual clk! */
-		.iotype		= UPIO_MEM32,
+		.iotype		= IS_ENABLED(CONFIG_CPU_BIG_ENDIAN) ?
+				  UPIO_MEM32BE : UPIO_MEM32,
 		.flags		= CBUS_UART_FLAGS,
 		.regshift	= 3,
 	},
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index bfe16631fd1d..ccd14aca30e7 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -792,9 +792,10 @@ void x86_pmu_stop(struct perf_event *event, int flags);
 
 static inline void x86_pmu_disable_event(struct perf_event *event)
 {
+	u64 disable_mask = __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);
 	struct hw_perf_event *hwc = &event->hw;
 
-	wrmsrl(hwc->config_base, hwc->config);
+	wrmsrl(hwc->config_base, hwc->config & ~disable_mask);
 }
 
 void x86_pmu_enable_event(struct perf_event *event);
diff --git a/drivers/acpi/acpica/nsrepair2.c b/drivers/acpi/acpica/nsrepair2.c
index 78b802b5f7d3..06037e044694 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -409,13 +409,6 @@ acpi_ns_repair_CID(struct acpi_evaluate_info *info,
 
 			(*element_ptr)->common.reference_count =
 			    original_ref_count;
-
-			/*
-			 * The original_element holds a reference from the package object
-			 * that represents _HID. Since a new element was created by _HID,
-			 * remove the reference from the _CID package.
-			 */
-			acpi_ut_remove_reference(original_element);
 		}
 
 		element_ptr++;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 7057630ccf52..1b4297ec3e87 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -657,6 +657,20 @@ unsigned int ata_sff_data_xfer32(struct ata_queued_cmd *qc, unsigned char *buf,
 }
 EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);
 
+static void ata_pio_xfer(struct ata_queued_cmd *qc, struct page *page,
+		unsigned int offset, size_t xfer_size)
+{
+	bool do_write = (qc->tf.flags & ATA_TFLAG_WRITE);
+	unsigned char *buf;
+
+	buf = kmap_atomic(page);
+	qc->ap->ops->sff_data_xfer(qc, buf + offset, xfer_size, do_write);
+	kunmap_atomic(buf);
+
+	if (!do_write && !PageSlab(page))
+		flush_dcache_page(page);
+}
+
 /**
  *	ata_sff_data_xfer_noirq - Transfer data by PIO
  *	@qc: queued command
@@ -698,11 +712,9 @@ EXPORT_SYMBOL_GPL(ata_sff_data_xfer_noirq);
  */
 static void ata_pio_sector(struct ata_queued_cmd *qc)
 {
-	int do_write = (qc->tf.flags & ATA_TFLAG_WRITE);
 	struct ata_port *ap = qc->ap;
 	struct page *page;
 	unsigned int offset;
-	unsigned char *buf;
 
 	if (!qc->cursg) {
 		qc->curbytes = qc->nbytes;
@@ -720,13 +732,20 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 
 	DPRINTK("data %s\n", qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
 
-	/* do the actual data transfer */
-	buf = kmap_atomic(page);
-	ap->ops->sff_data_xfer(qc, buf + offset, qc->sect_size, do_write);
-	kunmap_atomic(buf);
+	/*
+	 * Split the transfer when it splits a page boundary.  Note that the
+	 * split still has to be dword aligned like all ATA data transfers.
+	 */
+	WARN_ON_ONCE(offset % 4);
+	if (offset + qc->sect_size > PAGE_SIZE) {
+		unsigned int split_len = PAGE_SIZE - offset;
 
-	if (!do_write && !PageSlab(page))
-		flush_dcache_page(page);
+		ata_pio_xfer(qc, page, offset, split_len);
+		ata_pio_xfer(qc, nth_page(page, 1), 0,
+			     qc->sect_size - split_len);
+	} else {
+		ata_pio_xfer(qc, page, offset, qc->sect_size);
+	}
 
 	qc->curbytes += qc->sect_size;
 	qc->cursg_ofs += qc->sect_size;
diff --git a/drivers/clk/clk-stm32f4.c b/drivers/clk/clk-stm32f4.c
index 96c6b6bc8f0e..46bc5f5d7134 100644
--- a/drivers/clk/clk-stm32f4.c
+++ b/drivers/clk/clk-stm32f4.c
@@ -453,7 +453,7 @@ struct stm32f4_pll {
 
 struct stm32f4_pll_post_div_data {
 	int idx;
-	u8 pll_num;
+	int pll_idx;
 	const char *name;
 	const char *parent;
 	u8 flag;
@@ -484,13 +484,13 @@ static const struct clk_div_table post_divr_table[] = {
 
 #define MAX_POST_DIV 3
 static const struct stm32f4_pll_post_div_data  post_div_data[MAX_POST_DIV] = {
-	{ CLK_I2SQ_PDIV, PLL_I2S, "plli2s-q-div", "plli2s-q",
+	{ CLK_I2SQ_PDIV, PLL_VCO_I2S, "plli2s-q-div", "plli2s-q",
 		CLK_SET_RATE_PARENT, STM32F4_RCC_DCKCFGR, 0, 5, 0, NULL},
 
-	{ CLK_SAIQ_PDIV, PLL_SAI, "pllsai-q-div", "pllsai-q",
+	{ CLK_SAIQ_PDIV, PLL_VCO_SAI, "pllsai-q-div", "pllsai-q",
 		CLK_SET_RATE_PARENT, STM32F4_RCC_DCKCFGR, 8, 5, 0, NULL },
 
-	{ NO_IDX, PLL_SAI, "pllsai-r-div", "pllsai-r", CLK_SET_RATE_PARENT,
+	{ NO_IDX, PLL_VCO_SAI, "pllsai-r-div", "pllsai-r", CLK_SET_RATE_PARENT,
 		STM32F4_RCC_DCKCFGR, 16, 2, 0, post_divr_table },
 };
 
@@ -1489,7 +1489,7 @@ static void __init stm32f4_rcc_init(struct device_node *np)
 				post_div->width,
 				post_div->flag_div,
 				post_div->div_table,
-				clks[post_div->pll_num],
+				clks[post_div->pll_idx],
 				&stm32f4_clk_lock);
 
 		if (post_div->idx != NO_IDX)
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 95a7b9123f8e..bfce2d6addf7 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -50,7 +50,16 @@ static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
 	} else {
 		/* read */
 		requesttype = (USB_TYPE_VENDOR | USB_DIR_IN);
-		pipe = usb_rcvctrlpipe(d->udev, 0);
+
+		/*
+		 * Zero-length transfers must use usb_sndctrlpipe() and
+		 * rtl28xxu_identify_state() uses a zero-length i2c read
+		 * command to determine the chip type.
+		 */
+		if (req->size)
+			pipe = usb_rcvctrlpipe(d->udev, 0);
+		else
+			pipe = usb_sndctrlpipe(d->udev, 0);
 	}
 
 	ret = usb_control_msg(d->udev, pipe, 0, requesttype, req->value,
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f1725da2a90d..5cd496e5010c 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1371,6 +1371,7 @@ static int vb2_start_streaming(struct vb2_queue *q)
 int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 {
 	struct vb2_buffer *vb;
+	enum vb2_buffer_state orig_state;
 	int ret;
 
 	if (q->error) {
@@ -1400,6 +1401,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	 * Add to the queued buffers list, a buffer will stay on it until
 	 * dequeued in dqbuf.
 	 */
+	orig_state = vb->state;
 	list_add_tail(&vb->queued_entry, &q->queued_list);
 	q->queued_count++;
 	q->waiting_for_buffers = false;
@@ -1430,8 +1432,17 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	if (q->streaming && !q->start_streaming_called &&
 	    q->queued_count >= q->min_buffers_needed) {
 		ret = vb2_start_streaming(q);
-		if (ret)
+		if (ret) {
+			/*
+			 * Since vb2_core_qbuf will return with an error,
+			 * we should return it to state DEQUEUED since
+			 * the error indicates that the buffer wasn't queued.
+			 */
+			list_del(&vb->queued_entry);
+			q->queued_count--;
+			vb->state = orig_state;
 			return ret;
+		}
 	}
 
 	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index faa45491ae4d..8c111def8185 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2667,7 +2667,8 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 	}
 
 	/* Allocated memory for FW statistics  */
-	if (bnx2x_alloc_fw_stats_mem(bp))
+	rc = bnx2x_alloc_fw_stats_mem(bp);
+	if (rc)
 		LOAD_ERROR_EXIT(bp, load_error0);
 
 	/* request pf to initialize status blocks */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 22f964ef859e..29902b8709f1 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3581,13 +3581,13 @@ fec_drv_remove(struct platform_device *pdev)
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
-	free_netdev(ndev);
 
 	clk_disable_unprepare(fep->clk_ahb);
 	clk_disable_unprepare(fep->clk_ipg);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
+	free_netdev(ndev);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index 18af2a23a933..779f8042478a 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -819,7 +819,7 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 		printk(version);
 #endif
 
-	i = pci_enable_device(pdev);
+	i = pcim_enable_device(pdev);
 	if (i) return i;
 
 	/* natsemi has a non-standard PM control register
@@ -852,7 +852,7 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ioaddr = ioremap(iostart, iosize);
 	if (!ioaddr) {
 		i = -ENOMEM;
-		goto err_ioremap;
+		goto err_pci_request_regions;
 	}
 
 	/* Work around the dropped serial bit. */
@@ -974,9 +974,6 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
  err_register_netdev:
 	iounmap(ioaddr);
 
- err_ioremap:
-	pci_release_regions(pdev);
-
  err_pci_request_regions:
 	free_netdev(dev);
 	return i;
@@ -3244,7 +3241,6 @@ static void natsemi_remove1(struct pci_dev *pdev)
 
 	NATSEMI_REMOVE_FILE(pdev, dspcfg_workaround);
 	unregister_netdev (dev);
-	pci_release_regions (pdev);
 	iounmap(ioaddr);
 	free_netdev (dev);
 }
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 50ea69d88480..e69e76bb2c77 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3537,13 +3537,13 @@ static void vxge_device_unregister(struct __vxge_hw_device *hldev)
 
 	kfree(vdev->vpaths);
 
-	/* we are safe to free it now */
-	free_netdev(dev);
-
 	vxge_debug_init(vdev->level_trace, "%s: ethernet device unregistered",
 			buf);
 	vxge_debug_entryexit(vdev->level_trace,	"%s: %s:%d  Exiting...", buf,
 			     __func__, __LINE__);
+
+	/* we are safe to free it now */
+	free_netdev(dev);
 }
 
 /*
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 8e623d8fa78e..681919f8cbd7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -271,6 +271,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 
 	/* Init to unknowns */
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+	ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
 	cmd->base.port = PORT_OTHER;
 	cmd->base.speed = SPEED_UNKNOWN;
 	cmd->base.duplex = DUPLEX_UNKNOWN;
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index a8bb061e1a8a..36c7d78ba780 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -155,7 +155,7 @@ static int ql_wait_for_drvr_lock(struct ql3_adapter *qdev)
 				      "driver lock acquired\n");
 			return 1;
 		}
-		ssleep(1);
+		mdelay(1000);
 	} while (++i < 10);
 
 	netdev_err(qdev->ndev, "Timed out waiting for driver lock...\n");
@@ -3291,7 +3291,7 @@ static int ql_adapter_reset(struct ql3_adapter *qdev)
 		if ((value & ISP_CONTROL_SR) == 0)
 			break;
 
-		ssleep(1);
+		mdelay(1000);
 	} while ((--max_wait_time));
 
 	/*
@@ -3327,7 +3327,7 @@ static int ql_adapter_reset(struct ql3_adapter *qdev)
 						   ispControlStatus);
 			if ((value & ISP_CONTROL_FSR) == 0)
 				break;
-			ssleep(1);
+			mdelay(1000);
 		} while ((--max_wait_time));
 	}
 	if (max_wait_time == 0)
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 6f3e79159d7a..5261796ce708 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1165,9 +1165,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	}
 
 	dev_info(dev,
-		 "Xilinx EmacLite at 0x%08X mapped to 0x%08X, irq=%d\n",
-		 (unsigned int __force)ndev->mem_start,
-		 (unsigned int __force)lp->base_addr, ndev->irq);
+		 "Xilinx EmacLite at 0x%08X mapped to 0x%p, irq=%d\n",
+		 (unsigned int __force)ndev->mem_start, lp->base_addr, ndev->irq);
 	return 0;
 
 error:
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 8faf4488340d..f846c55f9df0 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -286,7 +286,7 @@ static struct channel *ppp_find_channel(struct ppp_net *pn, int unit);
 static int ppp_connect_channel(struct channel *pch, int unit);
 static int ppp_disconnect_channel(struct channel *pch);
 static void ppp_destroy_channel(struct channel *pch);
-static int unit_get(struct idr *p, void *ptr);
+static int unit_get(struct idr *p, void *ptr, int min);
 static int unit_set(struct idr *p, void *ptr, int n);
 static void unit_put(struct idr *p, int n);
 static void *unit_find(struct idr *p, int n);
@@ -977,9 +977,20 @@ static int ppp_unit_register(struct ppp *ppp, int unit, bool ifname_is_set)
 	mutex_lock(&pn->all_ppp_mutex);
 
 	if (unit < 0) {
-		ret = unit_get(&pn->units_idr, ppp);
+		ret = unit_get(&pn->units_idr, ppp, 0);
 		if (ret < 0)
 			goto err;
+		if (!ifname_is_set) {
+			while (1) {
+				snprintf(ppp->dev->name, IFNAMSIZ, "ppp%i", ret);
+				if (!__dev_get_by_name(ppp->ppp_net, ppp->dev->name))
+					break;
+				unit_put(&pn->units_idr, ret);
+				ret = unit_get(&pn->units_idr, ppp, ret + 1);
+				if (ret < 0)
+					goto err;
+			}
+		}
 	} else {
 		/* Caller asked for a specific unit number. Fail with -EEXIST
 		 * if unavailable. For backward compatibility, return -EEXIST
@@ -3266,9 +3277,9 @@ static int unit_set(struct idr *p, void *ptr, int n)
 }
 
 /* get new free unit number and associate pointer with it */
-static int unit_get(struct idr *p, void *ptr)
+static int unit_get(struct idr *p, void *ptr, int min)
 {
-	return idr_alloc(p, ptr, 0, 0, GFP_KERNEL);
+	return idr_alloc(p, ptr, min, 0, GFP_KERNEL);
 }
 
 /* put unit number back to a pool */
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 5435c34dfcc7..d18a283a0ccf 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -750,12 +750,16 @@ static inline void disable_net_traffic(pegasus_t *pegasus)
 	set_registers(pegasus, EthCtrl0, sizeof(tmp), &tmp);
 }
 
-static inline void get_interrupt_interval(pegasus_t *pegasus)
+static inline int get_interrupt_interval(pegasus_t *pegasus)
 {
 	u16 data;
 	u8 interval;
+	int ret;
+
+	ret = read_eprom_word(pegasus, 4, &data);
+	if (ret < 0)
+		return ret;
 
-	read_eprom_word(pegasus, 4, &data);
 	interval = data >> 8;
 	if (pegasus->usb->speed != USB_SPEED_HIGH) {
 		if (interval < 0x80) {
@@ -770,6 +774,8 @@ static inline void get_interrupt_interval(pegasus_t *pegasus)
 		}
 	}
 	pegasus->intr_interval = interval;
+
+	return 0;
 }
 
 static void set_carrier(struct net_device *net)
@@ -1188,7 +1194,9 @@ static int pegasus_probe(struct usb_interface *intf,
 				| NETIF_MSG_PROBE | NETIF_MSG_LINK);
 
 	pegasus->features = usb_dev_id[dev_index].private;
-	get_interrupt_interval(pegasus);
+	res = get_interrupt_interval(pegasus);
+	if (res)
+		goto out2;
 	if (reset_mac(pegasus)) {
 		dev_err(&intf->dev, "can't reset MAC\n");
 		res = -EIO;
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index cd3865f70578..928219ab0912 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -22,6 +22,7 @@
 #include <linux/usb/cdc.h>
 #include <linux/usb/usbnet.h>
 #include <linux/usb/cdc-wdm.h>
+#include <linux/u64_stats_sync.h>
 
 /* This driver supports wwan (3G/LTE/?) devices using a vendor
  * specific management protocol called Qualcomm MSM Interface (QMI) -
@@ -74,6 +75,7 @@ struct qmimux_hdr {
 struct qmimux_priv {
 	struct net_device *real_dev;
 	u8 mux_id;
+	struct pcpu_sw_netstats __percpu *stats64;
 };
 
 static int qmimux_open(struct net_device *dev)
@@ -100,19 +102,65 @@ static netdev_tx_t qmimux_start_xmit(struct sk_buff *skb, struct net_device *dev
 	struct qmimux_priv *priv = netdev_priv(dev);
 	unsigned int len = skb->len;
 	struct qmimux_hdr *hdr;
+	netdev_tx_t ret;
 
 	hdr = skb_push(skb, sizeof(struct qmimux_hdr));
 	hdr->pad = 0;
 	hdr->mux_id = priv->mux_id;
 	hdr->pkt_len = cpu_to_be16(len);
 	skb->dev = priv->real_dev;
-	return dev_queue_xmit(skb);
+	ret = dev_queue_xmit(skb);
+
+	if (likely(ret == NET_XMIT_SUCCESS || ret == NET_XMIT_CN)) {
+		struct pcpu_sw_netstats *stats64 = this_cpu_ptr(priv->stats64);
+
+		u64_stats_update_begin(&stats64->syncp);
+		stats64->tx_packets++;
+		stats64->tx_bytes += len;
+		u64_stats_update_end(&stats64->syncp);
+	} else {
+		dev->stats.tx_dropped++;
+	}
+
+	return ret;
+}
+
+static void qmimux_get_stats64(struct net_device *net,
+			       struct rtnl_link_stats64 *stats)
+{
+	struct qmimux_priv *priv = netdev_priv(net);
+	unsigned int start;
+	int cpu;
+
+	netdev_stats_to_stats64(stats, &net->stats);
+
+	for_each_possible_cpu(cpu) {
+		struct pcpu_sw_netstats *stats64;
+		u64 rx_packets, rx_bytes;
+		u64 tx_packets, tx_bytes;
+
+		stats64 = per_cpu_ptr(priv->stats64, cpu);
+
+		do {
+			start = u64_stats_fetch_begin_irq(&stats64->syncp);
+			rx_packets = stats64->rx_packets;
+			rx_bytes = stats64->rx_bytes;
+			tx_packets = stats64->tx_packets;
+			tx_bytes = stats64->tx_bytes;
+		} while (u64_stats_fetch_retry_irq(&stats64->syncp, start));
+
+		stats->rx_packets += rx_packets;
+		stats->rx_bytes += rx_bytes;
+		stats->tx_packets += tx_packets;
+		stats->tx_bytes += tx_bytes;
+	}
 }
 
 static const struct net_device_ops qmimux_netdev_ops = {
-	.ndo_open       = qmimux_open,
-	.ndo_stop       = qmimux_stop,
-	.ndo_start_xmit = qmimux_start_xmit,
+	.ndo_open        = qmimux_open,
+	.ndo_stop        = qmimux_stop,
+	.ndo_start_xmit  = qmimux_start_xmit,
+	.ndo_get_stats64 = qmimux_get_stats64,
 };
 
 static void qmimux_setup(struct net_device *dev)
@@ -197,8 +245,19 @@ static int qmimux_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		}
 
 		skb_put_data(skbn, skb->data + offset + qmimux_hdr_sz, pkt_len);
-		if (netif_rx(skbn) != NET_RX_SUCCESS)
+		if (netif_rx(skbn) != NET_RX_SUCCESS) {
+			net->stats.rx_errors++;
 			return 0;
+		} else {
+			struct pcpu_sw_netstats *stats64;
+			struct qmimux_priv *priv = netdev_priv(net);
+
+			stats64 = this_cpu_ptr(priv->stats64);
+			u64_stats_update_begin(&stats64->syncp);
+			stats64->rx_packets++;
+			stats64->rx_bytes += pkt_len;
+			u64_stats_update_end(&stats64->syncp);
+		}
 
 skip:
 		offset += len + qmimux_hdr_sz;
@@ -222,6 +281,12 @@ static int qmimux_register_device(struct net_device *real_dev, u8 mux_id)
 	priv->mux_id = mux_id;
 	priv->real_dev = real_dev;
 
+	priv->stats64 = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!priv->stats64) {
+		err = -ENOBUFS;
+		goto out_free_newdev;
+	}
+
 	err = register_netdevice(new_dev);
 	if (err < 0)
 		goto out_free_newdev;
@@ -252,6 +317,7 @@ static void qmimux_unregister_device(struct net_device *dev,
 	struct qmimux_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev = priv->real_dev;
 
+	free_percpu(priv->stats64);
 	netdev_upper_dev_unlink(real_dev, dev);
 	unregister_netdevice_queue(dev, head);
 
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index aae7e6df99cd..ba13e3c3d6b8 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -105,6 +105,7 @@ static int i82092aa_pci_probe(struct pci_dev *dev, const struct pci_device_id *i
 	for (i = 0;i<socket_count;i++) {
 		sockets[i].card_state = 1; /* 1 = present but empty */
 		sockets[i].io_base = pci_resource_start(dev, 0);
+		sockets[i].dev = dev;
 		sockets[i].socket.features |= SS_CAP_PCCARD;
 		sockets[i].socket.map_size = 0x1000;
 		sockets[i].socket.irq_mask = 0;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a46fbe2d2ee6..be2daf5536ff 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -217,7 +217,7 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
 	else if (med->media_event_code == 3)
-		return DISK_EVENT_EJECT_REQUEST;
+		return DISK_EVENT_MEDIA_CHANGE;
 	return 0;
 }
 
diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index a5b0df7e6131..4d1d7053291b 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -599,6 +599,8 @@ static int meson_spicc_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(spicc->core);
 
+	spi_master_put(spicc->master);
+
 	return 0;
 }
 
diff --git a/drivers/staging/rtl8723bs/hal/sdio_ops.c b/drivers/staging/rtl8723bs/hal/sdio_ops.c
index 1d1b14dedd35..689e544a506a 100644
--- a/drivers/staging/rtl8723bs/hal/sdio_ops.c
+++ b/drivers/staging/rtl8723bs/hal/sdio_ops.c
@@ -1118,6 +1118,8 @@ void sd_int_dpc(struct adapter *padapter)
 				} else {
 					rtw_c2h_wk_cmd(padapter, (u8 *)c2h_evt);
 				}
+			} else {
+				kfree(c2h_evt);
 			}
 		} else {
 			/* Error handling for malloc fail */
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 25e8ccd6865a..20f58e9da2fb 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -314,7 +314,11 @@ static const struct serial8250_config uart_config[] = {
 /* Uart divisor latch read */
 static int default_serial_dl_read(struct uart_8250_port *up)
 {
-	return serial_in(up, UART_DLL) | serial_in(up, UART_DLM) << 8;
+	/* Assign these in pieces to truncate any bits above 7.  */
+	unsigned char dll = serial_in(up, UART_DLL);
+	unsigned char dlm = serial_in(up, UART_DLM);
+
+	return dll | dlm << 8;
 }
 
 /* Uart divisor latch write */
@@ -1302,9 +1306,11 @@ static void autoconfig(struct uart_8250_port *up)
 	serial_out(up, UART_LCR, 0);
 
 	serial_out(up, UART_FCR, UART_FCR_ENABLE_FIFO);
-	scratch = serial_in(up, UART_IIR) >> 6;
 
-	switch (scratch) {
+	/* Assign this as it is to truncate any bits above 7.  */
+	scratch = serial_in(up, UART_IIR);
+
+	switch (scratch >> 6) {
 	case 0:
 		autoconfig_8250(up);
 		break;
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 6ebfabfa0dc7..ee6cba310448 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1343,16 +1343,10 @@ static void usbtmc_interrupt(struct urb *urb)
 	case -EOVERFLOW:
 		dev_err(dev, "overflow with length %d, actual length is %d\n",
 			data->iin_wMaxPacketSize, urb->actual_length);
-	case -ECONNRESET:
-	case -ENOENT:
-	case -ESHUTDOWN:
-	case -EILSEQ:
-	case -ETIME:
+	default:
 		/* urb terminated, clean up */
 		dev_dbg(dev, "urb terminated, status: %d\n", status);
 		return;
-	default:
-		dev_err(dev, "unknown status received: %d\n", status);
 	}
 exit:
 	rv = usb_submit_urb(urb, GFP_ATOMIC);
diff --git a/drivers/usb/common/usb-otg-fsm.c b/drivers/usb/common/usb-otg-fsm.c
index b8fe31e409a5..a8b91f825e1a 100644
--- a/drivers/usb/common/usb-otg-fsm.c
+++ b/drivers/usb/common/usb-otg-fsm.c
@@ -206,7 +206,11 @@ static void otg_start_hnp_polling(struct otg_fsm *fsm)
 	if (!fsm->host_req_flag)
 		return;
 
-	INIT_DELAYED_WORK(&fsm->hnp_polling_work, otg_hnp_polling_work);
+	if (!fsm->hnp_work_inited) {
+		INIT_DELAYED_WORK(&fsm->hnp_polling_work, otg_hnp_polling_work);
+		fsm->hnp_work_inited = true;
+	}
+
 	schedule_delayed_work(&fsm->hnp_polling_work,
 					msecs_to_jiffies(T_HOST_REQ_POLL));
 }
diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index e9b772a9902b..74ddb44631a3 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -45,6 +45,7 @@ struct f_hidg {
 	unsigned char			bInterfaceSubClass;
 	unsigned char			bInterfaceProtocol;
 	unsigned char			protocol;
+	unsigned char			idle;
 	unsigned short			report_desc_length;
 	char				*report_desc;
 	unsigned short			report_length;
@@ -348,6 +349,11 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 
 	spin_lock_irqsave(&hidg->write_spinlock, flags);
 
+	if (!hidg->req) {
+		spin_unlock_irqrestore(&hidg->write_spinlock, flags);
+		return -ESHUTDOWN;
+	}
+
 #define WRITE_COND (!hidg->write_pending)
 try_again:
 	/* write queue */
@@ -368,8 +374,14 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 	count  = min_t(unsigned, count, hidg->report_length);
 
 	spin_unlock_irqrestore(&hidg->write_spinlock, flags);
-	status = copy_from_user(req->buf, buffer, count);
 
+	if (!req) {
+		ERROR(hidg->func.config->cdev, "hidg->req is NULL\n");
+		status = -ESHUTDOWN;
+		goto release_write_pending;
+	}
+
+	status = copy_from_user(req->buf, buffer, count);
 	if (status != 0) {
 		ERROR(hidg->func.config->cdev,
 			"copy_from_user error\n");
@@ -397,14 +409,17 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 
 	spin_unlock_irqrestore(&hidg->write_spinlock, flags);
 
+	if (!hidg->in_ep->enabled) {
+		ERROR(hidg->func.config->cdev, "in_ep is disabled\n");
+		status = -ESHUTDOWN;
+		goto release_write_pending;
+	}
+
 	status = usb_ep_queue(hidg->in_ep, req, GFP_ATOMIC);
-	if (status < 0) {
-		ERROR(hidg->func.config->cdev,
-			"usb_ep_queue error on int endpoint %zd\n", status);
+	if (status < 0)
 		goto release_write_pending;
-	} else {
+	else
 		status = count;
-	}
 
 	return status;
 release_write_pending:
@@ -533,6 +548,14 @@ static int hidg_setup(struct usb_function *f,
 		goto respond;
 		break;
 
+	case ((USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
+		  | HID_REQ_GET_IDLE):
+		VDBG(cdev, "get_idle\n");
+		length = min_t(unsigned int, length, 1);
+		((u8 *) req->buf)[0] = hidg->idle;
+		goto respond;
+		break;
+
 	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
 		  | HID_REQ_SET_REPORT):
 		VDBG(cdev, "set_report | wLength=%d\n", ctrl->wLength);
@@ -556,6 +579,14 @@ static int hidg_setup(struct usb_function *f,
 		goto stall;
 		break;
 
+	case ((USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE) << 8
+		  | HID_REQ_SET_IDLE):
+		VDBG(cdev, "set_idle\n");
+		length = 0;
+		hidg->idle = value >> 8;
+		goto respond;
+		break;
+
 	case ((USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_INTERFACE) << 8
 		  | USB_REQ_GET_DESCRIPTOR):
 		switch (value >> 8) {
@@ -783,6 +814,7 @@ static int hidg_bind(struct usb_configuration *c, struct usb_function *f)
 	hidg_interface_desc.bInterfaceSubClass = hidg->bInterfaceSubClass;
 	hidg_interface_desc.bInterfaceProtocol = hidg->bInterfaceProtocol;
 	hidg->protocol = HID_REPORT_PROTOCOL;
+	hidg->idle = 1;
 	hidg_ss_in_ep_desc.wMaxPacketSize = cpu_to_le16(hidg->report_length);
 	hidg_ss_in_comp_desc.wBytesPerInterval =
 				cpu_to_le16(hidg->report_length);
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 265c9af1d2b5..d0deff8c81a3 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -311,6 +311,9 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 	if (pdev->vendor == PCI_VENDOR_ID_STMICRO
 	    && pdev->device == PCI_DEVICE_ID_STMICRO_USB_HOST)
 		;	/* ConneXT has no sbrn register */
+	else if (pdev->vendor == PCI_VENDOR_ID_HUAWEI
+			 && pdev->device == 0xa239)
+		;	/* HUAWEI Kunpeng920 USB EHCI has no sbrn register */
 	else
 		pci_read_config_byte(pdev, 0x60, &ehci->sbrn);
 
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 4ae7afc68bde..86ca2405942b 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -628,6 +628,7 @@ static struct usb_serial_driver ch341_device = {
 		.owner	= THIS_MODULE,
 		.name	= "ch341-uart",
 	},
+	.bulk_in_size      = 512,
 	.id_table          = id_table,
 	.num_ports         = 1,
 	.open              = ch341_open,
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 1196b0dcf828..bcf4ba4f9819 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -214,6 +214,7 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_MTXORB_6_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_R2000KU_TRUE_RNG) },
 	{ USB_DEVICE(FTDI_VID, FTDI_VARDAAN_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_AUTO_M3_OP_COM_V2_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0100_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0101_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_0102_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index add602bebd82..755858ca20ba 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -159,6 +159,9 @@
 /* Vardaan Enterprises Serial Interface VEUSB422R3 */
 #define FTDI_VARDAAN_PID	0xF070
 
+/* Auto-M3 Ltd. - OP-COM USB V2 - OBD interface Adapter */
+#define FTDI_AUTO_M3_OP_COM_V2_PID	0x4f50
+
 /*
  * Xsens Technologies BV products (http://www.xsens.com).
  */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index fa9e3a2ddd01..5482e7a973d1 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1206,6 +1206,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1055, 0xff),	/* Telit FN980 (PCIe) */
 	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1056, 0xff),	/* Telit FD980 */
+	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 83bdae81721d..9a138a6dc17e 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2295,7 +2295,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 				goto journal_error;
 			err = ext4_handle_dirty_dx_node(handle, dir,
 							frame->bh);
-			if (err)
+			if (restart || err)
 				goto journal_error;
 		} else {
 			struct dx_root *dxroot;
diff --git a/fs/namespace.c b/fs/namespace.c
index c8acc60c456d..473446ae9e9b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1879,6 +1879,20 @@ void drop_collected_mounts(struct vfsmount *mnt)
 	namespace_unlock();
 }
 
+static bool has_locked_children(struct mount *mnt, struct dentry *dentry)
+{
+	struct mount *child;
+
+	list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
+		if (!is_subdir(child->mnt_mountpoint, dentry))
+			continue;
+
+		if (child->mnt.mnt_flags & MNT_LOCKED)
+			return true;
+	}
+	return false;
+}
+
 /**
  * clone_private_mount - create a private clone of a path
  *
@@ -1893,14 +1907,27 @@ struct vfsmount *clone_private_mount(const struct path *path)
 	struct mount *old_mnt = real_mount(path->mnt);
 	struct mount *new_mnt;
 
+	down_read(&namespace_sem);
 	if (IS_MNT_UNBINDABLE(old_mnt))
-		return ERR_PTR(-EINVAL);
+		goto invalid;
+
+	if (!check_mnt(old_mnt))
+		goto invalid;
+
+	if (has_locked_children(old_mnt, path->dentry))
+		goto invalid;
 
 	new_mnt = clone_mnt(old_mnt, path->dentry, CL_PRIVATE);
+	up_read(&namespace_sem);
+
 	if (IS_ERR(new_mnt))
 		return ERR_CAST(new_mnt);
 
 	return &new_mnt->mnt;
+
+invalid:
+	up_read(&namespace_sem);
+	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(clone_private_mount);
 
@@ -2216,19 +2243,6 @@ static int do_change_type(struct path *path, int ms_flags)
 	return err;
 }
 
-static bool has_locked_children(struct mount *mnt, struct dentry *dentry)
-{
-	struct mount *child;
-	list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
-		if (!is_subdir(child->mnt_mountpoint, dentry))
-			continue;
-
-		if (child->mnt.mnt_flags & MNT_LOCKED)
-			return true;
-	}
-	return false;
-}
-
 /*
  * do loopback mount.
  */
diff --git a/fs/pipe.c b/fs/pipe.c
index fa3c2c25cec5..0523dd148ed3 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -29,6 +29,21 @@
 
 #include "internal.h"
 
+/*
+ * New pipe buffers will be restricted to this size while the user is exceeding
+ * their pipe buffer quota. The general pipe use case needs at least two
+ * buffers: one for data yet to be read, and one for new data. If this is less
+ * than two, then a write to a non-empty pipe may block even if the pipe is not
+ * full. This can occur with GNU make jobserver or similar uses of pipes as
+ * semaphores: multiple processes may be waiting to write tokens back to the
+ * pipe before reading tokens: https://lore.kernel.org/lkml/1628086770.5rn8p04n6j.none@localhost/.
+ *
+ * Users can reduce their pipe buffers with F_SETPIPE_SZ below this at their
+ * own risk, namely: pipe writes to non-full pipes may block until the pipe is
+ * emptied.
+ */
+#define PIPE_MIN_DEF_BUFFERS 2
+
 /*
  * The max size that a non-root user is allowed to grow the pipe. Can
  * be set by root in /proc/sys/fs/pipe-max-size
@@ -654,8 +669,8 @@ struct pipe_inode_info *alloc_pipe_info(void)
 	user_bufs = account_pipe_buffers(user, 0, pipe_bufs);
 
 	if (too_many_pipe_buffers_soft(user_bufs) && is_unprivileged_user()) {
-		user_bufs = account_pipe_buffers(user, pipe_bufs, 1);
-		pipe_bufs = 1;
+		user_bufs = account_pipe_buffers(user, pipe_bufs, PIPE_MIN_DEF_BUFFERS);
+		pipe_bufs = PIPE_MIN_DEF_BUFFERS;
 	}
 
 	if (too_many_pipe_buffers_hard(user_bufs) && is_unprivileged_user())
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 5229038852ca..4ebad6781b0e 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -387,6 +387,24 @@ void pathrelse(struct treepath *search_path)
 	search_path->path_length = ILLEGAL_PATH_ELEMENT_OFFSET;
 }
 
+static int has_valid_deh_location(struct buffer_head *bh, struct item_head *ih)
+{
+	struct reiserfs_de_head *deh;
+	int i;
+
+	deh = B_I_DEH(bh, ih);
+	for (i = 0; i < ih_entry_count(ih); i++) {
+		if (deh_location(&deh[i]) > ih_item_len(ih)) {
+			reiserfs_warning(NULL, "reiserfs-5094",
+					 "directory entry location seems wrong %h",
+					 &deh[i]);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
 static int is_leaf(char *buf, int blocksize, struct buffer_head *bh)
 {
 	struct block_head *blkh;
@@ -454,11 +472,14 @@ static int is_leaf(char *buf, int blocksize, struct buffer_head *bh)
 					 "(second one): %h", ih);
 			return 0;
 		}
-		if (is_direntry_le_ih(ih) && (ih_item_len(ih) < (ih_entry_count(ih) * IH_SIZE))) {
-			reiserfs_warning(NULL, "reiserfs-5093",
-					 "item entry count seems wrong %h",
-					 ih);
-			return 0;
+		if (is_direntry_le_ih(ih)) {
+			if (ih_item_len(ih) < (ih_entry_count(ih) * IH_SIZE)) {
+				reiserfs_warning(NULL, "reiserfs-5093",
+						 "item entry count seems wrong %h",
+						 ih);
+				return 0;
+			}
+			return has_valid_deh_location(bh, ih);
 		}
 		prev_location = ih_location(ih);
 	}
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index fbae5f4eea09..7dfdc503e601 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2085,6 +2085,14 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 		unlock_new_inode(root_inode);
 	}
 
+	if (!S_ISDIR(root_inode->i_mode) || !inode_get_bytes(root_inode) ||
+	    !root_inode->i_size) {
+		SWARN(silent, s, "", "corrupt root inode, run fsck");
+		iput(root_inode);
+		errval = -EUCLEAN;
+		goto error;
+	}
+
 	s->s_root = d_make_root(root_inode);
 	if (!s->s_root)
 		goto error;
diff --git a/include/linux/usb/otg-fsm.h b/include/linux/usb/otg-fsm.h
index a0a8f878503c..31b204084d5f 100644
--- a/include/linux/usb/otg-fsm.h
+++ b/include/linux/usb/otg-fsm.h
@@ -195,6 +195,7 @@ struct otg_fsm {
 	struct mutex lock;
 	u8 *host_req_flag;
 	struct delayed_work hnp_polling_work;
+	bool hnp_work_inited;
 	bool state_changed;
 };
 
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 0cc5e2b4bbf4..51afaaa68408 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1030,6 +1030,7 @@ struct hci_dev *hci_alloc_dev(void);
 void hci_free_dev(struct hci_dev *hdev);
 int hci_register_dev(struct hci_dev *hdev);
 void hci_unregister_dev(struct hci_dev *hdev);
+void hci_cleanup_dev(struct hci_dev *hdev);
 int hci_suspend_dev(struct hci_dev *hdev);
 int hci_resume_dev(struct hci_dev *hdev);
 int hci_reset_dev(struct hci_dev *hdev);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index ba5c899d1edf..3b2dd98e9fd6 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3181,14 +3181,10 @@ EXPORT_SYMBOL(hci_register_dev);
 /* Unregister HCI device */
 void hci_unregister_dev(struct hci_dev *hdev)
 {
-	int id;
-
 	BT_DBG("%p name %s bus %d", hdev, hdev->name, hdev->bus);
 
 	hci_dev_set_flag(hdev, HCI_UNREGISTER);
 
-	id = hdev->id;
-
 	write_lock(&hci_dev_list_lock);
 	list_del(&hdev->list);
 	write_unlock(&hci_dev_list_lock);
@@ -3217,7 +3213,14 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	}
 
 	device_del(&hdev->dev);
+	/* Actual cleanup is deferred until hci_cleanup_dev(). */
+	hci_dev_put(hdev);
+}
+EXPORT_SYMBOL(hci_unregister_dev);
 
+/* Cleanup HCI device */
+void hci_cleanup_dev(struct hci_dev *hdev)
+{
 	debugfs_remove_recursive(hdev->debugfs);
 	kfree_const(hdev->hw_info);
 	kfree_const(hdev->fw_info);
@@ -3239,11 +3242,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	hci_discovery_filter_clear(hdev);
 	hci_dev_unlock(hdev);
 
-	hci_dev_put(hdev);
-
-	ida_simple_remove(&hci_index_ida, id);
+	ida_simple_remove(&hci_index_ida, hdev->id);
 }
-EXPORT_SYMBOL(hci_unregister_dev);
 
 /* Suspend HCI device */
 int hci_suspend_dev(struct hci_dev *hdev)
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 120064e9cb2b..1ad569581165 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -59,6 +59,17 @@ struct hci_pinfo {
 	char              comm[TASK_COMM_LEN];
 };
 
+static struct hci_dev *hci_hdev_from_sock(struct sock *sk)
+{
+	struct hci_dev *hdev = hci_pi(sk)->hdev;
+
+	if (!hdev)
+		return ERR_PTR(-EBADFD);
+	if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
+		return ERR_PTR(-EPIPE);
+	return hdev;
+}
+
 void hci_sock_set_flag(struct sock *sk, int nr)
 {
 	set_bit(nr, &hci_pi(sk)->flags);
@@ -747,19 +758,13 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 	if (event == HCI_DEV_UNREG) {
 		struct sock *sk;
 
-		/* Detach sockets from device */
+		/* Wake up sockets using this dead device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
-			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
-				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
-				sk->sk_state = BT_OPEN;
 				sk->sk_state_change(sk);
-
-				hci_dev_put(hdev);
 			}
-			release_sock(sk);
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
@@ -918,10 +923,10 @@ static int hci_sock_blacklist_del(struct hci_dev *hdev, void __user *arg)
 static int hci_sock_bound_ioctl(struct sock *sk, unsigned int cmd,
 				unsigned long arg)
 {
-	struct hci_dev *hdev = hci_pi(sk)->hdev;
+	struct hci_dev *hdev = hci_hdev_from_sock(sk);
 
-	if (!hdev)
-		return -EBADFD;
+	if (IS_ERR(hdev))
+		return PTR_ERR(hdev);
 
 	if (hci_dev_test_flag(hdev, HCI_USER_CHANNEL))
 		return -EBUSY;
@@ -1075,6 +1080,18 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
 
 	lock_sock(sk);
 
+	/* Allow detaching from dead device and attaching to alive device, if
+	 * the caller wants to re-bind (instead of close) this socket in
+	 * response to hci_sock_dev_event(HCI_DEV_UNREG) notification.
+	 */
+	hdev = hci_pi(sk)->hdev;
+	if (hdev && hci_dev_test_flag(hdev, HCI_UNREGISTER)) {
+		hci_pi(sk)->hdev = NULL;
+		sk->sk_state = BT_OPEN;
+		hci_dev_put(hdev);
+	}
+	hdev = NULL;
+
 	if (sk->sk_state == BT_BOUND) {
 		err = -EALREADY;
 		goto done;
@@ -1351,9 +1368,9 @@ static int hci_sock_getname(struct socket *sock, struct sockaddr *addr,
 
 	lock_sock(sk);
 
-	hdev = hci_pi(sk)->hdev;
-	if (!hdev) {
-		err = -EBADFD;
+	hdev = hci_hdev_from_sock(sk);
+	if (IS_ERR(hdev)) {
+		err = PTR_ERR(hdev);
 		goto done;
 	}
 
@@ -1713,9 +1730,9 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto done;
 	}
 
-	hdev = hci_pi(sk)->hdev;
-	if (!hdev) {
-		err = -EBADFD;
+	hdev = hci_hdev_from_sock(sk);
+	if (IS_ERR(hdev)) {
+		err = PTR_ERR(hdev);
 		goto done;
 	}
 
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index d5c7c89ec4d6..b568f7c21b30 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -83,6 +83,9 @@ void hci_conn_del_sysfs(struct hci_conn *conn)
 static void bt_host_release(struct device *dev)
 {
 	struct hci_dev *hdev = to_hci_dev(dev);
+
+	if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
+		hci_cleanup_dev(hdev);
 	kfree(hdev);
 	module_put(THIS_MODULE);
 }
diff --git a/scripts/tracing/draw_functrace.py b/scripts/tracing/draw_functrace.py
index 30f117dfab43..68ecb455b492 100755
--- a/scripts/tracing/draw_functrace.py
+++ b/scripts/tracing/draw_functrace.py
@@ -17,7 +17,7 @@ Usage:
 	$ cat /sys/kernel/debug/tracing/trace_pipe > ~/raw_trace_func
 	Wait some times but not too much, the script is a bit slow.
 	Break the pipe (Ctrl + Z)
-	$ scripts/draw_functrace.py < raw_trace_func > draw_functrace
+	$ scripts/tracing/draw_functrace.py < ~/raw_trace_func > draw_functrace
 	Then you have your drawn trace in draw_functrace
 """
 
@@ -103,10 +103,10 @@ def parseLine(line):
 	line = line.strip()
 	if line.startswith("#"):
 		raise CommentLineException
-	m = re.match("[^]]+?\\] +([0-9.]+): (\\w+) <-(\\w+)", line)
+	m = re.match("[^]]+?\\] +([a-z.]+) +([0-9.]+): (\\w+) <-(\\w+)", line)
 	if m is None:
 		raise BrokenLineException
-	return (m.group(1), m.group(2), m.group(3))
+	return (m.group(2), m.group(3), m.group(4))
 
 
 def main():
diff --git a/sound/core/seq/seq_ports.c b/sound/core/seq/seq_ports.c
index c8fa4336bccd..86fb5eea9e4d 100644
--- a/sound/core/seq/seq_ports.c
+++ b/sound/core/seq/seq_ports.c
@@ -532,10 +532,11 @@ static int check_and_subscribe_port(struct snd_seq_client *client,
 	return err;
 }
 
-static void delete_and_unsubscribe_port(struct snd_seq_client *client,
-					struct snd_seq_client_port *port,
-					struct snd_seq_subscribers *subs,
-					bool is_src, bool ack)
+/* called with grp->list_mutex held */
+static void __delete_and_unsubscribe_port(struct snd_seq_client *client,
+					  struct snd_seq_client_port *port,
+					  struct snd_seq_subscribers *subs,
+					  bool is_src, bool ack)
 {
 	struct snd_seq_port_subs_info *grp;
 	struct list_head *list;
@@ -543,7 +544,6 @@ static void delete_and_unsubscribe_port(struct snd_seq_client *client,
 
 	grp = is_src ? &port->c_src : &port->c_dest;
 	list = is_src ? &subs->src_list : &subs->dest_list;
-	down_write(&grp->list_mutex);
 	write_lock_irq(&grp->list_lock);
 	empty = list_empty(list);
 	if (!empty)
@@ -553,6 +553,18 @@ static void delete_and_unsubscribe_port(struct snd_seq_client *client,
 
 	if (!empty)
 		unsubscribe_port(client, port, grp, &subs->info, ack);
+}
+
+static void delete_and_unsubscribe_port(struct snd_seq_client *client,
+					struct snd_seq_client_port *port,
+					struct snd_seq_subscribers *subs,
+					bool is_src, bool ack)
+{
+	struct snd_seq_port_subs_info *grp;
+
+	grp = is_src ? &port->c_src : &port->c_dest;
+	down_write(&grp->list_mutex);
+	__delete_and_unsubscribe_port(client, port, subs, is_src, ack);
 	up_write(&grp->list_mutex);
 }
 
@@ -608,27 +620,30 @@ int snd_seq_port_disconnect(struct snd_seq_client *connector,
 			    struct snd_seq_client_port *dest_port,
 			    struct snd_seq_port_subscribe *info)
 {
-	struct snd_seq_port_subs_info *src = &src_port->c_src;
+	struct snd_seq_port_subs_info *dest = &dest_port->c_dest;
 	struct snd_seq_subscribers *subs;
 	int err = -ENOENT;
 
-	down_write(&src->list_mutex);
+	/* always start from deleting the dest port for avoiding concurrent
+	 * deletions
+	 */
+	down_write(&dest->list_mutex);
 	/* look for the connection */
-	list_for_each_entry(subs, &src->list_head, src_list) {
+	list_for_each_entry(subs, &dest->list_head, dest_list) {
 		if (match_subs_info(info, &subs->info)) {
-			atomic_dec(&subs->ref_count); /* mark as not ready */
+			__delete_and_unsubscribe_port(dest_client, dest_port,
+						      subs, false,
+						      connector->number != dest_client->number);
 			err = 0;
 			break;
 		}
 	}
-	up_write(&src->list_mutex);
+	up_write(&dest->list_mutex);
 	if (err < 0)
 		return err;
 
 	delete_and_unsubscribe_port(src_client, src_port, subs, true,
 				    connector->number != src_client->number);
-	delete_and_unsubscribe_port(dest_client, dest_port, subs, false,
-				    connector->number != dest_client->number);
 	kfree(subs);
 	return 0;
 }
