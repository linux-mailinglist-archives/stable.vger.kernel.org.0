Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48B52F0216
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 18:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbhAIRKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 12:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbhAIRKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 12:10:50 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7A7C061786
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 09:10:10 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id b64so12600034ybg.7
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 09:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EL3usNsR6RJ/kaN0gX4dE0zjZk+adUFE1G3dRPjGzc4=;
        b=pvdQP6wQkmLKyKoYbBICYKmMe81Lh1oUOvgaduNtneTY4/Dw9v7yK3RuKYojT7mPE6
         dFAN3j0PWoI7ZliFe1xz6xiBR/Qy0kLkAQnbsI05LC9pWOcfvg8/GBxE/JEs7sgn+9DH
         h7ou9N+XOh3i+Zo+BR0lz5Z28ovaX4PK45UOgwpcoBtpSfxuUHMk2El22tndLV6MdghH
         G/7n3iPQOnPVDjldgLXeOE+EslcU8Ch3eeswEwLOBjJYKvmVBthWxJLLYz5hzFxkV1rh
         +EFteDKsqKscftKsKcAqpJqAGCIUtKlVvOvHVg88tdFA2A4+Id/r7Au6bGGts2uqN2NS
         Lkaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EL3usNsR6RJ/kaN0gX4dE0zjZk+adUFE1G3dRPjGzc4=;
        b=mEB2T/fGjakk/01AMje1bhx2GWgfqJGJg3rGR519PmOsfHe6FQWB0K7xI/+BcqL13m
         ft5C7Q9UzHApR+sj8cgjma53YNvtZLHxCqnCO8qMGBoNSlrEch9fCsccpUqLpO7/2riU
         wjh7/bhBQ/Ud4HfA7X7qHBe6H4qUikdtKz33aMlPVkT/qjkVcDTIYid8/1IXAIvqwd9O
         MzSwC7Rs4n3aXb6jviA8jKsGdq6Pc9YB0bwLekEmzEolTByqo+ashfhVr4ZQ/efKifEW
         9pToIfi2gEzXKWFBlhf26ogQnBiWA9FflmZMOD8nQ4LJRfzptrPAs1uRYsi/kvdhn5JA
         P71g==
X-Gm-Message-State: AOAM5314LpSABMyJZn2v64n6MrjB9ADu99qy46ocBsxsD5WINS2Os9P6
        N7fKh8eAdt4T+IPol+CGUwoqg1vRE1BYOennKnTZulyqsBgCxQ==
X-Google-Smtp-Source: ABdhPJxHs5vAL9PG0BmAfRSJClqSNUC3Mz6HmKJcNj/c05dWYJWnw0Eok1hSeNWBJjU6gd7mOhnDHRZgdM91tl+VTx8=
X-Received: by 2002:a25:2506:: with SMTP id l6mr14836274ybl.32.1610212209019;
 Sat, 09 Jan 2021 09:10:09 -0800 (PST)
MIME-Version: 1.0
References: <20210108012427.766318-1-saravanak@google.com> <9ec99f2f0e1e75e11f2d7d013dc78203@walle.cc>
 <CAGETcx-TT=ce+oSV2miKN5YdO-gY1oqCMVBkgs6D4kfFLpyn1w@mail.gmail.com> <7f10c6c94729dfa48e18f7f4b038403a@walle.cc>
