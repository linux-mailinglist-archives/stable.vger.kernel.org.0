Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7F36336B6
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 09:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiKVILX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 03:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbiKVILW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 03:11:22 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [IPv6:2a01:e0c:1:1599::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8782622504;
        Tue, 22 Nov 2022 00:11:21 -0800 (PST)
Received: from [192.168.10.46] (unknown [130.180.211.218])
        (Authenticated sender: daniel.lezcano@free.fr)
        by smtp1-g21.free.fr (Postfix) with ESMTPA id F0F71B00593;
        Tue, 22 Nov 2022 09:11:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1669104680;
        bh=TISIpjZ7FC95oehxTvBSrsbcUOCPBMkAO4i/5N4DvUc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VW/dpyUQ8QFT3hzwNvPsqIeixeoH0hxJ45EAbxBGbvn7LABFC9YvKCjnITEAzwc/d
         pVx+GxLVZi+crhPzyDE0HXHq5zGmz55mn0O3wF+iSbA1s5UcbnnPTrFZ/6bB81vqWq
         KYPydpJ3sRCL3XQAdCgvtHAE02DoK0OwnAbJu4ldtWJw7oZW1xYBhAxUZ4+kbyGhe6
         0rULxrVyk/3gQZfIvToQWq3B3GgVk+6j5QWm+xmNsnrzlUCTd00QCsDva8Hy34XLzm
         SICzbU59uO1I7ZXR5BJFRR1P6qLQJEDHnE4HxSR0bWSev2ggHAIdAo1Xthd8tL2Zwi
         +g6tzwCopIEiA==
Message-ID: <973694d5-9a97-2239-be69-8f380d6e7130@free.fr>
Date:   Tue, 22 Nov 2022 09:11:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL
 register math error
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Joe Korty <joe.korty@concurrent-rt.com>, stable@vger.kernel.org
References: <20221121145343.896018-1-maz@kernel.org>
From:   Daniel Lezcano <daniel.lezcano@free.fr>
In-Reply-To: <20221121145343.896018-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/11/2022 15:53, Marc Zyngier wrote:
> From: Joe Korty <joe.korty@concurrent-rt.com>
> 
> The TVAL register is 32 bit signed.  Thus only the lower 31 bits are
> available to specify when an interrupt is to occur at some time in the
> near future.  Attempting to specify a larger interval with TVAL results
> in a negative time delta which means the timer fires immediately upon
> being programmed, rather than firing at that expected future time.
> 
> The solution is for Linux to declare that TVAL is a 31 bit register rather
> than give its true size of 32 bits.  This prevents Linux from programming
> TVAL with a too-large value.  Note that, prior to 5.16, this little trick
> was the standard way to handle TVAL in Linux, so there is nothing new
> happening here on that front.
> 
> The softlockup detector hides the issue, because it keeps generating
> short timer deadlines that are within the scope of the broken timer.
> 
> Disable it, and you start using NO_HZ with much longer timer deadlines,
> which turns into an interrupt flood:
> 
>   11: 1124855130  949168462  758009394   76417474  104782230   30210281
>           310890 1734323687     GICv2  29 Level     arch_timer
> 
> And "much longer" isn't that long: it takes less than 43s to underflow
> TVAL at 50MHz (the frequency of the counter on XGene-1).
> 
> Some comments on the v1 version of this patch by Marc Zyngier:
> 
>    XGene implements CVAL (a 64bit comparator) in terms of TVAL (a countdown
>    register) instead of the other way around. TVAL being a 32bit register,
>    the width of the counter should equally be 32.  However, TVAL is a
>    *signed* value, and keeps counting down in the negative range once the
>    timer fires.
> 
>    It means that any TVAL value with bit 31 set will fire immediately,
>    as it cannot be distinguished from an already expired timer. Reducing
>    the timer range back to a paltry 31 bits papers over the issue.
> 
>    Another problem cannot be fixed though, which is that the timer interrupt
>    *must* be handled within the negative countdown period, or the interrupt
>    will be lost (TVAL will rollover to a positive value, indicative of a
>    new timer deadline).
> 
> Cc: stable@vger.kernel.org # 5.16+
> Fixes: 012f18850452 ("clocksource/drivers/arm_arch_timer: Work around broken CVAL implementations")
> Signed-off-by: Joe Korty <joe.korty@concurrent-rt.com>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> [maz: revamped the commit message]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20221024165422.GA51107@zipoli.concurrent-rt.com
> ---

Applied

