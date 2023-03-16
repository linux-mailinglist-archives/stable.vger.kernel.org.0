Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9772D6BC79E
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 08:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjCPHrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 03:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCPHrs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 03:47:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601B6A42E7;
        Thu, 16 Mar 2023 00:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0861DCE17F2;
        Thu, 16 Mar 2023 07:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A782BC433D2;
        Thu, 16 Mar 2023 07:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678952860;
        bh=Jmx8A4cV89EL/rYdZ69YDOlNR4J4Gh1u59G1cRQSYRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=chlIsEXVMEJgLRyVE/jUDtJ87Zz81vCtKYI16JZEXXviSZRBsmFPs9rG5oZP/asZ4
         AnQ86L6/b+wONAV9SVQ/WySnBj64NUJQKzWwuTurhi8AyaE3y0kwdQJ6ay7tym7R6X
         ZPqDaxj7/tFO59A9V/CnyVmf/CO1DsqZ4nCnTF2Q=
Date:   Thu, 16 Mar 2023 08:47:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/39] 4.19.278-rc1 review
Message-ID: <ZBLJmakn42oYUSdd@kroah.com>
References: <20230315115721.234756306@linuxfoundation.org>
 <7e46d536-cc68-4b7c-e56e-cf1b94a925cb@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e46d536-cc68-4b7c-e56e-cf1b94a925cb@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 09:44:59AM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 15/03/23 06:12, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.278 release.
> > There are 39 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.278-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Lots and lots of failures, mostly Arm.
> 
> For Arm, Arm64, MIPS, with GCC-8, GCC-9, GCC-10, GCC-11, GCC-12, Clang-16, for some combinations with:
> * axm55xx_defconfig
> * davinci_all_defconfig
> * defconfig
> * defconfig-40bc7ee5
> * lkftconfig-kasan
> * multi_v5_defconfig
> * s5pv210_defconfig
> * sama5_defconfig
> 
> -----8<-----
> /builds/linux/kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function 'get_online_cpus' [-Werror,-Wimplicit-function-declaration]
>         get_online_cpus();
>         ^
> /builds/linux/kernel/cgroup/cgroup.c:2237:2: note: did you mean 'get_online_mems'?
> /builds/linux/include/linux/memory_hotplug.h:258:20: note: 'get_online_mems' declared here
> static inline void get_online_mems(void) {}
>                    ^
> /builds/linux/kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function 'put_online_cpus' [-Werror,-Wimplicit-function-declaration]
>         put_online_cpus();
>         ^
> /builds/linux/kernel/cgroup/cgroup.c:2248:2: note: did you mean 'put_online_mems'?
> /builds/linux/include/linux/memory_hotplug.h:259:20: note: 'put_online_mems' declared here
> static inline void put_online_mems(void) {}
>                    ^
> 2 errors generated.
> make[3]: *** [/builds/linux/scripts/Makefile.build:303: kernel/cgroup/cgroup.o] Error 1
> ----->8-----

This should now be resolved, I'll do a -rc2 with the fixes.

> For Arm64, i386 x86, with GCC-11, Perf has a new error:
> 
> -----8<-----
> In function 'ready',
>     inlined from 'sender' at bench/sched-messaging.c:90:2:
> bench/sched-messaging.c:76:13: error: 'dummy' is used uninitialized [-Werror=uninitialized]
>    76 |         if (write(ready_out, &dummy, 1) != 1)
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from bench/../perf-sys.h:5,
>                  from bench/../perf.h:18,
>                  from bench/sched-messaging.c:13:
> ----->8-----

That's odd as I don't see any perf patches for 4.19.

thanks,

greg k-h
