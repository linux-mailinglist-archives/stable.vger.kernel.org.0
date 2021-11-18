Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376144556A7
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244464AbhKRIRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:17:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244386AbhKRIQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 03:16:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 377B0619BB;
        Thu, 18 Nov 2021 08:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637223181;
        bh=VW8XL5P3cEuMtrWnECN39Kg2jTgv0gMinHiwNQoCuF0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V4NfIZILvX2jS8WWppKsU43fv+kYqoIjU2pk+zKRTTgvuXzf/W6RWRpc5wrS4jz9r
         9K7PVLd4rYRYxETW6iNCaVJ/dNEWMGaS9mgHS7bPPm1CTegNMsWHkEU5sztEzOYW+i
         tAZll/cBSDXnFmtL48oqS7YCkKa9h0Cxk2WM51Qc=
Date:   Thu, 18 Nov 2021 09:12:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Wang Yugui <wangyugui@e16-tech.com>,
        =?iso-8859-1?Q?Fran=E7ois?= Guerraz <kubrick@fgv6.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <YZYLC9D6zpUneYtn@kroah.com>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <202111171609.56F12BD@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202111171609.56F12BD@keescook>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 04:16:51PM -0800, Kees Cook wrote:
> On Wed, Nov 17, 2021 at 03:50:17PM -0800, Linus Torvalds wrote:
> > Sorry for top-posting and quoting this all, but the actual people
> > involved with the wchan changes don't seem to be on the participant
> > list.
> 
> Adding more folks from a private report and
> https://bugzilla.kernel.org/show_bug.cgi?id=215031
> 
> and for the new people, here's a lore link for this thread:
> https://lore.kernel.org/stable/YZV02RCRVHIa144u@fedora64.linuxtx.org/
> 
> 
> FWIW, earlier bisection pointed to the stable backport of
> 5d1ceb3969b6b2e47e2df6d17790a7c5a20fcbb4 being the primary culprit.
> At first glance it seems to me that the problem with -stable is that an
> unvetted subset of the wchan refactoring series landed in -stable.

What would be the vetted subset?  :)

Anyway, I have now dropped the following patches that were in the
5.15.3-rc tree:
	bc9bbb81730e ("x86: Fix get_wchan() to support the ORC unwinder")
	42a20f86dc19 ("sched: Add wrapper for get_wchan() to keep task blocked")
	5d1ceb3969b6 ("x86: Fix __get_wchan() for !STACKTRACE")

And will push out another -rc release to let people test.

If there are any other commits I should have also dropped, please let me
know.

thanks,

greg k-h
