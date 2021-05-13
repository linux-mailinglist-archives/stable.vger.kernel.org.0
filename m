Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA3B37F55E
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhEMKNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhEMKNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 06:13:06 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A45C061574;
        Thu, 13 May 2021 03:11:55 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id b11-20020a7bc24b0000b0290148da0694ffso1096909wmj.2;
        Thu, 13 May 2021 03:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=La321s4CZU0bPmAeqpbhR07/5MbTy0zEdX1bFYFt688=;
        b=FXl490aa2FwvDKZV/tDAkD3/iELc/MtK7XHteo9p3C9q3RSdEOS1rh+LWMO5RMWq9g
         8VGNNA7zfDxEkywwfSsXGyX6bLAYcwE+kwHSFqLkCqODOgvYBbsTL2+6GGIM1aZG/yn0
         qLpiCBtg0oSQ3ampNK35mdOWKSx2S94lRoVGjWmwY9mF5qf7SImVaPjPWbNr2GIXSsJ4
         TfENxE292YaUqq9IWkKrlakC3e8voEsR84in4nPmPc2siszJga+h8YlK336my0JKPx5p
         0acjVLGkKbzcLP2yD4Qfj3U3InfCbCWqt7lyvSNoQvAVspctIv79nmxEh81LT151z6/Y
         t/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=La321s4CZU0bPmAeqpbhR07/5MbTy0zEdX1bFYFt688=;
        b=rWA9YrZ0I+4fyYoqOLW3bmPh/9FZ/e2Wlu6UJOcaDUWobOTqItOM8MnAjacbMKAvvU
         Pi6UGVcSlnso7CotprOQ3Mt25ZvP6OraxFVqYGAAUMSqn+kXYiAIBM3NLUuBd5BGmdJn
         /Bvtkq6rIl0N6ELuyDUFPODD9rdS7WUeO8GKu3OIvmBPYojWmxTJ2obC1B7e5PzRrEgD
         YOSR6FuWdWUkHCwO6iztwaBwoTxp7uAKRZJgEImQIhdE/TZqWWILLBAHp9Iu2PAlNnW9
         FIB/frBaF4nM2ScOLvwErfcO+i/u11OwX9YLpFNAepG2v9T5jHmpDR56c2uenQyGxnZS
         jYqw==
X-Gm-Message-State: AOAM53004FsUsDqkHqQF6qV4xImWL00eW7mmvwszhmyqxw78lUc3hgBG
        M9uRJkXy3xKyGHdr9X4Kcj+sy0bWwh4=
X-Google-Smtp-Source: ABdhPJyAVt9wUEBJ+hKtnp2rP5Mba9w1wMUrlHFR7B1w0feeMo8Wgb9UCHVAoyyVcotuN35yR7K/ow==
X-Received: by 2002:a1c:7419:: with SMTP id p25mr3047896wmc.79.1620900713557;
        Thu, 13 May 2021 03:11:53 -0700 (PDT)
Received: from [192.168.2.202] (pd9e5a254.dip0.t-ipconnect.de. [217.229.162.84])
        by smtp.gmail.com with ESMTPSA id c14sm2341108wrt.77.2021.05.13.03.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 03:11:53 -0700 (PDT)
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
To:     David Laight <David.Laight@ACULAB.COM>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com>
 <9b70d8113c084848b8d9293c4428d71b@AcuMS.aculab.com>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
Date:   Thu, 13 May 2021 12:11:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <9b70d8113c084848b8d9293c4428d71b@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/21 10:10 AM, David Laight wrote:
> From: Maximilian Luz
>> Sent: 12 May 2021 22:05
>>
>> The legacy PIC on the AMD variant of the Microsoft Surface Laptop 4 has
>> some problems on boot. For some reason it consistently does not respond
>> on the first try, requiring a couple more tries before it finally
>> responds.
> 
> That seems very strange, something else must be going on that causes the grief.
> The 8259 will be built into to the one of the cpu support chips.
> I can't imagine that requires anything special.

Right, it's definitely strange. Both Sachi (I imagine) and I don't know
much about these devices, so we're open for suggestions.

For reference: [1] and following comments are the discussion where we
(mostly Sachi) discovered the issue, tracking this from
platform_get_irq() returning -EINVAL to the PIC not probing. It also has
a dmesg log [2] attached, but as far as we can tell

     [    0.105820] Using NULL legacy PIC

is the only relevant line to that in there.

And lastly, if that's any help at all: The PIC device is described in
ACPI in [3]. The Surface Laptop 3 also has an AMD CPU (although a prior
generation) and has the PIC described in the exact same way (can also be
found in that repository), but doesn't exhibit that behavior (and
doesn't show the "Using NULL legacy PIC" line). I expect there's not
much you can change to that definition so that's probably irrelevant
here.

Again, I don't really know anything about these devices, so my guess
would be bad hardware revision or bad firmware revision. All I know is
that retrying seems to "fix" it.

> It's not as though you have a real 8259 - which even a 286 can
> break the inter-cycle recovery on (with the circuit from the
> application note).

Right, I imagine that's some emulation for legacy reasons?

Regards,
Max

[1]: https://github.com/linux-surface/linux-surface/issues/425#issuecomment-831921098
[2]: https://github.com/linux-surface/linux-surface/files/6421166/dmesg-2021-05-04_22-11.txt
[3]: https://github.com/linux-surface/acpidumps/blob/69d5ecc1954ea5e90829b8e33541308e7451e951/surface_laptop_4_amd/dsdt.dsl#L1201-L1221
