Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F0E5BB8D0
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 16:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiIQOli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 10:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiIQOli (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 10:41:38 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3D52EF30
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 07:41:36 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z97so35339784ede.8
        for <stable@vger.kernel.org>; Sat, 17 Sep 2022 07:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date;
        bh=B7c48Z8IZiBzjAtTLrYPY8QrxbyK5DhJJQyC2Fi78rY=;
        b=DHKuitl1k5Dq4xohtm6Hc8tkHQviYn3xo84WZoWcPcUOwVw+q6v5AVFl1Qb5pDlLP6
         fsYfm8YFpC0KqcbZaG76v2X2w3GJ4Am4EfD+zBUIqKwc06SJlsWxhptRYSYBWixGzgiD
         7R7vnMI0OiQo6IqvEMkWpxIBoft4kWDWig6WjbFDaQWyfxSiZx8sd+8VM+gfmet+JiBX
         k67F/8pBSUQy9+wEQpdPseROfOvHXzIh78E9hy/QIIhT9Gmrgd/OHk/WiDEp2FPCu7uT
         8bqfbrjlNfvkkkd0kCm9z7wWmyfxExZmPmbbAgTRwvmkvb5Hi3fAv4SyUjQKRXz3r54e
         JrPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date;
        bh=B7c48Z8IZiBzjAtTLrYPY8QrxbyK5DhJJQyC2Fi78rY=;
        b=YxGK0J9eyh8RuEDUQ47uJxlfbe7maetGDdsg90Xx3u4UrpSNmjqlhfS4XI4P9Ofhwq
         gT4YIpjB1DU3bC6/gVoBumM/BJ+ssbKVOSbeIVXOrvsscLRDQ2RyS1Nt0zUt6Q4JxkRM
         arD06M+6xHhhHNRw1ITPIGS4FLlbiMipTCgTCoUPtvZ0YRcoY8/n/wjiRVItkMnmvOBU
         SR6QIr8hGE+w/tLEfnsUWmSiQy+zUOXRJJ2jIiNC4mzpcT+aQrCak0JO2Excc0UvJl5D
         4PjWpyIrn9utc0NUFJduBnvr2FEz/Jj3YB07rvZNzdokIONjp1qcduSgkE8JCnNMdCvd
         TdXQ==
X-Gm-Message-State: ACrzQf3Ly600IfaHhNDr6b00vnJtRyRDi62pPsSnHghLjOjCKo+HVdDc
        xkXFnd/CtAr2RXH1RBvY0HoaQg==
X-Google-Smtp-Source: AMsMyM4d1Aka8XgJxz0Zktp0Q3125bi/VgZwK3Dgx/cFNzeiVEtBEZ/yc+ZnRFbfRjJ0z9eItt9YdA==
X-Received: by 2002:aa7:cb18:0:b0:452:9071:aff with SMTP id s24-20020aa7cb18000000b0045290710affmr7909086edt.194.1663425695017;
        Sat, 17 Sep 2022 07:41:35 -0700 (PDT)
Received: from localhost (vpn-konference.ms.mff.cuni.cz. [195.113.20.101])
        by smtp.gmail.com with ESMTPSA id y9-20020a1709064b0900b0073d218af237sm12114436eju.216.2022.09.17.07.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 07:41:34 -0700 (PDT)
Date:   Sat, 17 Sep 2022 07:41:34 -0700 (PDT)
X-Google-Original-Date: Sat, 17 Sep 2022 04:30:08 PDT (-0700)
Subject:     Re: [PATCH] RISC-V: Avoid coupling the T-Head CMOs and Zicbom
In-Reply-To: <4d7ab3d1-72cc-f1cf-15bf-50bbb64837da@microchip.com>
CC:     linux-riscv@lists.infradead.org, stable@vger.kernel.org,
        lkp@intel.com
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     Conor.Dooley@microchip.com
Message-ID: <mhng-85fb2ed5-046c-4fd3-a703-b417bff95c57@palmer-ri-x1c9>
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

On Fri, 16 Sep 2022 05:22:59 PDT (-0700), Conor.Dooley@microchip.com wrote:
> On 15/09/2022 18:13, Conor Dooley wrote:
>> On 15/09/2022 18:09, Palmer Dabbelt wrote:
>>> We could make the T-Head CMOs depend on a new-enough assembler to have
>>> Zicbom, but it's not strictly necessary because the T-Head CMOs
>>> circumvent the assembler.
>>>
>>> Fixes: 8f7e001e0325 ("RISC-V: Clean up the Zicbom block size probing")
>>> Cc: stable@vger.kernel.org
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Reported-by: Conor Dooley <conor.dooley@microchip.com>
>> 
>> I build-tested this last night when I accidentally found it so:
>> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> 
> This is the one you I noticed you missed, msg-id is:
> 4d943291-f78f-31ed-0d67-7073e1f762e2@microchip.com

Sorry about that, the scripts to search for a Reviewed-by weren't 
handling the base64 encoding that Exchange was doing.  It should be 
fixed, at least it is for the test merge I just made.

> 
>> 
>>> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>>> ---
>>>   arch/riscv/include/asm/cacheflush.h | 6 +++++-
>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
>>> index a89c005b4bbf..273ece6b622f 100644
>>> --- a/arch/riscv/include/asm/cacheflush.h
>>> +++ b/arch/riscv/include/asm/cacheflush.h
>>> @@ -42,8 +42,12 @@ void flush_icache_mm(struct mm_struct *mm, bool local);
>>>   
>>>   #endif /* CONFIG_SMP */
>>>   
>>> -#ifdef CONFIG_RISCV_ISA_ZICBOM
>>> +/*
>>> + * The T-Head CMO errata internally probe the CBOM block size, but otherwise
>>> + * don't depend on Zicbom.
>>> + */
>>>   extern unsigned int riscv_cbom_block_size;
>>> +#ifdef CONFIG_RISCV_ISA_ZICBOM
>>>   void riscv_init_cbom_blocksize(void);
>>>   #else
>>>   static inline void riscv_init_cbom_blocksize(void) { }
> 
