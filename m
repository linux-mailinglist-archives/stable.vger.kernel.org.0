Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32743A5935
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 17:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhFMPH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 11:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231782AbhFMPHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Jun 2021 11:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E73261285;
        Sun, 13 Jun 2021 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623596713;
        bh=dI6TOSqiN7cMwHPJQuKBFVW24xy5y35XDm8j6K5hPbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=haIxuMxTViWZ3dwNnsXRIWYeZI6UfII8IQARRDIXuJ9K3aZRHoTcE+p60bON3nYBn
         mxHtFFy0IMZEBHDwGnZKoo/oJH3y5IRE34G+2TTGnonqXer6GUMEShMWF3ibTkVcE+
         iwTE83LzuI4wLCE56wj2oxeXmsV5PnPQiXNeKa/Q=
Date:   Sun, 13 Jun 2021 17:05:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: compiler.h:417:38: error: call to '__compiletime_assert_59'
 declared with attribute error: BUILD_BUG_ON failed: sizeof(_i) >
 sizeof(long)
Message-ID: <YMYepbrAxKbgaXi8@kroah.com>
References: <CA+G9fYuBo_WgjtW1BugKLPeYnmLEe65zU7Ttt=FB2uqMzZy1eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuBo_WgjtW1BugKLPeYnmLEe65zU7Ttt=FB2uqMzZy1eQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 13, 2021 at 08:25:19PM +0530, Naresh Kamboju wrote:
> The following error was noticed on stable-rc 5.12, 5.10, 5.4, 4.19,
> 4.14, 4.9 and 4.4
> for i386 and arm.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
> arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
> In file included from /builds/linux/include/linux/kernel.h:11,
>                  from /builds/linux/include/linux/list.h:9,
>                  from /builds/linux/include/linux/preempt.h:11,
>                  from /builds/linux/include/linux/hardirq.h:5,
>                  from /builds/linux/include/linux/kvm_host.h:7,
>                  from
> /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:18:
> In function '__gfn_to_hva_memslot',
>     inlined from '__gfn_to_hva_many.part.6' at
> /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1446:9,
>     inlined from '__gfn_to_hva_many' at
> /builds/linux/arch/arm/kvm/../../../virt/kvm/kvm_main.c:1434:22:
> /builds/linux/include/linux/compiler.h:417:38: error: call to
> '__compiletime_assert_59' declared with attribute error: BUILD_BUG_ON
> failed: sizeof(_i) > sizeof(long)
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                       ^
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ref:
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1342604370#L389

Odd.  Does Linus's tree have this problem?

The only arm changes was in arch/arm/include/asm/cpuidle.h in the tree
right now.  There are some kvm changes, but they are tiny...

Can you bisect this?

thanks,

greg k-h
