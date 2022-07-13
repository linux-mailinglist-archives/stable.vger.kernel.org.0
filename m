Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F50572FBB
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 09:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbiGMHyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 03:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbiGMHyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 03:54:19 -0400
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88901DABA9;
        Wed, 13 Jul 2022 00:54:04 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id j22so18444189ejs.2;
        Wed, 13 Jul 2022 00:54:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=xyiAbcKEwIGxp7PBwRMpuDfi9s7uX1yxh0HxeedfbwY=;
        b=2Pg/tCdFnkc5SmWdfOe/jrRxLoWbXOgUjmMzwF4qbDHzOWDyN8eAeT9qeNy3wHbVep
         2sLeqWB3cpnfkpQ5afe4I9Vt36ABrnhmc1RAAUaJZgVxDCx8Z1Iy6pGj7hqhEOHYYAYF
         J+2L9Xm6mtMNoPC2B0WS6YTb8FdcXfYv/8iUkGu/K01JCvOrExYXu0R/2IsgbBu7LD9N
         wCHFSdJdltCXtW2GyHbZ+iKZthWAkchomGdbtlgxl8xW9Glkazf1r24APQ4k7bUt1UCb
         WqoCH0UHSo41+XtTT1QScuhDnqtqHG04Xoaz4So2aPZdXZz7YTOro/TViBZ+Cag7/z1I
         Mdcw==
X-Gm-Message-State: AJIora9epWkEiJwFqpx0xrVaPiZz/QHuYOeBVXejYLsmr+wyn2I/JO2C
        ZvgheGwRQ2jzYu1MCSbVttw=
X-Google-Smtp-Source: AGRyM1t8wbeI5BUtThwdeXpeOWbjFRWUgi+T55oMZagY1JleWDccVgbPhVCuqj2FQIiyW0HPopZXvw==
X-Received: by 2002:a17:906:84f0:b0:72b:5cf4:465d with SMTP id zp16-20020a17090684f000b0072b5cf4465dmr2141063ejb.705.1657698843269;
        Wed, 13 Jul 2022 00:54:03 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id h4-20020a50ed84000000b0043a85d7d15esm7396951edr.12.2022.07.13.00.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 00:54:02 -0700 (PDT)
Message-ID: <509dd891-73cc-31b9-18ac-2e930084c02f@kernel.org>
Date:   Wed, 13 Jul 2022 09:54:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.18 34/61] objtool: Update Retpoline validation
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
References: <20220712183236.931648980@linuxfoundation.org>
 <20220712183238.342232911@linuxfoundation.org>
 <63e23f80-033f-f64e-7522-2816debbc367@kernel.org>
In-Reply-To: <63e23f80-033f-f64e-7522-2816debbc367@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13. 07. 22, 9:45, Jiri Slaby wrote:
> On 12. 07. 22, 20:39, Greg Kroah-Hartman wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>>
>> commit 9bb2ec608a209018080ca262f771e6a9ff203b6f upstream.
>>
>> Update retpoline validation with the new CONFIG_RETPOLINE requirement of
>> not having bare naked RET instructions.
> 
> Hi,
> 
> this breaks compilation on i386:
>  > arch/x86/kernel/../../x86/xen/xen-head.S:35: Error: no such 
> instruction: `annotate_unret_safe'
> 
> Config:
> https://raw.githubusercontent.com/openSUSE/kernel-source/stable/config/i386/pae 
> 
> 
> And yeah, upstream¹⁾ is affected too.
> 
> ¹⁾I am at commit b047602d579b4fb028128a525f056bbdc890e7f0.

A naive fix is:
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -23,6 +23,7 @@
  #include <asm/cpufeatures.h>
  #include <asm/percpu.h>
  #include <asm/nops.h>
+#include <asm/nospec-branch.h>
  #include <asm/bootparam.h>
  #include <asm/export.h>
  #include <asm/pgtable_32.h>

The question (I don't know answer to) is whether x86_32 should actually 
do ANNOTATE_UNRET_SAFE.

thanks,
-- 
js
