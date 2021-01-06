Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACAD2EBAE6
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 08:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbhAFHyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 02:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbhAFHyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 02:54:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8141923107;
        Wed,  6 Jan 2021 07:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609919644;
        bh=j5YThDLZfb4EpafLxe4k3rXFuluI4oztf/lLDLsmL2U=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Q2R7Oow/MA97X7XDkcsW7SitfThJmxe+0zMJ66N9IqLiG/9VksoZmtAS4FslmNPNZ
         ehzLm4pslcTjQsjdWm2sOQqITSxMcVD9vy+QGOqjbBVNm1s1u9HjS1AL6i/2Vfwsbp
         Wa+v+IBiXERbOdmCT/Ptqnr61p4PpqmMJpQT8B9XvOYwuvumpUNX3R0U81Br95Ymvo
         +UXIOkgGQBiOmA+rb9eS3RhgENrb82Aapp398qPDYXhkuyQdLeBvSHki/q2BPFTZ4N
         RBk5irVMim55yLPaMm6jSnX7o6filL3tSu83mDrWOVKRGFL/JrqP/FGEcjli4zB0/T
         saFFbFD3j8P2g==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: dwc3: gadget: Check if the gadget had stopped
In-Reply-To: <9d057f37b82083af331fb6225d7c7ef3d1840a6e.1609865348.git.Thinh.Nguyen@synopsys.com>
References: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
 <9d057f37b82083af331fb6225d7c7ef3d1840a6e.1609865348.git.Thinh.Nguyen@synopsys.com>
Date:   Wed, 06 Jan 2021 09:54:00 +0200
Message-ID: <877doqcxgn.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
> If the gadget had already stopped, don't try to stop again. Otherwise
> we'd get a warning for trying to free an already freed irq. This can
> happen if a user tries to trigger a soft-disconnect from soft_connect
> sysfs multiple times. The fix is to check if there's a bounded gadget
> driver to determined if the gadget had stopped.
>
> Cc: stable@vger.kernel.org
> Fixes: 8698e2acf3a5 ("usb: dwc3: gadget: introduce and use enable/disable irq methods")
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/usb/dwc3/gadget.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 51d81a32ce78..9ec70282e610 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2338,6 +2338,10 @@ static int dwc3_gadget_stop(struct usb_gadget *g)
>  	struct dwc3		*dwc = gadget_to_dwc(g);
>  	unsigned long		flags;
>  
> +	/* The controller is already stopped if there's no gadget driver */
> +	if (!dwc->gadget_driver)
> +		return 0;

same here. Better done at the framework

-- 
balbi
