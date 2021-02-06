Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAB1311D48
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 14:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhBFNBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 08:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhBFNBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Feb 2021 08:01:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 240C764E51;
        Sat,  6 Feb 2021 13:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612616430;
        bh=pXWdrjkvleOtQM4N0W7PKsQJSBPIQc49fK6cpNTq1qA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zbny9ceyBunyM8KwNPCLpSv5IhpqcmrkQICKMt/uqCIuOP8SN+dopvPzCd5GTXtOs
         8Jw3tynb/TDQa2S9TsvVcf/2/lSSyofpB1hUQpdfZRDqC/KK6zX0ebhPwyhbRLmzKH
         qaa9SJgUQG8PF+Zk6wQx9OU7Tr+nq6O6/zGdvV3I=
Date:   Sat, 6 Feb 2021 14:00:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com
Subject: Re: Linux 4.4.256
Message-ID: <YB6S612pwLbQJf4u@kroah.com>
References: <1612534196241236@kroah.com>
 <20210205205658.GA136925@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205205658.GA136925@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 12:56:58PM -0800, Guenter Roeck wrote:
> On Fri, Feb 05, 2021 at 03:26:36PM +0100, Greg Kroah-Hartman wrote:
> > I'm announcing the release of the 4.4.256 kernel.
> > 
> > This, and the 4.9.256 release are a little bit "different" than normal.
> > 
> > This contains only 1 patch, just the version bump from .255 to .256 which ends
> > up causing the userspace-visable LINUX_VERSION_CODE to behave a bit differently
> > than normal due to the "overflow".
> > 
> > With this release, KERNEL_VERSION(4, 4, 256) is the same as KERNEL_VERSION(4, 5, 0).
> > 
> > Nothing in the kernel build itself breaks with this change, but given that this
> > is a userspace visible change, and some crazy tools (like glibc and gcc) have
> > logic that checks the kernel version for different reasons, I wanted to do this
> > release as an "empty" release to ensure that everything still works properly.
> > 
> > So, this is a YOU MUST UPGRADE requirement of a release.  If you rely on the
> > 4.4.y kernel, please throw this release into your test builds and rebuild the
> > world and let us know if anything breaks, or if all is well.
> > 
> > Go forth and do full system rebuilds!  Yocto and Gentoo are great for this, as
> > will systems that use buildroot.
> > 
> > I'll try to hold off on doing a "real" 4.4.y release for a week to give
> > everyone a chance to test this out and get back to me.  The pending patches in
> > the 4.4.y queue are pretty serious, so I am loath to wait longer than that,
> > consider yourself warned...
> > 
> Thanks a lot for the heads-up. For chromeos-4.4, the version number wrap
> is indeed fatal: Unfortunately we have lots of vendor code in the tree
> which uses KERNEL_VERSION(), and all the version comparisons against
> KERNEL_VERSION(4,5,0) do result in compile errors.
> 
> The best workaround/hack/kludge to address the problem seems to be the idea
> to use 4.4.255 as version number for LINUX_VERSION_CODE and KERNEL_VERSION()
> if SUBLEVEL is larger than 255. Did anyone find a better solution for the
> problem ?

I think Sasha's patch here:
	https://lore.kernel.org/r/20210205174702.1904681-1-sashal@kernel.org
is looking like the solution.

thanks,

greg k-h
