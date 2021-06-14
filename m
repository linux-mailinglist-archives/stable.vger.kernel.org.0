Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DE33A68C9
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 16:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhFNOSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 10:18:11 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:37580 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbhFNOSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 10:18:10 -0400
Received: by mail-wr1-f42.google.com with SMTP id i94so14708482wri.4;
        Mon, 14 Jun 2021 07:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nv8sCghoU/z4tN6pql6xoUnldOs3jUg913mwIKWSKs0=;
        b=IaXhDbnblhRX4Dj2Pw5J7M3I9iuRNU3DIVktue8Or1bI37wHgSeoYfIepRxio7yMWm
         zA0wy2rDDVcyopuOVBdaE1zjQxO8xR+EV/A4v6frji+ECJOc7PRD4gx/d93wI0Clo3CD
         UHpkwc0u3NlS9dq7zENaPPvcMaHb6bm1DSg9oHP/LNsP7ItKAGtGdwrvyDJ6/Uer5rTY
         SQ4JKRrBU+w74qOaLQKC+3Kf2qO0bW4LeuGRp9y0Ez6lM2Nw4GqhX6o9ZaJQDROrisv2
         i4tnv/uZ0UkMTYZqMKtwTXpqScBNVON5eOI8QuMKTIvohnKIN0U64xHM8Ipgq0vhsyd1
         nT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nv8sCghoU/z4tN6pql6xoUnldOs3jUg913mwIKWSKs0=;
        b=LZ9sm4/XWcitSFQNIlNDX2tQWo168SNHhTgQotRJeu6tFt6gO9WIVJqoOWUNVl1Q/x
         TwAtOT+g0O7+qFn5Qx1Z8BbyyaFQBfWPyU22YLaghaLJLceK4LEgvHR49nDPSvupXm7/
         PkvMQWP8mOEI7jXzTAHhKHNw6fBkRSrGRqe89Pb6rjrJtMI74mymXVSYeRUUxQdxzEC+
         nrK2b3Y0d7oI0UHCWVED4/Glc97yGgqJWgzBI5kWQn0P7o+j0sUuVtdz/RpvX+hIFe65
         WfBYbKU6Mxyl+6CTJ3gtEYFmGJYUIkjM19d7SwafOS68uGlpNFV3wDm8VJWhBjIWmG3L
         kppw==
X-Gm-Message-State: AOAM530dTTCwQyFGNrQL8cfCtQMB29qO3HI00L8xmg7713kBfMb0alft
        DcD1T8XFxZvRcAQd8pQzs2x4CaxBqkk=
X-Google-Smtp-Source: ABdhPJyyC2BKBidatirkK3+o41GNY290g5haHJkw48TwQSxkA7kd1QhAYxnvyHe4DH0mOiQT2Bmmow==
X-Received: by 2002:a05:6000:184c:: with SMTP id c12mr19551152wri.196.1623680107011;
        Mon, 14 Jun 2021 07:15:07 -0700 (PDT)
Received: from [192.168.181.98] (199.106.23.93.rev.sfr.net. [93.23.106.199])
        by smtp.gmail.com with ESMTPSA id h11sm13060093wmq.34.2021.06.14.07.15.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 07:15:06 -0700 (PDT)
Subject: Re: [PATCH 5.4 39/78] Bluetooth: use correct lock to prevent UAF of
 hdev object
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>
References: <20210608175935.254388043@linuxfoundation.org>
 <20210608175936.584233292@linuxfoundation.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <def3c8d4-a787-8536-e743-adf90a0c5352@gmail.com>
Date:   Mon, 14 Jun 2021 16:15:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210608175936.584233292@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/8/21 8:27 PM, Greg Kroah-Hartman wrote:
> From: Lin Ma <linma@zju.edu.cn>
> 
> commit e305509e678b3a4af2b3cfd410f409f7cdaabb52 upstream.
> 
> The hci_sock_dev_event() function will cleanup the hdev object for
> sockets even if this object may still be in used within the
> hci_sock_bound_ioctl() function, result in UAF vulnerability.
> 
> This patch replace the BH context lock to serialize these affairs
> and prevent the race condition.
> 
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/bluetooth/hci_sock.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -755,7 +755,7 @@ void hci_sock_dev_event(struct hci_dev *
>  		/* Detach sockets from device */
>  		read_lock(&hci_sk_list.lock);
>  		sk_for_each(sk, &hci_sk_list.head) {
> -			bh_lock_sock_nested(sk);
> +			lock_sock(sk);
>  			if (hci_pi(sk)->hdev == hdev) {
>  				hci_pi(sk)->hdev = NULL;
>  				sk->sk_err = EPIPE;
> @@ -764,7 +764,7 @@ void hci_sock_dev_event(struct hci_dev *
>  
>  				hci_dev_put(hdev);
>  			}
> -			bh_unlock_sock(sk);
> +			release_sock(sk);
>  		}
>  		read_unlock(&hci_sk_list.lock);
>  	}
> 
> 


This patch is buggy.

lock_sock() can sleep.

But the read_lock(&hci_sk_list.lock) two lines before is not going to allow the sleep.

Hmmm ?


