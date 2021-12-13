Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9E1472CC0
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 14:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbhLMNDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 08:03:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55508 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbhLMNDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 08:03:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42802B80EC5;
        Mon, 13 Dec 2021 13:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C859C34602;
        Mon, 13 Dec 2021 13:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639400588;
        bh=nTxKyHF1jC9M+ChnTa2i7iJGpJ4/W7CueQKrDF9/29o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eYwrNKS94IVdZlgIRFgwmb08WdKYJBbbGOiryztgbiDvOblRq8IfXRwKTUKQCelU2
         BmtqcAGNaNyotJwXMmr0L1CK1Zu+sTkN9AXrn86u8wzSPR8joYf9dHfNESrlxOPEnX
         4OI/ijyfVKeLUxy+l49NTpUp78wI/G54GVaZjJqQBVO7b1YFN7rEB8zM33ea3TFr7F
         vmzjntRqGuRNYqztKqj01CpzuoE/eUykTyTh7ZLSsJSD59QGVnx9F9qZxPFYK/MNVf
         /FQaajoCZFvGWLXI+pYTZmj64EP0zTguJtpR0JRfZtMe35VGXdgvCDIqzNJtM2WL2h
         f0ibZb2sFNT1g==
Date:   Mon, 13 Dec 2021 21:02:58 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jianhe@ambarella.com" <jianhe@ambarella.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: cdnsp: Fix incorrect status for control request
Message-ID: <20211213130258.GA5346@Peter>
References: <20211207091838.39572-1-pawell@gli-login.cadence.com>
 <20211209113408.GA5084@Peter>
 <BYAPR07MB5381415E88BAAC945CB47A93DD709@BYAPR07MB5381.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR07MB5381415E88BAAC945CB47A93DD709@BYAPR07MB5381.namprd07.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-12-09 12:57:31, Pawel Laszczak wrote:
> >> From: Pawel Laszczak <pawell@cadence.com>
> >>
> >> Patch fixes incorrect status for control request.
> >> Without this fix all usb_request objects were returned to upper drivers
> >> with usb_reqest->status field set to -EINPROGRESS.
> >>
> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> >> Reported-by: Ken (Jian) He <jianhe@ambarella.com>
> >> cc: <stable@vger.kernel.org>
> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >> ---
> >>  drivers/usb/cdns3/cdnsp-ring.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> >> index 1b1438457fb0..e8f5ecbb5c75 100644
> >> --- a/drivers/usb/cdns3/cdnsp-ring.c
> >> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> >> @@ -1029,6 +1029,8 @@ static void cdnsp_process_ctrl_td(struct cdnsp_device *pdev,
> >>  		return;
> >>  	}
> >>
> >> +	*status = 0;
> >> +
> >>  	cdnsp_finish_td(pdev, td, event, pep, status);
> >>  }
> >>
> >> --
> >I think you may move *status = 0 at the beginning of
> >cdnsp_process_ctrl_td in case you would like to handle some error
> >conditions during this function.
> 
> I don't predict any other status code for control request in this place.
> I wanted to set this status only once after completion status stage. It was the reason why I put this
> statement at the end of function.

So, you always consider there is no error for control request handling?

-- 

Thanks,
Peter Chen

