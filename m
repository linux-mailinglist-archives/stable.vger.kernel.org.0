Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590835F8F9E
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiJIWKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiJIWJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:09:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6136286FD;
        Sun,  9 Oct 2022 15:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50FD860CEC;
        Sun,  9 Oct 2022 22:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D07C43142;
        Sun,  9 Oct 2022 22:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353330;
        bh=r85VRtW2vzTGHkgz/5r6B0X8eKc5Xa42RRq8MtDaW+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmutzQ8vLFgMIvQjx0lRGsolQxuVfQqGS7sM3ntFAEKWj+481bAcOYJcaetg3RY/P
         UpxhLSf8DBlMObo4zUshXklO32FOqdMVTYTVhD02gkE+0KmMAUR2ebOqvEkmNtz3WO
         kthFZH9S7puA7m0tLNtWctlmH78qtz2YPa3d1/mO1F+TeSFpiw6c7+ApcPEtETWX1w
         4zUCH3EgjRDdOm8ClOcxc6jXrzwyg3KKXVioC4eHKDixc1Ky62bnJArr5WQC2eeS0f
         xM0BEsvISTGB32ZGYQVoHhtm/Bop/BUyCIx7zUTebNu+SQ99fMRAePHoHX3bbOS6rs
         9O7nXRjzZd7iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, andreas.noever@gmail.com,
        michael.jamet@intel.com, YehezkelShB@gmail.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 21/77] thunderbolt: Add back Intel Falcon Ridge end-to-end flow control workaround
Date:   Sun,  9 Oct 2022 18:06:58 -0400
Message-Id: <20221009220754.1214186-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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
index cb8c9c4ae93a..b5cd9673e15d 100644
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

