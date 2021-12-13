Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3414472CF7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 14:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhLMNPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 08:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhLMNPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 08:15:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACEFC061574;
        Mon, 13 Dec 2021 05:15:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C6CA9CE100B;
        Mon, 13 Dec 2021 13:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DEBC34601;
        Mon, 13 Dec 2021 13:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639401297;
        bh=7YSSAAaM+CIfr3Dc7UnExlLCYseohcOQ5zO7iPdPqqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aBdowYwbegXVcB74Rj0OepKx3omwXechhqzyXfnipSaiXHkRXrfRqkQ1ZBUC0BpBj
         uhgef6Bn3P+yq1Vkmozd7KCAkp5bNzY2wAbujkTLCnZ6xWpgBW1k0sIttC8nNE8C7R
         LfedrXk58veHQUtWwujLNbbWts5kKBn20LhCWnuCIxo7RSmkRH4KI0Gy1ZVRwwrI27
         Ew8HlKFd1cUFgRriAwxbFmAmV78qY5TYMOEwTgAglbFSIZB1Un4kF7QL1i9pdePQPj
         deAYjNiVrswiEbqLRO8u7MuHiL8k8CY+7L0P/dTZbRGZt4NwmP/GJehvVQUXi59zzX
         2+q68hBlOxE7w==
Date:   Mon, 13 Dec 2021 21:14:47 +0800
From:   Peter Chen <peter.chen@kernel.org>
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: cdnsp: Fix issue in cdnsp_log_ep trace event
Message-ID: <20211213131447.GC5346@Peter>
References: <20211213050609.22640-1-pawell@gli-login.cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213050609.22640-1-pawell@gli-login.cadence.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21-12-13 06:06:09, Pawel Laszczak wrote:
> From: Pawel Laszczak <pawell@cadence.com>
> 
> Patch fixes incorrect order of __entry->stream_id and __entry->state
> parameters in TP_printk macro.
> 
> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
> cc: <stable@vger.kernel.org>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> ---
>  drivers/usb/cdns3/cdnsp-trace.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/cdns3/cdnsp-trace.h b/drivers/usb/cdns3/cdnsp-trace.h
> index 5aa88ca012de..13091df9934c 100644
> --- a/drivers/usb/cdns3/cdnsp-trace.h
> +++ b/drivers/usb/cdns3/cdnsp-trace.h
> @@ -57,9 +57,9 @@ DECLARE_EVENT_CLASS(cdnsp_log_ep,
>  		__entry->first_prime_det = pep->stream_info.first_prime_det;
>  		__entry->drbls_count = pep->stream_info.drbls_count;
>  	),
> -	TP_printk("%s: SID: %08x ep state: %x stream: enabled: %d num  %d "
> +	TP_printk("%s: SID: %08x, ep state: %x, stream: enabled: %d num %d "
>  		  "tds %d, first prime: %d drbls %d",
> -		  __get_str(name), __entry->state, __entry->stream_id,
> +		  __get_str(name), __entry->stream_id, __entry->state,
>  		  __entry->enabled, __entry->num_streams, __entry->td_count,
>  		  __entry->first_prime_det, __entry->drbls_count)
>  );
> -- 

Reviewed-by: Peter Chen <peter.chen@kernel.org>

-- 

Thanks,
Peter Chen

