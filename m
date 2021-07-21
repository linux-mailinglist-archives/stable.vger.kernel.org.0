Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85173D14AB
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 18:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhGUQPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 12:15:54 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:37719 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhGUQPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 12:15:53 -0400
Received: by mail-pl1-f175.google.com with SMTP id y3so1259047plp.4;
        Wed, 21 Jul 2021 09:56:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IBALwA0/lwQlCC9ArWBTvBN3bpZvZSDVrssut1ZL5To=;
        b=G5Dl+E1P/ctIAYcJVuRw+G2ejfCTfQirlVGDkVMCeoZvKN/jWIGa61XeWhl7aegIGN
         TitxiYIYCTrOH6ADBws9exWjLEbkaabzo5a/hZX6kA7PFfrHH+RnAlS2OPF5xFVV1aij
         XcgOvxiacNyqtkDe03ZzmtYg6Kgkyu1BlsFx2/aRjxcnlL3yrLZNQn8tG+P0HFkDTOsd
         GEMoGmARcGMUSZF772n5utr+I3oIvk49/0aUOcmqz3c9ErX7w3yuwOwekQpUwmPRqVGY
         0c8zmgN6s/cJgzOJGMKXO0bbEtVChqBhoVnD/5jQ5DHJgJTLLnnyHqG6m0J/MnLB5KD+
         NggQ==
X-Gm-Message-State: AOAM532Oe4PrEizeq5VUU1OMW4/nRCMZuQaKtGf4Bj0/GhfSIcY84Mmr
        J+brajI+yR0Qyteq4gIl8YpLwR/24dY=
X-Google-Smtp-Source: ABdhPJzLT5UR89aJMp59XYiivG86/2UEWAPwE+X+74lT1yI7aGKnATCAT7OyluqUiTmtGSaHfB07sw==
X-Received: by 2002:a17:902:7c18:b029:117:e575:473e with SMTP id x24-20020a1709027c18b0290117e575473emr28357351pll.37.1626886589063;
        Wed, 21 Jul 2021 09:56:29 -0700 (PDT)
Received: from localhost ([2601:647:5b00:6f70:be34:681b:b1e9:776f])
        by smtp.gmail.com with ESMTPSA id q125sm21522998pga.87.2021.07.21.09.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 09:56:28 -0700 (PDT)
Date:   Wed, 21 Jul 2021 09:56:27 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     Matthias Schiffer <mschiffer@universe-factory.net>
Cc:     Moritz Fischer <mdf@kernel.org>, linux-kernel@vger.kernel.org,
        gabriel.kh.huang@fii-na.com, moritzf@google.com,
        stable@vger.kernel.org, Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vinod Koul <vkoul@kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Revert "usb: renesas-xhci: Fix handling of unknown ROM
 state"
Message-ID: <YPhRu/DWbs58hgvq@epycbox.lan>
References: <20210719070519.41114-1-mdf@kernel.org>
 <c0f191cc-6400-7309-e8a4-eab0925a3d54@universe-factory.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0f191cc-6400-7309-e8a4-eab0925a3d54@universe-factory.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 21, 2021 at 05:28:21PM +0200, Matthias Schiffer wrote:
> On 7/19/21 9:05 AM, Moritz Fischer wrote:
> > This reverts commit d143825baf15f204dac60acdf95e428182aa3374.
> > 
> > Justin reports some of his systems now fail as result of this commit:
> > 
> >   xhci_hcd 0000:04:00.0: Direct firmware load for renesas_usb_fw.mem failed with error -2
> >   xhci_hcd 0000:04:00.0: request_firmware failed: -2
> >   xhci_hcd: probe of 0000:04:00.0 failed with error -2
> > 
> > The revert brings back the original issue the commit tried to solve but
> > at least unbreaks existing systems relying on previous behavior.
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Mathias Nyman <mathias.nyman@intel.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Vinod Koul <vkoul@kernel.org>
> > Cc: Justin Forbes <jmforbes@linuxtx.org>
> > Reported-by: Justin Forbes <jmforbes@linuxtx.org>
> > Signed-off-by: Moritz Fischer <mdf@kernel.org>
> > ---
> > 
> > Justin,
> > 
> > would you be able to help out testing follow up patches to this?
> > 
> > I don't have a machine to test your use-case and mine definitly requires
> > a firmware load on RENESAS_ROM_STATUS_NO_RESULT.
> > 
> > Thanks
> > - Moritz
> 
> 
> Hi Moritz,
> 
> as an additional data point, here's the behaviour of my system, a Thinkpad
> T14 AMD with:

Thanks!
> 
> 06:00.0 USB controller [0c03]: Renesas Technology Corp. uPD720202 USB 3.0
> Host Controller [1912:0015] (rev 02)
> 
> - On Kernel 5.13.1, no firmware: USB controller resets in an endless loop
> when the system is running from battery
> - On Kernel 5.13.4, no firmware: USB controller probe fails with the
> mentioned firmware load error
> - On Kernel 5.13.4, with renesas_usb_fw.mem: everything is working fine, the
> reset issue is gone
> 
> So it seems to me that requiring a firmware is generally the correct driver
> behaviour for this hardware. The firmware I found in the Arch User
> Repository [1] unfortunately has a very restrictive license...

Yeah, the chip definitely needs the firmware. It can either initialize
from external ROM or runtime loaded firmware.

I think the problem really lies in how the current (and reverted) code
detects the need for firmware loading.

The current code looks at two indicators:
- Is there an external ROM and if so, did somebody try to program the
  external ROM and succeed? (renesas_check_rom_state)
- Did somebody try to runtime-load firmware, and if so did they succeed?
  (renesas_fw_check_running, after the early return)

The first one (and resulting early return) does *not* tell you whether
the controller actually has firwmare. That's what breaks my systems.

The second one is only really useful *if* we also check that FW_DOWNLOAD
was locked.

Neither of the above captures the case where you actually have an
external ROM that is programmed with proper firmware and caused the chip
to be loaded with said firmware.

Now before the patch that was reverted, since nobody tried to program
the ROM, it feel through to the "do nothing" in this case -- which
worked since it configured itself from external ROM.

Now how do we properly determine we do or don't need firwmare?

Looking at the datasheet I see two options.
- The version register? I need to investigate what that resets to with
  an unprogrammed/corrupted ROM. If that reliably gives a detectable value
  this could be used as an indicator.
  
- The USBSTS register according to the datasheet will report an error
  through the HCE bit:
  "If both uDP720201 and uDP720202 detect no correct firmware in Serial
  ROM, this flag will be set"

I'll put up an RFC in the next couple of days ...

- Moritz
