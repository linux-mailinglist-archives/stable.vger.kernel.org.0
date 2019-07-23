Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB35171FAA
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 20:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391591AbfGWSxP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 23 Jul 2019 14:53:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:41103 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbfGWSxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 14:53:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 11:53:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,300,1559545200"; 
   d="scan'208";a="180829860"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga002.jf.intel.com with ESMTP; 23 Jul 2019 11:53:14 -0700
Received: from orsmsx112.amr.corp.intel.com (10.22.240.13) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 23 Jul 2019 11:53:14 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.29]) by
 ORSMSX112.amr.corp.intel.com ([169.254.3.253]) with mapi id 14.03.0439.000;
 Tue, 23 Jul 2019 11:53:14 -0700
From:   "Yang, Fei" <fei.yang@intel.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "andrzej.p@collabora.com" <andrzej.p@collabora.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3] usb: dwc3: gadget: trb_dequeue is not updated
 properly
Thread-Topic: [PATCH v3] usb: dwc3: gadget: trb_dequeue is not updated
 properly
Thread-Index: AQHVPgQR482iA1i8Sk2wptVdWd1tF6bYj1lg
Date:   Tue, 23 Jul 2019 18:53:13 +0000
Message-ID: <02E7334B1630744CBDC55DA8586225837F8E94AC@ORSMSX103.amr.corp.intel.com>
References: <1563497183-7114-1-git-send-email-fei.yang@intel.com>
 <87k1cescnc.fsf@linux.intel.com>
In-Reply-To: <87k1cescnc.fsf@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMGZlNTUxYTctMDE1Ni00MjQyLWFjOTEtY2M5ZjBiYzU3YzVhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiREhrRWRSYjdoaUpJc0h2QzhsMnF5WjljUFNCMkRSbWxlZzhrS2FCOE56bEMwU2FiNTFBZ1NmN2tScEFzZDQrdiJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c 
>> index 173f532..88eed49 100644
>> --- a/drivers/usb/dwc3/gadget.c
>> +++ b/drivers/usb/dwc3/gadget.c
>> @@ -2394,7 +2394,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
>>  	if (event->status & DEPEVT_STATUS_SHORT && !chain)
>>  		return 1;
>>  
>> -	if (event->status & DEPEVT_STATUS_IOC)
>> +	if (event->status & DEPEVT_STATUS_IOC && !chain)
>>  		return 1;
>
> This will break the situation when we have more SGs than available TRBs. In that case we set IOC before the last so we have time to update transfer to append more TRBs.
What's your opinion on https://patchwork.kernel.org/patch/10640137/? Checking condition "(event->status & DEPEVT_STATUS_IOC) && (trb->ctrl & DWC3_TRB_CTRL_IOC)"
won't cause problem handling TRB shortage cases, right?

> Please, send me tracepoints
I sent you the tracepoints last Friday, any new findings?

