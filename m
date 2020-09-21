Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8C8273049
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgIURED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:04:03 -0400
Received: from aibo.runbox.com ([91.220.196.211]:47404 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730241AbgIURD4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 13:03:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject;
        bh=k/3RqlGP8umWH2V93M6YMNwduu9r1I/7Qp6CppItaag=; b=NHhciC5X9b1ZYCcMcGv44DoB4j
        adsPaAS9yxY6y2YM6cW1+9FuyBCn2NhvOngFDSMgzZQ9EmcznSZ1xufTE0CVxx7rxxaT00hpuRCGa
        fhQfNbOzot+waY6OUzXxHu1PLiiXzkV4t86mS6jRdqt3IcFvOTixdNndLKwEI0qKDg0dsNQmfAbKg
        gAZ23E8apb7XcdjvhEtrxmdtm+dTSHPfeI6dwYj6EjbcBcYuT6XQcDkWDf/WUNn/VlyCyc3kECr3+
        seqkIlz1U8v+6esmXPtxnxKjISrjuUbSpHmGpCoOPTH2gVM658+Av+tph6+w5YHwlG3fcvFhvUM9n
        9m1Yc9uA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kKPEE-0004cE-Jt; Mon, 21 Sep 2020 19:03:50 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kKPDx-00035C-DB; Mon, 21 Sep 2020 19:03:33 +0200
Subject: Re: [PATCH 3/3] usbip: Make the driver's match function specific
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Bastien Nocera <hadess@hadess.net>,
        Andrey Konovalov <andreyknvl@google.com>,
        stable@vger.kernel.org,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com
References: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
 <20200917144151.355848-1-m.v.b@runbox.com>
 <20200917144151.355848-3-m.v.b@runbox.com>
 <45badff8-53e9-359d-4bf2-b0f71b910b2f@linuxfoundation.org>
 <e64f51b0-db05-e078-af58-b31a0be1e9ca@runbox.com>
 <e6404ae3-4b4e-f8d4-4c92-a71410e20569@runbox.com>
 <d6d43c46-3231-7e64-b708-d1fe8349e8a3@linuxfoundation.org>
 <1580e066-41e6-ec74-7427-1dd0cdabcf90@runbox.com>
Message-ID: <9f332d7b-e33d-ebd0-3154-246fbfb69128@runbox.com>
Date:   Mon, 21 Sep 2020 20:03:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1580e066-41e6-ec74-7427-1dd0cdabcf90@runbox.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/09/2020 16.54, M. Vefa Bicakci wrote:
> On 18/09/2020 18.49, Shuah Khan wrote:
>> On 9/18/20 8:31 AM, M. Vefa Bicakci wrote:
>>> Hello Shuah,
>>>
>>> I have just cleaned up the patches and run usbip_test.sh with a kernel without
>>> the patches in this series and with a kernel in this series.
>>>
>>> I noticed that there is a change in behaviour due to the fact that the new
>>> match function (usbip_match) does not always return true. This causes the
>>> stub device driver's probe() function to not get called at all, as the new
>>> more selective match function will prevent the stub device driver from being
>>> considered as a potential driver for the device under consideration.
>>>
>>
>> Yes. This is the behavior I am concerned about and hence the reason
>> to use the usbip test to verify this doesn't happen.
>>
>> With the patch you have the usbip match behavior becomes restrictive
>> which isn't desirable.
>>
>>> All of this results in the following difference in the logs of the usbip_test.sh,
>>> where the expected kernel log message "usbip-host 2-6: 2-6 is not in match_busid table... skip!"
>>> is not printed by a kernel that includes the patches in this series.
>>>
>>> --- unpatched_kernel_log.txt  2020-09-18 17:12:10.654000000 +0300
>>> +++ patched_kernel_log.txt  2020-09-18 17:12:10.654000000 +0300
>>> @@ -213,70 +213,69 @@
>>>       |__ Port 1: Dev 2, If 0, Class=Human Interface Device, Driver=usbhid, 480M
>>>   ==============================================================
>>>   modprobe usbip_host - does it work?
>>>   Should see -busid- is not in match_busid table... skip! dmesg
>>>   ==============================================================
>>> -usbip-host 2-6: 2-6 is not in match_busid table... skip!
>>>   ==============================================================
>>>
>>> Do you find this change in behaviour unacceptable?
>>
>> Yeah. This behavior isn't acceptable.
>>
>> If no, I can remove this
>>> test case from usbip_test.sh with the same patch. If yes, then there is a need
>>> for a different solution to resolve the unexpected negative interaction between
>>> Bastien's work on generic/specific USB device driver selection and usbip
>>> functionality.
>>>
>>
>> I would recommend finding a different solution. Now that you have the
>> usbip test handy, you can verify and test for regressions.
>>
>> thanks,
>> -- Shuah
> 
> Thanks for the feedback, Shuah. I spent some time looking at and instrumenting
> the code in an attempt to find another solution, but have not found one.
> 
> If the generic/specific USB driver selection functionality that Bastien Nocera
> introduced is desired to stay in the kernel, then making usbip_match more
> specific appears to be the only option for usbip to be functional without
> negatively affecting other device drivers.
> 
> Should Bastien's work be reverted until a solution to this issue is found?
> Would you (or anyone) have any suggestions? I would be happy to work further
> on resolving this issue.

Hello again,

Status update: I found a solution that should be more acceptable. It involves
some changes to the generic/specialized driver selection code and the removal
of usbip_match altogether, while preserving proper behaviour of the usbip driver,
apple-mfi-fastcharge and dummy_hcd. I intend to publish a new patch set by
tomorrow.

Vefa
