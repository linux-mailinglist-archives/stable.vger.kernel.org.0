Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DE363581D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbiKWJuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238213AbiKWJuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:50:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85645116580
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:47:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 463F7B81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFFFC433C1;
        Wed, 23 Nov 2022 09:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196835;
        bh=cGBYHnodxjntZHnubDta9kf8NNVinALXPM/rMSQ0+Io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3kSeTaiQJTdI28W/0QS5r2Rggz2HdvXP6aGydnoj7pvCGAcpO9ndg5qzoZNhTSlh
         sIbj2bwmEG1Ues7Toj31pWJ68CFSTnVH7nhlEGvxBLEhX2nb7x+WSL1cAFqL7YNzWX
         cosIJdFCmekN+SGiO2Gh+lVCTv6TwYPEiPnXwjN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vikas Gupta <vikas.gupta@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 106/314] bnxt_en: fix the handling of PCIE-AER
Date:   Wed, 23 Nov 2022 09:49:11 +0100
Message-Id: <20221123084630.307795257@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 0cf736a18a1e804037839bd8df9e36f0efdb8745 ]

Fix the sequence required for PCIE-AER. While slot reset occurs, firmware
might not be ready and the driver needs to check for its recovery.  We
also need to remap the health registers for some chips and clear the
resource reservations.  The resources will be allocated again during
bnxt_io_resume().

Fixes: fb1e6e562b37 ("bnxt_en: Fix AER recovery.")
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 29 ++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    |  3 +-
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 72915f40c7a0..55d4efbb8614 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13922,7 +13922,9 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 	pci_ers_result_t result = PCI_ERS_RESULT_DISCONNECT;
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(netdev);
-	int err = 0, off;
+	int retry = 0;
+	int err = 0;
+	int off;
 
 	netdev_info(bp->dev, "PCI Slot Reset\n");
 
@@ -13950,11 +13952,36 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 		pci_restore_state(pdev);
 		pci_save_state(pdev);
 
+		bnxt_inv_fw_health_reg(bp);
+		bnxt_try_map_fw_health_reg(bp);
+
+		/* In some PCIe AER scenarios, firmware may take up to
+		 * 10 seconds to become ready in the worst case.
+		 */
+		do {
+			err = bnxt_try_recover_fw(bp);
+			if (!err)
+				break;
+			retry++;
+		} while (retry < BNXT_FW_SLOT_RESET_RETRY);
+
+		if (err) {
+			dev_err(&pdev->dev, "Firmware not ready\n");
+			goto reset_exit;
+		}
+
 		err = bnxt_hwrm_func_reset(bp);
 		if (!err)
 			result = PCI_ERS_RESULT_RECOVERED;
+
+		bnxt_ulp_irq_stop(bp);
+		bnxt_clear_int_mode(bp);
+		err = bnxt_init_int_mode(bp);
+		bnxt_ulp_irq_restart(bp, err);
 	}
 
+reset_exit:
+	bnxt_clear_reservations(bp, true);
 	rtnl_unlock();
 
 	return result;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index b1b17f911300..d5fa43cfe524 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1621,6 +1621,7 @@ struct bnxt_fw_health {
 
 #define BNXT_FW_RETRY			5
 #define BNXT_FW_IF_RETRY		10
+#define BNXT_FW_SLOT_RESET_RETRY	4
 
 enum board_idx {
 	BCM57301,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index b01d42928a53..132442f16fe6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -476,7 +476,8 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 		memset(ctx->resp, 0, PAGE_SIZE);
 
 	req_type = le16_to_cpu(ctx->req->req_type);
-	if (BNXT_NO_FW_ACCESS(bp) && req_type != HWRM_FUNC_RESET) {
+	if (BNXT_NO_FW_ACCESS(bp) &&
+	    (req_type != HWRM_FUNC_RESET && req_type != HWRM_VER_GET)) {
 		netdev_dbg(bp->dev, "hwrm req_type 0x%x skipped, FW channel down\n",
 			   req_type);
 		goto exit;
-- 
2.35.1



