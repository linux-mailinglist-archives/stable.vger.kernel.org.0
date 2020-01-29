Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D8714CDE5
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 17:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgA2QC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 11:02:56 -0500
Received: from mga14.intel.com ([192.55.52.115]:27432 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgA2QC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 11:02:56 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 08:02:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,378,1574150400"; 
   d="scan'208";a="223084445"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jan 2020 08:02:52 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iwpnp-0004Lm-M0; Wed, 29 Jan 2020 18:02:53 +0200
Date:   Wed, 29 Jan 2020 18:02:53 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        vipul kumar <vipulk0511@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
Message-ID: <20200129160253.GK32742@smile.fi.intel.com>
References: <87ftg5131x.fsf@nanos.tec.linutronix.de>
 <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com>
 <87sgjz434v.fsf@nanos.tec.linutronix.de>
 <20200129130350.GD32742@smile.fi.intel.com>
 <0d361322-87aa-af48-492c-e8c4983bb35b@redhat.com>
 <20200129141444.GE32742@smile.fi.intel.com>
 <91cdda7a-4194-ebe7-225d-854447b0436e@redhat.com>
 <87imku2t3w.fsf@nanos.tec.linutronix.de>
 <20200129155353.GI32742@smile.fi.intel.com>
 <20200129155910.GJ32742@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129155910.GJ32742@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 29, 2020 at 05:59:10PM +0200, Andy Shevchenko wrote:
> On Wed, Jan 29, 2020 at 05:53:53PM +0200, Andy Shevchenko wrote:
> > On Wed, Jan 29, 2020 at 04:13:39PM +0100, Thomas Gleixner wrote:
> > > Hans de Goede <hdegoede@redhat.com> writes:
> > > > On 29-01-2020 15:14, Andy Shevchenko wrote:
> > > >>> The only one which is possibly suspicious here is this line:
> > > >>>
> > > >>>   * 0111:   25 * 32 /  9  =  88.8889 MHz
> > > >>>
> > > >>> The SDM says 88.9 MHz for this one.
> > > 
> > > I trust math more than the SDM :)
> > > 
> > > >> Anyway it seems need to be fixed as well.
> > > >> 
> > > >> Btw, why we are mentioning 20 / 6 and 28 / 6 when arithmetically
> > > >> it's the same as 10 / 3 and 14 / 3?
> > > >
> > > > I copied the BYT values from Thomas' email and I guess he did not
> > > > get around to simplifying them, I'll use the simplified versions
> > > > for my patch.
> > > 
> > > Too tired, too lazy :)
> > > 
> > > Andy, can you please make sure that people inside Intel who can look
> > > into the secrit documentation confirm what we are aiming for?
> > > 
> > > Ideally they should provide the X-tal frequency and the mult/div pair
> > > themself :)
> > 
> > So, I don't have access to the CPU core documentation (and may be will not be
> > given), nevertheless I dug a bit to what I have for Cherrytrail. So, the XTAL
> > is 19.2MHz, which becomes 100MHz and 1600MHz by some root PLL, then, the latter
> > two frequencies are being used by another PLL to provide a reference clock (*)
> > to PLL which derives CPU clock.
> 
> > *) According to colleagues of mine it's a fixed rate source.
> 
> One more thing.
> 
> Depends on SKU it may be 400MHz, 320MHz, 200MHz or 333MHz.

Aha, found better precision for the last one, 333.33MHz.

> (I guess these values should be kinda references in the table)
> 
> > That's all what I have.

-- 
With Best Regards,
Andy Shevchenko


