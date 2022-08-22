Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8474359BC2B
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 11:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiHVJBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 05:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbiHVJA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 05:00:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE202E9EF;
        Mon, 22 Aug 2022 02:00:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFD6960AD7;
        Mon, 22 Aug 2022 09:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB127C433D7;
        Mon, 22 Aug 2022 09:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661158855;
        bh=/r635Nf0GeBhwc+wnSHRPBxLAAUJnF8htkFn+8pytfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YhoZieWNU1+BD+y8GAvexW7gtzw7/8i91r4/y0ie7lO6GwzasEo6h4TcPTAthtF7G
         VaSKrfTZCUcpOYqPi6QKh6EpdG6AdqZVXyU6mEjiRnVKN2LUXHowPqoZfLUQA6stXS
         dR3BTN2HCl2cnMqaVjKlL1iW5n184HVDqy7L8Q7w=
Date:   Mon, 22 Aug 2022 11:00:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x86_64@vger.kernel.org
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
Message-ID: <YwNFxIouYoRo/wT+@kroah.com>
References: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
 <YwMhXX6OhROLZ/LR@kroah.com>
 <1ed5a33a-b667-0e8e-e010-b4365f3713d6@gmx.com>
 <YwMxRAfrrsPE6sNI@kroah.com>
 <8aff5c17-d414-2412-7269-c9d15f574037@gmx.com>
 <YwM3DwvPIGkfE4Tu@kroah.com>
 <acc6051b-748f-4f06-63b3-919eb831217c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acc6051b-748f-4f06-63b3-919eb831217c@gmx.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 04:13:03PM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/8/22 15:58, Greg KH wrote:
> > On Mon, Aug 22, 2022 at 03:49:51PM +0800, Qu Wenruo wrote:
> > > 
> > > 
> > > On 2022/8/22 15:33, Greg KH wrote:
> > > > On Mon, Aug 22, 2022 at 03:24:53PM +0800, Qu Wenruo wrote:
> > > > > 
> > > > > 
> > > > > On 2022/8/22 14:25, Greg KH wrote:
> > > > > > On Mon, Aug 22, 2022 at 09:15:59AM +0800, Qu Wenruo wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > When backporting some btrfs specific patches to all LTS kernels, I found
> > > > > > > v4.14.290 kernel unable to boot as a KVM guest with edk2-ovmf
> > > > > > > (edk2-ovmf: 202205, qemu 7.0.0, libvirt 1:8.6.0).
> > > > > > > 
> > > > > > > While all other LTS/stable branches (4.19.x, 5.4.x, 5.10.x, 5.15.x,
> > > > > > > 5.18.x, 5.19.x) can boot without a hipccup.
> > > > > > > 
> > > > > > > I tried the following configs, but none of them can even provide an
> > > > > > > early output:
> > > > > > > 
> > > > > > > - CONFIG_X86_VERBOSE_BOOTUP
> > > > > > > - CONFIG_EARLY_PRINTK
> > > > > > > - CONFIG_EARLY_PRINTK_EFI
> > > > > > > 
> > > > > > > Is this a known bug or something new?
> > > > > > 
> > > > > > Has this ever worked properly on this very old kernel tree?  If so, can
> > > > > > you use 'git bisect' to find the offending commit?
> > > > > 
> > > > > Unfortunately the initial v4.14 from upstream can not even be compiled.
> > > > 
> > > > Really?  Try using an older version of gcc and you should be fine.  It
> > > > did build properly back in 2017 when it was released :)
> > > 
> > > Yeah, I'm pretty sure my toolchain is too new for v4.14.0. But my distro
> > > only provides the latest and mostly upstream packages.
> > > 
> > > It may be a even worse disaster to find a way to rollback to older
> > > toolchains using my distro...
> > > 
> > > Also my hardware may not be well suited for older kernels either.
> > > (Zen 3 CPU used here)
> > > 
> > > In fact, I even find it hard just to locate a v4.14.x tag that can compile.
> > > After some bisection between v4.14.x tags, only v4.14.268 and newer tags
> > > can even be compiled using latest toolchain.
> > > (But still tons of warning, and tons of objdump warnings against
> > > insn_get_length()).
> > > 
> > > I'm not sure what's the normal practice for backports to such old branch.
> > > 
> > > Do you stable guys keep dedicated VMs loaded with older distro just for
> > > these old branches?
> > 
> > I don't, that's why those kernels can be built with newer versions of
> > gcc.
> > 
> > Your distro should have a version of gcc-10 or gcc-9 that can be
> > installed, right?
> 
> This may sounds like a meme, but I'm really using Archlinux for my VM
> and host, and it doesn't provide older GCC at all.

Archlinux does provide older gcc versions, that's what I use.

It still supports gcc11 in the main repo, and there is gcc10 in AUR as
well as gcc9.  Try those!

good luck!

greg k-h
