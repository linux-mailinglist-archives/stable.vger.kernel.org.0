Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A3665EB5D
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbjAEM73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbjAEM7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:59:11 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107B750E78;
        Thu,  5 Jan 2023 04:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1672923516;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=mblklxT3tdQtGNGyWhlxjvyTs/AQhdvYqP4MC7Rdv9A=;
    b=E0xkbpakXWEcZb/OM4L76y5jo9ARBrDIx3LPgWhCBPap3F9QwnaqRZh0i5ur1IN+Vb
    OhLnvNc5g0hnubHXFDsbCB37vAw6b87pcVaPlIDbCzWVXPDgmd/sb6PM+3Ubz4H19kpU
    inObWo4RTnRi0hPRNqg3f0h1dX0UytVZbD6w8mrJfe0O2mkJGhN/37pESYT87PjKHj9W
    YvGDJeiMPRo75O05qga4W10TXjnN46t/OU2/0B9yT2TzqEC2p/6pe0Zpz0QyONocUAHS
    a6dzbV7I60ByHMPvuGw81yb/K+BoucfX1sHjPxmVUCCZ6gtXc+wzT3DUKxwNuk2+TM8X
    AW1A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR5J8xpzl0="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.47]
    by smtp.strato.de (RZmta 48.2.1 DYNA|AUTH)
    with ESMTPSA id j06241z05CwZ2q3
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 5 Jan 2023 13:58:35 +0100 (CET)
Message-ID: <20bef3ed-47ef-8042-6b98-1f498b81962f@hartkopp.net>
Date:   Thu, 5 Jan 2023 13:58:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] can: isotp: handle wait_event_interruptible() return
 values
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, stable@vger.kernel.org
References: <20230104164605.39666-1-socketcan@hartkopp.net>
 <20230105093226.alchrnm34s6tmfpp@pengutronix.de>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20230105093226.alchrnm34s6tmfpp@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 05.01.23 10:32, Marc Kleine-Budde wrote:
> On 04.01.2023 17:46:05, Oliver Hartkopp wrote:
>> When wait_event_interruptible() has been interrupted by a signal the
>> tx.state value might not be ISOTP_IDLE. Force the state machines
>> into idle state to inhibit the timer handlers to continue working.
>>
>> Cc: stable@vger.kernel.org # >= v5.15
>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> Can you add a Fixes: tag?

Yes. Sent out a V3.

In fact I was not sure if it makes sense to apply the patch down to 
Linux 5.10 as it might increase the possibility to trigger a WARN(1) in 
the isotp_tx_timer_handler().

The patch is definitely helpful for the latest code including commit 
4b7fe92c0690 ("can: isotp: add local echo tx processing for consecutive 
frames") introduced in Linux 5.18 and its fixes.

I did some testing with very long ISOTP PDUs and killed the waiting 
isotp_release() with a Crtl-C.

To prevent the WARN(1) we might also stick this patch to

Fixes: 866337865f37 ("can: isotp: fix tx state handling for echo tx 
processing")

What do you think about the WARN(1)?

Best regards,
Oliver
