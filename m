Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D840F2D3C14
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 08:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgLIHV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 02:21:29 -0500
Received: from mail-ed1-f41.google.com ([209.85.208.41]:39521 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgLIHV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 02:21:28 -0500
Received: by mail-ed1-f41.google.com with SMTP id c7so428753edv.6
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 23:21:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=92AeNRUXg5xWNtA0Bq+jXru7Ri7Z6DdahD+32tZ2ilQ=;
        b=o5jQA+UeIsTM1rYsQ/fdGXALAP9CYjwD/yA5fUKtm8f/jR0eoPx8ArqTB6lkj4OpZn
         hnzJ1URGXD85CqiBLPip8xAoRAtCyLsZYinm0QnF71zkDz7nlMESRBMvoUo1ImWaCrHt
         pCsk2R2XQGVtjl9WemQdvXYxZn+AQBX26FbGaqm+dVtvTfLLRgK+wWI9KS0bE4vobgjb
         g8tdYtVG/ByiPIcKzG9Z/mmKO4ThxktAYoGSjgLo68KFiyeNJdQhFn0x+CPoz5rKs/E5
         aIODPMmowKcIhYdRZN+3XcvOv2s7TziHd1nS4K/zu1eEcfADIbOQzINX48ntGOMe3uFK
         siUA==
X-Gm-Message-State: AOAM530ZahCsFR6Hsqni+xq9TzjZWcNDe9aV/LWdVm7vVPY4GzKMrlT+
        Gf6JfivnfBfTg9jWpZv1pR4=
X-Google-Smtp-Source: ABdhPJzzHyxOK/j2RA9OUA4wNN4NnxSwBeh17cRlQ2i750qr/j7xqHrlC2yZ/CZIHOFxOlDFEVwilA==
X-Received: by 2002:a05:6402:d08:: with SMTP id eb8mr757712edb.271.1607498446870;
        Tue, 08 Dec 2020 23:20:46 -0800 (PST)
Received: from ?IPv6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id q4sm602546ejc.78.2020.12.08.23.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 23:20:46 -0800 (PST)
Subject: Re: 5.4 and 4.19 fix for LLVM_IAS/clang-12
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>, Jian Cai <jiancai@google.com>,
        Fangrui Song <maskray@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Borislav Petkov <bp@suse.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
References: <CAKwvOdkK1LgLC4ChptzUTC45WvE9-Sn0OqtgF7-odNSw8xLTYA@mail.gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <a3b89f95-2635-ff9d-4248-4e5e3065ff85@kernel.org>
Date:   Wed, 9 Dec 2020 08:20:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdkK1LgLC4ChptzUTC45WvE9-Sn0OqtgF7-odNSw8xLTYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09. 12. 20, 1:12, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> Please consider accepting the following backport to 5.4 and 4.19 of
> commit 4d6ffa27b8e5 ("x86/lib: Change .weak to SYM_FUNC_START_WEAK for
> arch/x86/lib/mem*_64.S"), attached.
> 
> The patch to 5.4 had a conflict due to 5.4 missing upstream commit
> e9b9d020c487 ("x86/asm: Annotate aliases") which first landed in
> v5.5-rc1.
> 
> The patch to 4.19 had a conflict due to 4.19 missing the above commit
> and ffedeeb780dc ("linkage: Introduce new macros for assembler
> symbols") which also first landed in v5.5-rc1 but was backported to
> linux-5.4.y as commit 840d8c9b3e5f ("linkage: Introduce new macros for
> assembler symbols") which shipped in v5.4.76.
> 
> This patch fixes a build error from clang's assembler when building
> with Clang-12, which now errors when symbols are redeclared with
> different bindings.  We're using clang's assembler in Android and
> ChromeOS for 4.19+.
> 
> Jiri, would you mind reviewing the 4.19 patch (or both)?  It simply
> open codes what the upstream macros would expand to; this can be and
> was observed from running:

You don't have to touch (expand) __memcpy, __memmove, and __memset, right?

thanks,
-- 
js
suse labs
