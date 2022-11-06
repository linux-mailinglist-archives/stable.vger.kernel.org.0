Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2707361E121
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 10:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiKFJCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 04:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiKFJCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 04:02:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F1F2663;
        Sun,  6 Nov 2022 01:02:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E218B80B30;
        Sun,  6 Nov 2022 09:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2F8C433D6;
        Sun,  6 Nov 2022 09:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667725346;
        bh=xjKCgVmFbXFxtKFBYyK+XNvbHjCTI456JH43nwr0lEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T9unJaNs6HLnI2qRq4XbuONifxSjf0RJRYhKfas+wxK0doTZWhX2Vxi39kuPEzrO1
         +BV+lm/BOobR6s2lIx1pnCeyyfzWQXnIHRZ0qr9Wgc8MsPH6MehxcEhifAsz/gCVMR
         wvbdlY7k7tV3PjNt7Ctd0UhP6JiWltIf9hTki/rSmR64249F9Up3gEhGCvzC/K1UUw
         q9WzrK8uP8dz9slhiVl6SMQbmszxY25erslacG3LzbC9pUj69lwABU9ze9xERKJkcR
         wekQkPj45xpacM2TntuWA291big5LixYfpfKE1aAa0O4qd/nFGMnoR+QB4LeTUmdNh
         lMSMKTgYI6f8Q==
Date:   Sun, 6 Nov 2022 17:02:21 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Message-ID: <20221106090221.GA152143@nchen-desktop>
References: <1666620275-139704-1-git-send-email-pawell@cadence.com>
 <20221027072421.GA75844@nchen-desktop>
 <BYAPR07MB5381482129407B849BA9A616DD339@BYAPR07MB5381.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR07MB5381482129407B849BA9A616DD339@BYAPR07MB5381.namprd07.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-10-27 08:46:17, Pawel Laszczak wrote:
> 
> >
> >On 22-10-24 10:04:35, Pawel Laszczak wrote:
> >> Patch modifies the TD_SIZE in TRB before ZLP TRB.
> >> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force processing
> >> ZLP TRB by controller.
> >>
> >> cc: <stable@vger.kernel.org>
> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
> >> USBSSP DRD Driver")
> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >>
> >> ---
> >> Changelog:
> >> v2:
> >> - returned value for last TRB must be 0
> >>
> >>  drivers/usb/cdns3/cdnsp-ring.c | 7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/usb/cdns3/cdnsp-ring.c
> >> b/drivers/usb/cdns3/cdnsp-ring.c index 04dfcaa08dc4..aa79bce89d8a
> >> 100644
> >> --- a/drivers/usb/cdns3/cdnsp-ring.c
> >> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> >> @@ -1769,8 +1769,13 @@ static u32 cdnsp_td_remainder(struct
> >> cdnsp_device *pdev,
> >>
> >>  	/* One TRB with a zero-length data packet. */
> >>  	if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
> >> -	    trb_buff_len == td_total_len)
> >> +	    trb_buff_len == td_total_len) {
> >> +		/* Before ZLP driver needs set TD_SIZE=1. */
> >> +		if (more_trbs_coming)
> >> +			return 1;
> >> +
> >>  		return 0;
> >> +	}
> >
> >Does that fix the issue you want at bulk transfer, which has zero-length packet
> >at the last packet? It seems not align with your previous fix.
> >Would you mind explaining more?
> 
> Value returned by function cdnsp_td_remainder is used 
> as TD_SIZE in TRB.
> 
> The last TRB in TD should have TD_SIZE=0, so trb for ZLP should have
> set also TD_SIZE=0. If driver set TD_SIZE=0 on before the last one
> TRB then the controller stops the transfer and ignore trb for ZLP packet.
> 
> To fix this, the driver in such case must set TD_SIZE = 1
> before the last TRB. 

  	if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
 -	    trb_buff_len == td_total_len)
 +	    trb_buff_len == td_total_len) {
 +		/* Before ZLP driver needs set TD_SIZE=1. */
 +		if (more_trbs_coming)
 +			return 1;
 +
  		return 0;
 +	}

How your above fix could return TD_SIZE as 1 for last non-ZLP TRB?
Which conditions are satisfied?

Peter

> e.g.
> 
> TD -> TRB1  transfer_length = 64KB, TD_SIZE =0
>           TRB2 transfer_length =0, TD_SIZE = 0  - controller will
> 		    ignore this transfer and stop transfer on previous one
> 
> TD -> TRB1  transfer_length = 64KB, TD_SIZE =1
>           TRB2 transfer_length =0, TD_SIZE = 0  - controller will
> 		    execute this trb and send ZLP
> 
> As you noticed previously, previous fix for last TRB returned
> TD_SIZE = 1 in some cases.
> Previous fix was working correct but was not compliance with
> controller specification.
> 
> >
> >>
> >>  	maxp = usb_endpoint_maxp(preq->pep->endpoint.desc);
> >>  	total_packet_count = DIV_ROUND_UP(td_total_len, maxp);
> >> --
> >> 2.25.1
> >>
> >
> >--
> >
> 
> Thanks,
> Pawel Laszczak

-- 

Thanks,
Peter Chen
