Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5299653602
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 19:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiLUSTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 13:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbiLUSTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 13:19:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55987F7C;
        Wed, 21 Dec 2022 10:19:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E469B618A8;
        Wed, 21 Dec 2022 18:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DB0C433EF;
        Wed, 21 Dec 2022 18:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671646745;
        bh=rgE/++iNjfIht0vkb5As1fT6+eAEzONl8QvRYMNWxVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oMRdZG6EOZUl8QgrH3BqDc4jpU9852LGhM67FT6eK4weFV1b5hrLNI2mEJ2xI6My3
         HISWJcIkYOGOmmOwbflsdr49nNthglwI3RWoKwRxBujIqunYhbmJYKeYgHXzecJkLU
         kqmq4cfdY9Ov8QcOsMnt/9YA94vfu1Jc8WyBBTes=
Date:   Wed, 21 Dec 2022 19:19:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <Y6NOFisxidbxoOed@kroah.com>
References: <20221219182943.395169070@linuxfoundation.org>
 <Y6Gp25YJ/m+DcgWH@debian>
 <CADVatmM9_d6gOo7VTM1ybVgNDM_w2+NdKM3DC67L9KjeWL7Ltg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmM9_d6gOo7VTM1ybVgNDM_w2+NdKM3DC67L9KjeWL7Ltg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 02:31:20PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Tue, 20 Dec 2022 at 12:26, Sudip Mukherjee (Codethink)
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > Hi Greg,
> >
> > On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.1 release.
> > > There are 25 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > > Anything received after that time might be too late.
> >
> 
> <snip>
> 
> >
> > Boot test:
> > x86_64: Booted on my test laptop. No regression.
> > x86_64: Booted on qemu. No regression. [1]
> > arm64: Booted on rpi4b (4GB model). No regression. [2]
> > mips: Booted on ci20 board. Regression.
> >
> > Note:
> > networking.service is failing on mips ci20 boards. Issue seen on v6.1 also.
> > Will report upstream after bisecting.
> 
> This has already been fixed in mainline by:
> ca637c0ece14 ("MIPS: DTS: CI20: fix reset line polarity of the
> ethernet controller")
> 
> I have tested 6.1.1-rc1 with the above commit cherry-picked and it has
> fixed the issue.

Thanks for letting me know, now queued up.

greg k-h
