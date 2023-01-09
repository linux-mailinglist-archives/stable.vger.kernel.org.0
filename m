Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCFC662A11
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 16:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237218AbjAIPcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 10:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbjAIPbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 10:31:51 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C785717047
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 07:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673278270; x=1704814270;
  h=from:to:cc:subject:date:message-id;
  bh=wva8vZRxBk1WM1WW4WpFbcoP5MmHOU8eLhwsXmsxR3Q=;
  b=T6p60CsODXR0wswMd/I17mKCOnhxk4WFy/OGGfxWLlNn6OkjA62L2CuF
   OuzI4iG7QU3x3EwqSWottAcGicEioRB0yC+mVEXhqarzz7I8ovMzcQaGZ
   1H17THzxXQGVZS/Qn0va4fjy2iECd7mnLWvnIr8lJ/caTQP28hSNQUAS6
   dwoeBK1mVKbOXhzLFOAiV3G9OBU31k5GVVRhuKdt2bB0cd0v/E24EhsS4
   NuJjy/B+qXl73tLt2xl9I8etNFZLVStOIABDjUwlVJqzOUfIfmcVKj0dp
   YHhLqqPhe5OvVOYtEzuU0MVbYLhii9zWqzKZFUpTLAiHwfWfy+M6Ac0La
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="409140306"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="409140306"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 07:27:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="725208250"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="725208250"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jan 2023 07:27:55 -0800
Received: from noorazur1-iLBPG12.png.intel.com (noorazur1-iLBPG12.png.intel.com [10.88.229.87])
        by linux.intel.com (Postfix) with ESMTP id D5C8D5809A0;
        Mon,  9 Jan 2023 07:27:53 -0800 (PST)
From:   Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
To:     Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
Cc:     Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH net 1/1] net: stmmac: add aux timestamps fifo clearance wait
Date:   Mon,  9 Jan 2023 23:14:33 +0800
Message-Id: <20230109151433.26201-1-noor.azura.ahmad.tarmizi@intel.com>
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

