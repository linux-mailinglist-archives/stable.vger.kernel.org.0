Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30400653D3B
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 10:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiLVJCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 04:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiLVJCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 04:02:17 -0500
X-Greylist: delayed 61 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Dec 2022 01:02:16 PST
Received: from h1.cmg1.smtp.forpsi.com (h1.cmg1.smtp.forpsi.com [81.2.195.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592FA201B4
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 01:02:16 -0800 (PST)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id 8HRupBMVhPm6C8HRwps7dc; Thu, 22 Dec 2022 10:01:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1671699673; bh=qge3kDbkiWyV4yHzI7E+c0ZfjS1KW8bVG8zEvpOWOd0=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=I8sIdEt4zgseAOWO1uZpTg4s5AR8McQeqDXwwZJS3svKg1Nzt6Dgwkk+AFwy2wZLW
         B2y9df9/XZI9xNlVACIv7IjvTbWWQ5zg3YJR7DC6pt1GtIW5E4++0tfearsd/cPTIE
         sSGQLkjcJ3aWhB2JFTGl/UoO1etNrwtlO24g3G1zDRGmmOFGVsBTDsOpITIqV0C4K3
         AE1SmYgJx5CdynP/o2t9aKPER84egcDTbx9EM6HkxfDG6a7rqFRGYzveu/UfSnws8W
         wKTtDxSuNV8GRnrbVUeUVDpvs81lrgOzH2Ao9d8rdALNGrPYK9Dlxukx3ku8pe3ufb
         6fWzO3fsNA41A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1671699673; bh=qge3kDbkiWyV4yHzI7E+c0ZfjS1KW8bVG8zEvpOWOd0=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=I8sIdEt4zgseAOWO1uZpTg4s5AR8McQeqDXwwZJS3svKg1Nzt6Dgwkk+AFwy2wZLW
         B2y9df9/XZI9xNlVACIv7IjvTbWWQ5zg3YJR7DC6pt1GtIW5E4++0tfearsd/cPTIE
         sSGQLkjcJ3aWhB2JFTGl/UoO1etNrwtlO24g3G1zDRGmmOFGVsBTDsOpITIqV0C4K3
         AE1SmYgJx5CdynP/o2t9aKPER84egcDTbx9EM6HkxfDG6a7rqFRGYzveu/UfSnws8W
         wKTtDxSuNV8GRnrbVUeUVDpvs81lrgOzH2Ao9d8rdALNGrPYK9Dlxukx3ku8pe3ufb
         6fWzO3fsNA41A==
Date:   Thu, 22 Dec 2022 10:01:10 +0100
From:   Ladislav Michl <oss-lists@triops.cz>
To:     Jimmy Hu <hhhuuu@google.com>
Cc:     mathias.nyman@intel.com, gregkh@linuxfoundation.org,
        badhri@google.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: xhci: Check endpoint is valid before
 dereferencing it
Message-ID: <Y6Qc1p4saGFTdh9n@lenoch>
References: <20221222072912.1843384-1-hhhuuu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222072912.1843384-1-hhhuuu@google.com>
X-CMAE-Envelope: MS4wfNO5x+DpKZwbW3lurs1sQhgUPIy+dj7ucKhBRqyEPreFzT3p9wNPofvA00eN4H/tcs8ydYqz5iIEZ71vt1eLaXu0WWa/enj7rgwRjpowbQt2RTSa3Ues
 YGtWSsfYnpDSy+qitDo63FZ4CZjII3PYG6Pv4eoe0rtqB5dAFjzyc9tzUV/gv/aLhyKMSHlEI9nu4VvOVSBXUzYfBoZddAHy6tTFgsAVuuMCtOEtugRzHHWb
 QtBPQOwXUE9r0Qk7Wu5eL84fyhZ2yHdCrTWu/hNks9USiAlyByN8mik3s1efnXAfyv5dYr//CPwcdkLbP+Ohjwn3V1paC5gJHPs/AFXwAIwBn/m2x+YaOyhH
 aJ786keQe8H+mjR+sDWirXH+eeTEiQ==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 07:29:12AM +0000, Jimmy Hu wrote:
> When the host controller is not responding, all URBs queued to all
> endpoints need to be killed. This can cause a kernel panic if we
> dereference an invalid endpoint.
> 
> Fix this by using xhci_get_virt_ep() helper to find the endpoint and
> checking if the endpoint is valid before dereferencing it.
> 
> [233311.853271] xhci-hcd xhci-hcd.1.auto: xHCI host controller not responding, assume dead
> [233311.853393] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000e8
> 
> [233311.853964] pc : xhci_hc_died+0x10c/0x270
> [233311.853971] lr : xhci_hc_died+0x1ac/0x270
> 
> [233311.854077] Call trace:
> [233311.854085]  xhci_hc_died+0x10c/0x270
> [233311.854093]  xhci_stop_endpoint_command_watchdog+0x100/0x1a4
> [233311.854105]  call_timer_fn+0x50/0x2d4
> [233311.854112]  expire_timers+0xac/0x2e4
> [233311.854118]  run_timer_softirq+0x300/0xabc
> [233311.854127]  __do_softirq+0x148/0x528
> [233311.854135]  irq_exit+0x194/0x1a8
> [233311.854143]  __handle_domain_irq+0x164/0x1d0
> [233311.854149]  gic_handle_irq.22273+0x10c/0x188
> [233311.854156]  el1_irq+0xfc/0x1a8
> [233311.854175]  lpm_cpuidle_enter+0x25c/0x418 [msm_pm]
> [233311.854185]  cpuidle_enter_state+0x1f0/0x764
> [233311.854194]  do_idle+0x594/0x6ac
> [233311.854201]  cpu_startup_entry+0x7c/0x80
> [233311.854209]  secondary_start_kernel+0x170/0x198
> 
> Fixes: 50e8725e7c42 ("xhci: Refactor command watchdog and fix split string.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jimmy Hu <hhhuuu@google.com>
> ---
>  drivers/usb/host/xhci-ring.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index ddc30037f9ce..f5b0e1ce22af 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -1169,7 +1169,10 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
>  	struct xhci_virt_ep *ep;
>  	struct xhci_ring *ring;
>  
> -	ep = &xhci->devs[slot_id]->eps[ep_index];
> +	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
> +	if (!ep)
> +		return;
> +

xhci_get_virt_ep also adds check for slot_id == 0. It changes behaviour,
do we really want to skip that slot? Original code went from 0 to
MAX_HC_SLOTS-1.

It seems to be off by one to me. Am I missing anything?
Also, what about passing ep directly to xhci_kill_endpoint_urbs
and do the check in xhci_hc_died? Not even compile tested:

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index ddc30037f9ce..5dac483c562a 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1162,14 +1162,12 @@ static void xhci_kill_ring_urbs(struct xhci_hcd *xhci, struct xhci_ring *ring)
 }
 
 static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
-		int slot_id, int ep_index)
+		struct xhci_virt_ep *ep)
 {
 	struct xhci_td *cur_td;
 	struct xhci_td *tmp;
-	struct xhci_virt_ep *ep;
 	struct xhci_ring *ring;
 
-	ep = &xhci->devs[slot_id]->eps[ep_index];
 	if ((ep->ep_state & EP_HAS_STREAMS) ||
 			(ep->ep_state & EP_GETTING_NO_STREAMS)) {
 		int stream_id;
@@ -1180,18 +1178,12 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
 			if (!ring)
 				continue;
 
-			xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
-					"Killing URBs for slot ID %u, ep index %u, stream %u",
-					slot_id, ep_index, stream_id);
 			xhci_kill_ring_urbs(xhci, ring);
 		}
 	} else {
 		ring = ep->ring;
 		if (!ring)
 			return;
-		xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
-				"Killing URBs for slot ID %u, ep index %u",
-				slot_id, ep_index);
 		xhci_kill_ring_urbs(xhci, ring);
 	}
 
