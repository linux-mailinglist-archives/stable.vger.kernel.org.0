Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7E13BFACB
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 14:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhGHNB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 09:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231755AbhGHNB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 09:01:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D433D61585;
        Thu,  8 Jul 2021 12:58:44 +0000 (UTC)
Date:   Thu, 8 Jul 2021 13:58:42 +0100
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
        linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] userfaultfd: do not untag user pointers
Message-ID: <20210708125841.GA9966@arm.com>
References: <20210707184313.3697385-1-pcc@google.com>
 <20210707184313.3697385-2-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707184313.3697385-2-pcc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 07, 2021 at 11:43:12AM -0700, Peter Collingbourne wrote:
> If a user program uses userfaultfd on ranges of heap memory, it may
> end up passing a tagged pointer to the kernel in the range.start
> field of the UFFDIO_REGISTER ioctl. This can happen when using an
> MTE-capable allocator, or on Android if using the Tagged Pointers
> feature for MTE readiness [1].
> 
> When a fault subsequently occurs, the tag is stripped from the fault
> address returned to the application in the fault.address field
> of struct uffd_msg. However, from the application's perspective,
> the tagged address *is* the memory address, so if the application
> is unaware of memory tags, it may get confused by receiving an
> address that is, from its point of view, outside of the bounds of the
> allocation. We observed this behavior in the kselftest for userfaultfd
> [2] but other applications could have the same problem.
> 
> Address this by not untagging pointers passed to the userfaultfd
> ioctls. Instead, let the system call fail. This will provide an
> early indication of problems with tag-unaware userspace code instead
> of letting the code get confused later, and is consistent with how
> we decided to handle brk/mmap/mremap in commit dcde237319e6 ("mm:
> Avoid creating virtual address aliases in brk()/mmap()/mremap()"),
> as well as being consistent with the existing tagged address ABI
> documentation relating to how ioctl arguments are handled.
> 
> The code change is a revert of commit 7d0325749a6c ("userfaultfd:
> untag user pointers") plus some fixups to some additional calls to
> validate_range that have appeared since then.
> 
> [1] https://source.android.com/devices/tech/debug/tagged-pointers
> [2] tools/testing/selftests/vm/userfaultfd.c
> 
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
> Link: https://linux-review.googlesource.com/id/I761aa9f0344454c482b83fcfcce547db0a25501b
> Fixes: 63f0c6037965 ("arm64: Introduce prctl() options to control the tagged user addresses ABI")
> Cc: <stable@vger.kernel.org> # 5.4

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
