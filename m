Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355094467E5
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 18:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhKERa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 13:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbhKERa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 13:30:27 -0400
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDD0C061714;
        Fri,  5 Nov 2021 10:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=In-Reply-To:Content-Type:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description; bh=+EuADCz3KxLfauAaV/cM2d29LIe6kmYoyUrEWCMg+Zo=; b=J/8UR
        EG6RyEwhcRUBO2MsYIDTBLBsj3HYwQAaTw6dtCciJY5gJyB8rxDYniJZh8TN3yK3LF8mi7WFSzVQF
        JHI63LW6Q1O1aVWtlSEt+VnuPaVvwGhrAUNAkUA4qe9H73ZhiN5qbJoid6XlvV7MhZ3F1dygCD+qZ
        lwwsLGqnU3YlPPrKljNdcHGLKrNyw79Uy1yNiHSbKe6AQ0E8xgMkhR6Xj6Gf08rgX3JBE/GVlmrLy
        M99U+15s8Zgkst9UY0YBD2T3sBj55h/fPneGrAY8PttCLFJSFZhav1NcjMXXrZ6r7t8so82lR1wv5
        Ad+prBXILYLDR0sAg04oPY3avGShg==;
Received: from [81.174.171.191] (helo=donbot)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1mj30A-0006gp-HL; Fri, 05 Nov 2021 17:27:42 +0000
Date:   Fri, 5 Nov 2021 17:27:36 +0000
From:   John Keeping <john@metanate.com>
To:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, John Youn <John.Youn@synopsys.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc2: gadget: Fix ISOC flow for elapsed frames
Message-ID: <YYVpiEpm+kjDRePK@donbot>
References: <c356baade6e9716d312d43df08d53ae557cb8037.1636011277.git.Minas.Harutyunyan@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c356baade6e9716d312d43df08d53ae557cb8037.1636011277.git.Minas.Harutyunyan@synopsys.com>
X-Authenticated: YES
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 11:36:01AM +0400, Minas Harutyunyan wrote:
> Added updating of request frame number for elapsed frames,
> otherwise frame number will remain as previous use of request.
> This will allow function driver to correctly track frames in
> case of Missed ISOC occurs.
> 
> Added setting request actual length to 0 for elapsed frames.
> In Slave mode when pushing data to RxFIFO by dwords, request
> actual length incrementing accordingly. But before whole packet
> will be pushed into RxFIFO and send to host can occurs Missed
> ISOC and data will not send to host. So, in this case request
> actual length should be reset to 0.
> 
> Fixes: 91bb163e1e4f ("usb: dwc2: gadget: Fix ISOC flow for BDMA and Slave")
> Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

Reviewed-by: John Keeping <john@metanate.com>

> ---
>  drivers/usb/dwc2/gadget.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index 11d85a6e0b0d..2190225bf3da 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -1198,6 +1198,8 @@ static void dwc2_hsotg_start_req(struct dwc2_hsotg *hsotg,
>  			}
>  			ctrl |= DXEPCTL_CNAK;
>  		} else {
> +			hs_req->req.frame_number = hs_ep->target_frame;
> +			hs_req->req.actual = 0;
>  			dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, -ENODATA);
>  			return;
>  		}
> @@ -2857,9 +2859,12 @@ static void dwc2_gadget_handle_ep_disabled(struct dwc2_hsotg_ep *hs_ep)
>  
>  	do {
>  		hs_req = get_ep_head(hs_ep);
> -		if (hs_req)
> +		if (hs_req) {
> +			hs_req->req.frame_number = hs_ep->target_frame;
> +			hs_req->req.actual = 0;
>  			dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req,
>  						    -ENODATA);
> +		}
>  		dwc2_gadget_incr_frame_num(hs_ep);
>  		/* Update current frame number value. */
>  		hsotg->frame_number = dwc2_hsotg_read_frameno(hsotg);
> @@ -2912,8 +2917,11 @@ static void dwc2_gadget_handle_out_token_ep_disabled(struct dwc2_hsotg_ep *ep)
>  
>  	while (dwc2_gadget_target_frame_elapsed(ep)) {
>  		hs_req = get_ep_head(ep);
> -		if (hs_req)
> +		if (hs_req) {
> +			hs_req->req.frame_number = ep->target_frame;
> +			hs_req->req.actual = 0;
>  			dwc2_hsotg_complete_request(hsotg, ep, hs_req, -ENODATA);
> +		}
>  
>  		dwc2_gadget_incr_frame_num(ep);
>  		/* Update current frame number value. */
> @@ -3002,8 +3010,11 @@ static void dwc2_gadget_handle_nak(struct dwc2_hsotg_ep *hs_ep)
>  
>  	while (dwc2_gadget_target_frame_elapsed(hs_ep)) {
>  		hs_req = get_ep_head(hs_ep);
> -		if (hs_req)
> +		if (hs_req) {
> +			hs_req->req.frame_number = hs_ep->target_frame;
> +			hs_req->req.actual = 0;
>  			dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, -ENODATA);
> +		}
>  
>  		dwc2_gadget_incr_frame_num(hs_ep);
>  		/* Update current frame number value. */
> 
> base-commit: c26f1c109d21f2ea874e4a85c0c76c385b8f46cb
> -- 
> 2.11.0
> 
