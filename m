Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806EB2D3C16
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 08:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgLIHW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 02:22:26 -0500
Received: from mail-ej1-f47.google.com ([209.85.218.47]:37907 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgLIHW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 02:22:26 -0500
Received: by mail-ej1-f47.google.com with SMTP id a16so625847ejj.5
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 23:22:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zKreOXQg8Zew2FOkd7kR5R18DPUcCLB8b6VPYDaoryU=;
        b=IDGPuMwnD01rbkRJBU3naebqldfaNIm1mwHOxjiHINXFCW5ZfFildbM9+9+GUahhZJ
         JfQZT4XTUBTtnDMIZl4CahQnTiPnSc8pO6ZVkniQtVwOQeVEU49oL/8O2lYkMQLnSffQ
         mjp3hYMzRzpHZLdcVCm6Snpf+S1hjJbtiVEAYyrtawRxrahMPtvWVs98Xbl4cgKstHQZ
         7G09xKmK/L0mZyLOMAU43LnOxUvzyKC6iR0jOk0BlhkKpJwX+coJFkrUsKwtUnkshTRR
         +VPxw0GNwU6tCPvjDoBFsubecBUWl6hnVa0iowy6xleN+dkMnXnOCyN/sjqigiVd6jLN
         1LpA==
X-Gm-Message-State: AOAM531ttOOB8JAdFYJ1PbGf19XNfI9jn1EOfD/wpW+DR6u4DZjTpTv1
        OwOhkAdDnCU92Lakredi8rI=
X-Google-Smtp-Source: ABdhPJxIgm0Dp8dwPVybk5Qs+kL7S9DlS9s7hm3yDKsgMo33AJ7bJmP4sxuCToLpd5nkmH6DhQRdDg==
X-Received: by 2002:a17:906:1c8e:: with SMTP id g14mr941266ejh.5.1607498504678;
        Tue, 08 Dec 2020 23:21:44 -0800 (PST)
Received: from ?IPv6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id be6sm675122edb.29.2020.12.08.23.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 23:21:44 -0800 (PST)
Subject: Re: 5.4 and 4.19 fix for LLVM_IAS/clang-12
From:   Jiri Slaby <jirislaby@kernel.org>
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
 <a3b89f95-2635-ff9d-4248-4e5e3065ff85@kernel.org>
Message-ID: <e9695da9-8b83-39a5-8781-47ae4c7d2e51@kernel.org>
Date:   Wed, 9 Dec 2020 08:21:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <a3b89f95-2635-ff9d-4248-4e5e3065ff85@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09. 12. 20, 8:20, Jiri Slaby wrote:
> On 09. 12. 20, 1:12, Nick Desaulniers wrote:
>> Dear stable kernel maintainers,
>> Please consider accepting the following backport to 5.4 and 4.19 of
>> commit 4d6ffa27b8e5 ("x86/lib: Change .weak to SYM_FUNC_START_WEAK for
>> arch/x86/lib/mem*_64.S"), attached.
>>
>> The patch to 5.4 had a conflict due to 5.4 missing upstream commit
>> e9b9d020c487 ("x86/asm: Annotate aliases") which first landed in
>> v5.5-rc1.
>>
>> The patch to 4.19 had a conflict due to 4.19 missing the above commit
>> and ffedeeb780dc ("linkage: Introduce new macros for assembler
>> symbols") which also first landed in v5.5-rc1 but was backported to
>> linux-5.4.y as commit 840d8c9b3e5f ("linkage: Introduce new macros for
>> assembler symbols") which shipped in v5.4.76.
>>
>> This patch fixes a build error from clang's assembler when building
>> with Clang-12, which now errors when symbols are redeclared with
>> different bindings.  We're using clang's assembler in Android and
>> ChromeOS for 4.19+.
>>
>> Jiri, would you mind reviewing the 4.19 patch (or both)?  It simply
>> open codes what the upstream macros would expand to; this can be and
>> was observed from running:
> 
> You don't have to touch (expand) __memcpy, __memmove, and __memset, right?

Also, no need for doubled p2align.

> thanks,
-- 
js
