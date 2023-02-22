Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A8269F3E0
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 13:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjBVMDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 07:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbjBVMDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 07:03:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED18337556;
        Wed, 22 Feb 2023 04:03:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60105613E9;
        Wed, 22 Feb 2023 12:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539D1C433D2;
        Wed, 22 Feb 2023 12:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677067421;
        bh=ZkyBrUBefvj4igrj3dHdkjIIOpcBVHS2KxscW3qUvyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orLps78NW2kSC1P08XAkNwXcgj8qvB9gKS2lfTe5h78z4BIWR52TUkCWOUd59Xqk+
         8Cq7pfiDMKWzml1mieNXklvb5in7QzSChf4SS+6yhcHGJSl2zyBCaG4lRS6yiMRc6I
         awFYotu5L9rf7CtrNo3wl4HdG9QS3bu7wfAMPviE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.306
Date:   Wed, 22 Feb 2023 13:03:35 +0100
Message-Id: <167706741443254@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167706741359197@kroah.com>
References: <167706741359197@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 9722d1518655..581f92d635a8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 305
+SUBLEVEL = 306
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index 6d471c00c71a..906b7c882587 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1197,7 +1197,7 @@ static char __attribute__((aligned(64))) iodc_dbuf[4096];
  */
 int pdc_iodc_print(const unsigned char *str, unsigned count)
 {
-	unsigned int i;
+	unsigned int i, found = 0;
 	unsigned long flags;
 
 	for (i = 0; i < count;) {
@@ -1206,6 +1206,7 @@ int pdc_iodc_print(const unsigned char *str, unsigned count)
 			iodc_dbuf[i+0] = '\r';
 			iodc_dbuf[i+1] = '\n';
 			i += 2;
+			found = 1;
 			goto print;
 		default:
 			iodc_dbuf[i] = str[i];
@@ -1222,7 +1223,7 @@ int pdc_iodc_print(const unsigned char *str, unsigned count)
                     __pa(iodc_retbuf), 0, __pa(iodc_dbuf), i, 0);
         spin_unlock_irqrestore(&pdc_lock, flags);
 
-	return i;
+	return i - found;
 }
 
 #if !defined(BOOTLOADER)
diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index f468a5b44508..c18731c0e834 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -132,6 +132,12 @@ long arch_ptrace(struct task_struct *child, long request,
 	unsigned long tmp;
 	long ret = -EIO;
 
+	unsigned long user_regs_struct_size = sizeof(struct user_regs_struct);
+#ifdef CONFIG_64BIT
+	if (is_compat_task())
+		user_regs_struct_size /= 2;
+#endif
+
 	switch (request) {
 
 	/* Read the word at location addr in the USER area.  For ptraced
@@ -187,14 +193,14 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_to_user(child,
 					   task_user_regset_view(current),
 					   REGSET_GENERAL,
-					   0, sizeof(struct user_regs_struct),
+					   0, user_regs_struct_size,
 					   datap);
 
 	case PTRACE_SETREGS:	/* Set all gp regs in the child. */
 		return copy_regset_from_user(child,
 					     task_user_regset_view(current),
 					     REGSET_GENERAL,
-					     0, sizeof(struct user_regs_struct),
+					     0, user_regs_struct_size,
 					     datap);
 
 	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
@@ -308,6 +314,11 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 			}
 		}
 		break;
+	case PTRACE_GETREGS:
+	case PTRACE_SETREGS:
+	case PTRACE_GETFPREGS:
+	case PTRACE_SETFPREGS:
+		return arch_ptrace(child, request, addr, data);
 
 	default:
 		ret = compat_ptrace_request(child, request, addr, data);
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index a3a570df6be1..9692ccc583bb 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -138,6 +138,9 @@ static void __init fpu__init_system_generic(void)
 unsigned int fpu_kernel_xstate_size;
 EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
 
+/* Get alignment of the TYPE. */
+#define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
+
 /*
  * Enforce that 'MEMBER' is the last field of 'TYPE'.
  *
@@ -145,8 +148,8 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
  * because that's how C aligns structs.
  */
 #define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \
