Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9093A1A8406
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 18:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387661AbgDNP7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 11:59:48 -0400
Received: from foss.arm.com ([217.140.110.172]:58990 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732397AbgDNP7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 11:59:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83D5CC14;
        Tue, 14 Apr 2020 08:59:45 -0700 (PDT)
Received: from gaia (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC8E83F6C4;
        Tue, 14 Apr 2020 08:59:44 -0700 (PDT)
Date:   Tue, 14 Apr 2020 16:59:42 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/5] arm64: vdso: don't free unallocated pages
Message-ID: <20200414155942.GC22140@gaia>
References: <20200414104252.16061-1-mark.rutland@arm.com>
 <20200414104252.16061-2-mark.rutland@arm.com>
 <c5596228-2685-abb3-5ab1-9519759e1f7a@arm.com>
 <20200414132751.GF2486@C02TD0UTHF1T.local>
 <8681c958-0fd9-130e-f7bb-99bfd3a027cb@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8681c958-0fd9-130e-f7bb-99bfd3a027cb@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 03:53:45PM +0100, Vincenzo Frascino wrote:
> On 4/14/20 2:27 PM, Mark Rutland wrote:
> > On Tue, Apr 14, 2020 at 01:50:38PM +0100, Vincenzo Frascino wrote:
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
> allocator is correctly implemented. From what I can see the implementation of
> the page allocator honors this assumption.
[...]
> > * page_to_virt(NULL) does not have a well-defined result, and
> >   page_to_virt() should only be called for a valid struct page pointer.
> >   The result of page_to_virt(NULL) may not be a pointer into the linear
> >   map as would be expected.
> 
> Do you know why this is the case? To be compliant with what the page allocator
> expects page_to_virt(NULL) should be equal to NULL.

Since __free_page(page) (note the two underscores and pointer type) does
not accept a NULL argument, I don't see any reason for page_to_virt() to
accept NULL as a valid argument.

-- 
Catalin
