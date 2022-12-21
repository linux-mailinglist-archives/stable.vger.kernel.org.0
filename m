Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E948A65355F
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 18:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLURiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 12:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLURiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 12:38:05 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2491F2CD
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 09:38:02 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id cf42so24580050lfb.1
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 09:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/AelPukw/Bge/7D4TE4mpS0Mi8DONwlQdwfLQqx7Viw=;
        b=iJb7JPEhV43mASG2Opvh40XFlzzuj45UkNNp8P8ydysARPR109zfVZDGrsZmuwLTrg
         ceSiJttmIcx/hPGt51w2jnUE8+AkQ1LhtP0xhAdfFeYzd0/A/c1vL8ualdpzX8UKH0i+
         50+jYbnkZh+m1J/kssSPUq09UUk0gWgIY8n/noymyUZSy91AMG9H96Sa6ND7Grs5VMgw
         2rHXxQQhcKlDyaweRtt6x7w8AOgZyRWh+n4AFg3YtFiQYhNtNVFzqmkIloctr2dGqFVs
         8rGOb0DJOesd5ILuXXxVY1Tln7XBV2FWiA9plnNWDtpgp0lPTCt9P3sNlRmNH6hrsL1r
         X9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/AelPukw/Bge/7D4TE4mpS0Mi8DONwlQdwfLQqx7Viw=;
        b=hH4L8wDyWAtJH68O4GdcvJsunTlHbWe8CXm2YnSow1CGebOJRnY0pnHd0Dg2gPic4+
         /FiVoDuhFEpzy3uQLDmMBmmgI+U7JzRCYzPfTXbQCLApui7vK1G44+1iFgzVLOuNqmKG
         J3JQD81QnJh7fAbQPKFE+O9Buhe5hQmL20MoOt06UPHeO/TDj92f7KhggelYjxRl9Yc3
         jK5w7/9bny12uQtaGj8Y/mLI9ctHN6Rie++Urid/13GAZCxYEnXt+yR7ZOYA9PDF8oEf
         q0jOI2dFyS5SUocUqKfFGzRFNV/p9c72F+rugJzQucmHO75GgiGaA1gvrZXhTkE8iFS+
         Voyw==
X-Gm-Message-State: AFqh2kr/tByln6aDThsDUr1ihmy2ntAOyZktomC43HkaqzNReukjcseP
        9wvbYopYjQtJinn/gsIbHIWkUw==
X-Google-Smtp-Source: AMrXdXsrPzQelHePCPmvLJQmIXtxQhBFg1PxGdLa73n0nJSt1ejn4gkd9JRT+ZtnUWrNzEkFDx5hkA==
X-Received: by 2002:a05:6512:1395:b0:4b7:113:9296 with SMTP id p21-20020a056512139500b004b701139296mr1295156lfa.14.1671644281055;
        Wed, 21 Dec 2022 09:38:01 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id v7-20020a056512348700b004b561202ea2sm1889034lfr.182.2022.12.21.09.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 09:38:00 -0800 (PST)
Message-ID: <e2925111-abcf-26fb-59e0-9bd4fb3f7b8e@linaro.org>
Date:   Wed, 21 Dec 2022 18:37:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/2] serdev: ttyport: fix use-after-free on closed TTY
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Zijun Hu <zijuhu@codeaurora.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Sai Teja Aluvala <quic_saluvala@quicinc.com>,
        Panicker Harish <quic_pharish@quicinc.com>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
References: <20221221163249.1058459-1-krzysztof.kozlowski@linaro.org>
 <Y6M2vLV9PM3HfXZY@kroah.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Y6M2vLV9PM3HfXZY@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/12/2022 17:39, Greg Kroah-Hartman wrote:
> On Wed, Dec 21, 2022 at 05:32:48PM +0100, Krzysztof Kozlowski wrote:
>> use-after-free is visible in serdev-ttyport, e.g. during system reboot
>> with Qualcomm Atheros Bluetooth.  The TTY is closed, thus "struct
>> tty_struct" is being released, but the hci_uart_qca driver performs
>> writes and flushes during system shutdown in qca_serdev_shutdown().
>>
>>   Unable to handle kernel paging request at virtual address 0072662f67726fd7
>>   ...
>>   CPU: 6 PID: 1 Comm: systemd-shutdow Tainted: G        W          6.1.0-rt5-00325-g8a5f56bcfcca #8
>>   Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
>>   Call trace:
>>    tty_driver_flush_buffer+0x4/0x30
>>    serdev_device_write_flush+0x24/0x34
>>    qca_serdev_shutdown+0x80/0x130 [hci_uart]
>>    device_shutdown+0x15c/0x260
>>    kernel_restart+0x48/0xac
>>
>> KASAN report:
>>
>>   BUG: KASAN: use-after-free in tty_driver_flush_buffer+0x1c/0x50
>>   Read of size 8 at addr ffff16270c2e0018 by task systemd-shutdow/1
>>
>>   CPU: 7 PID: 1 Comm: systemd-shutdow Not tainted 6.1.0-next-20221220-00014-gb85aaf97fb01-dirty #28
>>   Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
>>   Call trace:
>>    dump_backtrace.part.0+0xdc/0xf0
>>    show_stack+0x18/0x30
>>    dump_stack_lvl+0x68/0x84
>>    print_report+0x188/0x488
>>    kasan_report+0xa4/0xf0
>>    __asan_load8+0x80/0xac
>>    tty_driver_flush_buffer+0x1c/0x50
>>    ttyport_write_flush+0x34/0x44
>>    serdev_device_write_flush+0x48/0x60
>>    qca_serdev_shutdown+0x124/0x274
>>    device_shutdown+0x1e8/0x350
>>    kernel_restart+0x48/0xb0
>>    __do_sys_reboot+0x244/0x2d0
>>    __arm64_sys_reboot+0x54/0x70
>>    invoke_syscall+0x60/0x190
>>    el0_svc_common.constprop.0+0x7c/0x160
>>    do_el0_svc+0x44/0xf0
>>    el0_svc+0x2c/0x6c
>>    el0t_64_sync_handler+0xbc/0x140
>>    el0t_64_sync+0x190/0x194
>>
>> Fixes: bed35c6dfa6a ("serdev: add a tty port controller driver")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> ---
>>  drivers/tty/serdev/serdev-ttyport.c | 24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
>> index d367803e2044..3d2bab91a988 100644
>> --- a/drivers/tty/serdev/serdev-ttyport.c
>> +++ b/drivers/tty/serdev/serdev-ttyport.c
>> @@ -91,6 +91,9 @@ static void ttyport_write_flush(struct serdev_controller *ctrl)
>>  	struct serport *serport = serdev_controller_get_drvdata(ctrl);
>>  	struct tty_struct *tty = serport->tty;
>>  
>> +	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
>> +		return;
> 
> Shouldn't that be a more useful macro/function instead?
> 	serport_is_active(serport)

Sure, makes sense.

> 
> Anyway, what prevents this from changing _right_ after you test it and
> before you call the next line in this function (same for all invocations
> here.)

Eh, you're right. I got suggested by such solution in
ttyport_write_buf() assuming it was correct in the first place. Is
holding tty_lock for entire function here reasonable?

Anyway the issue also is in the caller, which should not talk over
closed TTY, which should be fixed in patch 2.

Best regards,
Krzysztof

