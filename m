Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDC2CCD39
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 01:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfJEXCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 19:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbfJEXCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Oct 2019 19:02:36 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B3CE20862;
        Sat,  5 Oct 2019 23:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570316555;
        bh=pbCDwTpnxXwPtXZNFzio8R6jbg4DLNM1x7B3grojDPw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zv+p98PCeWNGZlJ8OtQAB26G6EkW2a2HjaVvZ6dIpjVVh/Q78h1eUKzUl4t1AgTZ2
         LwoiqZpsJzcIfdEumNTZVbBoUr/+zBCChIxMXkdzG9o7/lbobup29RiTkAxoq2JfO2
         k/6aHn3SNEm3WYuutdL7Kqf2EL5A49pTZPDoc3mg=
Date:   Sat, 5 Oct 2019 19:02:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH AUTOSEL 4.14 08/23] ARM: 8875/1: Kconfig: default to
 AEABI w/ Clang
Message-ID: <20191005230234.GD25255@sasha-vm>
References: <20190929173535.9744-1-sashal@kernel.org>
 <20190929173535.9744-8-sashal@kernel.org>
 <20190929180852.GA901024@archlinux-threadripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190929180852.GA901024@archlinux-threadripper>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 11:08:52AM -0700, Nathan Chancellor wrote:
>On Sun, Sep 29, 2019 at 01:35:18PM -0400, Sasha Levin wrote:
>> From: Nick Desaulniers <ndesaulniers@google.com>
>>
>> [ Upstream commit a05b9608456e0d4464c6f7ca8572324ace57a3f4 ]
>>
>> Clang produces references to __aeabi_uidivmod and __aeabi_idivmod for
>> arm-linux-gnueabi and arm-linux-gnueabihf targets incorrectly when AEABI
>> is not selected (such as when OABI_COMPAT is selected).
>>
>> While this means that OABI userspaces wont be able to upgraded to
>> kernels built with Clang, it means that boards that don't enable AEABI
>> like s3c2410_defconfig will stop failing to link in KernelCI when built
>> with Clang.
>>
>> Link: https://github.com/ClangBuiltLinux/linux/issues/482
>> Link: https://groups.google.com/forum/#!msg/clang-built-linux/yydsAAux5hk/GxjqJSW-AQAJ
>>
>> Suggested-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  arch/arm/Kconfig | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index cf69aab648fbd..f0080864b9ce8 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -1595,8 +1595,9 @@ config ARM_PATCH_IDIV
>>  	  code to do integer division.
>>
>>  config AEABI
>> -	bool "Use the ARM EABI to compile the kernel" if !CPU_V7 && !CPU_V7M && !CPU_V6 && !CPU_V6K
>> -	default CPU_V7 || CPU_V7M || CPU_V6 || CPU_V6K
>> +	bool "Use the ARM EABI to compile the kernel" if !CPU_V7 && \
>> +		!CPU_V7M && !CPU_V6 && !CPU_V6K && !CC_IS_CLANG
>> +	default CPU_V7 || CPU_V7M || CPU_V6 || CPU_V6K || CC_IS_CLANG
>>  	help
>>  	  This option allows for the kernel to be compiled using the latest
>>  	  ARM ABI (aka EABI).  This is only useful if you are using a user
>> --
>> 2.20.1
>>
>
>Hi Sasha,
>
>This patch will not do anything for 4.14 because CC_IS_CLANG is not
>defined in this tree. The Kconfig patches that make this symbol possible
>were not merged until 4.18. I would recommend dropping it (unless Nick
>has an idea to make this work).

I've dropped it from 4.14 and older, thanks!

-- 
Thanks,
Sasha
