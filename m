Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0480D7A425
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 11:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfG3J3X convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 30 Jul 2019 05:29:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:27888 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbfG3J3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 05:29:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jul 2019 02:29:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,326,1559545200"; 
   d="scan'208";a="165791932"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga008.jf.intel.com with ESMTP; 30 Jul 2019 02:29:22 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 30 Jul 2019 02:29:21 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 02:29:21 -0700
Received: from BGSMSX108.gar.corp.intel.com (10.223.4.192) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 02:29:20 -0700
Received: from bgsmsx104.gar.corp.intel.com ([169.254.5.156]) by
 BGSMSX108.gar.corp.intel.com ([169.254.8.155]) with mapi id 14.03.0439.000;
 Tue, 30 Jul 2019 14:59:18 +0530
From:   "Gopal, Saranya" <saranya.gopal@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Yang, Fei" <fei.yang@intel.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: RE: [PATCH 4.19.y 0/3] usb: dwc3: Prevent requests from being
 queued twice
Thread-Topic: [PATCH 4.19.y 0/3] usb: dwc3: Prevent requests from being
 queued twice
Thread-Index: AQHVRhOUnK9XeBaQ9UCn6YgdpRfpLKbhf2KAgAFlo/A=
Date:   Tue, 30 Jul 2019 09:29:18 +0000
Message-ID: <C672AA6DAAC36042A98BAD0B0B25BDA94CC83271@BGSMSX104.gar.corp.intel.com>
References: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
 <20190729173427.GA19326@kroah.com>
In-Reply-To: <20190729173427.GA19326@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZTYyZDU5MWQtNWIxZi00MmI4LTgxM2UtMzJhN2IwYzM5OTdhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVlZUcjlzOVV2djJUWFI4TUF4XC9aTXpYR3huVFF1eXlwcjVOK1ZEazJwVmFIUzRFZjVzTmk3YkJscWxZWWZVem8ifQ==
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Mon, Jul 29, 2019 at 07:13:36PM +0530, Saranya Gopal wrote:
> > With recent changes in AOSP, adb is now using asynchronous I/O.
> > While adb works good for the most part, there have been issues with
> > adb root/unroot commands which cause adb hang. The issue is caused
> > by a request being queued twice. A series of 3 patches from
> > Felipe Balbi in upstream tree fixes this issue.
> >
> > Felipe Balbi (3):
> >   usb: dwc3: gadget: add dwc3_request status tracking
> >   usb: dwc3: gadget: prevent dwc3_request from being queued twice
> >   usb: dwc3: gadget: remove req->started flag
> 
> I would like to get an ack from Felipe before I take these.
> 
> thanks,
> 
> greg k-h

I just realized that I had been testing this patch series with the flag to enable async IO on adb disabled!
It requires a few more patches on top for adb to work properly in async IO mode.
It has been working reliably in our internal tree for some time.
Let me resubmit the whole series after getting it reviewed by Felipe.

Thanks,
Saranya
