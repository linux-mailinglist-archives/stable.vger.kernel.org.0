Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3AD4DDF26
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbiCRQeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238699AbiCRQep (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:34:45 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158FB2B44AB;
        Fri, 18 Mar 2022 09:33:24 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id s11so9845067pfu.13;
        Fri, 18 Mar 2022 09:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uqrYEAfHuf0wkRq2lUVPpQU7SLLCnbhWn5P1zgSp4Bg=;
        b=R1/vtPVPNAd4IEpdhz5myyEIm9iMD3+XA9QE7WNd1sBvuqpROiSaqFP1S0oGPWNrzG
         PGCQrzB/2FPZvGr/1xYz8YX9h2oSuTlNd7Oy+PlWUPvhb3j1TxH1ckeLl406/S+NWmcJ
         wkQsEgHbk3jHkgZsdsOqccLo8TPqqoFxe6k+4LKC4KGzLBnYJC7i/FoQB96YRjpPiveU
         mvs2vu77/cWVVGgQCm3sdMt6/9nsmSXvTfha4tz8Vqs/7qJCoNV9w+9BZKFuFDWbf92+
         sj7+/F5rZerh2nOwLOt8Aoe0ijduzOyGSwVz2Y7hFxcv7A5Yi/b9O4hMhFTVJpYB5SVU
         kbNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uqrYEAfHuf0wkRq2lUVPpQU7SLLCnbhWn5P1zgSp4Bg=;
        b=dAq+5So2xFpSpArUkCAzy5pzocsEGdx64QbL2pMpzdZQSNP+E+2AiqFrT9t/h0K1XW
         yWS/OQGSbPSVoVq5eOZfNKCVBT2xjyf7X8nwSU+2S2ptkv88Bj0WqsIdlBNu29oJ82Pr
         CqcBchQek1qJ9LRlzMkcgLjWezEfDig3JY2/DZyytwqUGTvexBSfDvGSSxTUDfOVNPP/
         Y1d2CEh2rIVElKYAd+Hueh6qKyCOCq4rN2xVRyZ5rrAinXnQjsVrkq/n7+VrUq411tql
         4ptfKpOR/30yH7Z8zwITECxdMkbmJDcc9lmX+S4Iq6d1dQVjHDI7flEFkZdaJ8spLBEi
         m+Pw==
X-Gm-Message-State: AOAM533ROGWZmBob+50l1349beWIQ65B4s2NG8rD9xVlEVfowsn1DRMr
        IyciLj4E5Kx/NiyH9UPxGUA6R9d1law=
X-Google-Smtp-Source: ABdhPJw042wC/bNq7K+DZPJf38T7E06+6ptmzNuQb3ez5pbVNg6t3d2Mu4OF9TPdrjwA5alcpT+Jqg==
X-Received: by 2002:a63:1d6:0:b0:380:a063:660c with SMTP id 205-20020a6301d6000000b00380a063660cmr8538141pgb.149.1647621203368;
        Fri, 18 Mar 2022 09:33:23 -0700 (PDT)
Received: from [10.230.3.191] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id q2-20020a056a00084200b004f761a7287dsm10600535pfk.131.2022.03.18.09.33.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 09:33:22 -0700 (PDT)
Message-ID: <0721f050-d6db-ce33-3b59-465c75d73a24@gmail.com>
Date:   Fri, 18 Mar 2022 09:33:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.4 18/43] arm64: entry: Add macro for reading symbol
 addresses from the trampoline
Content-Language: en-US
To:     James Morse <james.morse@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
References: <20220317124527.672236844@linuxfoundation.org>
 <20220317124528.180267687@linuxfoundation.org>
 <113e7675-4263-2a20-81d0-9634f03511d2@gmail.com>
 <bc35996d-ec18-1923-38f4-81d16ed98b7a@arm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <bc35996d-ec18-1923-38f4-81d16ed98b7a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/18/2022 5:11 AM, James Morse wrote:
