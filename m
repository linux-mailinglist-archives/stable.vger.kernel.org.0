Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D497608D75
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 15:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJVNn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 09:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJVNn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 09:43:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AF41D0E9;
        Sat, 22 Oct 2022 06:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D140600A0;
        Sat, 22 Oct 2022 13:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D11C433C1;
        Sat, 22 Oct 2022 13:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666446204;
        bh=23QxA+M5S6H4DcowzMHJG00jNE/2O8r9A640gDM5zu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jXyOk6gbU1Fzfuj8+1dyFfm2/PEN5YaPlKVloWqQkm1bSey+JZcTauOMh5hXBfXZQ
         SDS7weCSdbOpVxCCEm/Hqjr8P1QiCG9ai/nBtCNxiJigEnIZKG/dHmVpj4IDZtDj6B
         otsBPBdgHMW6VSHVQZdXi/qoNZpZz/ILlQWpQzG1ppDwMHM7b2ChZQ49vunhKyODwO
         HnTL0U6gVwoehGJK/TEX4ieRHJ9wUv1mgpNvr9hD6OFhgyK6tqeT4O+vaE/jH7UAin
         kuf01/WI4NNiZbCL2b+0Zc4PxlmlI3UUl9ug7NWXkSbs3ZoVlYwBrxzhFUz09s375P
         rxwoVSfVjb0HQ==
Date:   Sat, 22 Oct 2022 21:43:18 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Message-ID: <20221022134318.GA51416@nchen-desktop>
References: <1666159637-161135-1-git-send-email-pawell@cadence.com>
 <20221020132010.GA29690@nchen-desktop>
 <BYAPR07MB5381E4649DFD2BD0C528AC0FDD2D9@BYAPR07MB5381.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR07MB5381E4649DFD2BD0C528AC0FDD2D9@BYAPR07MB5381.namprd07.prod.outlook.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-10-21 05:03:25, Pawel Laszczak wrote:
> >
> >
> >On 22-10-19 02:07:17, Pawel Laszczak wrote:
> >> Patch modifies the TD_SIZE in TRB before ZLP TRB.
> >> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force processing
> >> ZLP TRB by controller.
> >>
> >> Cc: <stable@vger.kernel.org>
> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
> >> USBSSP DRD Driver")
> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >> ---
> >>  drivers/usb/cdns3/cdnsp-ring.c | 15 ++++++++-------
> >>  1 file changed, 8 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/usb/cdns3/cdnsp-ring.c
> >> b/drivers/usb/cdns3/cdnsp-ring.c index 794e413800ae..4809d0e894bb
> >> 100644
> >> --- a/drivers/usb/cdns3/cdnsp-ring.c
> >> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> >> @@ -1765,18 +1765,19 @@ static u32 cdnsp_td_remainder(struct
> >cdnsp_device *pdev,
> >>  			      struct cdnsp_request *preq,
> >>  			      bool more_trbs_coming)
> >>  {
> >> -	u32 maxp, total_packet_count;
> >> -
> >> -	/* One TRB with a zero-length data packet. */
> >> -	if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
> >> -	    trb_buff_len == td_total_len)
> >> -		return 0;
> >> +	u32 maxp, total_packet_count, remainder;
> >>
> >>  	maxp = usb_endpoint_maxp(preq->pep->endpoint.desc);
> >>  	total_packet_count = DIV_ROUND_UP(td_total_len, maxp);
> >>
> >>  	/* Queuing functions don't count the current TRB into transferred. */
> >> -	return (total_packet_count - ((transferred + trb_buff_len) / maxp));
> >> +	remainder = (total_packet_count - ((transferred + trb_buff_len) /
> >> +maxp));
> >> +
> >> +	/* Before ZLP driver needs set TD_SIZE=1. */
> >> +	if (!remainder && more_trbs_coming)
> >> +		remainder = 1;
> >
> >Without ZLP, TD_SIZE = 0 for the last TRB.
> >With ZLP, TD_SIZE = 1 for current TRB, and TD_SIZE = 0 for the next TRB (the
> >last zero-length packet) right?
> 
> Yes, you have right.
> 

Pawel, With your changes, the return value is 1 for function
cdnsp_queue_ctrl_tx. Without your changes, it is 0, something wrong?

-- 

Thanks,
Peter Chen
