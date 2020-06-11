Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396731F6B88
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 17:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgFKPvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 11:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbgFKPvH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 11:51:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B579206A4;
        Thu, 11 Jun 2020 15:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591890665;
        bh=0i52mGoeksoc7L27nFMcpvuLY8HKp+wqTbv9H7+nprA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TozrJIrr8kN1vFIjF94rnrUDVXAooIhPuBYaVVWucMRowIbKI9MHVSjMO3/reX9GW
         VbNAdHTzO9K7Xcqlz26sM2bAVeUYVS+gNt47STLtZYLB4xaX7KTmonmpf/uO2jTHgu
         XoWKWYpa5rO8OOjVjOBuTKnoN4Uhv494uc/wpx8k=
Date:   Thu, 11 Jun 2020 17:50:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Cc:     linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        helen.koike@collabora.com, ezequiel@collabora.com,
        hverkuil@xs4all.nl, kernel@collabora.com, dafna3@gmail.com,
        sakari.ailus@linux.intel.com, linux-rockchip@lists.infradead.org,
        mchehab@kernel.org, tfiga@chromium.org, stable@vger.kernel.org
Subject: Re: [RESEND PATCH v3 2/6] media: staging: rkisp1: rsz: set default
 format if the given format is not RKISP1_DIR_SRC
Message-ID: <20200611155059.GB1456044@kroah.com>
References: <20200611154551.25022-1-dafna.hirschfeld@collabora.com>
 <20200611154551.25022-3-dafna.hirschfeld@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611154551.25022-3-dafna.hirschfeld@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 05:45:47PM +0200, Dafna Hirschfeld wrote:
> When setting the sink format of the 'rkisp1_resizer'
> the format should be supported by 'rkisp1_isp' on
> the video source pad. This patch checks this condition
> and set the format to default if the condition is false.
> 
> Fixes: 56e3b29f9f6b "media: staging: rkisp1: add streaming paths"
> 
> Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  drivers/staging/media/rkisp1/rkisp1-common.h  | 4 ++++
>  drivers/staging/media/rkisp1/rkisp1-isp.c     | 4 ----
>  drivers/staging/media/rkisp1/rkisp1-resizer.c | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/media/rkisp1/rkisp1-common.h b/drivers/staging/media/rkisp1/rkisp1-common.h
> index 0c4fe503adc9..39d8e46d8d8a 100644
> --- a/drivers/staging/media/rkisp1/rkisp1-common.h
> +++ b/drivers/staging/media/rkisp1/rkisp1-common.h
> @@ -22,6 +22,10 @@
>  #include "rkisp1-regs.h"
>  #include "uapi/rkisp1-config.h"
>  
> +#define RKISP1_DIR_SRC BIT(0)
> +#define RKISP1_DIR_SINK BIT(1)
> +#define RKISP1_DIR_SINK_SRC (RKISP1_DIR_SINK | RKISP1_DIR_SRC)
> +
>  #define RKISP1_ISP_MAX_WIDTH		4032
>  #define RKISP1_ISP_MAX_HEIGHT		3024
>  #define RKISP1_ISP_MIN_WIDTH		32
> diff --git a/drivers/staging/media/rkisp1/rkisp1-isp.c b/drivers/staging/media/rkisp1/rkisp1-isp.c
> index dc2b59a0160a..e66e87d6ea8b 100644
> --- a/drivers/staging/media/rkisp1/rkisp1-isp.c
> +++ b/drivers/staging/media/rkisp1/rkisp1-isp.c
> @@ -23,10 +23,6 @@
>  
>  #define RKISP1_ISP_DEV_NAME	RKISP1_DRIVER_NAME "_isp"
>  
> -#define RKISP1_DIR_SRC BIT(0)
> -#define RKISP1_DIR_SINK BIT(1)
> -#define RKISP1_DIR_SINK_SRC (RKISP1_DIR_SINK | RKISP1_DIR_SRC)
> -
>  /*
>   * NOTE: MIPI controller and input MUX are also configured in this file.
>   * This is because ISP Subdev describes not only ISP submodule (input size,
> diff --git a/drivers/staging/media/rkisp1/rkisp1-resizer.c b/drivers/staging/media/rkisp1/rkisp1-resizer.c
> index d64c064bdb1d..fa28f4bd65c0 100644
> --- a/drivers/staging/media/rkisp1/rkisp1-resizer.c
> +++ b/drivers/staging/media/rkisp1/rkisp1-resizer.c
> @@ -542,7 +542,7 @@ static void rkisp1_rsz_set_sink_fmt(struct rkisp1_resizer *rsz,
>  					    which);
>  	sink_fmt->code = format->code;
>  	mbus_info = rkisp1_isp_mbus_info_get(sink_fmt->code);
> -	if (!mbus_info) {
> +	if (!mbus_info || !(mbus_info->direction & RKISP1_DIR_SRC)) {
>  		sink_fmt->code = RKISP1_DEF_FMT;
>  		mbus_info = rkisp1_isp_mbus_info_get(sink_fmt->code);
>  	}
> -- 
> 2.17.1
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
