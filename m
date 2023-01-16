Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC9B66C276
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjAPOoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjAPOn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:43:28 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E63A2449D;
        Mon, 16 Jan 2023 06:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673878871; x=1705414871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SOVQZKrr5URDcyPP3D+C6d4QlrafqNVC6a9c0MPjlKU=;
  b=hSciHy0ccl0dc0585ghWf7hesdKP8pne4r2pctLbRxtv+KgUTB/PuY4C
   8Ex33s+Cy/xK0lt/8eUu2xE9j5mZDavIRMWgOxjh+tSebBF93i60gPesO
   47L9pgBeoi/P88+/gtZVnLyj6XJWtoXRpsPl2fUG0CNmHYT3HoZOSo7TQ
   jwp91EAIp+qv79JlIDym0MBoyX3BwXullKi1tdVpIDnN0Ok6AKMtj99eU
   t3zYl5LP8krQv/Lhkf0SnJqCKZexy1N5DV4oWBv2NE4NjZzQNGuhaCEMO
   7W3GQ+7joe9TJhoWodPZ4uHfPrwdpNyoRPcI4kMqFpMNP162gAfXKJsjW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="312322953"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="312322953"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 06:21:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="987817206"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="987817206"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jan 2023 06:21:09 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 5/7] xhci: Add a flag to disable USB3 lpm on a xhci root port level.
Date:   Mon, 16 Jan 2023 16:22:14 +0200
Message-Id: <20230116142216.1141605-6-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116142216.1141605-1-mathias.nyman@linux.intel.com>
References: <20230116142216.1141605-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

One USB3 roothub port may support link power management, while another
root port on the same xHC can't due to different retimers used for
the ports.

This is the case with Intel Alder Lake, and possible future platforms
where retimers used for USB4 ports cause too long exit latecy to
enable native USB3 lpm U1 and U2 states.

Add a flag in the xhci port structure to indicate if the port is
lpm_incapable, and check it while calculating exit latency.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 8 ++++++++
 drivers/usb/host/xhci.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 89f92fc78bb1..2b280beb0011 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5049,6 +5049,7 @@ static int xhci_enable_usb3_lpm_timeout(struct usb_hcd *hcd,
 			struct usb_device *udev, enum usb3_link_state state)
 {
 	struct xhci_hcd	*xhci;
+	struct xhci_port *port;
 	u16 hub_encoded_timeout;
 	int mel;
 	int ret;
@@ -5065,6 +5066,13 @@ static int xhci_enable_usb3_lpm_timeout(struct usb_hcd *hcd,
 	if (xhci_check_tier_policy(xhci, udev, state) < 0)
 		return USB3_LPM_DISABLED;
 
+	/* If connected to root port then check port can handle lpm */
+	if (udev->parent && !udev->parent->parent) {
+		port = xhci->usb3_rhub.ports[udev->portnum - 1];
+		if (port->lpm_incapable)
+			return USB3_LPM_DISABLED;
+	}
+
 	hub_encoded_timeout = xhci_calculate_lpm_timeout(hcd, udev, state);
 	mel = calculate_max_exit_latency(udev, state, hub_encoded_timeout);
 	if (mel < 0) {
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 3edfacb93817..dcee7f3207ad 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1735,6 +1735,7 @@ struct xhci_port {
 	int			hcd_portnum;
 	struct xhci_hub		*rhub;
 	struct xhci_port_cap	*port_cap;
+	unsigned int		lpm_incapable:1;
 };
 
 struct xhci_hub {
-- 
2.25.1

