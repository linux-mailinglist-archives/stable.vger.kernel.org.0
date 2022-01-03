Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF78482F69
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 10:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiACJ1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 04:27:11 -0500
Received: from mail-ed1-f41.google.com ([209.85.208.41]:42657 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiACJ1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 04:27:11 -0500
Received: by mail-ed1-f41.google.com with SMTP id j21so133462169edt.9;
        Mon, 03 Jan 2022 01:27:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I6mFObq+HW34JfaRw9hspk15zGnBTkuC5zPqAfC34u4=;
        b=LbWSXu33EnyWBMAsnNaftOvFybCaVsH2HhdB8dMbigLTx3P/0qt8AuthZHP6sxnuQA
         QM4WdwKZJfxwaqRjArOycNN7Ux/PuuL7RTBgo1jW/s9E4Ehpes5hu4FhiOvojcJhDdVs
         t899CvG/fuqW4gF00hoUJu9DI0d4Nj8dijpYVxdn3Vbnvo9kBKyZMBGQwFAZMcdA84OE
         XRRNhtmKkbEfsROvRc0LE0sxhyJ9FQZZbC7DOpyH2w/0NT4zCxpf7CfkWewmtDNe3L7q
         0ex4rnnqj55yAaBn950aVwLzHDA6s1kayFqEwoyJb7i6dl2nayiZ0KxiOO2dDfCARivN
         YIvg==
X-Gm-Message-State: AOAM532hWSRHFOV2hIT3jLQki+S+3iXzIul5jboF3JvX2c2exCMNuZWr
        fdBAvAiCIMZxQe7q2s7SkwU=
X-Google-Smtp-Source: ABdhPJyZX4AG8dE5Q7iACz0rxB9YoGeBK2NJMtERD64LbrojenW8G4vLChuHSJ0r0zbMKPYUlcqZqA==
X-Received: by 2002:a05:6402:11c7:: with SMTP id j7mr40498320edw.169.1641202029877;
        Mon, 03 Jan 2022 01:27:09 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id lb7sm4208925ejc.20.2022.01.03.01.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 01:27:09 -0800 (PST)
Message-ID: <97e94a27-6f9f-1a21-cf3e-11d97f74cbd8@kernel.org>
Date:   Mon, 3 Jan 2022 10:27:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] ipc/sem: do not sleep with a spin lock held
Content-Language: en-US
To:     cgel.zte@gmail.com, manfred@colorfullife.com
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        chi.minghao@zte.com.cn, dbueso@suse.de,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        shakeelb@google.com, unixbhaskar@gmail.com, vvs@virtuozzo.com,
        zealci@zte.com.cn
References: <63840bf3-2199-3240-bdfa-abb55518b5f9@colorfullife.com>
 <20211223031207.556189-1-chi.minghao@zte.com.cn>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20211223031207.556189-1-chi.minghao@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23. 12. 21, 4:12, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> We can't call kvfree() with a spin lock held, so defer it.

Sorry, defer what?

There are attempts to fix kvfree instead, not sure which of these 
approaches (fix kvfree or its callers) won in the end?

> Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo
> allocation")
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> ---
> changelog since v2:
> + Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo
> + allocation")
>   ipc/sem.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 6693daf4fe11..0dbdb98fdf2d 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1964,6 +1964,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
>   	 */
>   	un = lookup_undo(ulp, semid);
>   	if (un) {
> +		spin_unlock(&ulp->lock);
>   		kvfree(new);
>   		goto success;
>   	}


-- 
js
suse labs
