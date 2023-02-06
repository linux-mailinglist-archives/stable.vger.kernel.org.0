Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820DA68B65C
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 08:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBFH1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 02:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjBFH1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 02:27:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4C11BAC3;
        Sun,  5 Feb 2023 23:27:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80FDFB80D4C;
        Mon,  6 Feb 2023 07:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1A1C433EF;
        Mon,  6 Feb 2023 07:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675668420;
        bh=QDpLcNuEijGtKSxGo5heAO+LwBt9P53tNO4ZORG9EQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvNq6YhMdBuIPqIqAu3lESLILbkQxdrAnGAMZhhn+Flox4S/tTKGZlkAaMS0L2axZ
         SAMC9/ARqiZ9gDF5a7r4jal4ADVegkgDZoFo4Sfw8V7hyj7syY/aTRq4eBwCyM9fYK
         DnvdgqfHq+pGIqBux3YaXRjDkfU2eoC+5/kRxHMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.167
Date:   Mon,  6 Feb 2023 08:26:51 +0100
Message-Id: <1675668410127188@kroah.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <167566841047145@kroah.com>
References: <167566841047145@kroah.com>
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
index efdfb40a82ab..84b78e657357 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 166
+SUBLEVEL = 167
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arm/boot/dts/imx53-ppd.dts b/arch/arm/boot/dts/imx53-ppd.dts
index 006fbd7f5432..54e39db447c4 100644
--- a/arch/arm/boot/dts/imx53-ppd.dts
+++ b/arch/arm/boot/dts/imx53-ppd.dts
@@ -487,7 +487,7 @@ &i2c1 {
 	scl-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 
-	i2c-switch@70 {
+	i2c-mux@70 {
 		compatible = "nxp,pca9547";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
index 6f1e0f0d4f0a..073f5d196ca9 100644
--- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
+++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
@@ -345,7 +345,7 @@ gpio6: io-expander@22 {
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
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 484c6b2dd264..c623632c1cda 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1370,6 +1370,10 @@ int blkcg_activate_policy(struct request_queue *q,
 		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
 			pol->pd_init_fn(blkg->pd[pol->plid]);
 
+	if (pol->pd_online_fn)
+		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
+			pol->pd_online_fn(blkg->pd[pol->plid]);
+
 	__set_bit(pol->plid, q->blkcg_pols);
 	ret = 0;
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index e5dd87ddc6b3..59781e765e0e 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -536,10 +536,27 @@ static void wait_for_freeze(void)
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
index 2283dcd8bf91..6514db824473 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1363,10 +1363,12 @@ static struct sdma_desc *sdma_transfer_init(struct sdma_channel *sdmac,
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
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a9e074769881..ab4f51716645 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1072,6 +1072,9 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 		return -EPERM;
 	if (unlikely(!nmi_uaccess_okay()))
 		return -EPERM;
+	/* Task should not be pid=1 to avoid kernel panic. */
+	if (unlikely(is_global_init(current)))
+		return -EPERM;
 
 	if (irqs_disabled()) {
 		/* Do an early check on signal validity. Otherwise,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 954b29605c94..eb111504afc6 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4307,6 +4307,19 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
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
index 2b12e0730b85..668a9d0fbbc6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3688,7 +3688,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 
 	skb_shinfo(skb)->frag_list = NULL;
 
-	do {
+	while (list_skb) {
 		nskb = list_skb;
 		list_skb = list_skb->next;
 
@@ -3732,8 +3732,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		if (skb_needs_linearize(nskb, features) &&
 		    __skb_linearize(nskb))
 			goto err_linearize;
-
-	} while (list_skb);
+	}
 
 	skb->truesize = skb->truesize - delta_truesize;
 	skb->data_len = skb->data_len - delta_len;
