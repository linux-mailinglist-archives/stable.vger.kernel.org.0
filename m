Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF2214CC25
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 15:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgA2OOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 09:14:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:17780 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgA2OOq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 09:14:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 06:14:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,378,1574150400"; 
   d="scan'208";a="223844287"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jan 2020 06:14:43 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iwo7A-0002xX-Gd; Wed, 29 Jan 2020 16:14:44 +0200
Date:   Wed, 29 Jan 2020 16:14:44 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        vipul kumar <vipulk0511@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
Message-ID: <20200129141444.GE32742@smile.fi.intel.com>
References: <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
 <20200123144108.GU32742@smile.fi.intel.com>
 <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
 <87iml11ccf.fsf@nanos.tec.linutronix.de>
 <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
 <87ftg5131x.fsf@nanos.tec.linutronix.de>
 <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com>
 <87sgjz434v.fsf@nanos.tec.linutronix.de>
 <20200129130350.GD32742@smile.fi.intel.com>
 <0d361322-87aa-af48-492c-e8c4983bb35b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d361322-87aa-af48-492c-e8c4983bb35b@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 29, 2020 at 02:21:40PM +0100, Hans de Goede wrote:
> On 29-01-2020 14:03, Andy Shevchenko wrote:
> > On Tue, Jan 28, 2020 at 11:39:28PM +0100, Thomas Gleixner wrote:
> > > Hans de Goede <hdegoede@redhat.com> writes:

...

> > > Typical crystal frequencies are 19.2, 24 and 25Mhz.
> > 
> > Hans, I think Cherrytrail may be affected by this as the others.
> > CHT AFAIK uses 19.2MHz xtal.
> 
> Are you sure?

I'm not. I may mixed this with PMC clock.

> The first 5 entries of the CHT MSR_FSB_FREQ documentation exactly
> match those of the BYT documentation (which has only 5 entries),
> which suggests to me that CHT is also using a 25 MHz crystal.
> 
> I can also make the other CHT only frequencies when assuming a 25
> MHz crystal, here is a bit from the patch I'm working on for this:
> 
> /*
>  * Cherry Trail SDM MSR_FSB_FREQ frequencies to PLL settings map:
>  * 0000:   25 * 20 /  6  =  83.3333 MHz
>  * 0001:   25 *  4 /  1  = 100.0000 MHz
>  * 0010:   25 * 16 /  3  = 133.3333 MHz
>  * 0011:   25 * 28 /  6  = 116.6667 MHz
>  * 0100:   25 * 16 /  5  =  80.0000 MHz
>  * 0101:   25 * 56 / 15  =  93.3333 MHz
>  * 0110:   25 * 18 /  5  =  90.0000 MHz
>  * 0111:   25 * 32 /  9  =  88.8889 MHz
>  * 1000:   25 *  7 /  2  =  87.5000 MHz
>  */
> 
> The only one which is possibly suspicious here is this line:
> 
>  * 0111:   25 * 32 /  9  =  88.8889 MHz
> 
> The SDM says 88.9 MHz for this one.

Anyway it seems need to be fixed as well.

Btw, why we are mentioning 20 / 6 and 28 / 6 when arithmetically
it's the same as 10 / 3 and 14 / 3?

-- 
With Best Regards,
Andy Shevchenko


