Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01662146FD9
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 18:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgAWRhQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 Jan 2020 12:37:16 -0500
Received: from mga12.intel.com ([192.55.52.136]:37819 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgAWRhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 12:37:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 09:37:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="307888607"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga001.jf.intel.com with ESMTP; 23 Jan 2020 09:37:15 -0800
Received: from orsmsx162.amr.corp.intel.com (10.22.240.85) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jan 2020 09:37:14 -0800
Received: from orsmsx102.amr.corp.intel.com ([169.254.3.100]) by
 ORSMSX162.amr.corp.intel.com ([169.254.3.134]) with mapi id 14.03.0439.000;
 Thu, 23 Jan 2020 09:37:14 -0800
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
Thread-Index: AQHV0XMMcRoryuKxgUWuu9vXC1fi/6f4daqA///7ALCAAJiOAP//ee5Q
Date:   Thu, 23 Jan 2020 17:37:14 +0000
Message-ID: <02E7334B1630744CBDC55DA8586225837F9EE335@ORSMSX102.amr.corp.intel.com>
References: <20200122222645.38805-1-john.stultz@linaro.org>
 <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com>
 <02E7334B1630744CBDC55DA8586225837F9EE280@ORSMSX102.amr.corp.intel.com>
 <87o8uu3wqd.fsf@kernel.org>
In-Reply-To: <87o8uu3wqd.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>>> Hey all,
>>>>    I wanted to send these out for comment and thoughts.
>>>> 
>>>> Since ~4.20, when the functionfs gadget enabled scatter-gather 
>>>> support, we have seen problems with adb connections stalling and 
>>>> stopping to function on hardware with dwc3 usb controllers.
>>>> Specifically, HiKey960, Dragonboard 845c, and Pixel3 devices.
>>>
>>> Any chance this:
>>> 
>>> https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git/commit/
>>> ?h=testing/next&id=f63333e8e4fd63d8d8ae83b89d2c38cf21d64801
>> This is a different issue. I have tried initializing num_sgs when debugging this adb stall problem, but it didn't help.
>
> So multiple folks have run through this problem, but not *one* has tracepoints collected from the issue? C'mon guys. Can someone, please, collect tracepoints so we can figure out what's actually going on?
>
> I'm pretty sure this should be solved at the DMA API level, just want to confirm.
I have sent you the tracepoints long time ago. Also my analysis of the problem (BTW, I don't think the tracepoints helped much). It's basically a logic problem in function dwc3_gadget_ep_reclaim_trb_sg().
I can try dig into my old emails and resend, but that is a bit hard to find.

-Fei 
