Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D22B662927
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 15:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjAIO6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 09:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjAIO6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 09:58:02 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16D41570E
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 06:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673276281; x=1704812281;
  h=from:to:cc:subject:date:message-id;
  bh=MNjeI7mhUv6Lf4neOwqOGMOpQ8FYcoXk40gGQI68o/4=;
  b=SgEtU/IPu95mGfmgcEUBGTJT02R7tnzk3fkwqCiCgh5XOuvrWsN8GBoG
   G+shyFy2KSfD8tE7Dqo4Vzi8UBBrzadrO3gmeeSNJr2KO/LHJTkvWykHI
   w43ubQBEyN2d2kJBzO5/QsXKrLR55uJ/Vmi+L+UsekzcJo+Rgk7KKwRtA
   imJyTM+GiLl3wV87qIM5dJhLLUiQfq2jleUk/x/c/TLuDW+ojBTb0V/eC
   xbJjYE6HDtquxUw0dv0Qrn6IPPTY9G6u2jp/ZYMOjNkyxdFJwN7oSgJaN
   B9+Yqjy+2KQ8Md10I8G36bLfl/0qoS4Nz1zhmIUzkgWFCothq5apVHsCb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="320590033"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="320590033"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 06:58:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="764339632"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="764339632"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jan 2023 06:58:01 -0800
Received: from noorazur1-iLBPG12.png.intel.com (noorazur1-iLBPG12.png.intel.com [10.88.229.87])
        by linux.intel.com (Postfix) with ESMTP id 5CE59580ABB;
        Mon,  9 Jan 2023 06:58:00 -0800 (PST)
From:   Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
To:     Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Cc:     Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH net v2 1/1] net: stmmac: add aux timestamps fifo clearance wait
Date:   Mon,  9 Jan 2023 22:44:39 +0800
Message-Id: <20230109144439.5615-1-noor.azura.ahmad.tarmizi@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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
v1 -> v2: Test update to version 2

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

