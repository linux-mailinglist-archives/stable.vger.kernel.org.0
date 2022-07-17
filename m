Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321145778B9
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 01:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiGQXEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jul 2022 19:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbiGQXEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jul 2022 19:04:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBCB12A8C;
        Sun, 17 Jul 2022 16:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12B9060ECE;
        Sun, 17 Jul 2022 23:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C09EC341C0;
        Sun, 17 Jul 2022 23:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658099043;
        bh=IPeBIHmETf2O6wdyfCK0PR/zEOWzTcVCzm7iP2DJHDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RgQq0B6e+i5l9xDOvXFdov0SJX+cZ0qaW54Lug3UowEykKCTpf0es9VM+tS4CCAnF
         IrDb1y+v1xkrc2+PnqpVOG2BiaTC5AZF6C7HZbin9M/fOttDIW/SKcEJOnearBm0E4
         W+F5k/2NR24Ac454Qlmzojs0ohoF2FHzIYm3MW0UjKQeQWeEFnMYrvP424BXeJG4Xl
         omuV/ZWdxgZxNM6fJlvQTom2tmNIuTTLRxhdxw4WTirATWgHQPF52iFOrfh08ddE/O
         farPpHz/MVdnbi8+mHXmvCCVnNwNE2Tw1fNcwRmD4bXITd8qlkeItkN5g3k35ST3x6
         viaQ2ogp096vg==
Date:   Sun, 17 Jul 2022 19:04:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Chen-Yu Tsai <wenst@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Judy Hsiao <judyhsiao@chromium.org>,
        Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, heiko@sntech.de,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.15 12/28] ASoC: rockchip: i2s: switch BCLK to
 GPIO
Message-ID: <YtSVYq/47XmF6V0b@sashalap>
References: <20220714042429.281816-1-sashal@kernel.org>
 <20220714042429.281816-12-sashal@kernel.org>
 <CAGXv+5Fnj4-bHksi5ymy6LwOrmv_9yQ1aBSOpM4wGbGy2QGZUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXv+5Fnj4-bHksi5ymy6LwOrmv_9yQ1aBSOpM4wGbGy2QGZUQ@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 12:29:27PM +0800, Chen-Yu Tsai wrote:
>Hi,
>
>On Thu, Jul 14, 2022 at 12:25 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Judy Hsiao <judyhsiao@chromium.org>
>>
>> [ Upstream commit a5450aba737dae3ee1a64b282e609d8375d6700c ]
>>
>> We discoverd that the state of BCLK on, LRCLK off and SD_MODE on
>> may cause the speaker melting issue. Removing LRCLK while BCLK
>> is present can cause unexpected output behavior including a large
>> DC output voltage as described in the Max98357a datasheet.
>>
>> In order to:
>>   1. prevent BCLK from turning on by other component.
>>   2. keep BCLK and LRCLK being present at the same time
>>
>> This patch switches BCLK to GPIO func before LRCLK output, and
>> configures BCLK func back during LRCLK is output.
>>
>> Without this fix, BCLK is turned on 11 ms earlier than LRCK by the
>> da7219.
>> With this fix, BCLK is turned on only 0.4 ms earlier than LRCK by
>> the rockchip codec.
>>
>> Signed-off-by: Judy Hsiao <judyhsiao@chromium.org>
>> Link: https://lore.kernel.org/r/20220615045643.3137287-1-judyhsiao@chromium.org
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please drop this one from all stable branches. It caused more problems
>than it fixed and will be reverted for 5.19 [1]. The same patch, along
>with a proper follow-up fix, are queued up for 5.20.

Now dropped, thanks!

-- 
Thanks,
Sasha
