Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899D74394AD
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhJYLYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 07:24:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:43251 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231586AbhJYLXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 07:23:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10147"; a="227078939"
X-IronPort-AV: E=Sophos;i="5.87,180,1631602800"; 
   d="scan'208";a="227078939"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 04:20:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,180,1631602800"; 
   d="scan'208";a="634705359"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 25 Oct 2021 04:20:35 -0700
To:     youling 257 <youling257@gmail.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        pkondeti@codeaurora.org, stable@vger.kernel.org
References: <20211008092547.3996295-5-mathias.nyman@linux.intel.com>
 <20211022105913.7671-1-youling257@gmail.com>
 <CAOzgRdY8+Wm-Ane==RQTvEe4aKa40+h1VF9JSg8WQsm-XH0ZCw@mail.gmail.com>
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH 4/5] xhci: Fix command ring pointer corruption while
 aborting a command
Message-ID: <8c3cd8f7-0bd1-0ec4-2f58-6122ae7ef270@linux.intel.com>
Date:   Mon, 25 Oct 2021 14:21:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAOzgRdY8+Wm-Ane==RQTvEe4aKa40+h1VF9JSg8WQsm-XH0ZCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

>> This patch cause suspend to disk resume usb not work, xhci_hcd 0000:00:14.0:
>> Abort failed to stop command ring: -110.

Thanks for the report, this is odd.

Could you double check that by reverting this patch resume start working again.

If this is the case maybe we need to write all 64bits before this xHC hardware reacts to
CRCR register changes.

Maybe following changes on top of current patch could help:

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 311597bba80e..32665637d5e5 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -366,7 +366,7 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd *xhci,
 /* Must be called with xhci->lock held, releases and aquires lock back */
 static int xhci_abort_cmd_ring(struct xhci_hcd *xhci, unsigned long flags)
 {
-	u32 temp_32;
+	u64 crcr;
	int ret;
 
	xhci_dbg(xhci, "Abort command ring\n");
@@ -375,13 +375,15 @@ static int xhci_abort_cmd_ring(struct xhci_hcd *xhci, unsigned long flags)
 
	/*
	 * The control bits like command stop, abort are located in lower
-	 * dword of the command ring control register. Limit the write
-	 * to the lower dword to avoid corrupting the command ring pointer
-        * in case if the command ring is stopped by the time upper dword
-	 * is written.
+	 * dword of the command ring control register. Some hw require all
+	 * 64 bits to be written, starting with lower dword.
+	 * Make sure the upper dword is valid to avoid corrupting the command
+	 * ring pointer in case if the command ring is stopped by the time upper
+	 * dword is written.
	 */
-	temp_32 = readl(&xhci->op_regs->cmd_ring);
-	writel(temp_32 | CMD_RING_ABORT, &xhci->op_regs->cmd_ring);
+	crcr = xhci_trb_virt_to_dma(xhci->cmd_ring->deq_seg,
+				    xhci->cmd_ring->dequeue);
+	xhci_write_64(xhci, crcr | CMD_RING_ABORT, &xhci->op_regs->cmd_ring);

	/* Section 4.6.1.2 of xHCI 1.0 spec says software should also time the
	 * completion of the Command Abort operation. If CRR is not negated in 5

-Mathias
