Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836B766291E
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 15:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbjAIOyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 09:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234720AbjAIOy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 09:54:29 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BC1D53
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 06:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673276068; x=1704812068;
  h=from:to:cc:subject:date:message-id;
  bh=wva8vZRxBk1WM1WW4WpFbcoP5MmHOU8eLhwsXmsxR3Q=;
  b=jLg4TWADNDC3koPeQDj/VvcmeAOhAZylHpzPSZppmssWyCQMM29fDYSs
   E6Uo5VxKEv8JRU55skNgTsw+i26Ezt56GG7mKotJqhsv6w1K/zSP1eZx/
   9dWRxtM1e6Fvt6kKM9m2bugp3xt+Ec6noJxki37+UY3NhdovL0o20whlg
   hXHJHbs9Wjb/PHSrCOk3e9WysY0YAvU4OejbcoUdy0wUiA7NByuE2fKMe
   SrXLTNZuy+c4t7dmq6e/45UDYjcebzv8Q1Bqu6wLLQIwhD4KtbJTbzlXG
   eG/KRUCwiUNfT/6TRJT3Rl6u9ppggHQL9B+o0XQucPLsjQoTA495E6v6U
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="324133678"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="324133678"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 06:54:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="656702340"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="656702340"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 09 Jan 2023 06:54:22 -0800
Received: from noorazur1-iLBPG12.png.intel.com (noorazur1-iLBPG12.png.intel.com [10.88.229.87])
        by linux.intel.com (Postfix) with ESMTP id D0EAF580ABB;
        Mon,  9 Jan 2023 06:54:21 -0800 (PST)
From:   Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
To:     Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Cc:     Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH net v2 1/1] net: stmmac: add aux timestamps fifo clearance wait
Date:   Mon,  9 Jan 2023 22:41:01 +0800
Message-Id: <20230109144101.604-1-noor.azura.ahmad.tarmizi@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add timeout polling wait for auxiliary timestamps snapshot FIFO clear bit
(ATSFC) to clear. This is to ensure no residue fifo value is being read
erroneously.

Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
-- 
2.17.1

