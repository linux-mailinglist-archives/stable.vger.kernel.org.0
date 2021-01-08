Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F8E2EF66A
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 18:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbhAHRYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 12:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbhAHRX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 12:23:59 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920EFC061380
        for <stable@vger.kernel.org>; Fri,  8 Jan 2021 09:23:19 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id b64so10018088ybg.7
        for <stable@vger.kernel.org>; Fri, 08 Jan 2021 09:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7vLqbi/sihxtyWstJFdoSmf0V1iPip4GNWYBITz48Ag=;
        b=hftI+uxAMDWcDHZ+V+KGHi9iWWWXPhmw0jh2j7JuyktnwTk6JtQWJ69CtdUXoB/taw
         ApM9uoaSF71MmsogAeU04FrfmnS49pu5L1PvPPwiYvVrxZvaFFJBgSqa6IZEskZ5jLfX
         eJ4YkFjWEUlSdChvg9X3n6FMrev52IZ84rR0sHWj55QtiP8dCtfPrLxnrUbzlP5lZgMs
         R0gMioe3+d2l/DBZ7JlI7wYEjcxhxvyw/CeQV8s4dCsORHn1EYXlZcUvs2N7yVrJct3e
         0WRdoOSf4FvTmcPvQUkpopsogG739SfDaDySd49I8Xx+dNuWh7IC48fwdKmeaNr/7sDj
         Kc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7vLqbi/sihxtyWstJFdoSmf0V1iPip4GNWYBITz48Ag=;
        b=XI8z4J9PEHoyHxgvZ3X7N/JHyBjj+n96ShYSEOpykCdJ38Ds51ULb5ZPNpF/XbguXy
         GgTdgfaNwrW8FP6tKsp81qEqrCNJwH6SaE+CBOtIVrEspWN/pI4oDbBawM/A2vtBb125
         jEA14mVS3XZtjnw+39IDghNHvcO3s1zLXVBJPC+B8rU6vtrDmQAgcAS8gtHLLAYo6ojU
         tIUt2vtNhyuEqLgMMzIcfYzlhdLjiLe30q4rYbKW2RCZqMmZPphoCs4g6XyHzdQ/UVLK
         6K9VO7KpSgRKDOvKKhTJ1JjeCqS2uFvjWxnY/ys+Nz5Pc4TgTDNU0aN6fNYRcQpLCiw1
         DKlw==
X-Gm-Message-State: AOAM5322GTrRE2mugNhXuw3MDdaHXX5rDCanKsRSALevRuTfYXCoaDEj
        xXPcFbBFvLoyh7sPdZRg87OEvNylFM1mwAzL36Mq+A==
X-Google-Smtp-Source: ABdhPJzs0JtRADFZhOTT4LGKcy6QUHh1bFOy7+sG0vzuHOdsVX06wFxavXLEVPU9M+Xl/qFekinW7DPbmigF39rq48w=
X-Received: by 2002:a25:6604:: with SMTP id a4mr7295312ybc.412.1610126598484;
 Fri, 08 Jan 2021 09:23:18 -0800 (PST)
