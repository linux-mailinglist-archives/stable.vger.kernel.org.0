Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FEF344C18
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 17:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhCVQqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 12:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhCVQqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 12:46:22 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB15C061574;
        Mon, 22 Mar 2021 09:46:21 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id e14so4188591ejz.11;
        Mon, 22 Mar 2021 09:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d7JTsRZDTyvobnenHB8H6TPts47SdiSa4dMkzBQDt/A=;
        b=WZ/U84EDYWGYWUPushVovk+XliN7OiAdqZ9vpkTO9eMOMHcupRFbcWnE0zCDxuiWl4
         q4G6tqCdtsMsYmUe9vJYjrHImeYXKy4PnXeBFlefVb/O8nqCGFFDQ5rr9m8rtjky1B8j
         qRFjiPRwzX4dzNj02Jvb4wMXbicaq1mQjVNUhvHWAI8ZzaFU6Dj6NM5JbgKOdG7lutdY
         qJVriEqW6veSayHuDnXYFs6Oi7szRhl6kqaeAEZjUcM3ZFq4qbCEdDtqk+Vr7B0wRYiD
         XUtPw0CaXPODCPUlMshj64jDLUtVMhoqq4PyeqyV30+kHvzQaB9OatKDihVbmfI+bULA
         xmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d7JTsRZDTyvobnenHB8H6TPts47SdiSa4dMkzBQDt/A=;
        b=gkY2FOkMLGhDA6/tXa0X68D6U0VbzMivlhqUQzepDT3cqlq9qT1NMayjADIbhfUCeF
         1dz3BasLLbxpvLyPW8RkfnO3QO1YrOJ2MLgKJpFhIgn1amK5l2n8/N57tOPbPVJoHmHn
         qJn0TqLQPnqmKqtCz9pGUu34TkFnyFYvV1TBss3iftpGMOqdAr7RZKutn7CviyhrGqcR
         YJhSKC49qH8/tFaeYX1C72PvJ2nwfB8aTpPoBfQek381mjx74R7UrJCVBncLRLHlG0K/
         AprKvd6r7dIDIWyt+h+5FqxweL+IqlZ9wgQlM59xzJJuAUpxzDWwInfhgm6e1Wu5X9LM
         GySQ==
X-Gm-Message-State: AOAM532OPAOt4PoFBuX6bgw8E3HRtmWWnaf6uSvFgr3nJ5v4WvuzfPyv
        Wb95z8MrjgVl1VC/MK0Gy7m6P3b0NPQ=
X-Google-Smtp-Source: ABdhPJwFm/AZdI/nT8M5nBXfMsXQTIVHiYBvm6qbRfEhrsdBVdlCSUl/rDRp5gxiPasURIZzbsHbSQ==
X-Received: by 2002:a17:906:7c4:: with SMTP id m4mr700648ejc.63.1616431579520;
        Mon, 22 Mar 2021 09:46:19 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ld19sm9874662ejb.102.2021.03.22.09.46.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 09:46:19 -0700 (PDT)
Subject: Re: [PATCH 5.10 103/157] MIPS: kernel: Reserve exception base early
 to prevent corruption
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Kamal Dasu <kdasu.kdev@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        lkft-triage@lists.linaro.org, linux-mips@vger.kernel.org
References: <20210322121933.746237845@linuxfoundation.org>
 <20210322121937.040307268@linuxfoundation.org>
 <CA+G9fYuSdE7U-D+mn82bR3e33NzpDEFsD9B6EgXAj3sKMLxfeQ@mail.gmail.com>
 <YFixCO3CMwh+TThB@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dda5fbda-e2a0-db06-e112-a07f05ddd388@gmail.com>