In-Reply-To: <7f10c6c94729dfa48e18f7f4b038403a@walle.cc>
From:   Saravana Kannan <saravanak@google.com>
Date:   Sat, 9 Jan 2021 09:09:32 -0800
Message-ID: <CAGETcx-FAaBRLxLS8_s65VHi6S1MF3RZHw5A5RkQ=eikZuMBtA@mail.gmail.com>
Subject: Re: [PATCH v3] driver core: Fix device link device name collision
To:     Michael Walle <michael@walle.cc>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 9, 2021 at 8:49 AM Michael Walle <michael@walle.cc> wrote:
>
> Am 2021-01-08 18:22, schrieb Saravana Kannan:
> > On Fri, Jan 8, 2021 at 12:16 AM Michael Walle <michael@walle.cc> wrote:
> >>
> >> Am 2021-01-08 02:24, schrieb Saravana Kannan:
> >> > The device link device's name was of the form:
> >> > <supplier-dev-name>--<consumer-dev-name>
> >> >
> >> > This can cause name collision as reported here [1] as device names are
> >> > not globally unique. Since device names have to be unique within the
> >> > bus/class, add the bus/class name as a prefix to the device names used
> >> > to
> >> > construct the device link device name.
> >> >
> >> > So the devuce link device's name will be of the form:
> >> > <supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>
> >> >
> >> > [1] -
> >> > https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/
> >> >
> >> > Cc: stable@vger.kernel.org
> >> > Fixes: 287905e68dd2 ("driver core: Expose device link details in
> >> > sysfs")
> >> > Reported-by: Michael Walle <michael@walle.cc>
> >> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> >> > ---
> >> [..]
> >>
> >> The changes are missing for the error path and
> >> devlink_remove_symlinks(),
> >> right?
> >
> > Removing symlinks doesn't need the name. Just needs the "handle". So
> > we are good there.
>
> I don't get it. What is the "handle"? Without the patch below
> kernfs_remove_by_name() in sysfs_remove_link will return -ENOENT. With
> the patch it will return 0.
>
> And even if it would work, how is this even logical:

Ah sorry, I confused it with removing device attrs. I need to fix up
the symlink remove path.

>
>         snprintf(buf, len, "consumer:%s:%s", dev_bus_name(con), dev_name(con));
>         ret = sysfs_create_link(&sup->kobj, &link->link_dev.kobj, buf);
>         if (ret)
>                 goto err_con_dev;
>         snprintf(buf, len, "supplier:%s:%s", dev_bus_name(sup), dev_name(sup));
>         ret = sysfs_create_link(&con->kobj, &link->link_dev.kobj, buf);
>         if (ret)
>                 goto err_sup_dev;
> [..]
> err_sup_dev:
>         snprintf(buf, len, "consumer:%s", dev_name(con));
>         sysfs_remove_link(&sup->kobj, buf);
>
> You call sysfs_create_link("consumer:bus_name:dev_name") but the
> corresponding rollback is sysfs_remove_link("consumer:dev_name"), that
> is super confusing.
>
> >> diff --git a/drivers/base/core.c b/drivers/base/core.c
> >> index 4140a69dfe18..385e16d92874 100644
> >> --- a/drivers/base/core.c
> >> +++ b/drivers/base/core.c
> >> @@ -485,7 +485,7 @@ static int devlink_add_symlinks(struct device
> >> *dev,
> >>         goto out;
> >>
> >>   err_sup_dev:
> >> -       snprintf(buf, len, "consumer:%s", dev_name(con));
> >> +       snprintf(buf, len, "consumer:%s:%s", dev_bus_name(con),
> >> dev_name(con));
> >>         sysfs_remove_link(&sup->kobj, buf);
> >>   err_con_dev:
> >>         sysfs_remove_link(&link->link_dev.kobj, "consumer");
> >> @@ -508,7 +508,9 @@ static void devlink_remove_symlinks(struct device
> >> *dev,
> >>         sysfs_remove_link(&link->link_dev.kobj, "consumer");
> >>         sysfs_remove_link(&link->link_dev.kobj, "supplier");
> >>
> >> -       len = max(strlen(dev_name(sup)), strlen(dev_name(con)));
> >> +       len = max(strlen(dev_bus_name(sup)) + strlen(dev_name(sup)),
> >> +                 strlen(dev_bus_name(con)) + strlen(dev_name(con)));
> >> +       len += strlen(":");
> >>         len += strlen("supplier:") + 1;
> >>         buf = kzalloc(len, GFP_KERNEL);
> >>         if (!buf) {
> >> @@ -516,9 +518,9 @@ static void devlink_remove_symlinks(struct device
> >> *dev,
> >>                 return;
> >>         }
> >>
> >> -       snprintf(buf, len, "supplier:%s", dev_name(sup));
> >> +       snprintf(buf, len, "supplier:%s:%s", dev_bus_name(sup),
> >> dev_name(sup));
> >>         sysfs_remove_link(&con->kobj, buf);
> >> -       snprintf(buf, len, "consumer:%s", dev_name(con));
> >> +       snprintf(buf, len, "consumer:%s:%s", dev_bus_name(sup),
> >> dev_name(con));

Ah I completely skimmed over this code thinking it was code from my
patch. Like I said, I was struggling with the length of the email due
to the logs. Anyway, I'll fix up the remove symlink path too. Thanks
for catching that.

> btw this should be dev_bus_name(con).
>
> >>         sysfs_remove_link(&sup->kobj, buf);
> >>         kfree(buf);
> >>   }
> >>
> >> With these changes:
> >>
> >> Tested-by: Michael Walle <michael@walle.cc>
> >
> > Greg,
> >
> > I think it's good to pick up this version if you don't see any issues.
>
> Why so fast?

Sorry, didn't mean to rush. I was just trying to say I wasn't planning
on a v4 because I thought your Tested-by was for my unchanged v4, but
clearly I need to send a v4.

-Saravana
