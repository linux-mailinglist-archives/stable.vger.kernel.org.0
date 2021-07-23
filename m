Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282C93D39EA
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 14:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhGWLXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 07:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234385AbhGWLXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Jul 2021 07:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDE8360ED4;
        Fri, 23 Jul 2021 12:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627041819;
        bh=PwjtfCTo8tHsPYPLNc6oR+NsanQdP6K5wpoC58YhcD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NWOOfsfzvJ7ztmEmEZDPGApUZaC7JkdjD65E2rZZD6219b0QDxn0mPZdfJl5VrviB
         nE4o7MF7oxSimILe2n9LYnzMusBjsyjSiMh6o2iJIs5T5odKEZtfy1BDTuqptC0dAZ
         F3l8kI2YE4CJq5sD1AQtS/sbkLVseyZ4B8wGIA5g=
Date:   Fri, 23 Jul 2021 14:03:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, LTP List <ltp@lists.linux.it>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.13 000/156] 5.13.5-rc1 review
Message-ID: <YPqwF7wtM6n3wHlr@kroah.com>
References: <20210722155628.371356843@linuxfoundation.org>
 <CA+G9fYt_9nfDcQzKm8SZtmQXzzrybutS9vD4GgUw_0o8UD1HOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt_9nfDcQzKm8SZtmQXzzrybutS9vD4GgUw_0o8UD1HOQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 23, 2021 at 05:26:22PM +0530, Naresh Kamboju wrote:
> On Thu, 22 Jul 2021 at 22:17, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.13.5 release.
> > There are 156 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.5-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The following error is due to SATA drive format failing with arm64 64k-page
> size ( CONFIG_ARM64_64K_PAGES=y ) kernel.
> while running LTP syscalls test suite on running 5.13.3 and 5.13.5-rc1 kernel.
> 
> First it was noticed on the stable-rc 5.13.3-rc2 kernel.
> 
> Whereas 64bit kernel and 32bit kernel pass with 4K page size.
> 
> Initially, I thought it could be a Hard drive fault but it is reproducible on
> other devices but not always. Which is a blocker to bisect the problem.
> 
> The steps to reproduce:
>  - Boot arm64 juno device with 64k page stable-rc 5.13 kernel Image [1]
>    - CONFIG_ARM64_64K_PAGES=y
>  - format connected SATA drives and mount /scratch
>  - Use the mounted /scratch for LTP runs to create and delete files from this
>  - cd /opt/ltp
>  - ./runltp -d /scratch -f syscalls

And does that also fail for 5.13.2?

