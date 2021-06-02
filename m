Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF23C398998
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 14:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhFBMeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 08:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhFBMeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 08:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E666F61396;
        Wed,  2 Jun 2021 12:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622637153;
        bh=3wHbSLDW1D6xmeYCO1AnnnFEs8YqNQFX8hYvGbsMbDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J06Ef+lAcMVXkb1+3avPznSKBIzFmpbza1QT4qEDFlSDMPz4+uNvowy/8q4fbAV51
         MB0NubAE1XFTqPZX/f3x8NWeWUIkw9zutJDREhFzKuc9ntOOqq5qw+Ror8JZDoDOzm
         XLLKfODD+YjCl685K+rq2LSuLOh7GO2k4cRsxKdM1m4Wjm+sr3V7D3Q7LFDCgngAai
         cQGbpV0aNxhqFqMepCm9Vlcoyg7xMymvyGICNn9YuAgUcn4yQvTY2Skw0O/rHZzvxq
         uS6DDKDcujEGEAADKmqi936ipGy+GtB8jQl8tNRp0JlPQi48YLc+86LTm+zfS50TUc
         zqZ9GrgPFJHqA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1loQ2w-0000Eq-T3; Wed, 02 Jun 2021 14:32:31 +0200
Date:   Wed, 2 Jun 2021 14:32:30 +0200
From:   Johan Hovold <johan@kernel.org>
To:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linuxtv-commits@linuxtv.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Antti Palosaari <crope@iki.fi>, stable@vger.kernel.org
Subject: Re: [git:media_stage/master] media: rtl28xxu: fix zero-length
 control request
Message-ID: <YLd6XvvogRcfSVqx@hovoldconsulting.com>
References: <E1loPrC-00GEsr-60@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1loPrC-00GEsr-60@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 02, 2021 at 12:15:42PM +0000, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued:
> 
> Subject: media: rtl28xxu: fix zero-length control request
> Author:  Johan Hovold <johan@kernel.org>
> Date:    Mon May 24 13:09:20 2021 +0200
> 
> The direction of the pipe argument must match the request-type direction
> bit or control requests may fail depending on the host-controller-driver
> implementation.
> 
> Control transfers without a data stage are treated as OUT requests by
> the USB stack and should be using usb_sndctrlpipe(). Failing to do so
> will now trigger a warning.
> 
> Fix the zero-length i2c-read request used for type detection by
> attempting to read a single byte instead.
> 
> Reported-by: syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com
> Fixes: d0f232e823af ("[media] rtl28xxu: add heuristic to detect chip type")
> Cc: stable@vger.kernel.org      # 4.0
> Cc: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

This one caused a regression and a v2 was submitted here:

	https://lore.kernel.org/r/20210531094434.12651-4-johan@kernel.org

Can you drop this one in favour of the v2?

>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> ---
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 97ed17a141bb..2c04ed8af0e4 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -612,8 +612,9 @@ static int rtl28xxu_read_config(struct dvb_usb_device *d)
>  static int rtl28xxu_identify_state(struct dvb_usb_device *d, const char **name)
>  {
>  	struct rtl28xxu_dev *dev = d_to_priv(d);
> +	u8 buf[1];
>  	int ret;
> -	struct rtl28xxu_req req_demod_i2c = {0x0020, CMD_I2C_DA_RD, 0, NULL};
> +	struct rtl28xxu_req req_demod_i2c = {0x0020, CMD_I2C_DA_RD, 1, buf};
>  
>  	dev_dbg(&d->intf->dev, "\n");
>  

Johan
