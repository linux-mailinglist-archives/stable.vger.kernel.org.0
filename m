Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B83566AACD
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjANJ4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjANJ4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:56:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD12976A7
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:56:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BD97B808C5
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F71C433EF;
        Sat, 14 Jan 2023 09:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673690164;
        bh=2N4KdOguUrOMpzyB7TheSvZdW25IyRGLYwHVjLN2ZBI=;
        h=Subject:To:Cc:From:Date:From;
        b=ALpn9XWoF4+dgLeyjAE48p8l+tIGmuF8nfiCUQ8/ifxD4Pq9fLYPMMjFMkN4oy4zh
         wRMC8QJNgHzr0HQ/FEBascpHvZsBCvnjWQFP49+zaoSPF0LUAz7Yi19SpOLz5ivDGu
         WElhThN1rVmifrmNtOdmegGkBGKdZCOTihmgxHAM=
Subject: FAILED: patch "[PATCH] net: stmmac: add aux timestamps fifo clearance wait" failed to apply to 5.10-stable tree
To:     noor.azura.ahmad.tarmizi@intel.com, kuba@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Jan 2023 10:56:01 +0100
Message-ID: <1673690161244150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ae9dcb91c606 ("net: stmmac: add aux timestamps fifo clearance wait")
f4da56529da6 ("net: stmmac: Add support for external trigger timestamping")
8532f613bc78 ("net: stmmac: introduce MSI Interrupt routines for mac, safety, RX & TX")
7e1c520c0d20 ("net: stmmac: introduce DMA interrupt status masking per traffic direction")
341f67e424e5 ("net: stmmac: Add hardware supported cross-timestamp")
76da35dc99af ("stmmac: intel: Add PSE and PCH PTP clock source selection")
b4d45aee6635 ("net: stmmac: add platform level clocks management")
5ec55823438e ("net: stmmac: add clocks management for gmac driver")
7310fe538ea5 ("stmmac: intel: add pcs-xpcs for Intel mGbE controller")
20e07e2c3cf3 ("net: stmmac: Add PCI bus info to ethtool driver query output")
7cfc4486e7ea ("stmmac: intel: Configure EHL PSE0 GbE and PSE1 GbE to 32 bits DMA addressing")
bff6f1db91e3 ("stmmac: intel: change all EHL/TGL to auto detect phy addr")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ae9dcb91c6069e20b3b9505d79cbc89fd6e086f5 Mon Sep 17 00:00:00 2001
From: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Date: Wed, 11 Jan 2023 13:02:00 +0800
Subject: [PATCH] net: stmmac: add aux timestamps fifo clearance wait

Add timeout polling wait for auxiliary timestamps snapshot FIFO clear bit
(ATSFC) to clear. This is to ensure no residue fifo value is being read
erroneously.

Fixes: f4da56529da6 ("net: stmmac: Add support for external trigger timestamping")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Link: https://lore.kernel.org/r/20230111050200.2130-1-noor.azura.ahmad.tarmizi@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index fc06ddeac0d5..b4388ca8d211 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -210,7 +210,10 @@ static int stmmac_enable(struct ptp_clock_info *ptp,
 		}
 		writel(acr_value, ptpaddr + PTP_ACR);
 		mutex_unlock(&priv->aux_ts_lock);
-		ret = 0;
+		/* wait for auxts fifo clear to finish */
+		ret = readl_poll_timeout(ptpaddr + PTP_ACR, acr_value,
+					 !(acr_value & PTP_ACR_ATSFC),
+					 10, 10000);
 		break;
 
 	default:

