Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A9E184916
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 15:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgCMOSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 10:18:20 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53570 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgCMOSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 10:18:20 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02DEIGBp079520;
        Fri, 13 Mar 2020 09:18:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584109096;
        bh=hC2Sn8brMutbk7gjZTcEULXcnx9TSQxA+J8yxdkxpaI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=xfDqZtZxnQR52JCUyIhv/hWzz/2phkO0xjtE89oLELFXOqovfQzoqOvDsnbX5InfC
         oyuyY040VsONpRxVxCOGGdJs1QU/Bk7RRZgYJ9QOZ6OHijR0I0flJ5ScwW9c6XJbM8
         3fv5ioBfUogJn7XFz5mLu6bRkPQf2R1s5y/T47eQ=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02DEIGVB084211
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Mar 2020 09:18:16 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 13
 Mar 2020 09:18:15 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 13 Mar 2020 09:18:15 -0500
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02DEIEbS045210;
        Fri, 13 Mar 2020 09:18:14 -0500
Subject: Re: [PATCH] media: ti-vpe: cal: fix DMA memory corruption
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>,
        <stable@vger.kernel.org>
References: <20200313082639.7743-1-tomi.valkeinen@ti.com>
 <20200313140311.GF4751@pendragon.ideasonboard.com>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <79e87213-6648-8056-1db5-718ed3963ed3@ti.com>
Date:   Fri, 13 Mar 2020 16:18:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200313140311.GF4751@pendragon.ideasonboard.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/03/2020 16:03, Laurent Pinchart wrote:

>> +	/* wait for stream and dma to finish */
>> +	dma_act = true;
>> +	timeout = jiffies + msecs_to_jiffies(500);
>> +	while (dma_act && time_before(jiffies, timeout)) {
>> +		msleep(50);
>> +
>> +		spin_lock_irqsave(&ctx->slock, flags);
>> +		dma_act = ctx->dma_act;
>> +		spin_unlock_irqrestore(&ctx->slock, flags);
>> +	}
> 
> Waiting for the transfer to complete seems to be a good idea, but how
> about using a wait queue instead of such a loop ? That would allow
> better usage of CPU time and faster reaction time, and shouldn't be
> difficult to implement. You may also want to replace dma_act with a
> state if needed (in case you need to express running/stopping/stopped
> states), and I would rename it to running if you just need a boolean.

Maybe, but I wasn't sure how to implement it safely.

So, when we call csi2_ppi_disable() (just above the wait code above), the HW will stop the DMA after 
the next frame has ended.

But there's no way to know in the irq handler if the DMA transfer that just ended was the last one 
or not. And I don't see how I could set a "disabling" flag before calling csi2_ppi_disable(), as I 
think that would always be racy with the irq handler.

So I went with a safe way: call csi2_ppi_disable(), then wait a bit so that we are sure that either 
1) the last frame is on going 2) the last frame has finished (instead of the previous-to-last frame 
is on going or finished). Then see if the DMA is active. If yes, we loop for it to end.

I think the loop could be replaced with a wait queue, but we still need the initial sleep to ensure 
we don't end the wait when the previous-to-last frame DMA has been finished.

  Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
