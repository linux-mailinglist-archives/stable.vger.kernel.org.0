Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBCE1BE0B2
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 16:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgD2OWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 10:22:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:1349 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgD2OWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Apr 2020 10:22:11 -0400
IronPort-SDR: LgnWTTuWbaIsCtA80/Jc16ThDGM8oOOj+N07l5IztSoXewfybckL6WDqoRgeyy0ug1EIURy8H2
 73QzjPpETYdw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 07:22:10 -0700
IronPort-SDR: N81ZmKouHyFZr/u5MTSxU1Qi7vCcMMzjx7r6Z5dnI/mgsYe+NrS1FcKzvYdzrh7Bsx7bOqaEf6
 fNaLjWtLoHJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="336969599"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001.jf.intel.com with ESMTP; 29 Apr 2020 07:22:08 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jTnb5-003jjK-B0; Wed, 29 Apr 2020 17:21:59 +0300
Date:   Wed, 29 Apr 2020 17:21:59 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: cherryview: Ensure _REG(ACPI_ADR_SPACE_GPIO, 1)
 gets called
Message-ID: <20200429142159.GJ185537@smile.fi.intel.com>
References: <20200429104651.63643-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429104651.63643-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 29, 2020 at 12:46:51PM +0200, Hans de Goede wrote:
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
> does work under Windows. This issue leads to the intel_vbtn driver
> reporting the device always being in tablet-mode at boot, even if it
> is in laptop mode. Which in turn causes userspace to ignore touchpad
> events. So iow this issues causes the touchpad to not work at boot.
> 
> Since the bug in the DSDT stems from the confusion of having 2 different
> OpRegion types for accessing GPIOs on Cherry Trail devices, I believe
> that this is best fixed inside the cherryview pinctrl driver.
> 
> This commit adds a workaround to the cherryview pinctrl driver so
> that the DSDT's expectations of _REG always getting called for the
> GeneralPurposeIo OpRegion are met.

s/cherryview/Cherryview/g

...

> +	if (acpi_has_method(adev->handle, "_REG")) {

And this check si redundant, you may call it as is (you didn't check for error
anyway), see also below.

> +		struct acpi_object_list input;
> +		union acpi_object params[2];
> +
> +		input.count = 2;
> +		input.pointer = params;
> +		params[0].type = ACPI_TYPE_INTEGER;
> +		params[0].integer.value = ACPI_ADR_SPACE_GPIO;
> +		params[1].type = ACPI_TYPE_INTEGER;
> +		params[1].integer.value = 1;
> +		acpi_evaluate_object(adev->handle, "_REG", &input, NULL);
> +	}

Can you consider to unify this with one in drivers/pci/hotplug/acpiphp_glue.c,
so we will have some helper function at the end? (perhaps as separate changes
to make less burden on backporting this one)

-- 
With Best Regards,
Andy Shevchenko


