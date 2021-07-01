Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CD33B95B0
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 19:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhGARxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 13:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhGARxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 13:53:05 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97859C061762
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 10:50:33 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id s19so7232831ilj.1
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 10:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bUtCNCSFv0Q5SB9VYXY5u8YCjnCEEfFnTcEtPEAHL8Q=;
        b=bgCbu+alLf1tUDTbB+xcqn5OwFwzJ1dg/fgITkgOgWL9zNFtibXJlFDtdNILmNVVGm
         BoAOKjHG+8safXyj5pLKxDGiE4qKY5Xv3Yg62Db4dhFUICFeSP+R7aI42GLb3x2taUl5
         BFcB5se32ckgf6w1ASGcBVRwSRyEXR4OdnaEjls8lX75E4IsI1W6bmuB98E4/Lrw+82O
         00QXHAV9OFIJPNwkc2HB8jY8zaAkXPHbALv8QD3mNhYJtHP+vmVJWiPPXebb8K7YL1FO
         QYfpNiv96hsJyWO+uH6Yrd7j0CRK5mt3zmMrQ3ZvwkPFP9DlsdcczZSDkXU6B2SvhusK
         zRxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bUtCNCSFv0Q5SB9VYXY5u8YCjnCEEfFnTcEtPEAHL8Q=;
        b=kqESgriMmhwR1poEQsGXaMWHYmggcrLqKSnGVky3U0M4lGrXDb27Thy9DemQKycWi9
         +e0xkWZHSR+9ljqLCc3Cawme7fGQ8cF0lFtXAUQ0jp5Vk4wBj/EW8T3tpDTkAiHuVN7Q
         tPorfzIlGK3Av9wSqAYjfDY0b07O0niW6i+fRIBWD03GMsP3Yw7gsJ5UEQ9SznWExDar
         gX3eBPJCqspazxp1uewN1Ulug1xyeM43jyhkkLYeY9fLJRVtfJ93DVXvYwL0rOM7Agi/
         GTRcDeeq8ucoyyziIKa3AKQoVed8LyNz5PQeyAZ1DzgiFVkLq9kIQbDBxE9HBl6seRzx
         1hEg==
X-Gm-Message-State: AOAM533cBBYBq57jWJadlP41cwnI7QRKT4iIRA5iuDo7WmVa6PLx84uS
        j3VHl5KVhHncmDb7xh23/LLJCJ6u5kAZxZW4jQ1qoQ==
X-Google-Smtp-Source: ABdhPJw3vT0UxSMOsFnHHqOVPGuwb02X5x4u1fJ9zS+ari8IkyQdbI/IvMHRsVs3x7QFwxsNWucOCWD6EHRv03EYErM=
X-Received: by 2002:a05:6e02:c2e:: with SMTP id q14mr464641ilg.2.1625161832735;
 Thu, 01 Jul 2021 10:50:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210630232931.3779403-1-pcc@google.com> <20210701155148.GB12484@arm.com>
In-Reply-To: <20210701155148.GB12484@arm.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Thu, 1 Jul 2021 10:50:21 -0700
Message-ID: <CAMn1gO5SKNOg8Dwf6JxSNaBLuoxDs9Bo9zC+k-20drjd6s47Vg@mail.gmail.com>
Subject: Re: [PATCH v2] userfaultfd: preserve user-supplied address tag in
 struct uffd_msg
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Alistair Delva <adelva@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
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

On Thu, Jul 1, 2021 at 8:51 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> Hi Peter,
>
> On Wed, Jun 30, 2021 at 04:29:31PM -0700, Peter Collingbourne wrote:
> > If a user program uses userfaultfd on ranges of heap memory, it may
> > end up passing a tagged pointer to the kernel in the range.start
> > field of the UFFDIO_REGISTER ioctl. This can happen when using an
> > MTE-capable allocator, or on Android if using the Tagged Pointers
> > feature for MTE readiness [1].
>
> When we added the tagged addr ABI, we realised it's nearly impossible to
> sort out all ioctls, so we added a note to the documentation that any
> address other than pointer to user structures as arguments to ioctl()
> should be untagged. Arguably, userfaultfd is not a random device but if
> we place it in the same category as mmap/mremap/brk, those don't allow
> tagged pointers either. And we do expect some apps to break when they
> rely on malloc() to return untagged pointers.

Okay, so arguably another approach would be to make userfaultfd
consistent with mmap/mremap/brk and let the UFFDIO_REGISTER fail if
given a tagged address.

> > When a fault subsequently occurs, the tag is stripped from the fault
> > address returned to the application in the fault.address field
> > of struct uffd_msg. However, from the application's perspective,
> > the tagged address *is* the memory address, so if the application
> > is unaware of memory tags, it may get confused by receiving an
> > address that is, from its point of view, outside of the bounds of the
> > allocation. We observed this behavior in the kselftest for userfaultfd
> > [2] but other applications could have the same problem.
>
> Just curious, what's generating the tagged pointers in the kselftest? Is
> it posix_memalign()?

Yes, on Android that call goes into our allocator which returns the
tagged pointer.

> > Fix this by remembering which tag was used to originally register the
> > userfaultfd and passing that tag back in fault.address. In a future
> > enhancement, we may want to pass back the original fault address,
> > but like SA_EXPOSE_TAGBITS, this should be guarded by a flag.
>
> I don't see exposing the tagged fault address vs making up a tag (from
> the original request) that different. I find the former cleaner from an
> ABI perspective, though it's a bit more intrusive to pass the tagged
> address via handle_mm_fault().
>
> My preference is to fix this in user-space entirely, by explicit
> untagging of the malloc'ed pointer either before being passed to
> userfaultfd or when handling the userfaultfd message. How common is it
> for apps to register malloc'ed pointers with userfaultfd? I was hoping
> that's more of an (anonymous) mmap() play.

At least we haven't seen any apps do this so far, and the tagged
pointers feature has been in Android since last year's Android 11
release. So maybe we can say this is uncommon enough that we can just
let userspace handle this. So we would do:

1. Forbid tagged pointers in the ioctl as mentioned above.
2. Fix the kselftest (e.g. by untagging the pointer, or making it use
mmap). A fix would probably be needed here anyway because we noticed
that the test is later passing a tagged heap pointer to mremap (and
failing).

I'd be okay with this approach but I'd first like to hear from
Alistair and/or Lokesh since I think they favored the approach in my
patch.

Peter
