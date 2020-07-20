Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5C1226343
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgGTPZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgGTPZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:25:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE45A20709;
        Mon, 20 Jul 2020 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595258719;
        bh=jdj9paZnlpTbmlF16p7NrfstzvTc8IWb5Tm8ItMq2+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PAwfvVlwSqrMZTJI85UWln/2G9vO/2ZS6Ntw5so6EUun9KUjLyZe5+WCVQkHcYPQy
         tE21f4DQDVLwIIGahuRwuKyUAdza2TnxcxunuoVMC3iCLZ8FXRkutE79H2XErGC/1+
         yj6F8vsGJ689VkrJQpTWZ9wNyjnA3K3RLdDW6R5o=
Date:   Mon, 20 Jul 2020 17:25:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, saravanak@google.com
Subject: Re: stable-rc 5.4: arm build =?utf-8?Q?fai?=
 =?utf-8?Q?led=3A_arm-init=2Ec=3A327=3A12=3A_error=3A_implicit_declaration?=
 =?utf-8?B?IG9mIGZ1bmN0aW9uIOKAmGdldF9kZXZfZnJvbV9md25vZGXigJk=?=
Message-ID: <20200720152529.GA1390777@kroah.com>
References: <CA+G9fYuPe=XkrTx+yDo556D5t4wrFRFXctPPb2+7w+v-hAHvyw@mail.gmail.com>
 <CAK8P3a24UWMoH9775FD3++Uwp1O-9gJkjoiq0M21RLZoe7TxbQ@mail.gmail.com>
 <20200720152407.GA1381945@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200720152407.GA1381945@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 05:24:07PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jul 20, 2020 at 05:04:57PM +0200, Arnd Bergmann wrote:
> > On Mon, Jul 20, 2020 at 4:46 PM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> > >
> > > arm build failed on stable-rc 5.4 branch.
> > >
> > > make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j32 ARCH=arm
> > > CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> > > arm-linux-gnueabihf-gcc" O=build zImage
> > > #
> > > ../drivers/firmware/efi/arm-init.c: In function ‘efifb_add_links’:
> > > ../drivers/firmware/efi/arm-init.c:327:12: error: implicit declaration
> > > of function ‘get_dev_from_fwnode’
> > > [-Werror=implicit-function-declaration]
> > >   327 |  sup_dev = get_dev_from_fwnode(&sup_np->fwnode);
> > >       |            ^~~~~~~~~~~~~~~~~~~
> > > ../drivers/firmware/efi/arm-init.c:327:10: warning: assignment to
> > > ‘struct device *’ from ‘int’ makes pointer from integer without a cast
> > > [-Wint-conversion]
> > >   327 |  sup_dev = get_dev_from_fwnode(&sup_np->fwnode);
> > >       |          ^
> > > ../drivers/firmware/efi/arm-init.c: At top level:
> > > ../drivers/firmware/efi/arm-init.c:352:3: error: ‘const struct
> > > fwnode_operations’ has no member named ‘add_links’
> > >   352 |  .add_links = efifb_add_links,
> > >       |   ^~~~~~~~~
> > > ../drivers/firmware/efi/arm-init.c:352:15: error: initialization of
> > > ‘struct fwnode_handle * (*)(struct fwnode_handle *)’ from incompatible
> > > pointer type ‘int (*)(const struct fwnode_handle *, struct device *)’
> > > [-Werror=incompatible-pointer-types]
> > >   352 |  .add_links = efifb_add_links,
> > >       |               ^~~~~~~~~~~~~~~
> > > ../drivers/firmware/efi/arm-init.c:352:15: note: (near initialization
> > > for ‘efifb_fwnode_ops.get’)
> > >
> > >
> > > seems like this is coming from the below patch
> > > --
> > > efi/arm: Defer probe of PCIe backed efifb on DT systems
> > > [ Upstream commit 64c8a0cd0a535891d5905c3a1651150f0f141439 ]
> > >
> > > The new of_devlink support breaks PCIe probing on ARM platforms booting
> > > via UEFI if the firmware exposes a EFI framebuffer that is backed by a
> > > PCI device. The reason is that the probing order gets reversed,
> > > resulting in a resource conflict on the framebuffer memory window when
> > > the PCIe probes last, causing it to give up entirely.
> > >
> > > Given that we rely on PCI quirks to deal with EFI framebuffers that get
> > > moved around in memory, we cannot simply drop the memory reservation, so
> > > instead, let's use the device link infrastructure to register this
> > > dependency, and force the probing to occur in the expected order.
> > >
> > > Co-developed-by: Saravana Kannan <saravanak@google.com>
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > > Link: https://lore.kernel.org/r/20200113172245.27925-9-ardb@kernel.org
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > It seems that the stable kernels need a backport of commit 372a67c0c5ef
> > ("driver core: Add fwnode_to_dev() to look up device from fwnode") as well.
> 
> Ick, really?
> 
> I think we should just drop the efi patch as if it relying on device
> link, that is only in newer kernels.
> 
> I'll go do that now, thanks.

Yeah, that's why it wasn't backported to 5.4 in the first place, it went
into 5.5.6 when it got merged into 5.6-rc.

thanks,

greg k-h
