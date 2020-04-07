Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6E21A0F70
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 16:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgDGOmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 10:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbgDGOmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 10:42:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D97722072A;
        Tue,  7 Apr 2020 14:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586270554;
        bh=U2KFol3fXEOhTgJ6ZIrnz0C6w8fi8C1JYimxTLP5uf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xb2YKk4YYvKhUr58uU4ecUgsLJ7rIxZeCbWRXlCDk04NZISVhdqk01JLgBbiRZnRg
         oFWsOvyXKOSgZ52nYJTb4cE3V89UiH/egP7P9UCCBfWG1EI/2G/pJlcQZzUNjBGlQx
         n8cWr+jvHpBTRuwvC8oxmgd+qhsFmTT5g9XozMs4=
Date:   Tue, 7 Apr 2020 16:42:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jann Horn <jannh@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bpf@vger.kernel.org
Subject: Re: [PATCH 5.4 10/36] bpf: Fix tnum constraints for 32-bit
 comparisons
Message-ID: <20200407144232.GA877817@kroah.com>
References: <20200407101454.281052964@linuxfoundation.org>
 <20200407101455.655552813@linuxfoundation.org>
 <26e2a116-bc4c-59b2-7c54-6ebbfb140ea5@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26e2a116-bc4c-59b2-7c54-6ebbfb140ea5@iogearbox.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 12:45:23PM +0200, Daniel Borkmann wrote:
> Hey Sasha, hey Greg,
> 
> On 4/7/20 12:21 PM, Greg Kroah-Hartman wrote:
> > From: Jann Horn <jannh@google.com>
> > 
> > [ Upstream commit 604dca5e3af1db98bd123b7bfc02b017af99e3a0 ]
> > 
> > The BPF verifier tried to track values based on 32-bit comparisons by
> > (ab)using the tnum state via 581738a681b6 ("bpf: Provide better register
> > bounds after jmp32 instructions"). The idea is that after a check like
> > this:
> > 
> >      if ((u32)r0 > 3)
> >        exit
> > 
> > We can't meaningfully constrain the arithmetic-range-based tracking, but
> > we can update the tnum state to (value=0,mask=0xffff'ffff'0000'0003).
> > However, the implementation from 581738a681b6 didn't compute the tnum
> > constraint based on the fixed operand, but instead derives it from the
> > arithmetic-range-based tracking. This means that after the following
> > sequence of operations:
> > 
> >      if (r0 >= 0x1'0000'0001)
> >        exit
> >      if ((u32)r0 > 7)
> >        exit
> > 
> > The verifier assumed that the lower half of r0 is in the range (0, 0)
> > and apply the tnum constraint (value=0,mask=0xffff'ffff'0000'0000) thus
> > causing the overall tnum to be (value=0,mask=0x1'0000'0000), which was
> > incorrect. Provide a fixed implementation.
> > 
> > Fixes: 581738a681b6 ("bpf: Provide better register bounds after jmp32 instructions")
> > Signed-off-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > Link: https://lore.kernel.org/bpf/20200330160324.15259-3-daniel@iogearbox.net
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> We've already addressed this issue (CVE-2020-8835) on 5.4/5.5/5.6 kernels through
> the following backports:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=8d62a8c7489a68b5738390b008134a644aa9b383
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.5.y&id=0ebc01466d98d016eb6a3780ec8edb0c86fa48bc
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.6.y&id=6797143df51c8ae259aa4bfe4e99c832b20bde8a
> 
> Given the severity of the issue, we concluded that revert-only is the best and
> most straight forward way to address it for stable.
> 
> Was this selected via Sasha's ML mechanism? Should there be a commit tag to opt-out
> for some commits being selected? E.g. this one 581738a681b6 ("bpf: Provide better
> register bounds after jmp32 instructions") already fell through our radar and wrongly
> made its way into 5.4 where it should have never landed. :/

Oops, yeah, I think this came from Sasha's simple "Fixes:" script, and
wasn't aware that it was already resolved.  I'll go drop these patches
now, thanks for catching this.

greg k-h
