Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63C749C02D
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 01:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbiAZAej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 19:34:39 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:43710 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235320AbiAZAeg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 19:34:36 -0500
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A905771;
        Wed, 26 Jan 2022 01:34:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1643157274;
        bh=lUX+kFPnDrnpFIwRLB+0ea+BzHc8BeXdjxjNfpaQf8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WSd3MCZcI+qCUvtATN5gB1lFpUqU1+Q+c83YGWkknRH05LoWGRMzUCvn8qBCeICPV
         /8sMCyWIsZKlV+NNBsIZikbz/z8ME8t8AQtX3RdgVKUm/MCepvjrOpbTu6voN00GGy
         pzaooN0jnvnmfvYRhUvLVgIERMErGpOsfRnAs+ZQ=
Date:   Wed, 26 Jan 2022 02:34:15 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, stable@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND] media: omap3isp: Use struct_group() for memcpy()
 region
Message-ID: <YfCXB7+XOJ8Ue+rR@pendragon.ideasonboard.com>
References: <20220124172952.2411764-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220124172952.2411764-1-keescook@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kees,

Thank you for the patch.

On Mon, Jan 24, 2022 at 09:29:52AM -0800, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields. Wrap the target region
> in struct_group(). This additionally fixes a theoretical misalignment
> of the copy (since the size of "buf" changes between 64-bit and 32-bit,
> but this is likely never built for 64-bit).
> 
> FWIW, I think this code is totally broken on 64-bit (which appears to
> not be a "real" build configuration): it would either always fail (with
> an uninitialized data->buf_size) or would cause corruption in userspace
> due to the copy_to_user() in the call path against an uninitialized
> data->buf value:
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

I don't mind either way. Sakari, do you want to pick the patch up ?

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

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

-- 
Regards,

Laurent Pinchart
