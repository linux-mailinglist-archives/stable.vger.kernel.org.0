Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3A749B2B1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 12:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380014AbiAYLIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 06:08:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33234 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380259AbiAYLFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 06:05:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D545B817AD;
        Tue, 25 Jan 2022 11:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E46C340E0;
        Tue, 25 Jan 2022 11:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643108721;
        bh=AfhY2TYZYO9iDIyybFxYert/9cADvDnVxpfry7WcujE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LIOUqi2ATiu+vsEySUrEqDohgapN4extbQtb53UAurfo49kHj+xCwBHpmHCg4Y4BT
         8xQlbVgUsF2LzQaL0WZrZtBN8zBa7wFHloWCvVQ7igKa8zSwTQ3CcY6hCE6J44QtV7
         9Gh4raXsM1ydY02ScCtrkQYQ8zVg4wq1ZDsnGoDc=
Date:   Tue, 25 Jan 2022 12:05:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/563] 5.10.94-rc1 review
Message-ID: <Ye/ZbicY9yYltua7@kroah.com>
References: <20220124184024.407936072@linuxfoundation.org>
 <20220124202234.GC16782@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124202234.GC16782@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 09:22:34PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.94 release.
> > There are 563 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Our tests are unhappy, and it is more than gmp.h problem:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> arm64_ctj:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/2010070033
> 
> arch/arm64/mm/extable.c: In function 'fixup_exception':
> 1095arch/arm64/mm/extable.c:17:6: error: implicit declaration of function 'in_bpf_jit' [-Werror=implicit-function-declaration]
> 1096  if (in_bpf_jit(regs))
> 1097      ^~~~~~~~~~
> 1098cc1: some warnings being treated as errors
> 1099scripts/Makefile.build:280: recipe for target 'arch/arm64/mm/extable.o' failed
> 1100make[2]: *** [arch/arm64/mm/extable.o] Error 1
> 1101make[2]: *** Waiting for unfinished jobs....
> 1102  CC      kernel/sched/loadavg.o
> 1103  CC      arch/arm64/kernel/entry-common.o
> 1104
> 
> arm64_defconfig:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/2010070044
> 
> arch/arm64/mm/extable.c: In function 'fixup_exception':
> 1129arch/arm64/mm/extable.c:17:6: error: implicit declaration of function 'in_bpf_jit' [-Werror=implicit-function-declaration]
> 1130  if (in_bpf_jit(regs))
> 1131      ^~~~~~~~~~
> 1132  CC      arch/arm64/crypto/ghash-ce-glue.o
> 1133cc1: some warnings being treated as errors
> 1134scripts/Makefile.build:280: recipe for target 'arch/arm64/mm/extable.o' failed
> 1135make[2]: *** [arch/arm64/mm/extable.o] Error 1
> 1136make[2]: *** Waiting for unfinished jobs....
> 1137  CC      arch/arm64/kvm/hyp/vhe/sysreg-sr.o
> 1138
> 
> Best regards,

Found the offending commit, will fix this in -rc2, thanks.

greg k-h
