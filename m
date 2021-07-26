Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AB63D6878
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 23:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbhGZUdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 16:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232922AbhGZUdK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 16:33:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEABD60F5D;
        Mon, 26 Jul 2021 21:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627334018;
        bh=lzeqMw1augM9jIjp6DS7Z86oMsklA1uPRFTN6gP4N/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FCO2Of0F2qwRKsvCg49INNYLrWobJGDirVTcYzmc6av8P+fhSkRCyMzvDEA9SQHLD
         EAQ/PaJxGZbXtIYOuPYvSq8HV4ADqNuCgEFE4tPeRfbKrq34OA/+sqnHMcglfUW2EN
         GxOAED+kDhVNAci/OfK41Qp0InZjiFXccu0DvvN6MvpJbZTR+LQBejd8V5jAg4oSS/
         sFA+HJ1aTwmVLilpa0sH/vLCCFDATwxlqP2LrF4ptIvSEYmyI+76QTww/6wuevD9Wg
         dSKG6hI1JygymWkCwRM8ZHgnjuphd6HatRjCnk6k/D2I39Ay8FJypmAQDycOAQMMOS
         94Dm/vrb/PnAw==
Received: by pali.im (Postfix)
        id 1A8528A2; Mon, 26 Jul 2021 23:13:36 +0200 (CEST)
Date:   Mon, 26 Jul 2021 23:13:35 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        linux-pci@vger.kernel.org,
        =?utf-8?B?UsO2dHRp?= 
        <espressobinboardarmbiantempmailaddress@posteo.de>,
        Zachary Zhang <zhangzg@marvell.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI: Add Max Payload Size quirk for ASMedia ASM1062
 SATA controller
Message-ID: <20210726211335.2hkjrjpe2xavlyxd@pali>
References: <20210624171418.27194-2-kabel@kernel.org>
 <20210726172403.GA623272@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210726172403.GA623272@bjorn-Precision-5520>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 26 July 2021 12:24:03 Bjorn Helgaas wrote:
> On Thu, Jun 24, 2021 at 07:14:18PM +0200, Marek Behún wrote:
> > The ASMedia ASM1062 SATA controller advertises
> > Max_Payload_Size_Supported of 512, but in fact it cannot handle TLPs
> > with payload size of 512.
> > 
> > We discovered this issue on PCIe controllers capable of MPS = 512
> > (Aardvark and DesignWare), where the issue presents itself as an
> > External Abort. Bjorn Helgaas says:
> >   Probably ASM1062 reports a Malformed TLP error when it receives a data
> >   payload of 512 bytes, and Aardvark, DesignWare, etc convert this to an
> >   arm64 External Abort.
> > 
> > Limiting Max Payload Size to 256 bytes solves this problem.
> > 
> > Signed-off-by: Marek Behún <kabel@kernel.org>
> > BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212695
> > Reported-by: Rötti <espressobinboardarmbiantempmailaddress@posteo.de>
> > Cc: Pali Rohár <pali@kernel.org>
> > Cc: stable@vger.kernel.org
> 
> Applied both to pci/enumeration for v5.15, thanks!
> 
> Were you able to confirm that a Malformed TLP error was logged?  The
> lspci in the bugzilla is from a system with no AER support,

Hello Bjorn! That is because patch for AER support for pci-aardvark.c
driver was not reviewed / commented / merged yet:
https://lore.kernel.org/linux-pci/20210506153153.30454-43-pali@kernel.org/

Anyway, this arm64 external abort is currently sent to arm64 EL3 level
(implemented in trusted firmware) and not to kernel. And EL3 hook after
receiving this abort resets CPU, so we / kernel do not have opportunity
to look what is in AER registers.

So dumping AER registers in this stage from aardvark is quite harder.

Maybe it could be easier with DesignWare PCIe controller.

> so no
> information from that one.  I don't know if any of the PCIe
> controllers you tested support both AER and MPS=512.
> 
> > ---
> >  drivers/pci/quirks.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 4d9b9d8fbc43..a4ba3e3b3c5e 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -3239,6 +3239,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
> >  			PCI_DEVICE_ID_SOLARFLARE_SFC4000A_1, fixup_mpss_256);
> >  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SOLARFLARE,
> >  			PCI_DEVICE_ID_SOLARFLARE_SFC4000B, fixup_mpss_256);
> > +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ASMEDIA, 0x0612, fixup_mpss_256);
> >  
> >  /*
> >   * Intel 5000 and 5100 Memory controllers have an erratum with read completion
> > -- 
> > 2.31.1
> > 
