Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2C51A03DB
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 02:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgDGAmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 20:42:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36868 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgDGAmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 20:42:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id j19so42862wmi.2;
        Mon, 06 Apr 2020 17:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1/GMD4MhzeUoQcWCEaHjUFdLxERyNzM7HCiCRhFo7RM=;
        b=USj6K0LkmikgD6fr+GWmT+COhXGfdPBRCHh03ECvPd2Q5gwS914lN3KG6RyFOVByqs
         w3C8TA5vPXTM3s9ODDBCcR0KjCF9Kd2pMhfc4uEPryqrGG6viAj1blr1AprmazjH8t88
         jXx1QaUFIZ4CGAojGWXEWGgFOMnFIrYI/4ov8KSi/38g/eaYOFYeCJZsNusg0siNaQxc
         uhyg4i+17ZnCFNTN7HIlS+q+3aydWcdilcrWJ6MaW9UzuqMZVl7hXSXQ+FR0p2cbK1HY
         1CmDgNTuyBV9SPFSDf70C1XBn29RFU2PIdiDXhRxvberflvihhXHDMHDeD1R9WXnWFnA
         I1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1/GMD4MhzeUoQcWCEaHjUFdLxERyNzM7HCiCRhFo7RM=;
        b=juK9yiK408DYz8ncJD7lryOr3wBU/sKWgF1UHCfcCCyiHcAmL7R6GjeZ6Nff3XXiDE
         Af64xXwjnn2ZjuYw2b7jUIOL2Bbkd5p61D5SlqQQJrfChHVtYmBCqCbuVxwckMcIAa72
         FLf4CqiILIn30RX4SydB8TStSffDbprAZII/uw3hpAuw1OVxF3xmDgGGrDLrDNxRnoBv
         OssWRylxMtoTl96j+xrIA3Yqo/x3umwxiYY4JD+6ClRaZk1X3oQtRcqRkzoWz7NWlfNc
         q0bzZM3F22NoJL+yumzbS0uiq0DJ9aXJg9snxgmO/dBgk2vIDNy8P6BHx807PcOLvMxU
         ncVw==
X-Gm-Message-State: AGi0PuZFezwygG/WnfBdfXGw9Z1vl+4BRMVKE+uuYxHcqzrhfRurLdL6
        bgq5xAOWUY4cjQVNTZrCo88cO831
X-Google-Smtp-Source: APiQypK5l4kzvVHMqFZ7bwJHNb0J4A5hLsgNTWbaT9wu+0ES74Y8yZem/5WLtA7MKjs98GGXOT3mhw==
X-Received: by 2002:a7b:cb59:: with SMTP id v25mr1758678wmj.13.1586220140055;
        Mon, 06 Apr 2020 17:42:20 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v7sm1834585wmg.3.2020.04.06.17.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 17:42:19 -0700 (PDT)
Subject: Re: [PATCH 4.9 040/102] net: dsa: Fix duplicate frames flooded by
 learning
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20200401161530.451355388@linuxfoundation.org>
 <20200401161540.401786749@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <5b036a64-db51-d687-758f-c8b0a5b0c72b@gmail.com>
Date:   Mon, 6 Apr 2020 17:42:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200401161540.401786749@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/1/2020 9:17 AM, Greg Kroah-Hartman wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> [ Upstream commit 0e62f543bed03a64495bd2651d4fe1aa4bcb7fe5 ]
> 
> When both the switch and the bridge are learning about new addresses,
> switch ports attached to the bridge would see duplicate ARP frames
> because both entities would attempt to send them.
> 
> Fixes: 5037d532b83d ("net: dsa: add Broadcom tag RX/TX handler")
> Reported-by: Maxime Bizon <mbizon@freebox.fr>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/dsa/tag_brcm.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -84,6 +84,8 @@ static struct sk_buff *brcm_tag_xmit(str
>  		brcm_tag[2] = BRCM_IG_DSTMAP2_MASK;
>  	brcm_tag[3] = (1 << p->port) & BRCM_IG_DSTMAP1_MASK;
>  
> +	skb->offload_fwd_mark = 1;

This is incorrectly placed, the assignment should be in brcm_tag_rcv().
It looks like only linux-4.9.y is affected. Sorry for not noticing this
earlier. Do you want me to submit a correcting patch?
-- 
Florian