MIME-Version: 1.0
References: <20210108012427.766318-1-saravanak@google.com> <9ec99f2f0e1e75e11f2d7d013dc78203@walle.cc>
In-Reply-To: <9ec99f2f0e1e75e11f2d7d013dc78203@walle.cc>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 8 Jan 2021 09:22:42 -0800
Message-ID: <CAGETcx-TT=ce+oSV2miKN5YdO-gY1oqCMVBkgs6D4kfFLpyn1w@mail.gmail.com>
Subject: Re: [PATCH v3] driver core: Fix device link device name collision
To:     Michael Walle <michael@walle.cc>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 8, 2021 at 12:16 AM Michael Walle <michael@walle.cc> wrote:
>
> Am 2021-01-08 02:24, schrieb Saravana Kannan:
> > The device link device's name was of the form:
> > <supplier-dev-name>--<consumer-dev-name>
> >
> > This can cause name collision as reported here [1] as device names are
> > not globally unique. Since device names have to be unique within the
> > bus/class, add the bus/class name as a prefix to the device names used
> > to
> > construct the device link device name.
> >
> > So the devuce link device's name will be of the form:
> > <supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>
> >
> > [1] -
> > https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 287905e68dd2 ("driver core: Expose device link details in
> > sysfs")
> > Reported-by: Michael Walle <michael@walle.cc>
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > ---
> [..]
>
> The changes are missing for the error path and
> devlink_remove_symlinks(),
> right?

Removing symlinks doesn't need the name. Just needs the "handle". So
we are good there.

>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 4140a69dfe18..385e16d92874 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -485,7 +485,7 @@ static int devlink_add_symlinks(struct device *dev,
>         goto out;
>
>   err_sup_dev:
> -       snprintf(buf, len, "consumer:%s", dev_name(con));
> +       snprintf(buf, len, "consumer:%s:%s", dev_bus_name(con),
> dev_name(con));
>         sysfs_remove_link(&sup->kobj, buf);
>   err_con_dev:
>         sysfs_remove_link(&link->link_dev.kobj, "consumer");
> @@ -508,7 +508,9 @@ static void devlink_remove_symlinks(struct device
> *dev,
>         sysfs_remove_link(&link->link_dev.kobj, "consumer");
>         sysfs_remove_link(&link->link_dev.kobj, "supplier");
>
> -       len = max(strlen(dev_name(sup)), strlen(dev_name(con)));
> +       len = max(strlen(dev_bus_name(sup)) + strlen(dev_name(sup)),
> +                 strlen(dev_bus_name(con)) + strlen(dev_name(con)));
> +       len += strlen(":");
>         len += strlen("supplier:") + 1;
>         buf = kzalloc(len, GFP_KERNEL);
>         if (!buf) {
> @@ -516,9 +518,9 @@ static void devlink_remove_symlinks(struct device
> *dev,
>                 return;
>         }
>
> -       snprintf(buf, len, "supplier:%s", dev_name(sup));
> +       snprintf(buf, len, "supplier:%s:%s", dev_bus_name(sup),
> dev_name(sup));
>         sysfs_remove_link(&con->kobj, buf);
> -       snprintf(buf, len, "consumer:%s", dev_name(con));
> +       snprintf(buf, len, "consumer:%s:%s", dev_bus_name(sup),
> dev_name(con));
>         sysfs_remove_link(&sup->kobj, buf);
>         kfree(buf);
>   }
>
> With these changes:
>
> Tested-by: Michael Walle <michael@walle.cc>

Greg,

I think it's good to pick up this version if you don't see any issues.

>
> This at least make the warning go away.

Phew!

> BUT, there is somesthing strange or at least I don't get it:
>
> # find /sys/bus/pci/devices/0000:00:00.0/ -name "consumer\:*"
> # find /sys/bus/pci/devices/0000:00:00.1/ -name "consumer\:*"
> /sys/bus/pci/devices/0000:00:00.1/consumer:mdio_bus:0000:00:00.1:04
> /sys/bus/pci/devices/0000:00:00.1/consumer:mdio_bus:0000:00:00.1
>
> enetc0 (0000:00:00.0) has no consumers while enetc1 (0000:00:00.1)
> has ones. Although both have PHYs connected. Here are the
> corresonding device tree entries:
>
> enetc0:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28.dts?h=v5.11-rc2#n81
>
> enetc1:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var4.dts?h=v5.11-rc2#n21
>
> Why is there a link between enetc1 and its PHY (and MDIO bus)
> but not for enetc0?

So a lot of subtle things could be going on here that make it look
like it's not working correctly but it's actually working fine. Since
fw_devlink=permissive is the default mode, all links that are created
are SYNC_STATE_ONLY links. These links are deleted after their
consumers probe. So if you really want to see all the "real" links
persist, try booting with fw_devlink=on. You might have boot issues
though -- I'm working on that separately [1]. Also, SYNC_STATE_ONLY
links can be created between the parent of a consumer and the supplier
(I won't get into the why here) depending on some ordering -- so that
might be causing some spurious looking links, but they aren't.

Another way to do what you are trying to do is to enable the logs in
device_link_add() and look at them to see if all the links are created
as you'd expect.

> btw, here are all links:
>
> # ls /sys/class/devlink/
> pci:0000:00:00.1--mdio_bus:0000:00:00.1
> platform:5000000.iommu--pci:0000:00:00.0
> platform:5000000.iommu--pci:0000:00:00.1
> platform:5000000.iommu--pci:0000:00:00.2
> platform:5000000.iommu--pci:0000:00:00.3
> platform:5000000.iommu--pci:0000:00:00.5
> platform:5000000.iommu--pci:0000:00:00.6
> platform:5000000.iommu--pci:0001:00:00.0
> platform:5000000.iommu--pci:0002:00:00.0
> platform:5000000.iommu--platform:2140000.mmc
> platform:5000000.iommu--platform:2150000.mmc
> platform:5000000.iommu--platform:22c0000.dma-controller
> platform:5000000.iommu--platform:3100000.usb
> platform:5000000.iommu--platform:3110000.usb
> platform:5000000.iommu--platform:3200000.sata
> platform:5000000.iommu--platform:8000000.crypto
> platform:5000000.iommu--platform:8380000.dma-controller
> platform:5000000.iommu--platform:f080000.display
> platform:f1f0000.clock-controller--platform:f080000.display
> regulator:regulator.0--i2c:0-0050
> regulator:regulator.0--i2c:1-0057
> regulator:regulator.0--i2c:2-0050
> regulator:regulator.0--platform:3200000.sata

As you can see, most of the links that fw_devlink created are gone.
Because all the consumers probed. Any remaining ones you see here are
non-SYNC_STATE_ONLY links created by the driver/frameworks or cases
where consumers haven't probed. My guess is that only the first one is
of this criteria and it doesn't hurt anything here. Try booting with
fw_devlink=on and check this list. That'll give you a better idea.

-Saravana
