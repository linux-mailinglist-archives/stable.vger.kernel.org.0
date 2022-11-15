Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F6C629B79
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 15:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiKOOFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 09:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238304AbiKOOE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 09:04:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB332B24F;
        Tue, 15 Nov 2022 06:04:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75820617B4;
        Tue, 15 Nov 2022 14:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDCDC433D6;
        Tue, 15 Nov 2022 14:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668521085;
        bh=1SdoHrXVlc28tVcuFs95h6yDFt8dc6moE42nroJLpog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wF1R5osC3lM2Y6sFYbZp7KtYIh0sc2hGF4ZYfYqnKNvJLSLq6W5PqdPDJYaB1JsuT
         XeXfQ3GJ3zxE0TEcok2nhhkELuHZ9Pu5jKZl4+khWuDbxj6s1L7TvAk0WhqxZufSbs
         VtXLcW4xe11+U8pQ6xiXbnteCV8IdWwRtcmX26zc=
Date:   Tue, 15 Nov 2022 15:04:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Message-ID: <Y3Oce3RElD47w1Dj@kroah.com>
References: <20221114124448.729235104@linuxfoundation.org>
 <Y3NupE6nAtbpoxbk@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3NupE6nAtbpoxbk@debian>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 10:49:08AM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Nov 14, 2022 at 01:44:29PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.79 release.
> > There are 131 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> > Anything received after that time might be too late.
> 
> Build test (gcc version 12.2.1 20221016):
> mips: 62 configs -> no failure
> arm: 99 configs -> 1 failure
> arm64: 3 configs -> 1 failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> csky allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
> 
> Note:
> As already mailed by others, both arm and arm64 allmodconfig fails to build:
> 
> drivers/net/ethernet/mediatek/mtk_star_emac.c: In function 'mtk_star_enable':
> drivers/net/ethernet/mediatek/mtk_star_emac.c:980:29: error: 'struct mtk_star_priv' has no member named 'rx_napi'; did you mean 'napi'?
>   980 |         napi_disable(&priv->rx_napi);
>       |                             ^~~~~~~
>       |                             napi
> drivers/net/ethernet/mediatek/mtk_star_emac.c:981:29: error: 'struct mtk_star_priv' has no member named 'tx_napi'; did you mean 'napi'?
>   981 |         napi_disable(&priv->tx_napi);
>       |                             ^~~~~~~
>       |                             napi
> 
> 

Should now be fixed in -rc2
