Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B84D4D434C
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 10:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbiCJJTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 04:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbiCJJTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 04:19:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67277124C3B;
        Thu, 10 Mar 2022 01:18:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25BA1B8254A;
        Thu, 10 Mar 2022 09:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C5EC340E8;
        Thu, 10 Mar 2022 09:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646903929;
        bh=E0/oipbFt9BSDxE+8Eu6f1igEieMOi82a3gQ5A4wr2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i7LHIE8m0Dp+cBrw8NZkhFHpOcAAT3gkB5qgZSSjwXYFiXWPaO9fqFsrKp0DzN/dm
         bbgrcPFsoAxeOG+fVLy0wqbgpCX34Lhj+XDxaGaWr2hezzKaCJFoiSQN3ftxXZRAT/
         oLb0AJBFB93Pm60h0bIRMCWdUfc1EQkZq1gmIDsM=
Date:   Wed, 9 Mar 2022 19:21:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/18] 4.19.234-rc1 review
Message-ID: <YijwKvDQxJzoYpFR@kroah.com>
References: <20220309155856.155540075@linuxfoundation.org>
 <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
 <CADVatmMceoHeQqFDEJND_3GmSeQqgefeP0Z9_Zi=UTAVfZ71RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmMceoHeQqFDEJND_3GmSeQqgefeP0Z9_Zi=UTAVfZ71RQ@mail.gmail.com>
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 06:15:08PM +0000, Sudip Mukherjee wrote:
> On Wed, Mar 9, 2022 at 6:08 PM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Greg,
> >
> > On Wed, Mar 9, 2022 at 4:03 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.19.234 release.
> > > There are 18 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> > > Anything received after that time might be too late.
> >
> > My tests are still running, but just an initial result for you,
> >
> > x86_64 defconfig fails with:
> > arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
> > arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of
> > function 'unprivileged_ebpf_enabled'
> > [-Werror=implicit-function-declaration]
> >   973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
> 
> And, lots of failures in arm builds also.
> Error:
> arch/arm/common/secure_cntvoff.S: Assembler messages:
> arch/arm/common/secure_cntvoff.S:24: Error: co-processor register
> expected -- `mcr p15,0,r0,c7,r5,4'
> arch/arm/common/secure_cntvoff.S:27: Error: co-processor register
> expected -- `mcr p15,0,r0,c7,r5,4'
> arch/arm/common/secure_cntvoff.S:29: Error: co-processor register
> expected -- `mcr p15,0,r0,c7,r5,4'
> make[1]: *** [scripts/Makefile.build:403:
> arch/arm/common/secure_cntvoff.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> arch/arm/kernel/entry-common.S: Assembler messages:
> arch/arm/kernel/entry-common.S:178: Error: co-processor register
> expected -- `mcr p15,0,r0,c7,r5,4'
> arch/arm/kernel/entry-common.S:187: Error: co-processor register
> expected -- `mcr p15,0,r0,c7,r5,4'
> make[1]: *** [scripts/Makefile.build:403:
> arch/arm/kernel/entry-common.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> arch/arm/mm/cache-v7.S: Assembler messages:
> arch/arm/mm/cache-v7.S:64: Error: co-processor register expected --
> `mcr p15,0,r0,c7,r5,4'
> arch/arm/mm/cache-v7.S:137: Error: co-processor register expected --
> `mcr p15,0,r0,c7,r5,4'
> arch/arm/mm/cache-v7.S:171: Error: co-processor register expected --
> `mcr p15,0,r0,c7,r5,4'
> arch/arm/mm/cache-v7.S:299: Error: co-processor register expected --
> `mcr p15,0,r0,c7,r5,4'
> make[1]: *** [scripts/Makefile.build:403: arch/arm/mm/cache-v7.o] Error 1

All clang builds for arm are known to fail, and some arm64 clang builds
will also fail.  I have seen initial patches for arm64, will let the
clang developers come up with the arm fix as I have no idea how to
handle that.  This just mirrors Linus's tree right now :)

Unless this is gcc?

thanks,

greg k-h
