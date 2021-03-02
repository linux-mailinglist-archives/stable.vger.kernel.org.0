Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B3932AFEB
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239751AbhCCA32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1446944AbhCBMlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:41:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 282B164F9D;
        Tue,  2 Mar 2021 12:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614688853;
        bh=647dv2UeIa7oWx+aGOeqCDewAnbXSZ+/CeLZ4dTw4AM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKp/G6ETbkEXnKIUh9YB765b4xhF0OdHeM/2mpotxLRVp0uQ1eSnOUoyvqDNqgzCc
         ZJDLqsOmHXesvx0YDS3atqrXFTlFQ7v4KKkmjS2WZDrNrTLrFgnYX+gqboJsOdgKrg
         1cGK3QOaU/1WzgNuuW4G7Fo5YRLRrEXndr9cd8H8=
Date:   Tue, 2 Mar 2021 13:40:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guillaume Tucker <guillaume.tucker@collabora.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org,
        Suram Suram <suram@nxp.com>
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
Message-ID: <YD4yUu6YH3wNQbwa@kroah.com>
References: <20210301193642.707301430@linuxfoundation.org>
 <32a6c609-642c-71cf-0a84-d5e8ccd104b1@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32a6c609-642c-71cf-0a84-d5e8ccd104b1@collabora.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 11:38:36AM +0000, Guillaume Tucker wrote:
> On 01/03/2021 19:37, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.20 release.
> > There are 661 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 03 Mar 2021 19:34:53 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> I've been through the KernelCI results for v5.10.20-rc2 and made
> this manual reply, hoping to eventually get it all automated.
> 
> 
> 
> First there was one build regression with the arm
> realview_defconfig:
> 
> kernel/rcu/tree.c:683:2: error: implicit declaration of function ‘IRQ_WORK_INIT’; did you mean ‘IRQMASK_I_BIT’? [-Werror=implicit-function-declaration]
>   IRQ_WORK_INIT(late_wakeup_func);
>   ^~~~~~~~~~~~~
>   IRQMASK_I_BIT
> kernel/rcu/tree.c:683:2: error: invalid initializer
> 
> 
> Full log:
> 
>   https://storage.kernelci.org/stable-rc/linux-5.10.y/v5.10.19-662-g92929e15cdc0/arm/realview_defconfig/gcc-8/build.log

That should now be resolved with a new -rc release for 5.4.y and 5.10.y.

> There were also a few new build warnings.  Here's a comparison of
> the number of builds that completed with no warnings, with at
> least one warning, and with an error between current stable and
> stable-rc:
> 
>               pass  warn  error
> v5.10.19      188      6      0  
> v5.10.20-rc2  180     15      1
> 
> Full details for these 2 revisions respectively:
> 
>   https://kernelci.org/build/stable/branch/linux-5.10.y/kernel/v5.10.19/
>   https://kernelci.org/build/stable-rc/branch/linux-5.10.y/kernel/v5.10.19-662-g92929e15cdc0/

That error should be resolved.

Warnings for non-x86 arches I have not been tracking to try to get down
to 0.  That would be a good project for someone to work on...

> Then on the runtime testing side, there was one boot regression
> detected on imx8mp-evk as detailed here:
> 
>   https://kernelci.org/test/case/id/603d69ec2924db6b9baddcb2/
> 
> I've re-run a couple of tests with both v5.10.19 and v5.10.20-rc2
> and also got a failure with v5.10.19, so it looks like it's not
> really a new regression but more of an intermittent problem.
> Bisections are not enabled in NXP's lab so we don't have results
> about which commit caused it.  We should chase this up, I've
> already asked if they're OK to enable bisection.  Then we may
> bisect with an older revision that is really booting to find the
> root cause...

Finding that root cause would be good, but doesn't really sound like a
regression yet :)

> Presumably it's not OK to have this build error in the v5.10.20
> release, assuming the boot regression is not new and can be
> ignored, but that's your call.  So it seems a bit early for
> KernelCI to stamp it with Tested-by, even though it was tested
> but it's more a matter of clarifying the semantics and whether
> Tested-by implicitly means "works for me".  What do you think?

Try the new release to see if that fixes the build errors for you.

And thanks for doing all of the testing here, this round was a rough one
for a variety of different reasons...

thanks,

greg k-h
