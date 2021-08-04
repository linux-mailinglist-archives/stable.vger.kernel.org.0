Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD783DF8DB
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 02:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhHDAUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 20:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbhHDAUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 20:20:14 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B91C06175F
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 17:20:02 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so6296416pjb.3
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 17:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=anLcT6NmPw5Wq6jaqp4SuN5fczQ6h6jMYqdGqLcfbzU=;
        b=eLYmNPskipBKjMlAN7IVq5LvbAcMs0NDKXctVa0zr0pvARvfLDE6Jcy7dAqfaRn7yb
         3eazISO9/z1ST9Naz1Kg16wOnphutXVpjbFngl8lcyEvqr24yDdHe3PYTggeRUDHRRuk
         NA14FZluM7XdhqHp2RazqrefbsTajF5z3obW3qBvrUT58XviVkANjpRHmCYWMwhiIBvu
         AZN5e1f57nL1LE0X2kD5rc+D/aj4kcFRkqMOPOVAHUwa3brWo1np5HuAkeOciGgOScp7
         /S5jALGuMN8xzVodhCToux9qnTC7asCQnn9LtIH4tp4qDNuiaTLMKNxn1Je0vJEunDTA
         LOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=anLcT6NmPw5Wq6jaqp4SuN5fczQ6h6jMYqdGqLcfbzU=;
        b=f1t3u44Ft4rpVPSO3ubHE722akVwWuOxWIts4c/b6e4N0cm+G4y2KmesoifqQIkI2d
         NG04BGBHq0ylB/IAW0gwVpPE1bCACMzFSQ29YeVi0h4W5Vv6vTfWn+E2LmPkOxc0uamG
         qzwfostmHE4k0+pMAtC+jO49dDzdEdlohaQabbk24QET840qzSow/+g79JAEymP5utld
         TjC1THUjRmRl4fX+UIzi/ToKMMPb3sCDGgM8UtIT/hILNm6Og+zszzOCBq9IQ2FDxA7H
         1IjpWAzXdcnvKKEn/IyEzBCbQOsNBXKYjpCrN2iRBm4X00Uv84nm1B5KoGl86MhnHzFb
         nkBw==
X-Gm-Message-State: AOAM533Y6a5zysxxF2WVT61AkqUyGSr3DJcLwjsjVOIe64hW0er20VPz
        b5Emc35/mynw1V6LKiDZI5FF7g==
X-Google-Smtp-Source: ABdhPJzPpbQ+hNLyy6tCVMaIw6/IAa/BqOg7qYT4dqYiH62tlIo1eEJRV92SpuuauEdd5A1EYA0Yag==
X-Received: by 2002:a63:5703:: with SMTP id l3mr1046571pgb.338.1628036401309;
        Tue, 03 Aug 2021 17:20:01 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id y8sm360674pfe.162.2021.08.03.17.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 17:20:00 -0700 (PDT)
Date:   Tue, 03 Aug 2021 17:20:00 -0700 (PDT)
X-Google-Original-Date: Tue, 03 Aug 2021 17:19:57 PDT (-0700)
Subject:     Re: [PATCH v2] lib: Use PFN_PHYS() in devmem_is_allowed()
In-Reply-To: <12e37243-0cdb-6765-c3ef-c98fd291591c@huawei.com>
CC:     wangliang101@huawei.com, mcgrof@kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org, wangle6@huawei.com,
        kepler.chenxin@huawei.com, nixiaoming@huawei.com
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     wangkefeng.wang@huawei.com
Message-ID: <mhng-e101fb5a-2f16-45a0-8436-454ac2bf4223@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Jul 2021 00:04:05 PDT (-0700), wangkefeng.wang@huawei.com wrote:
>
> On 2021/7/30 14:49, Liang Wang wrote:
>> The physical address may exceed 32 bits on ARM(when ARM_LPAE enabled),
>> use PFN_PHYS() in devmem_is_allowed(), or the physical address may
>> overflow and be truncated.
>>
>> This bug was initially introduced from v2.6.37, and the function was moved
>> to lib when v5.10.
>>
>> Fixes: 087aaffcdf9c ("ARM: implement CONFIG_STRICT_DEVMEM by disabling access to RAM via /dev/mem")
>> Fixes: 527701eda5f1 ("lib: Add a generic version of devmem_is_allowed()")
>> Cc: stable@vger.kernel.org # v2.6.37
>> Signed-off-by: Liang Wang <wangliang101@huawei.com>
> Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>> v2: update subject and changelog
>>   lib/devmem_is_allowed.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/devmem_is_allowed.c b/lib/devmem_is_allowed.c
>> index c0d67c541849..60be9e24bd57 100644
>> --- a/lib/devmem_is_allowed.c
>> +++ b/lib/devmem_is_allowed.c
>> @@ -19,7 +19,7 @@
>>    */
>>   int devmem_is_allowed(unsigned long pfn)
>>   {
>> -	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
>> +	if (iomem_is_exclusive(PFN_PHYS(pfn)))
>>   		return 0;
>>   	if (!page_is_ram(pfn))
>>   		return 1;

Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>

I only see the reply so I'm assuming this is going in through some other 
tree, but LMK if you want it via the RISC-V tree as IIRC we're using it 
too.

Thanks!
