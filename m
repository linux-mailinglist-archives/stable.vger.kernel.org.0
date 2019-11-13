Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF91EFB558
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 17:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbfKMQkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 11:40:03 -0500
Received: from vern.gendns.com ([98.142.107.122]:33946 "EHLO vern.gendns.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728532AbfKMQkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Nov 2019 11:40:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lechnology.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QrvW6E32K5Vx93CTVXth40KpCgKxLN9+MjmqBa8HhYQ=; b=rdK4ZdHRwSz49vILav5p93Yhsu
        s0JgORPMrczDhB+6+VsPQBw6DulH10gp+48pYNDxLSIb3+NvlY5YXHUG0aMQkNkN/LRIJgL+q1v11
        kHVaI1m1z4idkL5UfkrnGvW3wEJr3Dbd7yZnGXBckkHHYF196WmeuTT/ifi1YANq99Es6YE2CZTX3
        GgPoxxAeJQjzLQ3kQelwc3MvAz0Ugi8WqdiqhftIDzaH62iucTIdQ9XewhtXPLhETHNt3dxmuPZEL
        DuHdeoORIzasqi78q3dIwxpL2rFCcvvQtMa4zHTs67doZEun6vC4EnjxkZQMcuXlugEP1eM79BlH8
        ex+KYp8g==;
Received: from [2600:1700:4830:165f::fb2] (port=42830)
        by vern.gendns.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <david@lechnology.com>)
        id 1iUvDz-0004Ht-9V; Wed, 13 Nov 2019 11:10:31 -0500
Subject: Re: [PATCH AUTOSEL 4.19 087/209] ARM: dts: da850-lego-ev3: slow down
 A/DC as much as possible
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sekhar Nori <nsekhar@ti.com>, devicetree@vger.kernel.org
References: <20191113015025.9685-1-sashal@kernel.org>
 <20191113015025.9685-87-sashal@kernel.org>
From:   David Lechner <david@lechnology.com>
Message-ID: <96753746-79ae-3db2-c6d8-e4d5615c0354@lechnology.com>
Date:   Wed, 13 Nov 2019 10:10:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191113015025.9685-87-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - vern.gendns.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lechnology.com
X-Get-Message-Sender-Via: vern.gendns.com: authenticated_id: davidmain+lechnology.com/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: vern.gendns.com: davidmain@lechnology.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/12/19 7:48 PM, Sasha Levin wrote:
> From: David Lechner <david@lechnology.com>
> 
> [ Upstream commit aea4762fb46e048c059ff49565ee33da07c8aeb3 ]
> 
> Due to the electrical design of the A/DC circuits on LEGO MINDSTORMS EV3,
> if we are reading analog values as fast as possible (i.e. using DMA to
> service the SPI) the A/DC chip will read incorrect values - as much as
> 0.1V off when the SPI is running at 10MHz. (This has to do with the
> capacitor charge time when channels are muxed in the A/DC.)
> 
> This patch slows down the SPI as much as possible (if CPU is at 456MHz,
> SPI runs at 1/2 of that, so 228MHz and has a max prescalar of 256, so
> we could get ~891kHz, but we're just rounding it to 1MHz). We also use
> the max allowable value for WDELAY to slow things down even more.
> 
> These changes reduce the error of the analog values to about 5mV, which
> is tolerable.
> 
> Commits a3762b13a596 ("spi: spi-davinci: Add support for SPI_CS_WORD")
> and e2540da86ef8 ("iio: adc: ti-ads7950: use SPI_CS_WORD to reduce
> CPU usage") introduce changes that allow DMA transfers to be used, so
> this slow down is needed now.
> 

I doubt that the commits above would be backported, so it does not
make sense to backport this patch.


