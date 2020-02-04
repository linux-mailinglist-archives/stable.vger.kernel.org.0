Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB5C1516F7
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 09:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgBDIYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 03:24:35 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36356 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgBDIYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 03:24:35 -0500
Received: by mail-lf1-f66.google.com with SMTP id f24so11581238lfh.3;
        Tue, 04 Feb 2020 00:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E6T1KOOke4/c747RNor42t/cZnyazvkZ3EY6Urb5I3I=;
        b=mSRQsscU0xBPZIchK/X3YiAiekPaUYkwqordB7xA6oZRZ8DBnROSyLG5lWtylPidaw
         5OUigektmD9fRVUwxSyPu3tXz1BMJMPwUTLJ699P15Y9ATPj8HJAyhMJMWwvovevLgqb
         Gp0lkCYXnOGhryLX61rfQP4uRaBzPCZIA2Y7lFwsD2A/y5Z9EOBpCZYzehx3FrC747k/
         98oVuTRBuIl8p+KWBvYZ+zN2gUGlJoJcePeClL+gw3TSCNS4FDU+qqBWDE1R2U/qbeh0
         soDlu/6xN79t2z7jRBK4jmlx6ffnJv3XV+qVZA3xZZC1hQIZw9FF05MexOVdVpw5WgXR
         0/kQ==
X-Gm-Message-State: APjAAAU855vUymFZxUeV2Mj9edcJP+/Svsnk+KLYPLkEfaMcveXUFTb7
        NvU2aP+oOYBHwfdWe0/xyIQ=
X-Google-Smtp-Source: APXvYqxlKfcco2CZ6OmZ++hYA9pV0igvVPF/VyC2dwjPLoS7uc3OKJzegAJFxxgfc6cWfFbmSfpIDA==
X-Received: by 2002:ac2:46dc:: with SMTP id p28mr14269160lfo.23.1580804672704;
        Tue, 04 Feb 2020 00:24:32 -0800 (PST)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id v7sm10192776lfa.10.2020.02.04.00.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 00:24:32 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iytVh-0008Ia-6v; Tue, 04 Feb 2020 09:24:41 +0100
Date:   Tue, 4 Feb 2020 09:24:41 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>, stable@vger.kernel.org
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Martin Kepplinger <martink@posteo.de>
Subject: Re: [PATCH 1/7] Input: pegasus_notetaker: fix endpoint sanity check
Message-ID: <20200204082441.GD26725@localhost>
References: <20191210113737.4016-1-johan@kernel.org>
 <20191210113737.4016-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210113737.4016-2-johan@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 12:37:31PM +0100, Johan Hovold wrote:
> The driver was checking the number of endpoints of the first alternate
> setting instead of the current one, something which could be used by a
> malicious device (or USB descriptor fuzzer) to trigger a NULL-pointer
> dereference.
> 
> Fixes: 1afca2b66aac ("Input: add Pegasus Notetaker tablet driver")
> Cc: stable <stable@vger.kernel.org>     # 4.8
> Cc: Martin Kepplinger <martink@posteo.de>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Looks like the stable tag was removed when this one was applied, and
similar for patches 2, 4 and 7 of this series (commits 3111491fca4f,
a8eeb74df5a6, 6b32391ed675 upstream).

While the last three are mostly an issue for the syzbot fuzzer, we have
started backporting those as well.

This one (bcfcb7f9b480) is more clear cut as it can be used to trigger a
NULL-deref.

I only noticed because Sasha picked up one of the other patches in the
series which was never intended for stable.

> ---
>  drivers/input/tablet/pegasus_notetaker.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/tablet/pegasus_notetaker.c b/drivers/input/tablet/pegasus_notetaker.c
> index a1f3a0cb197e..38f087404f7a 100644
> --- a/drivers/input/tablet/pegasus_notetaker.c
> +++ b/drivers/input/tablet/pegasus_notetaker.c
> @@ -275,7 +275,7 @@ static int pegasus_probe(struct usb_interface *intf,
>  		return -ENODEV;
>  
>  	/* Sanity check that the device has an endpoint */
> -	if (intf->altsetting[0].desc.bNumEndpoints < 1) {
> +	if (intf->cur_altsetting->desc.bNumEndpoints < 1) {
>  		dev_err(&intf->dev, "Invalid number of endpoints\n");
>  		return -EINVAL;
>  	}

Johan
