Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7737417B00E
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 21:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgCEUxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 15:53:55 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45328 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCEUxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 15:53:54 -0500
Received: by mail-lj1-f195.google.com with SMTP id e18so7669130ljn.12;
        Thu, 05 Mar 2020 12:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jsxIAzZIbIFv3uNTJFU3lcngwYDPsPRNKGtmkKUO3Cg=;
        b=N2YKdNLdsYNGU0pMkPqNWkrzrQ7rA8ArkWU28KAW1GJNOsFaaZnU9zr78xkM5Pk28C
         O7xcfSxXS0o3muFr70fO2AAGbsKXntvFXlPs7vLuuzSd/9zhg0I9dlJWCYoGEIFCycar
         eupNpeihrl+44a8IEq/pxPQ9SsN5nLBV78A9GpC6T+9BoO/xfcsYslPckx1cxvyV2jRD
         Jn6xPHzfkpfyk2/ZIkCmRKQ1aXPEFhR3WWMwv64G2pZTgXWKmpY8QkqhP/i8bUVrG+ig
         AXlX1Jr4mA8LTOqIj6rmCFp03i4W/QD65GKeJwZE1a6AkwTDpCwdZKUJAtdBPjQBOjzg
         hodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jsxIAzZIbIFv3uNTJFU3lcngwYDPsPRNKGtmkKUO3Cg=;
        b=aN8W9C93+mm4sdN1QL5SsDfYcZYRNtQprvFvYMr1cgV6GSldDo1TXjSgkHM3/S0K4P
         /EB9AQ3H68PLd0C+xOvdhEaDzYUno8Av6D7KBrbePgNbI/Y7FAC/qR+rcZT4Xy2TIxxT
         The2NwLTP8Y9rKuKvAaaILMDsrWuVRr/60mwSbDAfIZC5+mCzuH1XyIFRZSoZ18Mbc8S
         mZpBo8BUiPAfROAchp45nXokooLL3RHEmCGzst9RkDTHLtBkJ0LNIAdAuCyzTuBrylDC
         OgmQQQtGk7WfBZSBPTjqhFhasJcbJFUwSH6Zlb+mnFjmzijRKT8K07MnzZGOshZIZUUE
         Wtrg==
X-Gm-Message-State: ANhLgQ3ylejy6BsSUiruMi/Wa6j5vD0Pxn8yzNYpZkw6NL94/KQ+ommj
        6z/3cJsmbgIqSgc81QdxXw0dNWGr
X-Google-Smtp-Source: ADFU+vv1K3DXVCSeAmqdxWT/2ITPn2efSMY13BfOd/2ZeF7Y93TFh37nJKZLZnx/trr5xFNikksD2A==
X-Received: by 2002:a2e:9c8b:: with SMTP id x11mr19423lji.225.1583441632353;
        Thu, 05 Mar 2020 12:53:52 -0800 (PST)
Received: from [192.168.2.145] (94-29-39-224.dynamic.spd-mgts.ru. [94.29.39.224])
        by smtp.googlemail.com with ESMTPSA id t1sm16332217lji.98.2020.03.05.12.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 12:53:51 -0800 (PST)
Subject: Re: [PATCH 1/1] usb: chipidea: udc: fix sleeping function called from
 invalid context
To:     Peter Chen <peter.chen@kernel.org>, linux-usb@vger.kernel.org
Cc:     linux-imx@nxp.com, jun.li@nxp.com, Peter Chen <peter.chen@nxp.com>,
        stable@vger.kernel.org
References: <20200305015502.28927-1-peter.chen@kernel.org>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <813231d7-ecca-9147-6eb3-2fb93a552e85@gmail.com>
Date:   Thu, 5 Mar 2020 23:53:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200305015502.28927-1-peter.chen@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

05.03.2020 04:55, Peter Chen пишет:
> From: Peter Chen <peter.chen@nxp.com>
> 
> The code calls pm_runtime_get_sync with irq disabled, it causes below
> warning:
> 
> BUG: sleeping function called from invalid context at
> wer/runtime.c:1075
> in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid:
> er/u8:1
> CPU: 1 PID: 37 Comm: kworker/u8:1 Not tainted
> 20200304-00181-gbebfd2a5be98 #1588
> Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
> Workqueue: ci_otg ci_otg_work
> [<c010e8bd>] (unwind_backtrace) from [<c010a315>]
> 1/0x14)
> [<c010a315>] (show_stack) from [<c0987d29>]
> 5/0x94)
> [<c0987d29>] (dump_stack) from [<c013e77f>]
> +0xeb/0x118)
> [<c013e77f>] (___might_sleep) from [<c052fa1d>]
> esume+0x75/0x78)
> [<c052fa1d>] (__pm_runtime_resume) from [<c0627a33>]
> 0x23/0x74)
> [<c0627a33>] (ci_udc_pullup) from [<c062fb93>]
> nect+0x2b/0xcc)
> [<c062fb93>] (usb_gadget_connect) from [<c062769d>]
> _connect+0x59/0x104)
> [<c062769d>] (ci_hdrc_gadget_connect) from [<c062778b>]
> ssion+0x43/0x48)
> [<c062778b>] (ci_udc_vbus_session) from [<c062f997>]
> s_connect+0x17/0x9c)
> [<c062f997>] (usb_gadget_vbus_connect) from [<c062634d>]
> bd/0x128)
> [<c062634d>] (ci_otg_work) from [<c0134719>]
> rk+0x149/0x404)
> [<c0134719>] (process_one_work) from [<c0134acb>]
> 0xf7/0x3bc)
> [<c0134acb>] (worker_thread) from [<c0139433>]
> x118)
> [<c0139433>] (kthread) from [<c01010bd>]
> (ret_from_fork+0x11/0x34)
> 
> Cc: <stable@vger.kernel.org> #v5.5
> Fixes: 72dc8df7920f ("usb: chipidea: udc: protect usb interrupt enable")
> Reported-by: Dmitry Osipenko <digetx@gmail.com>
> Signed-off-by: Peter Chen <peter.chen@nxp.com>
> ---
>  drivers/usb/chipidea/udc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
> index 94feaecc6059..9d74fe856ce8 100644
> --- a/drivers/usb/chipidea/udc.c
> +++ b/drivers/usb/chipidea/udc.c
> @@ -1601,9 +1601,11 @@ static void ci_hdrc_gadget_connect(struct usb_gadget *_gadget, int is_active)
>  		if (ci->driver) {
>  			hw_device_state(ci, ci->ep0out->qh.dma);
>  			usb_gadget_set_state(_gadget, USB_STATE_POWERED);
> +			spin_unlock_irqrestore(&ci->lock, flags);
>  			usb_udc_vbus_handler(_gadget, true);
> +		} else {
> +			spin_unlock_irqrestore(&ci->lock, flags);
>  		}
> -		spin_unlock_irqrestore(&ci->lock, flags);
>  	} else {
>  		usb_udc_vbus_handler(_gadget, false);
>  		if (ci->driver)
> 

Thank you very much!

Tested-by: Dmitry Osipenko <digetx@gmail.com>
