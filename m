Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D226E395
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 11:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbfGSJkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 05:40:00 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42219 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfGSJkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 05:40:00 -0400
Received: by mail-lf1-f65.google.com with SMTP id s19so21300083lfb.9;
        Fri, 19 Jul 2019 02:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=13znN2U9lFkjuUG2STCneO0Lwcmzsb8fok8rloSkCx4=;
        b=GCbhMA+nAtQnY70owCpjPyatOcsQag96ewzbLAwe660KEVdKuVG/pBCnKB4n5/wBSZ
         ypV/+gIonJYIP9ht1GUQbryY07HGk0NbsJJ69BjUl+GIruA1xEHvi6/dTU8jvPsUlnLE
         OCr5kHTKUNb4qcLALOgwE2VO5Pc3rSOH94GX3tapUMAgAwgyXSupz7kI2be6VunbDWMo
         mfKR9BUEESTAqqcapBH2Vdm2eStu8qGaV3s66VVRs0bqoOElzQ5jwT1clI2NzifaM9Dp
         Rd9ATUvBpARoVS++fHQqAGkhhLTdsi6TsLdZWlUTRq3D7E1W9VQbRcS8yVie2/fyqbPV
         7nYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=13znN2U9lFkjuUG2STCneO0Lwcmzsb8fok8rloSkCx4=;
        b=e0oiexXCUtNc73/bqS2eqVk1m8KkM9kGADal8AYkkX3XT8sQ7+F8C+nLPgIqeKD6+u
         jlFY7ukXlQ5NqP/B7gqHokYSsAF0nsxktj+oidYLl1ZIWoKr1esTjv44G0PaNqpA9/RY
         vnnkNfOJysXuqEEeHUjqGgbth5/Lntl/Xa3EJ/X4h5lAoigGgsH5HWSuofo8ccNXrJSz
         kwmcZIrz7/0aGVALfYl/HV9oHBxfsKg+yY4Wt1s666tLxCEYK4wWHQbXjgwLCdyRI9nd
         ZTz0cV8yHhIADZLiNdNQ3ng/fr7BmszSn6rOnOAZZqZWBzyFj4ebOpUTxPlMsMYVqqFF
         nxuQ==
X-Gm-Message-State: APjAAAUPTpN7PAylD7RDElgomk8C7so8E9RNSkfSRNwfXUgFtQD6EKwI
        UC/FsSlYBtIKRgu0a7dI0wg=
X-Google-Smtp-Source: APXvYqyHdRKy1zbhOt9jwP0CSgeD/W31nBQg4sLg4kjiYLlAHZ58/DRX2SekgtD5CbxbqGGIr+uf0A==
X-Received: by 2002:a19:6602:: with SMTP id a2mr22807973lfc.25.1563529197502;
        Fri, 19 Jul 2019 02:39:57 -0700 (PDT)
Received: from localhost ([188.170.223.67])
        by smtp.gmail.com with ESMTPSA id r17sm5601173ljc.85.2019.07.19.02.39.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jul 2019 02:39:56 -0700 (PDT)
Date:   Fri, 19 Jul 2019 12:39:53 +0300
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Hui Wang <hui.wang@canonical.com>
Cc:     linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Input: alps - Fix a mismatch between a condition check
 and its comment
Message-ID: <20190719093953.GA904@penguin>
References: <20190719090135.17811-1-hui.wang@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719090135.17811-1-hui.wang@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 05:01:35PM +0800, Hui Wang wrote:
> In the function alps_is_cs19_trackpoint(), we check if the param[1] is
> in the 0x20~0x2f range, but the code we wrote for this checking is not
> correct:
> (param[1] & 0x20) does not mean param[1] is in the range of 0x20~0x2f,
> it also means the param[1] is in the range of 0x30~0x3f, 0x60~0x6f...
> 
> Now fix it with a new condition checking ((param[1] & 0xf0) == 0x20).
> 
> Fixes: 7e4935ccc323 ("Input: alps - don't handle ALPS cs19 trackpoint-only device")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Wang <hui.wang@canonical.com>

Applied, thank you.

> ---
>  drivers/input/mouse/alps.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> index 62ffea00902a..34700eda0429 100644
> --- a/drivers/input/mouse/alps.c
> +++ b/drivers/input/mouse/alps.c
> @@ -2876,7 +2876,7 @@ static bool alps_is_cs19_trackpoint(struct psmouse *psmouse)
>  	 * trackpoint-only devices have their variant_ids equal
>  	 * TP_VARIANT_ALPS and their firmware_ids are in 0x20~0x2f range.
>  	 */
> -	return param[0] == TP_VARIANT_ALPS && (param[1] & 0x20);
> +	return param[0] == TP_VARIANT_ALPS && ((param[1] & 0xf0) == 0x20);
>  }
>  
>  static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)
> -- 
> 2.17.1
> 

-- 
Dmitry
