Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C030291416
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439405AbgJQTPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 15:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439275AbgJQTPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 15:15:52 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB44AC061755;
        Sat, 17 Oct 2020 12:15:50 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id m20so6421003ljj.5;
        Sat, 17 Oct 2020 12:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1pDfRvE5t/wD9O6TX1BzomcWhFOCiJ7ybHvakZc7Cs8=;
        b=RWEJe4O6Gptbz6cUhZ1+gwg8FetxX0elzhmYmdIwQmNcrUMjIIfvj5vNtRbZsE30FA
         19BNxGCDCbMFnFl/OC9CMslTK3c01ODhU0AEw5VrDspDdsWy3otGoV5c7OnR9mn6OD0W
         LkiusyQPRnw2uTCjM5befx3UoNE7XLyiAgsc5eESzacWP+DmXs5mD4mpXIGIL0lLLd1u
         D0pwv7pL8jw80N4ISNcAL/zmPxI7MaV2WdlrJ1Gk5ss98d4eauI3vnyzumuuuQqYWtx1
         CZ3RaQShS9iLanLaM2f5exUxAIPvXLHg2l2niA55Q3M9V6wGR1eR73Lp4pc+3VKq2ogb
         jMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1pDfRvE5t/wD9O6TX1BzomcWhFOCiJ7ybHvakZc7Cs8=;
        b=Rz/BIiF3mVVN/1bBTc4GOEubGjLeAagmapLPAo5PwKxfP72XXQPrXn3xwSNuftCOpl
         aKcP57SxO1JYmF6TGpWH2YV5z+NVgOb56tKLPDyf2b0gOgMIl8LxAeGsCszU/OkvgAB0
         eggP7Y+BeV/LLdLRFNbEcwPv3xah0eNlbI8ynfiR3n9tOXnQN4K0FhL9loIbS21M9M0z
         1gUkODXDiWmJjfCf+sq+9qVO73tsHLtYlbFCf5mg8T7TqMff/jKvxxSaTX+M+4wmVN+S
         hDbgI+W85r6w+IMuZLyWCjshpwZbvZiEZvoxEoQlv7l2/GohoSStH3vOQG6UrFH1taSx
         3IlQ==
X-Gm-Message-State: AOAM53346+3H2PTHBChMpzvM3l4kQF07NiaIu8uVjen5hRbOO+3wYnib
        1TE4lJW2NEmDHCJDbGlQ91BKfk4ttwuBhw==
X-Google-Smtp-Source: ABdhPJwZPRkgmtwcjRHQfWqrJTh8ctpurvMHZB8H6WxkSyS6oplxryBX2xh3DPLl81qVNZRG8lVErA==
X-Received: by 2002:a2e:989a:: with SMTP id b26mr3378280ljj.276.1602962147703;
        Sat, 17 Oct 2020 12:15:47 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:44ab:aa29:cc3a:7ce3:762e:af0? ([2a00:1fa0:44ab:aa29:cc3a:7ce3:762e:af0])
        by smtp.gmail.com with ESMTPSA id r19sm750940ljn.73.2020.10.17.12.15.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 12:15:47 -0700 (PDT)
Subject: Re: [PATCH v3] ata: sata_rcar: Fix DMA boundary mask
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-ide@vger.kernel.org,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <20200917130920.6689-1-geert+renesas@glider.be>
 <CAHp75Vd3s1N_f9oM=MiMv6ZhtrOzYMKAQz+CURVkxG4JgGVw+Q@mail.gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <b9b74843-70ea-f53c-53cf-e929d0542d2c@gmail.com>
Date:   Sat, 17 Oct 2020 22:15:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAHp75Vd3s1N_f9oM=MiMv6ZhtrOzYMKAQz+CURVkxG4JgGVw+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/20 7:40 PM, Andy Shevchenko wrote:

>> Before commit 9495b7e92f716ab2 ("driver core: platform: Initialize
>> dma_parms for platform devices"), the R-Car SATA device didn't have DMA
>> parameters.  Hence the DMA boundary mask supplied by its driver was
>> silently ignored, as __scsi_init_queue() doesn't check the return value
>> of dma_set_seg_boundary(), and the default value of 0xffffffff was used.
>>
>> Now the device has gained DMA parameters, the driver-supplied value is
>> used, and the following warning is printed on Salvator-XS:
>>
>>     DMA-API: sata_rcar ee300000.sata: mapping sg segment across boundary [start=0x00000000ffffe000] [end=0x00000000ffffefff] [boundary=0x000000001ffffffe]
>>     WARNING: CPU: 5 PID: 38 at kernel/dma/debug.c:1233 debug_dma_map_sg+0x298/0x300
>>
>> (the range of start/end values depend on whether IOMMU support is
>>  enabled or not)
>>
>> The issue here is that SATA_RCAR_DMA_BOUNDARY doesn't have bit 0 set, so
>> any typical end value, which is odd, will trigger the check.
>>
>> Fix this by increasing the DMA boundary value by 1.
>>
>> This also fixes the following WRITE DMA EXT timeout issue:
>>
>>     # dd if=/dev/urandom of=/mnt/de1/file1-1024M bs=1M count=1024
>>     ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>>     ata1.00: failed command: WRITE DMA EXT
>>     ata1.00: cmd 35/00:00:00:e6:0c/00:0a:00:00:00/e0 tag 0 dma 1310720 out
>>     res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>     ata1.00: status: { DRDY }
>>
>> as seen by Shimoda-san since commit 429120f3df2dba2b ("block: fix
>> splitting segments on boundary masks").
>>
>> Fixes: 8bfbeed58665dbbf ("sata_rcar: correct 'sata_rcar_sht'")
>> Fixes: 9495b7e92f716ab2 ("driver core: platform: Initialize dma_parms for platform devices")
>> Fixes: 429120f3df2dba2b ("block: fix splitting segments on boundary masks")
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
>> Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>> Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>> Cc: stable <stable@vger.kernel.org>
>> ---
>> v3:
>>   - Add Reviewed-by, Tested-by,
>>   - Augment description and Fixes: with Shimoda-san's problem report
>>     https://lore.kernel.org/r/1600255098-21411-1-git-send-email-yoshihiro.shimoda.uh@renesas.com,
>>
>> v2:
>>   - Add Reviewed-by, Tested-by, Cc.
>> ---
>>  drivers/ata/sata_rcar.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
>> index 141ac600b64c87ef..44b0ed8f6bb8a120 100644
>> --- a/drivers/ata/sata_rcar.c
>> +++ b/drivers/ata/sata_rcar.c
>> @@ -120,7 +120,7 @@
>>  /* Descriptor table word 0 bit (when DTA32M = 1) */
>>  #define SATA_RCAR_DTEND                        BIT(0)
>>
>> -#define SATA_RCAR_DMA_BOUNDARY         0x1FFFFFFEUL
>> +#define SATA_RCAR_DMA_BOUNDARY         0x1FFFFFFFUL
> 
> Wondering if GENMASK() here will be better to avoid such mistakes.

   How? The bit 0 is reserved, so only even byte counts are possiblе...

[...]

MBR, Sergei
