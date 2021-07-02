Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB563B9C04
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 07:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhGBFaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 01:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhGBFaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 01:30:17 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DC2C061762
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 22:27:44 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id j11so11566257edq.6
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 22:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l/CIfqGMmjYIsCzgr4AvzqUzXutEUTgHW7yZaII2nIc=;
        b=sMNxBgq6p8MYGYAzAdYHbTmZibqW4zuor+kGn8hkHguS73laLOeEzc/nKzBGZ/jY6V
         vmUpnTZqb8hDh+DVIkV5sXrURrJXRMXMZQWz1XL0hWPey5nCE537BjLl4USu/wdrxhLg
         sAxwU+9XDGZxVo6NAYFSkGKbBOr+KZZDXml/jMEayVacVgbKgOZ2QLKLW3aKY3Zx8RkR
         6tmSGoryjw7lwbyTynz3bfKgFEWoo8U0IdRPACuFy0fSGpz4ZqqDVviku7f7eSYYNqTu
         or33zxc6BjrxQYJCwLtKGkijqVZBAp1O+WJA9Hai/knZ8ev6rjcS4BGDng2Ka3j5NR8K
         TvPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l/CIfqGMmjYIsCzgr4AvzqUzXutEUTgHW7yZaII2nIc=;
        b=LfDYklK3DvVZGcxnWwq1b62mlz3YtV1jCjLO8UdEeL2DzjOQgfB1sPlto54zuSAm9e
         F3Dv13sd3D3utZD4bRFSpAIyUiRS7rIkbDcMloV2PIsRObVJjlUY9h8J0OTCNO3/vgav
         xkZHdIHSuDX+eNVpl+CdBK63x5dgBWBrXx0IDvQpAm42lwlveOwoWQu5wwdK0aDMmjnN
         jA65mLHPjlyGM/eU036/WLBsgTUogsMqSuhUqceJ6v4H5pWWwbKxOdzuxiZ8FT62429Z
         2xuTKKRZcfi0MNgnpMiedWyKXwQhalqCNZFlNCGa1O054EAw8twyjQOkAmW9MKW6eDwO
         vRSA==
X-Gm-Message-State: AOAM53260xk/I2OJegEz4rnAScYKqIX04+Zmzn6vDKnDzumtep6qt9mV
        cGmtcpeSIoZDf6fHch6xspogKX8ShmFB4FPp0TEkFw==
X-Google-Smtp-Source: ABdhPJzjfweoX/ejiqTW+J0NDOoQ3ivS/uibkApN9c3w09DsiOLqtcNArbaOUNc7jNRZTbVeNIcyjateo9yoVGWgWZM=
X-Received: by 2002:a05:6402:312d:: with SMTP id dd13mr4489155edb.140.1625203663084;
 Thu, 01 Jul 2021 22:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210630232931.3779403-1-pcc@google.com> <20210701155148.GB12484@arm.com>
 <CAMn1gO5SKNOg8Dwf6JxSNaBLuoxDs9Bo9zC+k-20drjd6s47Vg@mail.gmail.com>
In-Reply-To: <CAMn1gO5SKNOg8Dwf6JxSNaBLuoxDs9Bo9zC+k-20drjd6s47Vg@mail.gmail.com>
From:   Lokesh Gidra <lokeshgidra@google.com>
Date:   Thu, 1 Jul 2021 22:27:31 -0700
Message-ID: <CA+EESO6wnoBnA5QKTmpWJTvTcAP-2v7pWOBWxdH18GsqCeG9pQ@mail.gmail.com>
Subject: Re: [PATCH v2] userfaultfd: preserve user-supplied address tag in
 struct uffd_msg
To:     Peter Collingbourne <pcc@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Alistair Delva <adelva@google.com>,
        William McVicker <willmcvicker@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Mitch Phillips <mitchp@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 1, 2021 at 10:50 AM Peter Collingbourne <pcc@google.com> wrote:
>
> On Thu, Jul 1, 2021 at 8:51 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > Hi Peter,
> >
> > On Wed, Jun 30, 2021 at 04:29:31PM -0700, Peter Collingbourne wrote:
> > > If a user program uses userfaultfd on ranges of heap memory, it may
> > > end up passing a tagged pointer to the kernel in the range.start
> > > field of the UFFDIO_REGISTER ioctl. This can happen when using an
> > > MTE-capable allocator, or on Android if using the Tagged Pointers
> > > feature for MTE readiness [1].
> >
> > When we added the tagged addr ABI, we realised it's nearly impossible to
> > sort out all ioctls, so we added a note to the documentation that any
> > address other than pointer to user structures as arguments to ioctl()
> > should be untagged. Arguably, userfaultfd is not a random device but if
> > we place it in the same category as mmap/mremap/brk, those don't allow
> > tagged pointers either. And we do expect some apps to break when they
> > rely on malloc() to return untagged pointers.
>
> Okay, so arguably another approach would be to make userfaultfd
> consistent with mmap/mremap/brk and let the UFFDIO_REGISTER fail if
> given a tagged address.
>
This approach also seems reasonable. The problem, as things stand
today, is that UFFDIO_REGISTER doesn't complain when a tagged pointer
is used to register a memory range. But eventually the returned fault
address in messages are untagged. If UFFDIO_REGISTER were to fail on
passing a tagged pointer, then the userspace can address the issue.

> > > When a fault subsequently occurs, the tag is stripped from the fault
> > > address returned to the application in the fault.address field
> > > of struct uffd_msg. However, from the application's perspective,
> > > the tagged address *is* the memory address, so if the application
> > > is unaware of memory tags, it may get confused by receiving an
> > > address that is, from its point of view, outside of the bounds of the
> > > allocation. We observed this behavior in the kselftest for userfaultfd
> > > [2] but other applications could have the same problem.
> >
> > Just curious, what's generating the tagged pointers in the kselftest? Is
> > it posix_memalign()?
>
> Yes, on Android that call goes into our allocator which returns the
> tagged pointer.
>
> > > Fix this by remembering which tag was used to originally register the
> > > userfaultfd and passing that tag back in fault.address. In a future
> > > enhancement, we may want to pass back the original fault address,
> > > but like SA_EXPOSE_TAGBITS, this should be guarded by a flag.
> >
> > I don't see exposing the tagged fault address vs making up a tag (from
> > the original request) that different. I find the former cleaner from an
> > ABI perspective, though it's a bit more intrusive to pass the tagged
> > address via handle_mm_fault().
> >
> > My preference is to fix this in user-space entirely, by explicit
> > untagging of the malloc'ed pointer either before being passed to
> > userfaultfd or when handling the userfaultfd message. How common is it
> > for apps to register malloc'ed pointers with userfaultfd? I was hoping
> > that's more of an (anonymous) mmap() play.

I think it is very unlikely for someone to use malloc'ed pointers with
userfaultfd.

>
> At least we haven't seen any apps do this so far, and the tagged
> pointers feature has been in Android since last year's Android 11
> release. So maybe we can say this is uncommon enough that we can just
> let userspace handle this. So we would do:
>
> 1. Forbid tagged pointers in the ioctl as mentioned above.
> 2. Fix the kselftest (e.g. by untagging the pointer, or making it use
> mmap). A fix would probably be needed here anyway because we noticed
> that the test is later passing a tagged heap pointer to mremap (and
> failing).

The plan looks good to me. Using mmap (instead of posix_memalign)
seems like a cleaner fix to the kselftest as compared to untagging the
pointer everywhere.
>
> I'd be okay with this approach but I'd first like to hear from
> Alistair and/or Lokesh since I think they favored the approach in my
> patch.
>
> Peter
