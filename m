Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F7C1A819B
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 17:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgDNPKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 11:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436635AbgDNPKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 11:10:40 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB34B20768;
        Tue, 14 Apr 2020 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586877039;
        bh=WMb8yo4wljqMwsmKwQgBBbYKtIYLd1mlUILSYQQYR18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZXPJEWN4mNTWlWrwiTXBw4uWBw1zUsNKKElhIAM2xQVf5c1Xvm9I/psytdfmEfEsq
         mWuC5FDB3ZVdowbibFLSgStxSspW2Dd19FL6vwmGnASK32Ap+RlbJ2AbGNPaME130L
         QUi+LjBE8JMnJXjC+DCbIyW7WoK0RVt6gGJeDZoY=
Date:   Tue, 14 Apr 2020 16:10:35 +0100
From:   Will Deacon <will@kernel.org>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/5] arm64: vdso: don't free unallocated pages
Message-ID: <20200414151033.GA30288@willie-the-truck>
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
> 
> Since you say it is a bug (providing evidence), we might have to investigate
> because probably there is an issue somewhere else.

Not sure why you feel the need to throw the C standard around -- the patch
from Mark looks obviously like the right thing to do to me, so:

Acked-by: Will Deacon <will@kernel.org>

Catalin -- please take this one as a fix so that I can queue the rest of
the patches for 5.8 once it's hit mainline.

Will
