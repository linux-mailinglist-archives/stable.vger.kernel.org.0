Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6AD63581C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236322AbiKWJuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbiKWJt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944FE5F92
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:47:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3160561A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419DCC433D7;
        Wed, 23 Nov 2022 09:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196832;
        bh=wUl7IVCpwie38HmCHTaMz62NWtS26+zgc5NkX9CrU2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yskg0/U11FiA2m7MUf84g+qezMpkVtatYfoSKd4BhR3nXpFQBA7oy9ig+88jRr8wA
         AnnWHwkS7s8hty2T7/WLN+E7B7+nVTCMawqkHCRBjrn/ummcyOYHes4uPuJY6Dx4Rm
         WvXmvnXcSsdJd9SdVIuVCT7q3bw0AaU24CkhD8Tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vikas Gupta <vikas.gupta@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 105/314] bnxt_en: refactor bnxt_cancel_reservations()
Date:   Wed, 23 Nov 2022 09:49:10 +0100
Message-Id: <20221123084630.256463788@linuxfoundation.org>
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

[ Upstream commit b4c66425771ddb910316c7b4cd7fa0614098ec45 ]

Introduce bnxt_clear_reservations() to clear the reserved attributes only.
This will be used in the next patch to fix PCI AER handling.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0cf736a18a1e ("bnxt_en: fix the handling of PCIE-AER")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index be5df8fca264..72915f40c7a0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9983,17 +9983,12 @@ static int bnxt_try_recover_fw(struct bnxt *bp)
 	return -ENODEV;
 }
 
-int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset)
+static void bnxt_clear_reservations(struct bnxt *bp, bool fw_reset)
 {
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
-	int rc;
 
 	if (!BNXT_NEW_RM(bp))
-		return 0; /* no resource reservations required */
-
-	rc = bnxt_hwrm_func_resc_qcaps(bp, true);
-	if (rc)
-		netdev_err(bp->dev, "resc_qcaps failed\n");
+		return; /* no resource reservations required */
 
 	hw_resc->resv_cp_rings = 0;
 	hw_resc->resv_stat_ctxs = 0;
@@ -10006,6 +10001,20 @@ int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset)
 		bp->tx_nr_rings = 0;
 		bp->rx_nr_rings = 0;
 	}
+}
+
+int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset)
+{
+	int rc;
+
+	if (!BNXT_NEW_RM(bp))
+		return 0; /* no resource reservations required */
+
+	rc = bnxt_hwrm_func_resc_qcaps(bp, true);
+	if (rc)
+		netdev_err(bp->dev, "resc_qcaps failed\n");
+
+	bnxt_clear_reservations(bp, fw_reset);
 
 	return rc;
 }
-- 
2.35.1



