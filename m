Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD026BB9BA
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 17:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjCOQfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 12:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjCOQfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 12:35:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433556A1CD;
        Wed, 15 Mar 2023 09:35:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5521B81E55;
        Wed, 15 Mar 2023 16:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0316BC433D2;
        Wed, 15 Mar 2023 16:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678898103;
        bh=n8i29t5BnpopTLaaXc6hLewGgdeblPFa0r81cvMxEmI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=udF2FHNt26fc81ZUsuyN6XaE6Chor+gNDeI+M3GUm2h3UlP7aAvoCmksa1PtAwqra
         TeJcKrFj2vCMUu2cCdouCMmheQKO153T3qDd9Vw5n2VQ3hC5PEqf5UyPAla5m6uNqB
         T0q+0UNBSk2ZmlNsOVTHAIa3AnBgRSdrDBmJ+ro4=
Date:   Wed, 15 Mar 2023 17:35:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/39] 4.19.278-rc1 review
Message-ID: <ZBHztHUPsp/q98ji@kroah.com>
References: <20230315115721.234756306@linuxfoundation.org>
 <7e46d536-cc68-4b7c-e56e-cf1b94a925cb@linaro.org>
 <166de5e6-3911-cbda-8b36-624e396decaa@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <166de5e6-3911-cbda-8b36-624e396decaa@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 08:59:14AM -0700, Guenter Roeck wrote:
> On 3/15/23 08:44, Daniel Díaz wrote:
> > Hello!
> > 
> > On 15/03/23 06:12, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.278 release.
> > > There are 39 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.278-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Lots and lots of failures, mostly Arm.
> > 
> > For Arm, Arm64, MIPS, with GCC-8, GCC-9, GCC-10, GCC-11, GCC-12, Clang-16, for some combinations with:
> > * axm55xx_defconfig
> > * davinci_all_defconfig
> > * defconfig
> > * defconfig-40bc7ee5
> > * lkftconfig-kasan
> > * multi_v5_defconfig
> > * s5pv210_defconfig
> > * sama5_defconfig
> > 
> > -----8<-----
> > /builds/linux/kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function 'get_online_cpus' [-Werror,-Wimplicit-function-declaration]
> >          get_online_cpus();
> >          ^
> > /builds/linux/kernel/cgroup/cgroup.c:2237:2: note: did you mean 'get_online_mems'?
> > /builds/linux/include/linux/memory_hotplug.h:258:20: note: 'get_online_mems' declared here
> > static inline void get_online_mems(void) {}
> >                     ^
> > /builds/linux/kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function 'put_online_cpus' [-Werror,-Wimplicit-function-declaration]
> >          put_online_cpus();
> >          ^
> > /builds/linux/kernel/cgroup/cgroup.c:2248:2: note: did you mean 'put_online_mems'?
> > /builds/linux/include/linux/memory_hotplug.h:259:20: note: 'put_online_mems' declared here
> > static inline void put_online_mems(void) {}
> >                     ^
> > 2 errors generated.
> > make[3]: *** [/builds/linux/scripts/Makefile.build:303: kernel/cgroup/cgroup.o] Error 1
> > ----->8-----
> > 
> > 
> > For Arm64, i386 x86, with GCC-11, Perf has a new error:
> > 
> > -----8<-----
> > In function 'ready',
> >      inlined from 'sender' at bench/sched-messaging.c:90:2:
> > bench/sched-messaging.c:76:13: error: 'dummy' is used uninitialized [-Werror=uninitialized]
> >     76 |         if (write(ready_out, &dummy, 1) != 1)
> >        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> > In file included from bench/../perf-sys.h:5,
> >                   from bench/../perf.h:18,
> >                   from bench/sched-messaging.c:13:
> > ----->8-----
> > 
> > 
> > Greetings!
> > 
> > Daniel Díaz
> > daniel.diaz@linaro.org
> > 
> 
> Looks like this whole set of release candidates is a disaster. I have stopped
> my testbed for the time being (no point in wasting energy), so there won't be
> any further updates from me for the time being.

Thanks, yeah, looks like only x86 seems to work here, I'll drop a bunch
of patches and push out -rc2 later tonight.

sorry for the mess, turns out that lots of different set of backports
broke arches they were not expecting to :(

greg k-h
