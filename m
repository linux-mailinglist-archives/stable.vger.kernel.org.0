Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE60105EFA
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 04:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfKVDYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 22:24:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfKVDYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 22:24:24 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F08E2067D;
        Fri, 22 Nov 2019 03:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574393063;
        bh=iE3p1SKLOct5dnrnmKl/6ltpI6ePV5jd0Jn24rApQo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J0QsnJoRDUmg0O+Hq5suKVJNR0x7BaZjihZz2MgesejyZHnAiKNjICKnPQj1uxdcK
         iqB9QNXZn802hSg58ech4sMOptU/83arMJjRqAYGNdr/XBQXxT5qzouZVZ4Gp4GhG9
         0waNU23Nm/zB3BSjFprpl67wN8HmcfEf1gZBT0O0=
Date:   Thu, 21 Nov 2019 22:24:22 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     David Lechner <david@lechnology.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 087/209] ARM: dts: da850-lego-ev3: slow down
 A/DC as much as possible
Message-ID: <20191122032422.GK16867@sasha-vm>
References: <20191113015025.9685-1-sashal@kernel.org>
 <20191113015025.9685-87-sashal@kernel.org>
 <96753746-79ae-3db2-c6d8-e4d5615c0354@lechnology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <96753746-79ae-3db2-c6d8-e4d5615c0354@lechnology.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 13, 2019 at 10:10:30AM -0600, David Lechner wrote:
>On 11/12/19 7:48 PM, Sasha Levin wrote:
>>From: David Lechner <david@lechnology.com>
>>
>>[ Upstream commit aea4762fb46e048c059ff49565ee33da07c8aeb3 ]
>>
>>Due to the electrical design of the A/DC circuits on LEGO MINDSTORMS EV3,
>>if we are reading analog values as fast as possible (i.e. using DMA to
>>service the SPI) the A/DC chip will read incorrect values - as much as
>>0.1V off when the SPI is running at 10MHz. (This has to do with the
>>capacitor charge time when channels are muxed in the A/DC.)
>>
>>This patch slows down the SPI as much as possible (if CPU is at 456MHz,
>>SPI runs at 1/2 of that, so 228MHz and has a max prescalar of 256, so
>>we could get ~891kHz, but we're just rounding it to 1MHz). We also use
>>the max allowable value for WDELAY to slow things down even more.
>>
>>These changes reduce the error of the analog values to about 5mV, which
>>is tolerable.
>>
>>Commits a3762b13a596 ("spi: spi-davinci: Add support for SPI_CS_WORD")
>>and e2540da86ef8 ("iio: adc: ti-ads7950: use SPI_CS_WORD to reduce
>>CPU usage") introduce changes that allow DMA transfers to be used, so
>>this slow down is needed now.
>>
>
>I doubt that the commits above would be backported, so it does not
>make sense to backport this patch.

I've dropped it, thanks!

-- 
Thanks,
Sasha
