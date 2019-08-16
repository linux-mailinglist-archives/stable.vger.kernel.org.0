Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745708FBDC
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 09:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfHPHOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 03:14:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfHPHOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 03:14:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35AAA2077C;
        Fri, 16 Aug 2019 07:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565939654;
        bh=Evl2KKOh6MQV7F5Fco/BFBWeXigewfLlx6StyE+rljQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iIgo3dUGMR9iE/l7kU96+kdHskaGuaFsxyB/rbyEh7/OuqhbX1SUm6V7roCjoI3EW
         iylJ7DGPqaYp/oaL2Usdl4/uz2VDbRqkODX+frdFkIAaddeiSlQqXkDckYoSEy46Vg
         zO9+mj0DYLxZ6JhhFo0C/O/eaXrPQySk0z8NGhfg=
Date:   Fri, 16 Aug 2019 09:14:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org,
        stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: Allow flush_(inval_)dcache_range to work across
 ranges >4GB
Message-ID: <20190816071412.GF1368@kroah.com>
References: <20190815045543.16325-1-alastair@au1.ibm.com>
 <20190815071924.GA26670@kroah.com>
 <87mug97uo1.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mug97uo1.fsf@concordia.ellerman.id.au>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 11:42:22AM +1000, Michael Ellerman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > On Thu, Aug 15, 2019 at 02:55:42PM +1000, Alastair D'Silva wrote:
> >> From: Alastair D'Silva <alastair@d-silva.org>
> >> 
> >> Heads Up: This patch cannot be submitted to Linus's tree, as the affected
> >> assembler functions have already been converted to C.
> 
> That was done in upstream commit:
> 
> 22e9c88d486a ("powerpc/64: reuse PPC32 static inline flush_dcache_range()")
> 
> Which is a larger change that we don't want to backport. This patch is a
> minimal fix for stable trees.
> 
> 
> >> When calling flush_(inval_)dcache_range with a size >4GB, we were masking
> >> off the upper 32 bits, so we would incorrectly flush a range smaller
> >> than intended.
> >> 
> >> This patch replaces the 32 bit shifts with 64 bit ones, so that
> >> the full size is accounted for.
> >> 
> >> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> >> ---
> >>  arch/powerpc/kernel/misc_64.S | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Acked-by: Michael Ellerman <mpe@ellerman.id.au>
> 
> > <formletter>
> >
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> >
> > </formletter>
> 
> Hi Greg,
> 
> This is "option 3", submit the patch directly, and the patch "deviates
> from the original upstream patch" because the upstream patch was a
> wholesale conversion from asm to C.
> 
> This patch applies cleanly to v4.14 and v4.19.
> 
> The change log should have mentioned which upstream patch it is not a
> backport of, is there anything else we should have done differently to
> avoid the formletter bot :)

That is exactly what you should have done.  It needs to be VERY explicit
as to why this is being submitted different from what upstream did, and
to what trees it needs to go to and who is going to be responsible for
when it breaks.  And it will break :)

thanks,

greg k-h
