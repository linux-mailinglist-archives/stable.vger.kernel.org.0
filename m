Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3624F4005EC
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 21:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238632AbhICTjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 15:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhICTjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 15:39:40 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C735C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 12:38:40 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id x27so388636lfu.5
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 12:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CpWTZXeHQgxI0FRIsXgHMKOEiigtxEoeHddO3FWKGkk=;
        b=UhpAzgv7FchR19cnMXHoZ7cPsnwbRuML2DSSZEKXlKbP9d7Uh/q51lYN6dicMfTSUV
         dMV18+ZxBaPhTEDxtpW7QeKdKnIGoeQPq4sChmtUxnlLdNqoFJI2YqFqgG0EvaVH4Khl
         cQjGnPEclgybXcLpQg8op5cyqaW6q3ph7e4SmGdI2glcrgPorTq5EcfSXhONcxrAT9EV
         SVUaIelOgjBRpSAzTjutRcpIv1HmjzTs7O/hqvPSmsGQOjEwyuWWlW6theTjv4gHo0vi
         IINnLytwUQXvyKA3KgzPZHFbroL39slzKCL2Gv5DbeUdMQTO5Hn1r6ANYcmcwc0drL1+
         RszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CpWTZXeHQgxI0FRIsXgHMKOEiigtxEoeHddO3FWKGkk=;
        b=dsy6+6mwliRfRP4JFEZSZoZ/ttEoeQ2iZrmGXY6QyZHak/Xc00YSv81wv3hsXXgs2w
         HgUbDcyO3zt1+ONLHTGJjjpr1E2vuV+Oz6IIuvLLge9GpjFPTskmN/Tz5Kesdhwt1vd1
         X8z1YLC38t/OFZAbpDSqN6+UehcnSRV5ojcURDWeLCllDeXXBT/gwXSmBKSz3BfhwJYE
         8HuqPKN/Y8gqnN7EfwodyDsRfr+l/DXOJA5CaWZ1EdtKGXZu0BTtiQF6q7lHEKhyWd+L
         bBjRE8twygdqgwxpekwoXE7yrhnoXp94K9tgDAh9lzntYL+1F7c1w+KvOqY34OUAJd+d
         6k5Q==
X-Gm-Message-State: AOAM532tN/61uZGkiBk8DClfr2yx+c5KYb6QbiIBrd1UE8Lmetj5UuVj
        1QUQpUVjsSU3Xw8cJr5xeiUB+p4ZJ0iZ4DEiMtOCAg==
X-Google-Smtp-Source: ABdhPJzkMAwSm7ZOxAvX4qFCxpAR1VwRIYhxMiWpd1Z1azE/6kQNcFOVD1E07Ac/XUYd7vyLyUM9+oeka9mxK+cVk5k=
X-Received: by 2002:a05:6512:11e8:: with SMTP id p8mr386145lfs.682.1630697918128;
 Fri, 03 Sep 2021 12:38:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210830195146.587206-1-tkjos@google.com> <CAB0TPYFmUgPTONABLTJAdonK7fY7oqURKCpLp1-WqHLtyen7Zw@mail.gmail.com>
 <CAHRSSExONtUFu0Mb8uJeVKcyDYb8=1PO7a=aQ=DUEpA5kAcTQA@mail.gmail.com> <20210903080617.GA1957@kadam>
In-Reply-To: <20210903080617.GA1957@kadam>
From:   Todd Kjos <tkjos@google.com>
Date:   Fri, 3 Sep 2021 12:38:26 -0700
Message-ID: <CAHRSSEyDDmGRrc_paxJ2-Gkx=qMhKKhTr_Mpj-DiL8L1gcm5VA@mail.gmail.com>
Subject: Re: [PATCH] binder: make sure fd closes complete
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Martijn Coenen <maco@android.com>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Martijn Coenen <maco@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        kernel-team@android.com, Christian Brauner <christian@brauner.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 3, 2021 at 1:06 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Thu, Sep 02, 2021 at 08:35:35AM -0700, Todd Kjos wrote:
> > On Tue, Aug 31, 2021 at 12:24 AM Martijn Coenen <maco@android.com> wrote:
> > >
> > > On Mon, Aug 30, 2021 at 9:51 PM 'Todd Kjos' via kernel-team
> > > <kernel-team@android.com> wrote:
> > > >
> > > > During BC_FREE_BUFFER processing, the BINDER_TYPE_FDA object
> > > > cleanup may close 1 or more fds. The close operations are
> > > > completed using the task work mechanism -- which means the thread
> > > > needs to return to userspace or the file object may never be
> > > > dereferenced -- which can lead to hung processes.
> > > >
> > > > Force the binder thread back to userspace if an fd is closed during
> > > > BC_FREE_BUFFER handling.
> > > >
> > > > Signed-off-by: Todd Kjos <tkjos@google.com>
> > > Reviewed-by: Martijn Coenen <maco@android.com>
> >
> > Please also add to stable releases 5.4 and later.
>
> It would be better if this had a fixes tag so we knew which is the first
> buggy commit.
>
> There was a long Project Zero article about the Bad Binder exploit
> because commit f5cb779ba163 ("ANDROID: binder: remove waitqueue when
> thread exits.") was marked as # 4.14 but it didn't have a Fixes tag and
> the actual buggy commit was in 4.9.

Good point Dan. I should have included a Fixes tag. Here is the tag
(issue introduced in 4.20):

Fixes: 80cd795630d6 ("binder: fix use-after-free due to ksys_close()
during fdget()")

Greg- would you like me to send a v2 with the Fixes tag and CC'ing
stable appropriately?

>
> regards,
> dan carpenter
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
