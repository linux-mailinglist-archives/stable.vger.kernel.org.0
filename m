Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3888460F116
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 09:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbiJ0HYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 03:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbiJ0HYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 03:24:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0A126CD;
        Thu, 27 Oct 2022 00:24:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58A28B824DB;
        Thu, 27 Oct 2022 07:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122F5C433D7;
        Thu, 27 Oct 2022 07:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666855466;
        bh=XGWXjowETE8UBbAKGcfAlH1j6ZOErNggqJGyo/pFcTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZBIGnlc/c2M5XhG6r1qrm2ZjcX5yNMJfCI9opDqPrhDfKsF1pwiKvdo2cMJgqw6Oh
         3p41ErALoZXRBk/uRWl8qNvdyD87LnYd4vcXsLriuEZU4TERSzK9ln4cSw1GQLXbsx
         f+AauZU00Lnp4+Zhxjlq68UMUFgZvX5t0eQWK8KUFT94ss7PVuJEB1HERCmRJdyXWH
         zpeWCZfikUghEqWPlx0kQVLvrIjWszLcWfdD8zP0kaf+bo5eiw1tf09acqyqqaVJAm
         RjSkNt065lWKorxtbTk/xn8MnHJ4mctY7JWFUYSvo32nmWfe/Z52gAfYHuXvArPnWO
         a5URXEBjoGKlg==
Date:   Thu, 27 Oct 2022 15:24:21 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Message-ID: <20221027072421.GA75844@nchen-desktop>
References: <1666620275-139704-1-git-send-email-pawell@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666620275-139704-1-git-send-email-pawell@cadence.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22-10-24 10:04:35, Pawel Laszczak wrote:
> Patch modifies the TD_SIZE in TRB before ZLP TRB.
> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
> processing ZLP TRB by controller.
> 
> cc: <stable@vger.kernel.org>
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> 
> ---
> Changelog:
> v2:
> - returned value for last TRB must be 0
> 
>  drivers/usb/cdns3/cdnsp-ring.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
> index 04dfcaa08dc4..aa79bce89d8a 100644
> --- a/drivers/usb/cdns3/cdnsp-ring.c
> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> @@ -1769,8 +1769,13 @@ static u32 cdnsp_td_remainder(struct cdnsp_device *pdev,
>  
>  	/* One TRB with a zero-length data packet. */
>  	if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
> -	    trb_buff_len == td_total_len)
> +	    trb_buff_len == td_total_len) {
> +		/* Before ZLP driver needs set TD_SIZE=1. */
> +		if (more_trbs_coming)
> +			return 1;
> +
>  		return 0;
> +	}

Does that fix the issue you want at bulk transfer, which has zero-length
packet at the last packet? It seems not align with your previous fix.
Would you mind explaining more?

>  
>  	maxp = usb_endpoint_maxp(preq->pep->endpoint.desc);
>  	total_packet_count = DIV_ROUND_UP(td_total_len, maxp);
> -- 
> 2.25.1
> 

-- 

Thanks,
Peter Chen
