Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9964D3BF1
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 22:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbiCIVS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 16:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238108AbiCIVSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 16:18:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AE73B014;
        Wed,  9 Mar 2022 13:17:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D06361ADD;
        Wed,  9 Mar 2022 21:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A172C340E8;
        Wed,  9 Mar 2022 21:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646860672;
        bh=q/sUzokJDcCDhF1AND5ocTrgy9MD8fJuUYSeo9aXAug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=msUJ87NOhGULbVoLbEmh2AIm8+utgHpCQRNRP9nEh7TtPbNPoRdqxfT4Xf/vDHl7K
         mcXj1ClL7JwC16QsosfI/TlCOUP9UZbZLhNGAY8ozwArxrq2cuQwtxSFuQd5EUkuzS
         2i9go+QbPqeDsaTJEO38I817Ikce6VdOKO9y9Tc0=
Date:   Wed, 9 Mar 2022 22:17:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 00/37] 5.16.14-rc1 review
Message-ID: <YikZepRb0L7XygHD@kroah.com>
References: <20220309155859.086952723@linuxfoundation.org>
 <37efd441-7fe4-1aa4-a41b-19d30b652c5c@roeck-us.net>
 <YikHrEtQ5dFz9paK@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YikHrEtQ5dFz9paK@kroah.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 09:01:48PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Mar 09, 2022 at 11:05:15AM -0800, Guenter Roeck wrote:
> > On 3/9/22 08:00, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.16.14 release.
> > > There are 37 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Almost all arm builds, all branches from 4.9.y to 5.16.y:
> > 
> > Error log:
> > arch/arm/common/secure_cntvoff.S: Assembler messages:
> > arch/arm/common/secure_cntvoff.S:24: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
> > arch/arm/common/secure_cntvoff.S:27: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
> > arch/arm/common/secure_cntvoff.S:29: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
> > 
> > bisect log:
> > 
> > # bad: [3416254dac79ea26e08dffde371ab1fd3130223c] Linux 5.16.14-rc1
> > # good: [6273c309621c9dd61c9c3f6d63f5d56ee2d89c73] Linux 5.16.13
> > git bisect start 'HEAD' 'v5.16.13'
> > # bad: [4403d69931dbc17659845d2d710602bbe35b4398] KVM: arm64: Allow indirect vectors to be used without SPECTRE_V3A
> > git bisect bad 4403d69931dbc17659845d2d710602bbe35b4398
> > # good: [6f0cf3a1eb8b46a5d652a395ba25a59c32a86692] ARM: report Spectre v2 status through sysfs
> > git bisect good 6f0cf3a1eb8b46a5d652a395ba25a59c32a86692
> > # bad: [87e96a363eb4a62b65bb974a46d518a87153cd1c] arm64: add ID_AA64ISAR2_EL1 sys register
> > git bisect bad 87e96a363eb4a62b65bb974a46d518a87153cd1c
> > # good: [654f0a73f042662a36155a0cafa30db846ccb5a9] ARM: use LOADADDR() to get load address of sections
> > git bisect good 654f0a73f042662a36155a0cafa30db846ccb5a9
> > # bad: [91bdae56c40ee6de675fba6ac283311c92c437ce] ARM: include unprivileged BPF status in Spectre V2 reporting
> > git bisect bad 91bdae56c40ee6de675fba6ac283311c92c437ce
> > # bad: [95ff4cb3b696a581d6166f0d754771bf9af5e27b] ARM: Spectre-BHB workaround
> > git bisect bad 95ff4cb3b696a581d6166f0d754771bf9af5e27b
> > # first bad commit: [95ff4cb3b696a581d6166f0d754771bf9af5e27b] ARM: Spectre-BHB workaround
> > 
> > Guenter
> 
> Wow these are all broken, have I mentioned I hate working on patches in
> embargos?
> 
> I'll look at these in the morning, it's odd that Linus's tree isn't
> showing these same issue, but I might have messed up the arm backports
> somehow.  I did test them on using the multi_v7_defconfig configuration
> and they built for me locally with gcc.  I'll try to see what is
> different here...

Ah, 33970b031dc4 ("ARM: fix co-processor register typo") looks to solve
a bunch of these, I'll queue that up now...
