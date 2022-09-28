Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315195EE1BB
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 18:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbiI1QWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 12:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbiI1QWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 12:22:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC989E109C;
        Wed, 28 Sep 2022 09:22:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07A31B8216E;
        Wed, 28 Sep 2022 16:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1E1C433D6;
        Wed, 28 Sep 2022 16:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664382145;
        bh=AjT653v325TEXty7buZJL5j/SjnI/p1CDSEy5eYUGls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cGI2I6ZSb/Zwbmeok9U4OSo6wilaIg8BP0LGvBjVAq8GSaShDKvWpcaE3juA5wE1/
         uA2nR+Gu/6Vi8XRA3tx4/4APm4Mbrnhn2a1Dio/8za98R8cidMgNH++tlfDEe1p9yM
         dvQln+PCfsW4Xk4YhIuEaVZ3egjThFIK9nlk/K4mR/s0Nzwxvz5Aac/eSkD4iodOIx
         mhFu9sHXBoa7/jJ9ZJkvsJXWJLsMExbKxk6xqoe0lqWWAFIVfN2WLz+OxvpicEAoa8
         xZZ6S2p0EPYC22tnhUWPKP4e0bO25iJHasIFUtStqxmUoZ+0RfPu5MF39BTaBUo+1y
         xfOpLEkBvYaSg==
Date:   Wed, 28 Sep 2022 12:22:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: Re: [PATCH 5.4 097/120] gpio: ixp4xx: Make irqchip immutable
Message-ID: <YzR0wGFicmfmCKOs@sashalap>
References: <20220926100750.519221159@linuxfoundation.org>
 <20220926100754.551266309@linuxfoundation.org>
 <86a66m8lml.wl-maz@kernel.org>
 <YzHMOXeCyc1LTlhZ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YzHMOXeCyc1LTlhZ@kroah.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 05:58:49PM +0200, Greg Kroah-Hartman wrote:
>On Mon, Sep 26, 2022 at 06:40:02AM -0400, Marc Zyngier wrote:
>> Greg,
>>
>> On Mon, 26 Sep 2022 06:12:10 -0400,
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>> >
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
>> We had that discussion[1], and concluded that none of these should be
>> backported to a kernel earlier than 5.19. 5.4 doesn't currently
>> contain the relevant infrastructure, nor should that infrastructure
>> should be backported either.
>>
>> Can we *please* stop this?
>>
>> 	M.
>>
>> [1] https://lore.kernel.org/all/CAMRc=Md9JKdW8wmbun_0_1y2RQbck7q=vzOkdw6n+FBgpf0h8w@mail.gmail.com/
>
>Sasha, what went wrong here?
>
>Now dropped from all but 5.19.y, thanks.

Sorry about that, I misunderstood Bartosz's reply and went off based on
that.

-- 
Thanks,
Sasha
