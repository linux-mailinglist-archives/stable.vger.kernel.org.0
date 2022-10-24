Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECBD60ACEA
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbiJXOQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233144AbiJXONy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:13:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01ADCA8BD;
        Mon, 24 Oct 2022 05:53:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5BBF6129B;
        Mon, 24 Oct 2022 12:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0514DC433C1;
        Mon, 24 Oct 2022 12:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615899;
        bh=20Rf8tPmh/l/YzXwh60DAMJdzhLKNMHFPZGvh6qw//4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJxMQHHBCOT45uCzlndTiPgwQC3s5KXpC2JtNtOvniEdu5wgUdpfEkuYp3YVEgTbJ
         9LP5Uwfl7bum95utftj2KPHb4o4jIVMsqwATfR9SVBjCxC46qntRDrwhBPVCbVpWIs
         sqlq553v1QW4ShXixmfDmJbatnfOAnNC5Xp8kQYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 424/530] thunderbolt: Add back Intel Falcon Ridge end-to-end flow control workaround
Date:   Mon, 24 Oct 2022 13:32:48 +0200
Message-Id: <20221024113104.293220237@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index c73da0532be4..aa6cf7f2f438 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -25,7 +25,11 @@
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
@@ -35,7 +39,9 @@
 
 #define NHI_MAILBOX_TIMEOUT	500 /* ms */
 
+/* Host interface quirks */
 #define QUIRK_AUTO_CLEAR_INT	BIT(0)
+#define QUIRK_E2E		BIT(1)
 
 static int ring_interrupt_index(struct tb_ring *ring)
 {
@@ -455,8 +461,18 @@ static void ring_release_msix(struct tb_ring *ring)
 
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
@@ -466,7 +482,7 @@ static int nhi_alloc_hop(struct tb_nhi *nhi, struct tb_ring *ring)
 		 * Automatically allocate HopID from the non-reserved
 		 * range 1 .. hop_count - 1.
 		 */
-		for (i = RING_FIRST_USABLE_HOPID; i < nhi->hop_count; i++) {
+		for (i = start_hop; i < nhi->hop_count; i++) {
 			if (ring->is_tx) {
 				if (!nhi->tx_rings[i]) {
 					ring->hop = i;
@@ -481,6 +497,11 @@ static int nhi_alloc_hop(struct tb_nhi *nhi, struct tb_ring *ring)
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
@@ -1094,12 +1115,26 @@ static void nhi_shutdown(struct tb_nhi *nhi)
 
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
 
 static int nhi_init_msi(struct tb_nhi *nhi)
-- 
2.35.1



