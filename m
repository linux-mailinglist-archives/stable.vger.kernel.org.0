Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB5B2EBAC5
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 08:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbhAFHv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 02:51:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbhAFHvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 02:51:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C7562070C;
        Wed,  6 Jan 2021 07:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609919474;
        bh=mhj1Qo3d0xN+72WQ8KKjT+MhYlUWaRLY8TYHPwrJCkM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=MKbsZH8pAscitaLRkIfnB1L+bvsqnevgywpg+EDXm/yF/BvmD76Sze6NEuvZeAO5f
         lhkbEPJhUw+lKlguNfOm44S59oSXd6gnJOFEzVDJVAR6mlykvyS7axBPkESUEoFbcx
         L/uEF9KBtJz5s/pEHnj0mGMBizPJlPq+cYxNIJav7vaUKsJBskByxsZYgDWUXFtoTe
         lW7G0e4rtUpqfDxRmbl+KmehfW1wm1FvMRAUeXWDXqb/r/czyXKryV4230ym51sWj9
         q2ImZJJMmqfY/1MUvj0kz86rFBU2+OyIwX4kCltUmlOfNEaJ/m+mxqUGhX4Rbv5ohh
         Q9BuuIxqtIMJQ==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: Init only available HW eps
In-Reply-To: <3080c0452df14d510d24471ce0f9bb7592cdfd4d.1609866964.git.Thinh.Nguyen@synopsys.com>
References: <3080c0452df14d510d24471ce0f9bb7592cdfd4d.1609866964.git.Thinh.Nguyen@synopsys.com>
Date:   Wed, 06 Jan 2021 09:51:10 +0200
Message-ID: <87eeiycxld.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
> Typically FPGA devices are configured with CoreConsultant parameter
> DWC_USB3x_EN_LOG_PHYS_EP_SUPT=0 to reduce gate count and improve timing.
> This means that the number of INs equals to OUTs endpoints. But
> typically non-FPGA devices enable this CoreConsultant parameter to
> support flexible endpoint mapping and potentially may have unequal
> number of INs to OUTs physical endpoints.
>
> The driver must check how many physical endpoints are available for each
> direction and initialize them properly.
>
> Cc: stable@vger.kernel.org
> Fixes: 47d3946ea220 ("usb: dwc3: refactor gadget endpoint count calculation")
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/usb/dwc3/core.c   |  1 +
>  drivers/usb/dwc3/core.h   |  2 ++
>  drivers/usb/dwc3/gadget.c | 19 ++++++++++++-------
>  3 files changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 841daec70b6e..1084aa8623c2 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -529,6 +529,7 @@ static void dwc3_core_num_eps(struct dwc3 *dwc)
>  	struct dwc3_hwparams	*parms = &dwc->hwparams;
>  
>  	dwc->num_eps = DWC3_NUM_EPS(parms);
> +	dwc->num_in_eps = DWC3_NUM_IN_EPS(parms);
>  }
>  
>  static void dwc3_cache_hwparams(struct dwc3 *dwc)
> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> index 1b241f937d8f..1295dac019f9 100644
> --- a/drivers/usb/dwc3/core.h
> +++ b/drivers/usb/dwc3/core.h
> @@ -990,6 +990,7 @@ struct dwc3_scratchpad_array {
>   * @u1sel: parameter from Set SEL request.
>   * @u1pel: parameter from Set SEL request.
>   * @num_eps: number of endpoints
> + * @num_in_eps: number of IN endpoints
>   * @ep0_next_event: hold the next expected event
>   * @ep0state: state of endpoint zero
>   * @link_state: link state
> @@ -1193,6 +1194,7 @@ struct dwc3 {
>  	u8			speed;
>  
>  	u8			num_eps;
> +	u8			num_in_eps;
>  
>  	struct dwc3_hwparams	hwparams;
>  	struct dentry		*root;
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 25f654b79e48..8a38ee10c00b 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2025,7 +2025,7 @@ static void dwc3_stop_active_transfers(struct dwc3 *dwc)
>  {
>  	u32 epnum;
>  
> -	for (epnum = 2; epnum < dwc->num_eps; epnum++) {
> +	for (epnum = 2; epnum < DWC3_ENDPOINTS_NUM; epnum++) {
>  		struct dwc3_ep *dep;
>  
>  		dep = dwc->eps[epnum];
> @@ -2628,16 +2628,21 @@ static int dwc3_gadget_init_endpoint(struct dwc3 *dwc, u8 epnum)
>  	return 0;
>  }
>  
> -static int dwc3_gadget_init_endpoints(struct dwc3 *dwc, u8 total)
> +static int dwc3_gadget_init_endpoints(struct dwc3 *dwc)
>  {
> -	u8				epnum;
> +	u8				i;
> +	int				ret;
>  
>  	INIT_LIST_HEAD(&dwc->gadget->ep_list);
>  
> -	for (epnum = 0; epnum < total; epnum++) {
> -		int			ret;
> +	for (i = 0; i < dwc->num_in_eps; i++) {
> +		ret = dwc3_gadget_init_endpoint(dwc, i * 2 + 1);
> +		if (ret)
> +			return ret;
> +	}
>  
> -		ret = dwc3_gadget_init_endpoint(dwc, epnum);
> +	for (i = 0; i < dwc->num_eps - dwc->num_in_eps; i++) {
> +		ret = dwc3_gadget_init_endpoint(dwc, i * 2);
>  		if (ret)
>  			return ret;
>  	}
> @@ -3863,7 +3868,7 @@ int dwc3_gadget_init(struct dwc3 *dwc)
>  	 * sure we're starting from a well known location.
>  	 */
>  
> -	ret = dwc3_gadget_init_endpoints(dwc, dwc->num_eps);
> +	ret = dwc3_gadget_init_endpoints(dwc);
>  	if (ret)
>  		goto err4;

heh, looking at original commit, we used to have num_in_eps and
num_out_eps. In fact, this commit will reintroduce another problem that
Bryan tried to solve. num_eps - num_in_eps is not necessarily
num_out_eps.

How have you verified this patch? Did you read Bryan's commit log? This
is likely to reintroduce the problem raised by Bryan.

-- 
balbi
