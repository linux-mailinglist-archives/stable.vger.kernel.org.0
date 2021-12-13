Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086DF472D55
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 14:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhLMNbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 08:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhLMNbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 08:31:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B723C06173F;
        Mon, 13 Dec 2021 05:31:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8D6F4CE1028;
        Mon, 13 Dec 2021 13:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9958CC34604;
        Mon, 13 Dec 2021 13:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639402288;
        bh=ddrO99bL/NvwLaXBteZTyz+8EIq6t4l7DZWd4XYCcWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OvsgjvhGXZA8uRNz5MFklA/U0NDDKWiC+JAkC6JZDhVn2PJC3dH6EhQgADDfXG3SX
         vfki56eyGcd58G6lclw5sJfZs49tHImgP5h74rvCqpLMQdKNt1tHjSriPOGDRnKVni
         Awx8F48gGf4FKx46AFoGIji6bZW5hs5cViLU1Vum5x7h4Pxzmmn+Yi5vNwKGkuN33u
         iuG29hkKUHse7ICNi6ym/wCwISnSAcyynqvOBn/ciJMsn4A/0F5yYcg1mlCQzmd6Y7
         eFkNAgEMyaIh9itP1vdAz5CBH/Tj20wWoYIdecV3fq/8LZ3wolzc/502ALdq1kTQD/
         f9Iw61iAPkYkA==
Date:   Mon, 13 Dec 2021 21:31:06 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jianhe@ambarella.com" <jianhe@ambarella.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: cdnsp: Fix incorrect status for control request
Message-ID: <20211213133106.GE5346@Peter>
References: <20211207091838.39572-1-pawell@gli-login.cadence.com>
 <20211209113408.GA5084@Peter>
 <BYAPR07MB5381415E88BAAC945CB47A93DD709@BYAPR07MB5381.namprd07.prod.outlook.com>
 <20211213130258.GA5346@Peter>
 <BYAPR07MB5381078C05112F8453C4914EDD749@BYAPR07MB5381.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR07MB5381078C05112F8453C4914EDD749@BYAPR07MB5381.namprd07.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-12-13 13:17:53, Pawel Laszczak wrote:
> >
> >On 21-12-09 12:57:31, Pawel Laszczak wrote:
> >> >> From: Pawel Laszczak <pawell@cadence.com>
> >> >>
> >> >> Patch fixes incorrect status for control request.
> >> >> Without this fix all usb_request objects were returned to upper drivers
> >> >> with usb_reqest->status field set to -EINPROGRESS.
> >> >>
> >> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> >> >> Reported-by: Ken (Jian) He <jianhe@ambarella.com>
> >> >> cc: <stable@vger.kernel.org>
> >> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >> >> ---
> >> >>  drivers/usb/cdns3/cdnsp-ring.c | 2 ++
> >> >>  1 file changed, 2 insertions(+)
> >> >>
> >> >> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> >> >> index 1b1438457fb0..e8f5ecbb5c75 100644
> >> >> --- a/drivers/usb/cdns3/cdnsp-ring.c
> >> >> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> >> >> @@ -1029,6 +1029,8 @@ static void cdnsp_process_ctrl_td(struct cdnsp_device *pdev,
> >> >>  		return;
> >> >>  	}
> >> >>
> >> >> +	*status = 0;
> >> >> +
> >> >>  	cdnsp_finish_td(pdev, td, event, pep, status);
> >> >>  }
> >> >>
> >> >> --
> >> >I think you may move *status = 0 at the beginning of
> >> >cdnsp_process_ctrl_td in case you would like to handle some error
> >> >conditions during this function.
> >>
> >> I don't predict any other status code for control request in this place.
> >> I wanted to set this status only once after completion status stage. It was the reason why I put this
> >> statement at the end of function.
> >
> >So, you always consider there is no error for control request handling?
> 
> Not exactly. In this place driver handles only case when status stage has been completed, 
> so control transfer has been finished successfully.   
> 
> Driver still take into account for  control transfer such errors as:  STALL, EINVAL and ECONNRESET but
> in other parts of source code.
> 

Reviewed-by: Peter Chen <peter.chen@kernel.org>

-- 

Thanks,
Peter Chen

