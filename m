Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65DF31869AE
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbgCPLCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:02:32 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58230 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730678AbgCPLCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:02:31 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02GB2RrR069056;
        Mon, 16 Mar 2020 06:02:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584356547;
        bh=uziNMzww+JOywfVEJnrMifvzp7H2oZKOv4lFfT1hve8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=fwUTdlv7NDtnHpD+1kpQG2IXqN3BKfKgqlad50bChOYypL7DB6vwPr+09Tp9lX2d3
         vwFVeqAgwsRZbUsWlUKCLSa3wENeEIDKVFuC8w12DK0RQhcsi6id0EV1bGWr22fLs3
         cQ2OCnDuqe0qDfjd/nkNCdgogJStQ2EQIBmARq44=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02GB2RuU124740
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Mar 2020 06:02:27 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 16
 Mar 2020 06:02:26 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 16 Mar 2020 06:02:26 -0500
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02GB2Ofi116919;
        Mon, 16 Mar 2020 06:02:25 -0500
Subject: Re: [PATCH] media: ti-vpe: cal: fix DMA memory corruption
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>,
        <stable@vger.kernel.org>
References: <20200313082639.7743-1-tomi.valkeinen@ti.com>
 <20200313140311.GF4751@pendragon.ideasonboard.com>
 <79e87213-6648-8056-1db5-718ed3963ed3@ti.com>
 <20200316102830.GT4732@pendragon.ideasonboard.com>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <c8da227e-0495-d938-a4a3-14e02f344258@ti.com>
Date:   Mon, 16 Mar 2020 13:02:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316102830.GT4732@pendragon.ideasonboard.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16/03/2020 12:28, Laurent Pinchart wrote:
> Hi Tomi,
> 
> On Fri, Mar 13, 2020 at 04:18:13PM +0200, Tomi Valkeinen wrote:
>> On 13/03/2020 16:03, Laurent Pinchart wrote:
>>
>>>> +	/* wait for stream and dma to finish */
>>>> +	dma_act = true;
>>>> +	timeout = jiffies + msecs_to_jiffies(500);
>>>> +	while (dma_act && time_before(jiffies, timeout)) {
>>>> +		msleep(50);
>>>> +
>>>> +		spin_lock_irqsave(&ctx->slock, flags);
>>>> +		dma_act = ctx->dma_act;
>>>> +		spin_unlock_irqrestore(&ctx->slock, flags);
>>>> +	}
>>>
>>> Waiting for the transfer to complete seems to be a good idea, but how
>>> about using a wait queue instead of such a loop ? That would allow
>>> better usage of CPU time and faster reaction time, and shouldn't be
>>> difficult to implement. You may also want to replace dma_act with a
>>> state if needed (in case you need to express running/stopping/stopped
>>> states), and I would rename it to running if you just need a boolean.
>>
>> Maybe, but I wasn't sure how to implement it safely.
>>
>> So, when we call csi2_ppi_disable() (just above the wait code above), the HW will stop the DMA after
>> the next frame has ended.
>>
>> But there's no way to know in the irq handler if the DMA transfer that just ended was the last one
>> or not. And I don't see how I could set a "disabling" flag before calling csi2_ppi_disable(), as I
>> think that would always be racy with the irq handler.
>>
>> So I went with a safe way: call csi2_ppi_disable(), then wait a bit so that we are sure that either
>> 1) the last frame is on going 2) the last frame has finished (instead of the previous-to-last frame
>> is on going or finished). Then see if the DMA is active. If yes, we loop for it to end.
>>
>> I think the loop could be replaced with a wait queue, but we still need the initial sleep to ensure
>> we don't end the wait when the previous-to-last frame DMA has been finished.
> 
> I think you can solve this by introducing a new enum state field with
> RUNNING, STOPPING and STOPPED values, protected by a spinlock. Here's
> what I have in the VSP1 driver for instance:

I'm still unsure if such approach would work.

When we're handling DMA-stopped irq, we cannot know if the HW will start transferring a new frame 
right afterwards. Even if we track the call to csi2_ppi_disable(), which disables the interface, we 
cannot know if that call actually happened in time.

So, a sequence like this (H = hardware, 1 - thread 1, 2 - thread 2):

H  Frame ends
H  DMA stops
H  DMA stopped HW irq
1  ISR starts running
H  Frame starts
2  csi2_ppi_disable()
H  DMA starts
1  ISR sees DMA-stopped irq and PPI is disabled, so last frame.
    But PPI disable was called after frame start, so DMA is
    running again, and we'll get DMA started irq soon

  Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
