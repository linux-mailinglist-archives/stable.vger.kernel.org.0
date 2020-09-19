Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6286E270E3B
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 15:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgISNyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 09:54:47 -0400
Received: from aibo.runbox.com ([91.220.196.211]:46168 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgISNyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Sep 2020 09:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:Subject:From;
        bh=iPHWx2JUAUbIcISqbiln9SvsImo21k4OI04gLx1TxnU=; b=XyOztFjj4B18FXgIhNL3GUVH+A
        PFnTIEfM1KaZsDoVzSP4GoydKYNvopMaTatgeMMY1RmcPdn1XC8UZxhUx/fzip8PcLvJUcbXH26NO
        1NFWabAjYowd9rie5vFj/tmVf+sBqESfyFxLNZprAB31PPhzeorwmLLl9L5caz3XE8EIYZ51wFKLg
        9Jm4b6vLc/ok3rvV37lW/otOqODSkfOd3G+CKHpeD4C47+H6WisH7+iR1pG5ftXqj5uT0oUdILmf1
        VWl4EfSuLhXKXK/maa/HDewqzm5MIY9g5Ps/Xmr06YFDTNHoHP5pc08+fgIRNlSpVK8ZRrFjfVwOf
        +3+67/sA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kJdK6-0006qk-Ik; Sat, 19 Sep 2020 15:54:42 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kJdJp-0002Zg-HG; Sat, 19 Sep 2020 15:54:25 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: Re: [PATCH 3/3] usbip: Make the driver's match function specific
To:     Shuah Khan <skhan@linuxfoundation.org>, linux-usb@vger.kernel.org,
        Bastien Nocera <hadess@hadess.net>
Cc:     Andrey Konovalov <andreyknvl@google.com>, stable@vger.kernel.org,
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
Message-ID: <1580e066-41e6-ec74-7427-1dd0cdabcf90@runbox.com>
Date:   Sat, 19 Sep 2020 16:54:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <d6d43c46-3231-7e64-b708-d1fe8349e8a3@linuxfoundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/09/2020 18.49, Shuah Khan wrote:
> On 9/18/20 8:31 AM, M. Vefa Bicakci wrote:
>> Hello Shuah,
>>
>> I have just cleaned up the patches and run usbip_test.sh with a kernel without
>> the patches in this series and with a kernel in this series.
>>
>> I noticed that there is a change in behaviour due to the fact that the new
>> match function (usbip_match) does not always return true. This causes the
>> stub device driver's probe() function to not get called at all, as the new
>> more selective match function will prevent the stub device driver from being
>> considered as a potential driver for the device under consideration.
>>
> 
> Yes. This is the behavior I am concerned about and hence the reason
> to use the usbip test to verify this doesn't happen.
> 
> With the patch you have the usbip match behavior becomes restrictive
> which isn't desirable.
> 
>> All of this results in the following difference in the logs of the usbip_test.sh,
>> where the expected kernel log message "usbip-host 2-6: 2-6 is not in match_busid table... skip!"
>> is not printed by a kernel that includes the patches in this series.
>>
>> --- unpatched_kernel_log.txt  2020-09-18 17:12:10.654000000 +0300
>> +++ patched_kernel_log.txt  2020-09-18 17:12:10.654000000 +0300
>> @@ -213,70 +213,69 @@
>>       |__ Port 1: Dev 2, If 0, Class=Human Interface Device, Driver=usbhid, 480M
>>   ==============================================================
>>   modprobe usbip_host - does it work?
>>   Should see -busid- is not in match_busid table... skip! dmesg
>>   ==============================================================
>> -usbip-host 2-6: 2-6 is not in match_busid table... skip!
>>   ==============================================================
>>
>> Do you find this change in behaviour unacceptable?
> 
> Yeah. This behavior isn't acceptable.
> 
> If no, I can remove this
>> test case from usbip_test.sh with the same patch. If yes, then there is a need
>> for a different solution to resolve the unexpected negative interaction between
>> Bastien's work on generic/specific USB device driver selection and usbip
>> functionality.
>>
> 
> I would recommend finding a different solution. Now that you have the
> usbip test handy, you can verify and test for regressions.
> 
> thanks,
> -- Shuah

Thanks for the feedback, Shuah. I spent some time looking at and instrumenting
the code in an attempt to find another solution, but have not found one.

If the generic/specific USB driver selection functionality that Bastien Nocera
introduced is desired to stay in the kernel, then making usbip_match more
specific appears to be the only option for usbip to be functional without
negatively affecting other device drivers.

Should Bastien's work be reverted until a solution to this issue is found?
Would you (or anyone) have any suggestions? I would be happy to work further
on resolving this issue.

I am including a summary of my findings below my signature.

Thank you,

Vefa

=== === ===

(1) If usbip_match stays as is, then the issue reported by Andrey Konovalov at

       https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/

     will remain unresolved and will trickle down to Linux 5.9 due to the following
     commit's interaction with the return-true usbip_match function:

       USB: Simplify USB ID table match
       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=master&id=0ed9498f9ecfde50c93f3f3dd64b4cd5414d9944

     This commit was mis-classified as a simplification rather than a bug-fix
     and was not backported to linux-5.8.y. (I can explain my reasoning if beneficial.)
     After cherry-picking this commit onto 5.8.10, I can reproduce Andrey's issue
     with Andrey's "keyboard" program at: https://github.com/xairy/raw-gadget.git

(2) If the following patches are also included in the kernel to fix two bugs in the
     USB driver selection logic, then a return-true usbip_match function will cause
     usbip's stub driver to be selected as the more specific device driver for all
     USB devices when the usbip_host module is loaded. (This makes all USB devices
     unavailable on my system, until I unload usbip_host and reload {x,e}hci-pci
     modules.)

       usbcore/driver: Fix specific driver selection
       https://marc.info/?l=linux-usb&m=160037262607960&q=mbox

       usbcore/driver: Fix incorrect downcast
       https://lore.kernel.org/linux-usb/20200917144151.355848-2-m.v.b@runbox.com/

     I realize that this impact statement does not match my previous description at

        https://lore.kernel.org/linux-usb/363eab9a-c32a-4c60-4d6b-14ae8d873c52@runbox.com/

     which was because I had forgotten to cherry pick 0ed9498f9e ("USB: Simplify
     USB ID table match"; i.e., the commit discussed in the previous bullet point)
     onto my v5.8.10-based test kernel.
