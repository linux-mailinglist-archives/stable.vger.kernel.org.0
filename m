Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4A2606169
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 15:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiJTNU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 09:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiJTNUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 09:20:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D0F51A0B;
        Thu, 20 Oct 2022 06:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27B74B82648;
        Thu, 20 Oct 2022 13:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9CFC433D6;
        Thu, 20 Oct 2022 13:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666272015;
        bh=Rsn6bw20rlalxQ/SID97AXkpPfvVGG+5j06netqtMyk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j59LDTD/B7Zaiswj1/PchAfkOEHRbpLbB3ej8uTyuF4x8nxPjkCVDcpYZIGSe+WbC
         tYZoUNuBOPEssrYxUaCuOKmEsUphZs/87kBa/sHjolGygCZ+BtGkjWrFJT2L68ZHQ5
         z5mjihBA2IWYiWYFG4we8OU1ztD3lRT/1jWeAWzr+g+F9GtziARY1vSyRX/xu8Y/pk
         JJDSjbW6Bkia95/dtwPsuYqpEgdHfrtLH160heyKobnAw4xrDAKbN4Sqm4mxMYVMNs
         u9ly/5LBRY5g3MlZwIlKrsOeU+/QN00SV6C6AcRpDDhHVvP2JrCnxHaG1STuqvFgKu
         wpTDeqEBA3Lyw==
Date:   Thu, 20 Oct 2022 21:20:10 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Message-ID: <20221020132010.GA29690@nchen-desktop>
References: <1666159637-161135-1-git-send-email-pawell@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666159637-161135-1-git-send-email-pawell@cadence.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-10-19 02:07:17, Pawel Laszczak wrote:
> Patch modifies the TD_SIZE in TRB before ZLP TRB.
> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
> processing ZLP TRB by controller.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdnsp-ring.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> index 794e413800ae..4809d0e894bb 100644
> --- a/drivers/usb/cdns3/cdnsp-ring.c
> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> @@ -1765,18 +1765,19 @@ static u32 cdnsp_td_remainder(struct cdnsp_device *pdev,
>  			      struct cdnsp_request *preq,
>  			      bool more_trbs_coming)
>  {
> -	u32 maxp, total_packet_count;
> -
> -	/* One TRB with a zero-length data packet. */
> -	if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
> -	    trb_buff_len == td_total_len)
> -		return 0;
> +	u32 maxp, total_packet_count, remainder;
>  
>  	maxp = usb_endpoint_maxp(preq->pep->endpoint.desc);
>  	total_packet_count = DIV_ROUND_UP(td_total_len, maxp);
>  
>  	/* Queuing functions don't count the current TRB into transferred. */
> -	return (total_packet_count - ((transferred + trb_buff_len) / maxp));
> +	remainder = (total_packet_count - ((transferred + trb_buff_len) / maxp));
> +
> +	/* Before ZLP driver needs set TD_SIZE=1. */
> +	if (!remainder && more_trbs_coming)
> +		remainder = 1;

Without ZLP, TD_SIZE = 0 for the last TRB.
With ZLP, TD_SIZE = 1 for current TRB, and TD_SIZE = 0 for the next TRB
(the last zero-length packet) right?

Peter

> +
> +	return remainder;
>  }
>  
>  static int cdnsp_align_td(struct cdnsp_device *pdev,
> -- 
> 2.25.1
> 

-- 

Thanks,
Peter Chen
