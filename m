Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9741958C5
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 15:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgC0OQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 10:16:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39024 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgC0OQO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 10:16:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id p10so11589431wrt.6;
        Fri, 27 Mar 2020 07:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9wNt2gai8dRVSKQAlV2TOplqX3mifpAWTobUqLn101c=;
        b=inBI3zIMOQoWlxqDdeGv06GRSPaAjKkg26RelATkUJiHTcP9LZQnSO/ULU1nW/atKk
         GKf6/AVfYIuDEf5LyNTh33Tp39tDTnVLptNWdPYKqdZR9wn6MHdCwLJaIGX4oKWqUIUQ
         /J0Sq4xc09A5xL4LU1ZpBdePsC1fztREX3HVdk7Y6dBuDQ34vFmYc8s8v4v09jI6Cb1k
         c735gWJCGxyrXyhVtCL0BVi9Q/t9Q2jcXKwDZZrU6N6oS0DhJS8EOvpFdzvjJ3OvqvMe
         xv8OKLs9MFOkQLrsj7FElzDPCHR4BuBZiWvpsmhGIro1hJKXXmCLsDfS/GPcN9NMsQlJ
         H/9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9wNt2gai8dRVSKQAlV2TOplqX3mifpAWTobUqLn101c=;
        b=Y5aYPCSCC4waSpz7OZPzd6NquDjL/BBNYXLvd8nJlQ1feD0VSQNKfyXyYRWO2WcJw5
         QgX9zw+JxS9JvbObXM86hUYiR06HECKh/2QxVkQmD9NjPt8tOrOLWb1O64n4S/R6f66I
         O0eTRoM8BbRJhGdcvktJByVRH6CDfqvi5tZis8kCEXgF2kSToS42YU5un0P5GBQnfh/e
         dVnIO5TGtJgbgeJ7S0UKoY7klKzSBRGaa7p41KVKFSZHos1eUNHlC5hXdLZuxsICeMhr
         C50Y1ZWdMl6DwZ+CRXhgdKER5qQmOtrT2SMB0Up5yWmTP9PhIjXcmFmEE6lXgT67uQFT
         uSUA==
X-Gm-Message-State: ANhLgQ0+A9EGT1iA7gQoQvmu2dRljZRHlP/i3zByAbcNQ8HhkU2rUZgj
        kWiLJ+WpkJSBEXAwA2Zd7Sxjl1/8TKSqSIZo/5s=
X-Google-Smtp-Source: ADFU+vv/Vh/Usi3RX7zJFDIxkoX6XlRPz6qGaxO2o50FKhqyLTNRGqCUFnkaHDBaoZdAfcbG/1I2SUpXx72SUWSdNGo=
X-Received: by 2002:a5d:6187:: with SMTP id j7mr15924936wru.419.1585318572316;
 Fri, 27 Mar 2020 07:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200327082453eucas1p15b2371b61f653031408f319cc6d13893@eucas1p1.samsung.com>
 <20200327082446.18480-1-m.szyprowski@samsung.com> <CABnpCuDySf89HL2AksMB2fOcVCci+1zgB9r8zjRdpCAH3GWhPA@mail.gmail.com>
 <64025801-10f0-9f28-17b2-2c04d4308ac5@samsung.com> <CABnpCuBUEO6V=hwzHkUEKK5KDXC=ovPrTHyb9zFYrj0KaHHdww@mail.gmail.com>
In-Reply-To: <CABnpCuBUEO6V=hwzHkUEKK5KDXC=ovPrTHyb9zFYrj0KaHHdww@mail.gmail.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Fri, 27 Mar 2020 10:16:01 -0400
Message-ID: <CADnq5_N65tF-b772uJ2E72=Er8JeeX9UZ34PVGqssprHCMGF1g@mail.gmail.com>
Subject: Re: [PATCH] drm/prime: fix extracting of the DMA addresses from a scatterlist
To:     Shane Francis <bigbeeshane@gmail.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        David Airlie <airlied@linux.ie>,
        LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 6:25 AM Shane Francis <bigbeeshane@gmail.com> wrote:
>
> Hello Marek,
>
> On Fri, Mar 27, 2020 at 9:00 AM Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> > > I have tested the above patch against my original issues with amdgpu
> > > and radeon drivers and everything is still working as expected.
> > >
> > > Sorry I missed this in my original patches.
> >
> > No problem. Thanks for testing!
> >
> > Best regards
> > --
> > Marek Szyprowski, PhD
> > Samsung R&D Institute Poland
> >
> Just a thought.
>
> Would it be worth adding some comments to the code to explain why this
> is needed, reading
> the thread around my original patches and the DMA-API documentation it
> is not instantly
> clear why you would be mapping the pages in this way.
>
> Would probably prevent someone in the future making the same mistake I
> did while updating
> this code.

With a comment similar to the commit messaged added to this function,
this patch is:
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

Thanks!

Alex
