Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5217724D74D
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 16:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgHUOY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 10:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgHUOY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 10:24:57 -0400
Received: from mail.kmu-office.ch (mail.kmu-office.ch [IPv6:2a02:418:6a02::a2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5ACC061573;
        Fri, 21 Aug 2020 07:24:57 -0700 (PDT)
Received: from webmail.kmu-office.ch (unknown [IPv6:2a02:418:6a02::a3])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 2CA215C3C40;
        Fri, 21 Aug 2020 16:24:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1598019890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T+8cdmlCgL2E/JdDt751XqJVqvg2UVPQwivpPWqEdjI=;
        b=wnyAQK+sRU/WEsnin5QCSSp8c9IBjtyFN29UoeZvEpOXFRCfPputNuiPsDX3EbIte6J7fc
        uXfxZjhmX/ZwV7tmc0ICFV5Et+nLP8r9PWwPr6+Et95NLWIaZZyd18DWeURyhznzLxKOC+
        mfyclFvU8MxvQ1KjHHNVZfL9ndh3Pvk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date:   Fri, 21 Aug 2020 16:24:49 +0200
From:   Stefan Agner <stefan@agner.ch>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] ARM: dts: vfxxx: Add syscon compatible with ocotp
In-Reply-To: <CAFXsbZp0_hCZ-cz3vBtFySv-q4X8bKjSaPrAMt-aA5aAbtGVGA@mail.gmail.com>
References: <20200820041055.75848-1-cphealy@gmail.com>
 <1bf1c9664d8c376c87dc55aeb27da6e4@agner.ch>
 <CAFXsbZp0_hCZ-cz3vBtFySv-q4X8bKjSaPrAMt-aA5aAbtGVGA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.1
Message-ID: <76061743bc1c4ac7b498549921e937cb@agner.ch>
X-Sender: stefan@agner.ch
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-21 16:13, Chris Healy wrote:
> On Fri, Aug 21, 2020 at 6:21 AM Stefan Agner <stefan@agner.ch> wrote:
>>
>> On 2020-08-20 06:10, Chris Healy wrote:
>> > From: Chris Healy <cphealy@gmail.com>
>> >
>> > Add syscon compatibility with Vybrid ocotp node. This is required to
>> > access the UID.
>>
>> Hm, it seems today the SoC driver uses the specific compatible. It also
>> should expose the UID as soc_id, see drivers/soc/imx/soc-imx.c.
>>
> Yes, until I added syscon, the soc_id was empty and I would get the
> following line in dmesg:  "failed to find vf610-ocotp regmap!
> 

Ah I see, it looks up syscon, so that requires syscon to be in
compatible.

>> Maybe it does make sense exposing it as syscon, but then we should
>> probably also adjust
>> Documentation/devicetree/bindings/nvmem/vf610-ocotp.txt.
>>
> Makes sense.  I will update vf610-ocotp.txt in v3.  Tnx
> 

Ok, thx. With that you can add Reviewed-by: Stefan Agner
<stefan@agner.ch> as well.

--
Stefan

>> --
>> Stefan
>>
>> >
>> > Fixes: fa8d20c8dbb77 ("ARM: dts: vfxxx: Add node corresponding to OCOTP")
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Chris Healy <cphealy@gmail.com>
>> > ---
>> > Changes in v2:
>> >  - Add Fixes line to commit message
>> >
>> >  arch/arm/boot/dts/vfxxx.dtsi | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
>> > index 0fe03aa0367f..2259d11af721 100644
>> > --- a/arch/arm/boot/dts/vfxxx.dtsi
>> > +++ b/arch/arm/boot/dts/vfxxx.dtsi
>> > @@ -495,7 +495,7 @@ edma1: dma-controller@40098000 {
>> >                       };
>> >
>> >                       ocotp: ocotp@400a5000 {
>> > -                             compatible = "fsl,vf610-ocotp";
>> > +                             compatible = "fsl,vf610-ocotp", "syscon";
>> >                               reg = <0x400a5000 0x1000>;
>> >                               clocks = <&clks VF610_CLK_OCOTP>;
>> >                       };
