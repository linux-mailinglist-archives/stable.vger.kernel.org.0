Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0A73B6BF8
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 03:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhF2BRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 21:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231947AbhF2BR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 21:17:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93A0961941;
        Tue, 29 Jun 2021 01:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624929302;
        bh=n4Cp/kJo8UIbf0RkqsSQqrsS7eaLfDxC1AkSxNzUXC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=knvmbPWv/115WR/zQtzlqwUjidaJkxD4BCR5FqekwRBJyM0RTZOMjuGQhPv2BtH0e
         v7M7aXOdf4VTwKM04T9tm25dzMBOpJ4BIMmJSg4Gfx4zYleYoLOru78EPRGeNheSq9
         UUD4thH46R0RNQxgFzV8t0GLS7GZC4CHTbW0hY4hQJv0fom4HozuCK5W2k1XeTLlhl
         lxpe76kpatNZO2sHaNNpXxU4KFfdlck/UEBMCb9rnsfsXSUp1XaT0Un03xVIrI6rUY
         GzjqFyvbdnyNDHctc1DOF0Qy2LfRfJaUmNv6JUVkgbPi4r0savkNwH1e/8YjsezeBF
         QLbAyvwyH8HRw==
Date:   Tue, 29 Jun 2021 09:14:57 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     "rogerq@kernel.org" <rogerq@kernel.org>,
        "a-govindraju@ti.com" <a-govindraju@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kishon@ti.com" <kishon@ti.com>, Rahul Kumar <kurahul@cadence.com>,
        Sanket Parmar <sparmar@cadence.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: cdns3: Fixed incorrect gadget state
Message-ID: <20210629011457.GA14090@nchen>
References: <20210623070247.46151-1-pawell@gli-login.cadence.com>
 <20210626085655.GA13671@Peter>
 <BYAPR07MB53812E6619228B19C2C3A6DADD039@BYAPR07MB5381.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR07MB53812E6619228B19C2C3A6DADD039@BYAPR07MB5381.namprd07.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-06-28 03:46:38, Pawel Laszczak wrote:
> >
> >On 21-06-23 09:02:47, Pawel Laszczak wrote:
> >> From: Pawel Laszczak <pawell@cadence.com>
> >>
> >> For delayed status phase, the usb_gadget->state was set
> >> to USB_STATE_ADDRESS and it has never been updated to
> >> USB_STATE_CONFIGURED.
> >> Patch updates the gadget state to correct USB_STATE_CONFIGURED.
> >> As a result of this bug the controller was not able to enter to
> >> Test Mode while using MSC function.
> >
> >Pawel, would you please describe more about this issue? I remember the cdns3
> >controller at i.mx series SoC could enter test mode by using current
> >code.
> 
> The issue occurs only for MSC class. MSC class has delayed status stage, so
> after returning from cdns3_req_ep0_set_configuration function called 
> for Set Configuration driver remains in USB_STATE_ADDRESS.
> 
> In order to enter to test mode driver needs meet the condition included in 
> cdns3_ep0_feature_handle_device function:
> 		if (state != USB_STATE_CONFIGURED || speed > USB_SPEED_HIGH)
> 			return -EINVAL;
> 
> But it is still in USB_STATE_ADDRESS, because there was delayed status stage.
> To fix issue driver state must be updated to USB_STATE_CONFIGURED before 
> or after  finishing status stage.
> 

I am wondering if the cdns3 driver set gadget state as USB_STATE_ADDRESS
is correct for delayed status stage, since the composite core has already
set it as USB_STATE_CONFIGURED at function set_config.

Peter
> >
> >>
> >> Cc: <stable@vger.kernel.org>
> >> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >> ---
> >>  drivers/usb/cdns3/cdns3-ep0.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/usb/cdns3/cdns3-ep0.c b/drivers/usb/cdns3/cdns3-ep0.c
> >> index 9a17802275d5..ec5bfd8944c3 100644
> >> --- a/drivers/usb/cdns3/cdns3-ep0.c
> >> +++ b/drivers/usb/cdns3/cdns3-ep0.c
> >> @@ -731,6 +731,7 @@ static int cdns3_gadget_ep0_queue(struct usb_ep *ep,
> >>  		request->actual = 0;
> >>  		priv_dev->status_completion_no_call = true;
> >>  		priv_dev->pending_status_request = request;
> >> +		usb_gadget_set_state(&priv_dev->gadget, USB_STATE_CONFIGURED);
> >>  		spin_unlock_irqrestore(&priv_dev->lock, flags);
> >>
> >>  		/*
> >> --
> >> 2.25.1
> >>
> >
> --
> 
> Thanks,
> Pawel Laszczak
> 

-- 

Thanks,
Peter Chen

