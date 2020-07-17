Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EA62236BD
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 10:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgGQIOf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 17 Jul 2020 04:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgGQIOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 04:14:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0228AC061755
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 01:14:35 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jwLVn-0001qL-9I; Fri, 17 Jul 2020 10:14:31 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1jwLVn-0007E0-0T; Fri, 17 Jul 2020 10:14:31 +0200
Message-ID: <51175cb496644aaa5d5004630925ead4c6f0ddc7.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] media: coda: Fix reported H264 profile
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Beckett <bob.beckett@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org
Date:   Fri, 17 Jul 2020 10:14:30 +0200
In-Reply-To: <20200717034923.219524-1-ezequiel@collabora.com>
References: <20200717034923.219524-1-ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-07-17 at 00:49 -0300, Ezequiel Garcia wrote:
> From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> 
> The CODA960 manual states that ASO/FMO features of baseline are not
> supported, so for this reason this driver should only report
> constrained baseline support.

I know the encoder doesn't support this, but is this also true of the
decoder? The i.MX6DQ Reference Manual explicitly lists H.264/AVC decoder
support for both baseline profile and constrained base line profile.

> This fixes negotiation issue with constrained baseline content
> on GStreamer 1.17.1.
> 
> Cc: stable@vger.kernel.org
> Fixes: 42a68012e67c2 ("media: coda: add read-only h.264 decoder profile/level controls")
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/platform/coda/coda-common.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 3ab3d976d8ca..c641d1608825 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -2335,8 +2335,8 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
>  		V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET, -12, 12, 1, 0);
>  	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
>  		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> -		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE, 0x0,
> -		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE);
> +		V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE, 0x0,
> +		V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE);

Encoder support is listed as baseline, not constrained baseline, in the
manual, but the SPS NALs produced by the encoder start with:
  00 00 00 01 67 42 40
                    ^
so that is profile_idc=66, constraint_set1_flag==1, constrained baseline
indeed. I think this change is correct.

>  	if (ctx->dev->devtype->product == CODA_HX4 ||
>  	    ctx->dev->devtype->product == CODA_7541) {
>  		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
> @@ -2417,7 +2417,7 @@ static void coda_decode_ctrls(struct coda_ctx *ctx)
>  	ctx->h264_profile_ctrl = v4l2_ctrl_new_std_menu(&ctx->ctrls,
>  		&coda_ctrl_ops, V4L2_CID_MPEG_VIDEO_H264_PROFILE,
>  		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
> -		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
> +		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE) |
>  		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
>  		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_HIGH)),
>  		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH);

I'm not sure about this one.

regards
Philipp
