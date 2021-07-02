Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBD23BA002
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 13:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhGBLuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 07:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231935AbhGBLuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Jul 2021 07:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ED4E61402;
        Fri,  2 Jul 2021 11:48:05 +0000 (UTC)
Date:   Fri, 2 Jul 2021 12:48:02 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Lokesh Gidra <lokeshgidra@google.com>
Cc:     Peter Collingbourne <pcc@google.com>,
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
Subject: Re: [PATCH v2] userfaultfd: preserve user-supplied address tag in
 struct uffd_msg
Message-ID: <20210702114802.GA685@arm.com>
References: <20210630232931.3779403-1-pcc@google.com>
 <20210701155148.GB12484@arm.com>
 <CAMn1gO5SKNOg8Dwf6JxSNaBLuoxDs9Bo9zC+k-20drjd6s47Vg@mail.gmail.com>
 <CA+EESO6wnoBnA5QKTmpWJTvTcAP-2v7pWOBWxdH18GsqCeG9pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EESO6wnoBnA5QKTmpWJTvTcAP-2v7pWOBWxdH18GsqCeG9pQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 01, 2021 at 10:27:31PM -0700, Lokesh Gidra wrote:
> On Thu, Jul 1, 2021 at 10:50 AM Peter Collingbourne <pcc@google.com> wrote:
> > On Thu, Jul 1, 2021 at 8:51 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Wed, Jun 30, 2021 at 04:29:31PM -0700, Peter Collingbourne wrote:
> > > > If a user program uses userfaultfd on ranges of heap memory, it may
> > > > end up passing a tagged pointer to the kernel in the range.start
> > > > field of the UFFDIO_REGISTER ioctl. This can happen when using an
> > > > MTE-capable allocator, or on Android if using the Tagged Pointers
> > > > feature for MTE readiness [1].
> > >
> > > When we added the tagged addr ABI, we realised it's nearly impossible to
> > > sort out all ioctls, so we added a note to the documentation that any
> > > address other than pointer to user structures as arguments to ioctl()
> > > should be untagged. Arguably, userfaultfd is not a random device but if
> > > we place it in the same category as mmap/mremap/brk, those don't allow
> > > tagged pointers either. And we do expect some apps to break when they
> > > rely on malloc() to return untagged pointers.
> >
> > Okay, so arguably another approach would be to make userfaultfd
> > consistent with mmap/mremap/brk and let the UFFDIO_REGISTER fail if
> > given a tagged address.
>
> This approach also seems reasonable. The problem, as things stand
> today, is that UFFDIO_REGISTER doesn't complain when a tagged pointer
> is used to register a memory range. But eventually the returned fault
> address in messages are untagged. If UFFDIO_REGISTER were to fail on
> passing a tagged pointer, then the userspace can address the issue.

On the mmap etc. functions we get an error as a side effect of addr
being larger than TASK_SIZE (unless explicitly untagged). The
userfaultfd_register() function had similar checks but they were relaxed
by commit 7d0325749a6c ("userfaultfd: untag user pointers").

I think we should revert the above, or part of it. We did something
similar for mmap/mremap/brk when untagging the address broke glibc:
commit dcde237319e6 ("mm: Avoid creating virtual address aliases in
brk()/mmap()/mremap()").

-- 
Catalin
