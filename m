Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DE3477A84
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 18:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbhLPRZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 12:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239933AbhLPRZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 12:25:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3CDC061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 09:25:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA67161EED
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 17:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6838C36AE4;
        Thu, 16 Dec 2021 17:25:52 +0000 (UTC)
Date:   Thu, 16 Dec 2021 17:25:49 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Chris January <Chris.January@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Subject: Re: Bug with KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2
 and CPTR_EL2 to 1
Message-ID: <Ybt2nd33H/pgKfpm@arm.com>
References: <DB8835B4-8F04-4669-87EA-D348FA47A79D@goldelico.com>
 <8C04B3CF-4B26-4EA1-B6BD-A7AB30078FCE@goldelico.com>
 <be707d0d8fa0419470cb07b47e6f0464@kernel.org>
 <CD07B147-6798-46C8-A01C-6CBDB73A44B2@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CD07B147-6798-46C8-A01C-6CBDB73A44B2@goldelico.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 16, 2021 at 03:30:40PM +0100, H. Nikolaus Schaller wrote:
> > Am 16.12.2021 um 09:43 schrieb Marc Zyngier <maz@kernel.org>:
> > On 2021-12-16 06:58, H. Nikolaus Schaller wrote:
> >>> Am 15.12.2021 um 19:40 schrieb H. Nikolaus Schaller <hns@goldelico.com>:
> >>> this seems to break build of 5.10.y (and maybe earlier) for me:
> >>> CALL    scripts/checksyscalls.sh - due to target missing
> >>> CALL    scripts/atomic/check-atomics.sh - due to target missing
> >>> CHK     include/generated/compile.h
> >>> AS      arch/arm64/kvm/hyp/nvhe/hyp-init.nvhe.o - due to target missing
> >>> arch/arm64/kvm/hyp/nvhe/hyp-init.S: Assembler messages:
> >>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
> >>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'
> >>> arch/arm64/kvm/hyp/nvhe/hyp-init.S:87: Error: missing ')'This should somehow be fixed so that arch/arm64/include/asm/kvm_arm.h
> >>> can be included by older assemblers.
> > 
> > GCC versions prior to 5.1 are known to miscompile the kernel,
> > and the minimal GCC version was bumped in dca5244d2f5b.
> 
> > I am surprised this requirement wasn't backported to 5.10-stable,
> > as this results in all sorts of terrible bugs that are hard to
> > diagnose (see the horror story in the commit message).
> 
> Indeed.
> 
> My build system checks for existence of scripts/min-tool-version.sh
> and if it exists it chooses the right gcc version. If it does not exist
> it assumes that gcc 4.9 is still good enough...

I wonder whether the problem is binutils rather than gcc. We have a
minimum requirement of 2.23 but it looks like it failed to build for you
with 2.25. Unless the compiler got smarter and it drops the 'U' from 1U
when passing it to gas.

> Yes, it does! This can be compiled with gcc 4.9 (resp. binutils).
> 
> So IMHO there are 3 different ways to solve it:
> a) your fix applied to 5.10.y
> b) someone backports scripts/min-tool-version.sh
> to allow for dependable automation...
> c) we leave 5.10.y unfixed and I just add a special
> rule for arm64 to choose a newer gcc (it is no problem to
> use 4.9 for other architectures) in my build setup.

Another option is to merge Marc's fix in 5.16 (there are two more 1U in
the same file) with a Fixes tag and cc stable so that it gets backported
to 5.10.y.

-- 
Catalin
