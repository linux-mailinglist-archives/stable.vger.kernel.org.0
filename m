Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FFD5FA3EC
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 21:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJJTHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 15:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiJJTHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 15:07:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F5522B01;
        Mon, 10 Oct 2022 12:07:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 058A8B81057;
        Mon, 10 Oct 2022 19:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B395C433C1;
        Mon, 10 Oct 2022 19:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665428834;
        bh=ZWte8C5uYISsFF83lneemPzUO7b1EEQdlJLiTDU0ssw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JI4Ehp2CiUq5xxDqBVNsGOt2nBa5oyufpY5HbmjJ5Qduy88uaLpqEktBP1OfVBcwa
         0XM4PeV0bkGspu/1E+Li1P+MKjM0x/1EdtK5IbGhk8TyhloJcN0+hsld5GyElxUeTC
         uBWCySCKOREhneM3+Z5KBquQDSOQTOQyd3gPAuSs=
Date:   Mon, 10 Oct 2022 21:07:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>,
        Mikulas Patocka <mpatocka@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/37] 5.15.73-rc1 review
Message-ID: <Y0RtjqMJc19d1WSx@kroah.com>
References: <20221010070331.211113813@linuxfoundation.org>
 <09eca44e-4d91-a060-d48c-d0aa41ac5045@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09eca44e-4d91-a060-d48c-d0aa41ac5045@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 10:49:10AM -0700, Guenter Roeck wrote:
> On 10/10/22 00:05, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.73 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building h8300:allnoconfig ... failed
> --------------
> Error log:
> In file included from include/linux/fs.h:6,
>                  from include/linux/huge_mm.h:8,
>                  from include/linux/mm.h:727,
>                  from include/linux/pid_namespace.h:7,
>                  from include/linux/ptrace.h:10,
>                  from arch/h8300/kernel/asm-offsets.c:15:
> include/linux/wait_bit.h: In function 'wait_on_bit':
> include/linux/wait_bit.h:74:14: error: implicit declaration of function 'test_bit_acquire'; did you mean 'test_bit_le'? [-Werror=implicit-function-declaration]
>    74 |         if (!test_bit_acquire(bit, word))
>       |              ^~~~~~~~~~~~~~~~
>       |              test_bit_le
> 
> This affects h8300 builds in all branches all the way back to v4.9.y.
> It also affects release candidates for various other architectures
> in v4.9.y..v5.10.y. In v4.9.y.queue, for example, I see 56 build
> failures out of 164 builds; most if not all of those can be attributed
> to problems with test_bit_acquire() - either due to a missing or due
> to a bad backport.
> 
> I can only hope that fix for the the problem that required the
> test_bit_acquire() backport is worth the trouble it causes.

Not yet, no.  I'm dropping them all.

thanks,

greg k-h
