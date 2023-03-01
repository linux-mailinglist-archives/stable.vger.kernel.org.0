Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136B66A7572
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 21:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCAUgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 15:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjCAUgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 15:36:16 -0500
Received: from thorn.bewilderbeest.net (thorn.bewilderbeest.net [IPv6:2605:2700:0:5::4713:9cab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDFF2ED54;
        Wed,  1 Mar 2023 12:36:15 -0800 (PST)
Received: from hatter.bewilderbeest.net (174-21-161-58.tukw.qwest.net [174.21.161.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: zev)
        by thorn.bewilderbeest.net (Postfix) with ESMTPSA id 3A62B341;
        Wed,  1 Mar 2023 12:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bewilderbeest.net;
        s=thorn; t=1677702975;
        bh=IRmYsMVKZO7oj/cHyStRNgW6UvFUZ3w6BCIHeycLvXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mnVGx8zBSAvVSEXbzkQ3uAqbks7J8iX0ljiFBrh5zEu6CyjY3IsrZmuFOZ3y63y8K
         /bf9/xnkLgmr6gEWeZercgWJSCYmwhTodkCuK7O/HaXG6DrRtdLBYz6WBV4rnIaIXc
         hjCjIQFdpH+1v37ItHG94ruPSwiu5a2Xat+y0/Sg=
Date:   Wed, 1 Mar 2023 12:36:13 -0800
From:   Zev Weiss <zev@bewilderbeest.net>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ARM: dts: aspeed: asrock: Correct firmware flash
 SPI clocks
Message-ID: <Y/+3PSQzo+ZGM+hk@hatter.bewilderbeest.net>
References: <20230224000400.12226-1-zev@bewilderbeest.net>
 <20230224000400.12226-4-zev@bewilderbeest.net>
 <CACPK8XdFT=+VJJ=iDhcmWPh9m9of2b+2UYxkrAisp6tdmWOWKg@mail.gmail.com>
 <36da41c9-2396-5dd4-7fef-c85412f23045@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36da41c9-2396-5dd4-7fef-c85412f23045@kaod.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 28, 2023 at 11:33:58PM PST, C�dric Le Goater wrote:
>On 3/1/23 02:30, Joel Stanley wrote:
>>On Fri, 24 Feb 2023 at 00:04, Zev Weiss <zev@bewilderbeest.net> wrote:
>>>
>>>While I'm not aware of any problems that have occurred running these
>>>at 100 MHz, the official word from ASRock is that 50 MHz is the
>>>correct speed to use, so let's be safe and use that instead.
>>
>>:(
>>
>>Validated with which driver?
>>

spi-nor, FWIW.

>>C�dric, do you have any thoughts on this?
>
>Transactions on the Firmware SPI controller are usually configured at
>50MHz by U-Boot and Linux to stay on the safe side, specially CE0 from
>which the board boots. The other SPI controllers are generally set at
>a higher freq : 100MHz, because the devices on these buses are not for
>booting the BMC, they are mostly only written to (at a default lower
>freq). There are some exceptions when the devices and the wiring permit
>higher rates.
>
>For the record, we lowered the SPI freq on the AST2400 (palmetto)
>because some chips would freak out once in a while at 100MHz.
>
>C.
>

Yeah, this actually grew out of some OpenBMC bringup work on another 
ASRock board -- I started out with a 100MHz clock since that's what I'd 
been using without a hitch on previous ASRock systems (such as these), 
but saw sporadic data corruption.  Some discussion on the OpenBMC 
Discord 
(https://discord.com/channels/775381525260664832/775694683589574659/1074904879023263774 
and 
https://discord.com/channels/775381525260664832/775694683589574659/1075336116212875335) 
prompted me to try 50MHz instead, which seemed to solve the problem -- 
then after enquiring about it with ASRock I discovered that the 100MHz 
clocks we've been using on these boards are also officially out of spec.


Zev

