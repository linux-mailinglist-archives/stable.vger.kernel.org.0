Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99132524E57
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 15:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354455AbiELNcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 09:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354446AbiELNcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 09:32:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400C013CA02;
        Thu, 12 May 2022 06:32:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA4C060FF9;
        Thu, 12 May 2022 13:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E26C385B8;
        Thu, 12 May 2022 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652362362;
        bh=iea0wvYMraNHhc9IlNAJyT9swOt+7dgRX/XiM8IK73E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V9r8yQIeB0P4EdEg/9ZFaSn9+w3/lt4RTec+WroBnpB3Obe613rBheuB95t2Jc2BX
         rkuLU46AhA9Ar/cCLsSjEHVl02GieI6j2b3F+HZlHkWS452JUZX6Bg2KeE5B+tnthp
         8aJeCVvMxLaGdkwIWw8+tNlr0Y+DfxmXQvs9O1vk=
Date:   Thu, 12 May 2022 15:32:39 +0200
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
Subject: Re: [PATCH 5.10 00/70] 5.10.115-rc1 review
Message-ID: <Yn0Md78PJu1+nIKP@kroah.com>
References: <20220510130732.861729621@linuxfoundation.org>
 <CADVatmNyky-XXaeAiQ5ypZ7+7F7fzLshB4bNWt5v3RdnXStsOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmNyky-XXaeAiQ5ypZ7+7F7fzLshB4bNWt5v3RdnXStsOg@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 09:44:26PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Tue, May 10, 2022 at 2:25 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.115 release.
> > There are 70 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> > Anything received after that time might be too late.
> 
> Just some initial report for you.
> As mentioned in the mail for 4.19-stable, it will also need
> d422c6c0644b ("MIPS: Use address-of operator on section symbols").
> 
> But apart from that, there is also another failure.
> drivers/usb/phy/phy-generic.c: In function 'usb_phy_gen_create_phy':
> drivers/usb/phy/phy-generic.c:271:26: error: implicit declaration of
> function 'devm_regulator_get_exclusive'; did you mean
> 'regulator_get_exclusive'? [-Werror=implicit-function-declaration]
>   271 |         nop->vbus_draw = devm_regulator_get_exclusive(dev, "vbus");
> 
> This was introduced in v5.10.114 by d22d92230ffb ("usb: phy: generic:
> Get the vbus supply") but I missed testing that release. :(

Should now be fixed, thanks.

greg k-h
