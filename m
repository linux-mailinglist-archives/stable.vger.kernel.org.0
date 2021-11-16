Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E4C4533AD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 15:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbhKPOJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 09:09:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:37090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237001AbhKPOJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 09:09:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4EAF60F9C;
        Tue, 16 Nov 2021 14:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637071570;
        bh=t8XFI2ZYYxUCZidP3QZ4v5kg5V88IbkXzwXb2gSSxOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yGt1+hSqb2eMuF7ohS/mZANm20lffNFNEz5Vv+DE1c1qo9zeQYMyy7Ie8fr7JOcGY
         jeXsLqpdhFy8azTl+sPRgwU6MrOHiFbpSG7jm+aCG4HJ2OmDPtBsukGVfr+DXg38az
         ItDEu99iltCpikAx9zngv8KFciUiw2/M6QpeLQns=
Date:   Tue, 16 Nov 2021 15:06:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anders Roxell <anders.roxell@linaro.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/917] 5.15.3-rc1 review
Message-ID: <YZO60LxGc6Ii1Ixl@kroah.com>
References: <20211115165428.722074685@linuxfoundation.org>
 <CA+G9fYtFOnKQ4=3-4rUTfVM-fPno1KyTga1ZAFA2OoqNvcnAUg@mail.gmail.com>
 <CA+G9fYuF1F-9TAwgR9ik_qjFqQvp324FJwFJbYForA_iRexZjg@mail.gmail.com>
 <YZNwcylQcKVlZDlO@kroah.com>
 <dabc323f-b0e1-8c9f-1035-c48349a0eff4@nvidia.com>
 <CAMuHMdXG2Y-rwPtBw1PsGckk3MLRQvn6Xht6ts2RkW7Zkx=w2w@mail.gmail.com>
 <YZOKeFT8NGenpbsU@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZOKeFT8NGenpbsU@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 11:39:52AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 16, 2021 at 11:12:23AM +0100, Geert Uytterhoeven wrote:
> > Hi Jon,
> > 
> > On Tue, Nov 16, 2021 at 10:23 AM Jon Hunter <jonathanh@nvidia.com> wrote:
> > > On 16/11/2021 08:48, Greg Kroah-Hartman wrote:
> > > > On Tue, Nov 16, 2021 at 02:09:44PM +0530, Naresh Kamboju wrote:
> > > >> On Tue, 16 Nov 2021 at 12:06, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > > >>>
> > > >>> On Tue, 16 Nov 2021 at 00:03, Greg Kroah-Hartman
> > > >>> <gregkh@linuxfoundation.org> wrote:
> > > >>>>
> > > >>>> This is the start of the stable review cycle for the 5.15.3 release.
> > > >>>> There are 917 patches in this series, all will be posted as a response
> > > >>>> to this one.  If anyone has any issues with these being applied, please
> > > >>>> let me know.
> > > >>>>
> > > >>>> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> > > >>>> Anything received after that time might be too late.
> > > >>>>
> > > >>>> The whole patch series can be found in one patch at:
> > > >>>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc1.gz
> > > >>>> or in the git tree and branch at:
> > > >>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > >>>> and the diffstat can be found below.
> > > >>>>
> > > >>>> thanks,
> > > >>>>
> > > >>>> greg k-h
> > > >>>
> > > >>>
> > > >>
> > > >> Regression found on arm64 juno-r2 / qemu.
> > > >> Following kernel crash reported on stable-rc 5.15.
> > > >>
> > > >> Anders bisected this kernel crash and found the first bad commit,
> > > >>
> > > >> Herbert Xu <herbert@gondor.apana.org.au>
> > > >>     crypto: api - Fix built-in testing dependency failures
> > 
> > That's commit adad556efcdd ("crypto: api - Fix built-in testing
> > dependency failures")
> > 
> > > I am seeing the same for Tegra as well and bisect is pointing to the
> > > above for me too.
> > > > Is this also an issue on 5.16-rc1?
> > >
> > > I have not observed the same issue for 5.16-rc1.
> > 
> > Following the "Fixes: adad556efcdd" chain:
> > 
> > cad439fc040efe5f ("crypto: api - Do not create test larvals if manager
> > is disabled")
> > beaaaa37c664e9af ("crypto: api - Fix boot-up crash when crypto manager
> > is disabled")
> 
> Argh, yes, I didn't run my "check for fixes for patches in the queue"
> script which would have caught these.  I'll go queue these up and a few
> others that it just caught...

Now fixed up, along with another "fix for the fix for the fix" patch
that was needed.

greg k-h
