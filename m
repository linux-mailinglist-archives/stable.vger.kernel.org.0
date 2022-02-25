Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4E14C48A8
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiBYPWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiBYPWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:22:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97131DD0DA
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86E2B611CB
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFA2C340E7;
        Fri, 25 Feb 2022 15:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645802524;
        bh=fKghM15w+0ClPIV0urA5Q4XqyG0xM98JsV3c3vMt/tw=;
        h=Subject:To:Cc:From:Date:From;
        b=QFcsTs2eBmm+yq8PKIgpzGhwnuMxTvW38zfzMMRhrjU1wZrKqtEFxkR4oNmp1N9QK
         WDotH97peEDKG3JYJQ/q4UIUKpKZTxSwlhUnuESjVri4NkVWombuwlGsChTPbF4t4Y
         5hpdaCpgnYOt/qE5K/76PrX4BOPnLsy00EUsjdGY=
Subject: FAILED: patch "[PATCH] bnxt_en: Fix offline ethtool selftest with RDMA enabled" failed to apply to 5.10-stable tree
To:     michael.chan@broadcom.com, ben.li@broadcom.com,
        davem@davemloft.net, edwin.peer@broadcom.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:22:01 +0100
Message-ID: <16458025211926@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6758f937669dba14c6aac7ca004edda42ec1b18d Mon Sep 17 00:00:00 2001
From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 20 Feb 2022 04:05:48 -0500
Subject: [PATCH] bnxt_en: Fix offline ethtool selftest with RDMA enabled

For offline (destructive) self tests, we need to stop the RDMA driver
first.  Otherwise, the RDMA driver will run into unrecoverable errors
when destructive firmware tests are being performed.

The irq_re_init parameter used in the half close and half open
sequence when preparing the NIC for offline tests should be set to
true because the RDMA driver will free all IRQs before the offline
tests begin.

Fixes: 55fd0cf320c3 ("bnxt_en: Add external loopback test to ethtool selftest.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Ben Li <ben.li@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4f94136a011a..23bbb1c5812d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10330,12 +10330,12 @@ int bnxt_half_open_nic(struct bnxt *bp)
 		goto half_open_err;
 	}
 
-	rc = bnxt_alloc_mem(bp, false);
+	rc = bnxt_alloc_mem(bp, true);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_alloc_mem err: %x\n", rc);
 		goto half_open_err;
 	}
-	rc = bnxt_init_nic(bp, false);
+	rc = bnxt_init_nic(bp, true);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_init_nic err: %x\n", rc);
 		goto half_open_err;
@@ -10344,7 +10344,7 @@ int bnxt_half_open_nic(struct bnxt *bp)
 
 half_open_err:
 	bnxt_free_skbs(bp);
-	bnxt_free_mem(bp, false);
+	bnxt_free_mem(bp, true);
 	dev_close(bp->dev);
 	return rc;
 }
@@ -10354,9 +10354,9 @@ int bnxt_half_open_nic(struct bnxt *bp)
  */
 void bnxt_half_close_nic(struct bnxt *bp)
 {
-	bnxt_hwrm_resource_free(bp, false, false);
+	bnxt_hwrm_resource_free(bp, false, true);
 	bnxt_free_skbs(bp);
-	bnxt_free_mem(bp, false);
+	bnxt_free_mem(bp, true);
 }
 
 void bnxt_reenable_sriov(struct bnxt *bp)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index e195f4a669d8..a85b18858b32 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -25,6 +25,7 @@
 #include "bnxt_hsi.h"
 #include "bnxt.h"
 #include "bnxt_hwrm.h"
+#include "bnxt_ulp.h"
 #include "bnxt_xdp.h"
 #include "bnxt_ptp.h"
 #include "bnxt_ethtool.h"
@@ -3551,9 +3552,12 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 	if (!offline) {
 		bnxt_run_fw_tests(bp, test_mask, &test_results);
 	} else {
-		rc = bnxt_close_nic(bp, false, false);
-		if (rc)
+		bnxt_ulp_stop(bp);
+		rc = bnxt_close_nic(bp, true, false);
+		if (rc) {
+			bnxt_ulp_start(bp, rc);
 			return;
+		}
 		bnxt_run_fw_tests(bp, test_mask, &test_results);
 
 		buf[BNXT_MACLPBK_TEST_IDX] = 1;
@@ -3563,6 +3567,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 		if (rc) {
 			bnxt_hwrm_mac_loopback(bp, false);
 			etest->flags |= ETH_TEST_FL_FAILED;
+			bnxt_ulp_start(bp, rc);
 			return;
 		}
 		if (bnxt_run_loopback(bp))
@@ -3588,7 +3593,8 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 		}
 		bnxt_hwrm_phy_loopback(bp, false, false);
 		bnxt_half_close_nic(bp);
-		rc = bnxt_open_nic(bp, false, true);
+		rc = bnxt_open_nic(bp, true, true);
+		bnxt_ulp_start(bp, rc);
 	}
 	if (rc || bnxt_test_irq(bp)) {
 		buf[BNXT_IRQ_TEST_IDX] = 1;

