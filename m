Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D221C8AC4
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 14:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgEGMae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 08:30:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:14215 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgEGMae (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 08:30:34 -0400
IronPort-SDR: 0tjuxXzSwqYdrea6clOVtOqQX3LvGv2LiFT82MmPzETXGQIt9vCvnwAbzX8m61lqD6pvp4frLH
 TUx3exSoMaHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 05:30:30 -0700
IronPort-SDR: t2ATrTX9MVIuhS1TEX7c7IbFkjeEbujlLwRxsnDVdcFyC/oMzMMG7APiNWQQfCX0pcEKqy5pQW
 bllLLPQgF5OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,363,1583222400"; 
   d="scan'208";a="370102481"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 07 May 2020 05:30:26 -0700
Received: by lahna (sSMTP sendmail emulation); Thu, 07 May 2020 15:30:25 +0300
Date:   Thu, 7 May 2020 15:30:25 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-gpio@vger.kernel.org,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        Erik Kaneda <erik.kaneda@intel.com>
Subject: Re: [PATCH v2] pinctrl: cherryview: Ensure _REG(ACPI_ADR_SPACE_GPIO,
 1) gets called
Message-ID: <20200507123025.GR487496@lahna.fi.intel.com>
References: <20200504145957.480418-1-hdegoede@redhat.com>
 <20200506064057.GU487496@lahna.fi.intel.com>
 <f7ebb693-94ec-fd9f-c0a8-cfe8f9d4e9bf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7ebb693-94ec-fd9f-c0a8-cfe8f9d4e9bf@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 07, 2020 at 12:15:09PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 5/6/20 8:40 AM, Mika Westerberg wrote:
> > +Rafael and ACPICA folks.
> > 
> > On Mon, May 04, 2020 at 04:59:57PM +0200, Hans de Goede wrote:
> > > On Cherry Trail devices there are 2 possible ACPI OpRegions for
> > > accessing GPIOs. The standard GeneralPurposeIo OpRegion and the Cherry
> > > Trail specific UserDefined 0x9X OpRegions.
> > > 
> > > Having 2 different types of OpRegions leads to potential issues with
> > > checks for OpRegion availability, or in other words checks if _REG has
> > > been called for the OpRegion which the ACPI code wants to use.
> > > 
> > > The ACPICA core does not call _REG on an ACPI node which does not
> > > define an OpRegion matching the type being registered; and the reference
> > > design DSDT, from which most Cherry Trail DSDTs are derived, does not
> > > define GeneralPurposeIo, nor UserDefined(0x93) OpRegions for the GPO2
> > > (UID 3) device, because no pins were assigned ACPI controlled functions
> > > in the reference design.
> > > 
> > > Together this leads to the perfect storm, at least on the Cherry Trail
> > > based Medion Akayo E1239T. This design does use a GPO2 pin from its ACPI
> > > code and has added the Cherry Trail specific UserDefined(0x93) opregion
> > > to its GPO2 ACPI node to access this pin.
> > > 
> > > But it uses a has _REG been called availability check for the standard
> > > GeneralPurposeIo OpRegion. This clearly is a bug in the DSDT, but this
> > > does work under Windows.
> > 
> > Do we know why this works under Windows? I mean if possible we should do
> > the same and I kind of suspect that they forcibly call _REG in their
> > GPIO driver.
> 
> Windows has its own ACPI implementation, so it could also be that their
> equivalent of the:
> 
>         status = acpi_install_address_space_handler(handle, ACPI_ADR_SPACE_GPIO,
>                                                     acpi_gpio_adr_space_handler,
>                                                     NULL, achip);
> 
> Call from drivers/gpio/gpiolib-acpi.c indeed always calls _REG on the handle
> without checking that there is an actual OpRegion with a space-id
> of ACPI_ADR_SPACE_GPIO defined, as the ACPICA code does.  Note that the
> current ACPICA code would require significant rework to allow this, or
> it would need to add a _REG call at the end of acpi_install_address_space_handler(),
> potentially calling _REG twice in many cases.

I actually think this is the correct solution. Reading ACPI spec it say
this:

  Once _REG has been executed for a particular operation region,
  indicating that the operation region handler is ready, a control
  method can access fields in the operation region

You can interpret it so that _REG gets called when operation region
handler is ready. It does not say that there needs to be an actual
operation region even though the examples following all have operation
region.

I wonder what our ACPICA gurus think about this? Rafael, Bob, Erik?

> We could move the manual _REG call I'm adding to pinctrl-cherry-view.c
> but that has the same issue of calling _REG twice in many cases.
> 
> Most (all?) _REG implementations are fine with that, as they just set a
> variable to 1 (to the Arg1 value). Still calling _REG twice is something
> which we might want to avoid.
> 
> As a compromise I've chosen to add the extra unconditional _REG call
> to pinctrl-cherryview.c because:
> 
> 1. The problem in the DSDT in question stems from there being 2
> different OpRegions for accessing GPIOs which AFAIK is unique to
> cherryview
> 
> 2. I've seen many many cherryview DSDT-s and as such I'm confident
> that calling _REG twice is not an issue on cherryview.
> 
> > Are the ACPI tables from this system available somewhere?
> 
> Here you go:
> https://fedorapeople.org/~jwrdegoede/medion-e1239t-dsdt.dsl

Thanks for sharing!

> The problem is that on line 12624 there is a GPO2.AVBL == One
> check, before GPO2.DCDT is used. If you then look at line
> 17688 you see that _REG for the GPO2 device checkes for a
> space-id of 8 (ACPI_ADR_SPACE_GPIO) to set AVBL
> 
> But the only OpRegion defined for the GPO2 device, and the
> OpRegion to which GPO2.DCDT is mapped is the cherryview
> UserDefined 0x93 GPIO access OpRegion, see line 17760.
> Since there is no OpRegion for the ACPI_ADR_SPACE_GPIO
> space-id, ACPICA never calls _REG with Arg0 == 8.

Indeed, I see the issue now. I guess calling _REG always when there is
handler installed would solve this as well?

> So as already mentioned the problem stems from the confusion
> of there being 2 different OpRegions for accessing GPIOs
> on cherryview.
> 
> Regards,
> 
> Hans
> 
> 
> 
> > > This issue leads to the intel_vbtn driver
> > > reporting the device always being in tablet-mode at boot, even if it
> > > is in laptop mode. Which in turn causes userspace to ignore touchpad
> > > events. So iow this issues causes the touchpad to not work at boot.
> > > 
> > > Since the bug in the DSDT stems from the confusion of having 2 different
> > > OpRegion types for accessing GPIOs on Cherry Trail devices, I believe
> > > that this is best fixed inside the Cherryview pinctrl driver.
> > > 
> > > This commit adds a workaround to the Cherryview pinctrl driver so
> > > that the DSDT's expectations of _REG always getting called for the
> > > GeneralPurposeIo OpRegion are met.
> > 
> > I would like to understand the issue bit better before we do this.
> > 
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > > ---
> > > Changes in v2:
> > > - Drop unnecessary if (acpi_has_method(adev->handle, "_REG")) check
> > > - Fix Cherryview spelling in the commit message
> > > ---
> > >   drivers/pinctrl/intel/pinctrl-cherryview.c | 18 ++++++++++++++++++
> > >   1 file changed, 18 insertions(+)
> > > 
> > > diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
> > > index 4c74fdde576d..4817aec114d6 100644
> > > --- a/drivers/pinctrl/intel/pinctrl-cherryview.c
> > > +++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
> > > @@ -1693,6 +1693,8 @@ static acpi_status chv_pinctrl_mmio_access_handler(u32 function,
> > >   static int chv_pinctrl_probe(struct platform_device *pdev)
> > >   {
> > > +	struct acpi_object_list input;
> > > +	union acpi_object params[2];
> > >   	struct chv_pinctrl *pctrl;
> > >   	struct acpi_device *adev;
> > >   	acpi_status status;
> > > @@ -1755,6 +1757,22 @@ static int chv_pinctrl_probe(struct platform_device *pdev)
> > >   	if (ACPI_FAILURE(status))
> > >   		dev_err(&pdev->dev, "failed to install ACPI addr space handler\n");
> > > +	/*
> > > +	 * Some DSDT-s use the chv_pinctrl_mmio_access_handler while checking
> > > +	 * for the regular GeneralPurposeIo OpRegion availability, mixed with
> > > +	 * the DSDT not defining a GeneralPurposeIo OpRegion at all. In this
> > > +	 * case the ACPICA code will not call _REG to signal availability of
> > > +	 * the GeneralPurposeIo OpRegion. Manually call _REG here so that
> > > +	 * the DSDT-s GeneralPurposeIo availability checks will succeed.
> > > +	 */
> > > +	params[0].type = ACPI_TYPE_INTEGER;
> > > +	params[0].integer.value = ACPI_ADR_SPACE_GPIO;
> > > +	params[1].type = ACPI_TYPE_INTEGER;
> > > +	params[1].integer.value = 1;
> > > +	input.count = 2;
> > > +	input.pointer = params;
> > > +	acpi_evaluate_object(adev->handle, "_REG", &input, NULL);
> > > +
> > >   	platform_set_drvdata(pdev, pctrl);
> > >   	return 0;
> > > -- 
> > > 2.26.0
> > 
