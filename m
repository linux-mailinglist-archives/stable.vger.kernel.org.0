Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2650A2CD976
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 15:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbgLCOmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 09:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgLCOmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 09:42:23 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058C5C061A4E;
        Thu,  3 Dec 2020 06:41:43 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BD21C22EE3;
        Thu,  3 Dec 2020 15:41:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1607006499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bei1lhwQJZstsY68ENjaQ70P2t4ZlXIf/DRsO9Ikv8M=;
        b=lRyS9HqBpXCKuDCKhCRgon9jFgYgw2tvU0SX68nRFY7yDVfReemuipwKL5/UxueQdrKe3B
        YWl3vIEwSnlgjYcBVx65YikHJLIjFrv769+3dTg4FQBfgdkJRc89saMqNiavWh7iEz+Okd
        TxFPvJ2quFggUC8jcyy1wY1+wRAT7VQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 03 Dec 2020 15:41:39 +0100
From:   Michael Walle <michael@walle.cc>
To:     Tudor.Ambarus@microchip.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        boris.brezillon@collabora.com, stable@vger.kernel.org
Subject: Re: [PATCH v7 1/7] mtd: spi-nor: sst: fix BPn bits for the
 SST25VF064C
In-Reply-To: <fe37e295-9d74-160c-9b16-bbd5dcd5a638@microchip.com>
References: <20201202230040.14009-1-michael@walle.cc>
 <20201202230040.14009-2-michael@walle.cc>
 <fe37e295-9d74-160c-9b16-bbd5dcd5a638@microchip.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <9811370c4350a812ddabc5b9b86aa2a4@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2020-12-03 15:40, schrieb Tudor.Ambarus@microchip.com:
> On 12/3/20 1:00 AM, Michael Walle wrote:
>> --- a/drivers/mtd/spi-nor/sst.c
>> +++ b/drivers/mtd/spi-nor/sst.c
>> @@ -18,7 +18,8 @@ static const struct flash_info sst_parts[] = {
>>                               SECT_4K | SST_WRITE) },
>>         { "sst25vf032b", INFO(0xbf254a, 0, 64 * 1024, 64,
>>                               SECT_4K | SST_WRITE) },
>> -       { "sst25vf064c", INFO(0xbf254b, 0, 64 * 1024, 128, SECT_4K) },
>> +       { "sst25vf064c", INFO(0xbf254b, 0, 64 * 1024, 128,
>> +                             SECT_4K | SPI_NOR_4BIT_BP) },
> 
> And I would put 1/7 after 4/7, so that I can set the locking flags
> in some order: SPI_NOR_HAS_LOCK | SPI_NOR_4BIT_BP. We first indicate
> that the flash supports locking, and then what kind of locking, BP3,
> and not the other way around.

If that patch shouldn't make it into stable, then yes. otherwise, I've
put these patches first to not cause merge conflicts.

-michael
