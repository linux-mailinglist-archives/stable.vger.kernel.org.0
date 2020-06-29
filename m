Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA1E20E1A3
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbgF2U6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730795AbgF2TNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 15:13:04 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27941C00861B;
        Mon, 29 Jun 2020 03:32:26 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f7so13005273wrw.1;
        Mon, 29 Jun 2020 03:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uA93shaS3ROaZO1F/Theu2W+pMXUv937OHVYLQtQpJc=;
        b=QK9tK1GHNBE7aDAP8tGPnrwMHTwrspXJNSldTfaw2XfVBowb4ndW3UB1CXE+lCXLiD
         oZ3dwZ/LQQflwvqsBUPoydEzXLNhTeBeNUdbt1ugJZ2DwoylZp8MXRE4OInh8OKgUNZU
         1W6IFepl8kW12d6/MYgcGQA+X+1d7L/Q05ntTPVWi2kgbPkiAsbfY1CmNyx/263kVp1u
         5zP8ISuN6/7XyZ2oRH/ZkTBitJEFi6zWEgTnFnNRQ6JWhCdl/lAW62OS/gS7YnzoG/zy
         f8wWRGRPVY/9ko9g4VMsV/UdbkPiQjAoWA8g/WdkqDBeppBUz+sCQVoUA2iSDbi2FrBF
         pGPw==
X-Gm-Message-State: AOAM530lsHdL+EFmCZzaqvdxSTzXEJ8hPA9m4vTuZ3Ev3foTsiIM6fnN
        7SnYhW46nm9CqbKW3aUKe54=
X-Google-Smtp-Source: ABdhPJyQVyWd7PiCVN+PqIz3jcQ5yfRgoN5qX/9YK1HLjlJOQ0zbG0Eh8/SqLuvv2dP6GWVZw170OA==
X-Received: by 2002:adf:ee05:: with SMTP id y5mr16955076wrn.185.1593426744827;
        Mon, 29 Jun 2020 03:32:24 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id r1sm14814942wrw.24.2020.06.29.03.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 03:32:24 -0700 (PDT)
Date:   Mon, 29 Jun 2020 10:32:23 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Joseph Salisbury <joseph.salisbury@microsoft.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, wei.liu@kernel.org, mikelley@microsoft.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH][v2] Drivers: hv: Change flag to write log level in panic
 msg to false
Message-ID: <20200629103223.ft7l76vbr45eec6x@liuwe-devbox-debian-v2>
References: <1593210497-114310-1-git-send-email-joseph.salisbury@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593210497-114310-1-git-send-email-joseph.salisbury@microsoft.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 03:28:17PM -0700, Joseph Salisbury wrote:
> When the kernel panics, one page of kmsg data may be collected and sent to
> Hyper-V to aid in diagnosing the failure.  The collected kmsg data typically
>  contains 50 to 100 lines, each of which has a log level prefix that isn't
> very useful from a diagnostic standpoint.  So tell kmsg_dump_get_buffer()
> to not include the log level, enabling more information that *is* useful to
> fit in the page.
> 
> Requesting in stable kernels, since many kernels running in production are
> stable releases.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Joseph Salisbury <joseph.salisbury@microsoft.com>

Applied to hyperv-fixes with Michael's review from v1. Thanks.

> ---
>  drivers/hv/vmbus_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 9147ee9d5f7d..d69f4efa3719 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -1368,7 +1368,7 @@ static void hv_kmsg_dump(struct kmsg_dumper *dumper,
>  	 * Write dump contents to the page. No need to synchronize; panic should
>  	 * be single-threaded.
>  	 */
> -	kmsg_dump_get_buffer(dumper, true, hv_panic_page, HV_HYP_PAGE_SIZE,
> +	kmsg_dump_get_buffer(dumper, false, hv_panic_page, HV_HYP_PAGE_SIZE,
>  			     &bytes_written);
>  	if (bytes_written)
>  		hyperv_report_panic_msg(panic_pa, bytes_written);
> -- 
> 2.17.1
> 
