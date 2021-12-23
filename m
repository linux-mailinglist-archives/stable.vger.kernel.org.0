Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE0E47E2A1
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 12:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbhLWLwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 06:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbhLWLwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 06:52:30 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B43C061756
        for <stable@vger.kernel.org>; Thu, 23 Dec 2021 03:52:30 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id l4so3452952wmq.3
        for <stable@vger.kernel.org>; Thu, 23 Dec 2021 03:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vz4h/RJ8rZ3VS60YQh1WzGOuxDSr5YtX1Zwui52SKVc=;
        b=SQOpFeLuoIK3AUyO8KTyYlw5E20xMmt6Y85TplQ3xxU4QTHzjk26xwSIFYRtKEdG+J
         mP4s7UlLqs1+r5kLlZFQbF0R/Gb/cjcy8A8xJpWn6BggMskkHY0ieIIBIvMJW2XBMxj/
         wc2pOSlw/ItFJRt4xfC9M/5zEvwZXQfy4D0YQz6oIwplLnn4PbDwQSIH1/9ueRehVcpz
         mXVL2Kv7pjM6TTEg5ng8zONcg/VDur0BL1Wmavj7WpeIYOFCd4Ax4Y3EmJERfrV49TvK
         G6+RP2c/u9fl7PDQsrnoxE2Dt3+/u7Yy0FT/q1sIg5+W+liYVJaTedRZWciOBw1OmKTB
         0Zug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vz4h/RJ8rZ3VS60YQh1WzGOuxDSr5YtX1Zwui52SKVc=;
        b=ch3Mq6w5eqB6Nn/RUkv55Doc000xZmuT8vKdSsMWIK3gqY1vcqn1Joh5KNfiWnD8Rp
         xDfaHv4cszf6oVhFOljXS+FvaKMdV8UoxpiKzhR5uGvLWbWmoc0ZbDQCBmbyvUbauxKr
         SQQSN0fNJ/fspbDipwwRSOUefHzJDfzKpgPgSOQ1KRPVqoeT6nYxNcizdRzQVe5FuuKI
         1DwuQHVcTnZTilUEV/SlhAKibc9ktQ7rKRwillM2Ghcm26SoiddLbTVvFfiKTQyrcF29
         rhnLzzYD1Fwygip/rAwIbqI5xERZsmpMn2O/QmBRPLT/Agn/gfVjNjIyyi4YO2SOsWYA
         XTOg==
X-Gm-Message-State: AOAM532SMwZ1alHtW5HuKAcKEWG9o3hvSIj1fBhEHdqhTrvbvqEHmBx7
        OvUVakLZVvJjIN4ifbKnARD2BQ==
X-Google-Smtp-Source: ABdhPJxr2eV0xUcmK0kd5NhXFsKWLzuRNo0SVcNrD/CNu9SSi5hSue+5jMAuBJrcIgxQQ3TVVNPbwQ==
X-Received: by 2002:a1c:c908:: with SMTP id f8mr1440221wmb.193.1640260348998;
        Thu, 23 Dec 2021 03:52:28 -0800 (PST)
Received: from ?IPV6:2003:d9:970a:ab00:ae94:992d:1079:bfc? (p200300d9970aab00ae94992d10790bfc.dip0.t-ipconnect.de. [2003:d9:970a:ab00:ae94:992d:1079:bfc])
        by smtp.googlemail.com with ESMTPSA id i1sm7601297wml.26.2021.12.23.03.52.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 03:52:18 -0800 (PST)
Message-ID: <937f1320-6b7e-9aa2-2a21-7fd2f94eeb32@colorfullife.com>
Date:   Thu, 23 Dec 2021 12:52:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
Content-Language: en-US
To:     Vasily Averin <vvs@virtuozzo.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     cgel.zte@gmail.com, shakeelb@google.com, rdunlap@infradead.org,
        dbueso@suse.de, unixbhaskar@gmail.com, chi.minghao@zte.com.cn,
        arnd@arndb.de, Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org
References: <20211222194828.15320-1-manfred@colorfullife.com>
 <3ca4dec8-f0bd-740f-73c8-34fc6fc1cf66@virtuozzo.com>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <3ca4dec8-f0bd-740f-73c8-34fc6fc1cf66@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Vasily,

On 12/23/21 08:21, Vasily Averin wrote:
>
> I would prefer to release memory ASAP if it's possible.
> What do you think about this change?
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -614,9 +614,12 @@ EXPORT_SYMBOL(kvmalloc_node);
>    */
>   void kvfree(const void *addr)
>   {
> -       if (is_vmalloc_addr(addr))
> -               vfree(addr);
> -       else
> +       if (is_vmalloc_addr(addr)) {
> +               if (in_atomic())
> +                       vfree_atomic();
> +               else
> +                       vfree(addr);
> +       } else
>                  kfree(addr);
>   }
>   EXPORT_SYMBOL(kvfree);
>
Unfortunately this cannot work:

> /*
> * Are we running in atomic context?  WARNING: this macro cannot
> * always detect atomic context; in particular, it cannot know about
> * held spinlocks in non-preemptible kernels.  Thus it should not be
> * used in the general case to determine whether sleeping is possible.
> * Do not use in_atomic() in driver code.
> */
> #define in_atomic()     (preempt_count() != 0)
>

--

     Manfred

