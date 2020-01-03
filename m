Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B11812F970
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 16:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgACPCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 10:02:44 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39895 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACPCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 10:02:44 -0500
Received: by mail-lj1-f193.google.com with SMTP id l2so44145057lja.6;
        Fri, 03 Jan 2020 07:02:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jYP3oiguXTu4ukRMGsTE94fcOoRU1pxMAUcZzbqTsoQ=;
        b=kktXjEaeJoDj7MeJeceF+PZIAvZB1dFHWf2rIlpcI78QiDUIEXFx8aqrRtXrAcWClv
         rFKVKpb5IeEkBo4sjlZ6Yh971Qrxp1ffTFcvLaZsRY5+FTkxX3bqXWaQUxPvjGKyPHc/
         C5ir3vqVYaAdV+Q2C+xdKsh9ZsjuRtIJ3h6U1XPoaYjVSAsubhlyeSZA9I6gT63my9+O
         bQVqw67foi7WGZrwovnhuK7QW6m6q2NUAB18JWvvvapZMhh1/Zh82z9ethsHN3V8k/eV
         AJO/40nyT+zMsUUgXTZNVN4alPmqpgxlshU4y28PH0pID0iGr+0U5EIb/RL6r1UwZay9
         80Eg==
X-Gm-Message-State: APjAAAWzn3gWmRS1ySDtjsfw7AXqweyzbrbyGFjC3e197t1XEpYBsI7K
        gsAP0kBmjriebs/BKUw9pOtMf+ef
X-Google-Smtp-Source: APXvYqwKx1QwKtOPNraV0L9IHhbkT8H7iic6sFO29rqdvf4tU3k2+YpJg3mg8DbMbm7TyLBrosdkAg==
X-Received: by 2002:a05:651c:118b:: with SMTP id w11mr53364810ljo.54.1578063762042;
        Fri, 03 Jan 2020 07:02:42 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id t1sm24602951lji.98.2020.01.03.07.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 07:02:40 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1inOTK-0006si-Jb; Fri, 03 Jan 2020 16:02:42 +0100
Date:   Fri, 3 Jan 2020 16:02:42 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 106/434] media: flexcop-usb: fix NULL-ptr deref in
 flexcop_usb_transfer_init()
Message-ID: <20200103150242.GC17614@localhost>
References: <20191229172702.393141737@linuxfoundation.org>
 <20191229172708.658173957@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191229172708.658173957@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 06:22:39PM +0100, Greg Kroah-Hartman wrote:
> From: Yang Yingliang <yangyingliang@huawei.com>
> 
> [ Upstream commit 649cd16c438f51d4cd777e71ca1f47f6e0c5e65d ]
> 
> If usb_set_interface() failed, iface->cur_altsetting will
> not be assigned and it will be used in flexcop_usb_transfer_init()
> It may lead a NULL pointer dereference.
> 
> Check usb_set_interface() return value in flexcop_usb_init()
> and return failed to avoid using this NULL pointer.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Sean Young <sean@mess.org>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This commit is bogus and should be dropped from all stable queues.

Contrary to what the commit message claims, iface->cur_altsetting will
never be NULL so there's no risk for a NULL-pointer dereference here.

Even though the change itself is benign, we shouldn't spread this
confusion further.

> ---
>  drivers/media/usb/b2c2/flexcop-usb.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
> index 1a801dc286f8..d1331f828108 100644
> --- a/drivers/media/usb/b2c2/flexcop-usb.c
> +++ b/drivers/media/usb/b2c2/flexcop-usb.c
> @@ -504,7 +504,13 @@ urb_error:
>  static int flexcop_usb_init(struct flexcop_usb *fc_usb)
>  {
>  	/* use the alternate setting with the larges buffer */
> -	usb_set_interface(fc_usb->udev,0,1);
> +	int ret = usb_set_interface(fc_usb->udev, 0, 1);
> +
> +	if (ret) {
> +		err("set interface failed.");
> +		return ret;
> +	}
> +
>  	switch (fc_usb->udev->speed) {
>  	case USB_SPEED_LOW:
>  		err("cannot handle USB speed because it is too slow.");

Johan
