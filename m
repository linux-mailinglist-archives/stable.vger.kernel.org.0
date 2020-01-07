Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABB7132F79
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 20:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgAGTat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 14:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbgAGTat (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 14:30:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D66ED206DB;
        Tue,  7 Jan 2020 19:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578425448;
        bh=RcixPhzFLFpfoeFpHnTwEM2jSreesLXT8nwQzlKShsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mspJgrcd3kka6cRo+m/U4Jk7qGCePRKsS2a86k+iP6adF9v7uQxR84KhP4c0z0NYh
         OcoENlWN8eKeW/waEEdBjCv613rFOeKnd8XONxxn2G5BBQ2Okfshb5GHklCCKkja0+
         7OtcjypDEs10nMLdEsmZ3sXif0Dld54tNdO8+eSg=
Date:   Tue, 7 Jan 2020 20:30:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tejun Heo <tj@kernel.org>, Jaedon Shin <jaedon.shin@gmail.com>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 0/8] ata: ahci_brcm: Fixes and new device support
Message-ID: <20200107193046.GB2021584@kroah.com>
References: <20191210185351.14825-1-f.fainelli@gmail.com>
 <CA+G9fYsMyUWGo8Qtd2UCfYDV2aoH71=hCZKaTurq4Aj2eeZczw@mail.gmail.com>
 <CA+G9fYvmwetcZPraZrHbj=MjgWZik-wFK7nEejs-6TrYyODcSg@mail.gmail.com>
 <f2867b48-7ee3-4545-5d3e-19622120be4c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2867b48-7ee3-4545-5d3e-19622120be4c@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 09:39:58AM -0800, Florian Fainelli wrote:
> On 1/7/20 9:29 AM, Naresh Kamboju wrote:
> > On Tue, 7 Jan 2020 at 22:17, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >>
> >> On Wed, 11 Dec 2019 at 00:25, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>>
> >>> Hi Jens,
> >>>
> >>> The first 4 patches are fixes and should ideally be queued up/picked up
> >>> by stable. The last 4 patches add support for BCM7216 which is one of
> >>> our latest devices supported by this driver.
> >>>
> >>> Patch #2 does a few things, but it was pretty badly broken before and it
> >>> is hard not to fix all call sites (probe, suspend, resume) in one shot.
> >>>
> >>> Please let me know if you have any comments.
> >>>
> >>> Thanks!
> >>>
> >>> Florian Fainelli (8):
> >>>   ata: libahci_platform: Export again ahci_platform_<en/dis>able_phys()
> >>>   ata: ahci_brcm: Fix AHCI resources management
> >>
> >> Following error on stable-rc 4.14 and 4.9 branch for arm build.
> > 
> > Following error on stable-rc 4.19, 4.14 and 4.9 branch for arm build.
> > 
> >>
> >>  drivers/ata/ahci_brcm.c: In function 'brcm_ahci_probe':
> >>  drivers/ata/ahci_brcm.c:412:28: error: 'struct brcm_ahci_priv' has no
> >> member named 'rcdev'; did you mean 'dev'?
> >>    if (!IS_ERR_OR_NULL(priv->rcdev))
> >>                              ^~~~~
> >>                              dev
> >>    CC      fs/pnode.o
> >>    CC      block/genhd.o
> >>  drivers/ata/ahci_brcm.c:413:3: error: implicit declaration of
> >> function 'reset_control_assert'; did you mean 'ahci_reset_controller'?
> >> [-Werror=implicit-function-declaration]
> >>     reset_control_assert(priv->rcdev);
> >>     ^~~~~~~~~~~~~~~~~~~~
> >>     ahci_reset_controller
> >>  drivers/ata/ahci_brcm.c:413:30: error: 'struct brcm_ahci_priv' has no
> >> member named 'rcdev'; did you mean 'dev'?
> >>     reset_control_assert(priv->rcdev);
> >>                                ^~~~~
> >>                                dev
> >>  cc1: some warnings being treated as errors
> >>
> >> Full build log links,
> >> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.14/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/702/consoleText
> >> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.9/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/773/consoleText
> > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.19/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/404/consoleText
> 
> The reset controller support was added in
> 2b2c47d9e1fe90311b725125d6252a859ee87a79 ("ata: ahci_brcm: Allow
> optional reset controller to be used") which was include in v4.20 and
> newer so that explains the build failure.
> 
> You may want to cherry pick that change into the respective stable
> branches and then back port the fixes if that is not too much trouble.
> If that does not work or is impractical, please let me know and I can
> provide directed backport changes for 4.9, 4.14 and 4.19.

No need, I'll just queue up the other needed patch now, thanks.

greg k-h
