Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3BEE4732
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 11:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408743AbfJYJaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 05:30:01 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37130 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408067AbfJYJaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 05:30:00 -0400
Received: by mail-ot1-f68.google.com with SMTP id 53so1582174otv.4;
        Fri, 25 Oct 2019 02:30:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cU1OixEwalemmBVOtdh43Cbb3H+ljnFK0wFPUoflBD4=;
        b=kLQA4VMmDJbAJAaln5MqDnG1VwY0bsPwOYamGyjCEylZR4a64kdxF2DjwG1Ki/8GZx
         Y8/mzzFvjElpt+M8jgy3rM4fnXTLg1v4V7YcAgzeF+uOwHHc6y6/OzeCDdflZo3pZmXI
         aUZSr48pwb2MQiE9w/IZSxA05Tw9yby99T2F0ByvHTEJQnEioCItlut7rpnyT3OjQkap
         gnonHUDzZ2lj7vSLSfs8zksqsrOh7nFDcyt45vsh44taPSzi9qWmx3rq95ARYdU7p377
         utw5OS4TrT/oNmpSHHqmhIlghOZKnoGQPQr4dz6qRB5VWOiDCEr5s2Q/FCV1yh1dKMN+
         q9SA==
X-Gm-Message-State: APjAAAU3DU0n2//9RQWDQ8BhrOjtM220EqR6mpQHOVXDjCCS2VO5iveb
        UrFsbCbt2sJwijS2uPn6TFTXRiQpdKe50xMEgl0=
X-Google-Smtp-Source: APXvYqz2vywbyEVId7Pf5c1eOgBzo2kYCDQGSePp+4wh/X6injFWVYLZJNy79xhbDXX9niCyd/Faw/1yd+7SOB7+qwY=
X-Received: by 2002:a9d:459b:: with SMTP id x27mr1816253ote.167.1571995799632;
 Fri, 25 Oct 2019 02:29:59 -0700 (PDT)
MIME-Version: 1.0
References: <20191024215723.145922-1-hdegoede@redhat.com> <20191024215723.145922-3-hdegoede@redhat.com>
In-Reply-To: <20191024215723.145922-3-hdegoede@redhat.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 25 Oct 2019 11:29:48 +0200
Message-ID: <CAJZ5v0hVuakKRAfoB-+WGqjvxQ4EM5_jnf95VtQQxG5e4=5GsQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ACPI / LPSS: Add dmi quirk for skipping _DEP check
 for some device-links
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 11:57 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> The iGPU / GFX0 device's _PS0 method on the ASUS T200TA depends on the
> I2C1 controller (which is connected to the embedded controller). But unlike
> in the T100TA/T100CHI this dependency is not listed in the _DEP of the GFX0
> device.
>
> This results in the dev_WARN_ONCE(..., "Transfer while suspended\n") call
> in i2c-designware-master.c triggering and the AML code not working as it
> should.
>
> This commit fixes this by adding a dmi based quirk mechanism for devices
> which miss a _DEP, and adding a quirk for the LNXVIDEO depending on the
> I2C1 device on the Asus T200TA.
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
>  drivers/acpi/acpi_lpss.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index cd8cf3333f04..751ed38f2a10 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -10,6 +10,7 @@
>  #include <linux/acpi.h>
>  #include <linux/clkdev.h>
>  #include <linux/clk-provider.h>
> +#include <linux/dmi.h>
>  #include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/mutex.h>
> @@ -463,6 +464,18 @@ struct lpss_device_links {
>         const char *consumer_hid;
>         const char *consumer_uid;
>         u32 flags;
> +       const struct dmi_system_id *dep_missing_ids;
> +};
> +
> +/* Please keep this list sorted alphabetically by vendor and model */
> +static const struct dmi_system_id i2c1_dep_missing_dmi_ids[] = {
> +       {
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> +                       DMI_MATCH(DMI_PRODUCT_NAME, "T200TA"),
> +               },
> +       },
> +       {}
>  };
>
>  /*
> @@ -478,7 +491,8 @@ static const struct lpss_device_links lpss_device_links[] = {
>         /* CHT iGPU depends on PMIC I2C controller */
>         {"808622C1", "7", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
>         /* BYT iGPU depends on the Embedded Controller I2C controller (UID 1) */
> -       {"80860F41", "1", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
> +       {"80860F41", "1", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME,
> +        i2c1_dep_missing_dmi_ids},
>         /* BYT CR iGPU depends on PMIC I2C controller (UID 5 on CR) */
>         {"80860F41", "5", "LNXVIDEO", NULL, DL_FLAG_PM_RUNTIME},
>         /* BYT iGPU depends on PMIC I2C controller (UID 7 on non CR) */
> @@ -577,7 +591,8 @@ static void acpi_lpss_link_consumer(struct device *dev1,
>         if (!dev2)
>                 return;
>
> -       if (acpi_lpss_dep(ACPI_COMPANION(dev2), ACPI_HANDLE(dev1)))
> +       if ((link->dep_missing_ids && dmi_check_system(link->dep_missing_ids))
> +           || acpi_lpss_dep(ACPI_COMPANION(dev2), ACPI_HANDLE(dev1)))
>                 device_link_add(dev2, dev1, link->flags);
>
>         put_device(dev2);
> @@ -592,7 +607,8 @@ static void acpi_lpss_link_supplier(struct device *dev1,
>         if (!dev2)
>                 return;
>
> -       if (acpi_lpss_dep(ACPI_COMPANION(dev1), ACPI_HANDLE(dev2)))
> +       if ((link->dep_missing_ids && dmi_check_system(link->dep_missing_ids))
> +           || acpi_lpss_dep(ACPI_COMPANION(dev1), ACPI_HANDLE(dev2)))
>                 device_link_add(dev1, dev2, link->flags);
>
>         put_device(dev2);
> --

Applying the series as 5.5 material, thanks!
