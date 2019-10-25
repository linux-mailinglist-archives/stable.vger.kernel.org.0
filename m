Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A16E4774
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 11:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394338AbfJYJgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 05:36:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:41382 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394278AbfJYJg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 05:36:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 02:36:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="192488193"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 25 Oct 2019 02:36:26 -0700
Received: from andy by smile with local (Exim 4.92.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1iNw1C-00032k-0I; Fri, 25 Oct 2019 12:36:26 +0300
Date:   Fri, 25 Oct 2019 12:36:25 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] ACPI / LPSS: Add LNXVIDEO -> BYT I2C7 to
 lpss_device_links
Message-ID: <20191025093625.GM32742@smile.fi.intel.com>
References: <20191024215723.145922-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024215723.145922-1-hdegoede@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 11:57:21PM +0200, Hans de Goede wrote:
> So far on Bay Trail (BYT) we only have been adding a device_link adding
> the iGPU (LNXVIDEO) device as consumer for the I2C controller for the
> PMIC for I2C5, but the PMIC only uses I2C5 on BYT CR (cost reduced) on
> regular BYT platforms I2C7 is used and we were not adding the device_link
> sometimes causing resume ordering issues.
> 
> This commit adds LNXVIDEO -> BYT I2C7 to the lpss_device_links table,
> fixing this.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Couple of nits below.

> 
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
>  drivers/acpi/acpi_lpss.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 60bbc5090abe..e7a4504f0fbf 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -473,9 +473,14 @@ struct lpss_device_links {
>   * the supplier is not enumerated until after the consumer is probed.
>   */
>  static const struct lpss_device_links lpss_device_links[] = {
> +	/* CHT External sdcard slot controller depends on PMIC I2C ctrl */

sdcard -> SD card

>  	{"808622C1", "7", "80860F14", "3", DL_FLAG_PM_RUNTIME},
> +	/* CHT iGPU depends on PMIC I2C controller */
>  	{"808622C1", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
> +	/* BYT CR iGPU depends on PMIC I2C controller (UID 5 on CR) */
>  	{"80860F41", "5", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},

> +	/* BYT iGPU depends on PMIC I2C controller (UID 7 on non CR) */

non CR -> non-CR

> +	{"80860F41", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
>  };
>  
>  static bool hid_uid_match(struct acpi_device *adev,
> -- 
> 2.23.0
> 

-- 
With Best Regards,
Andy Shevchenko


