Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7C44B6C10
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 13:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbiBOMcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 07:32:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiBOMcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 07:32:19 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF259107D33;
        Tue, 15 Feb 2022 04:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644928329; x=1676464329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KkBlnmLKLUYXvnLYGVy9PBO4HTSjyp0rWzHy7zNqLxA=;
  b=ah+R7gvfpyLWBqOy/Hr+zXMPR3kbfIPmTiK8283jscQeNYnJAOK8btV+
   8IDS1CXX9VGROa63uHMuq+8RdrMMqARfO0mUxvVXqhGBqpt6YD1pygfzg
   DIqtKfCjvTBs8nYUR/KJ6d4SYIAzkYqyWtfo3P7XBKEhPe5kRKreTmPzR
   KBbpLgsX5Y/NmjMVDGytvLP8ATv5HqrTda2gh1NGaBx2k1EvETSQtpuzs
   CjWHJJwYh9AS/MGNXJ9+IxQNTbxhfNDzeTNC/OjmI871oF6ABNDXE4GDU
   FOhShUSMPrfBVQafVLF2auAI/DiUeWF2ddTue4uATO1A9z3gWih+qUeFE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="250082436"
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="250082436"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 04:32:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="703641745"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga005.jf.intel.com with ESMTP; 15 Feb 2022 04:32:07 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Puma Hsu <pumahsu@google.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 1/2] xhci: re-initialize the HC during resume if HCE was set
Date:   Tue, 15 Feb 2022 14:33:19 +0200
Message-Id: <20220215123320.1253947-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215123320.1253947-1-mathias.nyman@linux.intel.com>
References: <20220215123320.1253947-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Puma Hsu <pumahsu@google.com>

When HCE(Host Controller Error) is set, it means an internal
error condition has been detected. Software needs to re-initialize
the HC, so add this check in xhci resume.

Cc: stable@vger.kernel.org
Signed-off-by: Puma Hsu <pumahsu@google.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index dc357cabb265..04ec2de158bf 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1091,6 +1091,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	int			retval = 0;
 	bool			comp_timer_running = false;
 	bool			pending_portevent = false;
+	bool			reinit_xhc = false;
 
 	if (!hcd->state)
 		return 0;
@@ -1107,10 +1108,11 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	set_bit(HCD_FLAG_HW_ACCESSIBLE, &xhci->shared_hcd->flags);
 
 	spin_lock_irq(&xhci->lock);
-	if ((xhci->quirks & XHCI_RESET_ON_RESUME) || xhci->broken_suspend)
-		hibernated = true;
 
-	if (!hibernated) {
+	if (hibernated || xhci->quirks & XHCI_RESET_ON_RESUME || xhci->broken_suspend)
+		reinit_xhc = true;
+
+	if (!reinit_xhc) {
 		/*
 		 * Some controllers might lose power during suspend, so wait
 		 * for controller not ready bit to clear, just as in xHC init.
@@ -1143,12 +1145,17 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 			spin_unlock_irq(&xhci->lock);
 			return -ETIMEDOUT;
 		}
-		temp = readl(&xhci->op_regs->status);
 	}
 
-	/* If restore operation fails, re-initialize the HC during resume */
-	if ((temp & STS_SRE) || hibernated) {
+	temp = readl(&xhci->op_regs->status);
+
+	/* re-initialize the HC on Restore Error, or Host Controller Error */
+	if (temp & (STS_SRE | STS_HCE)) {
+		reinit_xhc = true;
+		xhci_warn(xhci, "xHC error in resume, USBSTS 0x%x, Reinit\n", temp);
+	}
 
+	if (reinit_xhc) {
 		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
 				!(xhci_all_ports_seen_u0(xhci))) {
 			del_timer_sync(&xhci->comp_mode_recovery_timer);
-- 
2.25.1

