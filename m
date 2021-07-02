Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADFC3BA275
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 17:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhGBPEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 11:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhGBPEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 11:04:43 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE6FC061762;
        Fri,  2 Jul 2021 08:02:10 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id g5so8394081iox.11;
        Fri, 02 Jul 2021 08:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ESnv5VltIcws9DNfVOo0LCJ9MunPT869dSHDL/9jQk=;
        b=MW8SyPAkGlNMj/7lTIXQI54JdRINXm54t8virqWSj8TBq1OzjoaLeIBhKE4poR0TqK
         2zgXO7G1NxOoKeB4ykAsoqT1xhG8M6b2FcMddg01P0zt0oRasIebhD9c6gbJ+ks6Gyj2
         DMIWNURi83YlaX+8ZbhoSMFZ4lCj78fpYs+iFXKqG3pGBTdZ9bc8aoqfAFGsG4kiva/D
         w7U1CEEAtzstg5BgFveRnkcbk7NTP6uUrAVR0rQFvdNMXK8j4pTo0HsrjOaeB0tsy/9Z
         Dr6vV5V9vE/gY1wtHPs5TYPMbj/PTov+IGq0Z9lgVdo3XVFCJdUWOpFym63t/uztt0/s
         yCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ESnv5VltIcws9DNfVOo0LCJ9MunPT869dSHDL/9jQk=;
        b=XTPy7Qv5Ygrph0HhggEZA181Peymz45A1zrBMn+nkHm8aImKA7GPAx/YurGhmkIUVm
         xDWw2vKjzPa1Je+s7Zu8+6uBlPdht+gQPq+eVJ7jk2GlBQM7H+iyJwhxPFPbcubuvrBd
         FXXYPI8K7eLytM0Cds+yvbqs+TanvhR/7NO3vtUEDAIxUgG5f6H6SdcFMrLeyOj0T4xC
         3jcpHUFptPfaJfh5QjooTfDcvE9fqLkxRDELEfDbhUgKFfy7QjU3zoRkLneeCe7GfJsI
         ZsJ+9cq/Evw55/6N93x1RQzNEtWFtcS9l6DmPViHx9JQAfYPFOcXOQzLvMy724j0fuWu
         7a2w==
X-Gm-Message-State: AOAM530++920/mVY+vtKTOi3GHHNwedPyZkCnFqPENgrnkixfjcesRZV
        eYOlGFpWAGTz/Sym/5GgRV1eTtDHpTJyDufekW0=
X-Google-Smtp-Source: ABdhPJymjpTCbVqbwJKHZL55yBj4hfNpFvH9autX0ylNKZMkjmtHSyFnxvTzNhTu5jrzDtq6Q/gwKAO8DgZCB7+Crpw=
X-Received: by 2002:a6b:f81a:: with SMTP id o26mr377544ioh.68.1625238129618;
 Fri, 02 Jul 2021 08:02:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210603171507.22514-1-andrew_gabbasov@mentor.com> <20210604110503.GA23002@vmlxhi-102.adit-jv.com>
In-Reply-To: <20210604110503.GA23002@vmlxhi-102.adit-jv.com>
From:   Macpaul Lin <macpaul@gmail.com>
Date:   Fri, 2 Jul 2021 23:01:57 +0800
Message-ID: <CACCg+XO+D+2SWJq0C=_sWXj53L1fh-wra8dmCb3VQ4bYCZQryA@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: f_fs: Fix setting of device and driver data cross-references
To:     Eugeniu Rosca <erosca@de.adit-jv.com>, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Eugeniu Rosca <erosca@de.adit-jv.com> wrote:
>
> Hello,
>
> On Thu, Jun 03, 2021 at 12:15:07PM -0500, Andrew Gabbasov wrote:
> > FunctionFS device structure 'struct ffs_dev' and driver data structure
> > 'struct ffs_data' are bound to each other with cross-reference pointers
> > 'ffs_data->private_data' and 'ffs_dev->ffs_data'. While the first one
> > is supposed to be valid through the whole life of 'struct ffs_data'
> > (and while 'struct ffs_dev' exists non-freed), the second one is cleared
> > in 'ffs_closed()' (called from 'ffs_data_reset()' or the last
> > 'ffs_data_put()'). This can be called several times, alternating in
> > different order with 'ffs_free_inst()', that, if possible, clears
> > the other cross-reference.
> >

[Skip some comment...]

> I confirm there are at least two KASAN use-after-free issues
> consistently/100% reproducible on v5.13-rc4-88-gf88cd3fb9df2:
>
> https://gist.github.com/erosca/b5976a96789e574b319cb9e076938b5c
> https://gist.github.com/erosca/4ded55ed32f0133bc2f4ccfe821c7776
>
> These two can no longer be seen after the patch is applied.
>
> In addition, below static analysis tools did not spot any regressions:
> cppcheck 2.4, smatch v0.5.0-7445-g58776ae33ae8, make W=1, coccicheck
>
> Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
>
> --
> Best regards,
> Eugeniu Rosca

It like there is similar issue on kernel-4.14 reported by our customer
(Android).
The back trace are similar.
It looks like this patch has fixed issue existed in earlier kernels.
Could Engeniu and Andrew help to comment if this fix is suggested to be pick to
stable-tree? I've tried to port it onto kernel-4.14, kernel-4.19, and
kernel-5.10.
But it seems there is some revise work to do.
If the origin issue affect multiple LTS kernel versions, then it will
be better to be
cherry-pick to stable-tree after it has been merged.
Thanks!

-- 
Best regards,
Macpaul Lin
