Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1037933F4ED
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 17:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhCQQER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 12:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231995AbhCQQDm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 12:03:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4718364F7E;
        Wed, 17 Mar 2021 15:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615994299;
        bh=xw75j8gkD9MFLwxR81md81e1o7okLIPVF5k8jy85Mbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bb7SxuHsEtbKNpovbATpafagBqyc6yyd5F+uY2iTmOhdxhtI041PKfUWSztSuwau8
         j+ZezIkhQIzzaL7DvvwFzuumDtOYsU1MLO7aILgW00X2nr5sBeiAdNmrEyux6hwy2+
         vkK1kLrI+2MmQGIjQHraSUcoljJlrF9/g2zTnp/s=
Date:   Wed, 17 Mar 2021 16:18:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/78] 4.9.262-rc1 review
Message-ID: <YFIduHUgBJsn63rh@kroah.com>
References: <20210315135212.060847074@linuxfoundation.org>
 <11774be7-0738-1a23-f186-0875b9e82ef6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11774be7-0738-1a23-f186-0875b9e82ef6@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 01:42:20PM -0700, Florian Fainelli wrote:
> 
> 
> On 3/15/2021 6:51 AM, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 4.9.262 release.
> > There are 78 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 17 Mar 2021 13:51:58 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.262-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit kernels, still seeing the
> following futex warning, unfortunately simply running the function
> tracers does not allow me to trigger the warning, so I am having a hard
> time coming up with a simple reproducer:
> 
> *** 0[   66.551916] ------------[ cut here ]------------
> [   66.557855] WARNING: CPU: 3 PID: 1628 at kernel/futex.c:1584
> do_futex+0x800/0x974
> [   66.565457] Modules linked in: brcmv3d(O) wakeup_drv(O) bcmdriver(PO)
> [   66.572048]
> [   66.573609] CPU: 3 PID: 1628 Comm: boot Tainted: P           O
> 4.9.262-1.22pre-g4c1466bf10ac #2
> [   66.582693] Hardware name: BCX972160DV (DT)
> [   66.586936] task: ffffffc07ae92280 task.stack: ffffffc0016ec000
> [   66.592923] PC is at do_futex+0x800/0x974
> [   66.596992] LR is at do_futex+0x784/0x974
> [   66.601057] pc : [<ffffff800810f470>] lr : [<ffffff800810f3f4>]
> pstate: 600001c5
> [   66.608547] sp : ffffffc0016efd10
> [   66.611912] x29: ffffffc0016efd10 x28: 0000000000000000
> [   66.617313] x27: 000000000000065c x26: ffffffc0016efdf8
> [   66.622713] x25: ffffffc079bf9090 x24: 000000008000065c
> [   66.628112] x23: ffffffc0016ec000 x22: 0000000000000000
> [   66.633511] x21: 000000000d72fbb0 x20: ffffffc079bf9080
> [   66.638912] x19: 0000000000000001 x18: 0000000000000000
> [   66.644313] x17: 0000007f845adfe8 x16: ffffff800810f5e4
> [   66.649713] x15: 000017d28638a692 x14: 00055d4a5b4a1ca0
> [   66.655114] x13: 000000000000012d x12: 0000000000000018
> [   66.660514] x11: 000000001f758ce6 x10: 0000000000000042
> [   66.665915] x9 : 003b9aca00000000 x8 : 0000000000000062
> [   66.671314] x7 : 0000000000007070 x6 : 0000000000000000
> [   66.676714] x5 : ffffffc079bf90b8 x4 : 0000000000000000
> [   66.682112] x3 : 0000000000000001 x2 : 0000000000000000
> [   66.687512] x1 : 0000000000000000 x0 : ffffff8009b0f7dd
> [   66.692909]
> [   66.694444] ---[ end trace cc7627749f0e27f6 ]---
> [   66.699114] Call trace:
> [   66.701614] Exception stack(0xffffffc0016efb10 to 0xffffffc0016efc40)
> [   66.708121] fb00:                                   0000000000000001
> 0000007fffffffff
> [   66.712143] arm-scmi brcm_scmi@0: mbox timed out in resp(caller:
> scmi_perf_level_set+0x80/0xc0)
> [   66.712155] cpufreq: __target_index: Failed to change cpu frequency: -110
> [   66.731690] fb20: ffffffc0016efd10 ffffff800810f470 00000000600001c5
> 000000000000003d
> [   66.739624] fb40: ffffffc079bf9090 ffffffc0016efdf8 000000000000065c
> ffffff8009a26000
> [   66.747559] fb60: ffffffc0016efb80 ffffff80080ddbec ffffffc0016efb90
> ffffff80080cf2ac
> [   66.755492] fb80: ffffff80099f6000 ffffff80080de170 ffffffc0016efc50
> ffffff80080c88e8
> [   66.763426] fba0: ffffffc07a6da280 ffffffc07a6da4a0 ffffffc0016efbc0
> ffffff80083d531c
> [   66.771360] fbc0: ffffffc0016efc00 ffffff800808e5c4 0000000000000008
> 00000000000409ff
> [   66.779295] fbe0: ffffff8009b0f7dd 0000000000000000 0000000000000000
> 0000000000000001
> [   66.787227] fc00: 0000000000000000 ffffffc079bf90b8 0000000000000000
> 0000000000007070
> [   66.795160] fc20: 0000000000000062 003b9aca00000000 0000000000000042
> 000000001f758ce6
> [   66.803095] [<ffffff800810f470>] do_futex+0x800/0x974
> [   66.808211] [<ffffff800810f740>] SyS_futex+0x15c/0x184
> [   66.813415] [<ffffff8008083180>] el0_svc_naked+0x34/0x38
> 
> other than that:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

I thought the patches from Ben would help resolve this, but it looks
like something else is still needed :(

thanks for testing and letting me know.

greg k-h
