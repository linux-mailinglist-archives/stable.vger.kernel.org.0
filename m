Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03ACA147133
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 19:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgAWSyR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 Jan 2020 13:54:17 -0500
Received: from mga05.intel.com ([192.55.52.43]:59071 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727590AbgAWSyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 13:54:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 10:54:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="221697238"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jan 2020 10:54:15 -0800
Received: from orsmsx102.amr.corp.intel.com ([169.254.3.100]) by
 ORSMSX103.amr.corp.intel.com ([169.254.5.147]) with mapi id 14.03.0439.000;
 Thu, 23 Jan 2020 10:54:15 -0800
From:   "Yang, Fei" <fei.yang@intel.com>
To:     Felipe Balbi <balbi@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
CC:     Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        "Andrzej Pietrasiewicz" <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Linux USB List" <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        "John Stultz" <john.stultz@linaro.org>
Subject: RE: [RFC][PATCH 1/2] usb: dwc3: gadget: Check for IOC/LST bit in
 both event->status and TRB->ctrl fields
Thread-Topic: [RFC][PATCH 1/2] usb: dwc3: gadget: Check for IOC/LST bit in
 both event->status and TRB->ctrl fields
Thread-Index: AQHV0XMMDal2ka/y0kSxMT/Pi5VKVaf4X3SAgAA3SWA=
Date:   Thu, 23 Jan 2020 18:54:15 +0000
Message-ID: <02E7334B1630744CBDC55DA8586225837F9EE439@ORSMSX102.amr.corp.intel.com>
References: <20200122222645.38805-1-john.stultz@linaro.org>
 <20200122222645.38805-2-john.stultz@linaro.org> <87tv4m4ov2.fsf@kernel.org>
In-Reply-To: <87tv4m4ov2.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> The present code in dwc3_gadget_ep_reclaim_completed_trb() will check 
>> for IOC/LST bit in the event->status and returns if IOC/LST bit is 
>> set. This logic doesn't work if multiple TRBs are queued per request 
>> and the IOC/LST bit is set on the last TRB of that request.
>> Consider an example where a queued request has multiple queued TRBs 
>> and IOC/LST bit is set only for the last TRB. In this case, the Core 
>> generates XferComplete/XferInProgress events only for the last TRB 
>> (since IOC/LST are set only for the last TRB). As per the logic in
>> dwc3_gadget_ep_reclaim_completed_trb() event->status is checked for 
>> IOC/LST bit and returns on the first TRB. This makes the remaining 
>> TRBs left unhandled.
>> To aviod this, changed the code to check for IOC/LST bits in both
>     avoid
>
>> event->status & TRB->ctrl. This patch does the same.
>
> We don't need to check both. It's very likely that checking the TRB is enough.
>
>> At a practical level, this patch resolves USB transfer stalls seen 
>> with adb on dwc3 based HiKey960 after functionfs gadget added 
>> scatter-gather support around v4.20.
>
> Right, I remember asking for tracepoint data showing this problem happening. It's the best way to figure out what's really going on.
>
> Before we accept these two patches, could you collect dwc3 tracepoint data and share here?

I should have replied to this one. Sorry for the confusion on the other thread.
I have sent tracepoints long time ago for this problem, but the tracepoints did help much on debugging the issue, so I'm not going to send again.

But the problem is really obvious though. In function dwc3_gadget_ep_reclaim_trb_sg(), the for_each_sg loop doesn't get a chance to iterate through all TRBs in the sg list, because this function only gets called when the last TRB in the list is completed (because of setting IOC), so at this moment event->status has IOC bit set. The consequence is that, when the for_each_sg loop trying to reclaim the first TRB in the sg list, the call dwc3_gadget_ep_reclaim_completed_trb() returns 1 (if (event-status & DEPEVT_STATUS_IOC) return 1;), thus the for loop is terminated before the rest of the TRBs are reclaimed.

static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
                struct dwc3_request *req, const struct dwc3_event_depevt *event,
                int status)
{
        struct dwc3_trb *trb = &dep->trb_pool[dep->trb_dequeue];
        struct scatterlist *sg = req->sg;
        struct scatterlist *s;
        unsigned int pending = req->num_pending_sgs;
        unsigned int i;
        int ret = 0;

        for_each_sg(sg, s, pending, i) {
                trb = &dep->trb_pool[dep->trb_dequeue];

                if (trb->ctrl & DWC3_TRB_CTRL_HWO)
                        break;

                req->sg = sg_next(s);
                req->num_pending_sgs--;

                ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
                                trb, event, status, true);
                if (ret)
                        break;
        }

        return ret;
}
 
