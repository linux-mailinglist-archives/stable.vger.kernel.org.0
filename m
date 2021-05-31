Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C93639568B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 09:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhEaH5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 03:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhEaH5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 03:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E41160FE3;
        Mon, 31 May 2021 07:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622447744;
        bh=0ZC9aSJd/5NSxSjCmt2ElwwzNfea3SyLmaaN0sdtbaw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SwrTWBapC8LTkHRLOHLM6zvqWwT8hwbcssM6KpafgaqeeMvFTGdq8w7QFBsOohxvl
         PRPPzrv/5+L3hm1sq6Jtz+FCvkhRjUEIDFuP+q5pUaJQEiARWG+up/v781ppvEWXkj
         IXoD5XiL6b7pTb91xw/YBzRgyUcrul4evF1PXnWOt7nth+gygVFdvpqZ8xQOiBZ/Nm
         E23+JYxdVIEMzd6mRDmN7QUz7UFcFSiFNXmVG02uRaa7ASekd4wR9Yvnd52AnvyQnu
         QswJjaPNHj4fWdc0xa0q6CeLoeetimeojfqdUeD+91DtEZgkmMwGNOPSLdQgRXx0Ly
         yAEg2ISzfSrRA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lnclv-0000aq-AX; Mon, 31 May 2021 09:55:39 +0200
Date:   Mon, 31 May 2021 09:55:39 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 3/3] media: rtl28xxu: fix zero-length control request
Message-ID: <YLSWeyy1skooTmqD@hovoldconsulting.com>
References: <20210524110920.24599-1-johan@kernel.org>
 <20210524110920.24599-4-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524110920.24599-4-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 01:09:20PM +0200, Johan Hovold wrote:
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
> ---
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
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

As reported here

	https://lore.kernel.org/r/YLSVsrhMZ2oOL1vM@hovoldconsulting.com

this patch is causing the chip type to no longer be detected correctly,
so please drop this one for now until this has been resolved.

Johan
