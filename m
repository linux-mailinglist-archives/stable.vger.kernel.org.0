Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F946623E1
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 12:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjAILMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 06:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbjAILMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 06:12:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3DF14086;
        Mon,  9 Jan 2023 03:12:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE93FB80DAB;
        Mon,  9 Jan 2023 11:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090FBC433D2;
        Mon,  9 Jan 2023 11:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673262763;
        bh=zcY/YpmdAAMLoGt7bn8IulxIoZd2Ehm6U9GhZUL7mCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TIf5R75AM4F9gRfLd291j/ks3M0JEBdIwcmYkmZO+gGU5r91UhX4Qccn33YVhGhtq
         5BW/U8gXl8grRv+KsZ0Ud7BRoXETBRNFJpr22a6KVWXlRjXB/6A0QX2EMIBWB8szyB
         T2rCGnAMzqFsFgO2pd/mvd+1Jl+d/QJ/eGqPNypRnRiU1J12X+6ydEYV9jXsGGlUa8
         a58SBnjB76rg6ceoR+s78YGwLLSJxQZpXc4GSx0Vuut76oG5PhvCRsen9jIJEdZBNS
         0Fa0oivxdFUYld7t2c0exaWpdx1C8B9kQlwnfX0HZ+GnAvP6Z37wzQq/kqn76S8mYG
         GjCcAOvf1ybdg==
Date:   Mon, 9 Jan 2023 19:12:32 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: cdnsp: : add scatter gather support for ISOC
 endpoint
Message-ID: <20230109111232.GB94204@nchen-desktop>
References: <20221222090934.145140-1-pawell@cadence.com>
 <20230102082021.GB40748@nchen-desktop>
 <BYAPR07MB53814954118F9A671DF5AD4DDDFE9@BYAPR07MB5381.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR07MB53814954118F9A671DF5AD4DDDFE9@BYAPR07MB5381.namprd07.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23-01-09 05:47:49, Pawel Laszczak wrote:
> 
> >
> >On 22-12-22 04:09:34, Pawel Laszczak wrote:
> >> Patch implements scatter gather support for isochronous endpoint.
> >> This fix is forced by 'commit e81e7f9a0eb9
> >> ("usb: gadget: uvc: add scatter gather support")'.
> >> After this fix CDNSP driver stop working with UVC class.
> >>
> >> cc: <stable@vger.kernel.org>
> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
> >> USBSSP DRD Driver")
> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >> ---
> >>  drivers/usb/cdns3/cdnsp-gadget.c |   2 +-
> >>  drivers/usb/cdns3/cdnsp-gadget.h |   4 +-
> >>  drivers/usb/cdns3/cdnsp-ring.c   | 110 +++++++++++++++++--------------
> >>  3 files changed, 63 insertions(+), 53 deletions(-)
> >>
> >> diff --git a/drivers/usb/cdns3/cdnsp-gadget.c
> >> b/drivers/usb/cdns3/cdnsp-gadget.c
> >> index a8640516c895..e81dca0e62a8 100644
> >> --- a/drivers/usb/cdns3/cdnsp-gadget.c
> >> +++ b/drivers/usb/cdns3/cdnsp-gadget.c
> >> @@ -382,7 +382,7 @@ int cdnsp_ep_enqueue(struct cdnsp_ep *pep, struct
> >cdnsp_request *preq)
> >>  		ret = cdnsp_queue_bulk_tx(pdev, preq);
> >>  		break;
> >>  	case USB_ENDPOINT_XFER_ISOC:
> >> -		ret = cdnsp_queue_isoc_tx_prepare(pdev, preq);
> >> +		ret = cdnsp_queue_isoc_tx(pdev, preq);
> >>  	}
> >>
> >>  	if (ret)
> >> diff --git a/drivers/usb/cdns3/cdnsp-gadget.h
> >> b/drivers/usb/cdns3/cdnsp-gadget.h
> >> index f740fa6089d8..e1b5801fdddf 100644
> >> --- a/drivers/usb/cdns3/cdnsp-gadget.h
> >> +++ b/drivers/usb/cdns3/cdnsp-gadget.h
> >> @@ -1532,8 +1532,8 @@ void cdnsp_queue_stop_endpoint(struct
> >cdnsp_device *pdev,
> >>  			       unsigned int ep_index);
> >>  int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct
> >> cdnsp_request *preq);  int cdnsp_queue_bulk_tx(struct cdnsp_device
> >> *pdev, struct cdnsp_request *preq); -int
> >cdnsp_queue_isoc_tx_prepare(struct cdnsp_device *pdev,
> >> -				struct cdnsp_request *preq);
> >> +int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
> >> +			struct cdnsp_request *preq);
> >
> >Why you re-name this function?
> >
> >Other changes are ok for me.
> >
> 
> The function cdnsp_queue_isoc_tx_prepare has been removed and replaced
> with cdnsp_queue_isoc_tx.  I just add declaration of this function to header file.
> Before change cdnsp_queue_isoc_tx was static function.
> 

Reviewed-by: Peter Chen <peter.chen@kernel.org>

-- 

Thanks,
Peter Chen
