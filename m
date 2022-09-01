Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB745A9395
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiIAJuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 05:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbiIAJuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 05:50:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE616564CD;
        Thu,  1 Sep 2022 02:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45FE361AFB;
        Thu,  1 Sep 2022 09:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13489C433D6;
        Thu,  1 Sep 2022 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662025806;
        bh=7h5BOZHPtqnTEJNeK9WhUGvbg4yr1amdKykOlMagcp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Be7a2tb5V3Nf/P/jwAV8YMBzSnVk8ylqUKA/EasuQtnIZul4ZUfQugFlrhXhNQOuJ
         UWIXJ5mxq9ACKl5nyinLiGPdXR8j7SVFBw/X54xQZdWaCh5JAq4irt76je0CEOXF1N
         nyz4vb5Jgz1+x7Tmigpydaevdpm/l2Ro6xiUA6QI=
Date:   Thu, 1 Sep 2022 11:50:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/136] 5.15.64-rc1 review
Message-ID: <YxCATHEyQapj71yn@kroah.com>
References: <20220829105804.609007228@linuxfoundation.org>
 <e9834880-c16e-e269-30ba-3fa8a94ba1af@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9834880-c16e-e269-30ba-3fa8a94ba1af@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 11:32:24AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 29/08/2022 11:57, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.64 release.
> > There are 136 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.64-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> I have been out on vacation and unfortunately some boot issues were
> introduced for Tegra back in 5.15.61 ...
> 
> Test results for stable-v5.15:
>     10 builds:	10 pass, 0 fail
>     32 boots:	28 pass, 4 fail
>     68 tests:	68 pass, 0 fail
> 
> Linux version:	5.15.64-rc1-g881ab4a7404d
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                 tegra20-ventana, tegra210-p2371-2180,
>                 tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Boot failures:	tegra186-p2771-0000, tegra194-p2972-0000,
>                 tegra194-p3509-0000+p3668-0000
> 
> 
> Fortunately, these boot issues are specific to Tegra and were caused by
> commit a7f751d4e830c5a2ac9e9908df43e8d29b7d3b22 ("arm64: tegra: Mark BPMP
> channels as no-memory-wc"). This commit had the fixes tag populated but it
> has a dependency on mainline commit a4740b148a04 ("firmware: tegra: bpmp: Do
> only aligned access to IPC memory area") which did not have any fixes tag
> populated.
> 
> Can you pull mainline commit a4740b148a04 ("firmware: tegra: bpmp: Do only
> aligned access to IPC memory area") into 5.15.y, 5.18.y and 5.19.y? Fine if
> you want to do it for the next stable update.

5.18.y is end-of-life, so I've applied this to the other branches now,
thanks!

greg k-h
