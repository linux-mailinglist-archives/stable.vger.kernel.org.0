Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7AB59B3B5
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 14:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiHUMQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 08:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiHUMQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 08:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED93155B7;
        Sun, 21 Aug 2022 05:16:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 245D060C71;
        Sun, 21 Aug 2022 12:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04601C433C1;
        Sun, 21 Aug 2022 12:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661084214;
        bh=pfR4jr4sZH4UOKGkZpaG1J5xDYNRWYkdFPxOgEXVxLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MIhopnaCtadqyqX/FI8A1b9vohyx0SQAkfq2Yt+GGmRiptIFOaHd82MtzWD4BR88I
         hG1fzHG+Rds8ryLU9I3aNMULrSBegjI/AsQXQSkuWzkYDlLBOiLQhfdiZxJyVgDRCE
         ACJuPi3QrJXo/rt2cAJLuLrdeuAxgHxdlr6BKShY=
Date:   Sun, 21 Aug 2022 14:16:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/541] 5.10.137-rc2 review
Message-ID: <YwIiM6l/f3354+7B@kroah.com>
References: <20220820182952.751374248@linuxfoundation.org>
 <20220821120348.GA2332676@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220821120348.GA2332676@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 21, 2022 at 05:03:48AM -0700, Guenter Roeck wrote:
> On Sat, Aug 20, 2022 at 08:39:26PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.137 release.
> > There are 541 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 22 Aug 2022 18:28:24 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 163 pass: 162 fail: 1
> Failed builds:
> 	um:defconfig
> Qemu test results:
> 	total: 474 pass: 474 fail: 0
> 
> The build error is:
> 
> Building um:defconfig ... failed
> --------------
> Error log:
> In file included from arch/um/include/shared/irq_user.h:10,
>                  from arch/um/include/shared/os.h:12,
>                  from arch/um/kernel/umid.c:9:
> include/linux/stddef.h:11:9: error: expected identifier before numeric constant
>    11 |         false   = 0,
>       |         ^~~~~
> include/linux/types.h:30:33: error: two or more data types in declaration specifiers
>    30 | typedef _Bool                   bool;
>       |                                 ^~~~
> In file included from arch/um/include/shared/os.h:17,
>                  from arch/um/kernel/umid.c:9:
> include/linux/types.h:30:1: warning: useless type name in empty declaration
>    30 | typedef _Bool                   bool;
>       | ^~~~~~~
> 
> Bisect points to commit 6660dd43bbf ("um: seed rng using host OS rng"),
> and reverting it fixes the problem.

Thanks, I'll go drop that commit now.

greg k-h
