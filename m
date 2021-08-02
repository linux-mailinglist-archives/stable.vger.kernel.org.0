Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CDC3DDE7D
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 19:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhHBR2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 13:28:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhHBR2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 13:28:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9EA060F9C;
        Mon,  2 Aug 2021 17:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627925283;
        bh=NA/OtrUPYU6SeAXYtZmkknCT34jOyScAkSKUaULSLXs=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=gH4HhnbxbwNAi/cG9oPZpKvy34VebkYWB8jRW07biq/HCSaPoFl8oXbVg1IZuPEFN
         2GoBSjYJlyh6vXodYu4cNsURTIwhZXfZIfrAncbHd0yPYqZuNSuinzwXOxTavXYIcZ
         f0OYluSOOJ0tjOdEpldhSQgQ7lu3lhNC6pzZqiylcMjt69QJVKSmxUcrxmPhs+wl4p
         0uDht99vLm75RzsiW8v4I1fQnuKv+4OnoN8wd+ubSXEDWdRuXhEq+XdfqesoibLyVi
         W7YdY57JKM95fvrTrtkc1vz6jNBNUZhX3ZR1VSs221AFRaIoqSf2B/5dVg1ekGtxPx
         zaQYh5mqNLdsw==
Subject: Re: [CI-NOTIFY]: TCWG Bisect
 tcwg_kernel/llvm-release-arm-stable-allyesconfig - Build # 4 - Successful!
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <1406720038.945.1627915387982@localhost>
Cc:     linaro-toolchain@lists.linaro.org,
        clang-built-linux@googlegroups.com, arnd@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>, ci_notify@linaro.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <a41ca429-9480-9ecf-242b-5e68fade3c10@kernel.org>
Date:   Mon, 2 Aug 2021 10:28:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1406720038.945.1627915387982@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/2/2021 7:43 AM, ci_notify@linaro.org wrote:
> Successfully identified regression in *linux* in CI configuration tcwg_kernel/llvm-release-arm-stable-allyesconfig.  So far, this commit has regressed CI configurations:
>   - tcwg_kernel/llvm-release-arm-stable-allyesconfig
> 
> Culprit:
> <cut>
> commit 341db343768bc44f3512facc464021730d64071c
> Author: Linus Walleij <linus.walleij@linaro.org>
> Date:   Sun May 23 00:50:39 2021 +0200
> 
>      power: supply: ab8500: Move to componentized binding
>      
>      [ Upstream commit 1c1f13a006ed0d71bb5664c8b7e3e77a28da3beb ]
>      
>      The driver has problems with the different components of
>      the charging code racing with each other to probe().
>      
>      This results in all four subdrivers populating battery
>      information to ascertain that it is populated for their
>      own needs for example.
>      
>      Fix this by using component probing and thus expressing
>      to the kernel that these are dependent components.
>      The probes can happen in any order and will only acquire
>      resources such as state container, regulators and
>      interrupts and initialize the data structures, but no
>      execution happens until the .bind() callback is called.
>      
>      The charging driver is the main component and binds
>      first, then bind in order the three subcomponents:
>      ab8500-fg, ab8500-btemp and ab8500-chargalg.
>      
>      Do some housekeeping while we are moving the code around.
>      Like use devm_* for IRQs so as to cut down on some
>      boilerplate.
>      
>      Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>      Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
>      Signed-off-by: Sasha Levin <sashal@kernel.org>
> </cut>
> 
> Results regressed to (for first_bad == 341db343768bc44f3512facc464021730d64071c)
> # reset_artifacts:
> -10
> # build_abe binutils:
> -9
> # build_llvm:
> -5
> # build_abe qemu:
> -2
> # linux_n_obj:
> 19634
> # First few build errors in logs:
> # 00:03:07 drivers/power/supply/ab8500_fg.c:3061:32: error: use of undeclared identifier 'np'
> # 00:03:08 make[3]: *** [drivers/power/supply/ab8500_fg.o] Error 1
> # 00:03:10 make[2]: *** [drivers/power/supply] Error 2
> # 00:03:10 make[1]: *** [drivers/power] Error 2
> # 00:04:05 make: *** [drivers] Error 2

Greg and Sasha,

Please cherry pick upstream commit 7e2bb83c617f ("power: supply: ab8500: 
Call battery population once") to resolve this build error on 5.13.

Cheers,
Nathan
