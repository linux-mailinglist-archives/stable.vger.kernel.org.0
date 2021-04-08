Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD02358137
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 13:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhDHLAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 07:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhDHLAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Apr 2021 07:00:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A950F608FE;
        Thu,  8 Apr 2021 11:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617879636;
        bh=Dkg7QdY5kyGAiD7cdHvYb+UjEUHo0BETWXZ37AlnuZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qXCAmq6HFhTrVPziAFYql6iYKhIBxFjkDXU+wRWjck2vSD1W9QJ8UKTvJsqEV0I7e
         Fqd6KxdvFt9QIjZRwuyGBJheEHfGo09jfgCERdzrCRjIyo6wdJWqz+Lcj99rT61/6K
         Mdo6MEDzYAhIVQl7wOR5yAhXNZvfTpyYo79ptbd8=
Date:   Thu, 8 Apr 2021 13:00:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
        Gregory Herrero <gregory.herrero@intel.com>,
        Douglas Anderson <dianders@chromium.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v2 00/14] usb: dwc2: Fix Partial Power down issues.
Message-ID: <YG7iUey+Rtof+3Up@kroah.com>
References: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
 <20210408072825.61347A022E@mailhost.synopsys.com>
 <3625b740-b362-5ec6-8fba-cd7babcab35b@synopsys.com>
 <af45ed18-2ce4-43da-f28c-d5cda0710b9f@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af45ed18-2ce4-43da-f28c-d5cda0710b9f@synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 08, 2021 at 10:09:20AM +0000, Artur Petrosyan wrote:
> Hi Greg,
> 
> On 4/8/2021 13:17, Artur Petrosyan wrote:
> > Hi Greg,
> > 
> > On 4/8/2021 11:28, Artur Petrosyan wrote:
> >> This patch set fixes and improves the Partial Power Down mode for
> >> dwc2 core.
> >> It adds support for the following cases
> >>       1. Entering and exiting partial power down when a port is
> >>          suspended, resumed, port reset is asserted.
> >>       2. Exiting the partial power down mode before removing driver.
> >>       3. Exiting partial power down in wakeup detected interrupt handler.
> >>       4. Exiting from partial power down mode when connector ID.
> >>          status changes to "connId B
> >>
> >> It updates and fixes the implementation of dwc2 entering and
> >> exiting partial power down mode when the system (PC) is suspended.
> >>
> >> The patch set also improves the implementation of function handlers
> >> for entering and exiting host or device partial power down.
> >>
> >> NOTE: This is the second patch set in the power saving mode fixes
> >> series.
> >> This patch set is part of multiple series and is continuation
> >> of the "usb: dwc2: Fix and improve power saving modes" patch set.
> >> (Patch set link: https://urldefense.com/v3/__https://marc.info/?l=linux-usb&m=160379622403975&w=2__;!!A4F2R9G_pg!IJ-Xl1ZwQU2kmqHB3ITyWyno9BgpWUsC647AqK7GIlgzJu9BzT6VN7jt--__fGdMtgWF69M$ ).
> >> The patches that were included in the "usb: dwc2:
> >> Fix and improve power saving modes" which was submitted
> >> earlier was too large and needed to be split up into
> >> smaller patch sets.
> >>
> >> Changes since V1:
> >> No changes in the patches or the source code.
> >> Sending the second version of the patch set because the first version
> >> was not received by vger.kernel.org.
> >>
> >>
> >>
> >> Artur Petrosyan (14):
> >>     usb: dwc2: Add device partial power down functions
> >>     usb: dwc2: Add host partial power down functions
> >>     usb: dwc2: Update enter and exit partial power down functions
> >>     usb: dwc2: Add partial power down exit flow in wakeup intr.
> >>     usb: dwc2: Update port suspend/resume function definitions.
> >>     usb: dwc2: Add enter partial power down when port is suspended
> >>     usb: dwc2: Add exit partial power down when port is resumed
> >>     usb: dwc2: Add exit partial power down when port reset is asserted
> >>     usb: dwc2: Add part. power down exit from
> >>       dwc2_conn_id_status_change().
> >>     usb: dwc2: Allow exit partial power down in urb enqueue
> >>     usb: dwc2: Fix session request interrupt handler
> >>     usb: dwc2: Update partial power down entering by system suspend
> >>     usb: dwc2: Fix partial power down exiting by system resume
> >>     usb: dwc2: Add exit partial power down before removing driver
> >>
> >>    drivers/usb/dwc2/core.c      | 113 ++-------
> >>    drivers/usb/dwc2/core.h      |  27 ++-
> >>    drivers/usb/dwc2/core_intr.c |  46 ++--
> >>    drivers/usb/dwc2/gadget.c    | 148 ++++++++++-
> >>    drivers/usb/dwc2/hcd.c       | 458 +++++++++++++++++++++++++----------
> >>    drivers/usb/dwc2/hw.h        |   1 +
> >>    drivers/usb/dwc2/platform.c  |  11 +-
> >>    7 files changed, 558 insertions(+), 246 deletions(-)
> >>
> >>
> >> base-commit: e9fcb07704fcef6fa6d0333fd2b3a62442eaf45b
> >>
> > 
> > Re sending as a "v2" did not work :(.
> > The patches are not in lore again.
> > 
> > Could the issue be with a comma in the end of To: or Cc: list?
> > Let me remove the comma in the end of those lists and try sending as "v3".
> > 
> > Regards,
> > Artur
> > 
> 
> I just removed the comma in the end of those lists and resent the patch 
> set as a "v3" and they are already seen in lore.
> There is one strange thing though on lore. Some patch titles are not 
> fully visible.
> 
> For sure the issue was comma in the end of To: or Cc: lists.
> Not working example.
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
> linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,

That's an invalid To: line for email.

> Working example.
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
> linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

That's a correct line.

> If the comma is at least in the end of one of those lists (To: or Cc:) 
> vger.kernel.org mailing server will not accept them.

I recommend using 'git send-email' with the --to="foo@bar.com" type
options so that you don't have to hand-edit the lines to try to get
stuff like this correct, as it is easy to get wrong.

thanks,

greg k-h
