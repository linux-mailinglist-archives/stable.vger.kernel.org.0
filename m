Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDCD3CB3A0
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 09:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236984AbhGPH6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 03:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhGPH6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 03:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 113FE613D0;
        Fri, 16 Jul 2021 07:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626422113;
        bh=NyskiDTy4SkfS11AN+jSm67E0nVKaGjdDDkssGi0kRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mB70bavcw3i38LIAdo74ezd3NJMxkyHg48y05ue0rR2T4yQ1cgTKCP3Hr7OYwq2HT
         AT9JEhmBmupuhNy/uTGKwjCr8F/9XxzLgrop7qcmeaPsWQgEHiQ/1SyVnSfHnCQfPF
         iwDriM5XCPXEaKbitTt1gbW4ARBiDbFjOwLf//j4iQFkKtpqcwCeVkMZ53PnLOwfuo
         T0X8/j5/sFKrTKBL4sob5ktXJZvErjJJJY/MNGuG8GcqU1I2J53RHl1R3xaBBHzlon
         3xIGYlPouCr28+757v1vwQheFNFsiIWcEHuXWIZxKii+vSVZnO8rGB4Twp1PmmwvH8
         GMoszaqAOmrIw==
Received: from johan by xi with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m4IgL-0005tp-Kw; Fri, 16 Jul 2021 09:54:50 +0200
Date:   Fri, 16 Jul 2021 09:54:49 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com,
        Antti Palosaari <crope@iki.fi>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH 5.13 252/266] media: rtl28xxu: fix zero-length control
 request
Message-ID: <YPE7Se31LQnaikuy@hovoldconsulting.com>
References: <20210715182613.933608881@linuxfoundation.org>
 <20210715182652.248759867@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715182652.248759867@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 08:40:07PM +0200, Greg Kroah-Hartman wrote:
> From: Johan Hovold <johan@kernel.org>
> 
> commit 25d5ce3a606a1eb23a9265d615a92a876ff9cb5f upstream.
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
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Please drop this patch from all stable trees. 

This patch causes a regression and a second version was sent almost two
months ago, but I'm not getting any response whatsoever from the media
maintainers. 

I resent the correct fix and a revert of this one almost a month ago and
the cover letter includes some further details:

	https://lore.kernel.org/r/20210623084521.7105-1-johan@kernel.org

But this still hasn't been fixed in linux-next.

> ---
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -612,8 +612,9 @@ static int rtl28xxu_read_config(struct d
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
> 
> 

Johan
