Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B906600D3
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 14:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbjAFNAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 08:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbjAFNAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 08:00:24 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0792F75D12;
        Fri,  6 Jan 2023 05:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1673009998;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ft/wlpfHhe3+YuvCCjuB7CQEkEhwpLGejLvvvKfZx9w=;
    b=WF7OSkeQaulJxUPvQlQPQqUm3zGLPr1kzyMNHaOANe93U23g6IcnUQFv33VV3yKxXE
    HI+Lwwpib1MHlAILR6+lvA2zERfYF7fkBeML3svPNi5BU15KKaUGKKypFgyS1xz/IJei
    npHGL7KDdZTkpcg7oJdnsoDd6v7AYB0N+JGJy8ZS64CwbpyGe8wHoyz4ELwVcmRCOBnm
    xHN7G7cKsb5JsrEm0s7bzJYGHn7nf0FukDhOEaS3hAkW3gdegYQUimK+oA1DOUhBt5YB
    NuYtCd8XDlIRB2lftwGi9r7rG6u7FxSkkMmf4O4Mebslh4LkBpIS0YFChLHv9k012/89
    o3pg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR5J8xpzl0="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.47]
    by smtp.strato.de (RZmta 48.2.1 DYNA|AUTH)
    with ESMTPSA id j06241z06Cxw4vV
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 6 Jan 2023 13:59:58 +0100 (CET)
Message-ID: <0e0e041b-8dd9-0764-3fd1-a426c99ec417@hartkopp.net>
Date:   Fri, 6 Jan 2023 13:59:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] can: isotp: handle wait_event_interruptible() return
 values
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, stable@vger.kernel.org
References: <20230104164605.39666-1-socketcan@hartkopp.net>
 <20230105093226.alchrnm34s6tmfpp@pengutronix.de>
 <20bef3ed-47ef-8042-6b98-1f498b81962f@hartkopp.net>
 <20230106113731.irqfxdpn5ygae44e@pengutronix.de>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20230106113731.irqfxdpn5ygae44e@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 06.01.23 12:37, Marc Kleine-Budde wrote:
> On 05.01.2023 13:58:30, Oliver Hartkopp wrote:
>>
>>
>> On 05.01.23 10:32, Marc Kleine-Budde wrote:
>>> On 04.01.2023 17:46:05, Oliver Hartkopp wrote:
>>>> When wait_event_interruptible() has been interrupted by a signal the
>>>> tx.state value might not be ISOTP_IDLE. Force the state machines
>>>> into idle state to inhibit the timer handlers to continue working.
>>>>
>>>> Cc: stable@vger.kernel.org # >= v5.15
>>>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>>
>>> Can you add a Fixes: tag?
>>
>> Yes. Sent out a V3.
>>
>> In fact I was not sure if it makes sense to apply the patch down to Linux
>> 5.10 as it might increase the possibility to trigger a WARN(1) in the
>> isotp_tx_timer_handler().
>>
>> The patch is definitely helpful for the latest code including commit
>> 4b7fe92c0690 ("can: isotp: add local echo tx processing for consecutive
>> frames") introduced in Linux 5.18 and its fixes.
>>
>> I did some testing with very long ISOTP PDUs and killed the waiting
>> isotp_release() with a Crtl-C.
>>
>> To prevent the WARN(1) we might also stick this patch to
>>
>> Fixes: 866337865f37 ("can: isotp: fix tx state handling for echo tx
>> processing")
>>
>> What do you think about the WARN(1)?
> 
> If this short patch avoids potential WARN()s it's stable material.
> 

It is the other way around. As written above this patch might increase 
the possibility to trigger a WARN(1).

With the patch:

https://lore.kernel.org/linux-can/20230104145701.2422-1-socketcan@hartkopp.net/T/#u

the WARN(1) is removed and this patch here makes the situation better.

Alternatively I could provide another patch for kernels < v6.0 which set 
the rx/tx states AND remove the WARN(1).

Back to your original question about the "Fixes:" tag, I would suggest 
to tag this patch similar to

https://lore.kernel.org/linux-can/20230104145701.2422-1-socketcan@hartkopp.net/T/#u

Namely:

Fixes: 866337865f37 ("can: isotp: fix tx state handling for echo tx 
processing")
Cc: stable@vger.kernel.org # >= v6.0

And later check whether I should remove the WARN(1) in older stable kernels.

Should I send a V4 with the new "Fixes: 866337865f37" tag?

Best regards,
Oliver

