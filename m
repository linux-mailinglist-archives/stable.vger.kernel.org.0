Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D1666C278
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjAPOoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjAPOn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:43:28 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF9935255;
        Mon, 16 Jan 2023 06:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673878866; x=1705414866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JzMNMpQ7ed2yal/rXfct7KOZMnPn/kl+KHbkIJaOahQ=;
  b=HY/pIKXc7C+9HCVO+xaKEZ92hFUprzJKrlrDUpjKRsR2qoDJuEbRtvh4
   fAleeoKJ86wc63wWqRpfP7B/mIkv++eD/yTf0wdeJdnSlI5wfM/0n3JsD
   XdU8wV2V7cUDfgc2TY8C/3MU+VYv1aek5feTJRKvsn6nDzhJnYM/O8e6U
   jqTaKKKA4CncQ0T+zTao8ZTK0bFNXrbs0HjD4YLLwIWDkN4FjlQjHaRK/
   yagCWKuKr0F4qyvAIgV+n6LYjScngmK0j033Oy5Q3ydZPt+AIZANPtLup
   JdFUhzo79l5zvLAGRfs3XMm7SE9f0Nyu21Vj2vZf0yAa+srUcVhIiqhbx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="312322932"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="312322932"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 06:21:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="987817184"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="987817184"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jan 2023 06:21:04 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, Jimmy Hu <hhhuuu@google.com>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 2/7] usb: xhci: Check endpoint is valid before dereferencing it
Date:   Mon, 16 Jan 2023 16:22:11 +0200
Message-Id: <20230116142216.1141605-3-mathias.nyman@linux.intel.com>
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

From: Jimmy Hu <hhhuuu@google.com>

When the host controller is not responding, all URBs queued to all
endpoints need to be killed. This can cause a kernel panic if we
dereference an invalid endpoint.

Fix this by using xhci_get_virt_ep() helper to find the endpoint and
checking if the endpoint is valid before dereferencing it.

[233311.853271] xhci-hcd xhci-hcd.1.auto: xHCI host controller not responding, assume dead
[233311.853393] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000e8

[233311.853964] pc : xhci_hc_died+0x10c/0x270
[233311.853971] lr : xhci_hc_died+0x1ac/0x270

[233311.854077] Call trace:
[233311.854085]  xhci_hc_died+0x10c/0x270
[233311.854093]  xhci_stop_endpoint_command_watchdog+0x100/0x1a4
[233311.854105]  call_timer_fn+0x50/0x2d4
[233311.854112]  expire_timers+0xac/0x2e4
[233311.854118]  run_timer_softirq+0x300/0xabc
[233311.854127]  __do_softirq+0x148/0x528
[233311.854135]  irq_exit+0x194/0x1a8
[233311.854143]  __handle_domain_irq+0x164/0x1d0
[233311.854149]  gic_handle_irq.22273+0x10c/0x188
[233311.854156]  el1_irq+0xfc/0x1a8
[233311.854175]  lpm_cpuidle_enter+0x25c/0x418 [msm_pm]
[233311.854185]  cpuidle_enter_state+0x1f0/0x764
[233311.854194]  do_idle+0x594/0x6ac
[233311.854201]  cpu_startup_entry+0x7c/0x80
[233311.854209]  secondary_start_kernel+0x170/0x198

Fixes: 50e8725e7c42 ("xhci: Refactor command watchdog and fix split string.")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Hu <hhhuuu@google.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index ddc30037f9ce..f5b0e1ce22af 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1169,7 +1169,10 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
 	struct xhci_virt_ep *ep;
 	struct xhci_ring *ring;
 
-	ep = &xhci->devs[slot_id]->eps[ep_index];
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return;
+
 	if ((ep->ep_state & EP_HAS_STREAMS) ||
 			(ep->ep_state & EP_GETTING_NO_STREAMS)) {
 		int stream_id;
-- 
2.25.1

