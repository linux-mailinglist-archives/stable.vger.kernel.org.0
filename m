Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C40163FC
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 14:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfEGMvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 08:51:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfEGMvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 08:51:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B150320B7C;
        Tue,  7 May 2019 12:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557233478;
        bh=plKPpyV/E4D4/D+TdJMVNIec2isYvg2Gv8++6/gnW+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DLTSD+JmSITP8Fj8SxlINMF6J+n7FpX2JIDLpBjtWhp541oHF5YwlSgV3tUxJrg4Z
         bdlET2vshtjGBTcyQnElHBL+COm4Bx8f5ykkOVf8BIlqhyfJK449rRoqegevwbYfNt
         BBjcu9wzd6bafwo2irc2K+KLzkf0JHVMdbhFvdAA=
Date:   Tue, 7 May 2019 14:51:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Qian Cai <cai@lca.pw>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Avi Kivity <avi@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 4.19 62/99] kmemleak: powerpc: skip scanning holes in the
 .bss section
Message-ID: <20190507125115.GB10118@kroah.com>
References: <20190506143053.899356316@linuxfoundation.org>
 <20190506143059.710412844@linuxfoundation.org>
 <20190507071925.irtu4gpc7tijmpbw@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507071925.irtu4gpc7tijmpbw@toshiba.co.jp>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 04:58:09PM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> On Mon, May 06, 2019 at 04:32:35PM +0200, Greg Kroah-Hartman wrote:
> > [ Upstream commit 298a32b132087550d3fa80641ca58323c5dfd4d9 ]
> > 
> > Commit 2d4f567103ff ("KVM: PPC: Introduce kvm_tmp framework") adds
> > kvm_tmp[] into the .bss section and then free the rest of unused spaces
> > back to the page allocator.
> > 
> > kernel_init
> >   kvm_guest_init
> >     kvm_free_tmp
> >       free_reserved_area
> >         free_unref_page
> >           free_unref_page_prepare
> > 
> > With DEBUG_PAGEALLOC=y, it will unmap those pages from kernel.  As the
> > result, kmemleak scan will trigger a panic when it scans the .bss
> > section with unmapped pages.
> > 
> > This patch creates dedicated kmemleak objects for the .data, .bss and
> > potentially .data..ro_after_init sections to allow partial freeing via
> > the kmemleak_free_part() in the powerpc kvm_free_tmp() function.
> > 
> > Link: http://lkml.kernel.org/r/20190321171917.62049-1-catalin.marinas@arm.com
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Reported-by: Qian Cai <cai@lca.pw>
> > Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> > Tested-by: Qian Cai <cai@lca.pw>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Avi Kivity <avi@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Krcmar <rkrcmar@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/powerpc/kernel/kvm.c |  7 +++++++
> >  mm/kmemleak.c             | 16 +++++++++++-----
> >  2 files changed, 18 insertions(+), 5 deletions(-)
> 
> This commit has other problems, so we also need the following commits:
> 
> commit dce5b0bdeec61bdbee56121ceb1d014151d5cab1
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Thu Apr 18 17:50:48 2019 -0700
> 
>     mm/kmemleak.c: fix unused-function warning
> 
>     The only references outside of the #ifdef have been removed, so now we
>     get a warning in non-SMP configurations:
> 
>       mm/kmemleak.c:1404:13: error: unused function 'scan_large_block' [-Werror,-Wunused-function]
> 
>     Add a new #ifdef around it.
> 
>     Link: http://lkml.kernel.org/r/20190416123148.3502045-1-arnd@arndb.de
>     Fixes: 298a32b13208 ("kmemleak: powerpc: skip scanning holes in the .bss section")
>     Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>     Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>     Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
>     Cc: Michael Ellerman <mpe@ellerman.id.au>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Please apply this commit.

Now queued up, thanks!

greg k-h
