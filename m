Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C21CB99A
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 13:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbfJDL5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 07:57:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:33448 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfJDL5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 07:57:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 04:57:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,256,1566889200"; 
   d="scan'208";a="186229443"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 04 Oct 2019 04:57:43 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "# v4 . 18+" <stable@vger.kernel.org>,
        =?UTF-8?q?Lo=C3=AFc=20Yhuel?= <loic.yhuel@gmail.com>
Subject: [PATCH 4/8] xhci: Fix USB 3.1 capability detection on early xHCI 1.1 spec based hosts
Date:   Fri,  4 Oct 2019 14:59:29 +0300
Message-Id: <1570190373-30684-5-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570190373-30684-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1570190373-30684-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Early xHCI 1.1 spec did not mention USB 3.1 capable hosts should set
sbrn to 0x31, or that the minor revision is a two digit BCD
containing minor and sub-minor numbers.
This was later clarified in xHCI 1.2.

Some USB 3.1 capable hosts therefore have sbrn set to 0x30, or minor
revision set to 0x1 instead of 0x10.

Detect the USB 3.1 capability correctly for these hosts as well

Fixes: ddd57980a0fd ("xhci: detect USB 3.2 capable host controllers correctly")
Cc: <stable@vger.kernel.org> # v4.18+
Cc: Loïc Yhuel <loic.yhuel@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a5ba5ace3d00..aec69d294973 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5079,11 +5079,18 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 		hcd->has_tt = 1;
 	} else {
 		/*
-		 * Some 3.1 hosts return sbrn 0x30, use xhci supported protocol
-		 * minor revision instead of sbrn. Minor revision is a two digit
-		 * BCD containing minor and sub-minor numbers, only show minor.
+		 * Early xHCI 1.1 spec did not mention USB 3.1 capable hosts
+		 * should return 0x31 for sbrn, or that the minor revision
+		 * is a two digit BCD containig minor and sub-minor numbers.
+		 * This was later clarified in xHCI 1.2.
+		 *
+		 * Some USB 3.1 capable hosts therefore have sbrn 0x30, and
+		 * minor revision set to 0x1 instead of 0x10.
 		 */
-		minor_rev = xhci->usb3_rhub.min_rev / 0x10;
+		if (xhci->usb3_rhub.min_rev == 0x1)
+			minor_rev = 1;
+		else
+			minor_rev = xhci->usb3_rhub.min_rev / 0x10;
 
 		switch (minor_rev) {
 		case 2:
-- 
2.7.4

