Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6741367A44
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 08:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhDVGzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 02:55:42 -0400
Received: from mout01.posteo.de ([185.67.36.141]:56263 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230228AbhDVGzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 02:55:13 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2021 02:55:12 EDT
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 4B3D8240027
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 08:47:24 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4FQnzH0cm6z6tmV;
        Thu, 22 Apr 2021 08:47:22 +0200 (CEST)
Subject: Re: [PATCH 120/190] Revert "tty: atmel_serial: fix a potential NULL
 pointer dereference"
To:     Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>,
        Richard Genoud <richard.genoud@gmail.com>,
        stable <stable@vger.kernel.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-121-gregkh@linuxfoundation.org>
 <57f44dfa-a502-ee4f-6d53-0ab7cba00e1b@kernel.org>
From:   Richard Genoud <richard.genoud@gmail.com>
Message-ID: <ad76449f-0603-a156-85d6-37d3c906b4cc@posteo.net>
Date:   Thu, 22 Apr 2021 06:47:20 +0000
MIME-Version: 1.0
In-Reply-To: <57f44dfa-a502-ee4f-6d53-0ab7cba00e1b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 22/04/2021 à 07:18, Jiri Slaby a écrit :
> On 21. 04. 21, 14:59, Greg Kroah-Hartman wrote:
>> This reverts commit c85be041065c0be8bc48eda4c45e0319caf1d0e5.
>>
>> Commits from @umn.edu addresses have been found to be submitted in "bad
>> faith" to try to test the kernel community's ability to review "known
>> malicious" changes.  The result of these submissions can be found in a
>> paper published at the 42nd IEEE Symposium on Security and Privacy
>> entitled, "Open Source Insecurity: Stealthily Introducing
>> Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
>> of Minnesota) and Kangjie Lu (University of Minnesota).
>>
>> Because of this, all submissions from this group must be reverted from
>> the kernel tree and will need to be re-reviewed again to determine if
>> they actually are a valid fix.  Until that work is complete, remove this
>> change to ensure that no problems are being introduced into the
>> codebase.
>>
>> Cc: Kangjie Lu <kjlu@umn.edu>
>> Cc: Richard Genoud <richard.genoud@gmail.com>
>> Cc: stable <stable@vger.kernel.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>   drivers/tty/serial/atmel_serial.c | 4 ----
>>   1 file changed, 4 deletions(-)
>>
>> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
>> index a24e5c2b30bc..9786d8e5f04f 100644
>> --- a/drivers/tty/serial/atmel_serial.c
>> +++ b/drivers/tty/serial/atmel_serial.c
>> @@ -1256,10 +1256,6 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
>>                        sg_dma_len(&atmel_port->sg_rx)/2,
>>                        DMA_DEV_TO_MEM,
>>                        DMA_PREP_INTERRUPT);
>> -    if (!desc) {
>> -        dev_err(port->dev, "Preparing DMA cyclic failed\n");
>> -        goto chan_err;
>> -    }
> 
> I cannot find anything malicious in the original fix:
> * port->dev is valid for dev_err
> * dmaengine_prep_dma_cyclic returns NULL in case of error
> * chan_err invokes atmel_release_rx_dma which undoes the previous initialization code.
> 
> Hence a NACK from me for the revert.

I agree with your NACK.
Back at the time (march 2019), I reviewed the changed and asked for a 2nd version and
I didn't found anything suspicious.
But the more eyes, the better.

cf http://lkml.iu.edu/hypermail/linux/kernel/1903.1/05858.html

> 
>>       desc->callback = atmel_complete_rx_dma;
>>       desc->callback_param = port;
>>       atmel_port->desc_rx = desc;
>>
> 
> 
