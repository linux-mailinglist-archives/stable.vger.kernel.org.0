Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F1E4516B4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 22:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350892AbhKOVkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 16:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347690AbhKOVbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 16:31:40 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A7FC07978C;
        Mon, 15 Nov 2021 13:16:10 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso966742pjb.0;
        Mon, 15 Nov 2021 13:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A2H9eWpu5XFGIj2LpL3XWrpar0ldad6fVGKZSwsPS8U=;
        b=ecBgsbCyP4rLezyg8ifBkDr4A2MT3nuunKNaswUoz7NLtAASDeH+xP27ABxc0vYgOs
         9xVNW7taSVEq1LCJnqLIwl+Ume8HcL2CLv4LbI7OqUbYSGGPGWkYljQhR4im9BEf9Wdm
         +2vNgD87JkQ8ehimWBd+/Dljgv/LCKtaGWFLgzwuz7H5BVtXRBVeLSZSptytyYkbFdNf
         h9SuJI2Z7IIg9Dnmz3k+PhSPjCzEtcl1mLRizs+Xto6BONEQlBUDzV1yZC1hSM7EvKdU
         CMvtJcnGxIfbEkKyeTw48LN0HevtYdIu7lB9w6Z9cAqqMTHTpyMsbgCaLpMTcukXPFUc
         SLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A2H9eWpu5XFGIj2LpL3XWrpar0ldad6fVGKZSwsPS8U=;
        b=yAYfM7bAacu6PDJ9nX9TxBg8P6KqNX/hWLT7PG4hMFd4yY9Rto70HPEuQzmK5Z2eS4
         S9iCVuDtCHgpMXxjSAFjCCD05ZDWfSULwCD/yFTEZ08RJTNnqItBYnp6x3kNz6WFHRLx
         O3Zsa1ROuoO+GeH1l/onuYq1ilCNpayaNULAGmgrTMDscj15dzhUh9gE2pL+Zr+VzoHW
         N7uS73AJBds9s7vlaKNe8lqvphJbdetRhDhmW4h3Vt8ljuCS1PjzozlBbooeYsRjL59V
         3MT71sFoAOrLZ03YDLT54L/zMYkQig6xd4p3MaduFOaGZsUFZ3in+V9NnJ3UtJJs4xuB
         PZ6g==
X-Gm-Message-State: AOAM5319QjUlQtlQHPjEBFsARkGceFWba0DkCS2x87v0hZIiFFvDl+tg
        gcfw6Z5tBm8N1sRMJ6XCVYo=
X-Google-Smtp-Source: ABdhPJzCVvr66gTRauRC3FvA3vNC+EUo3/WhpTrRao7Y0rDoVxmWRgXrwi5qjC3Ea8dNyOsSg1r7cw==
X-Received: by 2002:a17:90b:33d0:: with SMTP id lk16mr2065531pjb.66.1637010969952;
        Mon, 15 Nov 2021 13:16:09 -0800 (PST)
Received: from localhost ([2409:10:24a0:4700:e8ad:216a:2a9d:6d0c])
        by smtp.gmail.com with ESMTPSA id u38sm17125234pfg.0.2021.11.15.13.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 13:16:09 -0800 (PST)
Date:   Tue, 16 Nov 2021 06:16:07 +0900
From:   Stafford Horne <shorne@gmail.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilia Sergachev <silia@ethz.ch>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Filip Kokosinski <fkokosinski@antmicro.com>
Subject: Re: [PATCH 3/3] serial: liteuart: fix minor-number leak on probe
 errors
Message-ID: <YZLOF2g8DBllJg2l@antec>
References: <20211115133745.11445-1-johan@kernel.org>
 <20211115133745.11445-4-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115133745.11445-4-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 02:37:45PM +0100, Johan Hovold wrote:
> Make sure to release the allocated minor number before returning on
> probe errors.
> 
> Fixes: 1da81e5562fa ("drivers/tty/serial: add LiteUART driver")
> Cc: stable@vger.kernel.org      # 5.11
> Cc: Filip Kokosinski <fkokosinski@antmicro.com>
> Cc: Mateusz Holenko <mholenko@antmicro.com>
> Cc: Stafford Horne <shorne@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Stafford Horne <shorne@gmail.com>

> ---
>  drivers/tty/serial/liteuart.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/liteuart.c b/drivers/tty/serial/liteuart.c
> index da792d0df790..2941659e5274 100644
> --- a/drivers/tty/serial/liteuart.c
> +++ b/drivers/tty/serial/liteuart.c
> @@ -270,8 +270,10 @@ static int liteuart_probe(struct platform_device *pdev)
>  
>  	/* get membase */
>  	port->membase = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
> -	if (IS_ERR(port->membase))
> -		return PTR_ERR(port->membase);
> +	if (IS_ERR(port->membase)) {
> +		ret = PTR_ERR(port->membase);
> +		goto err_erase_id;
> +	}
>  
>  	/* values not from device tree */
>  	port->dev = &pdev->dev;
> @@ -287,7 +289,16 @@ static int liteuart_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, port);
>  
> -	return uart_add_one_port(&liteuart_driver, &uart->port);
> +	ret = uart_add_one_port(&liteuart_driver, &uart->port);
> +	if (ret)
> +		goto err_erase_id;
> +
> +	return 0;
> +
> +err_erase_id:
> +	xa_erase(&liteuart_array, uart->id);
> +
> +	return ret;
>  }
>  
>  static int liteuart_remove(struct platform_device *pdev)
> -- 
> 2.32.0
> 
