Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACD33D8E4D
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 14:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbhG1MxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 08:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235105AbhG1MxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 08:53:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 632B760FC0;
        Wed, 28 Jul 2021 12:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627476780;
        bh=qNhkG8u5fo9PXUX95VbmSmkx1Tw4abieBf5T2Nmp9Zs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lp/zwMDYg3rPs6orCp+QGUd2nySLvPw9iPlqe8cFsQZoGc7LPA0wl9nOO5WzFUEyd
         Y7o6y6knGhkeWd5YioJrXK7FJLFcHv5nt5sJ0hir70Z4rxXSTPZQuVT5eTsCq5pg8D
         qxyTf/qm1gkaRQwBqR6AM3fP+gw0G0C4EdKKMsyw=
Date:   Wed, 28 Jul 2021 14:52:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Klink <flokli@flokli.de>
Cc:     Moritz Fischer <mdf@kernel.org>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        linux-kernel@vger.kernel.org, gabriel.kh.huang@fii-na.com,
        moritzf@google.com, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Revert "usb: renesas-xhci: Fix handling of unknown ROM
 state"
Message-ID: <YQFTKug7VeUcuMG9@kroah.com>
References: <20210719070519.41114-1-mdf@kernel.org>
 <c0f191cc-6400-7309-e8a4-eab0925a3d54@universe-factory.net>
 <YPhRu/DWbs58hgvq@epycbox.lan>
 <20210728123755.md5zvbeeop3shmve@tp.flokli.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728123755.md5zvbeeop3shmve@tp.flokli.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 02:37:55PM +0200, Florian Klink wrote:
> On 21-07-21 09:56:27, Moritz Fischer wrote:
> > On Wed, Jul 21, 2021 at 05:28:21PM +0200, Matthias Schiffer wrote:
> > > On 7/19/21 9:05 AM, Moritz Fischer wrote:
> > > > This reverts commit d143825baf15f204dac60acdf95e428182aa3374.
> > > >
> > > > Justin reports some of his systems now fail as result of this commit:
> > > >
> > > >   xhci_hcd 0000:04:00.0: Direct firmware load for renesas_usb_fw.mem failed with error -2
> > > >   xhci_hcd 0000:04:00.0: request_firmware failed: -2
> > > >   xhci_hcd: probe of 0000:04:00.0 failed with error -2
> > > >
> > > > The revert brings back the original issue the commit tried to solve but
> > > > at least unbreaks existing systems relying on previous behavior.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Cc: Mathias Nyman <mathias.nyman@intel.com>
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: Vinod Koul <vkoul@kernel.org>
> > > > Cc: Justin Forbes <jmforbes@linuxtx.org>
> > > > Reported-by: Justin Forbes <jmforbes@linuxtx.org>
> > > > Signed-off-by: Moritz Fischer <mdf@kernel.org>
> > > > ---
> > > >
> > > > Justin,
> > > >
> > > > would you be able to help out testing follow up patches to this?
> > > >
> > > > I don't have a machine to test your use-case and mine definitly requires
> > > > a firmware load on RENESAS_ROM_STATUS_NO_RESULT.
> > > >
> > > > Thanks
> > > > - Moritz
> > > 
> > > 
> > > Hi Moritz,
> > > 
> > > as an additional data point, here's the behaviour of my system, a Thinkpad
> > > T14 AMD with:
> > 
> > Thanks!
> 
> Other Thinkpad (X13 AMD) user here.
> 
> > 06:00.0 USB controller: Renesas Technology Corp. uPD720202 USB 3.0 Host Controller (rev 02)
> 
> When upgrading from 5.13 5.13.2, suddenly the internal webcam, connected
> via USB (and possibly other peripherals) was gone.
> 
> It took me some digging until I came to this thread.
> 
> I see the same firmware load failures:
> 
> > xhci_hcd 0000:06:00.0: Direct firmware load for renesas_usb_fw.mem failed with error -2
> > xhci_hcd 0000:06:00.0: request_firmware failed: -2
> > xhci_hcd: probe of 0000:06:00.0 failed with error -2
> 
> I can confirm a revert of d143825baf15f204dac60acdf95e428182aa3374 fixes
> it.
> 
> > > 
> > > 06:00.0 USB controller [0c03]: Renesas Technology Corp. uPD720202 USB 3.0
> > > Host Controller [1912:0015] (rev 02)
> > > 
> > > - On Kernel 5.13.1, no firmware: USB controller resets in an endless loop
> > > when the system is running from battery
> > > - On Kernel 5.13.4, no firmware: USB controller probe fails with the
> > > mentioned firmware load error
> > > - On Kernel 5.13.4, with renesas_usb_fw.mem: everything is working fine, the
> > > reset issue is gone
> > > 
> > > So it seems to me that requiring a firmware is generally the correct driver
> > > behaviour for this hardware. The firmware I found in the Arch User
> > > Repository [1] unfortunately has a very restrictive license...
> > 
> > Yeah, the chip definitely needs the firmware. It can either initialize
> > from external ROM or runtime loaded firmware.
> > 
> > I think the problem really lies in how the current (and reverted) code
> > detects the need for firmware loading.
> > 
> > The current code looks at two indicators:
> > - Is there an external ROM and if so, did somebody try to program the
> >  external ROM and succeed? (renesas_check_rom_state)
> > - Did somebody try to runtime-load firmware, and if so did they succeed?
> >  (renesas_fw_check_running, after the early return)
> > 
> > The first one (and resulting early return) does *not* tell you whether
> > the controller actually has firwmare. That's what breaks my systems.
> > 
> > The second one is only really useful *if* we also check that FW_DOWNLOAD
> > was locked.
> > 
> > Neither of the above captures the case where you actually have an
> > external ROM that is programmed with proper firmware and caused the chip
> > to be loaded with said firmware.
> > 
> > Now before the patch that was reverted, since nobody tried to program
> > the ROM, it feel through to the "do nothing" in this case -- which
> > worked since it configured itself from external ROM.
> > 
> > Now how do we properly determine we do or don't need firwmare?
> > 
> > Looking at the datasheet I see two options.
> > - The version register? I need to investigate what that resets to with
> >  an unprogrammed/corrupted ROM. If that reliably gives a detectable value
> >  this could be used as an indicator.
> > 
> > - The USBSTS register according to the datasheet will report an error
> >  through the HCE bit:
> >  "If both uDP720201 and uDP720202 detect no correct firmware in Serial
> >  ROM, this flag will be set"
> > 
> > I'll put up an RFC in the next couple of days ...
> 
> Is the RFC already out somewhere?
> 
> Regardless of that, maybe we should push the trivial revert to
> linux-stable first, so users don't run into this unexpectedly.

It's already merged in the stable trees, right?
