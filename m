Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5C144EFD5
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 23:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhKLW7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 17:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhKLW7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 17:59:41 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2319C061766;
        Fri, 12 Nov 2021 14:56:50 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n23so9183101pgh.8;
        Fri, 12 Nov 2021 14:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yKPJvsR7pC33xxfU3bfcdvnOg23aMO1e3URcLdTsAyw=;
        b=SoCPUYPfxgg0tNVaYaaRrOAisiTHEw4Vij+/4tvkfqbwY3TTsOPlzuTS4abIEksL9q
         ywC8lCa96V5pq2xFkr+RnbjGp/83jZ4ZwDkbaQNh7q2gyYWIVWSgwAYwMCQ98qT+t/hf
         GzP86p4btP+qENQvtq006Qupkgq9RhgmvVYpEai5S+obsKNltVdOX0mywGFaWdFtCUMI
         U6OYyRomsNAdNuTFclIaSFQi6dpcgnPKH5udLi10V8Xobq1PNrUDfl26tFpS7dlAdKKY
         mQAjh3tLUKUqrIrBrY3W8ZKKO4WbGyAU5cDrFDu4chnXx34md97qWA9zYpr+fQf9v87/
         Sclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yKPJvsR7pC33xxfU3bfcdvnOg23aMO1e3URcLdTsAyw=;
        b=omVtZyrhaZgXFKekFCNrGOVfH67gzkzcs/NxFSW4Llwy2ZVWscajfjKAJOdi/qcPxs
         ojJwnSIUyI50pwATVExiwftHA2nW0CbnKmjJXMBnKp7Un0WNb4G8R0Ybae0vZZpZKh0G
         9al/bj+LrJHrYlanALdpcTsV+5Lt+lg6fkdX7mX3uuZRR3mLDNXY7wDz4ZqpS9hcL5aY
         48LUcCSUGki3WKplwXoTsokiqD9gC+NUgvQA931FHSrx1ojifjgrDnPWRki/NiwbA+TJ
         1tj7/Ap1jDdl+UF3TbrAurTvWPHtGu9ODMtlRXon4FOWt0f9NBkyfiDDFX62GX69lMZY
         jOkg==
X-Gm-Message-State: AOAM532BBIm95DihACCHD6ZSSb+ujs5J4AwJoQ4kBb3XKB6FAsUG6ROB
        ascTOC4ieJHEe4OmEGFv9Pygw/4HSAw=
X-Google-Smtp-Source: ABdhPJwRgIXwrQqAddCsNcG4+i2RoVefNg+clm540cnFK14oSYZ/JPif77kbUE2Ub2KoyCHc1PcwCQ==
X-Received: by 2002:a62:ae0f:0:b0:481:7fe:c719 with SMTP id q15-20020a62ae0f000000b0048107fec719mr17335971pff.14.1636757810191;
        Fri, 12 Nov 2021 14:56:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f15sm8258918pfe.171.2021.11.12.14.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 14:56:48 -0800 (PST)
Subject: Re: [PATCH 5.10 01/77] ARM: 9132/1: Fix __get_user_check failure with
 ARM KASAN images
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Lexi Shao <shaolexi@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
References: <20211101082511.254155853@linuxfoundation.org>
 <20211101082511.523745713@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5ea7d722-3f95-6c26-edb2-4b6a82fdbb38@gmail.com>
Date:   Fri, 12 Nov 2021 14:56:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211101082511.523745713@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/21 2:16 AM, Greg Kroah-Hartman wrote:
> From: Lexi Shao <shaolexi@huawei.com>
> 
> commit df909df0770779f1a5560c2bb641a2809655ef28 upstream.
> 
> ARM: kasan: Fix __get_user_check failure with kasan
> 
> In macro __get_user_check defined in arch/arm/include/asm/uaccess.h,
> error code is store in register int __e(r0). When kasan is
> enabled, assigning value to kernel address might trigger kasan check,
> which unexpectedly overwrites r0 and causes undefined behavior on arm
> kasan images.
> 
> One example is failure in do_futex and results in process soft lockup.
> Log:
> watchdog: BUG: soft lockup - CPU#0 stuck for 62946ms! [rs:main
> Q:Reg:1151]
> ...
> (__asan_store4) from (futex_wait_setup+0xf8/0x2b4)
> (futex_wait_setup) from (futex_wait+0x138/0x394)
> (futex_wait) from (do_futex+0x164/0xe40)
> (do_futex) from (sys_futex_time32+0x178/0x230)
> (sys_futex_time32) from (ret_fast_syscall+0x0/0x50)
> 
> The soft lockup happens in function futex_wait_setup. The reason is
> function get_futex_value_locked always return EINVAL, thus pc jump
> back to retry label and causes looping.
> 
> This line in function get_futex_value_locked
> 	ret = __get_user(*dest, from);
> is expanded to
> 	*dest = (typeof(*(p))) __r2; ,
> in macro __get_user_check. Writing to pointer dest triggers kasan check
> and overwrites the return value of __get_user_x function.
> The assembly code of get_futex_value_locked in kernel/futex.c:
> ...
> c01f6dc8:       eb0b020e        bl      c04b7608 <__get_user_4>
> // "x = (typeof(*(p))) __r2;" triggers kasan check and r0 is overwritten
> c01f6dCc:       e1a00007        mov     r0, r7
> c01f6dd0:       e1a05002        mov     r5, r2
> c01f6dd4:       eb04f1e6        bl      c0333574 <__asan_store4>
> c01f6dd8:       e5875000        str     r5, [r7]
> // save ret value of __get_user(*dest, from), which is dest address now
> c01f6ddc:       e1a05000        mov     r5, r0
> ...
> // checking return value of __get_user failed
> c01f6e00:       e3550000        cmp     r5, #0
> ...
> c01f6e0c:       01a00005        moveq   r0, r5
> // assign return value to EINVAL
> c01f6e10:       13e0000d        mvnne   r0, #13
> 
> Return value is the destination address of get_user thus certainly
> non-zero, so get_futex_value_locked always return EINVAL.
> 
> Fix it by using a tmp vairable to store the error code before the
> assignment. This fix has no effects to non-kasan images thanks to compiler
> optimization. It only affects cases that overwrite r0 due to kasan check.
> 
> This should fix bug discussed in Link:
> [1] https://lore.kernel.org/linux-arm-kernel/0ef7c2a5-5d8b-c5e0-63fa-31693fd4495c@gmail.com/
> 
> Fixes: 421015713b30 ("ARM: 9017/2: Enable KASan for ARM")

421015713b30 ("ARM: 9017/2: Enable KASan for ARM") is only in 5.11 and
beyond, do we want to take this patch still? I already tested the whole
v5.10.77-rc1 and did not have problems.
-- 
Florian
