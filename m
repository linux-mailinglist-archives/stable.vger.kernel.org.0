Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA21859832
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 12:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfF1KKp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 28 Jun 2019 06:10:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:11926 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfF1KKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 06:10:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 03:10:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,427,1557212400"; 
   d="scan'208";a="162927359"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga008.fm.intel.com with ESMTP; 28 Jun 2019 03:10:42 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 28 Jun 2019 03:10:42 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 03:10:42 -0700
Received: from bgsmsx151.gar.corp.intel.com (10.224.48.42) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 28 Jun 2019 03:10:41 -0700
Received: from bgsmsx104.gar.corp.intel.com ([169.254.5.212]) by
 BGSMSX151.gar.corp.intel.com ([169.254.3.51]) with mapi id 14.03.0439.000;
 Fri, 28 Jun 2019 15:40:39 +0530
From:   "Gopal, Saranya" <saranya.gopal@intel.com>
To:     John Stultz <john.stultz@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Yang, Fei" <fei.yang@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH 4.19.y 0/9] Fix scheduling while atomic in
 dwc3_gadget_ep_dequeue
Thread-Topic: [PATCH 4.19.y 0/9] Fix scheduling while atomic in
 dwc3_gadget_ep_dequeue
Thread-Index: AQHVLSpO0CxIfX1Aak+sMa9/czroQ6aw1kFg
Date:   Fri, 28 Jun 2019 10:10:38 +0000
Message-ID: <C672AA6DAAC36042A98BAD0B0B25BDA94CC59E46@BGSMSX104.gar.corp.intel.com>
References: <20190627205240.38366-1-john.stultz@linaro.org>
In-Reply-To: <20190627205240.38366-1-john.stultz@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNmQ2MjI3ZjctZTMyNi00YWEzLThkN2MtNTAyMzdlNDUxNWE1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTjMzUWhhOHptdmFNQzdUVjBzTnhoTXhUeTBIdDZwVU5YZFFna1gxa0x5Rld5NmZCcm1JTUZYOFMxOHcrQVdDZCJ9
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> With recent changes in AOSP, adb is using asynchronous io, which
> causes the following crash usually on a reboot:
> 
> [  184.278302] BUG: scheduling while atomic: ksoftirqd/0/9/0x00000104
> [  184.284617] Modules linked in: wl18xx wlcore snd_soc_hdmi_codec
> wlcore_sdio tcpci_rt1711h tcpci tcpm typec adv7511 cec dwc3 phy_hi3660_usb3
> snd_soc_simple_card snd_soc_a
> [  184.316034] Preemption disabled at:
> [  184.316072] [<ffffff8008081de4>] __do_softirq+0x64/0x398
> [  184.324953] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G S                4.19.43-
> 00669-g8e4970572c43-dirty #356
> [  184.334963] Hardware name: HiKey960 (DT)
> [  184.338892] Call trace:
> [  184.341352]  dump_backtrace+0x0/0x158
> [  184.345025]  show_stack+0x14/0x20
> [  184.348355]  dump_stack+0x80/0xa4
> [  184.351685]  __schedule_bug+0x6c/0xc0
> [  184.355363]  __schedule+0x64c/0x978
> [  184.358863]  schedule+0x2c/0x90
> [  184.362053]  dwc3_gadget_ep_dequeue+0x274/0x388 [dwc3]


> This happens as usb_ep_dequeue can be called in interrupt
> context, and dwc3_gadget_ep_dequeue() then calls
> wait_event_lock_irq() which can sleep.
> 
> Upstream kernels are not affected due to the change
> fec9095bdef4 ("dwc3: gadget: remove wait_end_transfer") which
> removes the wait_even_lock_irq code. Unfortunately that change
> has a number of dependencies, which I'm submitting here.
> 
> Also, to match upstream, in this series I've reverted one
> change that was backported to -stable, to replace it with the
> cherry-picked upstream commit (as the dependencies are now
> there)
> 
> This issue also affects 4.14,4.9 and I believe 4.4 kernels,
> however I don't know how to best backport this functionality
> that far back. Help from the maintainers would be very much
> appreciated!
> 
> Feedback and comments would be welcome!
> 
> thanks
> -john

I confirm that this patch series fixes crash seen on reboot.
Considering that many Android platforms use 4.19 stable kernel with latest AOSP codebase, it would be really helpful if these patches are merged to 4.19 stable.

Thanks,
Saranya
