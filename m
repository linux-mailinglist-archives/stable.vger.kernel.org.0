Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CC4383D3E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhEQT1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbhEQT1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:27:12 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76719C061573;
        Mon, 17 May 2021 12:25:55 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id v6so8634399ljj.5;
        Mon, 17 May 2021 12:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uu1FDu9fGs5Pi33teMn7ZfwLLr8waPYX+ZIqVV1QiCg=;
        b=PiBFvUPgqtVxl+xiMFNQSDCJqXcn9ed/tGhQZAcCdjWqlWxcsk9F1jb9q0xb2uK/BO
         +1eQ88vsT6/wNIc1aCCzgStt/IdYhkIxH52juEeTLIfeZcHuSAi6Vk1tkPIznQ7qJiNf
         7v9y4ti3ZBjYHgaxgPtmYQ/Vk4MfrjzBP0E8i3nfAYWU/xJc5dTwQ9lCSpqzRCkFY8z7
         GfCd0DylNIzGzD5/IT+TRrhZr+9WnmJcgf1dXM8l30/t4HnBfvYykrtaMMZ+ZV8LRpCU
         ykKQnkM1+xti/4GAtS+dqjCTmPS8sy1b+T1ilMOVvv74+9c8B67Hr1P0y8EySdjgcojs
         GOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uu1FDu9fGs5Pi33teMn7ZfwLLr8waPYX+ZIqVV1QiCg=;
        b=eZKkwqLBLI4H8hKffyBCwrXsA7e2X7cSsSGnUuWWl0ar+OdDs53RimGgejkdhQzE1m
         E6Vmc9DfwGNOqcbHgjE3nZ/9tDqUTsnt28VdFwolr/cQwdgOeS1jEBrSrcpjP3JaemhU
         riHcufbidzVmtx+PaLhYTsb6A1+cj/aWIyz8NpJQGfmZgN7VfJifXS44Rm1zqGOFIZ8O
         e7HfYgjGVeTAMKk6GGNYHg7+OXqIrSDFBzpxlx49t1ej16Y69OPAkK/+ULlciz/aV4b3
         QmjZjAFeZ5LUDallrpRtcbj4G22qIdpRbP0x7zBce44Tzh5qyGjSmtAtJY8/oL0BtHAF
         n7gQ==
X-Gm-Message-State: AOAM531xZcF5MjUR3pHeJ12hSQsKYTAiGD3R/dvQN3ifknw51+siJCfA
        xyX9LBKjNFOaHJaEg7+DQ9l95HhDTuY=
X-Google-Smtp-Source: ABdhPJxp2QOGsnmEnlQRU/ADYLvdAILbnamoueNzhGdqbJERogp1LTDuu652SO6NNTeAAagYkgj7ig==
X-Received: by 2002:a2e:b8c9:: with SMTP id s9mr760554ljp.422.1621279553536;
        Mon, 17 May 2021 12:25:53 -0700 (PDT)
Received: from [10.17.0.15] ([37.58.58.229])
        by smtp.gmail.com with ESMTPSA id t24sm1632410lfk.198.2021.05.17.12.25.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 12:25:53 -0700 (PDT)
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
To:     Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        David Laight <David.Laight@aculab.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <87a6otfblh.ffs@nanos.tec.linutronix.de>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <b509418f-9fff-ab27-b460-ecbe6fdea09a@gmail.com>
Date:   Mon, 17 May 2021 21:25:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87a6otfblh.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/17/21 8:40 PM, Thomas Gleixner wrote:
> Max,
> 
> On Sat, May 15 2021 at 00:47, Maximilian Luz wrote:
>> I believe the theory was that, while the PIC is advertised in ACPI, it
>> might be expected to not be used and only present for some legacy reason
>> (therefore untested and buggy). Which I believe led to the question
>> whether we shouldn't prefer IOAPIC on systems like that in general. So I
>> guess it comes down to how you define "systems like that". By Tomas'
>> comment, I guess it should be possible to implement this as "systems
>> that should prefer IOAPIC over legacy PIC" quirk.
>>
>> I guess all modern machines should have an IOAPIC, so it might also be
>> preferable to expand that definition, maybe over time and with enough
>> testing.
> 
> I just double checked and we actually can boot just fine without the
> PIC even when it is advertised, but disfunctional.
> 
> Can you please add "apic=verbose" to the kernel command line and provide
> full dmesg output for a kernel w/o your patch and one with your patch
> applied?

I don't actually own an affected device, but I'm sure Sachi can provide
you with that.

As far as we can tell, due to the NULL PIC being chosen nr_legacy_irqs()
returns 0. That in turn causes mp_check_pin_attr() to return false
because is_level and active_low don't seem to match the expected values.
That check is essentially ignored if nr_legacy_irqs() returns a high
enough value. I guess that might also be a firmware bug here? Not sure
where the expected values come from.

Due to this, mp_map_pin_to_irq() fails with -EBUSY which causes
acpi_register_gsi() to fail. That fails in acpi_dev_get_irqresource(),
which causes the IRQ resource to be marked as disabled.

Down the line, this then causes platform_get_irq() to return -EINVAL,
because the IRQ we're trying to get has the IORESOURCE_DISABLED bit set.

Sachi can probably walk you through this a bit better as she's the one
who tracked this down. See also [1, 2] and following comments.

Regards,
Max

[1]: https://github.com/linux-surface/linux-surface/issues/425#issuecomment-835309201
[2]: https://github.com/linux-surface/linux-surface/issues/425#issuecomment-835261784
