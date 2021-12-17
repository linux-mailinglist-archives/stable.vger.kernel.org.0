Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9C0479593
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 21:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbhLQUmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 15:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhLQUmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 15:42:15 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFEFC061574;
        Fri, 17 Dec 2021 12:42:14 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id d2so3351441qki.12;
        Fri, 17 Dec 2021 12:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=jJPFhgIsvKzJn7UezO2bKrdTlyTH555tbP3K3YvX9GE=;
        b=JuQ/zWsn8JI4BkEcnxXppvSHavTvBWZxUAvS+FCWeXmm34+KaZY1SAdmvIFl2FmtiB
         rdIybrj64k+eGnbkM3Q2VRygmkj0U3zAoEdJa2jY5hAYmIf9CgpdZbtouUEf1g7xK+s2
         eFsgSmy3PkDh5wCjmxdgeu90GQ+ZSWwdsskUk6w1qi66Vr3s9INqn1cN5uXLZKs/zbnf
         SAKb376W0Gtb2t/P4e2vQNp02jniuXO8uVq31yAlh0aL/kHNRpoC0oxl8umeNW9EwemH
         NJic5Y9QARCciXI/8z5S7ZRzRHM6X5x+3oeCeVmWBnL9Thi1J9D1Zigd1fnHN1x7PKt3
         TkUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :reply-to:references:mime-version:content-disposition:in-reply-to;
        bh=jJPFhgIsvKzJn7UezO2bKrdTlyTH555tbP3K3YvX9GE=;
        b=c2e8vsV6YFxqmeIuU+I//tUAhhyVkRQjnGt8qdRs+xN+DyLPBooHT2pnuAArZcSIwP
         QGs/kIT3pLNl7dM6drYyjqVfhSyc62fGZqctuP+Wqtrq276IMhix7xDZhFIEcRzHxc6q
         F8S9PWMC/A7S05NVWBtZOwB9OrBBWKrM7PHvmfPTnZ9WQFSYG8w88IVptyQghLgMEvaJ
         3kAT/QdMKpMrU/PtfvynouiN9NdDpH1rO9D9X9UxzG9eOwa1noCEnuJi+8/UxkA3T6Yp
         AuWV8H0cmbRNK97HomAcwltv003uvXvsMUx1Afoy8mtfK8NIay93axf2KShXVrTQZ4kk
         AiOw==
X-Gm-Message-State: AOAM530PB9vGipaKAkxKC7fwEXrVi+ng2ZSlWRW0OzLIF9BD2tYmyRoX
        0L0lFg/SzfoXoeRqKc1bhWAzLt1YYg==
X-Google-Smtp-Source: ABdhPJy8y0iM3Dge4lk7oYr/9Zcp7gvHlcJBP5wa9uZNFnBKBidFpbOUWDt0GTq/RyOhD5PovJ4RUA==
X-Received: by 2002:a05:620a:4244:: with SMTP id w4mr3100606qko.215.1639773733766;
        Fri, 17 Dec 2021 12:42:13 -0800 (PST)
Received: from serve.minyard.net ([47.184.156.158])
        by smtp.gmail.com with ESMTPSA id bs16sm5474114qkb.45.2021.12.17.12.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 12:42:13 -0800 (PST)
Sender: Corey Minyard <tcminyard@gmail.com>
Received: from minyard.net (unknown [IPv6:2001:470:b8f6:1b:253a:bfb0:ae5b:40ba])
        by serve.minyard.net (Postfix) with ESMTPSA id 6571E181061;
        Fri, 17 Dec 2021 20:42:12 +0000 (UTC)
Date:   Fri, 17 Dec 2021 14:42:11 -0600
From:   Corey Minyard <minyard@acm.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     openipmi-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        ioanna-maria.alifieraki@canonical.com, minyard@mvista.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ipmi: fix initialization when workqueue allocation
 fails
Message-ID: <20211217204211.GM14936@minyard.net>
Reply-To: minyard@acm.org
References: <20211217154410.1228673-1-cascardo@canonical.com>
 <20211217154410.1228673-2-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217154410.1228673-2-cascardo@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for this, I need to be more careful about looking at code and not
just looking at patches.  Both in my queue, I'll try to get them in to
5.16.

-corey

On Fri, Dec 17, 2021 at 12:44:10PM -0300, Thadeu Lima de Souza Cascardo wrote:
> If the workqueue allocation fails, the driver is marked as not initialized,
> and timer and panic_notifier will be left registered.
> 
> Instead of removing those when workqueue allocation fails, do the workqueue
> initialization before doing it, and cleanup srcu_struct if it fails.
> 
> Fixes: 1d49eb91e86e ("ipmi: Move remove_work to dedicated workqueue")
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Cc: Corey Minyard <cminyard@mvista.com>
> Cc: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/char/ipmi/ipmi_msghandler.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
> index 84975b21fff2..266c7bc58dda 100644
> --- a/drivers/char/ipmi/ipmi_msghandler.c
> +++ b/drivers/char/ipmi/ipmi_msghandler.c
> @@ -5396,20 +5396,23 @@ static int ipmi_init_msghandler(void)
>  	if (rv)
>  		goto out;
>  
> -	timer_setup(&ipmi_timer, ipmi_timeout, 0);
> -	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
> -
> -	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
> -
>  	remove_work_wq = create_singlethread_workqueue("ipmi-msghandler-remove-wq");
>  	if (!remove_work_wq) {
>  		pr_err("unable to create ipmi-msghandler-remove-wq workqueue");
>  		rv = -ENOMEM;
> -		goto out;
> +		goto out_wq;
>  	}
>  
> +	timer_setup(&ipmi_timer, ipmi_timeout, 0);
> +	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
> +
> +	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
> +
>  	initialized = true;
>  
> +out_wq:
> +	if (rv)
> +		cleanup_srcu_struct(&ipmi_interfaces_srcu);
>  out:
>  	mutex_unlock(&ipmi_interfaces_mutex);
>  	return rv;
> -- 
> 2.32.0
> 
