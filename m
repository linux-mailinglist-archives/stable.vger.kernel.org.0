Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5ED31D6FC
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 10:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhBQJ1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 04:27:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhBQJ1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 04:27:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A395A64E33;
        Wed, 17 Feb 2021 09:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613553981;
        bh=fAcVKDtKPT44X9xFpYrvNyyM8U32OFphf2W8r+3sh20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QvcLhgdcV7Kwxbg3HAmaaj8A0U0F2FumuzjmojGddG06REnmnlCAaU7J2kNY2KwEZ
         8CzIiSJzbXVYozGJ6Ehy1foB0ETZM850CGcXDIg6ZBbiRERbN0VFjVEAoQbYuj76Fv
         hjG6m6PfiprgGk1R7+SntYzH009FXvqCR6ZcBuaE=
Date:   Wed, 17 Feb 2021 10:26:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 043/104] kasan: add explicit preconditions to
 kasan_report()
Message-ID: <YCzhOtZd3ldvEzvk@kroah.com>
References: <20210215152719.459796636@linuxfoundation.org>
 <20210215152720.867409732@linuxfoundation.org>
 <20210216115029.GA25795@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216115029.GA25795@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 16, 2021 at 12:50:29PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Vincenzo Frascino <vincenzo.frascino@arm.com>
> > 
> > [ Upstream commit 49c6631d3b4f61a7b5bb0453a885a12bfa06ffd8 ]
> > 
> > Patch series "kasan: Fix metadata detection for KASAN_HW_TAGS", v5.
> > 
> > With the introduction of KASAN_HW_TAGS, kasan_report() currently assumes
> > that every location in memory has valid metadata associated.  This is
> > due to the fact that addr_has_metadata() returns always true.
> > 
> > As a consequence of this, an invalid address (e.g.  NULL pointer
> > address) passed to kasan_report() when KASAN_HW_TAGS is enabled, leads
> > to a kernel panic.
> ...
> > This patch (of 2):
> > 
> > With the introduction of KASAN_HW_TAGS, kasan_report() accesses the
> > metadata only when addr_has_metadata() succeeds.
> > 
> > Add a comment to make sure that the preconditions to the function are
> > explicitly clarified.
> 
> As the other patch from the series is not applied, I don't believe we
> need this in stable. Changelog does not make any sense with just
> comment change cherry-picked...

Good point, now dropped, the AUTOBOT triggered off of the changelog text
which is nice and scary :)

greg k-h
