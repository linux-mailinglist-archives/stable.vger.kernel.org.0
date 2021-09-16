Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857FF40ED8C
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241304AbhIPWyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241276AbhIPWyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 18:54:24 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A965C061574;
        Thu, 16 Sep 2021 15:53:02 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631832780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+uoRd7sICB9PTbOq5EWEwT9s8dxxMBDK5Hxzn1p0B2M=;
        b=1EHh+jTMSzgz8I5umosdei/hjB4deVd+HjIXpER0jj3a9UJvUTmYCG3sktt+mmgogjx4i5
        5D+TvgjsSbkOi2gRWJ9m/L2PsSXPUDA0fNBCaeyAQa5oIj2aZ0g7IpYrWYv2xoW3jpCr8W
        aEJLiY9J4es14JJ3Fuu2PLS1+FTJ0bE2cZpBoUg9o8Wfp16oVUcyT6k2JW56IzITAd1Qss
        dQHpUZYX/miD+m+QAFEvKHKOuPh3ii1buJhETb4Jo0E4cAcKIm9FXERVj2dXTWlNHeyUHk
        iAw/eFYYzJOa1pzYeAEHGABTxJs2LapYK4cztyOfWpa2A2nA74K18B2uCKyc+Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631832780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+uoRd7sICB9PTbOq5EWEwT9s8dxxMBDK5Hxzn1p0B2M=;
        b=vtwgGlcj3bLHRjLYNI/SunfOnn6jEEhRquuMedQEImsrPfPUPG9QhrJlsPjoht0r0FiHu4
        T9zSULifH9VCAfCg==
To:     Arnd Bergmann <arnd@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lukas Hannen <lukas.hannen@opensource.tttech-industrial.com>
Subject: Re: [PATCH 5.14 298/334] time: Handle negative seconds correctly in
 timespec64_to_ns()
In-Reply-To: <874kak9moe.ffs@tglx>
References: <20210913131113.390368911@linuxfoundation.org>
 <20210913131123.500712780@linuxfoundation.org>
 <CAK8P3a0z5jE=Z3Ps5bFTCFT7CHZR1JQ8VhdntDJAfsUxSPCcEw@mail.gmail.com>
 <874kak9moe.ffs@tglx>
Date:   Fri, 17 Sep 2021 00:53:00 +0200
Message-ID: <87y27w875f.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 17 2021 at 00:32, Thomas Gleixner wrote:
> I usually spend quite some time on tagging patches for stable and it's
> annoying me that this patch got reverted while stuff which I explicitely
> did not tag for stable got backported for whatever reason and completely
> against the stable rules:
>
>   627ef5ae2df8 ("hrtimer: Avoid double reprogramming in __hrtimer_start_range_ns()")
>
> What the heck qualifies this to be backported?
>
>  1) It's hot of the press and just got merged in the 5.15-rc1 merge
>     window and is not tagged for stable
>
>  2) https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>
>     clearly states the rules but obviously our new fangled "AI" driven
>     approach to select patches for stable is blissfully ignorant of
>     these rules. I assume that AI stands for "Artifical Ignorance' here.
>
> I already got a private bug report vs. that on 5.10.65. Annoyingly
> 5.10.5 does not have the issue despite the fact that the resulting diff

5.14.5 obviously...

> between those two versions in hrtimer.c is just in comments.
>
> Bah!
>
> Thanks,
>
>         tglx
