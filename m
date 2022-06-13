Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF262549DA5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245724AbiFMT0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350483AbiFMT0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:26:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED68C3C497;
        Mon, 13 Jun 2022 10:48:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C84E60FC7;
        Mon, 13 Jun 2022 17:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6916DC34114;
        Mon, 13 Jun 2022 17:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655142484;
        bh=c6eK96/fB3B8bbSZ76aWI5lVX3ac8Hw/Xs/mjQDWTBk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NPsAxPdKH5uynbMvGPPhs1bdZWOJIJa4GfB/w8PBP6SetFHieD25LWuo6fzbJ4niQ
         eqUKsg+RDgngGefM59vB/1ld+CrbGYCA++CWx8NBiyIFBl3Us2BsaDkT37/p96OP+y
         lgHHZZVpiDfz39G0oK4VRP6jeZqvBLD1wSzuv4Vs=
Date:   Mon, 13 Jun 2022 19:48:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/247] 5.15.47-rc1 review
Message-ID: <Yqd4Ucyl9muznjVI@kroah.com>
References: <20220613094922.843438024@linuxfoundation.org>
 <20220613131838.GA3571788@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613131838.GA3571788@roeck-us.net>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 06:18:38AM -0700, Guenter Roeck wrote:
> On Mon, Jun 13, 2022 at 12:08:22PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.47 release.
> > There are 247 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Early feedback:
> 
> Building arm:allmodconfig ... failed
> --------------
> Error log:
> In file included from include/linux/kernel.h:16,
>                  from include/linux/crypto.h:16,
>                  from include/crypto/hash.h:11,
>                  from lib/iov_iter.c:2:
> lib/iov_iter.c: In function 'iter_xarray_get_pages':
> include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast
> 
> This will likely affect affects all branches where commit 6c77676645ad
> ("iov_iter: Fix iter_xarray_get_pages{,_alloc}()") was backported.
> 
> The fix is upstream commit 1c27f1fc1549 ("iov_iter: fix build issue due
> to possible type mis-match").

{sigh}

For various reasons of being rushed today (and totally busy this past
weekend), I didn't run my "find if any fixes are needed in the queues"
scripts, and this got missed, sorry about that.

I'll go queue this up now and run the scripts to verify nothing else got
missed.

thanks,

greg k-h
