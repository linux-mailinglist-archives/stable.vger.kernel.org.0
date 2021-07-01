Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6C53B944D
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 17:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbhGAPyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 11:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233239AbhGAPyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Jul 2021 11:54:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ECE661413;
        Thu,  1 Jul 2021 15:51:51 +0000 (UTC)
Date:   Thu, 1 Jul 2021 16:51:49 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Peter Collingbourne <pcc@google.com>
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
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] userfaultfd: preserve user-supplied address tag in
 struct uffd_msg
Message-ID: <20210701155148.GB12484@arm.com>
References: <20210630232931.3779403-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630232931.3779403-1-pcc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Peter,

On Wed, Jun 30, 2021 at 04:29:31PM -0700, Peter Collingbourne wrote:
> If a user program uses userfaultfd on ranges of heap memory, it may
> end up passing a tagged pointer to the kernel in the range.start
> field of the UFFDIO_REGISTER ioctl. This can happen when using an
> MTE-capable allocator, or on Android if using the Tagged Pointers
> feature for MTE readiness [1].

When we added the tagged addr ABI, we realised it's nearly impossible to
sort out all ioctls, so we added a note to the documentation that any
address other than pointer to user structures as arguments to ioctl()
should be untagged. Arguably, userfaultfd is not a random device but if
we place it in the same category as mmap/mremap/brk, those don't allow
tagged pointers either. And we do expect some apps to break when they
rely on malloc() to return untagged pointers.

> When a fault subsequently occurs, the tag is stripped from the fault
> address returned to the application in the fault.address field
> of struct uffd_msg. However, from the application's perspective,
> the tagged address *is* the memory address, so if the application
> is unaware of memory tags, it may get confused by receiving an
> address that is, from its point of view, outside of the bounds of the
> allocation. We observed this behavior in the kselftest for userfaultfd
> [2] but other applications could have the same problem.

Just curious, what's generating the tagged pointers in the kselftest? Is
it posix_memalign()?

> Fix this by remembering which tag was used to originally register the
> userfaultfd and passing that tag back in fault.address. In a future
> enhancement, we may want to pass back the original fault address,
> but like SA_EXPOSE_TAGBITS, this should be guarded by a flag.

I don't see exposing the tagged fault address vs making up a tag (from
the original request) that different. I find the former cleaner from an
ABI perspective, though it's a bit more intrusive to pass the tagged
address via handle_mm_fault().

My preference is to fix this in user-space entirely, by explicit
untagging of the malloc'ed pointer either before being passed to
userfaultfd or when handling the userfaultfd message. How common is it
for apps to register malloc'ed pointers with userfaultfd? I was hoping
that's more of an (anonymous) mmap() play.

-- 
Catalin
