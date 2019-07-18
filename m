Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6C0A6CB4D
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 10:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfGRIzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 04:55:19 -0400
Received: from mga18.intel.com ([134.134.136.126]:55684 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfGRIzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 04:55:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 01:55:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="366852128"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jul 2019 01:55:15 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     fei.yang@intel.com, john.stultz@linaro.org,
        andrzej.p@collabora.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] usb: dwc3: gadget: trb_dequeue is not updated properly
In-Reply-To: <1563396788-126034-1-git-send-email-fei.yang@intel.com>
References: <1563396788-126034-1-git-send-email-fei.yang@intel.com>
Date:   Thu, 18 Jul 2019 11:55:14 +0300
Message-ID: <87o91riux9.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

Let's look at the relevant code:

fei.yang@intel.com writes:

> From: Fei Yang <fei.yang@intel.com>
>
> If scatter-gather operation is allowed, a large USB request would be split
> into multiple TRBs. These TRBs are chained up by setting DWC3_TRB_CTRL_CHN
> bit except the last one which has DWC3_TRB_CTRL_IOC bit set instead.
> Since only the last TRB has IOC set, dwc3_gadget_ep_reclaim_completed_trb()
> would be called only once for the whole USB request, thus all the TRBs need
> to be reclaimed within this single call. However that is not what the current
> code does.
>
> This patch addresses the issue by checking each TRB in function
> dwc3_gadget_ep_reclaim_trb_sg() and reclaiming the chained ones right there.
> Only the last TRB gets passed to dwc3_gadget_ep_reclaim_completed_trb(). This
> would guarantee all TRBs are reclaimed and trb_dequeue/num_trbs are updated
> properly.
>
> Signed-off-by: Fei Yang <fei.yang@intel.com>
> Cc: stable <stable@vger.kernel.org>
> ---
>
> V2: Better solution is to reclaim chained TRBs in dwc3_gadget_ep_reclaim_trb_sg()
>     and leave the last TRB to the dwc3_gadget_ep_reclaim_completed_trb().
>
> ---
>
>  drivers/usb/dwc3/gadget.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 173f532..c0662c2 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2404,7 +2404,7 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
>  		struct dwc3_request *req, const struct dwc3_event_depevt *event,
>  		int status)

Here's the full function:

| static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
| 		struct dwc3_request *req, const struct dwc3_event_depevt *event,
| 		int status)
| {
| 	struct dwc3_trb *trb = &dep->trb_pool[dep->trb_dequeue];
| 	struct scatterlist *sg = req->sg;
| 	struct scatterlist *s;
| 	unsigned int pending = req->num_pending_sgs;
| 	unsigned int i;
| 	int ret = 0;
| 
| 	for_each_sg(sg, s, pending, i) {

iterate over each scatterlist member for the current request...

| 		trb = &dep->trb_pool[dep->trb_dequeue];
| 
| 		if (trb->ctrl & DWC3_TRB_CTRL_HWO)
| 			break;
| 
| 		req->sg = sg_next(s);
| 		req->num_pending_sgs--;
| 
| 		ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
| 				trb, event, status, true);

... and reclaim its TRB.

Now, looking dwc3_gadget_ep_reclaim_compmleted_trb() we have:

| static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
| 		struct dwc3_request *req, struct dwc3_trb *trb,
| 		const struct dwc3_event_depevt *event, int status, int chain)
| {
| 	unsigned int		count;
| 
| 	dwc3_ep_inc_deq(dep);

unconditionally increment the dequeue pointer. What Are we missing here?

[...]

| 	return 0;
| }


Now, looking at what your patch does we will have:

>  {
> -	struct dwc3_trb *trb = &dep->trb_pool[dep->trb_dequeue];
> +	struct dwc3_trb *trb;

small cleanup, should be part of its own patch.

>  	struct scatterlist *sg = req->sg;
>  	struct scatterlist *s;
>  	unsigned int pending = req->num_pending_sgs;
> @@ -2419,7 +2419,15 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
>  
>  		req->sg = sg_next(s);
>  		req->num_pending_sgs--;
> +		if (!(trb->ctrl & DWC3_TRB_CTRL_IOC)) {
> +			/* reclaim the TRB without calling
> +			 * dwc3_gadget_ep_reclaim_completed_trb */

why do you have to skip dwc3_gadget_ep_reclaim_completed_trb()? Also,
your patch description claims that we're NOT incrementing the TRBs,
which is wrong. I fail to see what problem you're trying to solve here,
really.

Could it be that we're, simply. returning 1 when we should return 0 for
the previous SG list members? If that's the case, then that's the bug
that should be fixed. Still, you shouldn't avoid calling
dwc3_gadget_ep_reclaim_completed_trb() and should, instead, fix the bug
it contains.

Looking at the cases where dwc3_gadget_ep_reclaim_completed_trb()
returns 1, I can't see how that would be the case either:

| 	if (chain && (trb->ctrl & DWC3_TRB_CTRL_HWO))
| 		trb->ctrl &= ~DWC3_TRB_CTRL_HWO;

if CHN bit it set and HWO is bit, clear HWO

| 	if (req->needs_extra_trb && !(trb->ctrl & DWC3_TRB_CTRL_CHN)) {
| 		trb->ctrl &= ~DWC3_TRB_CTRL_HWO;
| 		return 1;
| 	}

if *not* CHN and needs_extra_trb, return 1. This can only be true for
the last TRB in the SG list.

| 	if ((trb->ctrl & DWC3_TRB_CTRL_HWO) && status != -ESHUTDOWN)
| 		return 1;

This can't be true because we cleared HWO up above

| 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
| 		return 1;

can only be true for last TRB

| 	if (event->status & DEPEVT_STATUS_IOC)
| 		return 1;

If we have a short packet, then we may fall here. Is that the case?

Please share dwc3 tracepoints of the problem happening so I can verify
what's going on.

-- 
balbi
