Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFE745F595
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 21:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237257AbhKZUDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 15:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbhKZUBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 15:01:50 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A075DC061396;
        Fri, 26 Nov 2021 11:43:45 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id e11so20592649ljo.13;
        Fri, 26 Nov 2021 11:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nQPpnZfbRUbuXuOwLW/n2B3yCkU4irvEjLPosYUfYAA=;
        b=nzrCYv6lykwqtrBXVd2Ar3Zv3iwMoJW5RoOvW9ZhQV67IydETSTc08RqGivCArzAZh
         d/vIijIwoT4XESeznt9VhYL+0l1aCHZ493cWXmM40FtsZo4Lwx4/DB8urH9FotY/6L6t
         iutRBklfKRD7QxA7b3pm9g3Mga9TGTmMDgnc8pKfnirHuZhiWpcEqmAk/iBsaZUONiAu
         AD3RxpxSp8ifZU2AimY6CUvEo7s0EJiwya9ouG7j47VGGjjZF3NYLYN7AR4mX875fsw3
         f23ohF5H6X0B8JfwDsk6QtZUv41JUlIWCpACU1PBW0srg/tf1ZGcpnK3bYNKIN+To+Xc
         Q12A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nQPpnZfbRUbuXuOwLW/n2B3yCkU4irvEjLPosYUfYAA=;
        b=NR0HZjX9epJFWzBXztV6+wvvF6DHCTfCmfMF0UngwjfLuWNqk1AfBxn3LRjhKsyzji
         6ojLg8TNiHKmPYpBXA57/7Cultbb15WS7F8W+3Y7sqSADK7FijxUV2uXF/CIZsufaTNF
         ZyGJjVULf19fjy1RFcDPrHdVQt8wWN757T9HM1SHlDs028vIQSOkgdS9Jd4lXFFlAl72
         Ag4ry25Ukpedfu9R3KnbvQVJyX7OeFIgU1d2GBjv+b92LsZIe1Y+AwVkrx20LjcdGIRV
         no1plOo11PSvlyXY7AaZS3nbO3UngdIzT4QLO1TlUDwM5M+kJG/NaCHOgWlIKCB+XAUp
         GP/A==
X-Gm-Message-State: AOAM533xQN1P190duDuRg9iSPe9ABSj4mzaxGQDLWSOAYnzk3cJVmMXU
        Sf0GF67SW1dnT69R3MJD6nY=
X-Google-Smtp-Source: ABdhPJzizYMSrgLgpnrhnG8Vbw4+FR+VlkOOpCkav2wnrfCEuYoBxFQFW39RYwDGE3D/vd2U5GnLdA==
X-Received: by 2002:a2e:a305:: with SMTP id l5mr33119964lje.73.1637955823975;
        Fri, 26 Nov 2021 11:43:43 -0800 (PST)
Received: from [192.168.1.103] ([178.176.72.184])
        by smtp.gmail.com with ESMTPSA id m28sm572111lfq.189.2021.11.26.11.43.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 11:43:43 -0800 (PST)
Subject: Re: [PATCH -next V5 1/2] sata_fsl: fix UAF in sata_fsl_port_stop when
 rmmod sata_fsl
To:     Baokun Li <libaokun1@huawei.com>, damien.lemoal@opensource.wdc.com,
        axboe@kernel.dk, tj@kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yebin10@huawei.com, yukuai3@huawei.com, stable@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
References: <20211126020307.2168767-1-libaokun1@huawei.com>
 <20211126020307.2168767-2-libaokun1@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <f8acc1f0-62d1-3c80-840f-1e38e21ad3c9@gmail.com>
Date:   Fri, 26 Nov 2021 22:43:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211126020307.2168767-2-libaokun1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/26/21 5:03 AM, Baokun Li wrote:

> When the `rmmod sata_fsl.ko` command is executed in the PPC64 GNU/Linux,
> a bug is reported:
>  ==================================================================
>  BUG: Unable to handle kernel data access on read at 0x80000800805b502c
>  Oops: Kernel access of bad area, sig: 11 [#1]
>  NIP [c0000000000388a4] .ioread32+0x4/0x20
>  LR [80000000000c6034] .sata_fsl_port_stop+0x44/0xe0 [sata_fsl]
>  Call Trace:
>   .free_irq+0x1c/0x4e0 (unreliable)
>   .ata_host_stop+0x74/0xd0 [libata]
>   .release_nodes+0x330/0x3f0
>   .device_release_driver_internal+0x178/0x2c0
>   .driver_detach+0x64/0xd0
>   .bus_remove_driver+0x70/0xf0
>   .driver_unregister+0x38/0x80
>   .platform_driver_unregister+0x14/0x30
>   .fsl_sata_driver_exit+0x18/0xa20 [sata_fsl]
>   .__se_sys_delete_module+0x1ec/0x2d0
>   .system_call_exception+0xfc/0x1f0
>   system_call_common+0xf8/0x200
>  ==================================================================
> 
> The triggering of the BUG is shown in the following stack:
> 
> driver_detach
>   device_release_driver_internal
>     __device_release_driver
>       drv->remove(dev) --> platform_drv_remove/platform_remove
>         drv->remove(dev) --> sata_fsl_remove
>           iounmap(host_priv->hcr_base);			<---- unmap
>           kfree(host_priv);                             <---- free
>       devres_release_all
>         release_nodes
>           dr->node.release(dev, dr->data) --> ata_host_stop
>             ap->ops->port_stop(ap) --> sata_fsl_port_stop
>                 ioread32(hcr_base + HCONTROL)           <---- UAF
>             host->ops->host_stop(host)
> 
> The iounmap(host_priv->hcr_base) and kfree(host_priv) functions should
> not be executed in drv->remove. These functions should be executed in
> host_stop after port_stop. Therefore, we move these functions to the
> new function sata_fsl_host_stop and bind the new function to host_stop.
> 
> Fixes: faf0b2e5afe7 ("drivers/ata: add support to Freescale 3.0Gbps SATA Controller")
> Cc: stable@vger.kernel.org
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

MBR, Sergei
