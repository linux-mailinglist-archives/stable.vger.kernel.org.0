Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04057223872
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 11:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgGQJeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 05:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgGQJeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 05:34:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5718F2063A;
        Fri, 17 Jul 2020 09:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594978445;
        bh=mIhGLiufJ6/BMsDdvDFYl28TDS9pc3qUvHLrRoX6ZhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b/KeB+YGDwp013yo7IEmGlJQ0quhL0ArbMiL1/cmtqv3B8x8OvqvwjMYwPFyNEfPU
         99g9fqWXuU1fHr9/mT1Bhgi0wcfg5OVsE9wxRVLuWzleq4o0SJMWHqwnl0CVay2DtI
         lXkxo5RWxUsrJNIJE2TlBMyEpQ+wloD5z78Dzsn0=
Date:   Fri, 17 Jul 2020 11:33:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, arnd@arndb.de, sashal@kernel.org,
        naresh.kamboju@linaro.org, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [Stable-5.4][PATCH 0/3] arm64: Allow the compat vdso to be
 disabled at runtime
Message-ID: <20200717093357.GA2371446@kroah.com>
References: <20200715125614.3240269-1-maz@kernel.org>
 <20200716115813.GB1668009@kroah.com>
 <c9f5b2b0512067b128dd5c98acc5db7e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9f5b2b0512067b128dd5c98acc5db7e@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 17, 2020 at 09:02:06AM +0100, Marc Zyngier wrote:
> Hi Greg,
> 
> On 2020-07-16 12:58, Greg KH wrote:
> > On Wed, Jul 15, 2020 at 01:56:11PM +0100, Marc Zyngier wrote:
> > > This is a backport of the series that recently went into 5.8. Note
> > > that the first patch is more a complete rewriting than a backport, as
> > > the vdso implementation in 5.4 doesn't have much in common with
> > > mainline. This affects the 32bit arch code in a benign way.
> > > 
> > > It has seen very little testing, as I don't have the HW that triggers
> > > this issue. I have run it in VMs by faking the CPU MIDR, and nothing
> > > caught fire. Famous last words.
> > 
> > These are also needed in 5.7.y, right?  If so, I need that series before
> > I can take this one as we don't want people moving to a newer kernel and
> > suffer regressions :(
> 
> The original mainline changes:
> 
> 4b661d6133c5 arm64: arch_timer: Disable the compat vdso for cores affected
> by ARM64_WORKAROUND_1418040
> c1fbec4ac0d7 arm64: arch_timer: Allow an workaround descriptor to disable
> compat vdso
> 97884ca8c292 arm64: Introduce a way to disable the 32bit vdso
> 
> do apply cleanly to stable-5.7. Do you want me to resend them separately,
> or will you pick the patches directly from mainline?

Hm, cherry-pick seems to work due to file renames, let me try this
again...

