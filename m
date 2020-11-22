Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0722BC47A
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 09:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgKVIAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 03:00:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbgKVIAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 03:00:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1BDE208B3;
        Sun, 22 Nov 2020 08:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606032011;
        bh=5nGQjY4uD/TbgJNXxHcVpqpVIu40OtUsHmB86TH07xM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jdnxMe200K+7CTqyW7AeInXsbWAw9lZM4jemnTgRL8szWwdmF4kAe9ZRpkorWM3xX
         JhZvFHHdhi5XNucw5r2KpNovmL98WuW28BeVj7miFdSjOs2kwpuX50NLwvFU1nOEbF
         MgOcBbgziES7sBeCFAZUKm1KrfPr8ihkLVplDfPo=
Date:   Sun, 22 Nov 2020 09:00:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Axtens <dja@axtens.net>, Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/15] 4.4.245-rc1 review
Message-ID: <X7oahkxvsgCgDtrG@kroah.com>
References: <20201120104539.534424264@linuxfoundation.org>
 <20201121182903.GB111877@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201121182903.GB111877@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 21, 2020 at 10:29:03AM -0800, Guenter Roeck wrote:
> On Fri, Nov 20, 2020 at 12:02:58PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.245 release.
> > There are 15 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 165 pass: 164 fail: 1
> Failed builds:
> 	powerpc:ppc64e_defconfig
> Qemu test results:
> 	total: 328 pass: 323 fail: 5
> Failed tests:
> 	ppc64:ppce500:corenet64_smp_defconfig:e5500:initrd
> 	ppc64:ppce500:corenet64_smp_defconfig:e5500:nvme:rootfs
> 	ppc64:ppce500:corenet64_smp_defconfig:e5500:sdhci:mmc:rootfs
> 	ppc64:ppce500:corenet64_smp_defconfig:e5500:scsi[53C895A]:rootfs
> 	ppc64:ppce500:corenet64_smp_defconfig:e5500:sata-sii3112:rootfs	
> 
> Failure in all cases is:
> 
> In file included from arch/powerpc/kernel/ppc_ksyms.c:10:0:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:11:29: error: redefinition of ‘allow_user_access’
>  static __always_inline void allow_user_access(void __user *to, const void __user *from,
>                              ^~~~~~~~~~~~~~~~~
> In file included from arch/powerpc/include/asm/uaccess.h:12:0,
>                  from arch/powerpc/kernel/ppc_ksyms.c:8:
> arch/powerpc/include/asm/kup.h:12:20: note: previous definition of ‘allow_user_access’ was here
>  static inline void allow_user_access(void __user *to, const void __user *from,
>                     ^~~~~~~~~~~~~~~~~
> In file included from arch/powerpc/kernel/ppc_ksyms.c:10:0:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:16:20: error: redefinition of ‘prevent_user_access’
>  static inline void prevent_user_access(void __user *to, const void __user *from,
>                     ^~~~~~~~~~~~~~~~~~~
> In file included from arch/powerpc/include/asm/uaccess.h:12:0,
>                  from arch/powerpc/kernel/ppc_ksyms.c:8:
> arch/powerpc/include/asm/kup.h:14:20: note: previous definition of ‘prevent_user_access’ was here
>  static inline void prevent_user_access(void __user *to, const void __user *from,
>                     ^~~~~~~~~~~~~~~~~~~
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing these.

Daniel, looks like your patches broke some configurations on powerpc as
shown above.  Care to send a fix-up patch for these?

thanks,

greg k-h
