Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FA13046F1
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 19:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390444AbhAZRSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 12:18:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389836AbhAZQhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 11:37:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A940C22241;
        Tue, 26 Jan 2021 16:36:41 +0000 (UTC)
Date:   Tue, 26 Jan 2021 16:36:39 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] arm64: Fix kernel address detection of __is_lm_address()
Message-ID: <20210126163638.GA3509@gaia>
References: <20210126134056.45747-1-vincenzo.frascino@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126134056.45747-1-vincenzo.frascino@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 01:40:56PM +0000, Vincenzo Frascino wrote:
> Currently, the __is_lm_address() check just masks out the top 12 bits
> of the address, but if they are 0, it still yields a true result.
> This has as a side effect that virt_addr_valid() returns true even for
> invalid virtual addresses (e.g. 0x0).
> 
> Fix the detection checking that it's actually a kernel address starting
> at PAGE_OFFSET.
> 
> Fixes: f4693c2716b35 ("arm64: mm: extend linear region for 52-bit VA configurations")
> Cc: <stable@vger.kernel.org> # 5.4.x

Not sure what happened with the Fixes tag but that's definitely not what
it fixes. The above is a 5.11 commit that preserves the semantics of an
older commit. So it should be:

Fixes: 68dd8ef32162 ("arm64: memory: Fix virt_addr_valid() using __is_lm_address()")

The above also had a fix for another commit but no need to add two
entries, we just fix the original fix: 14c127c957c1 ("arm64: mm: Flip
kernel VA space").

Anyway, no need to repost, I can update the fixes tag myself.

In terms of stable backports, it may be cleaner to backport 7bc1a0f9e176
("arm64: mm: use single quantity to represent the PA to VA translation")
which has a Fixes tag already but never made it to -stable. On top of
this, we can backport Ard's latest f4693c2716b35 ("arm64: mm: extend
linear region for 52-bit VA configurations"). I just tried these locally
and the conflicts were fairly trivial.

-- 
Catalin
