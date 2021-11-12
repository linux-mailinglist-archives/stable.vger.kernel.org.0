Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC65B44E7C4
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 14:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhKLNtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 08:49:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:43856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhKLNtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 08:49:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 367E16103A;
        Fri, 12 Nov 2021 13:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636724778;
        bh=OIKuLONgugogvdJKl8uYFIVoi1Fkl6hSMC7Ei+fXT3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vbg+THKScy4Gq5zlFb+PLYPVUdNA9dtAv+SdSS/IoxPx5AXk6Q68HHNF+uQiAlU9G
         5PJ03mdqcp3sK03WEDxLef+h+i3SvZUMBVhx5R+NTvWmjEJu8HeWAyk1INXZcobEyd
         Q6GjHzvzblIxdq4vdGP8iRJd1vt75bQyWLPdwoUA=
Date:   Fri, 12 Nov 2021 14:46:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
Message-ID: <YY5wKPes3JwZyLgY@kroah.com>
References: <20211110182002.964190708@linuxfoundation.org>
 <YY0UQAQ54Vq4vC3z@debian>
 <dc99862f-f4a5-4351-e4c8-43237238377e@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc99862f-f4a5-4351-e4c8-43237238377e@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 02:36:08PM -0700, Shuah Khan wrote:
> On 11/11/21 6:01 AM, Sudip Mukherjee wrote:
> > Hi Greg,
> > 
> > On Wed, Nov 10, 2021 at 07:43:46PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.79 release.
> > > There are 21 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> > > Anything received after that time might be too late.
> > 
> > systemd-journal-flush.service failed due to a timeout resulting in a very very
> > slow boot on my test laptop. qemu test on openqa failed due to the same problem.
> > 
> > https://openqa.qa.codethink.co.uk/tests/365
> > 
> > A bisect showed the problem to be 8615ff6dd1ac ("mm: filemap: check if THP has
> > hwpoisoned subpage for PMD page fault"). Reverting it on top of 5.10.79-rc1
> > fixed the problem.
> > Incidentally, I was having similar problem with Linus's tree
> > for last few days and was failing since 20211106 (did not get the time to check).
> > I will test mainline again with this commit reverted.
> > 
> > 
> 
> Reverting mm: filemap: check if THP has hwpoisoned subpage for PMD page fault"
> worked for me on my test system.
> 
> With this commit boots are long and shutdown was at the 20+ minute m ark when
> I powered it down. This commit isn't in any of the other release candidates.

Thanks, will go drop this commit.

greg k-h
