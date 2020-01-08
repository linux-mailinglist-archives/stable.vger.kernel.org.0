Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850AB134A64
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 19:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgAHSWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 13:22:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727169AbgAHSWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 13:22:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DFBA20692;
        Wed,  8 Jan 2020 18:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578507766;
        bh=UbS62opg9Mg5R72fpet8UvVpGaxxJdD/fWOHZnld6Fg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kt+Qk0iJbTqBYp82azao16P8Qn8lfy8bY1gHmgWDED9NtdiNQj/8YyuaeuGed6osA
         7uRQTfdezN3WlnVo7EkkhvCiLDiNNj38NH6DKGyHRQ72R8GUO0m5bQsHNZRQTE9yuI
         Tv2ieMF0y4HgVOFfad+a/enJVf5CbI9S3u+n7ym4=
Date:   Wed, 8 Jan 2020 19:22:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stephen Warren <swarren@wwwdotorg.org>
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        ARM kernel mailing list 
        <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Subject: Re: "arm64: alternatives: use tpidr_el2 on VHE hosts" v4.9 backport
 missing edits to proc.S
Message-ID: <20200108182244.GA2547623@kroah.com>
References: <a1cb6ca5-4806-0813-3aad-1246e65162a6@wwwdotorg.org>
 <aa09fae4-5b73-22d6-b3e8-91ff8d61d623@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa09fae4-5b73-22d6-b3e8-91ff8d61d623@wwwdotorg.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 08, 2020 at 11:08:20AM -0700, Stephen Warren wrote:
> On 1/7/20 6:09 PM, Stephen Warren wrote:
> > James,
> > 
> > I'm looking at commit 6d99b68933fbcf51f84fcbba49246ce1209ec193 ("arm64:
> > alternatives: use tpidr_el2 on VHE hosts"). When it was back-ported to
> > v4.9.x as eea59020a7f2993018ccde317387031c04c62036, the changes to
> > arch/arm64/mm/proc.S weren't included. I assume this was just an
> > accident, or was there some specific reason for this? Either way, I do
> > find that I need those changes for system suspend/resume to work in my
> > downstream vendor fork of v4.9 if I enable KVM support in .config. I'm
> > happy to send a patch for v4.9.x to add those changes back if that's the
> > way to go. v4.14.x and later don't have this issue.
> 
> Upon further investigation of git history, here's what happened:
> 
> When When 6d99b68933fb was back-ported to upstream v4.9.x as eea59020a7f2,
> proc.S didn't save/restore tpidr_el1 at all, so that's why the edits to
> proc.S were dropped as part of the backport.
> 
> Separately, in android-4.9, 0ec37136b90e ("UPSTREAM: arm64: move sp_el0 and
> tpidr_el1 into cpu_suspend_ctx") modified proc.S to save/restore tpidir_el1.
> When those two commits were later merged together in android-4.9, the
> modifications to proc.S to alternate between tpidr_el1/2 should have been
> added back in, but weren't.
> 
> Since our downstream 4.9 fork is based on android-4.9 after that merge, it
> picked up this issue and needs to be patched for it. Anyone else using
> android-4.9 would need this fix too. However, upstream 4.9.x stable doesn't
> have an issue.

Thanks for figuring this out.  If you could submit a 4.9 patch to AOSP
for this, that would be great, or I can do it myself if you have a
patch.

thanks,

greg k-h
