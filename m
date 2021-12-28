Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4EA480CED
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 21:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237228AbhL1UEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 15:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237216AbhL1UEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 15:04:21 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FA4C06173E
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 12:04:20 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t26so40255765wrb.4
        for <stable@vger.kernel.org>; Tue, 28 Dec 2021 12:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=goEETpOG9lfFevQHaur9PF5zaafWC9JdHro5XcDyM3s=;
        b=BZL8TKVxZBTtWhHhRnFHkYQw4mr94k7ePLKn6WIBSrOqTeipYFKW7BnRWSvQbvQYKc
         qanpY3Tu6TN6CaeWQ5rLt+SYXVKHpXjKHR1PAQgrSFA+FYgJiXFUyJ3WlHnd5L9/wNeE
         MURgsEKGnoZhMt6u9du4beR0EWgThKhNloCUzKlTT4tqdCX3msJumjBrmOXYm4kxcW9L
         U8I+zpsfS+Iap32r3gjcUkJXyZkKSJXeeVNMUsB/qusvwNZKWn+mDwjc+YKeUrtMLE9M
         LgIPTWJoBi7d8EiSh7dtZeu7sE3O7zv+WsVdCo1EKO23JJcg8ChK2ysPpFkthd3UKysK
         BkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=goEETpOG9lfFevQHaur9PF5zaafWC9JdHro5XcDyM3s=;
        b=bc60sM1lAVJMJERa0TOn7fMl8WYJql/jhsQtqqr7V8GWav4S1bJ/2pSOc4o2e4TRqw
         i56EWb3ZF1NmKaiuYrus2CLRr4p9b33QzBdSMtWJsoNWPN65vxgM5DixL9n4e2/i5SIp
         1rtwempJH3O6vmXPrDL9k4+DgKSBzgGIsTdwkbnxo3wgbvObVA/wrt6ZWlS1kxSCgP0m
         /XXdseoOZ9WBH/PVxnojvi1MiurRJQLzvu4jgCQsOEsJJv7AXkTZisEvJuvMBdo/h6cK
         tKQna3ZM8Ev1tARoXSH+GPfCx6r3NnL31VBT3i9s4BoR+OQksOv86euAEcNDTVfwpXcI
         rMfQ==
X-Gm-Message-State: AOAM532e1SkCXuI6uDKm0lVkxDvGdyZychYNU8pNt75JNnCFxEeHvFPh
        DlyrjeiVN5dcbsxdl+Ujyw0zqA==
X-Google-Smtp-Source: ABdhPJzENjmDSLB7a5xJOEU+owmw+05dK3GBXnyzbbvMdDMN+9jwRyPqZ3c1x7m35sU3sZGX/Ty7KQ==
X-Received: by 2002:a5d:58c5:: with SMTP id o5mr17226605wrf.15.1640721859327;
        Tue, 28 Dec 2021 12:04:19 -0800 (PST)
Received: from ?IPV6:2003:d9:970a:4f00:9d27:bf8:b765:305? (p200300d9970a4f009d270bf8b7650305.dip0.t-ipconnect.de. [2003:d9:970a:4f00:9d27:bf8:b765:305])
        by smtp.googlemail.com with ESMTPSA id a198sm19125636wmd.42.2021.12.28.12.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 12:04:18 -0800 (PST)
Message-ID: <18b6afe8-43b1-4159-0ddd-eca08f175f0a@colorfullife.com>
Date:   Tue, 28 Dec 2021 21:04:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
Content-Language: en-US
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasily Averin <vvs@virtuozzo.com>, cgel.zte@gmail.com,
        shakeelb@google.com, rdunlap@infradead.org, dbueso@suse.de,
        unixbhaskar@gmail.com, chi.minghao@zte.com.cn, arnd@arndb.de,
        Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org
References: <20211222194828.15320-1-manfred@colorfullife.com>
 <Ycdo1PHC9KDD8eGD@pc638.lan> <YceiFXyoGcgPaLeJ@casper.infradead.org>
 <Ycis/J1U2DB6Zx7j@pc638.lan> <YctpUurav74Ir5YS@pc638.lan>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <YctpUurav74Ir5YS@pc638.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Vlad,

On 12/28/21 20:45, Uladzislau Rezki wrote:
> [...]
> Manfred, could you please have a look and if you have a time test it?
> I mean if it solves your issue. You can take over this patch and resend
> it, otherwise i can send it myself later if we all agree with it.

I think we mix tasks: We have a bug in ipc/sem.c, thus we need a 
solution suitable for stable.

Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo 
allocation")
Cc: stable@vger.kernel.org

I think for stable, there are only two options:

- change ipc/sem.c, call kvfree() after dropping the spinlock

- change kvfree() to use vfree_atomic().

 From my point of view, both approaches are fine.

I.e. I'm waiting for feedback from an mm maintainer.

As soon as it is agreed, I will retest the chosen solution.


Now you propose to redesign vfree(), so that vfree() is safe to be 
called while holding spinlocks:

> <snip>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d2a00ad4e1dd..b82db44fea60 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1717,17 +1717,10 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end)
>   	return true;
>   }
>   
> -/*
> - * Kick off a purge of the outstanding lazy areas. Don't bother if somebody
> - * is already purging.
> - */
> -static void try_purge_vmap_area_lazy(void)
> -{
> -	if (mutex_trylock(&vmap_purge_lock)) {
> -		__purge_vmap_area_lazy(ULONG_MAX, 0);
> -		mutex_unlock(&vmap_purge_lock);
> -	}
> -}
> +static void purge_vmap_area_lazy(void);
> +static void drain_vmap_area(struct work_struct *work);
> +static DECLARE_WORK(drain_vmap_area_work, drain_vmap_area);
> +static atomic_t drain_vmap_area_work_in_progress;
>   
>   /*
>    * Kick off a purge of the outstanding lazy areas.
> @@ -1740,6 +1733,22 @@ static void purge_vmap_area_lazy(void)
>   	mutex_unlock(&vmap_purge_lock);
>   }
>   
> +static void drain_vmap_area(struct work_struct *work)
> +{
> +	mutex_lock(&vmap_purge_lock);
> +	__purge_vmap_area_lazy(ULONG_MAX, 0);
> +	mutex_unlock(&vmap_purge_lock);
> +
> +	/*
> +	 * Check if rearming is still required. If not, we are
> +	 * done and can let a next caller to initiate a new drain.
> +	 */
> +	if (atomic_long_read(&vmap_lazy_nr) > lazy_max_pages())
> +		schedule_work(&drain_vmap_area_work);
> +	else
> +		atomic_set(&drain_vmap_area_work_in_progress, 0);
> +}
> +
>   /*
>    * Free a vmap area, caller ensuring that the area has been unmapped
>    * and flush_cache_vunmap had been called for the correct range
> @@ -1766,7 +1775,8 @@ static void free_vmap_area_noflush(struct vmap_area *va)
>   
>   	/* After this point, we may free va at any time */
>   	if (unlikely(nr_lazy > lazy_max_pages()))
> -		try_purge_vmap_area_lazy();
> +		if (!atomic_xchg(&drain_vmap_area_work_in_progress, 1))
> +			schedule_work(&drain_vmap_area_work);
>   }
>   
>   /*
> <snip>
I do now know the mm code well enough to understand the side effects of 
the change. And doubt that it is suitable for stable, i.e. we need the 
simple patch first.

--

     Manfred

