Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147206CB1C7
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 00:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbjC0WZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 18:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbjC0WZn (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Mar 2023 18:25:43 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD363C33;
        Mon, 27 Mar 2023 15:25:42 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id F0398604F2;
        Tue, 28 Mar 2023 00:25:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1679955940; bh=UmKK/K6r1XUY8Qt5LDMAYSfnL5cEN4kYyMt8GqUwSKI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=2KVW0N2DElcyDJrnOniKv2VfobU2xISaujRjwvOEBYZmsPwSFBKfvD9ZNMuW7rdEQ
         Xu3A5AeTpuXhshkJd7SGSVv6n5ljiIVSn2c3TRDcQsPhEoIA11x9KCwFdCDNEA0VTP
         SYHULsUYCHf9kD18mTGFIp1caKBGEO6QilsjiPuyNSrYaloQ4UnD1YniJ3gemd0vIt
         UOik7QqWfLmDBaB3I5Rud2GNsg3aZ4zg19KAVVjAKb4IzHVZFfKco+ZiFeowmlmkFK
         5dNJAB2pjVJyuLocwgncdmxFzMG5b/e9aDGUuhHtpEkEa92RCZqmzU1wtpsMbSWOC/
         H2az8/h8wyN1g==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id p_zpHq6SdN4h; Tue, 28 Mar 2023 00:25:38 +0200 (CEST)
Received: from [192.168.1.3] (unknown [77.237.101.225])
        by domac.alu.hr (Postfix) with ESMTPSA id 698BD604EF;
        Tue, 28 Mar 2023 00:25:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1679955938; bh=UmKK/K6r1XUY8Qt5LDMAYSfnL5cEN4kYyMt8GqUwSKI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=X196uIJTyHFVHRVCY2sTcXTPKkg5Q4VqbdYri1CUzwXxU1qaD5pngzgQTjL2tS+GR
         wqb0EyIiTGemEwoJaO3rG1uauUo2FPJ3Z1Bv89u7wT8JhOa3ZzbVScKBqk5FCkntPY
         7WSUCnKvn9PEta4LXdFXWn4yg+qv3cabnWybt+0ETorJnxhQo4yiKGco61BtEj92+X
         YVKclcqqTjf2GPuxdPKd4v3DkCJ9znqbEgLG5ztU5I5L11P2hWhW/gmYNA2k6/qvxj
         2JxgZsg0mOvFdCQS+iHD4KnNTn/GA+wHZxBM5cVRMQMZpxsaENnkzPKh6e07cEPARS
         Ty0M7ucjo7YAg==
Message-ID: <d84fe574-e6cc-ad77-a44c-1eb8df3f2b6b@alu.unizg.hr>
Date:   Tue, 28 Mar 2023 00:25:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] xhci: Free the command allocated for setting LPM if we
 return early
Content-Language: en-US, hr
To:     Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, ubuntu-devel-discuss@lists.ubuntu.com,
        stern@rowland.harvard.edu, arnd@arndb.de, Stable@vger.kernel.org
References: <b86fcdbd-f1c6-846f-838f-b7679ec4e2b4@linux.intel.com>
 <20230327095019.1017159-1-mathias.nyman@linux.intel.com>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <20230327095019.1017159-1-mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27. 03. 2023. 11:50, Mathias Nyman wrote:
> The command allocated to set exit latency LPM values need to be freed in
> case the command is never queued. This would be the case if there is no
> change in exit latency values, or device is missing.
> 
> Fixes: 5c2a380a5aa8 ("xhci: Allocate separate command structures for each LPM command")
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index bdb6dd819a3b..6307bae9cddf 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -4442,6 +4442,7 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
>  
>  	if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
>  		spin_unlock_irqrestore(&xhci->lock, flags);
> +		xhci_free_command(xhci, command);
>  		return 0;
>  	}
>  

After more testing, I can confirm that your patch fixes the leak in the original
environment.

And I see that you independently already have bisected the culprit commit, so I
have needlessly duplicated the work.

However, I consider myself still a learner and an absolute beginner in the Linux
kernel world ...

Best regards,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

"I see something approaching fast ... Will it be friends with me?"

