Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00A424D12E
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 11:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgHUJMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 05:12:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:65060 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgHUJMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 05:12:44 -0400
IronPort-SDR: eKNFLZc2P+Jnmh/4il2TmdyXHKcq/epj+JobJyk23hVqpSCpdsv8eqGKy7Uk+NZiRIEb/y10E6
 HNUqnHCipzwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="143128378"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="143128378"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 02:12:43 -0700
IronPort-SDR: L1ZHWVWUhHwtoxg4o5YprUVrPG06hB6Cvi1y4bPasQYrTqFfnLZT1G/jr1j1kK6sI6hzLuVw4k
 /7Nhmxm05Ogw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="321194890"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga004.fm.intel.com with ESMTP; 21 Aug 2020 02:12:42 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Li Jun <jun.li@nxp.com>,
        stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 1/3] usb: host: xhci: fix ep context print mismatch in debugfs
Date:   Fri, 21 Aug 2020 12:15:47 +0300
Message-Id: <20200821091549.20556-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821091549.20556-1-mathias.nyman@linux.intel.com>
References: <20200821091549.20556-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

dci is 0 based and xhci_get_ep_ctx() will do ep index increment to get
the ep context.

[rename dci to ep_index -Mathias]
Cc: stable <stable@vger.kernel.org> # v4.15+
Fixes: 02b6fdc2a153 ("usb: xhci: Add debugfs interface for xHCI driver")
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-debugfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-debugfs.c b/drivers/usb/host/xhci-debugfs.c
index 92e25a62fdb5..c88bffd68742 100644
--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -274,7 +274,7 @@ static int xhci_slot_context_show(struct seq_file *s, void *unused)
 
 static int xhci_endpoint_context_show(struct seq_file *s, void *unused)
 {
-	int			dci;
+	int			ep_index;
 	dma_addr_t		dma;
 	struct xhci_hcd		*xhci;
 	struct xhci_ep_ctx	*ep_ctx;
@@ -283,9 +283,9 @@ static int xhci_endpoint_context_show(struct seq_file *s, void *unused)
 
 	xhci = hcd_to_xhci(bus_to_hcd(dev->udev->bus));
 
-	for (dci = 1; dci < 32; dci++) {
-		ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, dci);
-		dma = dev->out_ctx->dma + dci * CTX_SIZE(xhci->hcc_params);
+	for (ep_index = 0; ep_index < 31; ep_index++) {
+		ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
+		dma = dev->out_ctx->dma + (ep_index + 1) * CTX_SIZE(xhci->hcc_params);
 		seq_printf(s, "%pad: %s\n", &dma,
 			   xhci_decode_ep_context(le32_to_cpu(ep_ctx->ep_info),
 						  le32_to_cpu(ep_ctx->ep_info2),
-- 
2.17.1

