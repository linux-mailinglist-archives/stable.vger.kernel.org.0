Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FED791C2
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 19:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfG2RGS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Jul 2019 13:06:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:2632 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726601AbfG2RGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 13:06:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 10:06:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,323,1559545200"; 
   d="scan'208";a="173292464"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jul 2019 10:06:17 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jul 2019 10:06:17 -0700
Received: from bgsmsx101.gar.corp.intel.com (10.223.4.170) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jul 2019 10:06:16 -0700
Received: from bgsmsx104.gar.corp.intel.com ([169.254.5.156]) by
 BGSMSX101.gar.corp.intel.com ([169.254.1.46]) with mapi id 14.03.0439.000;
 Mon, 29 Jul 2019 22:36:14 +0530
From:   "Gopal, Saranya" <saranya.gopal@intel.com>
To:     Greg KH <greg@kroah.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Yang, Fei" <fei.yang@intel.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: RE: [PATCH 4.19.y 2/3] usb: dwc3: gadget: prevent dwc3_request from
 being queued twice
Thread-Topic: [PATCH 4.19.y 2/3] usb: dwc3: gadget: prevent dwc3_request
 from being queued twice
Thread-Index: AQHVRhOd0wLOey82WUq9uiBgYgUVXabhdN6AgABdFgA=
Date:   Mon, 29 Jul 2019 17:06:13 +0000
Message-ID: <C672AA6DAAC36042A98BAD0B0B25BDA94CC82DDD@BGSMSX104.gar.corp.intel.com>
References: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
 <1564407819-10746-3-git-send-email-saranya.gopal@intel.com>
 <20190729165649.GB14160@kroah.com>
In-Reply-To: <20190729165649.GB14160@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMGQ5MDcwMDUtMGY4YS00NGUyLTlkOTctNDg1MjhhZWNiZTgzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoib2YrUGVcL29rZW9sTkFWWGcybnM3b0hqUW1lUkZIZ1RpZFhveGlpUWNUZ2dPblFVUW9nem5vZ2s3QkZJN1dtRDYifQ==
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Mon, Jul 29, 2019 at 07:13:38PM +0530, Saranya Gopal wrote:
> > From: Felipe Balbi <felipe.balbi@linux.intel.com>
> >
> > [Upstream commit b2b6d601365a1acb90b87c85197d79]
> >
> > Queueing the same request twice can introduce hard-to-debug
> > problems. At least one function driver - Android's f_mtp.c - is known
> > to cause this problem.
> >
> > While that function is out-of-tree, this is a problem that's easy
> > enough to avoid.
> >
> > Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> > Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
> > ---
> >  drivers/usb/dwc3/gadget.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index 3f337a0..a56a92a 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -1291,6 +1291,11 @@ static int __dwc3_gadget_ep_queue(struct
> dwc3_ep *dep, struct dwc3_request *req)
> >  				&req->request, req->dep->name))
> >  		return -EINVAL;
> >
> > +	if (WARN(req->status < DWC3_REQUEST_STATUS_COMPLETED,
> > +				"%s: request %pK already in flight\n",
> > +				dep->name, &req->request))
> > +		return -EINVAL;
> 
> So we are going to trip syzbot up on this out-of-tree driver?  Brave...

I had retained the commit message from the upstream commit.
However, without this patch, I see issues with adb as well.
Adb will hang after adb root/unroot command and needs a reboot to recover.

Thanks,
Saranya
