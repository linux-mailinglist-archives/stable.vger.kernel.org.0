Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15901151717
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 09:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgBDId1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 03:33:27 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42600 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbgBDId1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 03:33:27 -0500
Received: by mail-lf1-f68.google.com with SMTP id y19so11580138lfl.9;
        Tue, 04 Feb 2020 00:33:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8DO+mGDd2sVt5YxyY/YYwABJQxNuUfjHg9DqBr31WD8=;
        b=AMnFVGS082Xu+jVLWsHqPqikDHmHistgBgpdTCznf5utbvfRylK9yBsASQWY55ePLo
         XHQivgXEa7gOoIIZaHKgc0e3xg5X00VZE+MCbslLE4do8mo9ZTthtXD9UuWLyvJwW66B
         3DKm+ES8nUw5npsoaVCm8VjN62ONcP96ic101e9eCHCv9R/kd6yW2SCB9tJSz5kE9LBZ
         oxhhfN4xxVER/EgAN8VxsIMy7MzkxxOJFK0Vts1Hm0AT1JdY+jIwphpekEb0ZxJ/YCoT
         8W4xwHQhvPn+WbCXn705hcObAMEyJcZH9CtPwqeDH6MwK/rS97UMurE7w4SixrlqQWQC
         oCgQ==
X-Gm-Message-State: APjAAAXddzLUUSJOTE+cFqbU4X1P69WvpBAEsoHnm4+vClSVp1cslk4b
        WwhrvGuwgQ0KmQaO0G6AmL4=
X-Google-Smtp-Source: APXvYqx57PfajZ51uAxyTh/39jBSBUfBp4nFXJXPoPpIVX52VhlNHoSlhGlqc/gieGZyJIoFj862xA==
X-Received: by 2002:ac2:555c:: with SMTP id l28mr14264850lfk.52.1580805203770;
        Tue, 04 Feb 2020 00:33:23 -0800 (PST)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id h9sm6045753ljg.3.2020.02.04.00.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 00:33:23 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iyteG-0008Mm-B8; Tue, 04 Feb 2020 09:33:32 +0100
Date:   Tue, 4 Feb 2020 09:33:32 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Denis Efremov <efremov@linux.com>
Subject: Re: [PATCH 5.4 117/203] rsi: fix potential null dereference in
 rsi_probe()
Message-ID: <20200204083332.GE26725@localhost>
References: <20200116231745.218684830@linuxfoundation.org>
 <20200116231755.604943633@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116231755.604943633@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 12:17:14AM +0100, Greg Kroah-Hartman wrote:
> From: Denis Efremov <efremov@linux.com>
> 
> commit f170d44bc4ec2feae5f6206980e7ae7fbf0432a0 upstream.
> 
> The id pointer can be NULL in rsi_probe(). It is checked everywhere except
> for the else branch in the idProduct condition. The patch adds NULL check
> before the id dereference in the rsi_dbg() call.
> 
> Fixes: 54fdb318c111 ("rsi: add new device model for 9116")
> Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> Cc: Siva Rebbagondla <siva8118@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Denis Efremov <efremov@linux.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This commit is bogus and was reverted shortly after it was applied in
order to prevent autosel from picking it up for stable (reverted by
c5dcf8f0e850 ("Revert "rsi: fix potential null dereference in
rsi_probe()"")).

The revert has now been picked up by Sasha, but shouldn't an
explicit revert in the same pull-request prevent a bad patch from being
backported in the first place? Seems like something that could be
scripted. But perhaps the net-stable oddities come into play here.

> ---
>  drivers/net/wireless/rsi/rsi_91x_usb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/net/wireless/rsi/rsi_91x_usb.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
> @@ -793,7 +793,7 @@ static int rsi_probe(struct usb_interfac
>  		adapter->device_model = RSI_DEV_9116;
>  	} else {
>  		rsi_dbg(ERR_ZONE, "%s: Unsupported RSI device id 0x%x\n",
> -			__func__, id->idProduct);
> +			__func__, id ? id->idProduct : 0x0);
>  		goto err1;
>  	}

Johan
