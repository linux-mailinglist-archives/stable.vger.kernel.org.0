Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804EC12DF72
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 17:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAAQYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 11:24:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgAAQYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 11:24:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79B752072C;
        Wed,  1 Jan 2020 16:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577895855;
        bh=M73trg+hti0X9pmV9ciObDeyGTVINgCWgga6e9ms7Q0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NXdX2yC022QFzTENm7uEgH4n82hF4nKBoUhUVoAzd6J9YKmODfrVjLsXPpqMzNDJV
         O/3C6mWTqYIwB7yEaQSvIrfT2sPBIxZ8DpBDUSogskcolSBPjx+dR3Ybzs5fHdjz56
         +4JAJYuuHr3Ug4gNXQC7iw828uJmnSzzLcVsAY/8=
Date:   Wed, 1 Jan 2020 17:24:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/219] 4.19.92-stable review
Message-ID: <20200101162413.GA2682113@kroah.com>
References: <20191229162508.458551679@linuxfoundation.org>
 <20191230171959.GC12958@roeck-us.net>
 <20191230173506.GB1350143@kroah.com>
 <7c5b2866-39d9-5c5f-0282-eef2f34c7fe8@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c5b2866-39d9-5c5f-0282-eef2f34c7fe8@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 31, 2019 at 06:01:12PM -0800, Guenter Roeck wrote:
> On 12/30/19 9:35 AM, Greg Kroah-Hartman wrote:
> > On Mon, Dec 30, 2019 at 09:19:59AM -0800, Guenter Roeck wrote:
> > > On Sun, Dec 29, 2019 at 06:16:42PM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.19.92 release.
> > > > There are 219 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > Build results:
> > > 	total: 156 pass: 141 fail: 15
> > > Failed builds:
> > > 	i386:tools/perf
> > > 	<all mips>
> > > 	x86_64:tools/perf
> > > Qemu test results:
> > > 	total: 381 pass: 316 fail: 65
> > > Failed tests:
> > > 	<all mips>
> > > 	<all ppc64_book3s_defconfig>
> > > 
> > > perf as with v4.14.y.
> > > 
> > > arch/mips/kernel/syscall.c:40:10: fatal error: asm/sync.h: No such file or directory
> > 
> > Ah, will go drop the offending patch and push out a -rc2 with both of
> > these issues fixed.
> > 
> > > arch/powerpc/include/asm/spinlock.h:56:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’
> > > and similar errors.
> > > 
> > > The powerpc build problem is inherited from mainline and has not been fixed
> > > there as far as I can see. I guess that makes 4.19.y bug-for-bug "compatible"
> > > with mainline in that regard.
> > 
> > bug compatible is fun :(
> > 
> 
> Not really. It is a terrible idea and results in the opposite of what I would
> call a "stable" release.
> 
> Anyway, turns out the offending commit is 14c73bd344d ("powerpc/vcpu: Assume
> dedicated processors as non-preempt"), which uses static_branch_unlikely().

It does?  I see:

+               if (lppaca_shared_proc(get_lppaca()))
+                       static_branch_enable(&shared_processor);

> This function does not exist for ppc in v4.19.y and v5.4.y. Thus, the _impact_
> of the error in v4.19.y and v5.4.y is the same as in mainline, but the _cause_
> is different. Upstream commit 14c73bd344d should not have been applied to
> v4.19.y and v5.4.y and needs to be reverted from those branches.

I'll go revert this patch, but as it was marked for stable by the
authors of the patch, as relevant back to 4.18, I would have hoped that
they knew what they were doing :)

thanks,

greg k-h
