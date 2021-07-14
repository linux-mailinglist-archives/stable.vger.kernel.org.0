Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3703C7E15
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 07:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbhGNFtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 01:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238000AbhGNFs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 01:48:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AA4F6138C;
        Wed, 14 Jul 2021 05:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626241568;
        bh=qpiaAFUsqnwaGdijxGchyZ5M0lzPsLjYvvrGTXz2/Uo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DSp6UMHOa2hXgETJuM3JV9ykRpWXqo/Pdp9m/RI6E1XTiqgYkkjyYpYgMwoBrfZXM
         JkXgZooyJW4NSSven9SEu4Difc84iwAxHiNrFoNiucodx05hRTNTVgzQ30zygqcFgF
         2hlG7IGnreCrK3uXgSO32DzRBX2Isqc8Ru8DGTz0=
Date:   Wed, 14 Jul 2021 07:46:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Holger Kiehl <Holger.Kiehl@dwd.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
Message-ID: <YO56HTE3k95JLeje@kroah.com>
References: <20210712060912.995381202@linuxfoundation.org>
 <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 05:39:43AM +0000, Holger Kiehl wrote:
> Hello,
> 
> On Mon, 12 Jul 2021, Greg Kroah-Hartman wrote:
> 
> > This is the start of the stable review cycle for the 5.13.2 release.
> > There are 800 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > Anything received after that time might be too late.
> > 
> With this my system no longer boots:
> 
>    [  OK  ] Reached target Swap.
>    [   75.213852] NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
>    [   75.213926] NMI watchdog: Watchdog detected hard LOCKUP on cpu 2
>    [   75.213962] NMI watchdog: Watchdog detected hard LOCKUP on cpu 4
>    [FAILED] Failed to start Wait for udev To Complete Device Initialization.
>    See 'systemctl status systemd-udev-settle.service' for details.
>             Starting Activation of DM RAID sets...
>    [      ] (1 of 2) A start job is running for Activation of DM RAID sets (..min ..s / no limit)
>    [      ] (2 of 2) A start job is running for Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling (..min ..s / no limit)
> 
> System is a Fedora 34 with all updates applied. Two other similar
> systems with AMD CPUs (Ryzen 4750G + 3400G) this does not happen
> and boots fine. The system where it does not boot has an Intel
> Xeon E3-1285L v4 CPU. All of them use a dm_crypt root filesystem.
> 
> Any idea which patch I should drop to see if it boots again. I already
> dropped
> 
>    [PATCH 5.13 743/800] ASoC: Intel: sof_sdw: add quirk support for Brya and BT-offload
> 
> and I just see that this one should also be dropped:
> 
>    [PATCH 5.13 768/800] hugetlb: address ref count racing in prep_compound_gigantic_page
> 
> Will still need to test this.

Can you run 'git bisect' to see what commit causes the problem?

thanks,

greg k-h