-	BUILD_BUG_ON(sizeof(TYPE) !=         \
-		     ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))
+	BUILD_BUG_ON(sizeof(TYPE) != ALIGN(offsetofend(TYPE, MEMBER), \
+					   TYPE_ALIGN(TYPE)))
 
 /*
  * We append the 'struct fpu' to the task_struct:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4729492b8448..ffd0afab702d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3419,12 +3419,11 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 {
 	unsigned long val;
 
+	memset(dbgregs, 0, sizeof(*dbgregs));
 	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
 	kvm_get_dr(vcpu, 6, &val);
 	dbgregs->dr6 = val;
 	dbgregs->dr7 = vcpu->arch.dr7;
-	dbgregs->flags = 0;
-	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index d3fb350dc9ee..bf4db708f0bd 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -783,7 +783,13 @@ static int __init sunxi_rsb_init(void)
 		return ret;
 	}
 
-	return platform_driver_register(&sunxi_rsb_driver);
+	ret = platform_driver_register(&sunxi_rsb_driver);
+	if (ret) {
+		bus_unregister(&sunxi_rsb_bus);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(sunxi_rsb_init);
 
diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 00cea6cb5ef7..bedc62efdd93 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -831,8 +831,10 @@ static int ioctl_send_response(struct client *client, union ioctl_arg *arg)
 
 	r = container_of(resource, struct inbound_transaction_resource,
 			 resource);
-	if (is_fcp_request(r->request))
+	if (is_fcp_request(r->request)) {
+		kfree(r->data);
 		goto out;
+	}
 
 	if (a->length != fw_get_response_length(r->request)) {
 		ret = -EINVAL;
diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index e0889922cc6d..a1ef30fca360 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -35,7 +35,7 @@ int __init efi_memattr_init(void)
 		return -ENOMEM;
 	}
 
-	if (tbl->version > 1) {
+	if (tbl->version > 2) {
 		pr_warn("Unexpected EFI Memory Attributes table version %d\n",
 			tbl->version);
 		goto unmap;
diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
index fc210d88bba9..fa3fc493a8d1 100644
--- a/drivers/iio/accel/hid-sensor-accel-3d.c
+++ b/drivers/iio/accel/hid-sensor-accel-3d.c
@@ -293,6 +293,7 @@ static int accel_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
 			hid_sensor_convert_timestamp(
 					&accel_state->common_attributes,
 					*(int64_t *)raw_data);
+		ret = 0;
 	break;
 	default:
 		break;
diff --git a/drivers/iio/adc/berlin2-adc.c b/drivers/iio/adc/berlin2-adc.c
index 71c806ecc722..a4b5747ac3d4 100644
--- a/drivers/iio/adc/berlin2-adc.c
+++ b/drivers/iio/adc/berlin2-adc.c
@@ -290,8 +290,10 @@ static int berlin2_adc_probe(struct platform_device *pdev)
 	int ret;
 
 	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*priv));
-	if (!indio_dev)
+	if (!indio_dev) {
+		of_node_put(parent_np);
 		return -ENOMEM;
+	}
 
 	priv = iio_priv(indio_dev);
 	platform_set_drvdata(pdev, indio_dev);
diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
index 6a4ec58eb9c5..8ccd0bc23ca8 100644
--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -71,6 +71,18 @@
 #define TWL6030_GPADCS				BIT(1)
 #define TWL6030_GPADCR				BIT(0)
 
+#define USB_VBUS_CTRL_SET			0x04
+#define USB_ID_CTRL_SET				0x06
+
+#define TWL6030_MISC1				0xE4
+#define VBUS_MEAS				0x01
+#define ID_MEAS					0x01
+
+#define VAC_MEAS                0x04
+#define VBAT_MEAS               0x02
+#define BB_MEAS                 0x01
+
+
 /**
  * struct twl6030_chnl_calib - channel calibration
  * @gain:		slope coefficient for ideal curve
@@ -943,6 +955,26 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = twl_i2c_write_u8(TWL_MODULE_USB, VBUS_MEAS, USB_VBUS_CTRL_SET);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
+	ret = twl_i2c_write_u8(TWL_MODULE_USB, ID_MEAS, USB_ID_CTRL_SET);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID0,
+				VBAT_MEAS | BB_MEAS | BB_MEAS,
+				TWL6030_MISC1);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
 	indio_dev->name = DRIVER_NAME;
 	indio_dev->dev.parent = dev;
 	indio_dev->info = &twl6030_gpadc_iio_info;
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 2441799605dd..d9be64aeae70 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -267,6 +267,12 @@ static void sdio_release_func(struct device *dev)
 	if (!(func->card->quirks & MMC_QUIRK_NONSTD_SDIO))
 		sdio_free_func_cis(func);
 
+	/*
+	 * We have now removed the link to the tuples in the
+	 * card structure, so remove the reference.
+	 */
+	put_device(&func->card->dev);
+
 	kfree(func->info);
 	kfree(func->tmpbuf);
 	kfree(func);
@@ -297,6 +303,12 @@ struct sdio_func *sdio_alloc_func(struct mmc_card *card)
 
 	device_initialize(&func->dev);
 
+	/*
+	 * We may link to tuples in the card structure,
+	 * we need make sure we have a reference to it.
+	 */
+	get_device(&func->card->dev);
+
 	func->dev.parent = &card->dev;
 	func->dev.bus = &sdio_bus_type;
 	func->dev.release = sdio_release_func;
@@ -350,10 +362,9 @@ int sdio_add_func(struct sdio_func *func)
  */
 void sdio_remove_func(struct sdio_func *func)
 {
-	if (!sdio_func_present(func))
-		return;
+	if (sdio_func_present(func))
+		device_del(&func->dev);
 
-	device_del(&func->dev);
 	of_node_put(func->dev.of_node);
 	put_device(&func->dev);
 }
diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index dca72444b312..f741eb24c3de 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -387,12 +387,6 @@ int sdio_read_func_cis(struct sdio_func *func)
 	if (ret)
 		return ret;
 
-	/*
-	 * Since we've linked to tuples in the card structure,
-	 * we must make sure we have a reference to it.
-	 */
-	get_device(&func->card->dev);
-
 	/*
 	 * Vendor/device id is optional for function CIS, so
 	 * copy it from the card structure as needed.
@@ -418,11 +412,5 @@ void sdio_free_func_cis(struct sdio_func *func)
 	}
 
 	func->tuples = NULL;
-
-	/*
-	 * We have now removed the link to the tuples in the
-	 * card structure, so remove the reference.
-	 */
-	put_device(&func->card->dev);
 }
 
diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 98f1057650da..5464252793ef 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -222,12 +222,12 @@ static int bgmac_probe(struct bcma_device *core)
 		bgmac->feature_flags |= BGMAC_FEAT_CLKCTLST;
 		bgmac->feature_flags |= BGMAC_FEAT_FLW_CTRL1;
 		bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_PHY;