Date:   Mon, 22 Mar 2021 09:46:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YFixCO3CMwh+TThB@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/22/2021 8:00 AM, Greg Kroah-Hartman wrote:
> On Mon, Mar 22, 2021 at 07:44:05PM +0530, Naresh Kamboju wrote:
>> On Mon, 22 Mar 2021 at 18:14, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>>>
>>> [ Upstream commit bd67b711bfaa02cf19e88aa2d9edae5c1c1d2739 ]
>>>
>>> BMIPS is one of the few platforms that do change the exception base.
>>> After commit 2dcb39645441 ("memblock: do not start bottom-up allocations
>>> with kernel_end") we started seeing BMIPS boards fail to boot with the
>>> built-in FDT being corrupted.
>>>
>>> Before the cited commit, early allocations would be in the [kernel_end,
>>> RAM_END] range, but after commit they would be within [RAM_START +
>>> PAGE_SIZE, RAM_END].
>>>
>>> The custom exception base handler that is installed by
>>> bmips_ebase_setup() done for BMIPS5000 CPUs ends-up trampling on the
>>> memory region allocated by unflatten_and_copy_device_tree() thus
>>> corrupting the FDT used by the kernel.
>>>
>>> To fix this, we need to perform an early reservation of the custom
>>> exception space. Additional we reserve the first 4k (1k for R3k) for
>>> either normal exception vector space (legacy CPUs) or special vectors
>>> like cache exceptions.
>>>
>>> Huge thanks to Serge for analysing and proposing a solution to this
>>> issue.
>>>
>>> Fixes: 2dcb39645441 ("memblock: do not start bottom-up allocations with kernel_end")
>>> Reported-by: Kamal Dasu <kdasu.kdev@gmail.com>
>>> Debugged-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
>>> Acked-by: Mike Rapoport <rppt@linux.ibm.com>
>>> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
>>> Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
>>> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  arch/mips/include/asm/traps.h    |  3 +++
>>>  arch/mips/kernel/cpu-probe.c     |  6 ++++++
>>>  arch/mips/kernel/cpu-r3k-probe.c |  3 +++
>>>  arch/mips/kernel/traps.c         | 10 +++++-----
>>
>> mipc tinyconfig and allnoconfig builds failed on stable-rc 5.10 branch
>>
>> make --silent --keep-going --jobs=8
>> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=mips
>> CROSS_COMPILE=mips-linux-gnu- 'CC=sccache mips-linux-gnu-gcc'
>> 'HOSTCC=sccache gcc'
>> WARNING: modpost: vmlinux.o(.text+0x6a88): Section mismatch in
>> reference from the function reserve_exception_space() to the function
>> .meminit.text:memblock_reserve()
>> The function reserve_exception_space() references
>> the function __meminit memblock_reserve().
>> This is often because reserve_exception_space lacks a __meminit
>> annotation or the annotation of memblock_reserve is wrong.
>>
>> FATAL: modpost: Section mismatches detected.
>> Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
>> make[2]: *** [/builds/linux/scripts/Makefile.modpost:59:
>> vmlinux.symvers] Error 1
>>
>> Here is the list of build failed,
>>  - gcc-8-allnoconfig
>>  - gcc-8-tinyconfig
>>  - gcc-9-allnoconfig
>>  - gcc-9-tinyconfig
>>  - gcc-10-allnoconfig
>>  - gcc-10-tinyconfig
>>  - clang-10-tinyconfig
>>  - clang-10-allnoconfig
>>  - clang-11-allnoconfig
>>  - clang-11-tinyconfig
>>  - clang-12-tinyconfig
>>  - clang-12-allnoconfig
>>
>> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>>
>> link:
>> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1117167411#L142
>>
>> steps to reproduce:
>> ---------------------------
>> # TuxMake is a command line tool and Python library that provides
>> # portable and repeatable Linux kernel builds across a variety of
>> # architectures, toolchains, kernel configurations, and make targets.
>> #
>> # TuxMake supports the concept of runtimes.
>> # See https://docs.tuxmake.org/runtimes/, for that to work it requires
>> # that you install podman or docker on your system.
>> #
>> # To install tuxmake on your system globally:
>> # sudo pip3 install -U tuxmake
>> #
>> # See https://docs.tuxmake.org/ for complete documentation.
>>
>>
>> tuxmake --runtime podman --target-arch mips --toolchain gcc-10
>> --kconfig tinyconfig
>>
> 
> Thanks for letting me know, I'll go drop this and push out a new -rc...

2dcb39645441 ("memblock: do not start bottom-up allocations with
kernel_end") is only present in v5.11 AFAICT, so not applicable for
v5.10. I did not observe this problem on v5.10.
-- 
Florian
