Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA801A81BE
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 17:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437077AbgDNPM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 11:12:58 -0400
Received: from foss.arm.com ([217.140.110.172]:57920 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437512AbgDNPMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 11:12:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E2E930E;
        Tue, 14 Apr 2020 08:12:51 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.30.4])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0BBC83F73D;
        Tue, 14 Apr 2020 08:12:49 -0700 (PDT)
Date:   Tue, 14 Apr 2020 16:12:47 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] arm64: vdso: don't free unallocated pages
Message-ID: <20200414151247.GJ2486@C02TD0UTHF1T.local>
References: <20200414104252.16061-1-mark.rutland@arm.com>
 <20200414104252.16061-2-mark.rutland@arm.com>
 <c5596228-2685-abb3-5ab1-9519759e1f7a@arm.com>
 <20200414132751.GF2486@C02TD0UTHF1T.local>
 <8681c958-0fd9-130e-f7bb-99bfd3a027cb@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8681c958-0fd9-130e-f7bb-99bfd3a027cb@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 03:53:45PM +0100, Vincenzo Frascino wrote:
> 
> On 4/14/20 2:27 PM, Mark Rutland wrote:
> > On Tue, Apr 14, 2020 at 01:50:38PM +0100, Vincenzo Frascino wrote:
> >> Hi Mark,
> >>
> >> On 4/14/20 11:42 AM, Mark Rutland wrote:
> >>> The aarch32_vdso_pages[] array never has entries allocated in the C_VVAR
> >>> or C_VDSO slots, and as the array is zero initialized these contain
> >>> NULL.
> >>>
> >>> However in __aarch32_alloc_vdso_pages() when
> >>> aarch32_alloc_kuser_vdso_page() fails we attempt to free the page whose
> >>> struct page is at NULL, which is obviously nonsensical.
> >>
> >> Could you please explain why do you think that free(NULL) is "nonsensical"? 
> > 
> > Regardless of the below, can you please explain why it is sensical? I'm
> > struggling to follow your argument here.
> 
> free(NULL) is a no-operation ("no action occurs") according to the C standard
> (ISO-IEC 9899 paragraph 7.20.3.2). Hence this should not cause any bug if the
> allocator is correctly implemented.

This is true, but irrelevant. The C standard does not define
free_page(), which is a Linnux kernel internal function, and does not
have the same semantics as free().

> > * It serves no legitimate purpose. One cannot free a page without a
> >   corresponding struct page.
> > 
> > * It is redundant. Removing the code does not detract from the utility
> >   of the remainging code, or make that remaing code more complex.

> > * free_page(x) calls free_pages(x, 0), which checks virt_addr_valid(x).
> >   As page_to_virt(NULL) is not a valid linear map address, this can
> >   trigger a VM_BUG_ON()
> > 
> 
> free_pages(x, 0) checks virt_addr_valid(x) only if "addr != 0" (as per C
> standard) which makes me infer what I stated above. But maybe I am missing
> something.

Regardless, this is all academic unless you disagree with the first two
bullets above.

You don't randomly sprinkle a program with free(NULL) for the fun of it.
Similarly, and regardless of how obfuscated, one should not do the same
here.

Thanks,
Mark.