-		if (ci->pkg == BCMA_PKG_ID_BCM47188 ||
-		    ci->pkg == BCMA_PKG_ID_BCM47186) {
+		if ((ci->id == BCMA_CHIP_ID_BCM5357 && ci->pkg == BCMA_PKG_ID_BCM47186) ||
+		    (ci->id == BCMA_CHIP_ID_BCM53572 && ci->pkg == BCMA_PKG_ID_BCM47188)) {
 			bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_RGMII;
 			bgmac->feature_flags |= BGMAC_FEAT_IOST_ATTACHED;
 		}
-		if (ci->pkg == BCMA_PKG_ID_BCM5358)
+		if (ci->id == BCMA_CHIP_ID_BCM5357 && ci->pkg == BCMA_PKG_ID_BCM5358)
 			bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_EPHYRMII;
 		break;
 	case BCMA_CHIP_ID_BCM53573:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index db1d784d4bd7..de8a713db078 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2480,7 +2480,7 @@ static int i40e_change_mtu(struct net_device *netdev, int new_mtu)
 	struct i40e_pf *pf = vsi->back;
 
 	if (i40e_enabled_xdp_vsi(vsi)) {
-		int frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+		int frame_size = new_mtu + I40E_PACKET_HDR_PAD;
 
 		if (frame_size > i40e_max_xdp_frame_size(vsi))
 			return -EINVAL;
@@ -9453,6 +9453,8 @@ static int i40e_ndo_bridge_setlink(struct net_device *dev,
 	}
 
 	br_spec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_AF_SPEC);
+	if (!br_spec)
+		return -EINVAL;
 
 	nla_for_each_nested(attr, br_spec, rem) {
 		__u16 mode;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 07951b43de21..6fef12235ae4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -500,7 +500,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	dma_cfg->mixed_burst = of_property_read_bool(np, "snps,mixed-burst");
 
 	plat->force_thresh_dma_mode = of_property_read_bool(np, "snps,force_thresh_dma_mode");
-	if (plat->force_thresh_dma_mode) {
+	if (plat->force_thresh_dma_mode && plat->force_sf_dma_mode) {
 		plat->force_sf_dma_mode = 0;
 		pr_warn("force_sf_dma_mode is ignored if force_thresh_dma_mode is set.");
 	}
diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
index c677ec2bae18..840099580f4e 100644
--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -69,8 +69,8 @@ kalmia_send_init_packet(struct usbnet *dev, u8 *init_msg, u8 init_msg_len,
 		init_msg, init_msg_len, &act_len, KALMIA_USB_TIMEOUT);
 	if (status != 0) {
 		netdev_err(dev->net,
-			"Error sending init packet. Status %i, length %i\n",
-			status, act_len);
+			"Error sending init packet. Status %i\n",
+			status);
 		return status;
 	}
 	else if (act_len != init_msg_len) {
@@ -87,8 +87,8 @@ kalmia_send_init_packet(struct usbnet *dev, u8 *init_msg, u8 init_msg_len,
 
 	if (status != 0)
 		netdev_err(dev->net,
-			"Error receiving init result. Status %i, length %i\n",
-			status, act_len);
+			"Error receiving init result. Status %i\n",
+			status);
 	else if (act_len != expected_len)
 		netdev_err(dev->net, "Unexpected init result length: %i\n",
 			act_len);
diff --git a/drivers/net/usb/plusb.c b/drivers/net/usb/plusb.c
index 6fe59373cba9..8bab7306e5a6 100644
--- a/drivers/net/usb/plusb.c
+++ b/drivers/net/usb/plusb.c
@@ -69,9 +69,7 @@
 static inline int
 pl_vendor_req(struct usbnet *dev, u8 req, u8 val, u8 index)
 {
-	return usbnet_read_cmd(dev, req,
-				USB_DIR_IN | USB_TYPE_VENDOR |
-				USB_RECIP_DEVICE,
+	return usbnet_write_cmd(dev, req, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				val, index, NULL, 0);
 }
 
diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index df1c6dee255b..b702bdc58955 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1301,8 +1301,10 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
 		else {
 			queue = nvmet_fc_alloc_target_queue(iod->assoc, 0,
 					be16_to_cpu(rqst->assoc_cmd.sqsize));
-			if (!queue)
+			if (!queue) {
 				ret = VERR_QUEUE_ALLOC_FAIL;
+				nvmet_fc_tgt_a_put(iod->assoc);
+			}
 		}
 	}
 
diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed.c b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
index 5249033ed413..b7155377a86d 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed.c
@@ -295,7 +295,7 @@ static int aspeed_disable_sig(const struct aspeed_sig_expr **exprs,
 	int ret = 0;
 
 	if (!exprs)
-		return true;
+		return -EINVAL;
 
 	while (*exprs && !ret) {
 		ret = aspeed_sig_expr_disable(*exprs, maps);
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index d633737a3bf9..44936fca576e 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -339,6 +339,8 @@ static int pcs_set_mux(struct pinctrl_dev *pctldev, unsigned fselector,
 	if (!pcs->fmask)
 		return 0;
 	function = pinmux_generic_get_function(pctldev, fselector);
+	if (!function)
+		return -EINVAL;
 	func = function->data;
 	if (!func)
 		return -EINVAL;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index e3ca16043f9a..9161fe8fba88 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -773,7 +773,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 				       enum iscsi_host_param param, char *buf)
 {
 	struct iscsi_sw_tcp_host *tcp_sw_host = iscsi_host_priv(shost);
-	struct iscsi_session *session = tcp_sw_host->session;
+	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_tcp_conn *tcp_conn;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn;
@@ -782,6 +782,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_IPADDRESS:
+		session = tcp_sw_host->session;
 		if (!session)
 			return -ENOTCONN;
 
@@ -870,12 +871,14 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	if (!cls_session)
 		goto remove_host;
 	session = cls_session->dd_data;
-	tcp_sw_host = iscsi_host_priv(shost);
-	tcp_sw_host->session = session;
 
 	shost->can_queue = session->scsi_cmds_max;
 	if (iscsi_tcp_r2tpool_alloc(session))
 		goto remove_session;
+
+	/* We are now fully setup so expose the session to sysfs. */
+	tcp_sw_host = iscsi_host_priv(shost);
+	tcp_sw_host->session = session;
 	return cls_session;
 
 remove_session:
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 9c7bc1ca341a..e72bfb10a3f0 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -114,8 +114,8 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 {
 	struct se_session *sess = se_cmd->se_sess;
 
-	assert_spin_locked(&sess->sess_cmd_lock);
-	WARN_ON_ONCE(!irqs_disabled());
+	lockdep_assert_held(&sess->sess_cmd_lock);
+
 	/*
 	 * If command already reached CMD_T_COMPLETE state within
 	 * target_complete_cmd() or CMD_T_FABRIC_STOP due to shutdown,
diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 26f17456b0d7..383ed9966cfc 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -52,19 +52,39 @@ static void __dma_rx_complete(void *param)
 	struct uart_8250_dma	*dma = p->dma;
 	struct tty_port		*tty_port = &p->port.state->port;
 	struct dma_tx_state	state;
+	enum dma_status		dma_status;
 	int			count;
 
-	dma->rx_running = 0;
-	dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
+	/*
+	 * New DMA Rx can be started during the completion handler before it
+	 * could acquire port's lock and it might still be ongoing. Don't to
+	 * anything in such case.
+	 */
+	dma_status = dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
+	if (dma_status == DMA_IN_PROGRESS)
+		return;
 
 	count = dma->rx_size - state.residue;
 
 	tty_insert_flip_string(tty_port, dma->rx_buf, count);
 	p->port.icount.rx += count;
+	dma->rx_running = 0;
 
 	tty_flip_buffer_push(tty_port);
 }
 
+static void dma_rx_complete(void *param)
+{
+	struct uart_8250_port *p = param;
+	struct uart_8250_dma *dma = p->dma;
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->port.lock, flags);
+	if (dma->rx_running)
+		__dma_rx_complete(p);
+	spin_unlock_irqrestore(&p->port.lock, flags);
+}
+
 int serial8250_tx_dma(struct uart_8250_port *p)
 {
 	struct uart_8250_dma		*dma = p->dma;
@@ -130,7 +150,7 @@ int serial8250_rx_dma(struct uart_8250_port *p)
 		return -EBUSY;
 
 	dma->rx_running = 1;
-	desc->callback = __dma_rx_complete;
+	desc->callback = dma_rx_complete;
 	desc->callback_param = p;
 
 	dma->rx_cookie = dmaengine_submit(desc);
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index c102c7a9a3b4..60a49b87cc64 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -340,6 +340,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
+	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 946cf039eddd..ba9af04ad37a 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -274,8 +274,10 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 	struct usb_request *req = ffs->ep0req;
 	int ret;
 
-	if (!req)
+	if (!req) {
+		spin_unlock_irq(&ffs->ev.waitq.lock);
 		return -EINVAL;
+	}
 
 	req->zero     = len < le16_to_cpu(ffs->ev.setup.wLength);
 
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index a97e94b1c84f..73d6187efc73 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2450,9 +2450,12 @@ static int fbcon_set_font(struct vc_data *vc, struct console_font *font, unsigne
 	    h > FBCON_SWAP(info->var.rotate, info->var.yres, info->var.xres))
 		return -EINVAL;
 
+	if (font->width > 32 || font->height > 32)
+		return -EINVAL;
+
 	/* Make sure drawing engine can handle the font */
-	if (!(info->pixmap.blit_x & (1 << (font->width - 1))) ||
-	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
+	if (!(info->pixmap.blit_x & BIT(font->width - 1)) ||
+	    !(info->pixmap.blit_y & BIT(font->height - 1)))
 		return -EINVAL;
 
 	/* Make sure driver can handle the font length */
diff --git a/drivers/watchdog/diag288_wdt.c b/drivers/watchdog/diag288_wdt.c
index 806a04a676b7..561797c3b202 100644
--- a/drivers/watchdog/diag288_wdt.c
+++ b/drivers/watchdog/diag288_wdt.c
@@ -88,7 +88,7 @@ static int __diag288(unsigned int func, unsigned int timeout,
 		"1:\n"
 		EX_TABLE(0b, 1b)
 		: "+d" (err) : "d"(__func), "d"(__timeout),
-		  "d"(__action), "d"(__len) : "1", "cc");
+		  "d"(__action), "d"(__len) : "1", "cc", "memory");
 	return err;
 }
 
@@ -274,12 +274,21 @@ static int __init diag288_init(void)
 	char ebc_begin[] = {
 		194, 197, 199, 201, 213
 	};
+	char *ebc_cmd;
 
 	watchdog_set_nowayout(&wdt_dev, nowayout_info);
 
 	if (MACHINE_IS_VM) {
-		if (__diag288_vm(WDT_FUNC_INIT, 15,
-				 ebc_begin, sizeof(ebc_begin)) != 0) {
+		ebc_cmd = kmalloc(sizeof(ebc_begin), GFP_KERNEL);
+		if (!ebc_cmd) {
+			pr_err("The watchdog cannot be initialized\n");
+			return -ENOMEM;
+		}
+		memcpy(ebc_cmd, ebc_begin, sizeof(ebc_begin));
+		ret = __diag288_vm(WDT_FUNC_INIT, 15,
+				   ebc_cmd, sizeof(ebc_begin));
+		kfree(ebc_cmd);
+		if (ret != 0) {
 			pr_err("The watchdog cannot be initialized\n");
 			return -EINVAL;
 		}
diff --git a/fs/aio.c b/fs/aio.c
index a2de58f77338..2eb3dba5ed16 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -328,6 +328,9 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
 	spin_lock(&mm->ioctx_lock);
 	rcu_read_lock();
 	table = rcu_dereference(mm->ioctx_table);
+	if (!table)
+		goto out_unlock;
+
 	for (i = 0; i < table->nr; i++) {
 		struct kioctx *ctx;
 
@@ -341,6 +344,7 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
 		}
 	}
 
+out_unlock:
 	rcu_read_unlock();
 	spin_unlock(&mm->ioctx_lock);
 	return res;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8df4aedb3138..455d8f8b9dfb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1397,7 +1397,7 @@ int find_free_dev_extent_start(struct btrfs_transaction *transaction,
 			goto out;
 	}
 
-	while (1) {
+	while (search_start < search_end) {
 		l = path->nodes[0];
 		slot = path->slots[0];
 		if (slot >= btrfs_header_nritems(l)) {
@@ -1420,6 +1420,9 @@ int find_free_dev_extent_start(struct btrfs_transaction *transaction,
 		if (key.type != BTRFS_DEV_EXTENT_KEY)
 			goto next;
 
+		if (key.offset > search_end)
+			break;
+
 		if (key.offset > search_start) {
 			hole_size = key.offset - search_start;
 
@@ -1494,6 +1497,7 @@ int find_free_dev_extent_start(struct btrfs_transaction *transaction,
 	else
 		ret = 0;
 
+	ASSERT(max_hole_start + max_hole_size <= search_end);
 out:
 	btrfs_free_path(path);
 	*start = max_hole_start;
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 1d2c3d7711fe..e79a29334539 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1144,7 +1144,14 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 
 	minseg = range[0] + segbytes - 1;
 	do_div(minseg, segbytes);
+
+	if (range[1] < 4096)
+		goto out;
+
 	maxseg = NILFS_SB2_OFFSET_BYTES(range[1]);
+	if (maxseg < segbytes)
+		goto out;
+
 	do_div(maxseg, segbytes);
 	maxseg--;
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 36e60a45a1bf..16acf5e78a3c 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -420,6 +420,15 @@ int nilfs_resize_fs(struct super_block *sb, __u64 newsize)
 	if (newsize > devsize)
 		goto out;
 
+	/*
+	 * Prevent underflow in second superblock position calculation.
+	 * The exact minimum size check is done in nilfs_sufile_resize().
+	 */
+	if (newsize < 4096) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
 	/*
 	 * Write lock is required to protect some functions depending
 	 * on the number of segments, the number of reserved segments,
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 3e143c2da06d..1d5ecb1e2e10 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -526,9 +526,15 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 {
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	struct buffer_head **sbh = nilfs->ns_sbh;
-	u64 sb2off = NILFS_SB2_OFFSET_BYTES(nilfs->ns_bdev->bd_inode->i_size);
+	u64 sb2off, devsize = nilfs->ns_bdev->bd_inode->i_size;
 	int valid[2], swp = 0;
 
+	if (devsize < NILFS_SEG_MIN_BLOCKS * NILFS_MIN_BLOCK_SIZE + 4096) {
+		nilfs_msg(sb, KERN_ERR, "device size too small");
+		return -EINVAL;
+	}
+	sb2off = NILFS_SB2_OFFSET_BYTES(devsize);
+
 	sbp[0] = nilfs_read_super_block(sb, NILFS_SB_OFFSET_BYTES, blocksize,
 					&sbh[0]);
 	sbp[1] = nilfs_read_super_block(sb, sb2off, blocksize, &sbh[1]);
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 309d24118f9a..16ed6441c943 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -728,9 +728,7 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 			page = device_private_entry_to_page(swpent);
 	}
 	if (page) {
-		int mapcount = page_mapcount(page);
-
-		if (mapcount >= 2)
+		if (page_mapcount(page) >= 2 || hugetlb_pmd_shared(pte))
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index 10e93345b615..75886e6d9c97 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -196,7 +196,7 @@ static inline int squashfs_block_size(__le32 raw)
 #define SQUASHFS_ID_BLOCK_BYTES(A)	(SQUASHFS_ID_BLOCKS(A) *\
 					sizeof(u64))
 /* xattr id lookup table defines */
-#define SQUASHFS_XATTR_BYTES(A)		((A) * sizeof(struct squashfs_xattr_id))
+#define SQUASHFS_XATTR_BYTES(A)		(((u64) (A)) * sizeof(struct squashfs_xattr_id))
 
 #define SQUASHFS_XATTR_BLOCK(A)		(SQUASHFS_XATTR_BYTES(A) / \
 					SQUASHFS_METADATA_SIZE)
diff --git a/fs/squashfs/squashfs_fs_sb.h b/fs/squashfs/squashfs_fs_sb.h
index 5234c19a0eab..7ec30a11273e 100644
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -76,7 +76,7 @@ struct squashfs_sb_info {
 	long long				bytes_used;
 	unsigned int				inodes;
 	unsigned int				fragments;
-	int					xattr_ids;
+	unsigned int				xattr_ids;
 	unsigned int				ids;
 };
 #endif
diff --git a/fs/squashfs/xattr.h b/fs/squashfs/xattr.h
index 86b0a0073e51..f360f27e38f3 100644
--- a/fs/squashfs/xattr.h
+++ b/fs/squashfs/xattr.h
@@ -23,12 +23,12 @@
 
 #ifdef CONFIG_SQUASHFS_XATTR
 extern __le64 *squashfs_read_xattr_id_table(struct super_block *, u64,
-		u64 *, int *);
+		u64 *, unsigned int *);
 extern int squashfs_xattr_lookup(struct super_block *, unsigned int, int *,
 		unsigned int *, unsigned long long *);
 #else
 static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
-		u64 start, u64 *xattr_table_start, int *xattr_ids)
+		u64 start, u64 *xattr_table_start, unsigned int *xattr_ids)
 {
 	struct squashfs_xattr_id_table *id_table;
 
diff --git a/fs/squashfs/xattr_id.c b/fs/squashfs/xattr_id.c
index 7f718d2bf357..fe266b3e95f8 100644
--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -69,7 +69,7 @@ int squashfs_xattr_lookup(struct super_block *sb, unsigned int index,
  * Read uncompressed xattr id lookup table indexes from disk into memory
  */
 __le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
-		u64 *xattr_table_start, int *xattr_ids)
+		u64 *xattr_table_start, unsigned int *xattr_ids)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	unsigned int len, indexes;
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 26dddc03b35c..e52e6bed5b44 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
+#include <linux/page_ref.h>
 #include <linux/list.h>
 #include <linux/kref.h>
 #include <asm/pgtable.h>
@@ -394,7 +395,10 @@ static inline struct hstate *hstate_sizelog(int page_size_log)
 	if (!page_size_log)
 		return &default_hstate;
 
-	return size_to_hstate(1UL << page_size_log);
+	if (page_size_log < BITS_PER_LONG)
+		return size_to_hstate(1UL << page_size_log);
+
+	return NULL;
 }
 
 static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
@@ -616,4 +620,16 @@ static inline spinlock_t *huge_pte_lock(struct hstate *h,
 	return ptl;
 }
 
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+static inline bool hugetlb_pmd_shared(pte_t *pte)
+{
+	return page_count(virt_to_page(pte)) > 1;
+}
+#else
+static inline bool hugetlb_pmd_shared(pte_t *pte)
+{
+	return false;
+}
+#endif
+
 #endif /* _LINUX_HUGETLB_H */
diff --git a/include/net/sock.h b/include/net/sock.h
index 4053eea6182a..f6d0d96419b1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2049,6 +2049,19 @@ static inline void skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 	sk_mem_charge(sk, skb->truesize);
 }
 
+static inline struct sk_buff *skb_clone_and_charge_r(struct sk_buff *skb, struct sock *sk)
+{
+	skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
+	if (skb) {
+		if (sk_rmem_schedule(sk, skb, skb->truesize)) {
+			skb_set_owner_r(skb, sk);
+			return skb;
+		}
+		__kfree_skb(skb);
+	}
+	return NULL;
+}
+
 void sk_reset_timer(struct sock *sk, struct timer_list *timer,
 		    unsigned long expires);
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index aa2a88c09621..19552bcc592d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -574,7 +574,8 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 		goto unlock;
 	/* With MPOL_MF_MOVE, we migrate only unshared hugepage. */
 	if (flags & (MPOL_MF_MOVE_ALL) ||
-	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1))
+	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1 &&
+	     !hugetlb_pmd_shared(pte)))
 		isolate_huge_page(page, qp->pagelist);
 unlock:
 	spin_unlock(ptl);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f65d97fe2ef7..4a814454eafa 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -983,6 +983,7 @@ int get_swap_pages(int n_goal, bool cluster, swp_entry_t swp_entries[])
 			goto check_out;
 		pr_debug("scan_swap_map of si %d failed to find offset\n",
 			si->type);
+		cond_resched();
 
 		spin_lock(&swap_avail_lock);
 nextsi:
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 72803e1ea10a..b2a26e41f932 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -541,11 +541,9 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), NULL);
 	/* Clone pktoptions received with SYN, if we own the req */
 	if (*own_req && ireq->pktopts) {
-		newnp->pktoptions = skb_clone(ireq->pktopts, GFP_ATOMIC);
+		newnp->pktoptions = skb_clone_and_charge_r(ireq->pktopts, newsk);
 		consume_skb(ireq->pktopts);
 		ireq->pktopts = NULL;
-		if (newnp->pktoptions)
-			skb_set_owner_r(newnp->pktoptions, newsk);
 	}
 
 	return newsk;
@@ -605,7 +603,7 @@ static int dccp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 					       --ANK (980728)
 	 */
 	if (np->rxopt.all)
-		opt_skb = skb_clone(skb, GFP_ATOMIC);
+		opt_skb = skb_clone_and_charge_r(skb, sk);
 
 	if (sk->sk_state == DCCP_OPEN) { /* Fast path */
 		if (dccp_rcv_established(sk, skb, dccp_hdr(skb), skb->len))
@@ -669,7 +667,6 @@ static int dccp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 			np->flow_label = ip6_flowlabel(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb,
 				      &DCCP_SKB_CB(opt_skb)->header.h6)) {
-			skb_set_owner_r(opt_skb, sk);
 			memmove(IP6CB(opt_skb),
 				&DCCP_SKB_CB(opt_skb)->header.h6,
 				sizeof(struct inet6_skb_parm));
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 16a28f4307fb..1f0e2d81ad7a 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -53,7 +53,7 @@ static void ip6_datagram_flow_key_init(struct flowi6 *fl6, struct sock *sk)
 	fl6->flowi6_mark = sk->sk_mark;
 	fl6->fl6_dport = inet->inet_dport;
 	fl6->fl6_sport = inet->inet_sport;
-	fl6->flowlabel = np->flow_label;
+	fl6->flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
 	fl6->flowi6_uid = sk->sk_uid;
 
 	if (!fl6->flowi6_oif)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c639431d848c..f9fcf7e70fdb 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -241,6 +241,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	fl6.flowi6_proto = IPPROTO_TCP;
 	fl6.daddr = sk->sk_v6_daddr;
 	fl6.saddr = saddr ? *saddr : np->saddr;
+	fl6.flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
 	fl6.flowi6_oif = sk->sk_bound_dev_if;
 	fl6.flowi6_mark = sk->sk_mark;
 	fl6.fl6_dport = usin->sin6_port;
@@ -1242,14 +1243,11 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 		/* Clone pktoptions received with SYN, if we own the req */
 		if (ireq->pktopts) {
-			newnp->pktoptions = skb_clone(ireq->pktopts,
-						      sk_gfp_mask(sk, GFP_ATOMIC));
+			newnp->pktoptions = skb_clone_and_charge_r(ireq->pktopts, newsk);
 			consume_skb(ireq->pktopts);
 			ireq->pktopts = NULL;
-			if (newnp->pktoptions) {
+			if (newnp->pktoptions)
 				tcp_v6_restore_cb(newnp->pktoptions);
-				skb_set_owner_r(newnp->pktoptions, newsk);
-			}
 		}
 	} else {
 		if (!req_unhash && found_dup_sk) {
@@ -1317,7 +1315,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 					       --ANK (980728)
 	 */
 	if (np->rxopt.all)
-		opt_skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
+		opt_skb = skb_clone_and_charge_r(skb, sk);
 
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
 		struct dst_entry *dst;
@@ -1399,7 +1397,6 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		if (np->repflow)
 			np->flow_label = ip6_flowlabel(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb, &TCP_SKB_CB(opt_skb)->header.h6)) {
-			skb_set_owner_r(opt_skb, sk);
 			tcp_v6_restore_cb(opt_skb);
 			opt_skb = xchg(&np->pktoptions, opt_skb);
 		} else {
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index f078e8506e25..18dfbf196cbd 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1344,6 +1344,7 @@ static int mpls_dev_sysctl_register(struct net_device *dev,
 free:
 	kfree(table);
 out:
+	mdev->sysctl = NULL;
 	return -ENOBUFS;
 }
 
@@ -1353,6 +1354,9 @@ static void mpls_dev_sysctl_unregister(struct net_device *dev,
 	struct net *net = dev_net(dev);
 	struct ctl_table *table;
 
+	if (!mdev->sysctl)
+		return;
+
 	table = mdev->sysctl->ctl_table_arg;
 	unregister_net_sysctl_table(mdev->sysctl);
 	kfree(table);
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index aebc804c10aa..b5a99b517207 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -403,6 +403,11 @@ static int nr_listen(struct socket *sock, int backlog)
 	struct sock *sk = sock->sk;
 
 	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		release_sock(sk);
+		return -EINVAL;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		memset(&nr_sk(sk)->user_addr, 0, AX25_ADDR_LEN);
 		sk->sk_max_ack_backlog = backlog;
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 8598bc101244..3ae4ccb9895d 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -961,14 +961,14 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	key = kzalloc(sizeof(*key), GFP_KERNEL);
 	if (!key) {
 		error = -ENOMEM;
-		goto err_kfree_key;
+		goto err_kfree_flow;
 	}
 
 	ovs_match_init(&match, key, false, &mask);
 	error = ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
 				  a[OVS_FLOW_ATTR_MASK], log);
 	if (error)
-		goto err_kfree_flow;
+		goto err_kfree_key;
 
 	ovs_flow_mask_key(&new_flow->key, key, true, &mask);
 
@@ -976,14 +976,14 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	error = ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR_UFID],
 				       key, log);
 	if (error)
-		goto err_kfree_flow;
+		goto err_kfree_key;
 
 	/* Validate actions. */
 	error = ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
 				     &new_flow->key, &acts, log);
 	if (error) {
 		OVS_NLERR(log, "Flow actions may not be safe on all matching packets.");
-		goto err_kfree_flow;
+		goto err_kfree_key;
 	}
 
 	reply = ovs_flow_cmd_alloc_info(acts, &new_flow->id, info, false,
@@ -1083,10 +1083,10 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	kfree_skb(reply);
 err_kfree_acts:
 	ovs_nla_free_flow_actions(acts);
-err_kfree_flow:
-	ovs_flow_free(new_flow, false);
 err_kfree_key:
 	kfree(key);
+err_kfree_flow:
+	ovs_flow_free(new_flow, false);
 error:
 	return error;
 }
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index b53468edf35a..ac2ea4ebf7c7 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -490,6 +490,12 @@ static int rose_listen(struct socket *sock, int backlog)
 {
 	struct sock *sk = sock->sk;
 
+	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		release_sock(sk);
+		return -EINVAL;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		struct rose_sock *rose = rose_sk(sk);
 
@@ -499,8 +505,10 @@ static int rose_listen(struct socket *sock, int backlog)
 		memset(rose->dest_digis, 0, AX25_ADDR_LEN * ROSE_MAX_DIGIS);
 		sk->sk_max_ack_backlog = backlog;
 		sk->sk_state           = TCP_LISTEN;
+		release_sock(sk);
 		return 0;
 	}
