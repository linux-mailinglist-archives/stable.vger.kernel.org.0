Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFA22EAB53
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 14:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbhAEM7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 07:59:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbhAEM7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 07:59:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6DE720735;
        Tue,  5 Jan 2021 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609851536;
        bh=+S1/asbQWfBvNMsP0z/RcaAM+16JOOlMmv1drViAqO0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PxAIdKH6kEjKb7oMRaveo5Qj5l8wPlvmtOIb5rpfAmRZf2ztw0ymoiiwQ9vHmaU+K
         zOS+kFkWANhHLe79LKRMDbPIDUg5ravfNNPUkPzYXxTIn/QnOIhPreuOhqAzSOloDN
         uS1gSVX+eBLY5KVoooffqc4LMMbC7/28gBfHy0Yp6lTW0+kW9Wf7wwF1Y40ooG3Ayt
         wTsNy/k6MG6xsQDLKhadzvuKLxyQKHluFJiubP4pRz10iq3iXrdTPviYQ6MYFuRE/C
         f/Sj1sg1r0JSNmt1AsfTu5MLVpIBFMO+abX/JiDBr5x0qbZ4Sbwxu0/WwYCfj9unix
         sSr50yEABI5fQ==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: dwc3: gadget: Clear wait flag on dequeue
In-Reply-To: <b81cd5b5281cfbfdadb002c4bcf5c9be7c017cfd.1609828485.git.Thinh.Nguyen@synopsys.com>
References: <b81cd5b5281cfbfdadb002c4bcf5c9be7c017cfd.1609828485.git.Thinh.Nguyen@synopsys.com>
Date:   Tue, 05 Jan 2021 14:58:51 +0200
Message-ID: <87turvczg4.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
> If an active transfer is dequeued, then the endpoint is freed to start a
> new transfer. Make sure to clear the endpoint's transfer wait flag for
> this case.
>
> Cc: stable@vger.kernel.org
> Fixes: e0d19563eb6c ("usb: dwc3: gadget: Wait for transfer completion")
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  Changes in v2:
>  - Only clear the wait flag if the selected request is of an active transfer.
>    Otherwise, any dequeue will change the endpoint's state even if it's for
>    some random request.
>
>  drivers/usb/dwc3/gadget.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 78cb4db8a6e4..9a00dcaca010 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -1763,6 +1763,8 @@ static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
>  			list_for_each_entry_safe(r, t, &dep->started_list, list)
>  				dwc3_gadget_move_cancelled_request(r);
>  
> +			dep->flags &= ~DWC3_EP_WAIT_TRANSFER_COMPLETE;

I'm not sure this is correct. This could create a race condition between
clearing this bit and getting the transfer complete interrupt. It also
seems to break the assumptions made by
dwc3_gadget_endpoint_trbs_complete() (actually its users), specially
regarding ISOC endpoints.

Have you verified all transfer types with this commit?

-- 
balbi
