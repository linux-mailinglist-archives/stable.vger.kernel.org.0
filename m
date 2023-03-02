Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E457E6A7BF1
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 08:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjCBHjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 02:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCBHjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 02:39:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4063D30B;
        Wed,  1 Mar 2023 23:39:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB77B81157;
        Thu,  2 Mar 2023 07:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1B7C433D2;
        Thu,  2 Mar 2023 07:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677742759;
        bh=iP38PmJa3Kna7d3rQK1LrMyR11nxjBvibst1AjEzKN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mnHJXetfuAQ8+BBRn0Wh85AMOpRevoND4VUUfpvJz4garY4R8yxLqx8w9AXXuHzZa
         J6BJJi3gKjw7AVKpySNBorhRRsRvPyUBEJkKv7s3u4U7vKZEvG65E1oA4MthvRbotA
         5509H9WX5hi6x1Fm3UCj1d5WNl8w7sokhfNARelA=
Date:   Thu, 2 Mar 2023 08:39:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     Slade Watkins <srw@sladewatkins.net>, Pavel Machek <pavel@denx.de>,
        kuniyu@amazon.com, stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Message-ID: <ZABSpbAUYfxqxtBS@kroah.com>
References: <20230301180652.316428563@linuxfoundation.org>
 <Y//Lw/zL168J3spQ@duo.ucw.cz>
 <31339d95-a318-ba2e-fdb0-ea7b102fd6fd@sladewatkins.net>
 <8e32bdd6-652f-f7db-15a0-9647f74275a1@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e32bdd6-652f-f7db-15a0-9647f74275a1@roeck-us.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 09:03:51PM -0800, Guenter Roeck wrote:
> On 3/1/23 14:09, Slade Watkins wrote:
> > On 3/1/23 17:03, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > This is the start of the stable review cycle for the 5.10.171 release.
> > > > There are 19 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > AFAICT we should not need this patch -- we don't have b5fc29233d28 in
> > > 5.10, so the assertion seems to be at the correct place here.
> > 
> > This (b5fc29233d28be7a3322848ebe73ac327559cdb9) appears to be in linux-5.10.y,
> > though?
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=b5fc29233d28be7a3322848ebe73ac327559cdb9
> > 
> > Confused,
> > -- Slade
> > 
> 
> Also confused. My script tells me that it is _not_ in v5.10.y, and that it isn't
> queued either.
> 
> Upstream commit b5fc29233d2 ("inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().")
>   Integrated in v6.2-rc1
>   Not in 6.1.y
>   Not in 5.15.y
>   Not in 5.10.y
>   Not in 5.4.y
>   Not in 4.19.y
>   Not in 4.14.y
> 
> and:
> 
> $ git describe --contains b5fc29233d28be7a3322848ebe73ac327559cdb9
> v6.2-rc1~99^2~393^2~4
> 
> However, it looks like 62ec33b44e0 is queued everywhere.
> 
> Upstream commit 62ec33b44e0 ("net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().")
>   Integrated in v6.2
>   Expected to be fixed in 6.1.y with next stable release (sha 29d108dc216d)
>   Expected to be fixed in 5.15.y with next stable release (sha 07c26a42efc3)
>   Expected to be fixed in 5.10.y with next stable release (sha 3ecdc3798eb9)
>   Expected to be fixed in 5.4.y with next stable release (sha a88c26a1210e)
>   Expected to be fixed in 4.19.y with next stable release (sha 60b390c291e9)
>   Expected to be fixed in 4.14.y with next stable release (sha b53a2b4858c2)

Please see the email from Kuniyuki here:
	https://lore.kernel.org/r/20230227205531.12036-1-kuniyu@amazon.com
that should explain this.

The backport to older kernels is here:
	https://lore.kernel.org/r/20230227211548.13923-1-kuniyu@amazon.com

If you all think this should not be in any of these kernels, please let
work with Kuniyuki to figure it out.

thanks,

greg k-h
