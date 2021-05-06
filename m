Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C15037507E
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 09:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhEFIAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 04:00:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233602AbhEFIAD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 04:00:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC428613B5;
        Thu,  6 May 2021 07:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620287945;
        bh=uCfde1LX4DjDU+mPSYhIcs+Z/3xSasgqoWoypH4z0Ow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ugMB5xplqYdquPFXAuYdacC0fmGUX/EwjPEzgpnLEBtBh4kr80mNAR4zDV1oqbWKI
         Cm+ijZILhNUFT4QNoy6DQpDOQFNMsgeKcJZbn9i0HUsVopvPxedHpQVZqEKlemhAh1
         BLmqGtTYmUMsG/pXdv/TDeoiGIAj5phmPjGbP8z0=
Date:   Thu, 6 May 2021 09:59:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/21] 5.4.117-rc1 review
Message-ID: <YJOhx+pkHj2ZDJgH@kroah.com>
References: <20210505112324.729798712@linuxfoundation.org>
 <20210505214938.GA817073@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505214938.GA817073@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 02:49:38PM -0700, Guenter Roeck wrote:
> On Wed, May 05, 2021 at 02:04:14PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.117 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.117-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> > 
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >     Linux 5.4.117-rc1
> > 
> > Ondrej Mosnacek <omosnace@redhat.com>
> >     perf/core: Fix unconditional security_locked_down() call
> > 
> > Miklos Szeredi <mszeredi@redhat.com>
> >     ovl: allow upperdir inside lowerdir
> > 
> > Dan Carpenter <dan.carpenter@oracle.com>
> >     scsi: ufs: Unlock on a couple error paths
> > 
> > Mark Pearson <markpearson@lenovo.com>
> >     platform/x86: thinkpad_acpi: Correct thermal sensor allocation
> > 
> > Shengjiu Wang <shengjiu.wang@nxp.com>
> >     ASoC: ak5558: Add MODULE_DEVICE_TABLE
> > 
> > Shengjiu Wang <shengjiu.wang@nxp.com>
> >     ASoC: ak4458: Add MODULE_DEVICE_TABLE
> 
> Twice ? Why ?
> 
> This gives me a compile error (the second time it is added at the wrong
> place).
> 
> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/sound/soc/codecs/ak4458.c:722:1: error: redefinition of '__mod_of__ak4458_of_match_device_table'
> chromeos-kernel-5_4-5.4.117_rc1-r2159: MODULE_DEVICE_TABLE(of, ak4458_of_match);
> chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/include/linux/module.h:227:21: note: expanded from macro 'MODULE_DEVICE_TABLE'
> chromeos-kernel-5_4-5.4.117_rc1-r2159: extern typeof(name) __mod_##type##__##name##_device_table               \
> chromeos-kernel-5_4-5.4.117_rc1-r2159:                     ^
> chromeos-kernel-5_4-5.4.117_rc1-r2159: <scratch space>:119:1: note: expanded from here
> chromeos-kernel-5_4-5.4.117_rc1-r2159: __mod_of__ak4458_of_match_device_table
> chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/sound/soc/codecs/ak4458.c:711:1: note: previous definition is here
> chromeos-kernel-5_4-5.4.117_rc1-r2159: MODULE_DEVICE_TABLE(of, ak4458_of_match);
> chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/include/linux/module.h:227:21: note: expanded from macro 'MODULE_DEVICE_TABLE'
> chromeos-kernel-5_4-5.4.117_rc1-r2159: extern typeof(name) __mod_##type##__##name##_device_table               \
> 
> Oddly enough, I only see the error when I try to merge the
> code into ChromeOS, not in my test builds. I guess that has
> to do with "-Werror".

Ah, these came into Linus's tree with two different commits, which is
why I didn't notice it was already present.  I'll go drop these two from
all stable trees now, thanks for letting me know.

greg k-h
