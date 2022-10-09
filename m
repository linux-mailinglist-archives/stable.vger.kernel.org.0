Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5121A5F911F
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiJIWal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiJIW20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:28:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E276738699;
        Sun,  9 Oct 2022 15:18:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C827B80DFD;
        Sun,  9 Oct 2022 22:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DE4C4347C;
        Sun,  9 Oct 2022 22:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353764;
        bh=Hx4mL44wdPU71kowxGBfpLmQJGtZwfe5kyjz5eQ9nTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZe0Xxv2cjYKyUHFvtqF13N/tw0ZsYpUAuXlwr/HjSSCUqOZ2qEGhSSWCLdEVjo+x
         RnJtNpqMoJJVRFibVFWGoDoYGBQCF1g7i+SXN2Cbcd8+qDZ2CeCpsXUts0Cs86fvt6
         7aF3bENZSCrIMGD92LHCfEfpEjQgtGIHvyhloYzxj8Ig3G085Jk7c/fGor7ti9sPuN
         Qwx8q97za6K3vj1/uIpCdbpuv9RnpyKBiBxk7N2f0WEgL6xoLIzA7AssDIVcgMuLqg
         jg/0GefqdSKw9oeHBGjqu+lHN02UZZLUPuhR+bwu0i+AqWDhc/etqDnrVvkKyvOTXR
         vmwj9DaRhecSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, andreas.noever@gmail.com,
        michael.jamet@intel.com, YehezkelShB@gmail.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 18/73] thunderbolt: Add back Intel Falcon Ridge end-to-end flow control workaround
Date:   Sun,  9 Oct 2022 18:13:56 -0400
Message-Id: <20221009221453.1216158-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 54669e2f17cb5a4c41ade89427f074dc22cecb17 ]

As we are now enabling full end-to-end flow control to the Thunderbolt
networking driver, in order for it to work properly on second generation
Thunderbolt hardware (Falcon Ridge), we need to add back the workaround
that was removed with commit 53f13319d131 ("thunderbolt: Get rid of E2E
workaround"). However, this time we only apply it for Falcon Ridge
controllers as a form of an additional quirk. For non-Falcon Ridge this
does nothing.

While there fix a typo 'reqister' -> 'register' in the comment.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/nhi.c | 49 +++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 1333b158a95e..407a89047473 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -28,7 +28,11 @@
 #define RING_TYPE(ring) ((ring)->is_tx ? "TX ring" : "RX ring")
 
 #define RING_FIRST_USABLE_HOPID	1
-
+/*
+ * Used with QUIRK_E2E to specify an unused HopID the Rx credits are
+ * transferred.
+ */
+#define RING_E2E_RESERVED_HOPID	RING_FIRST_USABLE_HOPID
 /*
  * Minimal number of vectors when we use MSI-X. Two for control channel
  * Rx/Tx and the rest four are for cross domain DMA paths.
@@ -38,7 +42,9 @@
 
 #define NHI_MAILBOX_TIMEOUT	500 /* ms */
 
+/* Host interface quirks */
 #define QUIRK_AUTO_CLEAR_INT	BIT(0)
+#define QUIRK_E2E		BIT(1)
 
 static int ring_interrupt_index(struct tb_ring *ring)
 {
@@ -458,8 +464,18 @@ static void ring_release_msix(struct tb_ring *ring)
 
 static int nhi_alloc_hop(struct tb_nhi *nhi, struct tb_ring *ring)
 {
+	unsigned int start_hop = RING_FIRST_USABLE_HOPID;
 	int ret = 0;
 
+	if (nhi->quirks & QUIRK_E2E) {
+		start_hop = RING_FIRST_USABLE_HOPID + 1;
+		if (ring->flags & RING_FLAG_E2E && !ring->is_tx) {
+			dev_dbg(&nhi->pdev->dev, "quirking E2E TX HopID %u -> %u\n",
+				ring->e2e_tx_hop, RING_E2E_RESERVED_HOPID);
+			ring->e2e_tx_hop = RING_E2E_RESERVED_HOPID;
+		}
+	}
+
 	spin_lock_irq(&nhi->lock);
 
 	if (ring->hop < 0) {
@@ -469,7 +485,7 @@ static int nhi_alloc_hop(struct tb_nhi *nhi, struct tb_ring *ring)
 		 * Automatically allocate HopID from the non-reserved
 		 * range 1 .. hop_count - 1.
 		 */
-		for (i = RING_FIRST_USABLE_HOPID; i < nhi->hop_count; i++) {
+		for (i = start_hop; i < nhi->hop_count; i++) {
 			if (ring->is_tx) {
 				if (!nhi->tx_rings[i]) {
 					ring->hop = i;
@@ -484,6 +500,11 @@ static int nhi_alloc_hop(struct tb_nhi *nhi, struct tb_ring *ring)
 		}
 	}
 
+	if (ring->hop > 0 && ring->hop < start_hop) {
+		dev_warn(&nhi->pdev->dev, "invalid hop: %d\n", ring->hop);
+		ret = -EINVAL;
+		goto err_unlock;
+	}
 	if (ring->hop < 0 || ring->hop >= nhi->hop_count) {
 		dev_warn(&nhi->pdev->dev, "invalid hop: %d\n", ring->hop);
 		ret = -EINVAL;
@@ -1097,12 +1118,26 @@ static void nhi_shutdown(struct tb_nhi *nhi)
 
 static void nhi_check_quirks(struct tb_nhi *nhi)
 {
-	/*
-	 * Intel hardware supports auto clear of the interrupt status
-	 * reqister right after interrupt is being issued.
-	 */
-	if (nhi->pdev->vendor == PCI_VENDOR_ID_INTEL)
+	if (nhi->pdev->vendor == PCI_VENDOR_ID_INTEL) {
+		/*
+		 * Intel hardware supports auto clear of the interrupt
+		 * status register right after interrupt is being
+		 * issued.
+		 */
 		nhi->quirks |= QUIRK_AUTO_CLEAR_INT;
+
+		switch (nhi->pdev->device) {
+		case PCI_DEVICE_ID_INTEL_FALCON_RIDGE_2C_NHI:
+		case PCI_DEVICE_ID_INTEL_FALCON_RIDGE_4C_NHI:
+			/*
+			 * Falcon Ridge controller needs the end-to-end
+			 * flow control workaround to avoid losing Rx
+			 * packets when RING_FLAG_E2E is set.
+			 */
+			nhi->quirks |= QUIRK_E2E;
+			break;
+		}
+	}
 }
 
 static int nhi_check_iommu_pdev(struct pci_dev *pdev, void *data)
-- 
2.35.1

