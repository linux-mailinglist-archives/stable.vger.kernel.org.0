Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C42F3DDFEE
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 21:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhHBTXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 15:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhHBTXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 15:23:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 080E360F51;
        Mon,  2 Aug 2021 19:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627932182;
        bh=FoNFwaxhVGbH5fiYKa0BkqvSkhEUlUyXZRZmtlpTJ+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dRFwk3MrqlMB69TcmHv5xEDkJyCXHWvFmyC6jDxbx7vpp2RZBG36uCw3KEanZgMsY
         xmDplUBLE0oRaKLSyPhrh8Rjt7jIQcGtCw5C12fnW9/fvAKyEQAfzzA++sDauRwklq
         scrSyRCfNGNwGYen8f5uonehMeDObkCa/YMzmcB1GPIzN24aIN7YZEPh6mRlDLma7/
         C1FSGMaGvErBKjqpEcE+lEDbfIzW8Kfkl9OG2S1YqeQvxodTjFkGodeqn8NQHj0DvX
         226t4MD6Anh7SKAkDenHoFjV2mubzn0DG4f/jBCHUv3XlDbcW9hvuU1NWSmvH9fENZ
         kQIwX3yGMhgkw==
Date:   Mon, 2 Aug 2021 15:23:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linaro-toolchain@lists.linaro.org,
        clang-built-linux@googlegroups.com, arnd@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>, ci_notify@linaro.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [CI-NOTIFY]: TCWG Bisect
 tcwg_kernel/llvm-release-arm-stable-allyesconfig - Build # 4 - Successful!
Message-ID: <YQhGFU85Q4k1dKfe@sashalap>
References: <1406720038.945.1627915387982@localhost>
 <a41ca429-9480-9ecf-242b-5e68fade3c10@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a41ca429-9480-9ecf-242b-5e68fade3c10@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 02, 2021 at 10:28:02AM -0700, Nathan Chancellor wrote:
>On 8/2/2021 7:43 AM, ci_notify@linaro.org wrote:
>>Successfully identified regression in *linux* in CI configuration tcwg_kernel/llvm-release-arm-stable-allyesconfig.  So far, this commit has regressed CI configurations:
>>  - tcwg_kernel/llvm-release-arm-stable-allyesconfig
>>
>>Culprit:
>><cut>
>>commit 341db343768bc44f3512facc464021730d64071c
>>Author: Linus Walleij <linus.walleij@linaro.org>
>>Date:   Sun May 23 00:50:39 2021 +0200
>>
>>     power: supply: ab8500: Move to componentized binding
>>     [ Upstream commit 1c1f13a006ed0d71bb5664c8b7e3e77a28da3beb ]
>>     The driver has problems with the different components of
>>     the charging code racing with each other to probe().
>>     This results in all four subdrivers populating battery
>>     information to ascertain that it is populated for their
>>     own needs for example.
>>     Fix this by using component probing and thus expressing
>>     to the kernel that these are dependent components.
>>     The probes can happen in any order and will only acquire
>>     resources such as state container, regulators and
>>     interrupts and initialize the data structures, but no
>>     execution happens until the .bind() callback is called.
>>     The charging driver is the main component and binds
>>     first, then bind in order the three subcomponents:
>>     ab8500-fg, ab8500-btemp and ab8500-chargalg.
>>     Do some housekeeping while we are moving the code around.
>>     Like use devm_* for IRQs so as to cut down on some
>>     boilerplate.
>>     Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>     Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
>>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>></cut>
>>
>>Results regressed to (for first_bad == 341db343768bc44f3512facc464021730d64071c)
>># reset_artifacts:
>>-10
>># build_abe binutils:
>>-9
>># build_llvm:
>>-5
>># build_abe qemu:
>>-2
>># linux_n_obj:
>>19634
>># First few build errors in logs:
>># 00:03:07 drivers/power/supply/ab8500_fg.c:3061:32: error: use of undeclared identifier 'np'
>># 00:03:08 make[3]: *** [drivers/power/supply/ab8500_fg.o] Error 1
>># 00:03:10 make[2]: *** [drivers/power/supply] Error 2
>># 00:03:10 make[1]: *** [drivers/power] Error 2
>># 00:04:05 make: *** [drivers] Error 2
>
>Greg and Sasha,
>
>Please cherry pick upstream commit 7e2bb83c617f ("power: supply: 
>ab8500: Call battery population once") to resolve this build error on 
>5.13.

Queued up, thanks!

-- 
Thanks,
Sasha
