Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476E14C75EC
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbiB1R5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239363AbiB1Rwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:52:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA16A94D7;
        Mon, 28 Feb 2022 09:40:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 455056156B;
        Mon, 28 Feb 2022 17:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55268C340E7;
        Mon, 28 Feb 2022 17:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070005;
        bh=nxXKOafHAT91L+KEcpG5Ig/Ag6ujqpSqA5C2JyOG9ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K19yfwFzkvTU55nNV32pmjG40BrNUpYv20IKLvt9diOL2WmM8f62vHWcVDhFiX0lW
         R91/aBtG+KqVf+IF3Kn0UJgpdb15ENSHkw7hBmcvs1G0H4wnhyf+pOjpMlCg0/YT2k
         2zaJ9pgOoJf+sZ88Zfq6gW10CfQE4k7YfLK7ajtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Ben Li <ben.li@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 043/139] bnxt_en: Fix offline ethtool selftest with RDMA enabled
Date:   Mon, 28 Feb 2022 18:23:37 +0100
Message-Id: <20220228172352.247071663@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

commit 6758f937669dba14c6aac7ca004edda42ec1b18d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |   10 +++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |   12 +++++++++---
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10295,12 +10295,12 @@ int bnxt_half_open_nic(struct bnxt *bp)
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
@@ -10309,7 +10309,7 @@ int bnxt_half_open_nic(struct bnxt *bp)
 
 half_open_err:
 	bnxt_free_skbs(bp);
-	bnxt_free_mem(bp, false);
+	bnxt_free_mem(bp, true);
 	dev_close(bp->dev);
 	return rc;
 }
@@ -10319,9 +10319,9 @@ half_open_err:
  */
 void bnxt_half_close_nic(struct bnxt *bp)
 {
-	bnxt_hwrm_resource_free(bp, false, false);
+	bnxt_hwrm_resource_free(bp, false, true);
 	bnxt_free_skbs(bp);
-	bnxt_free_mem(bp, false);
+	bnxt_free_mem(bp, true);
 }
 
 static void bnxt_reenable_sriov(struct bnxt *bp)
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
@@ -3502,9 +3503,12 @@ static void bnxt_self_test(struct net_de
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
@@ -3514,6 +3518,7 @@ static void bnxt_self_test(struct net_de
 		if (rc) {
 			bnxt_hwrm_mac_loopback(bp, false);
 			etest->flags |= ETH_TEST_FL_FAILED;
+			bnxt_ulp_start(bp, rc);
 			return;
 		}
 		if (bnxt_run_loopback(bp))
@@ -3539,7 +3544,8 @@ static void bnxt_self_test(struct net_de
 		}
 		bnxt_hwrm_phy_loopback(bp, false, false);
 		bnxt_half_close_nic(bp);
-		rc = bnxt_open_nic(bp, false, true);
+		rc = bnxt_open_nic(bp, true, true);
+		bnxt_ulp_start(bp, rc);
 	}
 	if (rc || bnxt_test_irq(bp)) {
 		buf[BNXT_IRQ_TEST_IDX] = 1;


