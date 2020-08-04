Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4D223B4D3
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 08:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgHDGLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 02:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728821AbgHDGLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 02:11:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AF652076E;
        Tue,  4 Aug 2020 06:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596521483;
        bh=ppi+8sf/WEedgMmc2O6rkbHCZMrQJgUlzTq2VUbRos0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SoQUM/daP1SBXAIPoPA481EhtQXpLBVbRBaR+iCgrtcmz5fYEwWw+Hqr4qp4gDZ8S
         vq2bAkBgCIeL8WJ8MuhcqOOtncjfjjtyAoc/Q98O6cYb8fMtuM8Qp1Wd6aR/o4WgTR
         7iH/Gf2PPi7COflXPHV3eDvEL4PiRnm7md/fclME=
Date:   Tue, 4 Aug 2020 08:11:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.7 000/120] 5.7.13-rc1 review
Message-ID: <20200804061120.GA696690@kroah.com>
References: <20200803121902.860751811@linuxfoundation.org>
 <20200803155820.GA160756@roeck-us.net>
 <20200803173330.GA1186998@kroah.com>
 <CAMuHMdW1Cz_JJsTmssVz_0wjX_1_EEXGOvGjygPxTkcMsbR6Lw@mail.gmail.com>
 <20200804030107.GA220454@roeck-us.net>
 <CAHk-=wi-WH0vTEVb=yTuWv=3RrGC2T28dHxqc=QXKkRMz3N3-g@mail.gmail.com>
 <20200804055855.GA114969@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804055855.GA114969@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 10:58:55PM -0700, Guenter Roeck wrote:
> On Mon, Aug 03, 2020 at 08:12:51PM -0700, Linus Torvalds wrote:
> > On Mon, Aug 3, 2020 at 8:01 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > >
> > > The bisect log below applies to both the sparc and the powerpc build
> > > failures.
> > 
> > Does the attached fix it?
> > 
> >                  Linus
> 
> > From 780c8591bce09bbdd2908b7c07b3baba883a1ce6 Mon Sep 17 00:00:00 2001
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > Date: Fri, 31 Jul 2020 07:51:14 +0200
> > Subject: [PATCH] random32: move the pseudo-random 32-bit definitions to prandom.h
> > 
> > The addition of percpu.h to the list of includes in random.h revealed
> > some circular dependencies on arm64 and possibly other platforms.  This
> > include was added solely for the pseudo-random definitions, which have
> > nothing to do with the rest of the definitions in this file but are
> > still there for legacy reasons.
> > 
> > This patch moves the pseudo-random parts to linux/prandom.h and the
> > percpu.h include with it, which is now guarded by _LINUX_PRANDOM_H and
> > protected against recursive inclusion.
> > 
> > A further cleanup step would be to remove this from <linux/random.h>
> > entirely, and make people who use the prandom infrastructure include
> > just the new header file.  That's a bit of a churn patch, but grepping
> > for "prandom_" and "next_pseudo_random32" should catch most users.
> > 
> > Acked-by: Willy Tarreau <w@1wt.eu>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> With this patch applied on top of v5.8:
> 
> Build results:
> 	total: 151 pass: 151 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for this, I'll go queue it up in a bit and push out some new
-rc2 releases.

greg k-h
