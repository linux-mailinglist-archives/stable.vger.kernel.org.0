Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56BA4D46C9
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 13:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241876AbiCJM0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 07:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237763AbiCJM0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 07:26:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980F663F4;
        Thu, 10 Mar 2022 04:25:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BA426191A;
        Thu, 10 Mar 2022 12:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3906C340E8;
        Thu, 10 Mar 2022 12:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646915116;
        bh=vcfAPDoZuzO8dkhCU5Hzdcr2BQ8q0N0ap2jBbaQyyLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v6jRM7Kk5NjMGYnB9QGFFeO3riCbdCt+1XM+OHvkksMt6f1SjgIgmEb38394wLZEm
         V37Y/Ts6BXso4gwuMlVgblnWv9fyWzcTBcrPKWFRcolL1r7/yqGdrtn5SBe4vBMQaR
         W5ZPRpmJaF+UjsJCBDqR9VTKBwlSJ2mQyWCYP1sk=
Date:   Thu, 10 Mar 2022 13:25:12 +0100
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
Subject: Re: [PATCH 4.19 00/18] 4.19.234-rc1 review
Message-ID: <YinuKNunDvWWLJs0@kroah.com>
References: <20220309155856.155540075@linuxfoundation.org>
 <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
 <Yijw3wz29xNiIhWl@kroah.com>
 <CADVatmMbww0jVS7O9BmtrGzfyBN0hfm8n7QNEdZpiigJGSp20Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmMbww0jVS7O9BmtrGzfyBN0hfm8n7QNEdZpiigJGSp20Q@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 09:51:12AM +0000, Sudip Mukherjee wrote:
> On Thu, Mar 10, 2022 at 9:18 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Mar 09, 2022 at 06:08:19PM +0000, Sudip Mukherjee wrote:
> > > Hi Greg,
> > >
> > > On Wed, Mar 9, 2022 at 4:03 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 4.19.234 release.
> > > > There are 18 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> > > > Anything received after that time might be too late.
> > >
> > > My tests are still running, but just an initial result for you,
> > >
> > > x86_64 defconfig fails with:
> > > arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
> > > arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of
> > > function 'unprivileged_ebpf_enabled'
> > > [-Werror=implicit-function-declaration]
> > >   973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
> >
> > It's in a .h file, how can it be undefined?  Must be a include path
> > somewhere, let me dig...
> 
> Looks like the problem is that both "static inline bool
> unprivileged_ebpf_enabled(void)" are in the "#ifdef
> CONFIG_BPF_SYSCALL" section of include/linux/bpf.h.
> I think the one returning false should be in the #else section.

Ah, good catch!

I've fixed this up for 4.19 and 5.4 now, will do some build tests and
then push out new -rc2 release for all branches as I think that should
be all of the reported problems fixed.

Now on to the next new round of build failures!  :)

thanks,

greg k-h
