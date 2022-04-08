Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E594F9735
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 15:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbiDHNsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 09:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236481AbiDHNsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 09:48:46 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD0E8BF4F;
        Fri,  8 Apr 2022 06:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649425602; x=1680961602;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l4VBFcXc3qAqGn+1Yb4l3Fd2gPYj10oSRfyXmwYf1JQ=;
  b=HFswPf9erbKAZXdZA9yx0u/FTDIlTUOMIHOCTEcjhvlDQVGDkaFUk6N9
   JsG+nhpRPxcVdFbDA86N64k/90OElu0rzYyN3Tpx0lLrxCTBOzftJQISM
   aapgtqHAj1t/svw1+Pqea3I7wFfnO3YUpC/k7NuHKUnWsu+ih67KRoG8h
   +SQXfBObNDW8KVKcTfhcz7DsBq23iDFJfCn0QUmkk7Sq9qB8XE+sHgN0y
   4YtlNgGy+QW17+5csUvdHaae2S+uzavvtTmeBpgRd5zkzwDr6HmFAQCdP
   5HFCmIOGSMLQjpiEGqM3jV3IL4cxXTvLTmDGND/aI5cV3Ta4femu6Ylcd
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="260432095"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="260432095"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 06:46:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="653263292"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga002.fm.intel.com with ESMTP; 08 Apr 2022 06:46:41 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] xhci: increase usb U3 -> U0 link resume timeout from 100ms to 500ms
Date:   Fri,  8 Apr 2022 16:48:23 +0300
Message-Id: <20220408134823.2527272-4-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408134823.2527272-1-mathias.nyman@linux.intel.com>
References: <20220408134823.2527272-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The first U3 wake signal by the host may be lost if the USB 3 connection is
tunneled over USB4, with a runtime suspended USB4 host, and firmware
implemented connection manager.

Specs state the host must wait 100ms (tU3WakeupRetryDelay) before
resending a U3 wake signal if device doesn't respond, leading to U3 -> U0
link transition times around 270ms in the tunneled case.

Cc: stable@vger.kernel.org
Fixes: 0200b9f790b0 ("xhci: Wait until link state trainsits to U0 after setting USB_SS_PORT_LS_U0")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 1e7dc130c39a..f65f1ba2b592 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1434,7 +1434,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 				}
 				spin_unlock_irqrestore(&xhci->lock, flags);
 				if (!wait_for_completion_timeout(&bus_state->u3exit_done[wIndex],
-								 msecs_to_jiffies(100)))
+								 msecs_to_jiffies(500)))
 					xhci_dbg(xhci, "missing U0 port change event for port %d-%d\n",
 						 hcd->self.busnum, wIndex + 1);
 				spin_lock_irqsave(&xhci->lock, flags);
-- 
2.25.1

