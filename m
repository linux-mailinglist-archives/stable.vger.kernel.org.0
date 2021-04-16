Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BC4362409
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 17:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240778AbhDPPfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 11:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243512AbhDPPfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 11:35:01 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3AAC061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 08:34:36 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id k18so23314614oik.1
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 08:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dB5FyefCuAZ8Q7hWFjVljKRKOLdVsOslNHvgih8a9co=;
        b=FSxq0keKb6sQ012CMpVxppG5Mf7kBbWkCLjfEUb/xDE22HbKbt44J3TzM5gYK8Na2j
         3cmPnLaNMKcqVb7CWN0358513m1JP6BCXd5Ezgv4D3um0Kxj9UNDDYGz9pNe4j+ftIHV
         iUNLWihU3tUpvIIdELWENPRjyJXrW3WtGnyj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dB5FyefCuAZ8Q7hWFjVljKRKOLdVsOslNHvgih8a9co=;
        b=n0CPC7dDz00wo/kZe/LCZKY7g+VxQWzp6LbzYkl5sqx6hmExd6urwUB/IBpP8BF/lB
         QR9NQGNhQVdfYhwrxlElGwXc+17pmTUXlMb9RC+trc41GuFsmmi1kkNrsYmE516oQHjb
         AoIxi2D1VnAcBTTeZ7kKP8rX/ScKX17UuwTUlEzUzXDN0GenyJ+++YB2W241Ot2iJDhP
         x/hTE9WLCSePu9R10exdihYtYNrkyxxebANdne77usAk4+02ccbQ5fbnrL5jNwCZb+9a
         WjwIH64LnyEf5nFKqcV8rnsDf7Y2hF88RAalPyAX4WiqQ6ir6F1wvqkft7xtHr449FGH
         hFwQ==
X-Gm-Message-State: AOAM530qIw3b4M9DwZ3xv1H0V3PmYj7iHOLPnfmF8qGltDFiYqOQnr1A
        d3PX78x6zTF+8ab+bI4AzCrckg==
X-Google-Smtp-Source: ABdhPJw2ef5RMxDWuT2tazLvRAVTc9KkdpSljkqB6619tlm49/F7tSbTji95nRyE/dXMhVaRVZDFbA==
X-Received: by 2002:a05:6808:1405:: with SMTP id w5mr6910504oiv.48.1618587275643;
        Fri, 16 Apr 2021 08:34:35 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h59sm1468933otb.29.2021.04.16.08.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 08:34:35 -0700 (PDT)
Subject: Re: [PATCH] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
To:     Tom Seewald <tseewald@gmail.com>, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210412185902.27755-1-tseewald@gmail.com>
 <f3e734e4-afc2-4d7c-8d02-714935b45764@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <997844d3-6bcb-72c5-58aa-776fafd2a32e@linuxfoundation.org>
Date:   Fri, 16 Apr 2021 09:34:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <f3e734e4-afc2-4d7c-8d02-714935b45764@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/16/21 9:32 AM, Shuah Khan wrote:
> On 4/12/21 12:59 PM, Tom Seewald wrote:
>> commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.
>>
>> Currently udc->ud.tcp_rx is being assigned twice, the second assignment
>> is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.
>>
>> Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading 
>> to gpf")
>> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> Cc: stable <stable@vger.kernel.org>
>> Addresses-Coverity: ("Unused value")
>> Link: 
>> https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Tom Seewald <tseewald@gmail.com>
>> ---
>>   drivers/usb/usbip/vudc_sysfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/usbip/vudc_sysfs.c 
>> b/drivers/usb/usbip/vudc_sysfs.c
>> index f44d98eeb36a..51cc5258b63e 100644
>> --- a/drivers/usb/usbip/vudc_sysfs.c
>> +++ b/drivers/usb/usbip/vudc_sysfs.c
>> @@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct device *dev,
>>           udc->ud.tcp_socket = socket;
>>           udc->ud.tcp_rx = tcp_rx;
>> -        udc->ud.tcp_rx = tcp_tx;
>> +        udc->ud.tcp_tx = tcp_tx;
>>           udc->ud.status = SDEV_ST_USED;
>>           spin_unlock_irq(&udc->ud.lock);
>>
> 
> Greg,
> 
> Please pick this up for 4.9 and 4.14
>

Forgot Acked-by :(

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
