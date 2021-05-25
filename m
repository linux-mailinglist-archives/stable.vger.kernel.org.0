Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EE138F71C
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 02:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhEYAzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 20:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhEYAzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 20:55:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 414F9613BF;
        Tue, 25 May 2021 00:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621904033;
        bh=gUNijcWcodGiSJ1D43tXty52czXiZxISSUlDZEOA4vA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uBU4xei5O1Q7UwrUGVnlMXrzppbBU8Nkvb+isRpf0NEjPBIyUXfs3aiKBliWtvp2o
         8TcvUWDor11JeF+5OPxhnUQy1KbQ14R9xo4ruKHWmENkYDUlvDdCN4UDI0D2Fh8U8Y
         4Q/hKaivUgIlRFRRNE+3/HZpVhXYFY/aaWRoRLREYPE8gFL1dPfSs0IanwyvTjMYGD
         XcONTSgtRWHey2iW5NCDZqDRh5g2qGOIqsGADAl+SJqpbcTvyfowSD1vsDPVRcrQWX
         Wr3FpiqF2BZBOI+bW5rXJbkNphAZKokAVVAAyDNdO75qNnbNqG0vqgCIffzoWZvG37
         0KxRGg5mXKudw==
Date:   Tue, 25 May 2021 08:53:49 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Rahul Kumar <kurahul@cadence.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: cdnsp: Fix deadlock issue in
 cdnsp_thread_irq_handler
Message-ID: <20210525005349.GA20923@nchen>
References: <20210520094224.14099-1-pawell@gli-login.cadence.com>
 <20210522095432.GA12415@b29397-desktop>
 <BYAPR07MB5381074F9A2A8AD6CAF4C10BDD269@BYAPR07MB5381.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR07MB5381074F9A2A8AD6CAF4C10BDD269@BYAPR07MB5381.namprd07.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-05-24 10:56:23, Pawel Laszczak wrote:
> >
> >
> >On 21-05-20 11:42:24, Pawel Laszczak wrote:
> >> From: Pawel Laszczak <pawell@cadence.com>
> >>
> >> Patch fixes the critical issue caused by deadlock which has been detected
> >> during testing NCM class.
> >>
> >> The root cause of issue is spin_lock/spin_unlock instruction instead
> >> spin_lock_irqsave/spin_lock_irqrestore in cdnsp_thread_irq_handler
> >> function.
> >
> >Pawel, would you please explain more about why the deadlock occurs with
> >current code, and why this patch could fix it?
> >
> 
> I'm going to add such description to commit message:
> 
> Lack of spin_lock_irqsave causes that during handling threaded
> interrupt inside spin_lock/spin_unlock section the ethernet
> subsystem invokes eth_start_xmit function from interrupt context
> which in turn starts queueing free requests in cdnsp driver. 
> Consequently, the deadlock occurs inside cdnsp_gadget_ep_queue
> on spin_lock_irqsave instruction. Replacing spin_lock/spin_unlock
> with spin_lock_irqsave/spin_lock_irqrestor causes disableing

%s/disableing/disabling

> interrupts and blocks queuing requests by ethernet subsystem until
> cdnsp_thread_irq_handler ends..
> 
> I hope this description is sufficient. 

A call stack graph may be better, like [1]

[1]: https://www.spinics.net/lists/linux-usb/msg211931.html

Peter

> 
> Thanks,
> Pawel
> 
> >>
> >> Cc: stable@vger.kernel.org
> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >> ---
> >>  drivers/usb/cdns3/cdnsp-ring.c | 7 ++++---
> >>  1 file changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> >> index 5f0513c96c04..68972746e363 100644
> >> --- a/drivers/usb/cdns3/cdnsp-ring.c
> >> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> >> @@ -1517,13 +1517,14 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void *data)
> >>  {
> >>  	struct cdnsp_device *pdev = (struct cdnsp_device *)data;
> >>  	union cdnsp_trb *event_ring_deq;
> >> +	unsigned long flags;
> >>  	int counter = 0;
> >>
> >> -	spin_lock(&pdev->lock);
> >> +	spin_lock_irqsave(&pdev->lock, flags);
> >>
> >>  	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
> >>  		cdnsp_died(pdev);
> >> -		spin_unlock(&pdev->lock);
> >> +		spin_unlock_irqrestore(&pdev->lock, flags);
> >>  		return IRQ_HANDLED;
> >>  	}
> >>
> >> @@ -1539,7 +1540,7 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void *data)
> >>
> >>  	cdnsp_update_erst_dequeue(pdev, event_ring_deq, 1);
> >>
> >> -	spin_unlock(&pdev->lock);
> >> +	spin_unlock_irqrestore(&pdev->lock, flags);
> >>
> >>  	return IRQ_HANDLED;
> >>  }
> >> --
> >> 2.25.1
> >>
> >
> >--
> >
> >Thanks,
> >Peter Chen
> 

-- 

Thanks,
Peter Chen

