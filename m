Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA89730F60B
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 16:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbhBDPUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 10:20:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237205AbhBDPNf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 10:13:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A992164F60;
        Thu,  4 Feb 2021 15:12:54 +0000 (UTC)
Date:   Thu, 4 Feb 2021 15:12:52 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     vincenzo.frascino@arm.com, mark.rutland@arm.com,
        stable@vger.kernel.org, will@kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: Fix kernel address detection of
 __is_lm_address()" failed to apply to 5.4-stable tree
Message-ID: <20210204151251.GD14155@gaia>
References: <1612104058247187@kroah.com>
 <20210203131501.GB10424@gaia>
 <YBwN0rNXAjg2+ZWl@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBwN0rNXAjg2+ZWl@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 04:08:02PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Feb 03, 2021 at 01:15:03PM +0000, Catalin Marinas wrote:
> > On Sun, Jan 31, 2021 at 03:40:58PM +0100, Greg Kroah-Hartman wrote:
> > > From 519ea6f1c82fcdc9842908155ae379de47818778 Mon Sep 17 00:00:00 2001
> > > From: Vincenzo Frascino <vincenzo.frascino@arm.com>
> > > Date: Tue, 26 Jan 2021 13:40:56 +0000
> > > Subject: [PATCH] arm64: Fix kernel address detection of __is_lm_address()
> > > 
> > > Currently, the __is_lm_address() check just masks out the top 12 bits
> > > of the address, but if they are 0, it still yields a true result.
> > > This has as a side effect that virt_addr_valid() returns true even for
> > > invalid virtual addresses (e.g. 0x0).
> > > 
> > > Fix the detection checking that it's actually a kernel address starting
> > > at PAGE_OFFSET.
> > > 
> > > Fixes: 68dd8ef32162 ("arm64: memory: Fix virt_addr_valid() using __is_lm_address()")
> > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > Cc: Will Deacon <will@kernel.org>
> > > Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > > Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> > > Link: https://lore.kernel.org/r/20210126134056.45747-1-vincenzo.frascino@arm.com
> > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > 
> > I sent you the 5.4 and 5.10 backports of this patch. There is another
> > fix in this area which I'll send to Linus tonight. It should apply
> > cleanly on 5.4 and 5.10.
> 
> Both now applied.  What is the git id of the other fix in Linus's tree?

Thanks. The other commit is 91cb2c8b072e ("arm64: Do not pass tagged
addresses to __is_lm_address()").

-- 
Catalin
