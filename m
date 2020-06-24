Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0151207504
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 15:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403994AbgFXN4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 09:56:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:43621 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403988AbgFXN4t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 09:56:49 -0400
IronPort-SDR: bsdUCaeIpFPvR/waB7x3aHUK+rPOYm+211kl8kvCiK46AkTvzVGXsRWRRBWEo/IsE4uZDyLMdN
 qu6KuhnYPNdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="132909235"
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="132909235"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 06:56:49 -0700
IronPort-SDR: GvYDAlAvEJinW2lPbtJBxLMTCUdj0IS7x+oNC/TYNtPbxKZVyMK/R1h4VOOou2g+e66sbB/F9i
 ehzQwqRkXvSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="263644026"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jun 2020 06:56:47 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/5] xhci: Fix incorrect EP_STATE_MASK
Date:   Wed, 24 Jun 2020 16:59:45 +0300
Message-Id: <20200624135949.22611-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624135949.22611-1-mathias.nyman@linux.intel.com>
References: <20200624135949.22611-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

EP_STATE_MASK should be 0x7 instead of 0xf

xhci spec 6.2.3 shows that the EP state field in the endpoint context data
structure consist of bits [2:0].
The old value included a bit from the next field which fortunately is a
 RsvdZ region. So hopefully this hasn't caused too much harm

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 2c6c4f8d1ee1..c295e8a7f5ae 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -716,7 +716,7 @@ struct xhci_ep_ctx {
  * 4 - TRB error
  * 5-7 - reserved
  */
-#define EP_STATE_MASK		(0xf)
+#define EP_STATE_MASK		(0x7)
 #define EP_STATE_DISABLED	0
 #define EP_STATE_RUNNING	1
 #define EP_STATE_HALTED		2
-- 
2.17.1

