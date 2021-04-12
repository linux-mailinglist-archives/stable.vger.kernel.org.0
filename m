Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944F635D0C7
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 21:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237051AbhDLTHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 15:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236984AbhDLTHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 15:07:18 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A2EC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 12:06:58 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 125-20020a4a1a830000b02901b6a144a417so3266817oof.13
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 12:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=pSOvyVVxKo5u6FT1fZWcPtbfZHXNjEHAQr2oYKdfRC4=;
        b=uTt7HVXPZPq3b3yVZeTJqUGP/64R9dTif5nRx+pZhxCBTBZ6Y4yeTWdl9Z7Mq7+0WL
         TiVvE688stPixgcxagMki49F9tfOjJ4sWgYQdKoAeBDJNSMH80GUI2VgkuVOaXy1AVgs
         M69bbBGIFGCNKPOEMezuGyjmLZYyQi5+0xSAB3n8qf8WaW8PuHFbFoMzn+A458BpvlOT
         CJUkBoIb1EgNSy+O0bms2SgvVhiJNoifwxuyyUJHZdYOKywpGEmnumKdrlSVAT5Il25e
         wm48foyDSG5pc8D8rkVNb/cKFVnCmTkk07n6I6moLubU7kjReorGRGq/PTSdeNtoBfyI
         UMEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pSOvyVVxKo5u6FT1fZWcPtbfZHXNjEHAQr2oYKdfRC4=;
        b=AoOewaygkcuxUZNv662A45Waf11NKLhv5NdOiRG8U62+4W3h88jPYvUpspVNYtHg6W
         JYBR1r3J552p6QNcXO9PWQ/eGNp1bn63UXnmmJ100cD7c1aLzsaR7VY5Rdjex09vthnp
         bsdnWz7FlGpHm3lS7plJQbHRy7TIpvuigdv9tlgXiOn1rZ0fMUw4P8Qc6YUE4FnWX0Hj
         9QuRDofPVvpq+COLiMo+6yauXGpHJLQp/uOlMlSizlVjDrpMZ5cAWVvfu2e1CI3GEpzu
         SARijLgs4srwBPolhJN0da958pwjZPHlMwiot0kKc3W9IMwiWTAGl5X8nLYGsahpcD6S
         ssCA==
X-Gm-Message-State: AOAM533IriTvHar3aG3DfxdWAW/9ydGMI181YzgBY+vSSnX6ZPho3bg7
        SwZkbMUrlr/wH7uAmT9LJBY=
X-Google-Smtp-Source: ABdhPJxxKaK5y32B1U8kt2VRT52M8CkKOKS/uuceTFgVttY1G1jwbnfgQcl3HQGJv7y1/y928sCCbA==
X-Received: by 2002:a4a:e5ce:: with SMTP id r14mr8884349oov.37.1618254417584;
        Mon, 12 Apr 2021 12:06:57 -0700 (PDT)
Received: from ?IPv6:2603:80a0:e01:cc2f:be5f:f4ff:fe7b:62ec? (2603-80a0-0e01-cc2f-be5f-f4ff-fe7b-62ec.res6.spectrum.com. [2603:80a0:e01:cc2f:be5f:f4ff:fe7b:62ec])
        by smtp.gmail.com with ESMTPSA id q21sm757485oof.5.2021.04.12.12.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 12:06:56 -0700 (PDT)
Subject: Re: [PATCH] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
To:     stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Colin Ian King <colin.king@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>
References: <20210412185902.27755-1-tseewald@gmail.com>
From:   Tom Seewald <tseewald@gmail.com>
Message-ID: <4fc29f02-2284-70a2-2995-407f5c45b11f@gmail.com>
Date:   Mon, 12 Apr 2021 14:06:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210412185902.27755-1-tseewald@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/21 1:59 PM, Tom Seewald wrote:

> commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.
>
> Currently udc->ud.tcp_rx is being assigned twice, the second assignment
> is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.
>
> Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Cc: stable <stable@vger.kernel.org>
> Addresses-Coverity: ("Unused value")
> Link: https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Tom Seewald <tseewald@gmail.com>
> ---
>  drivers/usb/usbip/vudc_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
> index f44d98eeb36a..51cc5258b63e 100644
> --- a/drivers/usb/usbip/vudc_sysfs.c
> +++ b/drivers/usb/usbip/vudc_sysfs.c
> @@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct device *dev,
>  
>  		udc->ud.tcp_socket = socket;
>  		udc->ud.tcp_rx = tcp_rx;
> -		udc->ud.tcp_rx = tcp_tx;
> +		udc->ud.tcp_tx = tcp_tx;
>  		udc->ud.status = SDEV_ST_USED;
>  
>  		spin_unlock_irq(&udc->ud.lock);
I sent this because I believe this patch needs to be backported to the
4.9.y and 4.14.y stable trees.
