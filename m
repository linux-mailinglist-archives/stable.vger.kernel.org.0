Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E1265408C
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 13:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbiLVMAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 07:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235851AbiLVL7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 06:59:51 -0500
Received: from h1.cmg1.smtp.forpsi.com (h1.cmg1.smtp.forpsi.com [81.2.195.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E8628E35
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 03:52:47 -0800 (PST)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id 8K7upCdRiPm6C8K7vpse0e; Thu, 22 Dec 2022 12:52:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1671709965; bh=twWdlUqcKW0gGIitOgkYeaXqXJJfP64QiolpNOKNhQ8=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=PFPWwZzOmoL6XeRnLW08mp2rd5Q69RSpmb/YZFubdSoMw3NcLGLAKIRPHky6vOFlN
         2rIpPmEQLNCn2afEWiV/TgvpfUPH2j8gCHa+FQg5wSKeMeAQ2/Ee2lNnLAZSouEx6J
         mtHsMyA0LvP/UENPYEtnBVn+KalFpwYJvHodOk2HIhNlTBeXPKUY6GLmtuRiTIVTj8
         UQAj39NfB4FhPDOkFtUDN9B6TuqY8zR1lSj1Cq/D6QebDJK9eMSzoRPcz34LjQ6amK
         uh4+9v2qTEP7E9oO2rRW1KQqAPPwBS9tP7hAiX885abYmtS042L5Tq6sqybIGL2QG0
         UYPUWnaj0N4HQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1671709965; bh=twWdlUqcKW0gGIitOgkYeaXqXJJfP64QiolpNOKNhQ8=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=PFPWwZzOmoL6XeRnLW08mp2rd5Q69RSpmb/YZFubdSoMw3NcLGLAKIRPHky6vOFlN
         2rIpPmEQLNCn2afEWiV/TgvpfUPH2j8gCHa+FQg5wSKeMeAQ2/Ee2lNnLAZSouEx6J
         mtHsMyA0LvP/UENPYEtnBVn+KalFpwYJvHodOk2HIhNlTBeXPKUY6GLmtuRiTIVTj8
         UQAj39NfB4FhPDOkFtUDN9B6TuqY8zR1lSj1Cq/D6QebDJK9eMSzoRPcz34LjQ6amK
         uh4+9v2qTEP7E9oO2rRW1KQqAPPwBS9tP7hAiX885abYmtS042L5Tq6sqybIGL2QG0
         UYPUWnaj0N4HQ==
Date:   Thu, 22 Dec 2022 12:52:42 +0100
From:   Ladislav Michl <oss-lists@triops.cz>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     Jimmy Hu <hhhuuu@google.com>, mathias.nyman@intel.com,
        gregkh@linuxfoundation.org, badhri@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: xhci: Check endpoint is valid before
 dereferencing it
Message-ID: <Y6RFCjbMswOBoKdV@lenoch>
References: <20221222072912.1843384-1-hhhuuu@google.com>
 <Y6Qc1p4saGFTdh9n@lenoch>
 <23fe0fe3-f330-b58e-c366-3ac5bd80fe22@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23fe0fe3-f330-b58e-c366-3ac5bd80fe22@linux.intel.com>
X-CMAE-Envelope: MS4wfBl8JSfdoQmD2sn0ZnFz7aja4Ft0iQkxA5tUDRdMddvEvPUAfRWHE90ENDAQMoil1AUbEp0V2GF+VMCfQYRVetnn+MfFS//Z0gZiT1Vp+Erug3NXHkww
 UpUPXjrJ78Vo9LZZM+Z+d0OdsibCcsJt8sMXKuLR9Wz60yx+l0+EnDDf8Wmto9D6psyMSKZB/Sj7vNYtyyzHbOcknfoqhjzi2CBKOP75t7/eHWOD2Tu3pTFe
 5H5npGjZ+t0ObVY9t0nv5/XDl+UgsxLYBgB2+dcizIjGNxzEcZykpW9sBA7f/v0i7XNCT9eMh0tIcqgGFsljv8BF6s3UTNy66m6YYvDAnKhMot39lOPNX2eP
 dCjw7Vw4NovH75rET22evU9gsrlHx/rPILpNN/qdF0WLf+Zuovi876HltbSyxf+6bmSJnMkO
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 01:08:47PM +0200, Mathias Nyman wrote:
> On 22.12.2022 11.01, Ladislav Michl wrote:
> > On Thu, Dec 22, 2022 at 07:29:12AM +0000, Jimmy Hu wrote:
> > > When the host controller is not responding, all URBs queued to all
> > > endpoints need to be killed. This can cause a kernel panic if we
> > > dereference an invalid endpoint.
> > > 
> > > Fix this by using xhci_get_virt_ep() helper to find the endpoint and
> > > checking if the endpoint is valid before dereferencing it.
> > > 
> > > [233311.853271] xhci-hcd xhci-hcd.1.auto: xHCI host controller not responding, assume dead
> > > [233311.853393] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000e8
> > > 
> > > [233311.853964] pc : xhci_hc_died+0x10c/0x270
> > > [233311.853971] lr : xhci_hc_died+0x1ac/0x270
> > > 
> > > [233311.854077] Call trace:
> > > [233311.854085]  xhci_hc_died+0x10c/0x270
> > > [233311.854093]  xhci_stop_endpoint_command_watchdog+0x100/0x1a4
> > > [233311.854105]  call_timer_fn+0x50/0x2d4
> > > [233311.854112]  expire_timers+0xac/0x2e4
> > > [233311.854118]  run_timer_softirq+0x300/0xabc
> > > [233311.854127]  __do_softirq+0x148/0x528
> > > [233311.854135]  irq_exit+0x194/0x1a8
> > > [233311.854143]  __handle_domain_irq+0x164/0x1d0
> > > [233311.854149]  gic_handle_irq.22273+0x10c/0x188
> > > [233311.854156]  el1_irq+0xfc/0x1a8
> > > [233311.854175]  lpm_cpuidle_enter+0x25c/0x418 [msm_pm]
> > > [233311.854185]  cpuidle_enter_state+0x1f0/0x764
> > > [233311.854194]  do_idle+0x594/0x6ac
> > > [233311.854201]  cpu_startup_entry+0x7c/0x80
> > > [233311.854209]  secondary_start_kernel+0x170/0x198
> > > 
> > > Fixes: 50e8725e7c42 ("xhci: Refactor command watchdog and fix split string.")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Jimmy Hu <hhhuuu@google.com>
> > > ---
> > >   drivers/usb/host/xhci-ring.c | 5 ++++-
> > >   1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> > > index ddc30037f9ce..f5b0e1ce22af 100644
> > > --- a/drivers/usb/host/xhci-ring.c
> > > +++ b/drivers/usb/host/xhci-ring.c
> > > @@ -1169,7 +1169,10 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
> > >   	struct xhci_virt_ep *ep;
> > >   	struct xhci_ring *ring;
> > > -	ep = &xhci->devs[slot_id]->eps[ep_index];
> > > +	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
> > > +	if (!ep)
> > > +		return;
> > > +
> > 
> > xhci_get_virt_ep also adds check for slot_id == 0. It changes behaviour,
> > do we really want to skip that slot? Original code went from 0 to
> > MAX_HC_SLOTS-1.
> > 
> > It seems to be off by one to me. Am I missing anything?
> 
> slot_id 0 is always invalid, so this is a good change.

I see. Now reading more carefully:
#define HCS_MAX_SLOTS(p)	(((p) >> 0) & 0xff)
#define MAX_HC_SLOTS		256
So the loop should go:
	for (i = 1; i <= HCS_MAX_SLOTS(xhci->hcs_params1); i++)

> > Also, what about passing ep directly to xhci_kill_endpoint_urbs
> > and do the check in xhci_hc_died? Not even compile tested:
> 
> passing ep to a function named kill_endpoint_urbs() sound like the
> right thing to do, but as a generic change.
> 
> I think its a good idea to first do a targeted fix for this null pointer
> issue that we can send to stable fist.

Agree. But I still do not understand the root cause. There is a check
for NULL xhci->devs[i] already, so patch does not add much more, except
for test for slot_id == 0. And the eps array is just array of
struct xhci_virt_ep, not a pointers to them, so &xhci->devs[i]->eps[j]
should be always valid pointer. However struct xhci_ring in each eps
is allocated and not protected by any lock here. Is that correct?

> > diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> > index ddc30037f9ce..5dac483c562a 100644
> > --- a/drivers/usb/host/xhci-ring.c
> > +++ b/drivers/usb/host/xhci-ring.c
> > @@ -1162,14 +1162,12 @@ static void xhci_kill_ring_urbs(struct xhci_hcd *xhci, struct xhci_ring *ring)
> >   }
> >   static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
> > -		int slot_id, int ep_index)
> > +		struct xhci_virt_ep *ep)
> >   {
> >   	struct xhci_td *cur_td;
> >   	struct xhci_td *tmp;
> > -	struct xhci_virt_ep *ep;
> >   	struct xhci_ring *ring;
> > -	ep = &xhci->devs[slot_id]->eps[ep_index];
> >   	if ((ep->ep_state & EP_HAS_STREAMS) ||
> >   			(ep->ep_state & EP_GETTING_NO_STREAMS)) {
> >   		int stream_id;
> > @@ -1180,18 +1178,12 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
> >   			if (!ring)
> >   				continue;
> > -			xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
> > -					"Killing URBs for slot ID %u, ep index %u, stream %u",
> > -					slot_id, ep_index, stream_id);
> >   			xhci_kill_ring_urbs(xhci, ring);
> >   		}
> >   	} else {
> >   		ring = ep->ring;
> >   		if (!ring)
> >   			return;
> > -		xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
> > -				"Killing URBs for slot ID %u, ep index %u",
> > -				slot_id, ep_index);
> >   		xhci_kill_ring_urbs(xhci, ring);
> >   	}
> > @@ -1217,6 +1209,7 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
> >   void xhci_hc_died(struct xhci_hcd *xhci)
> >   {
> >   	int i, j;
> > +	struct xhci_virt_ep *ep;
> >   	if (xhci->xhc_state & XHCI_STATE_DYING)
> >   		return;
> > @@ -1227,11 +1220,14 @@ void xhci_hc_died(struct xhci_hcd *xhci)
> >   	xhci_cleanup_command_queue(xhci);
> >   	/* return any pending urbs, remove may be waiting for them */
> > -	for (i = 0; i <= HCS_MAX_SLOTS(xhci->hcs_params1); i++) {
> > +	for (i = 0; i < HCS_MAX_SLOTS(xhci->hcs_params1); i++) {
> >   		if (!xhci->devs[i])
> >   			continue;
> > -		for (j = 0; j < 31; j++)
> > -			xhci_kill_endpoint_urbs(xhci, i, j);
> > +		for (j = 0; j < EP_CTX_PER_DEV; j++) {
> > +			ep = &xhci->devs[i]->eps[j];
> > +			if (ep)
> > +				xhci_kill_endpoint_urbs(xhci, ep);
> > +		}
> 
> This does loop a bit more than the existing code.
> With this change its always HCS_MAX_SLOTS * EP_CTX_PER_DEV.
> Previously best case was just HCS_MAX_SLOTS.

No, that's just the same:
#define EP_CTX_PER_DEV		31
to make clear where that 31 come from. Taken into acount your comment
above, the loop should be
	for (i = 1; i <= HCS_MAX_SLOTS(xhci->hcs_params1); i++) ...
		for (j = 0; j < EP_CTX_PER_DEV; j++) ...

	ladis
