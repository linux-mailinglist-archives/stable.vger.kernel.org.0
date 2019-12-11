Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255F011A9E1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 12:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfLKL20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 06:28:26 -0500
Received: from first.geanix.com ([116.203.34.67]:51764 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbfLKL20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 06:28:26 -0500
Received: from [192.168.100.11] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id B82EA3BE;
        Wed, 11 Dec 2019 11:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1576063674; bh=6NjacTLmI9/2FhGe+KVLw5pqz9mUqWx/cQOjcMN4K1o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=DCGFUePDiXBYmZyFjiMfRqao9QX4/HwdcvCeTqBDBOf0EDHOvOHW9Yofo/U7GHhWt
         TToljrnT2Jk+ThcDxfxoO+zSXe7bOAA+miquVGKBhbaR9wjgZCB6wAZfpnFYo/u75J
         7gG9ylDEiEWNRoVUA3W9nbmc9YaIcs29+43xVz14TSsLGQaEOrncwRapuywVlKH4fs
         Vr1KMuyvkXAdFS+CcLjm2JJGAr0RYiB6auQ3W6P1A1VHqTLN7xSdQEIdbIagZ1IWwf
         Bq3ooxzLDtbo8e78we57blaDAPtURKOVspfKBn0Ev04arBdSGAw1A59+A27YWPahNR
         /5Cvg4/mDl0eA==
Subject: Re: [PATCH v3 1/2] can: m_can: tcan4x5x: put the device out of
 standby before register access
To:     Marc Kleine-Budde <mkl@pengutronix.de>, dmurphy@ti.com,
        linux-can@vger.kernel.org
Cc:     martin@geanix.com, stable@vger.kernel.org
References: <20191211064208.84656-1-sean@geanix.com>
 <8b1682ad-c291-252e-c768-63a7a4801aff@pengutronix.de>
 <bc0014ec-7302-97f4-5d71-8d029b0fb1fb@geanix.com>
 <41d13619-fab8-ca19-c340-c80cd80d117e@pengutronix.de>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <ae996f9a-e50d-8f31-7457-c7fb461f5c9e@geanix.com>
Date:   Wed, 11 Dec 2019 12:28:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <41d13619-fab8-ca19-c340-c80cd80d117e@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 8b5b6f358cc9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/12/2019 10.44, Marc Kleine-Budde wrote:
> On 12/11/19 10:13 AM, Sean Nyekjaer wrote:
>>>> When the tcan device comes out of reset it comes out in standby mode.
>>>> The m_can driver tries to access the control register but fails due to
>>>> the device is in standby mode.
>>>> So this patch will put the tcan device in normal mode before the m_can
>>>> driver does the initialization.
>>>>
>>>> Fixes: a229abeed7f7 ("can: tcan4x5x: Turn on the power before parsing the config")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
>>>
>>> Applied both to linux-can.
>>
>> Oh, the commit id for "can: tcan4x5x: Turn on the power before parsing
>> the config" have changed, since this morning :)
> 
> Ahh, I see.
> 
> Until there is a pull request (including a tag) the testing branch is
> subject to rebase. Meaning, when there is a patch, that needs update I'm
> happy to squash things into it.
> 
> I'm squashing there two commits into one:

It's two different authors :-)
> 
>> # This is a combination of 2 commits.
>> # This is the 1st commit message:
>>
>> can: tcan4x5x: Turn on the power before parsing the config
>>
>> The parse config function now performs action on the device either
>> reading or writing and a reset.  If the regulator is managed it needs
>> to be turned on.  So turn on the regulator if available if the parsing
>> fails then turn off the regulator.
>>
>> Fixes: a5235f3c7c23 ("can: tcan45x: Make wake-up GPIO an optional GPIO")
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>
>> # This is the commit message #2:
>>
>> can: tcan4x5x: put the device out of standby before register access
>>
>> The m_can tries to detect if Non ISO Operation is available while in
>> standby, this function results in the following error:
>>
>> tcan4x5x spi2.0 (unnamed net_device) (uninitialized): Failed to init module
>> tcan4x5x spi2.0: m_can device registered (irq=84, version=32)
>> tcan4x5x spi2.0 can2: TCAN4X5X successfully initialized.
>>
>> When the tcan device comes out of reset it comes out in standby mode.
>> The m_can driver tries to access the control register but fails due to
>> the device is in standby mode.
>>
>> So this patch will put the tcan device in normal mode before the m_can
>> driver does the initialization.
>>
>> Fixes: a229abeed7f7 ("can: tcan4x5x: Turn on the power before parsing the config")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> Can you give me an updated commit message?
> 

I think it would be better to update the fixes tag :)

Could update the fixes tag for with the new commit id...

/Sean
