Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2A2357C30
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 08:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhDHGNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 02:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhDHGNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Apr 2021 02:13:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E337610A2;
        Thu,  8 Apr 2021 06:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617862400;
        bh=idCIivqrohs+8XI7ShOK104EL8SmXh5vn2poLxMFrcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q8H36JkMAoIsA3GGZmzDcC8UV8kiitjCODQfDEhCJCVRCYaLH2zaV9NgHAY6zJqVS
         rM+Wo7wDVIdVuXHEUPLSdyfjimfu+m3fyK1+vlQUO28BWF8eGWIwp2vog5eXQwiA1z
         9yBuP/SnuAthHLUGcWW218KIyjEU9CulxHq9l4GY=
Date:   Thu, 8 Apr 2021 08:09:24 +0200
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
Subject: Re: [PATCH 00/14] usb: dwc2: Fix Partial Power down issues.
Message-ID: <YG6eFEv8JfE3qSdV@kroah.com>
References: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
 <60f356b2-e465-48e7-ad37-f1021e3581ff@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60f356b2-e465-48e7-ad37-f1021e3581ff@synopsys.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 08, 2021 at 05:57:57AM +0000, Artur Petrosyan wrote:
> Hi Greg,
> 
> On 4/7/2021 14:00, Artur Petrosyan wrote:
> > This patch set fixes and improves the Partial Power Down mode for
> > dwc2 core.
> > It adds support for the following cases
> >      1. Entering and exiting partial power down when a port is
> >         suspended, resumed, port reset is asserted.
> >      2. Exiting the partial power down mode before removing driver.
> >      3. Exiting partial power down in wakeup detected interrupt handler.
> >      4. Exiting from partial power down mode when connector ID.
> >         status changes to "connId B
> > 
> > It updates and fixes the implementation of dwc2 entering and
> > exiting partial power down mode when the system (PC) is suspended.
> > 
> > The patch set also improves the implementation of function handlers
> > for entering and exiting host or device partial power down.
> > 
> > NOTE: This is the second patch set in the power saving mode fixes
> > series.
> > This patch set is part of multiple series and is continuation
> > of the "usb: dwc2: Fix and improve power saving modes" patch set.
> > (Patch set link: https://marc.info/?l=linux-usb&m=160379622403975&w=2).
> > The patches that were included in the "usb: dwc2:
> > Fix and improve power saving modes" which was submitted
> > earlier was too large and needed to be split up into
> > smaller patch sets.
> > 
> > 
> > Artur Petrosyan (14):
> >    usb: dwc2: Add device partial power down functions
> >    usb: dwc2: Add host partial power down functions
> >    usb: dwc2: Update enter and exit partial power down functions
> >    usb: dwc2: Add partial power down exit flow in wakeup intr.
> >    usb: dwc2: Update port suspend/resume function definitions.
> >    usb: dwc2: Add enter partial power down when port is suspended
> >    usb: dwc2: Add exit partial power down when port is resumed
> >    usb: dwc2: Add exit partial power down when port reset is asserted
> >    usb: dwc2: Add part. power down exit from
> >      dwc2_conn_id_status_change().
> >    usb: dwc2: Allow exit partial power down in urb enqueue
> >    usb: dwc2: Fix session request interrupt handler
> >    usb: dwc2: Update partial power down entering by system suspend
> >    usb: dwc2: Fix partial power down exiting by system resume
> >    usb: dwc2: Add exit partial power down before removing driver
> > 
> >   drivers/usb/dwc2/core.c      | 113 ++-------
> >   drivers/usb/dwc2/core.h      |  27 ++-
> >   drivers/usb/dwc2/core_intr.c |  46 ++--
> >   drivers/usb/dwc2/gadget.c    | 148 ++++++++++-
> >   drivers/usb/dwc2/hcd.c       | 458 +++++++++++++++++++++++++----------
> >   drivers/usb/dwc2/hw.h        |   1 +
> >   drivers/usb/dwc2/platform.c  |  11 +-
> >   7 files changed, 558 insertions(+), 246 deletions(-)
> > 
> > 
> > base-commit: e9fcb07704fcef6fa6d0333fd2b3a62442eaf45b
> > 
> I have submitted this patch set yesterday. It contains 14 patches. But 
> only 2 of those patches were received by LKML only the cover letter and 
> the 13th patch. 
> (https://lore.kernel.org/linux-usb/cover.1617782102.git.Arthur.Petrosyan@synopsys.com/T/#t)
> 
> I checked here at Synopsys, Minas did receive all the patches as his 
> email is in To list. Could this be an issue of vger.kernel.org mailing 
> server?
> 
> Because I checked every local possibility that could result to such 
> behavior. The patch 13 which was received by LKML has the similar 
> content as the other patches.
> 
> The mailing tool that was used is ssmtp, checked all the configurations 
> everything is fine.
> 
> Could you please suggest what should I do in this situation?

Odd, I got them here, but lore seems to not have them :(

Can you just resend them as a "v2" series so we know which to review and
let's see if that works better...

thanks,

greg k-h
