Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B8549ADFA
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 09:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450287AbiAYI0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 03:26:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32952 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450168AbiAYIYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 03:24:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FB50B8162C;
        Tue, 25 Jan 2022 08:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222ABC340E0;
        Tue, 25 Jan 2022 08:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643099071;
        bh=zhEJSMgOmCREgcS8sTDwVMLZTw5f5ROgOOgi3EInTqM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nEaLL1TsOZ2wtCC/6Mf+UAQCuY4QNAw0sIrT9MvRW7X7+caQDud1ootEMANZobvtK
         k56VZpKRFr4yGNOCvdaLOek5b1F4cJMuGjTiZyA264g8hNxFFrGpbxIR+JNlPqzWNu
         ykLGyFflEv1C2BAEFOqC5Soh7Yoi1vyIF4vB22VKqMgXI9WQTnEjErtgE2Tfy1q7wp
         57QM/qVfiDXjL9R7l1GjZJyWPRWpCaAv7wFej2WT/NzkuiJjSTD6coMsno4dfC0MgO
         e0EHbSSFCPFGKWl3DxThy6imvbDbJ0+WwxN2Ve7fedGSchV6Xf4KFG+AL/gfEQXd+J
         RwekOcxv3E7TA==
Date:   Tue, 25 Jan 2022 09:24:26 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, stable@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND] media: omap3isp: Use struct_group() for memcpy()
 region
Message-ID: <20220125092426.7bdfba8f@coco.lan>
In-Reply-To: <20220124172952.2411764-1-keescook@chromium.org>
References: <20220124172952.2411764-1-keescook@chromium.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Mon, 24 Jan 2022 09:29:52 -0800
Kees Cook <keescook@chromium.org> escreveu:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields. Wrap the target region
> in struct_group(). This additionally fixes a theoretical misalignment
> of the copy (since the size of "buf" changes between 64-bit and 32-bit,
> but this is likely never built for 64-bit).


> FWIW, I think this code is totally broken on 64-bit (which appears to
> not be a "real" build configuration): it would either always fail (with
> an uninitialized data->buf_size) or would cause corruption in userspace
> due to the copy_to_user() in the call path against an uninitialized
> data->buf value:

It doesn't matter. This driver is specific for TI OMAP3 SoC, which
is Cortex-A8 (32-bits). It only builds on 64 bit due to COMPILE_TEST.

Regards,
Mauro

> 
> omap3isp_stat_request_statistics_time32(...)
>     struct omap3isp_stat_data data64;
>     ...
>     omap3isp_stat_request_statistics(stat, &data64);
> 
> int omap3isp_stat_request_statistics(struct ispstat *stat,
>                                      struct omap3isp_stat_data *data)
>     ...
>     buf = isp_stat_buf_get(stat, data);
> 
> static struct ispstat_buffer *isp_stat_buf_get(struct ispstat *stat,
>                                                struct omap3isp_stat_data *data)
> ...
>     if (buf->buf_size > data->buf_size) {
>             ...
>             return ERR_PTR(-EINVAL);
>     }
>     ...
>     rval = copy_to_user(data->buf,
>                         buf->virt_addr,
>                         buf->buf_size);
> 
> Regardless, additionally initialize data64 to be zero-filled to avoid
> undefined behavior.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: linux-media@vger.kernel.org
> Fixes: 378e3f81cb56 ("media: omap3isp: support 64-bit version of omap3isp_stat_data")
> Cc: stable@vger.kernel.org
> Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Link: https://lore.kernel.org/lkml/20211215220505.GB21862@embeddedor
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> I will carry this in my tree unless someone else wants to pick it up. It's
> one of the last remaining clean-ups needed for the next step in memcpy()
> hardening.
> ---
>  drivers/media/platform/omap3isp/ispstat.c |  5 +++--
>  include/uapi/linux/omap3isp.h             | 21 +++++++++++++--------
>  2 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
> index 5b9b57f4d9bf..68cf68dbcace 100644
> --- a/drivers/media/platform/omap3isp/ispstat.c
> +++ b/drivers/media/platform/omap3isp/ispstat.c
> @@ -512,7 +512,7 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
>  int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
>  					struct omap3isp_stat_data_time32 *data)
>  {
> -	struct omap3isp_stat_data data64;
> +	struct omap3isp_stat_data data64 = { };
>  	int ret;
>  
>  	ret = omap3isp_stat_request_statistics(stat, &data64);
> @@ -521,7 +521,8 @@ int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
>  
>  	data->ts.tv_sec = data64.ts.tv_sec;
>  	data->ts.tv_usec = data64.ts.tv_usec;
> -	memcpy(&data->buf, &data64.buf, sizeof(*data) - sizeof(data->ts));
> +	data->buf = (uintptr_t)data64.buf;
> +	memcpy(&data->frame, &data64.frame, sizeof(data->frame));
>  
>  	return 0;
>  }
> diff --git a/include/uapi/linux/omap3isp.h b/include/uapi/linux/omap3isp.h
> index 87b55755f4ff..d9db7ad43890 100644
> --- a/include/uapi/linux/omap3isp.h
> +++ b/include/uapi/linux/omap3isp.h
> @@ -162,6 +162,7 @@ struct omap3isp_h3a_aewb_config {
>   * struct omap3isp_stat_data - Statistic data sent to or received from user
>   * @ts: Timestamp of returned framestats.
>   * @buf: Pointer to pass to user.
> + * @buf_size: Size of buffer.
>   * @frame_number: Frame number of requested stats.
>   * @cur_frame: Current frame number being processed.
>   * @config_counter: Number of the configuration associated with the data.
> @@ -176,10 +177,12 @@ struct omap3isp_stat_data {
>  	struct timeval ts;
>  #endif
>  	void __user *buf;
> -	__u32 buf_size;
> -	__u16 frame_number;
> -	__u16 cur_frame;
> -	__u16 config_counter;
> +	__struct_group(/* no tag */, frame, /* no attrs */,
> +		__u32 buf_size;
> +		__u16 frame_number;
> +		__u16 cur_frame;
> +		__u16 config_counter;
> +	);
>  };
>  
>  #ifdef __KERNEL__
> @@ -189,10 +192,12 @@ struct omap3isp_stat_data_time32 {
>  		__s32	tv_usec;
>  	} ts;
>  	__u32 buf;
> -	__u32 buf_size;
> -	__u16 frame_number;
> -	__u16 cur_frame;
> -	__u16 config_counter;
> +	__struct_group(/* no tag */, frame, /* no attrs */,
> +		__u32 buf_size;
> +		__u16 frame_number;
> +		__u16 cur_frame;
> +		__u16 config_counter;
> +	);
>  };
>  #endif
>  



Thanks,
Mauro
