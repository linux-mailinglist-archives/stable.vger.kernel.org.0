Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376875E90D4
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 05:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiIYDSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 23:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiIYDSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 23:18:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0633F311;
        Sat, 24 Sep 2022 20:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90797B80DEE;
        Sun, 25 Sep 2022 03:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128ABC433D6;
        Sun, 25 Sep 2022 03:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664075880;
        bh=TBQWJYDnI1VFe2YiW1HW4vwlj64AKQWTH+Rj9lXyibA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M2MC3Ey+3sGSjmE0gLaGOzvyyatTuha1bsGhiEu/eTySFhB35mqQjaPiUrOrqQPtX
         TKie3Txx9mm6ORKY8i4IVZ31ilVDj1lAOfXA1lGypq+V+Vf43MOswi4b7r2k8hDgFR
         VteY//FBvH4fE1Q3z9Vmkkh9Cp3boY6wrQaH7TWMDWTIKH2UBxaEnR/vPQR8owF0WF
         MwpPPxkXK0zQLFLbiiF3+P/Cxu6Rn1X7btoRkmbeifIN432x9R6xSHtUSy6dds3Ix5
         TG1z9Z3Ut3OcBwVpZNJ2YmDYHUWroNYN8eJj+vrM30OU67dQGxdv9A7kj56S1T/JiU
         ZrvoLgF5VnLoA==
Date:   Sat, 24 Sep 2022 23:17:58 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linusw@kernel.org, kaloz@openwrt.org, khalasa@piap.pl,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 2/5] gpio: ixp4xx: Make irqchip immutable
Message-ID: <Yy/IZjq+zVoKpfJ/@sashalap>
References: <20220921155436.235371-1-sashal@kernel.org>
 <20220921155436.235371-2-sashal@kernel.org>
 <fec2e2e2e74d680d5f9de6d68fb5fe18@kernel.org>
 <CAMRc=MexqLhu3ZWt1AbzBestswqmHNpct1LQiif0JGECTjHz4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMRc=MexqLhu3ZWt1AbzBestswqmHNpct1LQiif0JGECTjHz4Q@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 10:04:27PM +0200, Bartosz Golaszewski wrote:
>On Wed, Sep 21, 2022 at 6:57 PM Marc Zyngier <maz@kernel.org> wrote:
>>
>> On 2022-09-21 16:54, Sasha Levin wrote:
>> > From: Linus Walleij <linus.walleij@linaro.org>
>> >
>> > [ Upstream commit 94e9bc73d85aa6ecfe249e985ff57abe0ab35f34 ]
>> >
>> > This turns the IXP4xx GPIO irqchip into an immutable
>> > irqchip, a bit different from the standard template due
>> > to being hierarchical.
>> >
>> > Tested on the IXP4xx which uses drivers/ata/pata_ixp4xx_cf.c
>> > for a rootfs on compact flash with IRQs from this GPIO
>> > block to the CF ATA controller.
>> >
>> > Cc: Marc Zyngier <maz@kernel.org>
>> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> > Acked-by: Marc Zyngier <maz@kernel.org>
>> > Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
>> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> Why? The required dependencies are only in 5,19, and are
>> definitely NOT a stable candidate...
>>
>> This isn't a fix by any stretch of the imagination.
>>
>
>Hi Marc,
>
>While I didn't mark it for stable (and it shouldn't go into any branch
>earlier than 5.19.x), I did send the patches making the irqchips
>immutable to Linus Torvalds as fixes as they technically do *fix* the
>warning emitted by gpiolib and make the implementation correct.
>
>I think these patches should still be part of the v5.19.x stable branch.

Yes, and as far as I see we are taking those fixes too.

-- 
Thanks,
Sasha
