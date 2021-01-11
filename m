Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815522F1A11
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbhAKPuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbhAKPuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:50:08 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8279C0617A2;
        Mon, 11 Jan 2021 07:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FFMEUUCHGLm99xm2CkvttDiOzVZ9LFIoxQMb7aWxnFI=; b=oy5fZ4ZKbOyW3IOxH4IU3ZkhIc
        nsE4PdgidAM4ki+346LdyuoCASnTypQw0Zco7ZJXDwX6AvGwoJ4THriuE/UF23kqhtyJvcdiuq56s
        Tejnb7I3L8vBsXSVu7QAgw3Xbzu8xIZsSddgfGddZB2mF6o7WYHklBf5E7BRYuiXh1CldcEqRqBdA
        DrS9VZVqQjtlGk+ZK45zCV53HvvuqePmNplIu2YNFhl9i+yDVnzUqv8JvANPPZ3PetNmpeByQa4FT
        OGPHrv179xP57eZR1iDMA0FydgXLQ/BuaG6KSAf+H/P0Iutz1XLE/Scg6LBf2W/eFKbn9qHdmZCe5
        6oj7Wgcg==;
Received: from dsl-hkibng22-54f986-236.dhcp.inet.fi ([84.249.134.236] helo=[192.168.1.10])
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <cyndis@kapsi.fi>)
        id 1kyzRc-0003pz-NI; Mon, 11 Jan 2021 17:49:24 +0200
Subject: Re: [PATCH] i2c: tegra-bpmp: ignore DMA safe buffer flag
To:     Ben Dooks <ben.dooks@codethink.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        thierry.reding@gmail.com, jonathanh@nvidia.com
Cc:     talho@nvidia.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammed Fazal <mfazale@nvidia.com>, stable@vger.kernel.org
References: <20210111142713.3641208-1-mperttunen@nvidia.com>
 <16a0be21-2cbe-dd0e-aed7-b84f6abcacac@codethink.co.uk>
From:   Mikko Perttunen <cyndis@kapsi.fi>
Message-ID: <b3a7037c-4568-dcd3-3e03-d8031cc749b2@kapsi.fi>
Date:   Mon, 11 Jan 2021 17:49:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <16a0be21-2cbe-dd0e-aed7-b84f6abcacac@codethink.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 84.249.134.236
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/21 5:04 PM, Ben Dooks wrote:
> On 11/01/2021 14:27, Mikko Perttunen wrote:
>> From: Muhammed Fazal <mfazale@nvidia.com>
>>
>> Ignore I2C_M_DMA_SAFE flag as it does not make a difference
>> for bpmp-i2c, but causes -EINVAL to be returned for valid
>> transactions.
>>
>> Signed-off-by: Muhammed Fazal <mfazale@nvidia.com>
>> Cc: stable@vger.kernel.org # v4.19+
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>> This fixes failures seen with PMIC probing tools on
>> Tegra186+ boards.
>>
>>   drivers/i2c/busses/i2c-tegra-bpmp.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/i2c/busses/i2c-tegra-bpmp.c 
>> b/drivers/i2c/busses/i2c-tegra-bpmp.c
>> index ec7a7e917edd..998d4b21fb59 100644
>> --- a/drivers/i2c/busses/i2c-tegra-bpmp.c
>> +++ b/drivers/i2c/busses/i2c-tegra-bpmp.c
>> @@ -80,6 +80,9 @@ static int tegra_bpmp_xlate_flags(u16 flags, u16 *out)
>>           flags &= ~I2C_M_RECV_LEN;
>>       }
>> +    if (flags & I2C_M_DMA_SAFE)
>> +        flags &= ~I2C_M_DMA_SAFE;
>> +
> 
> Just a comment, you can do without the test here.
> Just doing this would have been fine:
> 
>      flags &= ~I2C_M_DMA_SAFE;
> 
> 
> 

Yep, I'll send a v2.

thanks,
Mikko
