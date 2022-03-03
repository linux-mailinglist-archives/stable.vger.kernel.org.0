Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7385C4CBC28
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 12:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbiCCLIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 06:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbiCCLIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 06:08:23 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98209FD37;
        Thu,  3 Mar 2022 03:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646305657; x=1677841657;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iYkhn+N++G6Az23+XPrHAQS99KXmeNH6QCJYVOADOTE=;
  b=ECAXf5ReldDriZDcAQGvNpkE3lIvxyuuafUwMk/da2zG6TwiTisnwHK6
   YmKEO4MQdbO6L3OWCoCs8apVISHW1tDr8+EAQ3XUZ0LUJPtoh+VCxhqMl
   13aaF2pkmURSMKgPeQV8oYat8SAAuEytCvs3fVnby+/n/827Txon0uFBa
   IZN55SPQu82O1r9vXpCqU7YJ7CtZAVA/kEAeEwu+I7+t/wiqJa1nnS8iK
   V3+3AsD3SQtrOM00bIo5YPRrqQHAQ5qOfb8E0JTO3pEs3X0r5b7vTSjNk
   OeWZtIw85CbVvmb0nR5E6olLt61+lP9PiYn+SOCrEpK1Fwq8UScnGhHPe
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251219891"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="251219891"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 03:07:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="576452380"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga001.jf.intel.com with ESMTP; 03 Mar 2022 03:07:35 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Henry Lin <henryl@nvidia.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH v2 4/9] xhci: fix runtime PM imbalance in USB2 resume
Date:   Thu,  3 Mar 2022 13:08:58 +0200
Message-Id: <20220303110903.1662404-5-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303110903.1662404-1-mathias.nyman@linux.intel.com>
References: <20220303110903.1662404-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Lin <henryl@nvidia.com>

A race between system resume and device-initiated resume may result in
runtime PM imbalance on USB2 root hub. If a device-initiated resume
starts and system resume xhci_bus_resume() directs U0 before hub driver
sees the resuming device in RESUME state, device-initiated resume will
not be finished in xhci_handle_usb2_port_link_resume(). In this case,
usb_hcd_end_port_resume() call is missing.

This changes calls usb_hcd_end_port_resume() if resuming device reaches
U0 to keep runtime PM balance.

Fixes: a231ec41e6f6 ("xhci: refactor U0 link state handling in get_port_status")
Cc: stable@vger.kernel.org
Signed-off-by: Henry Lin <henryl@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index bb4f01ce90e3..1e7dc130c39a 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1088,6 +1088,9 @@ static void xhci_get_usb2_port_status(struct xhci_port *port, u32 *status,
 		if (link_state == XDEV_U2)
 			*status |= USB_PORT_STAT_L1;
 		if (link_state == XDEV_U0) {
+			if (bus_state->resume_done[portnum])
+				usb_hcd_end_port_resume(&port->rhub->hcd->self,
+							portnum);
 			bus_state->resume_done[portnum] = 0;
 			clear_bit(portnum, &bus_state->resuming_ports);
 			if (bus_state->suspended_ports & (1 << portnum)) {
-- 
2.25.1

