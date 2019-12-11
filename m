Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 374FD11AD34
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbfLKOSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:18:36 -0500
Received: from mga07.intel.com ([134.134.136.100]:52849 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbfLKOSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 09:18:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 06:18:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="414868241"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga006.fm.intel.com with ESMTP; 11 Dec 2019 06:18:33 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4/6] xhci: Increase STS_HALT timeout in xhci_suspend()
Date:   Wed, 11 Dec 2019 16:20:05 +0200
Message-Id: <20191211142007.8847-5-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211142007.8847-1-mathias.nyman@linux.intel.com>
References: <20191211142007.8847-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

I've recently observed failed xHCI suspend attempt on AMD Raven Ridge
system:
kernel: xhci_hcd 0000:04:00.4: WARN: xHC CMD_RUN timeout
kernel: PM: suspend_common(): xhci_pci_suspend+0x0/0xd0 returns -110
kernel: PM: pci_pm_suspend(): hcd_pci_suspend+0x0/0x30 returns -110
kernel: PM: dpm_run_callback(): pci_pm_suspend+0x0/0x150 returns -110
kernel: PM: Device 0000:04:00.4 failed to suspend async: error -110

Similar to commit ac343366846a ("xhci: Increase STS_SAVE timeout in
xhci_suspend()") we also need to increase the HALT timeout to make it be
able to suspend again.

Cc: <stable@vger.kernel.org> # 5.2+
Fixes: f7fac17ca925 ("xhci: Convert xhci_handshake() to use readl_poll_timeout_atomic()")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c5ee562c4c74..dbac0fa9748d 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -970,7 +970,7 @@ static bool xhci_pending_portevent(struct xhci_hcd *xhci)
 int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
 {
 	int			rc = 0;
-	unsigned int		delay = XHCI_MAX_HALT_USEC;
+	unsigned int		delay = XHCI_MAX_HALT_USEC * 2;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	u32			command;
 	u32			res;
-- 
2.17.1

