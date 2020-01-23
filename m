Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6824F1470BF
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 19:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAWS3C convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 Jan 2020 13:29:02 -0500
Received: from mga04.intel.com ([192.55.52.120]:43749 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbgAWS3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 13:29:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 10:29:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="216341610"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga007.jf.intel.com with ESMTP; 23 Jan 2020 10:29:00 -0800
Received: from orsmsx102.amr.corp.intel.com ([169.254.3.100]) by
 ORSMSX109.amr.corp.intel.com ([169.254.11.6]) with mapi id 14.03.0439.000;
 Thu, 23 Jan 2020 10:29:00 -0800
From:   "Yang, Fei" <fei.yang@intel.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
CC:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        "Jack Pham" <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: RE: [RFC][PATCH 0/2] Avoiding DWC3 transfer stalls/hangs when using
 adb over f_fs
Thread-Topic: [RFC][PATCH 0/2] Avoiding DWC3 transfer stalls/hangs when
 using adb over f_fs
Thread-Index: AQHV0XMMcRoryuKxgUWuu9vXC1fi/6f4daqA///7ALCAAJiOAP//ee5QgACKP4D//31cgA==
Date:   Thu, 23 Jan 2020 18:28:59 +0000
Message-ID: <02E7334B1630744CBDC55DA8586225837F9EE3C0@ORSMSX102.amr.corp.intel.com>
References: <20200122222645.38805-1-john.stultz@linaro.org>
 <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com>
 <02E7334B1630744CBDC55DA8586225837F9EE280@ORSMSX102.amr.corp.intel.com>
 <87o8uu3wqd.fsf@kernel.org>
 <02E7334B1630744CBDC55DA8586225837F9EE335@ORSMSX102.amr.corp.intel.com>
 <87lfpy3w1g.fsf@kernel.org>
In-Reply-To: <87lfpy3w1g.fsf@kernel.org>
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

>>>>>> Since ~4.20, when the functionfs gadget enabled scatter-gather 
>>>>>> support, we have seen problems with adb connections stalling and 
>>>>>> stopping to function on hardware with dwc3 usb controllers.
>>>>>> Specifically, HiKey960, Dragonboard 845c, and Pixel3 devices.
>>>>>
>>>>> Any chance this:
>>>>> 
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git/commi
>>>>> t/
>>>>> ?h=testing/next&id=f63333e8e4fd63d8d8ae83b89d2c38cf21d64801
>>>> This is a different issue. I have tried initializing num_sgs when debugging this adb stall problem, but it didn't help.
>>>
>>> So multiple folks have run through this problem, but not *one* has tracepoints collected from the issue? C'mon guys.
>>> Can someone, please, collect tracepoints so we can figure out what's actually going on?
>>>
>>> I'm pretty sure this should be solved at the DMA API level, just want to confirm.
>>
>> I have sent you the tracepoints long time ago. Also my analysis of the 
>> problem (BTW, I don't think the tracepoints helped much). It's 
>> basically a logic problem in function dwc3_gadget_ep_reclaim_trb_sg().
>
> AFAICT, this is caused by DMA API merging pages together when map an sglist for DMA. While doing that,
> it does *not* move the SG_END flag which sg_is_last() checks.
>
> I consider that an overlook on the DMA API, wouldn't you? Why should DMA API users care if pages were merged or not while mapping the sglist?
> We have for_each_sg() and sg_is_last() for a reason.

Oops, my bad. Actually, I was talking about the other patch, not the one setting num_sgs = 0; I don't know if this patch is really needed, but from
what I remember the DMA API is setting up the num_sgs properly. I agree even if there is a problem initializing num_sgs, it should be fixed in DMA API.

> I can try dig into my old emails and resend, but that is a bit hard to find.
>
> Don't bother, I'm still not convinced we should fix at the driver level when sg_is_last() should be working here,
> unless we should iterate over num_sgs instead of num_mapped_sgs, though I don't think that's the case since
> in that case we would have to chain buffers of size zero.

> --
> balbi
