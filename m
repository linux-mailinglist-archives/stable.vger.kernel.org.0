Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61FB6ECF2D
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjDXNiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbjDXNil (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:38:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACBA8A78
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:38:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DCED623EE
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592FBC433EF;
        Mon, 24 Apr 2023 13:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343460;
        bh=uDcOGl6lZvFpVEcTKvEexxresinjttrssNcF7FyPlxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/pF2fQEMe9wp6Zle4nPV39huLMqFQqh9eCTmwpS3TiRXWGvYuFD6WRKRROHDw+3q
         aO7bMTcX3AdflVWJsxYJ5I9aFPUDBJM3DSpStlHCHYFiegp2cwVt9Q9Kti+NLTMcV/
         Cy0CLwlN8ndTu/q3wDVHLDfGjOAFs2Tv6w/jra8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Basierski <sebastianx.basierski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/28] e1000e: Disable TSO on i219-LM card to increase speed
Date:   Mon, 24 Apr 2023 15:18:28 +0200
Message-Id: <20230424131121.567627243@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Basierski <sebastianx.basierski@intel.com>

[ Upstream commit 67d47b95119ad589b0a0b16b88b1dd9a04061ced ]

While using i219-LM card currently it was only possible to achieve
about 60% of maximum speed due to regression introduced in Linux 5.8.
This was caused by TSO not being disabled by default despite commit
f29801030ac6 ("e1000e: Disable TSO for buffer overrun workaround").
Fix that by disabling TSO during driver probe.

Fixes: f29801030ac6 ("e1000e: Disable TSO for buffer overrun workaround")
Signed-off-by: Sebastian Basierski <sebastianx.basierski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230417205345.1030801-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 51 +++++++++++-----------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index cb3ff3c2fb03f..d41ebc50eeaa2 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5250,31 +5250,6 @@ static void e1000_watchdog_task(struct work_struct *work)
 				ew32(TARC(0), tarc0);
 			}
 
-			/* disable TSO for pcie and 10/100 speeds, to avoid
-			 * some hardware issues
-			 */
-			if (!(adapter->flags & FLAG_TSO_FORCE)) {
-				switch (adapter->link_speed) {
-				case SPEED_10:
-				case SPEED_100:
-					e_info("10/100 speed: disabling TSO\n");
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
-					break;
-				case SPEED_1000:
-					netdev->features |= NETIF_F_TSO;
-					netdev->features |= NETIF_F_TSO6;
-					break;
-				default:
-					/* oops */
-					break;
-				}
-				if (hw->mac.type == e1000_pch_spt) {
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
-				}
-			}
-
 			/* enable transmits in the hardware, need to do this
 			 * after setting TARC(0)
 			 */
@@ -7211,6 +7186,32 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    NETIF_F_RXCSUM |
 			    NETIF_F_HW_CSUM);
 
+	/* disable TSO for pcie and 10/100 speeds to avoid
+	 * some hardware issues and for i219 to fix transfer
+	 * speed being capped at 60%
+	 */
+	if (!(adapter->flags & FLAG_TSO_FORCE)) {
+		switch (adapter->link_speed) {
+		case SPEED_10:
+		case SPEED_100:
+			e_info("10/100 speed: disabling TSO\n");
+			netdev->features &= ~NETIF_F_TSO;
+			netdev->features &= ~NETIF_F_TSO6;
+			break;
+		case SPEED_1000:
+			netdev->features |= NETIF_F_TSO;
+			netdev->features |= NETIF_F_TSO6;
+			break;
+		default:
+			/* oops */
+			break;
+		}
+		if (hw->mac.type == e1000_pch_spt) {
+			netdev->features &= ~NETIF_F_TSO;
+			netdev->features &= ~NETIF_F_TSO6;
+		}
+	}
+
 	/* Set user-changeable features (subset of all device features) */
 	netdev->hw_features = netdev->features;
 	netdev->hw_features |= NETIF_F_RXFCS;
-- 
2.39.2