+	release_sock(sk);
 
 	return -EOPNOTSUPP;
 }
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index af56651169b2..79d2aa44c6e5 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -210,9 +210,7 @@ void sctp_transport_reset_hb_timer(struct sctp_transport *transport)
 
 	/* When a data chunk is sent, reset the heartbeat interval.  */
 	expires = jiffies + sctp_transport_timeout(transport);
-	if ((time_before(transport->hb_timer.expires, expires) ||
-	     !timer_pending(&transport->hb_timer)) &&
-	    !mod_timer(&transport->hb_timer,
+	if (!mod_timer(&transport->hb_timer,
 		       expires + prandom_u32_max(transport->rto)))
 		sctp_transport_hold(transport);
 }
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index e103ec39759f..73e293c3f2fb 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -496,6 +496,12 @@ static int x25_listen(struct socket *sock, int backlog)
 	int rc = -EOPNOTSUPP;
 
 	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		rc = -EINVAL;
+		release_sock(sk);
+		return rc;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		memset(&x25_sk(sk)->dest_addr, 0, X25_ADDR_LEN);
 		sk->sk_max_ack_backlog = backlog;
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 4a5b762dbdb7..62c694f5b3ec 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1136,6 +1136,7 @@ static const struct hda_device_id snd_hda_id_conexant[] = {
 	HDA_CODEC_ENTRY(0x14f11f86, "CX8070", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f120d0, "CX11970", patch_conexant_auto),
+	HDA_CODEC_ENTRY(0x14f120d1, "SN6180", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15045, "CX20549 (Venice)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15047, "CX20551 (Waikiki)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15051, "CX20561 (Hermosa)", patch_conexant_auto),
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 9dd104c308e1..5ab6d9b3e6d0 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -870,6 +870,9 @@ static int add_secret_dac_path(struct hda_codec *codec)
 		return 0;
 	nums = snd_hda_get_connections(codec, spec->gen.mixer_nid, conn,
 				       ARRAY_SIZE(conn) - 1);
+	if (nums < 0)
+		return nums;
+
 	for (i = 0; i < nums; i++) {
 		if (get_wcaps_type(get_wcaps(codec, conn[i])) == AC_WID_AUD_OUT)
 			return 0;
diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index a80684bdc30d..46f536209671 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -508,12 +508,11 @@ int lx_buffer_ask(struct lx6464es *chip, u32 pipe, int is_capture,
 		dev_dbg(chip->card->dev,
 			"CMD_08_ASK_BUFFERS: needed %d, freed %d\n",
 			    *r_needed, *r_freed);
-		for (i = 0; i < MAX_STREAM_BUFFER; ++i) {
-			for (i = 0; i != chip->rmh.stat_len; ++i)
-				dev_dbg(chip->card->dev,
-					"  stat[%d]: %x, %x\n", i,
-					    chip->rmh.stat[i],
-					    chip->rmh.stat[i] & MASK_DATA_SIZE);
+		for (i = 0; i < MAX_STREAM_BUFFER && i < chip->rmh.stat_len;
+		     ++i) {
+			dev_dbg(chip->card->dev, "  stat[%d]: %x, %x\n", i,
+				chip->rmh.stat[i],
+				chip->rmh.stat[i] & MASK_DATA_SIZE);
 		}
 	}
 
diff --git a/sound/synth/emux/emux_nrpn.c b/sound/synth/emux/emux_nrpn.c
index 9729a15b6ae6..f4aa2706aeb6 100644
--- a/sound/synth/emux/emux_nrpn.c
+++ b/sound/synth/emux/emux_nrpn.c
@@ -363,6 +363,9 @@ int
 snd_emux_xg_control(struct snd_emux_port *port, struct snd_midi_channel *chan,
 		    int param)
 {
+	if (param >= ARRAY_SIZE(chan->control))
+		return -EINVAL;
+
 	return send_converted_effect(xg_effects, ARRAY_SIZE(xg_effects),
 				     port, chan, param,
 				     chan->control[param],
diff --git a/tools/virtio/linux/bug.h b/tools/virtio/linux/bug.h
index b14c2c3b6b85..74aef964f509 100644
--- a/tools/virtio/linux/bug.h
+++ b/tools/virtio/linux/bug.h
@@ -1,11 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef BUG_H
-#define BUG_H
+#ifndef _LINUX_BUG_H
+#define _LINUX_BUG_H
 
 #define BUG_ON(__BUG_ON_cond) assert(!(__BUG_ON_cond))
 
-#define BUILD_BUG_ON(x)
-
 #define BUG() abort()
 
-#endif /* BUG_H */
+#endif /* _LINUX_BUG_H */
diff --git a/tools/virtio/linux/build_bug.h b/tools/virtio/linux/build_bug.h
new file mode 100644
index 000000000000..cdbb75e28a60
--- /dev/null
+++ b/tools/virtio/linux/build_bug.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BUILD_BUG_H
+#define _LINUX_BUILD_BUG_H
+
+#define BUILD_BUG_ON(x)
+
+#endif	/* _LINUX_BUILD_BUG_H */
diff --git a/tools/virtio/linux/cpumask.h b/tools/virtio/linux/cpumask.h
new file mode 100644
index 000000000000..307da69d6b26
--- /dev/null
+++ b/tools/virtio/linux/cpumask.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CPUMASK_H
+#define _LINUX_CPUMASK_H
+
+#include <linux/kernel.h>
+
+#endif /* _LINUX_CPUMASK_H */
diff --git a/tools/virtio/linux/gfp.h b/tools/virtio/linux/gfp.h
new file mode 100644
index 000000000000..43d146f236f1
--- /dev/null
+++ b/tools/virtio/linux/gfp.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_GFP_H
+#define __LINUX_GFP_H
+
+#include <linux/topology.h>
+
+#endif
diff --git a/tools/virtio/linux/kernel.h b/tools/virtio/linux/kernel.h
index 268ce239de65..e4e35e66ea14 100644
--- a/tools/virtio/linux/kernel.h
+++ b/tools/virtio/linux/kernel.h
@@ -10,6 +10,7 @@
 #include <stdarg.h>
 
 #include <linux/compiler.h>
+#include <linux/log2.h>
 #include <linux/types.h>
 #include <linux/printk.h>
 #include <linux/bug.h>
diff --git a/tools/virtio/linux/kmsan.h b/tools/virtio/linux/kmsan.h
new file mode 100644
index 000000000000..272b5aa285d5
--- /dev/null
+++ b/tools/virtio/linux/kmsan.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KMSAN_H
+#define _LINUX_KMSAN_H
+
+#include <linux/gfp.h>
+
+inline void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
+			     enum dma_data_direction dir)
+{
+}
+
+#endif /* _LINUX_KMSAN_H */
diff --git a/tools/virtio/linux/scatterlist.h b/tools/virtio/linux/scatterlist.h
index 9a45f90e2d08..97448e1ceebc 100644
--- a/tools/virtio/linux/scatterlist.h
+++ b/tools/virtio/linux/scatterlist.h
@@ -2,6 +2,7 @@
 #ifndef SCATTERLIST_H
 #define SCATTERLIST_H
 #include <linux/kernel.h>
+#include <linux/bug.h>
 
 struct scatterlist {
 	unsigned long	page_link;
diff --git a/tools/virtio/linux/topology.h b/tools/virtio/linux/topology.h
new file mode 100644
index 000000000000..910794afb993
--- /dev/null
+++ b/tools/virtio/linux/topology.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_TOPOLOGY_H
+#define _LINUX_TOPOLOGY_H
+
+#include <linux/cpumask.h>
+
+#endif /* _LINUX_TOPOLOGY_H */
