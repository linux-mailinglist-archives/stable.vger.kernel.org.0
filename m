Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0055BAAEB
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiIPKXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbiIPKWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:22:38 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CA9AB419
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 03:14:09 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t3so20996672ply.2
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 03:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date;
        bh=WnyaOUdAwdhGuoSKLMfkbnLqHMb9GaEy8+agcHeprAI=;
        b=xmHCXH3dTxhVEmwtulDTy0FW3GI+mBURqnSKifdSV7+MLBOutTkM5dQODvOUVUvqLS
         oDQV9aBR5ScVl0jhjWIm3brnnn70tx2HautlFeOoWxjqYcltpdWZLta8YcjKgGyNKF3K
         g3OXC4Tml26FpWo3ZO5cL6KqRP4JppBqKS/oOyrC+CTzPegpPhiBcCeMl7yxd6GbiF3G
         SlFKy4pj1ESBlSPJf1PuLUhgDf/SNYLea2ODxtmRA5UNESE3IrbvpMp3a/ZBhcp7MZDs
         AQWxRtv1yhUpu8c1oPCCl17LWNavc4CeknjE2+S1D7OBL9lN3XV53qaTMZvQccR9xMtc
         Hfbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date;
        bh=WnyaOUdAwdhGuoSKLMfkbnLqHMb9GaEy8+agcHeprAI=;
        b=sYegMdGjJ0nB4FtYPYJk2PG5K/eMUBdzb8+jkXY3OXB7A+XIuhdn0p6npjqUGnQIwD
         w6Cg7LLceBAXKUIfZHkRMg8hmPeR+8zsxvIQGdNQ6PN0+DCYvGx6BZoUyfavzVRU6eqV
         ixybDsmyiQzQ+dwGb2n65dGm09TMMHk7jd/01iAmhB3ldyQirebdtYKwyVWJhvm8jTu1
         /RYBXl3v47xnP42qTV8rBx9URPgXbGeq9bF2CtF3wNldk7fjm/Is8XmUleXG4ebwvf2m
         2Tz2QZ+u4qFtuXD1YqHFoyLzD10cpPcso4bdFQL9pewJjRbkvFgzFTREYKTbP3Oo8OY4
         8rXg==
X-Gm-Message-State: ACrzQf0WtC6BMAffToLEcxmEe6mGy4Tc7eW7dVys6BsjBjugiF2mLoHv
        rBcL+iM76J4/5ABP6Kp71BxXyw==
X-Google-Smtp-Source: AMsMyM7mukMH3VIw7Jn1b0Hb7d6os4h7bvv+ti/v3OQfATonGq3E8RiNw4cBut+RC1P1lFLmmKwVgQ==
X-Received: by 2002:a17:902:e14c:b0:177:e7be:2ab6 with SMTP id d12-20020a170902e14c00b00177e7be2ab6mr3974874pla.25.1663323235120;
        Fri, 16 Sep 2022 03:13:55 -0700 (PDT)
Received: from localhost (guests-out.ms.mff.cuni.cz. [195.113.20.231])
        by smtp.gmail.com with ESMTPSA id q1-20020aa78421000000b0054ad9c6b70fsm1144259pfn.8.2022.09.16.03.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 03:13:54 -0700 (PDT)
Date:   Fri, 16 Sep 2022 03:13:54 -0700 (PDT)
X-Google-Original-Date: Fri, 16 Sep 2022 03:03:57 PDT (-0700)
Subject:     Re: [PATCH] RISC-V: Avoid coupling the T-Head CMOs and Zicbom
In-Reply-To: <2123713.Mh6RI2rZIc@phil>
CC:     linux-riscv@lists.infradead.org, stable@vger.kernel.org,
        lkp@intel.com, conor.dooley@microchip.com
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     heiko@sntech.de
Message-ID: <mhng-ccfa026e-f1ec-4266-bda0-5cf07d7b47a3@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Sep 2022 14:15:13 PDT (-0700), heiko@sntech.de wrote:
> Am Donnerstag, 15. September 2022, 19:09:00 CEST schrieb Palmer Dabbelt:
>> We could make the T-Head CMOs depend on a new-enough assembler to have
>> Zicbom, but it's not strictly necessary because the T-Head CMOs
>> circumvent the assembler.
>>
>> Fixes: 8f7e001e0325 ("RISC-V: Clean up the Zicbom block size probing")
>> Cc: stable@vger.kernel.org
>> Reported-by: kernel test robot <lkp@intel.com>
>> Reported-by: Conor Dooley <conor.dooley@microchip.com>
>> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>

Thanks, this is on fixes (a little late this week due to the 
conferences, but I'm still hoping for rc6).

>
>> ---
>>  arch/riscv/include/asm/cacheflush.h | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
>> index a89c005b4bbf..273ece6b622f 100644
>> --- a/arch/riscv/include/asm/cacheflush.h
>> +++ b/arch/riscv/include/asm/cacheflush.h
>> @@ -42,8 +42,12 @@ void flush_icache_mm(struct mm_struct *mm, bool local);
>>
>>  #endif /* CONFIG_SMP */
>>
>> -#ifdef CONFIG_RISCV_ISA_ZICBOM
>> +/*
>> + * The T-Head CMO errata internally probe the CBOM block size, but otherwise
>> + * don't depend on Zicbom.
>> + */
>>  extern unsigned int riscv_cbom_block_size;
>> +#ifdef CONFIG_RISCV_ISA_ZICBOM
>>  void riscv_init_cbom_blocksize(void);
>>  #else
>>  static inline void riscv_init_cbom_blocksize(void) { }
>>
