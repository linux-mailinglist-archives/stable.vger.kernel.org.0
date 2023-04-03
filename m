Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B4E6D3E08
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 09:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbjDCHYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 03:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjDCHYh (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 3 Apr 2023 03:24:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105D3E077;
        Mon,  3 Apr 2023 00:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC4C3B811E1;
        Mon,  3 Apr 2023 07:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E01C433D2;
        Mon,  3 Apr 2023 07:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680506667;
        bh=t0itBp6GomQRcFMMaHlVcRlBZ2aQK/rO4c3RtCY9/8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EDA4cnr7QU56DRX0fnowHkmcyCXNo4SKQf12KrtnuXcNhryfbNsQ/QRQQXqJJNYSo
         9uDIHlwbwiKK24+8p0pDW90ozDN8yGR2VRR6UJ9uJ/dU9Q1EAmxKTcStYwWs1vu00x
         JmT4ac6+8x+oCuEQ/xT1/ghSD4XfmDSfYPR6kQQ0=
Date:   Mon, 3 Apr 2023 09:24:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-usb@vger.kernel.org, Stable@vger.kernel.org
Subject: Re: [PATCH 3/3] xhci: Free the command allocated for setting LPM if
 we return early
Message-ID: <2023040352-case-barterer-ccd1@gregkh>
References: <20230330143056.1390020-1-mathias.nyman@linux.intel.com>
 <20230330143056.1390020-4-mathias.nyman@linux.intel.com>
 <2219a894-eb79-70a4-2b92-2b7ee7e1e966@alu.unizg.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2219a894-eb79-70a4-2b92-2b7ee7e1e966@alu.unizg.hr>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 03, 2023 at 09:17:21AM +0200, Mirsad Goran Todorovac wrote:
> Hi, Mathias!
> 
> On 30.3.2023. 16:30, Mathias Nyman wrote:
> > The command allocated to set exit latency LPM values need to be freed in
> > case the command is never queued. This would be the case if there is no
> > change in exit latency values, or device is missing.
> > 
> > Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> > Link: https://lore.kernel.org/linux-usb/24263902-c9b3-ce29-237b-1c3d6918f4fe@alu.unizg.hr
> > Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> > Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
> > Cc: <Stable@vger.kernel.org>
> > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > ---
> >   drivers/usb/host/xhci.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> > index bdb6dd819a3b..6307bae9cddf 100644
> > --- a/drivers/usb/host/xhci.c
> > +++ b/drivers/usb/host/xhci.c
> > @@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
> >   	if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
> >   		spin_unlock_irqrestore(&xhci->lock, flags);
> > +		xhci_free_command(xhci, command);
> >   		return 0;
> >   	}
> 
> There seems to be a problem with applying this patch with "git am", as it
> gives the following:
> 
> commit ff9de97baa02cb9362b7cb81e95bc9be424cab89
> Author: @ <@>
> Date:   Mon Apr 3 08:42:33 2023 +0200
> 
>     The command allocated to set exit latency LPM values need to be freed in
>     case the command is never queued. This would be the case if there is no
>     change in exit latency values, or device is missing.
> 
>     Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
>     Cc: <Stable@vger.kernel.org>
>     Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

This is already commit f6caea485555 ("xhci: Free the command allocated
for setting LPM if we return early") in Linus's tree, do you not see it
there?

And how exactly did you save the message to apply it with 'git am'?  It
worked for me.

thanks,

greg k-h
