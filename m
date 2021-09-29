Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D43B41CD4E
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 22:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346520AbhI2UUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 16:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346475AbhI2UUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 16:20:53 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E0EC061765
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 13:19:12 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id f15so3529091qtv.9
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 13:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=02EXaRR/LNadeGaGEAJYu9eu7Tm3d0AkQIYMMcAXP4c=;
        b=LE4/GyFbg6PDYrFzMabU3wOkVWt1bHu/gEgjJL5r//rlKzDS9g6ZiNQZLgEqE5952C
         dhL0UwiqvNKYDPPQwubbwnqD9mpLnpOEj3bv8j2jO1T9MAE3sZYwQ6v4I0zIsPKYyZ4O
         rdmxyzL/WT5dtPbI02l1h0ZBCIiueWXex102uRrAV0withKV6ROlvuDYxJP2cXQYBS2P
         MiqX0CMENIKK+QG5J5hg8kAfOm4AOlfDXgGFEFmsQPmHc89hK9HHWbd0922OIa0ky0DK
         +koVjJRzBZVdI1lt+yaJcdYnUZs9aEE637ZhmjvS56wbP/NlDDSnzSlUs5LBT01p5N49
         lXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=02EXaRR/LNadeGaGEAJYu9eu7Tm3d0AkQIYMMcAXP4c=;
        b=U1JSIrt457bRPORKXrxQt1CHuRsndKhqWwzl7ovO44XajrAkRfCD+GGbildNtWFFTO
         zvjGaNcsE4FcTOmCl5IC00fcGopfHwwHmsDPXqF61XpIRH9svBRwEpO7LZvN42RGv5Yj
         2WcGSkp6Q9mvM8UZksAxl3wQBG9tl23Esh4Wskl2G717D9c91Xl/g62WAr3UY0yYLHqI
         qkJyQkdl+JYbHruqY5J3H26GA0L5GIVnHE3CaRsKQ8UYSBgLW+FTbp0uCF/Lclhi087J
         sFgqYq6nDCaAQf+coWYav+FV3IJKUh0zvFN/8w0TOMoiQOKA5sC7ytk46Zq4qYh/gO3h
         5lvw==
X-Gm-Message-State: AOAM531OmFSL3FcAa2NQE90z5he+4Gh7X1gx2M7ajK9wCHfN35+4zWbX
        nxSZDQiMETTAT6YpONSqvuBMDg==
X-Google-Smtp-Source: ABdhPJwtTleKCd4n65jPyiBJ5xy5JKPI3hEe5Ya8CJPORXD/cexXVJrGJWxaT2KgbAuRKQXmDeCx3Q==
X-Received: by 2002:ac8:4243:: with SMTP id r3mr2223327qtm.187.1632946751266;
        Wed, 29 Sep 2021 13:19:11 -0700 (PDT)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id z10sm485338qtv.6.2021.09.29.13.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 13:19:10 -0700 (PDT)
Subject: Re: [PATCH] nbd: use shifts rather than multiplies
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, nbd@other.debian.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20210920232533.4092046-1-ndesaulniers@google.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <079a17e7-6cf1-7632-bf12-1df0edf4f93a@toxicpanda.com>
Date:   Wed, 29 Sep 2021 16:19:09 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210920232533.4092046-1-ndesaulniers@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 7:25 PM, Nick Desaulniers wrote:
> commit fad7cd3310db ("nbd: add the check to prevent overflow in
> __nbd_ioctl()") raised an issue from the fallback helpers added in
> commit f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
> add fallback code")
> 
> ERROR: modpost: "__divdi3" [drivers/block/nbd.ko] undefined!
> 
> As Stephen Rothwell notes:
>    The added check_mul_overflow() call is being passed 64 bit values.
>    COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW is not set for this build (see
>    include/linux/overflow.h).
> 
> Specifically, the helpers for checking whether the results of a
> multiplication overflowed (__unsigned_mul_overflow,
> __signed_add_overflow) use the division operator when
> !COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW.  This is problematic for 64b
> operands on 32b hosts.
> 
> This was fixed upstream by
> commit 76ae847497bc ("Documentation: raise minimum supported version of
> GCC to 5.1")
> which is not suitable to be backported to stable.
> 
> Further, __builtin_mul_overflow() would emit a libcall to a
> compiler-rt-only symbol when compiling with clang < 14 for 32b targets.
> 
> ld.lld: error: undefined symbol: __mulodi4
> 
> In order to keep stable buildable with GCC 4.9 and clang < 14, modify
> struct nbd_config to instead track the number of bits of the block size;
> reconstructing the block size using runtime checked shifts that are not
> problematic for those compilers and in a ways that can be backported to
> stable.
> 
> In nbd_set_size, we do validate that the value of blksize must be a
> power of two (POT) and is in the range of [512, PAGE_SIZE] (both
> inclusive).
> 
> This does modify the debugfs interface.
> 
> Cc: stable@vger.kernel.org
> Cc: Arnd Bergmann <arnd@kernel.org>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1438
> Link: https://lore.kernel.org/all/20210909182525.372ee687@canb.auug.org.au/
> Link: https://lore.kernel.org/stable/CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com/
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