> Hi Florian,
> 
> On 3/17/22 8:48 PM, Florian Fainelli wrote:
>> On 3/17/22 5:45 AM, Greg Kroah-Hartman wrote:
>>> From: James Morse <james.morse@arm.com>
>>>
>>> commit b28a8eebe81c186fdb1a0078263b30576c8e1f42 upstream.
>>>
>>> The trampoline code needs to use the address of symbols in the wider
>>> kernel, e.g. vectors. PC-relative addressing wouldn't work as the
>>> trampoline code doesn't run at the address the linker expected.
>>>
>>> tramp_ventry uses a literal pool, unless CONFIG_RANDOMIZE_BASE is
>>> set, in which case it uses the data page as a literal pool because
>>> the data page can be unmapped when running in user-space, which is
>>> required for CPUs vulnerable to meltdown.
>>>
>>> Pull this logic out as a macro, instead of adding a third copy
>>> of it.
>>>
>>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>>> Signed-off-by: James Morse <james.morse@arm.com>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> This commit causes a linking failure with CONFIG_ARM_SDE_INTERFACE=y
>> enabled in the kernel:
>>
>>    LD      .tmp_vmlinux.kallsyms1
>> /local/users/fainelli/buildroot/output/arm64/host/bin/aarch64-linux-ld:
>> arch/arm64/kernel/entry.o: in function `__sdei_asm_exit_trampoline':
>> /local/users/fainelli/buildroot/output/arm64/build/linux-custom/arch/arm64/kernel/entry.S:1352: 
>>
>> undefined reference to `__sdei_asm_trampoline_next_handler'
>> make[2]: *** [Makefile:1100: vmlinux] Error 1
>> make[1]: *** [package/pkg-generic.mk:295:
>> /local/users/fainelli/buildroot/output/arm64/build/linux-custom/.stamp_built] 
>>
>> Error 2
>> make: *** [Makefile:27: _all] Error 2
> 
> ... and with CONFIG_RANDOMIZE_BASE turned off, which is why allyesconfig 
> didn't catch it.

Yes that is correct CONFIG_RANDOMIZE_BASE is turned off in the 
configuration file I used.

> This is because I kept the next_handler bit of the label when it 
> conflicted, which isn't needed
> because the __entry_tramp bit added by the macro serves the same purpose.
> 
> The below diff fixes it:
> ----------%<----------
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index e4b5a15c2e2e..cfc0bb6c49f7 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -1190,7 +1190,7 @@ __entry_tramp_data_start:
>   __entry_tramp_data_vectors:
>          .quad   vectors
>   #ifdef CONFIG_ARM_SDE_INTERFACE
> -__entry_tramp_data___sdei_asm_trampoline_next_handler:
> +__entry_tramp_data___sdei_asm_handler:
>          .quad   __sdei_asm_handler
>   #endif /* CONFIG_ARM_SDE_INTERFACE */
>          .popsection                             // .rodata
> @@ -1319,7 +1319,7 @@ ENTRY(__sdei_asm_entry_trampoline)
>           */
>   1:     str     x4, [x1, #(SDEI_EVENT_INTREGS + S_ORIG_ADDR_LIMIT)]
> 
> -       tramp_data_read_var     x4, __sdei_asm_trampoline_next_handler
> +       tramp_data_read_var     x4, __sdei_asm_handler
>          br      x4
>   ENDPROC(__sdei_asm_entry_trampoline)
>   NOKPROBE(__sdei_asm_entry_trampoline)
> ----------%<----------
> 
> Good news - this didn't happen with v5.10.
> 
> I don't see this in v5.4.185 yet.
> 
> Greg/Sasha, what is least work for you?:
> A new version of this patch,
> A fixup on top of the series,
> Reposting the series with this fixed.

FWIW, applying your patch on top of the entire 5.4.186-rc1 series will 
fail with some rejects so that would require you to fixup the patch 
instead, and then I suppose the whole -rc1 now becomes an -rc2?

> 
> 
> Thanks for catching this!

Thanks for the quick turnaround:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
