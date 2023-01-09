Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E676622B8
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 11:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbjAIKOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 05:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbjAIKOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 05:14:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB31B1C1;
        Mon,  9 Jan 2023 02:13:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF4560FC1;
        Mon,  9 Jan 2023 10:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1258FC433D2;
        Mon,  9 Jan 2023 10:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673259212;
        bh=pvqVDoJZCa0ZOaavtmQbruLzVu9U05hJ2hV/NAI13Qw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lEs48J/cW6Rt4gv7+9VTuxBSiG1DFLqbRoDIUst0m6CC9WqhK7cFM5Yx2i7OqY5Rf
         eb2ng1ub9H/Amdrilz0pjEpvcXPZZm7d0E8StYkffl3jV/wT1TpfHnTDrNLQDMDgmR
         Il2uPg0Um5RR4Kay4uNRCkcf8oqU1slVdUVYqlOHQ5YgaBpGXfvK8+oWYu+Wewe4Rk
         RQar24Dwi4vbIEbCegrbbFRfKD81IBWnZxEB+7cO6aFxPoChIDja2lYLRunRddny32
         cih+IYSpI8r8mF5wJm05NihUbNai0QFUlFyJ54/BjvMn5h741QyIZnMXU2atGZBM6B
         YZxY86c8R61tw==
Date:   Mon, 9 Jan 2023 18:13:21 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     Peter Chen <hzpeterchen@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>,
        "rogerq@kernel.org" <rogerq@kernel.org>,
        "a-govindraju@ti.com" <a-govindraju@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: cdns3: remove fetched trb from cache before
 dequeuing
Message-ID: <20230109101321.GA94204@nchen-desktop>
References: <20221115100039.441295-1-pawell@cadence.com>
 <CAL411-o4BETLPd-V_4yR6foXbES=72-P4tq-fQ_W_p0P_3ZqEw@mail.gmail.com>
 <BYAPR07MB5381AE961B59046ECB615C65DD069@BYAPR07MB5381.namprd07.prod.outlook.com>
 <CAL411-rFz5Dde4F_uWbksxJG2uqbD7VsU2GG1JQ0mU3LpbeoUA@mail.gmail.com>
 <BYAPR07MB5381157D62415BFFBD328C5ADDFE9@BYAPR07MB5381.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BYAPR07MB5381157D62415BFFBD328C5ADDFE9@BYAPR07MB5381.namprd07.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23-01-09 05:38:31, Pawel Laszczak wrote:
