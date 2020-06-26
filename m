Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40BC20B9F5
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 22:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgFZUHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 16:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgFZUHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 16:07:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 058C8206C3;
        Fri, 26 Jun 2020 20:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593202032;
        bh=4oOD88XtGZC/uNbNT6wOOaDIgm3VB5umJpU7EFUTnZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=obzLXtBTVJJGSeD0cbiCHxDtXmWB/hH2sZPMR14C2iGv+nabdMnUhC/p+gsX3vzpb
         DRB7pEDj2buzXO6nXa8YiLcW4x6TMxuNaz7hDeb1bYxuyZ6m4QyyrLWFTEgVH8/cAk
         1O3qQ4wXoWWBgv7oVCTJoTnL+YCkuF4EttpdzthU=
Date:   Fri, 26 Jun 2020 16:07:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ralph Siemsen <ralph.siemsen@linaro.org>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Pavel Machek <pavel@denx.de>,
        Serge Semin <fancer.lancer@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Georgy Vlasov <Georgy.Vlasov@baikalelectronics.ru>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4.19 182/267] spi: dw: Return any value retrieved from
 the dma_transfer callback
Message-ID: <20200626200710.GK1931@sasha-vm>
References: <20200619141648.840376470@linuxfoundation.org>
 <20200619141657.498868116@linuxfoundation.org>
 <20200619210719.GB12233@amd>
 <20200622205121.4xuki7guyj6u5yul@mobilestation>
 <20200626151800.GA22242@maple.netwinder.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200626151800.GA22242@maple.netwinder.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 11:18:00AM -0400, Ralph Siemsen wrote:
>Hi Serge, Pavel, Greg,
>
>On Mon, Jun 22, 2020 at 11:51:21PM +0300, Serge Semin wrote:
>>Hello Pavel
>>
>>On Fri, Jun 19, 2020 at 11:07:19PM +0200, Pavel Machek wrote:
>>
>>>Mainline patch simply changes return value, but code is different in
>>>v4.19, and poll_transfer will now be avoided when dws->dma_mapped. Is
>>>that a problem?
>>
>>Actually no.) In that old 4.19 context it's even better to return straight away
>>no matter what value is returned by the dma_transfer() callback.
>
>This patch changes the return dma_transfer return value from 0 to 1, 
>however it was only done in spi-dw-mid.c func mid_spi_dma_transfer().
>
>There is an identical function in spi-dw-mmio.c that needs the same 
>treatment, otherwise access to the SPI device becomes erratic and even 
>causes kernel to hang. Guess how I found this ;-)
>
>So the following patch is needed as well, at least in 4.9 and 4.19, I 
>did not check/test other versions. Mainline does not need this, since 
>the code seems to have been refactored to avoid the duplication.

Could you add your signed-off-by tag please? :)

-- 
Thanks,
Sasha
