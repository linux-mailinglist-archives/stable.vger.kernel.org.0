Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D2676E67
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjAVPKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjAVPKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:10:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3EC1F5D0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:10:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8588160C5C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C7BC433D2;
        Sun, 22 Jan 2023 15:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400207;
        bh=mPu63sf5o9V1+jdPl3Tt45olOsBL34qSaNss6EApYc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCv7gl1d9tJYuN1ZKRAxzrHMbU9/6UaqIo1DGgkix8OdhFsXy7WJAPHx1m6yqQf+G
         IehhhercGWi6wObfq/0GEaFD2ufksEpjy0B+VljQ6EHWBSwSL/G2GLe7MGtz3rueaD
         RKNFev+zUUIpcvnRdgbyz9iD10VTAJlxq/ttw5e0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jimmy Hu <hhhuuu@google.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 13/55] usb: xhci: Check endpoint is valid before dereferencing it
Date:   Sun, 22 Jan 2023 16:04:00 +0100
Message-Id: <20230122150222.804995363@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Hu <hhhuuu@google.com>

commit e8fb5bc76eb86437ab87002d4a36d6da02165654 upstream.

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
Message-ID: <0fe978ed-8269-9774-1c40-f8a98c17e838@linux.intel.com>
Link: https://lore.kernel.org/r/20230116142216.1141605-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -921,7 +921,10 @@ static void xhci_kill_endpoint_urbs(stru
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


