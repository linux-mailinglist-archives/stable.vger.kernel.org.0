Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE632E4779
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 11:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394368AbfJYJhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 05:37:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:39189 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730158AbfJYJhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 05:37:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 02:37:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="282213771"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001.jf.intel.com with ESMTP; 25 Oct 2019 02:37:15 -0700
Received: from andy by smile with local (Exim 4.92.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iNw1y-000337-CN; Fri, 25 Oct 2019 12:37:14 +0300
Date:   Fri, 25 Oct 2019 12:37:14 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C1 to
 lpss_device_links
Message-ID: <20191025093714.GN32742@smile.fi.intel.com>
References: <20191024215723.145922-1-hdegoede@redhat.com>
 <20191024215723.145922-2-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024215723.145922-2-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 11:57:22PM +0200, Hans de Goede wrote:
> Various Asus Bay Trail devices (T100TA, T100CHI, T200TA) have an embedded
> controller connected to I2C1 and the iGPU (LNXVIDEO) _PS0/_PS3 methods
> access it, so we need to add a consumer link from LNXVIDEO to I2C1 on
> these devices to avoid suspend/resume ordering problems.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Cc: stable@vger.kernel.org
> Fixes: 2d71ee0ce72f ("ACPI / LPSS: Add a device link from the GPU to the BYT I2C5 controller")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -Add Fixes: tag
> 
> Changes in v3:
> -Point Fixes tag to a more apropriate commit
> ---
>  drivers/acpi/acpi_lpss.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index e7a4504f0fbf..cd8cf3333f04 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -477,6 +477,8 @@ static const struct lpss_device_links lpss_device_links[] = {
>  	{"808622C1", "7", "80860F14", "3", DL_FLAG_PM_RUNTIME},
>  	/* CHT iGPU depends on PMIC I2C controller */
>  	{"808622C1", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
> +	/* BYT iGPU depends on the Embedded Controller I2C controller (UID 1) */
> +	{"80860F41", "1", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
>  	/* BYT CR iGPU depends on PMIC I2C controller (UID 5 on CR) */
>  	{"80860F41", "5", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
>  	/* BYT iGPU depends on PMIC I2C controller (UID 7 on non CR) */
> -- 
> 2.23.0
> 

-- 
With Best Regards,
Andy Shevchenko


