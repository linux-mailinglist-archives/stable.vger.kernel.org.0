Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9B35E7955
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 13:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiIWLVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 07:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiIWLVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 07:21:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E6D127563;
        Fri, 23 Sep 2022 04:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 704D061347;
        Fri, 23 Sep 2022 11:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54371C433D6;
        Fri, 23 Sep 2022 11:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663932091;
        bh=qWTeDWNmSq+YSAdgSKvScHEIJ19cF4WG2sxdTmr2afA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ewNOuceFpIBaGJERQkijuppxASAvM477SdlibmfOIBW7wScZgc7m57gUmcp6aVV/u
         7selXZGepMVrPYfumrkFxelbXVxntEKAPJjW5tyYp3plKPkFlF+qXlNjemumjkcEFb
         wSsJSI/cTx+oxbTAMFI/96GmhJgquIxPGZ484D5k=
Date:   Fri, 23 Sep 2022 13:21:28 +0200
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
Subject: Re: [PATCH 5.15 00/45] 5.15.70-rc1 review
Message-ID: <Yy2WuLeIUBVn09Hj@kroah.com>
References: <20220921153646.931277075@linuxfoundation.org>
 <Yyw6es9RdujAwChq@debian>
 <CADVatmMCmqXjo6_b-g3E=n6nXSftZ=49Q_OPvMOyGNCOKb0J=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmMCmqXjo6_b-g3E=n6nXSftZ=49Q_OPvMOyGNCOKb0J=A@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 01:35:24PM +0100, Sudip Mukherjee wrote:
> On Thu, Sep 22, 2022 at 11:35 AM Sudip Mukherjee (Codethink)
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Sudip,
> >
> > On Wed, Sep 21, 2022 at 05:45:50PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.70 release.
> > > There are 45 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> > > Anything received after that time might be too late.
> >
> > Build test (gcc version 12.2.1 20220919):
> > mips: 62 configs -> no failure
> > arm: 99 configs -> no failure
> > arm64: 3 configs -> 2 failures
> > x86_64: 4 configs -> no failure
> > alpha allmodconfig -> no failure
> > csky allmodconfig -> no failure
> > powerpc allmodconfig -> no failure
> > riscv allmodconfig -> no failure
> > s390 allmodconfig -> no failure
> > xtensa allmodconfig -> no failure
> >
> > arm64 allmodconfig and rpi4 config have failed with the error: (fails with both gcc-12 and gcc-11).
> >
> > arch/arm64/kernel/kexec_image.c:136:23: error: 'kexec_kernel_verify_pe_sig' undeclared here (not in a function); did you mean 'arch_kexec_kernel_verify_sig'?
> >   136 |         .verify_sig = kexec_kernel_verify_pe_sig,
> >       |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
> >       |                       arch_kexec_kernel_verify_sig
> 
> Bisect pointed to 3a27b0950129 ("arm64: kexec_file: use more system
> keyrings to verify kernel image signature").

Thanks, that's obviously not right.  I'll go drop that commit now.

greg k-h
