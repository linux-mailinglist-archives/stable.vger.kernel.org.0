Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC32C4099E4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239746AbhIMQsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239875AbhIMQs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 12:48:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4352960F26;
        Mon, 13 Sep 2021 16:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631551630;
        bh=k2+57G8GmiUA6A/+8F9R26euorOK1IJlieiurGMi0eU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bLHKkUj+yyzc+0pfc2VeRpIblNJFUpdKEtJCfc/QH6wyo4IpeWSqx67QolEpv4/Zp
         qXIIF0enzykxJ5PPn+IwmLOA/OG/sd1eLCx0TFL/la2FNIjfAJnylRJPDVmQPihlPS
         G2yfUK1eLHFwPspnoLeNlrddkfeMN7bK7TnWTU241AANnBZn3fzu4wHD9ulDw0b0r5
         /pIhY4ScDlYgtvZC0WWXInDySG2cNurIGqHmbiPqX2KveswxqAnO3BQWtPbMhiT7/E
         gNpjs3KTBspx0hqvOkfMvDhDQ5AjShFirsKzTwBwycekUq6blT+j48nv5lcr+wBm6x
         yCPpEZ6xcXfiA==
Date:   Mon, 13 Sep 2021 12:47:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Robin Gong <yibin.gong@nxp.com>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH AUTOSEL 5.14 058/252] spi: imx: fix ERR009165
Message-ID: <YT+AjZdkEOlHPOFW@sashalap>
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-58-sashal@kernel.org>
 <500c68753cac86d9b3021ddf1e8580779e685332.camel@pengutronix.de>
 <CAOMZO5D6pbTG3O14OtZRUCa5DPcG0seUzot4gX4Y=hQOpxRfdQ@mail.gmail.com>
 <VE1PR04MB6688DC0E216F0EA6E1A4349E89D69@VE1PR04MB6688.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <VE1PR04MB6688DC0E216F0EA6E1A4349E89D69@VE1PR04MB6688.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 03:30:27AM +0000, Robin Gong wrote:
>> Hi Lucas,
>>
>> On Thu, Sep 9, 2021 at 1:43 PM Lucas Stach <l.stach@pengutronix.de> wrote:
>> >
>> > Hi Sasha,
>> >
>> > Am Donnerstag, dem 09.09.2021 um 07:37 -0400 schrieb Sasha Levin:
>> > > From: Robin Gong <yibin.gong@nxp.com>
>> > >
>> > > [ Upstream commit 980f884866eed4dda2a18de888c5a67dde67d640 ]
>> > >
>> > > Change to XCH  mode even in dma mode, please refer to the below
>> > > errata:
>> > > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fww
>> > >
>> w.nxp.com%2Fdocs%2Fen%2Ferrata%2FIMX6DQCE.pdf&amp;data=04%7C01
>> %7Cyib
>> > >
>> in.gong%40nxp.com%7C39f3117d59434df46fc108d973b1bb3e%7C686ea1d3
>> bc2b4
>> > >
>> c6fa92cd99c5c301635%7C0%7C1%7C637668029454898655%7CUnknown%7
>> CTWFpbGZ
>> > >
>> sb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn
>> 0
>> > > %3D%7C1000&amp;sdata=NxCByvu4qCGniWnXccSxLNy9ilvQhFpid7O9Ag
>> 1HloI%3D&
>> > > amp;reserved=0
>> > >
>> >
>> > This patch is part of a quite extensive series touching multiple
>> > drivers and devicetree descriptions and will do more harm than good if
>> > backported without the rest of the series. The options here are:
>> > a) backport the entire series (this will most likely not match the
>> > stable criteria)
>> > b) drop the patch from the stable queue
>>
>> Yes, I agree. I prefer going with option b).
>Agree, vote for option b.

It's gone, thanks!

-- 
Thanks,
Sasha
