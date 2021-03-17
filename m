Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE6633FB88
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 23:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCQWzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 18:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhCQWzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 18:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F34160240;
        Wed, 17 Mar 2021 22:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616021747;
        bh=kyJ1k05CwGcs1l3ct65j33bmqBoAbKKmiNglmuTpeq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pFuMfu7HLaMKilBv7JLCNzL4TR6dLDAIqdn53veVHceZhkGytjidEkRyUDPzUgvIJ
         d6yGIpYBHi+6g9kNsLNA5ETc+kazdLdJSvyUTSH6VY8IyxT7VilunnbsP5OetrAzGZ
         2oWETOZp8q4DO8VbW5DGbPVJjWGiRJl/c+U/h7o+todiyahBIFGHOR7kwHoA9D97RU
         o5gI8TVA0txBUatLLYiASQ0sQIggo+pfEOz03kXYXBJh/XYg8ZXLTJK7SLRw5E5m8O
         nwIUEq3l1U6oPo71MhJau+dCRHiTcnaBFNZXYaAu2hQkUFFtklJhnhOHy5ODzlduAi
         A9aDXwkfZFRmg==
Received: by pali.im (Postfix)
        id 98A7F8A9; Wed, 17 Mar 2021 23:55:44 +0100 (CET)
Date:   Wed, 17 Mar 2021 23:55:44 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        linux-pci@vger.kernel.org,
        =?utf-8?B?UsO2dHRp?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        stable@vger.kernel.org, Zachary Zhang <zhangzg@marvell.com>
Subject: Re: [PATCH] PCI: Add Max Payload Size quirk for ASMedia ASM1062 SATA
 controller
Message-ID: <20210317225544.fm4oyuujylsxa77b@pali>
References: <20210317115924.31885-1-kabel@kernel.org>
 <20210317224549.GA93134@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210317224549.GA93134@bjorn-Precision-5520>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 17 March 2021 17:45:49 Bjorn Helgaas wrote:
> [+cc Zachary, author of 8a3ebd8de328]
> 
> Thanks for the report and the patch, Marek!
> 
> On Wed, Mar 17, 2021 at 12:59:24PM +0100, Marek Behún wrote:
> > The ASMedia ASM1062 SATA controller causes an External Abort on
> > controllers which support Max Payload Size >= 512. It happens with
> > Aardvark PCIe controller (tested on Turris MOX) and also with DesignWare
> > controller (armada8k, tested on CN9130-CRB):
> > 
> >   ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> >   ata1.00: ATA-9: WDC WD40EFRX-68WT0N0, 80.00A80, max UDMA/133
> >   ata1.00: 7814037168 sectors, multi 0: LBA48 NCQ (depth 32), AA
> >   ERROR:   Unhandled External Abort received on 0x80000000 at EL3!
> >   ERROR:    exception reason=1 syndrome=0x92000210
> >   PANIC at PC : 0x00000000040273bc
> > 
> > Limiting Max Payload Size to 256 bytes solves this problem.
> > 
> > On Turris MOX this problem first appeared when the pci-aardvark
> > controller started using the pci-emul-bridge API, in commit 8a3ebd8de328
> > ("PCI: aardvark: Implement emulated root PCI bridge config space").
> 
> Any ideas about why 8a3ebd8de328 made a difference?  Could there be a
> defect in 8a3ebd8de328?  Or maybe before 8a3ebd8de328 we didn't
> actually read or update MPS settings in the hardware?

Hi Bjorn! It is because A3720 HW does not have real PCIe Root Bridge and
therefore kernel was not able to read nor write MPS settings.

Commit 8a3ebd8de328 added support for emulated PCIe Root Bridge on A3720
and aardvark driver started emulating it via internal aardvark registers
which supports reading and writing also MPS settings. So kernel was
finally able to set 512 byte payload.

And so after this commit kernel was able to set MPS and due to that
ASMedia bug system started crashing.

> > On armada8k this was always a problem because it has HW root bridge.
> 
> Can you please open a report at bugzilla.kernel.org and attach the
> complete "sudo lspci -vv" output for both systems?  I think it's OK to
> collect these with the patch applied; we should still be able to see
> the information we use to compute the MPS values.  But please include
> the CONFIG_PCIE_BUS_* settings and any "pcie_bus_*" kernel command
> line arguments.
> 
> This quirk suggests that there's a hardware defect in the ASMedia
> ASM1062.  But if that's really the case, we should see reports on lots
> of platforms, and I'm only aware of these two.

Do you have platform which support MPS of 512 bytes? Because I have not
seen any x86 / Intel PCIe controller with such support on ordinary
laptop and desktop.

These two (A3720 and CN9130) are the only which has support for it.

Has somebody else PCIe controller which Root Bridge supports MPS of 512
bytes?

Maybe they are in servers, but then such "cheap" SATA controllers are
not used in servers. So this is probably reason why nobody else reported
such issue.

> You do mention that it
> was always a problem on armada8k; if you know of other reports of
> that, please include URLs in the bugzilla.
> 
> If the problem only occurs on these platforms, my first guess would be
> a hardware defect in these platforms or a software defect in the PCIe
> controller driver.  It wouldn't surprise me if we have a generic PCI
> core defect in how we set MPS, either.
> 
> > Signed-off-by: Marek Behún <kabel@kernel.org>
> > Reported-by: Rötti <espressobinboardarmbiantempmailaddress@posteo.de>
> > Cc: Pali Rohár <pali@kernel.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/pci/quirks.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 653660e3ba9e..a561136efb08 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -3251,6 +3251,11 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
> >  			 PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SOLARFLARE,
> >  			 PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
> > +/*
> > + * For some reason DECLARE_PCI_FIXUP_HEADER does not work with pci-aardvark
> > + * controller. We have to use DECLARE_PCI_FIXUP_EARLY.
> > + */
> 
> This is curious, too.  If we need the quirk, I'd like to run this down
> to figure out why we need an EARLY instead of HEADER quirk.
> Differences like that suggest a bug elsewhere, or at least an
> unnecessary difference between PCIe controller drivers.
> 
> > +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ASMEDIA, 0x0612, fixup_mpss_256);
> >  
> >  /*
> >   * Intel 5000 and 5100 Memory controllers have an erratum with read completion
> > -- 
> > 2.26.2
> > 
