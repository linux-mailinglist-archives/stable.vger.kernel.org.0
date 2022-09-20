Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493305BEAFF
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 18:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiITQT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 12:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiITQSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 12:18:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682485A835;
        Tue, 20 Sep 2022 09:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05C9062B40;
        Tue, 20 Sep 2022 16:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BC1C433D6;
        Tue, 20 Sep 2022 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663690591;
        bh=0r4Hdlwu/SEjhuy0IBiEziv9Z22uksKqH1g7EsUNbKg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IUHA7ysPbF1ireKx7CTtigwr5nwwLDaAbvuSMYKXDDlG5qWo424CRKm5LjJZqWCpg
         d6pFk4jVy8xKKURWkA5xGykmA7PUPXJ8WXxZNyGTPb9DcYA9oey6hQRJlfbqHMAqLX
         82jh0tLD722LL1YDYULvCjCxCM0JWfKr09BGAGHrtJxwPcTBNnNZeth0KFgJuWbXxx
         gTpHJo51fTUM9Xn/UEGYVcJkhg8/nSMT3Fd2mbdABunsButb8kxHnyPUQUSj1svMpc
         eUTV2NRizdZwDXhfQi/5HBRewB/SUQoi19K2XfTWb9ESHAQzfO8uz05PKiOLHaglqf
         EFXfIsDq5pBZA==
Date:   Tue, 20 Sep 2022 12:16:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 01/13] spi: spi-cadence: Fix SPI CS gets
 toggling sporadically
Message-ID: <YynnXkGHUTY3Fbxc@sashalap>
References: <20220914090540.471725-1-sashal@kernel.org>
 <20220920134832.GA19086@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220920134832.GA19086@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 20, 2022 at 03:48:32PM +0200, Pavel Machek wrote:
>Hi!
>
>> From: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
>>
>> [ Upstream commit 21b511ddee09a78909035ec47a6a594349fe3296 ]
>>
>> As part of unprepare_transfer_hardware, SPI controller will be disabled
>> which will indirectly deassert the CS line. This will create a problem
>> in some of the devices where message will be transferred with
>> cs_change flag set(CS should not be deasserted).
>> As per SPI controller implementation, if SPI controller is disabled then
>> all output enables are inactive and all pins are set to input mode which
>> means CS will go to default state high(deassert). This leads to an issue
>> when core explicitly ask not to deassert the CS (cs_change = 1). This
>> patch fix the above issue by checking the Slave select status bits from
>> configuration register before disabling the SPI.
>
>My records say this was already submitted to AUTOSEL at "Jun
>27". There are more patches from that era that were reviewed in
>AUTOSEL but not merged anywhere. Can you investigate?

Yup, there was a batch that never went in, going to queue it up for the
next round of releases.

-- 
Thanks,
Sasha
