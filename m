Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B328496D5A
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 19:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiAVSjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 13:39:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53950 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiAVSje (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 13:39:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58D4C60EA1;
        Sat, 22 Jan 2022 18:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A4FC004E1;
        Sat, 22 Jan 2022 18:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642876773;
        bh=n/B1FmyEoA1G3JCa6y+KvNFQMmHR9BMvLjaGYR7WJAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pz/YJD7W27+/z+O5KGHaCzHgh/dhwn9TP0dG8pYxyvv1ELB8OMLl+otmXC3zKiD3t
         nHHKotzH6ewZmjHh55JM4Jr6lHTKDMrhYyh8M0zA3zJmUUe4KD74HWcyNEaoTsKsEk
         EvIlYldlhW5vvP7iHpz69Ae6SKezkRcAO+7o+6d5BIAXjrOk/bT6lVCp8Nhu1ndDq6
         z4FsozrFXyc0kYctK+o44AzkfdK3b7Db1bHwfPaVRDCCzcBjJbmIxZalMw/xZYXHg+
         xfhU8fMj9KMrMSLKGBKhWvYilMStz50N3YRQi/gH2w/HDHTU7muhuOgGxQLTGfJTGt
         I7kiMvZLFMAJQ==
Date:   Sat, 22 Jan 2022 13:39:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Sam Protsenko <semen.protsenko@linaro.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        tomasz.figa@gmail.com, cw00.choi@samsung.com,
        mturquette@baylibre.com, sboyd@kernel.org, matthias.bgg@gmail.com,
        linux-samsung-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.16 02/52] clk: samsung: exynos850: Register
 clocks early
Message-ID: <YexPYoPd5CTfNuId@sashalap>
References: <20220117165853.1470420-1-sashal@kernel.org>
 <20220117165853.1470420-2-sashal@kernel.org>
 <b75a0bc9-0423-83cc-11e1-d5e08952cc93@canonical.com>
 <CAPLW+4mPnktJTBeokhbmSGTZTqOa3-rkpThYHZ-Y0=_40bbLtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAPLW+4mPnktJTBeokhbmSGTZTqOa3-rkpThYHZ-Y0=_40bbLtA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 17, 2022 at 09:18:43PM +0200, Sam Protsenko wrote:
>On Mon, 17 Jan 2022 at 19:11, Krzysztof Kozlowski
><krzysztof.kozlowski@canonical.com> wrote:
>>
>> On 17/01/2022 17:58, Sasha Levin wrote:
>> > From: Sam Protsenko <semen.protsenko@linaro.org>
>> >
>> > [ Upstream commit bcda841f9bf2cddcf2f000cba96f2e27f6f2bdbf ]
>> >
>> > Some clocks must be registered before init calls. For example MCT clock
>> > (from CMU_PERI) is needed for MCT timer driver, which is registered
>> > with TIMER_OF_DECLARE(). By the time we get to core_initcall() used for
>> > clk-exynos850 platform driver init, it's already too late. Inability to
>> > get "mct" clock in MCT driver leads to kernel panic, as functions
>> > registered with *_OF_DECLARE() can't do deferred calls. MCT timer driver
>> > can't be fixed either, as it's acting as a clock source and it's
>> > essential to register it in start_kernel() -> time_init().
>> >
>> > Let's register CMU_PERI clocks early, using CLK_OF_DECLARE(). CMU_TOP
>> > generates clocks needed for CMU_PERI, but it's already registered early.
>> >
>> > While at it, let's cleanup the code a bit, by extracting everything
>> > related to CMU initialization and registration to the separate function.
>> >
>> > Similar issue was discussed at [1] and addressed in commit 1f7db7bbf031
>> > ("clk: renesas: cpg-mssr: Add early clock support"), as well as in
>> > drivers/clk/mediatek/clk-mt2712.c.
>> >
>> > [1] https://patchwork.kernel.org/project/linux-renesas-soc/patch/20180829132954.64862-2-chris.brandt@renesas.com/
>> >
>> > Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
>> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> > Link: https://lore.kernel.org/r/20211122144206.23134-1-semen.protsenko@linaro.org
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>> > ---
>> >  drivers/clk/samsung/clk-exynos850.c | 70 ++++++++++++++++++++---------
>> >  1 file changed, 49 insertions(+), 21 deletions(-)
>> >
>>
>> I propose to skip this one.
>>
>> Backporting it to v5.16 does not hurt but also does not bring any
>> benefits for the upstream kernel users. There is no support for
>> mentioned Exynos850 in v5.16.
>>
>> It could have only meaning for some downstream, out-of-tree kernels
>> which apply Exynos850 support on top of v5.16, but then they can just
>> take this patch as well.
>>
>
>Agreed. DTS patches will be merged only in v5.17, hopefully. Till that
>time the whole clock driver is floating with no users. That's
>historical thing -- I didn't have "Ack" to submit board dts at the
>time, and SoC dts couldn't be applied without users (board dts). So I
>focused on driver work, isolated. Not much sense to backport something
>without having real users.

Dropped, thanks!

-- 
Thanks,
Sasha
