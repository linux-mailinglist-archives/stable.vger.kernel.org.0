Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD5546E7A1
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 12:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbhLILhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 06:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhLILhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 06:37:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE0BC061746;
        Thu,  9 Dec 2021 03:34:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F13A9B82438;
        Thu,  9 Dec 2021 11:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5CDC004DD;
        Thu,  9 Dec 2021 11:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639049653;
        bh=/UoSYaophVFDvX7Odv3p2En0p+Ipv1vaAWvDHVFyQpE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I7nwVCja0RBkvgTFFsPPcuDBG3HDQJqw9KwpPxr6BEhUidxmvz9nDVHybSX3I0sst
         CN8X2bz7kFo0ciVIq5YKVHW3Qt/fwdRmDs1ysN/AKm3mEgOE6J+NBj3b96Vs/r2N+C
         b211lRncmTmpMdulLk0Rfp+gNKiyJD99tq4HmCajnQO+3eBcHHtqBsSVQku35L7Lb9
         fX5RHeysjHSfEErvaE42bNPKDg0x5kVBfVBdJ3XdC3XkLkSTfSNff5s2nHxIUoKKzo
         JMjYFk5skiSwr7PYZFjOgCJBBdJ/+QLYmpuHF2YJQYoelAxtbQwKY73TOcwLXTxt8U
         b8Xp4p7T4zrrA==
Date:   Thu, 9 Dec 2021 19:34:08 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jianhe@ambarella.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdnsp: Fix incorrect status for control request
Message-ID: <20211209113408.GA5084@Peter>
References: <20211207091838.39572-1-pawell@gli-login.cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207091838.39572-1-pawell@gli-login.cadence.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-12-07 10:18:38, Pawel Laszczak wrote:
> From: Pawel Laszczak <pawell@cadence.com>
> 
> Patch fixes incorrect status for control request.
> Without this fix all usb_request objects were returned to upper drivers
> with usb_reqest->status field set to -EINPROGRESS.
> 
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Reported-by: Ken (Jian) He <jianhe@ambarella.com>
> cc: <stable@vger.kernel.org>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdnsp-ring.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> index 1b1438457fb0..e8f5ecbb5c75 100644
> --- a/drivers/usb/cdns3/cdnsp-ring.c
> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> @@ -1029,6 +1029,8 @@ static void cdnsp_process_ctrl_td(struct cdnsp_device *pdev,
>  		return;
>  	}
>  
> +	*status = 0;
> +
>  	cdnsp_finish_td(pdev, td, event, pep, status);
>  }
>  
> -- 
I think you may move *status = 0 at the beginning of
cdnsp_process_ctrl_td in case you would like to handle some error
conditions during this function.

-- 

Thanks,
Peter Chen

