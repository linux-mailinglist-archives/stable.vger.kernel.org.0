Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0954410C454
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 08:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfK1Hhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 02:37:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbfK1Hhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 02:37:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BE312154A;
        Thu, 28 Nov 2019 07:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574926654;
        bh=uJn9SEkaDvAg+ikL6FA9KhxlSb5h2187kV8XT21sBAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SMVp+EEChpEM20jbz+SUeo9ASpKsWPxLkxh7KlCY+I2LoWSoB5H33snQmv15ShBdm
         rHncFCQDO4Ex57sv6gM+1kDMUuCutmafGjeQYnSF7+wCXxL2FUsBQAd+0SlHNauoOF
         GS+gTWypVTav/HQxsJYMEHigXN8vWfZqcFTReZmI=
Date:   Thu, 28 Nov 2019 08:18:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: Check for NULL descriptor
Message-ID: <20191128071841.GB3317260@kroah.com>
References: <bbb1564aa649a6b5b97160ec3ef9fefdd8c85aea.1574891043.git.thinhn@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbb1564aa649a6b5b97160ec3ef9fefdd8c85aea.1574891043.git.thinhn@synopsys.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 01:45:15PM -0800, Thinh Nguyen wrote:
> The function driver may try to enable an unconfigured endpoint. This
> check make sure that we do not attempt to access a NULL descriptor and
> crash.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
> ---
>  drivers/usb/dwc3/gadget.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 7f97856e6b20..00f8f079bbf2 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -619,6 +619,9 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep, unsigned int action)
>  	u32			reg;
>  	int			ret;
>  
> +	if (!desc)
> +		return -EINVAL;

How can this happen?  Shouldn't this be caught at an earlier point in
time?

thanks,

greg k-h
