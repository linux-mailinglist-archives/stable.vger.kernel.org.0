Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCE04516B3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 22:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346064AbhKOVkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 16:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350123AbhKOVaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 16:30:22 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B710C03401D;
        Mon, 15 Nov 2021 13:15:08 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id m24so5566807pls.10;
        Mon, 15 Nov 2021 13:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xvg46sJvn19n9tEricC/NpG5AqoxAA/4TRI4qGnUVi8=;
        b=W6ZNm/FA91vLxzlu6rYm80SOp1u48RrhiHYm5dB3RA1rvpzFsTCJDEeOgHcS2Abhgp
         fCubB5cT72aujJ/zwlGfuOfSkr8s2ombGO2PID7QLJFxaINDBekfhmUf1r7fw2KfbPzd
         JHRFMVrsD+/w/LQOtR5t1YYO6QU6shV4zXkzPEvkY8d8rDlKa5QSS9bWzFkKeexPIfTm
         b9sjyiT/+AQG+6t4HDHvzUe4AK5I9RPay6GZlymwiuFJlKvZdsJgPD4AqUfds8B71Uhh
         haLaDKF9IMzgW9gLTj6+mS9nK4VwSg9tcpsWa546R1k0JC7uC0YcKh1AhimUCYF87pTR
         AWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xvg46sJvn19n9tEricC/NpG5AqoxAA/4TRI4qGnUVi8=;
        b=fs2Jr6QUEeL272kTLh0PSytRhJM2uuN9uGP+vRTwyHZcBkq2uoctPwhE7gySVXj0ho
         qf1Wvjvah5vYuAGeupBhD2cwvH122KYg3ewz8uDR+U/LWoMtxFqwBZRKaFgl9DjKbTmL
         ESrGqVoZy7d7jFlf+H3yPERkJ/kCBXOzXsZLTpnqKM6r8gxIw+o7ZUuc8gHyIpoWcacn
         ZB3+Be8u3dHXVq4L4IbPBU31ZmTPSyLDOWQoHskMOHARc/Roe6sy0x4T9DfmVw3DFTsI
         Mt9qHSoEbS51fXop2diSGAhoQfDFyBX9Nl0SGy2BAyTLhYnabErfSDFtrmratcvd+19Q
         druw==
X-Gm-Message-State: AOAM531QKr8uEtXSeckNv1dOoCvE6UShGUBtpmmlgICx7KZQZuOGPsvv
        TmVXW/JtFBltzNctK/KPn/s=
X-Google-Smtp-Source: ABdhPJzZVkYMm9Oc3FfzK8/CwhITC9FiGrcRGNwlXlo+hxVselXOw4goITPmf2HjqhTNCWBtPEAKnw==
X-Received: by 2002:a17:90b:1c91:: with SMTP id oo17mr23728524pjb.193.1637010907713;
        Mon, 15 Nov 2021 13:15:07 -0800 (PST)
Received: from localhost ([2409:10:24a0:4700:e8ad:216a:2a9d:6d0c])
        by smtp.gmail.com with ESMTPSA id nn15sm234848pjb.11.2021.11.15.13.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 13:15:07 -0800 (PST)
Date:   Tue, 16 Nov 2021 06:15:05 +0900
From:   Stafford Horne <shorne@gmail.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilia Sergachev <silia@ethz.ch>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Filip Kokosinski <fkokosinski@antmicro.com>
Subject: Re: [PATCH 2/3] serial: liteuart: fix use-after-free and memleak on
 unbind
Message-ID: <YZLN2d4jB9AuN4BV@antec>
References: <20211115133745.11445-1-johan@kernel.org>
 <20211115133745.11445-3-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115133745.11445-3-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 02:37:44PM +0100, Johan Hovold wrote:
> Deregister the port when unbinding the driver to prevent it from being
> used after releasing the driver data and leaking memory allocated by
> serial core.

This looks good to me.  Just curious did you test this on a Litex SoC/FPGA?

> Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
> Cc: stable@vger.kernel.org      # 5.11
> Cc: Filip Kokosinski <fkokosinski@antmicro.com>
> Cc: Mateusz Holenko <mholenko@antmicro.com>
> Cc: Stafford Horne <shorne@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Stafford Horne <shorne@gmail.com>

> ---
>  drivers/tty/serial/liteuart.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/tty/serial/liteuart.c b/drivers/tty/serial/liteuart.c
> index f075f4ff5fcf..da792d0df790 100644
> --- a/drivers/tty/serial/liteuart.c
> +++ b/drivers/tty/serial/liteuart.c
> @@ -295,6 +295,7 @@ static int liteuart_remove(struct platform_device *pdev)
>  	struct uart_port *port = platform_get_drvdata(pdev);
>  	struct liteuart_port *uart = to_liteuart_port(port);
>  
> +	uart_remove_one_port(&liteuart_driver, port);
>  	xa_erase(&liteuart_array, uart->id);
>  
>  	return 0;
> -- 
> 2.32.0
> 
