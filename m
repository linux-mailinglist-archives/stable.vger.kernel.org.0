Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFD53371D2
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 12:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhCKLwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 06:52:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:16412 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232719AbhCKLwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 06:52:31 -0500
IronPort-SDR: jaEJcGmPl9AjfOrpmpDpxz14GMxpPhsr14L8m7ceg05cUX2nSP5z0bwFIoIi8+Xa1Q6wwv6Koo
 2+J0e4j4VCRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="188752215"
X-IronPort-AV: E=Sophos;i="5.81,240,1610438400"; 
   d="scan'208";a="188752215"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 03:52:30 -0800
IronPort-SDR: gJNkl1qlRYM1s8FhUNLJxSnLS7jxe4YsxLGDzdVGj9jhNLAz4WTYFHVttPC6iUO3P3LE+RjdJc
 hhGkrVrgv+Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,240,1610438400"; 
   d="scan'208";a="409463981"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2021 03:52:27 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] xhci: Improve detection of device initiated wake signal.
Date:   Thu, 11 Mar 2021 13:53:51 +0200
Message-Id: <20210311115353.2137560-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311115353.2137560-1-mathias.nyman@linux.intel.com>
References: <20210311115353.2137560-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A xHC USB 3 port might miss the first wake signal from a USB 3 device
if the port LFPS reveiver isn't enabled fast enough after xHC resume.

xHC host will anyway be resumed by a PME# signal, but will go back to
suspend if no port activity is seen.
The device resends the U3 LFPS wake signal after a 100ms delay, but
by then host is already suspended, starting all over from the
beginning of this issue.

USB 3 specs say U3 wake LFPS signal is sent for max 10ms, then device
needs to delay 100ms before resending the wake.

Don't suspend immediately if port activity isn't detected in resume.
Instead add a retry. If there is no port activity then delay for 120ms,
and re-check for port activity.

Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index bd27bd670104..48a68fcf2b36 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1088,6 +1088,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	struct usb_hcd		*secondary_hcd;
 	int			retval = 0;
 	bool			comp_timer_running = false;
+	bool			pending_portevent = false;
 
 	if (!hcd->state)
 		return 0;
@@ -1226,13 +1227,22 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 
  done:
 	if (retval == 0) {
-		/* Resume root hubs only when have pending events. */
-		if (xhci_pending_portevent(xhci)) {
+		/*
+		 * Resume roothubs only if there are pending events.
+		 * USB 3 devices resend U3 LFPS wake after a 100ms delay if
+		 * the first wake signalling failed, give it that chance.
+		 */
+		pending_portevent = xhci_pending_portevent(xhci);
+		if (!pending_portevent) {
+			msleep(120);
+			pending_portevent = xhci_pending_portevent(xhci);
+		}
+
+		if (pending_portevent) {
 			usb_hcd_resume_root_hub(xhci->shared_hcd);
 			usb_hcd_resume_root_hub(hcd);
 		}
 	}
-
 	/*
 	 * If system is subject to the Quirk, Compliance Mode Timer needs to
 	 * be re-initialized Always after a system resume. Ports are subject
-- 
2.25.1

