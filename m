Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25A23BB808
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhGEHol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:44:41 -0400
Received: from first.geanix.com ([116.203.34.67]:49190 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230033AbhGEHok (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 03:44:40 -0400
Received: from localhost (80-62-117-165-mobile.dk.customer.tdc.net [80.62.117.165])
        by first.geanix.com (Postfix) with ESMTPSA id 04F814C528F;
        Mon,  5 Jul 2021 07:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1625470922; bh=dgpgbFO+AkeqP2aXFDpwiwm4oc+y3Uzbs8GvMijlFxw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To;
        b=f5URPZai2agU/HGKuv5ZFecSTAuW6f5YrAmez15mBR/3bvpFC3Wka4WqcipDIoxQk
         Log0IGZV+zy7UxcBWnXavpug/0Fch+vE0WZPEqqkiweJpz6BIkWh+XHxm9vIsSBPHS
         saWNN/4eInPczVyiNLCSZBzwx8Cn34Z9Gci++1Trk4cRCtAzS/wZYpwAA+rY3dfvJV
         IbkdqkQ0/KDHQraPKR0PXyyvq0R+VGNtvvFmLAMXEupdZ9iaX+cy2a3h84TWAmPSZE
         TTjbwPeNE+mEh7a2ZgwG15949w+XSYU+TA/A0RpiW4KxZrMcrXhA3N3lGNcHuqAMC/
         BoeMeqWS2X7lg==
From:   Esben Haabendal <esben@geanix.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 055/101] net: ll_temac: Add memory-barriers for TX
 BD access
References: <20210628142607.32218-1-sashal@kernel.org>
        <20210628142607.32218-56-sashal@kernel.org>
        <20210703152218.GD3004@amd>
Date:   Mon, 05 Jul 2021 09:42:01 +0200
In-Reply-To: <20210703152218.GD3004@amd> (Pavel Machek's message of "Sat, 3
        Jul 2021 17:22:18 +0200")
Message-ID: <87zgv1tdfa.fsf@geanix.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pavel Machek <pavel@denx.de> writes:

> Hi!
>
>> Add a couple of memory-barriers to ensure correct ordering of read/write
>> access to TX BDs.
>
> So... this is dealing with CPU-to-device consistency, not CPU-to-CPU,
> right?

Actually, One of both.  When looping over the buffers, looking for CMPLT
bit in APP0 (in temac_start_xmit_done()), the challenge is CPU-to-device
consistency, as the CMPLT bit is set by device, and read by CPU.

But when we clear APP0 (and the other fields) in the same loop, it is
CPU-to-CPU, as APP0 is cleared by CPU and read by CPU.

>
>> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
>> @@ -774,12 +774,15 @@ static void temac_start_xmit_done(struct net_device *ndev)
>>  	stat = be32_to_cpu(cur_p->app0);
>>  
>>  	while (stat & STS_CTRL_APP0_CMPLT) {
>> +		/* Make sure that the other fields are read after bd is
>> +		 * released by dma
>> +		 */
>> +		rmb();
>>  		dma_unmap_single(ndev->dev.parent,
>
> Full barrier, as expected.
>
>> @@ -788,6 +791,12 @@ static void temac_start_xmit_done(struct net_device *ndev)
>>  		ndev->stats.tx_packets++;
>>  		ndev->stats.tx_bytes += be32_to_cpu(cur_p->len);
>>  
>> +		/* app0 must be visible last, as it is used to flag
>> +		 * availability of the bd
>> +		 */
>> +		smp_mb();
>
> SMP-only barrier, but full barrier is needed here AFAICT.

I don't think that is needed.  See above.

/Esben