> >
> >On Thu, Nov 17, 2022 at 8:27 PM Pawel Laszczak <pawell@cadence.com>
> >wrote:
> >>
> >> >
> >> >On Tue, Nov 15, 2022 at 6:01 PM Pawel Laszczak <pawell@cadence.com>
> >> >wrote:
> >> >>
> >> >> After doorbell DMA fetches the TRB. If during dequeuing request
> >> >> driver changes NORMAL TRB to LINK TRB but doesn't delete it from
> >> >> controller cache then controller will handle cached TRB and packet can be
> >lost.
> >> >>
> >> >> The example scenario for this issue looks like:
> >> >> 1. queue request - set doorbell
> >> >> 2. dequeue request
> >> >> 3. send OUT data packet from host
> >> >> 4. Device will accept this packet which is unexpected 5. queue new
> >> >> request - set doorbell 6. Device lost the expected packet.
> >> >>
> >> >> By setting DFLUSH controller clears DRDY bit and stop DMA transfer.
> >> >>
> >> >> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> >> >> cc: <stable@vger.kernel.org>
> >> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >> >> ---
> >> >>  drivers/usb/cdns3/cdns3-gadget.c | 12 ++++++++++++
> >> >>  1 file changed, 12 insertions(+)
> >> >>
> >> >> diff --git a/drivers/usb/cdns3/cdns3-gadget.c
> >> >> b/drivers/usb/cdns3/cdns3-gadget.c
> >> >> index 5adcb349718c..ccfaebca6faa 100644
> >> >> --- a/drivers/usb/cdns3/cdns3-gadget.c
> >> >> +++ b/drivers/usb/cdns3/cdns3-gadget.c
> >> >> @@ -2614,6 +2614,7 @@ int cdns3_gadget_ep_dequeue(struct usb_ep
> >*ep,
> >> >>         u8 req_on_hw_ring = 0;
> >> >>         unsigned long flags;
> >> >>         int ret = 0;
> >> >> +       int val;
> >> >>
> >> >>         if (!ep || !request || !ep->desc)
> >> >>                 return -EINVAL;
> >> >> @@ -2649,6 +2650,13 @@ int cdns3_gadget_ep_dequeue(struct usb_ep
> >> >*ep,
> >> >>
> >> >>         /* Update ring only if removed request is on pending_req_list list */
> >> >>         if (req_on_hw_ring && link_trb) {
> >> >> +               /* Stop DMA */
> >> >> +               writel(EP_CMD_DFLUSH, &priv_dev->regs->ep_cmd);
> >> >> +
> >> >> +               /* wait for DFLUSH cleared */
> >> >> +               readl_poll_timeout_atomic(&priv_dev->regs->ep_cmd, val,
> >> >> +                                         !(val & EP_CMD_DFLUSH),
> >> >> + 1, 1000);
> >> >> +
> >> >>                 link_trb->buffer = cpu_to_le32(TRB_BUFFER(priv_ep-
> >> >>trb_pool_dma +
> >> >>                         ((priv_req->end_trb + 1) * TRB_SIZE)));
> >> >>                 link_trb->control =
> >> >> cpu_to_le32((le32_to_cpu(link_trb->control) & TRB_CYCLE) | @@
> >> >>-2660,6
> >> >> +2668,10 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
> >> >>
> >> >>         cdns3_gadget_giveback(priv_ep, priv_req, -ECONNRESET);
> >> >>
> >> >> +       req = cdns3_next_request(&priv_ep->pending_req_list);
> >> >> +       if (req)
> >> >> +               cdns3_rearm_transfer(priv_ep, 1);
> >> >> +
> >> >
> >> >Why the above changes are needed?
> >> >
> >>
> >> Do you mean the last line or this patch?
> >>
> >> Last line:
> >> DMA is stopped, so driver arm the queued transfers
> >>
> >
> >Sorry, I have been very busy recently, so the response may not be in time.
> >I mean why it needs to re-arm the transfers after DMA is stopped?
> 
> Because driver can have queued more transfers. Only one of them are
> dequeued. In the vast majority of the rest request will be removed in the
> next steps, but there can be case in which we have queued e.g. 10 usb requests
> and only one of them will be removed. In such case the driver can stuck.
> To avoid this driver, rearm the endpoint if there are other transfer
> in transfer ring.
> 

Since this logic (re-arm the pending request) is different with current
one, please test it well to avoid other use cases. After you have fully
tested, feel free to add my ack:

Acked-by: Peter Chen <peter.chen@kernel.org>

Peter

> Regards,
> Pawel
> 
> >
> >
> >> If you means this patch:
> >> Issue was detected by customer test. I don’t know whether it was only
> >> test or the real application.
> >>
> >> The problem happens because user application queued the transfer
> >> (endpoint has been armed), so controller fetch the TRB.
> >> When user application removed this request the TRB was still processed
> >> by controller. If at that time the host will send data packet then
> >> controller will accept it, but it shouldn't because the usb_request
> >> associated with TRB cached by controller was removed.
> >> To force the controller to drop this TRB DFLUSH is required.
> >>
> >> Pawel
> >>
> >> >
> >> >>  not_found:
> >> >>         spin_unlock_irqrestore(&priv_dev->lock, flags);
> >> >>         return ret;
> >> >> --
> >> >> 2.25.1
> >> >>

-- 

Thanks,
Peter Chen
