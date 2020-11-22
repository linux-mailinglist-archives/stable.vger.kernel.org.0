Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9042BC47C
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 09:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgKVIBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 03:01:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbgKVIBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 03:01:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DB852078E;
        Sun, 22 Nov 2020 08:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606032100;
        bh=Fv9ziXyMoxfkJt/o/JsSYt1VLSXkbD0M5x/rvgfTmJ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sLpnABnT5X8mv/nHoOfcfMgAxYUgUa4zrkKr6BqTR7I8kylTelURPX/Vj2L5zudUW
         r9MyXNFnjmWGZlqc8oaICYOFgxInIw0CQrZAyGvJGgqQdSe0rjIwckI4lfZDmnT4uV
         WAx7cy9Pgsq5xp+hzmqReGiJyYhaULbye4lRv6sM=
Date:   Sun, 22 Nov 2020 09:01:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Axtens <dja@axtens.net>, Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/16] 4.9.245-rc1 review
Message-ID: <X7oa4P3qJ+VHnqY7@kroah.com>
References: <20201120104539.706905067@linuxfoundation.org>
 <20201121183446.GC111877@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201121183446.GC111877@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 21, 2020 at 10:34:46AM -0800, Guenter Roeck wrote:
> On Fri, Nov 20, 2020 at 12:03:05PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.245 release.
> > There are 16 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 168 pass: 166 fail: 2
> Failed builds:
> 	powerpc:cell_defconfig
> 	powerpc:maple_defconfig
> Qemu test results:
> 	total: 382 pass: 377 fail: 5
> Failed tests:
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:initrd
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:ide:rootfs
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:sdhci:mmc:rootfs
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:nvme:rootfs
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:scsi[DC395]:rootfs
> 
> Build failures see below. Note that the failures are different than the
> failures observed in the v4.4.y release candidate, meaning that some
> additional errors may not be reported.
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> 
> Guenter
> 
> ---
> Building powerpc:cell_defconfig ... failed
> --------------
> Error log:
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from arch/powerpc/lib/checksum_wrappers.c:24:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: data definition has no type or storage class [-Werror]
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: parameter names (without types) in function declaration [-Werror]
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> cc1: all warnings being treated as errors
> make[2]: *** [arch/powerpc/lib/checksum_wrappers.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[2]: *** wait: No child processes.  Stop.
> make[1]: *** [arch/powerpc/lib] Error 2
> make[1]: *** Waiting for unfinished jobs....
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from arch/powerpc/platforms/cell/spufs/syscalls.c:8:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: data definition has no type or storage class [-Werror]
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: parameter names (without types) in function declaration [-Werror]
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> cc1: all warnings being treated as errors
> make[4]: *** [arch/powerpc/platforms/cell/spufs/syscalls.o] Error 1
> make[4]: *** Waiting for unfinished jobs....
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from include/linux/uaccess.h:8,
>                  from include/linux/crypto.h:26,
>                  from crypto/cipher.c:17:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from include/linux/uaccess.h:8,
>                  from include/linux/crypto.h:26,
>                  from crypto/compress.c:15:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
> cc1: some warnings being treated as errors
> make[2]: *** [crypto/cipher.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from include/asm-generic/termios-base.h:7,
>                  from arch/powerpc/include/asm/termios.h:20,
>                  from include/uapi/linux/termios.h:5,
>                  from include/linux/tty.h:6,
>                  from kernel/signal.c:18:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from include/linux/uaccess.h:8,
>                  from include/linux/crypto.h:26,
>                  from include/crypto/algapi.h:15,
>                  from crypto/memneq.c:62:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> cc1: some warnings being treated as errors
> 
> Building powerpc:maple_defconfig ... failed
> --------------
> Error log:
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from arch/powerpc/lib/checksum_wrappers.c:24:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: data definition has no type or storage class [-Werror]
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: parameter names (without types) in function declaration [-Werror]
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> cc1: all warnings being treated as errors
> make[2]: *** [arch/powerpc/lib/checksum_wrappers.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [arch/powerpc/lib] Error 2
> make[1]: *** Waiting for unfinished jobs....
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from include/linux/uaccess.h:8,
>                  from include/linux/crypto.h:26,
>                  from crypto/cipher.c:17:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> cc1: some warnings being treated as errors
> make[2]: *** [crypto/cipher.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from include/linux/uaccess.h:8,
>                  from include/linux/crypto.h:26,
>                  from crypto/compress.c:15:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> cc1: some warnings being treated as errors
> make[2]: *** [crypto/compress.o] Error 1
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from include/linux/uaccess.h:8,
>                  from include/linux/crypto.h:26,
>                  from include/crypto/algapi.h:15,
>                  from crypto/memneq.c:62:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> cc1: some warnings being treated as errors
> make[2]: *** [crypto/memneq.o] Error 1
> make[1]: *** [crypto] Error 2
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from include/asm-generic/termios-base.h:7,
>                  from arch/powerpc/include/asm/termios.h:20,
>                  from include/uapi/linux/termios.h:5,
>                  from include/linux/tty.h:6,
>                  from kernel/signal.c:18:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from include/asm-generic/termios-base.h:7,
>                  from arch/powerpc/include/asm/termios.h:20,
>                  from include/uapi/linux/termios.h:5,
>                  from include/linux/tty.h:6,
>                  from arch/powerpc/kernel/setup_64.c:27:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: data definition has no type or storage class [-Werror]
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: parameter names (without types) in function declaration [-Werror]
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> cc1: some warnings being treated as errors
> make[2]: *** [kernel/signal.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> cc1: all warnings being treated as errors
> make[2]: *** [arch/powerpc/kernel/setup_64.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [arch/powerpc/kernel] Error 2
> In file included from arch/powerpc/include/asm/kup.h:10:0,
>                  from arch/powerpc/include/asm/uaccess.h:12,
>                  from include/linux/poll.h:11,
>                  from fs/bad_inode.c:16:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: data definition has no type or storage class
>  DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
>  ^~~~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
> arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: warning: parameter names (without types) in function declaration
> arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
>   if (static_branch_unlikely(&uaccess_flush_key))
>       ^~~~~~~~~~~~~~~~~~~~~~
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean ‘do_uaccess_flush’?
>   if (static_branch_unlikely(&uaccess_flush_key))
>                               ^~~~~~~~~~~~~~~~~
>                               do_uaccess_flush
> arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
> cc1: some warnings being treated as errors


Daniel, your commit broke this on 4.9, and on 4.14.y.  If you could
provide fix-up patches for these trees as well, that would be great.

thanks,

greg k-h
