Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC8735D103
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 21:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbhDLTZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 15:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbhDLTZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 15:25:41 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06954C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 12:25:22 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e14so716127ils.12
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 12:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xyGwau3Qr56l27OA1EcdnFAGWFqShnNtotphtxZHKTQ=;
        b=I95kqT71BKKjaT+RKf0vToul4/62n/FFKjghQ4hfIau3nd2I+2AYgL8l6iAX2Zit9K
         YgR5bc2FVHDL6Q7KpgTwq/fKmzcF3F2jxNEqw4CvPwtWAgcZuzkWEpa6zd3khsdlD6Ve
         C4PMfi4py65Z4EoPVEP5xTQYtMAutdzwuB95I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xyGwau3Qr56l27OA1EcdnFAGWFqShnNtotphtxZHKTQ=;
        b=s0KBjxrCK95rkA1llftrH/C0QZEi+8dHZEMfy9q/E5xTtI3cys7lY4EVJYiWcTXnPW
         FH6LwBtAetdCDn5lZWhhAepMZx8gPHuM6intxNAMKTZpy5frmKCol5YPo2XXVW0U3pE0
         NJOSMp6LTLXYUjln+ghQ5NosfAa+0VOYTVwbGRAZciYwQQxb57qPM4JxgCUK6ABnV//U
         T4CscKntwTeqa7tCK6XKDdgghi18k21dh2Te8OKcr/RMAj8RzQCbqFhYziFqqRzXI1Gk
         oMWae/2unNPzRgi04p5j7YehCqvjmtiUY4m7EhSo2nVARq3Y2YHR7GrY7GfYDZlr0yz+
         JECA==
X-Gm-Message-State: AOAM531De1lKc+vmNvrIQURZkDMX11hxg/7H4VYXbGdNJ0IFn80rOx6O
        rfddLi+vWIU2MBt+sfhS70f2yQ==
X-Google-Smtp-Source: ABdhPJx+AHlmljxsgKf7jp/3Yekvrwqu7uiA0t/FOt058NfjLpWT/VIAULXs/6Z4vV56nNBzvOK2sw==
X-Received: by 2002:a92:3002:: with SMTP id x2mr22461277ile.116.1618255521513;
        Mon, 12 Apr 2021 12:25:21 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k20sm4626734iob.38.2021.04.12.12.25.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 12:25:21 -0700 (PDT)
Subject: Re: [PATCH] usbip: Fix incorrect double assignment to udc->ud.tcp_rx
To:     Tom Seewald <tseewald@gmail.com>, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210412185902.27755-1-tseewald@gmail.com>
 <4fc29f02-2284-70a2-2995-407f5c45b11f@gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0a4197a2-d417-dca5-20fe-908bb5e76b55@linuxfoundation.org>
Date:   Mon, 12 Apr 2021 13:25:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <4fc29f02-2284-70a2-2995-407f5c45b11f@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/21 1:06 PM, Tom Seewald wrote:
> On 4/12/21 1:59 PM, Tom Seewald wrote:
> 
>> commit 9858af27e69247c5d04c3b093190a93ca365f33d upstream.
>>
>> Currently udc->ud.tcp_rx is being assigned twice, the second assignment
>> is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.
>>
>> Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
>> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> Cc: stable <stable@vger.kernel.org>
>> Addresses-Coverity: ("Unused value")
>> Link: https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Tom Seewald <tseewald@gmail.com>
>> ---
>>   drivers/usb/usbip/vudc_sysfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
>> index f44d98eeb36a..51cc5258b63e 100644
>> --- a/drivers/usb/usbip/vudc_sysfs.c
>> +++ b/drivers/usb/usbip/vudc_sysfs.c
>> @@ -187,7 +187,7 @@ static ssize_t store_sockfd(struct device *dev,
>>   
>>   		udc->ud.tcp_socket = socket;
>>   		udc->ud.tcp_rx = tcp_rx;
>> -		udc->ud.tcp_rx = tcp_tx;
>> +		udc->ud.tcp_tx = tcp_tx;
>>   		udc->ud.status = SDEV_ST_USED;
>>   
>>   		spin_unlock_irq(&udc->ud.lock);
> I sent this because I believe this patch needs to be backported to the
> 4.9.y and 4.14.y stable trees.
> 

Tom,

Correct. This needs proting to 4.14 and 4.9. However, you have to also
backport the patch it fixes to 4.14 and 4.9

46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")

You can combine the two patches when you backport to 4.14 and 4.9 and
add both upstream commits in the change log.

thanks,
-- Shuah
