Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222831C8C92
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgEGNj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 09:39:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:61782 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgEGNj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 09:39:28 -0400
IronPort-SDR: BaOkAkWH0bPNZN1dpjY2kGotFMhheGPnEVnT1wkZyauY2c8NMOGMPsgX0jCvPAt0EXLoTgxAnl
 awKBWMX3zWFw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 06:39:27 -0700
IronPort-SDR: NiB7rUwXSpY33D9VbpkLHQnGePzLCLwJkXYQ5PrCr6JN8/14HnLoKby+No6kqXkWf7iR6PWN7N
 JNq972iYTKtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,363,1583222400"; 
   d="scan'208";a="461849302"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga005.fm.intel.com with ESMTP; 07 May 2020 06:39:25 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jWgkK-005Dlq-Og; Thu, 07 May 2020 16:39:28 +0300
Date:   Thu, 7 May 2020 16:39:28 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-gpio@vger.kernel.org,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>
Subject: Re: [PATCH v2] pinctrl: cherryview: Ensure _REG(ACPI_ADR_SPACE_GPIO,
 1) gets called
Message-ID: <20200507133928.GW185537@smile.fi.intel.com>
References: <20200504145957.480418-1-hdegoede@redhat.com>
 <20200506064057.GU487496@lahna.fi.intel.com>
 <f7ebb693-94ec-fd9f-c0a8-cfe8f9d4e9bf@redhat.com>
 <20200507123025.GR487496@lahna.fi.intel.com>
 <3c509026-7d4f-9915-1c5e-dd6002042d92@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c509026-7d4f-9915-1c5e-dd6002042d92@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 07, 2020 at 02:39:21PM +0200, Hans de Goede wrote:
> On 5/7/20 2:30 PM, Mika Westerberg wrote:
> > On Thu, May 07, 2020 at 12:15:09PM +0200, Hans de Goede wrote:
> > > On 5/6/20 8:40 AM, Mika Westerberg wrote:

+Rafael and ACPICA folks.

...

> > I actually think this is the correct solution. Reading ACPI spec it say
> > this:
> > 
> >    Once _REG has been executed for a particular operation region,
> >    indicating that the operation region handler is ready, a control
> >    method can access fields in the operation region
> > 
> > You can interpret it so that _REG gets called when operation region
> > handler is ready. It does not say that there needs to be an actual
> > operation region even though the examples following all have operation
> > region.
> > 
> > I wonder what our ACPICA gurus think about this? Rafael, Bob, Erik?
> > 
> > > We could move the manual _REG call I'm adding to pinctrl-cherry-view.c
> > > but that has the same issue of calling _REG twice in many cases.
> > > 
> > > Most (all?) _REG implementations are fine with that, as they just set a
> > > variable to 1 (to the Arg1 value). Still calling _REG twice is something
> > > which we might want to avoid.
> > > 
> > > As a compromise I've chosen to add the extra unconditional _REG call
> > > to pinctrl-cherryview.c because:
> > > 
> > > 1. The problem in the DSDT in question stems from there being 2
> > > different OpRegions for accessing GPIOs which AFAIK is unique to
> > > cherryview
> > > 
> > > 2. I've seen many many cherryview DSDT-s and as such I'm confident
> > > that calling _REG twice is not an issue on cherryview.
> > > 
> > > > Are the ACPI tables from this system available somewhere?
> > > 
> > > Here you go:
> > > https://fedorapeople.org/~jwrdegoede/medion-e1239t-dsdt.dsl
> > 
> > Thanks for sharing!
> > 
> > > The problem is that on line 12624 there is a GPO2.AVBL == One
> > > check, before GPO2.DCDT is used. If you then look at line
> > > 17688 you see that _REG for the GPO2 device checkes for a
> > > space-id of 8 (ACPI_ADR_SPACE_GPIO) to set AVBL
> > > 
> > > But the only OpRegion defined for the GPO2 device, and the
> > > OpRegion to which GPO2.DCDT is mapped is the cherryview
> > > UserDefined 0x93 GPIO access OpRegion, see line 17760.
> > > Since there is no OpRegion for the ACPI_ADR_SPACE_GPIO
> > > space-id, ACPICA never calls _REG with Arg0 == 8.
> > 
> > Indeed, I see the issue now. I guess calling _REG always when there is
> > handler installed would solve this as well?
> 
> Yes that should solve the issue, that is actualy more or less
> what my patch does, but my patch only does it for the
> pinctrl-cherryview.c case.

And ACPICA guys, in case of thinking about generic solution there, can also
have a look into ACPI hotplug code. Something tells me that there may be the
very same root cause.

-- 
With Best Regards,
Andy Shevchenko


