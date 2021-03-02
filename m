Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC86432AEFF
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCCANq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350044AbhCBLv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 06:51:26 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAAAC06178A;
        Tue,  2 Mar 2021 03:41:38 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id 711CD1F45192
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Suram Suram <suram@nxp.com>
References: <20210301193642.707301430@linuxfoundation.org>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <32a6c609-642c-71cf-0a84-d5e8ccd104b1@collabora.com>
Date:   Tue, 2 Mar 2021 11:38:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210301193642.707301430@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/03/2021 19:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 661 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 19:34:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


I've been through the KernelCI results for v5.10.20-rc2 and made
this manual reply, hoping to eventually get it all automated.



First there was one build regression with the arm
realview_defconfig:

kernel/rcu/tree.c:683:2: error: implicit declaration of function ‘IRQ_WORK_INIT’; did you mean ‘IRQMASK_I_BIT’? [-Werror=implicit-function-declaration]
  IRQ_WORK_INIT(late_wakeup_func);
  ^~~~~~~~~~~~~
  IRQMASK_I_BIT
kernel/rcu/tree.c:683:2: error: invalid initializer


Full log:

  https://storage.kernelci.org/stable-rc/linux-5.10.y/v5.10.19-662-g92929e15cdc0/arm/realview_defconfig/gcc-8/build.log


There were also a few new build warnings.  Here's a comparison of
the number of builds that completed with no warnings, with at
least one warning, and with an error between current stable and
stable-rc:

              pass  warn  error
v5.10.19      188      6      0  
v5.10.20-rc2  180     15      1

Full details for these 2 revisions respectively:

  https://kernelci.org/build/stable/branch/linux-5.10.y/kernel/v5.10.19/
  https://kernelci.org/build/stable-rc/branch/linux-5.10.y/kernel/v5.10.19-662-g92929e15cdc0/



Then on the runtime testing side, there was one boot regression
detected on imx8mp-evk as detailed here:

  https://kernelci.org/test/case/id/603d69ec2924db6b9baddcb2/

I've re-run a couple of tests with both v5.10.19 and v5.10.20-rc2
and also got a failure with v5.10.19, so it looks like it's not
really a new regression but more of an intermittent problem.
Bisections are not enabled in NXP's lab so we don't have results
about which commit caused it.  We should chase this up, I've
already asked if they're OK to enable bisection.  Then we may
bisect with an older revision that is really booting to find the
root cause...



Presumably it's not OK to have this build error in the v5.10.20
release, assuming the boot regression is not new and can be
ignored, but that's your call.  So it seems a bit early for
KernelCI to stamp it with Tested-by, even though it was tested
but it's more a matter of clarifying the semantics and whether
Tested-by implicitly means "works for me".  What do you think?

Best wishes,
Guillaume
