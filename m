Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F8740C4B7
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 14:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbhIOMEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 08:04:09 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:38468 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237390AbhIOMEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 08:04:09 -0400
Received: by mail-oi1-f179.google.com with SMTP id bd1so3872759oib.5;
        Wed, 15 Sep 2021 05:02:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ft+/nqrBQ84bDI6atl3Foew3VaLSZRGHThiF7jBPugw=;
        b=CORW40AgryR2XHPMXs5MbTdiyi36VxqB+ty2enln1UyXQqgfOwORaXLNkgeUJn1BH4
         0VjOptnHjc+n41YyKB4F3h1+qj+yK8YMVWX5H3+CgZzxsFY4rYstFqNB//09Ghi7AgSQ
         3/RqNSut9QXo2dtEU6dsHyAqLYvKdQLUYkG+6RPdgW6xIcxStbPBC+x+T+F3rOiJn6az
         dxksDTzp4Q63K3JSYnSvHw/sf+nsd2kF0fI6ocszwsRosDKoxs1oGz4xBCrfk106S6A0
         FhPrkN0xBLygzy88yPS/DERisZULNO824nyvWXkuWxQHeKj8lkkxHubendY1zjlCTcZT
         FAsQ==
X-Gm-Message-State: AOAM533XGw8HNRJiFZxCjPp+Ae3gFyGTZ4vjPioUdNZ7+4x+g3TuQMUg
        lMODF8cSSquDMUyJOVMA/2AhE+GXvPXKYP20sG8=
X-Google-Smtp-Source: ABdhPJyGhctEtJcYpPhIBlMl0Hs0PLrpfyZw8VEQPoRNxmcPY/aPGvm9HL0F3vzfOSKPRWwFYRrJTkXlmeNXlxmuDGg=
X-Received: by 2002:a05:6808:10c1:: with SMTP id s1mr4729442ois.69.1631707365049;
 Wed, 15 Sep 2021 05:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210915080939.21388-1-laurentiu.tudor@nxp.com>
In-Reply-To: <20210915080939.21388-1-laurentiu.tudor@nxp.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 15 Sep 2021 14:02:32 +0200
Message-ID: <CAJZ5v0jT9bn3RQpo9XJVb7SG_nJn1btvxvJW4jRZQByQajZ00A@mail.gmail.com>
Subject: Re: [PATCH v3] software node: balance refcount for managed sw nodes
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jon <jon@solid-run.com>, Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 10:10 AM <laurentiu.tudor@nxp.com> wrote:
>
> From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
>
> software_node_notify(), on KOBJ_REMOVE drops the refcount twice on managed
> software nodes, thus leading to underflow errors. Balance the refcount by
> bumping it in the device_create_managed_software_node() function.
>
> The error [1] was encountered after adding a .shutdown() op to our
> fsl-mc-bus driver.
>
> [1]
> pc : refcount_warn_saturate+0xf8/0x150
> lr : refcount_warn_saturate+0xf8/0x150
> sp : ffff80001009b920
> x29: ffff80001009b920 x28: ffff1a2420318000 x27: 0000000000000000
> x26: ffffccac15e7a038 x25: 0000000000000008 x24: ffffccac168e0030
> x23: ffff1a2428a82000 x22: 0000000000080000 x21: ffff1a24287b5000
> x20: 0000000000000001 x19: ffff1a24261f4400 x18: ffffffffffffffff
> x17: 6f72645f726f7272 x16: 0000000000000000 x15: ffff80009009b607
> x14: 0000000000000000 x13: ffffccac16602670 x12: 0000000000000a17
> x11: 000000000000035d x10: ffffccac16602670 x9 : ffffccac16602670
> x8 : 00000000ffffefff x7 : ffffccac1665a670 x6 : ffffccac1665a670
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff1a2420318000
> Call trace:
>  refcount_warn_saturate+0xf8/0x150
>  kobject_put+0x10c/0x120
>  software_node_notify+0xd8/0x140
>  device_platform_notify+0x4c/0xb4
>  device_del+0x188/0x424
>  fsl_mc_device_remove+0x2c/0x4c
>  rebofind sp.c__fsl_mc_device_remove+0x14/0x2c
>  device_for_each_child+0x5c/0xac
>  dprc_remove+0x9c/0xc0
>  fsl_mc_driver_remove+0x28/0x64
>  __device_release_driver+0x188/0x22c
>  device_release_driver+0x30/0x50
>  bus_remove_device+0x128/0x134
>  device_del+0x16c/0x424
>  fsl_mc_bus_remove+0x8c/0x114
>  fsl_mc_bus_shutdown+0x14/0x20
>  platform_shutdown+0x28/0x40
>  device_shutdown+0x15c/0x330
>  __do_sys_reboot+0x218/0x2a0
>  __arm64_sys_reboot+0x28/0x34
>  invoke_syscall+0x48/0x114
>  el0_svc_common+0x40/0xdc
>  do_el0_svc+0x2c/0x94
>  el0_svc+0x2c/0x54
>  el0t_64_sync_handler+0xa8/0x12c
>  el0t_64_sync+0x198/0x19c
> ---[ end trace 32eb1c71c7d86821 ]---
>
> Fixes: 151f6ff78cdf ("software node: Provide replacement for device_add_properties()")
> Reported-by: Jon Nettleton <jon@solid-run.com>
> Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> Cc: stable@vger.kernel.org
> ---
> Changes since v2:
>  - added Fixes: tag
>  - Cc-ed stable
>
> Changes since v1:
>  - added Heikki's Reviewed-by: (Thanks!)
>
> Changes since RFC:
>  - use software_node_notify(KOBJ_ADD) instead of directly bumping
>    refcount (Heikki)
>
>
>  drivers/base/swnode.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
> index d1f1a8240120..bdb50a06c82a 100644
> --- a/drivers/base/swnode.c
> +++ b/drivers/base/swnode.c
> @@ -1113,6 +1113,9 @@ int device_create_managed_software_node(struct device *dev,
>         to_swnode(fwnode)->managed = true;
>         set_secondary_fwnode(dev, fwnode);
>
> +       if (device_is_registered(dev))
> +               software_node_notify(dev, KOBJ_ADD);
> +
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(device_create_managed_software_node);
> --

Applied as 5.15-rc material, thanks!
