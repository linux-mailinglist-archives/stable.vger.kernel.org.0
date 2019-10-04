Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2EBBCB998
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 13:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfJDL5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 07:57:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:33448 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfJDL5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 07:57:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 04:57:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,256,1566889200"; 
   d="scan'208";a="186229440"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 04 Oct 2019 04:57:41 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Jan Schmidt <jan@centricular.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3/8] xhci: Check all endpoints for LPM timeout
Date:   Fri,  4 Oct 2019 14:59:28 +0300
Message-Id: <1570190373-30684-4-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570190373-30684-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1570190373-30684-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Schmidt <jan@centricular.com>

If an endpoint is encountered that returns USB3_LPM_DEVICE_INITIATED, keep
checking further endpoints, as there might be periodic endpoints later
that return USB3_LPM_DISABLED due to shorter service intervals.

Without this, the code can set too high a maximum-exit-latency and
prevent the use of multiple USB3 cameras that should be able to work.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jan Schmidt <jan@centricular.com>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index aed5a65f25bd..a5ba5ace3d00 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4674,12 +4674,12 @@ static int xhci_update_timeout_for_endpoint(struct xhci_hcd *xhci,
 	alt_timeout = xhci_call_host_update_timeout_for_endpoint(xhci, udev,
 		desc, state, timeout);
 
-	/* If we found we can't enable hub-initiated LPM, or
+	/* If we found we can't enable hub-initiated LPM, and
 	 * the U1 or U2 exit latency was too high to allow
-	 * device-initiated LPM as well, just stop searching.
+	 * device-initiated LPM as well, then we will disable LPM
+	 * for this device, so stop searching any further.
 	 */
-	if (alt_timeout == USB3_LPM_DISABLED ||
-			alt_timeout == USB3_LPM_DEVICE_INITIATED) {
+	if (alt_timeout == USB3_LPM_DISABLED) {
 		*timeout = alt_timeout;
 		return -E2BIG;
 	}
-- 
2.7.4

