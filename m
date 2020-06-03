Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AD61ED3CC
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 17:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgFCPxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 11:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgFCPxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 11:53:44 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9597206A2;
        Wed,  3 Jun 2020 15:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591199624;
        bh=A7R/LfmNTV+rUGtiZFNA3CTiCNX1NnmFmlAyesmhuCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CgxiiRImLnAtWO1jIYZC1XMb3gsIzCXKVv5zSce1CUqVxMp6+JWeULMW5/Dg/B/Ty
         vZ31bFD4b4VGvCYluH+VCCz3fg9Ff0/q3bgiTBsDZV/09HBk6VZHOtIN3tHUvmRKH6
         rfUerWQDx5CRoYmw4nC9oYk3UmntXbwFB2gaJhAc=
Date:   Wed, 3 Jun 2020 16:53:39 +0100
From:   Will Deacon <will@kernel.org>
To:     Keno Fischer <keno@juliacomputing.com>
Cc:     linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        Mark Rutland <mark.rutland@arm.com>,
        Luis Machado <luis.machado@linaro.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] arm64: Override SPSR.SS when single-stepping is
 enabled
Message-ID: <20200603155338.GA12036@willie-the-truck>
References: <20200603151033.11512-1-will@kernel.org>
 <20200603151033.11512-2-will@kernel.org>
 <CABV8kRwrnixNc074-jQhZzeucGHx9_e5FnQmBS=VuL=tFGjY-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABV8kRwrnixNc074-jQhZzeucGHx9_e5FnQmBS=VuL=tFGjY-Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Keno,

Thanks for having a look.

On Wed, Jun 03, 2020 at 11:42:46AM -0400, Keno Fischer wrote:
> On Wed, Jun 3, 2020 at 11:10 AM Will Deacon <will@kernel.org> wrote:
> >
> > Luis reports that, when reverse debugging with GDB, single-step does not
> > function as expected on arm64:
> >
> >   | I've noticed, under very specific conditions, that a PTRACE_SINGLESTEP
> >   | request by GDB won't execute the underlying instruction. As a consequence,
> >   | the PC doesn't move, but we return a SIGTRAP just like we would for a
> >   | regular successful PTRACE_SINGLESTEP request.
> >
> > The underlying problem is that when the CPU register state is restored
> > as part of a reverse step, the SPSR.SS bit is cleared and so the hardware
> > single-step state can transition to the "active-pending" state, causing
> > an unexpected step exception to be taken immediately if a step operation
> > is attempted.
> 
> We saw this issue also and worked around it in user-space [1]. That said,
> I think I'm ok with this change in the kernel, since I can't think of
> a particularly useful usecase for this feature.
> 
> However, at the same time as changing this, we should probably make sure
> to enable the syscall exit pseudo-singlestep trap (similar issue as the other
> patch I had sent for the signal pseudo-singlestep trap), since otherwise
> ptracers might get confused about the lack of singlestep trap during a
> singlestep -> seccomp -> singlestep path (which would give one trap
> less with this patch than before).

Hmm, I don't completely follow your example. Please could you spell it
out a bit more? I fast-forward the stepping state machine on sigreturn,
which I thought would be sufficient. Perhaps you're referring to a variant
of the situation mentioned by Mark, which I didn't think could happen
with ptrace [2].

Cheers,

Will

[2] https://lore.kernel.org/r/20200531095216.GB30204@willie-the-truck
