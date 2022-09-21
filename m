Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8DA5BFDFB
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 14:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiIUMdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 08:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiIUMdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 08:33:36 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78536F247;
        Wed, 21 Sep 2022 05:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663763615; x=1695299615;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ziGX66AbiYR2EZskkYdpAo55M94DeQXsDOfDCkgAD+A=;
  b=U77eIK0wMxURkoiCB6jRF7PMXPKoTSXQyE0Mkg5IrennzYEf5aroyVOd
   r7GyBhlumKfV2CSo7sEUP/IuS0iiAqp/2sytTV1SWpjv049EQL7hBK1f5
   IbhAyJ3PnkUWhY9adVu8FcMCUp4PzZdD9onmY7cNEIS20l5HanObafmq9
   3wTl6riwb8FmhegClvTgSnMDH004y70JxKNOMwQOYRtAXLh7/gaGiud1F
   ZsyeybeBel9Z43N0IAJ9r9DIG+BUmD8NYaXEcUdN0+RjS7k+npIGwrtKy
   idomPtS9fGdCR5D50eh+/GO7X2ACmt08ai2IaK0ZxDj9Xqsz0PVs002T1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="363965097"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="363965097"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 05:33:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="708429453"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Sep 2022 05:33:33 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Rafael Mendonca <rafaelmendsr@gmail.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 2/6] xhci: dbc: Fix memory leak in xhci_alloc_dbc()
Date:   Wed, 21 Sep 2022 15:34:46 +0300
Message-Id: <20220921123450.671459-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921123450.671459-1-mathias.nyman@linux.intel.com>
References: <20220921123450.671459-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

If DbC is already in use, then the allocated memory for the xhci_dbc struct
doesn't get freed before returning NULL, which leads to a memleak.

Fixes: 534675942e90 ("xhci: dbc: refactor xhci_dbc_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-dbgcap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
index e61155fa6379..f1367b53b260 100644
--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -988,7 +988,7 @@ xhci_alloc_dbc(struct device *dev, void __iomem *base, const struct dbc_driver *
 	dbc->driver = driver;
 
 	if (readl(&dbc->regs->control) & DBC_CTRL_DBC_ENABLE)
-		return NULL;
+		goto err;
 
 	INIT_DELAYED_WORK(&dbc->event_work, xhci_dbc_handle_events);
 	spin_lock_init(&dbc->lock);
-- 
2.25.1

