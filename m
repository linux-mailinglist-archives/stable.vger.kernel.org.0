Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC516D3DF6
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 09:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjDCHRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 03:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjDCHRg (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 3 Apr 2023 03:17:36 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB8A769D;
        Mon,  3 Apr 2023 00:17:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id BA20D604F2;
        Mon,  3 Apr 2023 09:17:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1680506248; bh=L7SfYHB8iJJltASqIKVWzJ2Stt1m9QGN2wUwuHaZLFQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=c5ejcpUMXlYbgS/sLlwcHhCno06yeMflabALrg5mai4pMu//VPC8vQVptYGgzTHIF
         RSwVkGLhtYAGBVAII7gAnX/m1nYoZwNKCkZky2zwrhDUz1lWcr8T9Eh9TfLqgxmEaZ
         yJHIU3Jr2SYejjWRElnhI2e+Tfemd54Mbpsd+GeimkkAMQ8CCwuEEfWn9jtFTgZufW
         18tdnLr+ij0I+ffyHAJfE1q2r80c7FHX5u6mVPAlo2MaEJoNQW4dvOaSyDSq7RqUWJ
         dmjnNedyN3ULys5KlBDYWC3NstulQYsM6m3W53WCgXrGfLtvlbySLt7NXq8h2THnoV
         BYS4vRkn4Dz/g==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SBow1MjoW8Tg; Mon,  3 Apr 2023 09:17:26 +0200 (CEST)
Received: from [10.0.1.57] (grf-nat.grf.hr [161.53.83.23])
        by domac.alu.hr (Postfix) with ESMTPSA id B5D8B604F0;
        Mon,  3 Apr 2023 09:17:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1680506246; bh=L7SfYHB8iJJltASqIKVWzJ2Stt1m9QGN2wUwuHaZLFQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Gb84Oge+MVTcvDSIi8j1OmVuXU12LEaUxe1n7kPZFe65gicY7uzMDF+Gd97l6t+FV
         +bsBivmtjK6tEw4TGgngRl8gD+3x+HBKYxC7C7yMqyxi+V2lNRk/Otzdjgt4Naz+Ja
         M6+XLpxAiAl87ZO6qkp4T9/sXv9GpZ8plxEFKYG46un7sRzHo85w+yttgUAdhiJ/+6
         NRaCj8nARWdYN5JRhNZa7J2td1wAeWR/cJpLoS/pcCXkSrLhq0QmwxdynsyC+lE7Ww
         I2ADxG++QfXbVllgzm9Jq6UuKBVHATWoTSFacsfAJK116uxFMOHlVXDFX4vHEBQxuu
         XARmeyT3lVy7Q==
Message-ID: <2219a894-eb79-70a4-2b92-2b7ee7e1e966@alu.unizg.hr>
Date:   Mon, 3 Apr 2023 09:17:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 3/3] xhci: Free the command allocated for setting LPM if
 we return early
Content-Language: en-US, hr
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, Stable@vger.kernel.org
References: <20230330143056.1390020-1-mathias.nyman@linux.intel.com>
 <20230330143056.1390020-4-mathias.nyman@linux.intel.com>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <20230330143056.1390020-4-mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Mathias!

On 30.3.2023. 16:30, Mathias Nyman wrote:
> The command allocated to set exit latency LPM values need to be freed in
> case the command is never queued. This would be the case if there is no
> change in exit latency values, or device is missing.
> 
> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> Link: https://lore.kernel.org/linux-usb/24263902-c9b3-ce29-237b-1c3d6918f4fe@alu.unizg.hr
> Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
> Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>   drivers/usb/host/xhci.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index bdb6dd819a3b..6307bae9cddf 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
>   
>   	if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
>   		spin_unlock_irqrestore(&xhci->lock, flags);
> +		xhci_free_command(xhci, command);
>   		return 0;
>   	}

There seems to be a problem with applying this patch with "git am", as it
gives the following:

commit ff9de97baa02cb9362b7cb81e95bc9be424cab89
Author: @ <@>
Date:   Mon Apr 3 08:42:33 2023 +0200

     The command allocated to set exit latency LPM values need to be freed in
     case the command is never queued. This would be the case if there is no
     change in exit latency values, or device is missing.

     Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
     Cc: <Stable@vger.kernel.org>
     Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Thank you.

Best regards,
Mirsad

-- 
Mirsad Todorovac
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb
Republic of Croatia, the European Union

Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

