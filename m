Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CA55A153A
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 17:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239344AbiHYPHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 11:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237455AbiHYPHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 11:07:35 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969A981B2E;
        Thu, 25 Aug 2022 08:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661440054; x=1692976054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1DOhxGeiZXBrAneenWdEy15uEJy6cOb8JqHxpZ9EpwA=;
  b=PzLu4/fdoCIkGhByX1eE4hWzpCsYAtRdIcwUtpd2kRRxPEvdnekDQ6SF
   RooW6HNRktrEcZwA9SP4tYw0U9zJubUM1Cohoi1kcPLr73VHyJQv+u4vX
   SBhPhKbxVn2KCZao/7DUFWpi4LM4+NMvAMevtgnK3Ug4W3jgUFK3XXFxu
   IH9uDcM8hQ3KU90nIonexBSSOzMj8jVEf8AjzT6ShJHyJ5nLM+plASnyz
   dLMtcsFvQNfj9uFQaUpBqG8dk4AMVfF3pgX8Fn9596GE3A2Ds8Oku3zJt
   dggqJmNFbFGvMQmQN0IRIZ9NSRnLat7AldfW0TBXEm0J3kJup6bZw7Lhf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="355981801"
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="355981801"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 08:07:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,263,1654585200"; 
   d="scan'208";a="643284826"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 25 Aug 2022 08:07:31 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] xhci: Add grace period after xHC start to prevent premature runtime suspend.
Date:   Thu, 25 Aug 2022 18:08:39 +0300
Message-Id: <20220825150840.132216-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220825150840.132216-1-mathias.nyman@linux.intel.com>
References: <20220825150840.132216-1-mathias.nyman@linux.intel.com>
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

After xHC controller is started, either in probe or resume, it can take
a while before any of the connected usb devices are visible to the roothub
due to link training.

It's possible xhci driver loads, sees no acivity and suspends the host
before the USB device is visible.

In one testcase with a hotplugged xHC controller the host finally detected
the connected USB device and generated a wake 500ms after host initial
start.

If hosts didn't suspend the device duringe training it probablty wouldn't
take up to 500ms to detect it, but looking at specs reveal USB3 link
training has a couple long timeout values, such as 120ms
RxDetectQuietTimeout, and 360ms PollingLFPSTimeout.

So Add a 500ms grace period that keeps polling the roothub for 500ms after
start, preventing runtime suspend until USB devices are detected.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c | 11 +++++++++++
 drivers/usb/host/xhci.c     |  4 +++-
 drivers/usb/host/xhci.h     |  2 +-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 0fdc014c9401..b30298986a69 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1648,6 +1648,17 @@ int xhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 
 	status = bus_state->resuming_ports;
 
+	/*
+	 * SS devices are only visible to roothub after link training completes.
+	 * Keep polling roothubs for a grace period after xHC start
+	 */
+	if (xhci->run_graceperiod) {
+		if (time_before(jiffies, xhci->run_graceperiod))
+			status = 1;
+		else
+			xhci->run_graceperiod = 0;
+	}
+
 	mask = PORT_CSC | PORT_PEC | PORT_OCC | PORT_PLC | PORT_WRC | PORT_CEC;
 
 	/* For each port, did anything change?  If so, set that bit in buf. */
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 65858f607437..1afd32beec99 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -151,9 +151,11 @@ int xhci_start(struct xhci_hcd *xhci)
 		xhci_err(xhci, "Host took too long to start, "
 				"waited %u microseconds.\n",
 				XHCI_MAX_HALT_USEC);
-	if (!ret)
+	if (!ret) {
 		/* clear state flags. Including dying, halted or removing */
 		xhci->xhc_state = 0;
+		xhci->run_graceperiod = jiffies + msecs_to_jiffies(500);
+	}
 
 	return ret;
 }
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 1960b47acfb2..df6f2ebaff18 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1826,7 +1826,7 @@ struct xhci_hcd {
 
 	/* Host controller watchdog timer structures */
 	unsigned int		xhc_state;
-
+	unsigned long		run_graceperiod;
 	u32			command;
 	struct s3_save		s3;
 /* Host controller is dying - not responding to commands. "I'm not dead yet!"
-- 
2.25.1

