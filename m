Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBB2532A0E
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 14:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbiEXMJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 08:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237179AbiEXMJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 08:09:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0468469732;
        Tue, 24 May 2022 05:09:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A977CB818B6;
        Tue, 24 May 2022 12:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814B5C385AA;
        Tue, 24 May 2022 12:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653394148;
        bh=hiARRylI+i7IS43C7Rjpcem8mau4qP1iPmqwydlZzi4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M9sNXs1EO07RbtRbQitF6xYtvmdZ/Q3SHObS3gb3UOBbokvFco2IX9V2rGdsmnWuk
         wclkFgr4bIk9/8RewMsMaQ6uJDB9W7X0GljjBmkFZwdd611D4QoWq76HL49gBI2Gt4
         Q/TD4Gn411nS47AEuGrwiGjm7yZDtlVKxCoFqFxk=
Date:   Tue, 24 May 2022 14:09:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/25] 4.9.316-rc1 review
Message-ID: <YozK4DvamHBJ1qdX@kroah.com>
References: <20220523165743.398280407@linuxfoundation.org>
 <6f4034a5-f692-8a64-a09d-8bfe49767b78@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f4034a5-f692-8a64-a09d-8bfe49767b78@nvidia.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 24, 2022 at 09:32:07AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 23/05/2022 18:03, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.316 release.
> > There are 25 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.316-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > Ard Biesheuvel <ardb@kernel.org>
> >      ARM: 9196/1: spectre-bhb: enable for Cortex-A15
> 
> 
> I am seeing a boot regression on tegra124-jetson-tk1 and reverting the above
> commit is fixing the problem. This also appears to impact linux-4.14.y,
> 4.19.y and 5.4.y.
> 
> Test results for stable-v4.9:
>     8 builds:	8 pass, 0 fail
>     18 boots:	16 pass, 2 fail
>     18 tests:	18 pass, 0 fail
> 
> Linux version:	4.9.316-rc1-gbe4ec3e3faa1
> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 
> Boot failures:	tegra124-jetson-tk1

Odd.  This is also in 5.10.y, right?  No issues there?  Are we missing
something?
