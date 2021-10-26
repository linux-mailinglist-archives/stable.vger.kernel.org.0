Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582DD43B094
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 12:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbhJZK5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 06:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbhJZK5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 06:57:33 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E96C061745;
        Tue, 26 Oct 2021 03:55:09 -0700 (PDT)
Received: from pendragon.ideasonboard.com (cpc89244-aztw30-2-0-cust3082.18-1.cable.virginm.net [86.31.172.11])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id AE56CDBF;
        Tue, 26 Oct 2021 12:55:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1635245707;
        bh=mGrpDB2zp/69hSCM3gtgWzVuOOkKWTDfKTiVZ0ETSBo=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=P3cJ91+j9kp5DxukjwWVNm07qSndbxmljvN1X6MFoG6binc3EnR4Z81+LvJgXlt3B
         0wn7SZORUCZg1b6DbvfSssxPaSCdrg9b1YRzJxfHhVxmBHVfE+7TRpksXAMM2C3qdw
         FD/9CQ1KDFGaMjKf4h95BbIGk1AHVK9S+nLDd33o=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211026095511.26673-1-johan@kernel.org>
References: <20211026095511.26673-1-johan@kernel.org>
Subject: Re: [PATCH] media: uvcvideo: fix division by zero at stream start
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
To:     Johan Hovold <johan@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Tue, 26 Oct 2021 11:55:05 +0100
Message-ID: <163524570516.1184428.14632987312253060787@Monstersaurus>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Johan Hovold (2021-10-26 10:55:11)
> Add the missing bulk-endpoint max-packet sanity check to probe() to
> avoid division by zero in uvc_alloc_urb_buffers() in case a malicious
> device has broken descriptors (or when doing descriptor fuzz testing).
>=20
> Note that USB core will reject URBs submitted for endpoints with zero
> wMaxPacketSize but that drivers doing packet-size calculations still
> need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
> endpoint descriptors with maxpacket=3D0")).
>=20
> Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
> Cc: stable@vger.kernel.org      # 2.6.26
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uv=
c_video.c
> index e16464606b14..85ac5c1081b6 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1958,6 +1958,10 @@ static int uvc_video_start_transfer(struct uvc_str=
eaming *stream,
>                 if (ep =3D=3D NULL)
>                         return -EIO;
> =20
> +               /* Reject broken descriptors. */
> +               if (usb_endpoint_maxp(&ep->desc) =3D=3D 0)
> +                       return -EIO;

Is there any value in identifying this with a specific return code like
-ENODATA?

But either way, this seems sane.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> +
>                 ret =3D uvc_init_video_bulk(stream, ep, gfp_flags);
>         }
> =20
> --=20
> 2.32.0
>
