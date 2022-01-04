Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFFA484926
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 21:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiADUS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 15:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbiADUS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 15:18:59 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F87C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 12:18:59 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v6so16741608wra.8
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 12:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YqfimjW8kCsOGvR2KcD4RHQdQET20TI1ORmSBFI8sRI=;
        b=WDkFXYDph6APi2TpmYV6NVvr0fZ/tTd6JqHKrtaa4wc/trS5pJhe8kbolGjpUT6ykG
         j8sFJUO9Yz9duMqOO7bySuDXp67t3obD3aB+SGWYX9uHrP9mthyOt6bVHewnu7ZMC44X
         tTLwK8u8keXTHuNpACSB7d3eJ4GVIH/Kg7zCPK6GEtKy4516s+ejpdz8VjvfPRVYSP/3
         TqRkV10FROCbDFXAvbYBYisOywawYWOUgvuiawoB+Z/Lcu6yVLeWl+gTmEsGSgTuPklS
         Dpg1kPbglEXCVmrE4Lcltu0vrAFNW4MStnZwWUAtQKda9Shag3duJO4//29OZDeUVgZB
         iy9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YqfimjW8kCsOGvR2KcD4RHQdQET20TI1ORmSBFI8sRI=;
        b=J99Rc/gQNKfv5F3o1AE3wwpSVM45rjnAHkdKE7BI3VPp37Itx1ETb4F9EjD4R1zyna
         Ud6EUPJPikflJlbNBa8S4bKzJ33RBMmuaHehZgxYU30G5ym6tdEuwTTczjoOtERchcTT
         xQ2ycPvCljTjOEuN2WP7YJ9VkmcILGM83PdE56PMFoJyT07oHsH5vobmLLin82jUNzKB
         /HpSTJqmnXROjbbKQDNLe+Ue+Dm3s7q+h+LgiMtU7D/pyVsmmhbTcfonMbRD3LtccHAp
         Aobb+ICMWJJbCgohP+wyxpxHKBZ9Hx+UYGst3LRCw7KnT4+rA7bWSiORhuZiwKz3BbZb
         2hJQ==
X-Gm-Message-State: AOAM531QGPfEkxDVrCxOe3dBnQ+CeaGbR4y62jV6QyEqfmh2B5gBIR/6
        Vk1B9H3788TNVo/t5HqHnrouWA==
X-Google-Smtp-Source: ABdhPJy6tdRfuf7vNvrCfa4kPR0PUvJ+rN7Ff5/CjrEw6jTzUch5sDRmqtRdda/moa/f0FdJEWxUzQ==
X-Received: by 2002:a05:6000:1188:: with SMTP id g8mr35565138wrx.134.1641327537601;
        Tue, 04 Jan 2022 12:18:57 -0800 (PST)
Received: from ?IPV6:2003:d9:9708:b800:49a3:330d:2aba:c4a2? (p200300d99708b80049a3330d2abac4a2.dip0.t-ipconnect.de. [2003:d9:9708:b800:49a3:330d:2aba:c4a2])
        by smtp.googlemail.com with ESMTPSA id c11sm492175wmq.48.2022.01.04.12.18.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 12:18:57 -0800 (PST)
Message-ID: <5818b7e5-5d21-9f80-3571-f0d34b4f5c23@colorfullife.com>
Date:   Tue, 4 Jan 2022 21:18:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] ipc/sem: do not sleep with a spin lock held
Content-Language: en-US
To:     Shakeel Butt <shakeelb@google.com>, cgel.zte@gmail.com
Cc:     stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, chi.minghao@zte.com.cn,
        Davidlohr Bueso <dbueso@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, unixbhaskar@gmail.com,
        Vasily Averin <vvs@virtuozzo.com>, zealci@zte.com.cn
References: <63840bf3-2199-3240-bdfa-abb55518b5f9@colorfullife.com>
 <20211223031207.556189-1-chi.minghao@zte.com.cn>
 <CALvZod7pTO6D5Lx62-eVWORSj4Q=Px2iu=qUgqA_9AZwQOKsUg@mail.gmail.com>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <CALvZod7pTO6D5Lx62-eVWORSj4Q=Px2iu=qUgqA_9AZwQOKsUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/4/22 19:20, Shakeel Butt wrote:
> On Wed, Dec 22, 2021 at 7:12 PM <cgel.zte@gmail.com> wrote:
>> From: Minghao Chi <chi.minghao@zte.com.cn>
>>
>> We can't call kvfree() with a spin lock held, so defer it.
>> Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo
>> allocation")
>>
>> Reported-by: Zeal Robot <zealci@zte.com.cn>
>> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

Reviewed-by: Manfred Spraul <manfred@colorfullife.com>

--

     Manfred