@@ -1217,6 +1209,7 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
 void xhci_hc_died(struct xhci_hcd *xhci)
 {
 	int i, j;
+	struct xhci_virt_ep *ep;
 
 	if (xhci->xhc_state & XHCI_STATE_DYING)
 		return;
@@ -1227,11 +1220,14 @@ void xhci_hc_died(struct xhci_hcd *xhci)
 	xhci_cleanup_command_queue(xhci);
 
 	/* return any pending urbs, remove may be waiting for them */
-	for (i = 0; i <= HCS_MAX_SLOTS(xhci->hcs_params1); i++) {
+	for (i = 0; i < HCS_MAX_SLOTS(xhci->hcs_params1); i++) {
 		if (!xhci->devs[i])
 			continue;
-		for (j = 0; j < 31; j++)
-			xhci_kill_endpoint_urbs(xhci, i, j);
+		for (j = 0; j < EP_CTX_PER_DEV; j++) {
+			ep = &xhci->devs[i]->eps[j];
+			if (ep)
+				xhci_kill_endpoint_urbs(xhci, ep);
+		}
 	}
 
 	/* inform usb core hc died if PCI remove isn't already handling it */
>  	if ((ep->ep_state & EP_HAS_STREAMS) ||
>  			(ep->ep_state & EP_GETTING_NO_STREAMS)) {
>  		int stream_id;
> -- 
> 2.39.0.314.g84b9a713c41-goog
