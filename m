Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEB5224000
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 17:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgGQP5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 11:57:19 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58842 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgGQP5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 11:57:19 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: nicolas)
        with ESMTPSA id 4432C2A03FC
Message-ID: <17189cd91b7412fdd102c2710d9e6aa8778aac23.camel@collabora.com>
Subject: Re: [PATCH 1/2] media: coda: Fix reported H264 profile
From:   Nicolas Dufresne <nicolas.dufresne@collabora.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Beckett <bob.beckett@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org
Date:   Fri, 17 Jul 2020 11:56:57 -0400
In-Reply-To: <51175cb496644aaa5d5004630925ead4c6f0ddc7.camel@pengutronix.de>
References: <20200717034923.219524-1-ezequiel@collabora.com>
         <51175cb496644aaa5d5004630925ead4c6f0ddc7.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le vendredi 17 juillet 2020 à 10:14 +0200, Philipp Zabel a écrit :
> On Fri, 2020-07-17 at 00:49 -0300, Ezequiel Garcia wrote:
> > From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > 
> > The CODA960 manual states that ASO/FMO features of baseline are not
> > supported, so for this reason this driver should only report
> > constrained baseline support.
> 
> I know the encoder doesn't support this, but is this also true of the
> decoder? The i.MX6DQ Reference Manual explicitly lists H.264/AVC decoder
> support for both baseline profile and constrained base line profile.

Hmm, double checking, you are right this is documented in the encoding tools
sections, not the decoding. But there is extra buffers that need to be passed
for ASO/FMO to work, I greatly doubt you have ever tested it. This is not
supported by GStreamer parser, or FFMPEG parsers either. Again, we need to make
sure in V2 that encoding and decoding capabilities are well seperated.

As for advertising ASO/FMO, I can leave it there, but be aware I won't be
testing it. I can provide you links to streams if you care (they are publicly
accessible throught the ITU conformance streams published by the ITU). But as
for GStreamer and FFMPEG, this is not supported anyway.

> 
> > This fixes negotiation issue with constrained baseline content
> > on GStreamer 1.17.1.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 42a68012e67c2 ("media: coda: add read-only h.264 decoder
> > profile/level controls")
> > Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  drivers/media/platform/coda/coda-common.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/platform/coda/coda-common.c
> > b/drivers/media/platform/coda/coda-common.c
> > index 3ab3d976d8ca..c641d1608825 100644
> > --- a/drivers/media/platform/coda/coda-common.c
> > +++ b/drivers/media/platform/coda/coda-common.c
> > @@ -2335,8 +2335,8 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
> >  		V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET, -12, 12, 1, 0);
> >  	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
> >  		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> > -		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE, 0x0,
> > -		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE);
> > +		V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE, 0x0,
> > +		V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE);
> 
> Encoder support is listed as baseline, not constrained baseline, in the
> manual, but the SPS NALs produced by the encoder start with:
>   00 00 00 01 67 42 40
>                     ^
> so that is profile_idc=66, constraint_set1_flag==1, constrained baseline
> indeed. I think this change is correct.
> 
> >  	if (ctx->dev->devtype->product == CODA_HX4 ||
> >  	    ctx->dev->devtype->product == CODA_7541) {
> >  		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
> > @@ -2417,7 +2417,7 @@ static void coda_decode_ctrls(struct coda_ctx *ctx)
> >  	ctx->h264_profile_ctrl = v4l2_ctrl_new_std_menu(&ctx->ctrls,
> >  		&coda_ctrl_ops, V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> >  		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
> > -		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
> > +		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE) |
> >  		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
> >  		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_HIGH)),
> >  		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH);
> 
> I'm not sure about this one.
> 
> regards
> Philipp

