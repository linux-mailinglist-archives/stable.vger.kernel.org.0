Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7A81C6920
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 08:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgEFGlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 02:41:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:54311 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgEFGlG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 02:41:06 -0400
IronPort-SDR: Bxx9UlhijIOlE/HuVNYXKoNJWRkMiKRr+LO+OGrkfSjXqPH3N8hlswJmYWrIR26zDRNLGZ8QIf
 6MaKBQRDFa7g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2020 23:41:02 -0700
IronPort-SDR: R2ely63ffkvvDXpX9TZU8U017jiHJBd91lgAffp6IPYnI1bew72yAmOXhsug7tgyisFSgpU3Bz
 UqAL9+ifze/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="369697947"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 05 May 2020 23:40:58 -0700
Received: by lahna (sSMTP sendmail emulation); Wed, 06 May 2020 09:40:57 +0300
Date:   Wed, 6 May 2020 09:40:57 +0300
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
Message-ID: <20200506064057.GU487496@lahna.fi.intel.com>
References: <20200504145957.480418-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504145957.480418-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Rafael and ACPICA folks.

On Mon, May 04, 2020 at 04:59:57PM +0200, Hans de Goede wrote:
> On Cherry Trail devices there are 2 possible ACPI OpRegions for
> accessing GPIOs. The standard GeneralPurposeIo OpRegion and the Cherry
> Trail specific UserDefined 0x9X OpRegions.
> 
> Having 2 different types of OpRegions leads to potential issues with
> checks for OpRegion availability, or in other words checks if _REG has
> been called for the OpRegion which the ACPI code wants to use.
> 
> The ACPICA core does not call _REG on an ACPI node which does not
> define an OpRegion matching the type being registered; and the reference
> design DSDT, from which most Cherry Trail DSDTs are derived, does not
> define GeneralPurposeIo, nor UserDefined(0x93) OpRegions for the GPO2
> (UID 3) device, because no pins were assigned ACPI controlled functions
> in the reference design.
> 
> Together this leads to the perfect storm, at least on the Cherry Trail
> based Medion Akayo E1239T. This design does use a GPO2 pin from its ACPI
> code and has added the Cherry Trail specific UserDefined(0x93) opregion
> to its GPO2 ACPI node to access this pin.
> 
> But it uses a has _REG been called availability check for the standard
> GeneralPurposeIo OpRegion. This clearly is a bug in the DSDT, but this
> does work under Windows.

Do we know why this works under Windows? I mean if possible we should do
the same and I kind of suspect that they forcibly call _REG in their
GPIO driver.

Are the ACPI tables from this system available somewhere?

> This issue leads to the intel_vbtn driver
> reporting the device always being in tablet-mode at boot, even if it
> is in laptop mode. Which in turn causes userspace to ignore touchpad
> events. So iow this issues causes the touchpad to not work at boot.
> 
> Since the bug in the DSDT stems from the confusion of having 2 different
> OpRegion types for accessing GPIOs on Cherry Trail devices, I believe
> that this is best fixed inside the Cherryview pinctrl driver.
> 
> This commit adds a workaround to the Cherryview pinctrl driver so
> that the DSDT's expectations of _REG always getting called for the
> GeneralPurposeIo OpRegion are met.

I would like to understand the issue bit better before we do this.

> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> - Drop unnecessary if (acpi_has_method(adev->handle, "_REG")) check
> - Fix Cherryview spelling in the commit message
> ---
>  drivers/pinctrl/intel/pinctrl-cherryview.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
> index 4c74fdde576d..4817aec114d6 100644
> --- a/drivers/pinctrl/intel/pinctrl-cherryview.c
> +++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
> @@ -1693,6 +1693,8 @@ static acpi_status chv_pinctrl_mmio_access_handler(u32 function,
>  
>  static int chv_pinctrl_probe(struct platform_device *pdev)
>  {
> +	struct acpi_object_list input;
> +	union acpi_object params[2];
>  	struct chv_pinctrl *pctrl;
>  	struct acpi_device *adev;
>  	acpi_status status;
> @@ -1755,6 +1757,22 @@ static int chv_pinctrl_probe(struct platform_device *pdev)
>  	if (ACPI_FAILURE(status))
>  		dev_err(&pdev->dev, "failed to install ACPI addr space handler\n");
>  
> +	/*
> +	 * Some DSDT-s use the chv_pinctrl_mmio_access_handler while checking
> +	 * for the regular GeneralPurposeIo OpRegion availability, mixed with
> +	 * the DSDT not defining a GeneralPurposeIo OpRegion at all. In this
> +	 * case the ACPICA code will not call _REG to signal availability of
> +	 * the GeneralPurposeIo OpRegion. Manually call _REG here so that
> +	 * the DSDT-s GeneralPurposeIo availability checks will succeed.
> +	 */
> +	params[0].type = ACPI_TYPE_INTEGER;
> +	params[0].integer.value = ACPI_ADR_SPACE_GPIO;
> +	params[1].type = ACPI_TYPE_INTEGER;
> +	params[1].integer.value = 1;
> +	input.count = 2;
> +	input.pointer = params;
> +	acpi_evaluate_object(adev->handle, "_REG", &input, NULL);
> +
>  	platform_set_drvdata(pdev, pctrl);
>  
>  	return 0;
> -- 
> 2.26.0
