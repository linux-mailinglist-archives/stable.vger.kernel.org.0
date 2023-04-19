Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258966E7A82
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 15:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjDSNVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 09:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbjDSNVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 09:21:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F54C15454;
        Wed, 19 Apr 2023 06:21:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF0C9613E9;
        Wed, 19 Apr 2023 13:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC009C433D2;
        Wed, 19 Apr 2023 13:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681910467;
        bh=F2isO/QKnkvIpjuuplfhWUvWAW759gjEsSZjf0jaC4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qSb/MxQoYsulH9ffzce/FxSABP8NkhdoR3ZvlrN7mbh5/0AADmwDa4C6sc2LuRmxU
         wOfOR1UPIE8dabQiccWTIKVMoOloICQJu6thqBtuRXxPsRbhv6T448d1JKmxI/cM6f
         j1bE/N9rJiK4hK49mkOzX2PU5IJK+GAS1yzOrXVM=
Date:   Wed, 19 Apr 2023 15:21:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ron Economos <re@w6rz.net>
Cc:     Conor.Dooley@microchip.com, stable@vger.kernel.org, hi@alyssa.is,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/132] 6.1.25-rc2 review
Message-ID: <2023041956-overhaul-uncrushed-2415@gregkh>
References: <20230419093701.194867488@linuxfoundation.org>
 <306005cd-b4a0-44d3-c9b4-f3c238e1cde7@microchip.com>
 <5e3d78ec-40fb-70fa-2d25-a465c823fb1c@w6rz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e3d78ec-40fb-70fa-2d25-a465c823fb1c@w6rz.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 19, 2023 at 05:46:50AM -0700, Ron Economos wrote:
> On 4/19/23 4:58 AM, Conor.Dooley@microchip.com wrote:
> > On 19/04/2023 10:40, Greg Kroah-Hartman wrote:
> > 
> > > This is the start of the stable review cycle for the 6.1.25 release.
> > > There are 132 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 21 Apr 2023 09:36:33 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >           https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.25-rc2.gz
> > > or in the git tree and branch at:
> > >           git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > Alyssa Ross <hi@alyssa.is>
> > >       purgatory: fix disabling debug info
> > Alyssa provided a custom backport of this that did not require
> > picking up Heiko's patch below, but it did not seem to get
> > picked up.
> > Lore is ~dead for me, so all I can give you here is her message-id
> > for the custom backport: <20230418155237.2ubcusqc52nufmow@x220>
> > 
> > Heiko's patch is dead code as you've (rightly) not backported
> > any of the users.
> > > Heiko Stuebner <heiko.stuebner@vrull.eu>
> > >       RISC-V: add infrastructure to allow different str* implementations
> > 
> > 
> > > Alexandre Ghiti <alexghiti@rivosinc.com>
> > >       riscv: Do not set initial_boot_params to the linear address of the dtb
> > This one should also be dropped, either the whole series or
> > none of it please!
> > 
> > Alex has said he'll send the lot in a way that avoids confusion.
> > 
> > Otherwise, my testing passed.
> > 
> > Thanks,
> > Conor.
> 
> The "riscv: Do not set initial_boot_params to the linear address of the dtb"
> patch is fatal. Definitely needs to be dropped.

Now dropped, thanks,

greg k-h
