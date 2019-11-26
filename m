Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43FD109B37
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 10:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfKZJ2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 04:28:22 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33145 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727275AbfKZJ2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 04:28:22 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 06D3922879;
        Tue, 26 Nov 2019 04:28:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 26 Nov 2019 04:28:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Yp7NqL
        28TScXHMGRnzguEconnNIWQEGyIXmMa2WjR2Q=; b=XHe7WAZnYvvgATbrTx2rLB
        3dyhR/POtJdohCJKE8TUrssrhWKlPGKeq4hQbMKM+/2111TJfif4kUb5qfO/Iab3
        I2kySdy4mJ4Q++mQad6NPyTeTPLT+grSkUZHcpSYhaf8zOa8m3v5EFcmmImM4eXs
        hhhCPlYdR5lFLB1drngVc04pnNzlpLDjJfB+8fJ/p0OgJ0z7mYWe/sk3YERPJGSs
        suwd/vutYxmlrhMWcS4+lgjwCe+Bmj95nvisNeSYnH/92I1TMAm50hgdtnHkdMn8
        NMPHFaM4BMk8a3KPhEfaNr23B340nr3GGYMx83BZzB72ER+57/PlIOWluvHQMFpA
        ==
X-ME-Sender: <xms:NPDcXXFYn6G6MhM7OVAnCy2UfW7yxNijPpYGf1slfDh57K4mxLwV1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeifedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekgedrvdeguddrudelgedrleeinecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:NPDcXerUJxPu6aTXXhaW2A4UM5dvtjbwiJ5-xeVtydrYZDGT1-MVTQ>
    <xmx:NPDcXQrUimd3WIbTSEf5_TypOAwtXZlfh2mv2rj3O0B5ZNPU6RP1ww>
    <xmx:NPDcXT15hcmcFTDQeE1X_wjmsCFpabgcuA5YU3Gu8_pHqLu1Xuo-ww>
    <xmx:NfDcXWTAcMgEv7AU8znfCndnn2m4ShYTzmZGwJe0Fze8Oh4hrb2mQA>
Received: from localhost (unknown [84.241.194.96])
        by mail.messagingengine.com (Postfix) with ESMTPA id 754CE306005C;
        Tue, 26 Nov 2019 04:28:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] ath10k: restore QCA9880-AR1A (v1) detection" failed to apply to 4.9-stable tree
To:     chunkeey@gmail.com, kvalo@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 26 Nov 2019 10:28:16 +0100
Message-ID: <157476049638248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f8914a14623a79b73f72b2b1ee4cd9b2cb91b735 Mon Sep 17 00:00:00 2001
From: Christian Lamparter <chunkeey@gmail.com>
Date: Fri, 6 Sep 2019 23:54:23 +0200
Subject: [PATCH] ath10k: restore QCA9880-AR1A (v1) detection

This patch restores the old behavior that read
the chip_id on the QCA988x before resetting the
chip. This needs to be done in this order since
the unsupported QCA988x AR1A chips fall off the
bus when resetted. Otherwise the next MMIO Op
after the reset causes a BUS ERROR and panic.

Cc: stable@vger.kernel.org
Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index bc3dc79de01a..bb44f5a0941b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3486,7 +3486,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	struct ath10k_pci *ar_pci;
 	enum ath10k_hw_rev hw_rev;
 	struct ath10k_bus_params bus_params = {};
-	bool pci_ps;
+	bool pci_ps, is_qca988x = false;
 	int (*pci_soft_reset)(struct ath10k *ar);
 	int (*pci_hard_reset)(struct ath10k *ar);
 	u32 (*targ_cpu_to_ce_addr)(struct ath10k *ar, u32 addr);
@@ -3496,6 +3496,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	case QCA988X_2_0_DEVICE_ID:
 		hw_rev = ATH10K_HW_QCA988X;
 		pci_ps = false;
+		is_qca988x = true;
 		pci_soft_reset = ath10k_pci_warm_reset;
 		pci_hard_reset = ath10k_pci_qca988x_chip_reset;
 		targ_cpu_to_ce_addr = ath10k_pci_qca988x_targ_cpu_to_ce_addr;
@@ -3615,25 +3616,34 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_deinit_irq;
 	}
 
+	bus_params.dev_type = ATH10K_DEV_TYPE_LL;
+	bus_params.link_can_suspend = true;
+	/* Read CHIP_ID before reset to catch QCA9880-AR1A v1 devices that
+	 * fall off the bus during chip_reset. These chips have the same pci
+	 * device id as the QCA9880 BR4A or 2R4E. So that's why the check.
+	 */
+	if (is_qca988x) {
+		bus_params.chip_id =
+			ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
+		if (bus_params.chip_id != 0xffffffff) {
+			if (!ath10k_pci_chip_is_supported(pdev->device,
+							  bus_params.chip_id))
+				goto err_unsupported;
+		}
+	}
+
 	ret = ath10k_pci_chip_reset(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to reset chip: %d\n", ret);
 		goto err_free_irq;
 	}
 
-	bus_params.dev_type = ATH10K_DEV_TYPE_LL;
-	bus_params.link_can_suspend = true;
 	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
-	if (bus_params.chip_id == 0xffffffff) {
-		ath10k_err(ar, "failed to get chip id\n");
-		goto err_free_irq;
-	}
+	if (bus_params.chip_id == 0xffffffff)
+		goto err_unsupported;
 
-	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id)) {
-		ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
-			   pdev->device, bus_params.chip_id);
+	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id))
 		goto err_free_irq;
-	}
 
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
@@ -3643,6 +3653,10 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
+err_unsupported:
+	ath10k_err(ar, "device %04x with chip_id %08x isn't supported\n",
+		   pdev->device, bus_params.chip_id);
+
 err_free_irq:
 	ath10k_pci_free_irq(ar);
 	ath10k_pci_rx_retry_sync(ar);

