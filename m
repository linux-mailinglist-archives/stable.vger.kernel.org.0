Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF81A26F944
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 11:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgIRJ1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 05:27:07 -0400
Received: from aibo.runbox.com ([91.220.196.211]:58414 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgIRJ1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 05:27:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=+658/XCWKhqnhXrinlJ6VzL+FcyuV3M5zKtRyB3ALqc=; b=RSX827nzK33bkOmLAPunXnUXkC
        nxfI5vI+dHt923aTOrRY4iNw7+7uiQ5l/Pm+DZqQsuBejPOr/CRFzQ+HRwZ4XPsFLUN2gO2SjMD/5
        XjmM70KqMeZQcANmZ/RitoCfMoMqDf3rnVPC4rT7L8fsDtNv8lVMQKBTpGGVuMWCdXRtTbeS/mBVK
        EPlAUG9zjdftk9d6hbzh8Mg225RrDwcTzSvHGuPZVymiy0RHCPRUrG3zzcMLCT+F/1TymyJZF9tKa
        U2/z6LSoui3FMvA/d2SAkxSb4UzYG3z1536wM1ib81a7JlLClCFGQLf+mqu36+E/tKu4DeBq/kcXm
        zschSpIQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kJCfW-0000Eu-Fj; Fri, 18 Sep 2020 11:27:02 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kJCfF-0000Zw-Tl; Fri, 18 Sep 2020 11:26:46 +0200
Subject: Re: [PATCH 3/3] usbip: Make the driver's match function specific
To:     Shuah Khan <skhan@linuxfoundation.org>, linux-usb@vger.kernel.org
Cc:     Andrey Konovalov <andreyknvl@google.com>, stable@vger.kernel.org,
        Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com
References: <a6e14983a8849d5f75a43f403c7cc721b6e4a420.camel@hadess.net>
 <20200917144151.355848-1-m.v.b@runbox.com>
 <20200917144151.355848-3-m.v.b@runbox.com>
 <45badff8-53e9-359d-4bf2-b0f71b910b2f@linuxfoundation.org>
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
Message-ID: <e64f51b0-db05-e078-af58-b31a0be1e9ca@runbox.com>
Date:   Fri, 18 Sep 2020 12:26:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <45badff8-53e9-359d-4bf2-b0f71b910b2f@linuxfoundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17/09/2020 18.21, Shuah Khan wrote:
> On 9/17/20 8:41 AM, M. Vefa Bicakci wrote:
>> Prior to this commit, the USB-IP subsystem's USB device driver match
>> function used to match all USB devices (by returning true
>> unconditionally). Unfortunately, this is not correct behaviour and is
>> likely the root cause of the bug reported by Andrey Konovalov.
>>
>> USB-IP should only match USB devices that the user-space asked the kernel
>> to handle via USB-IP, by writing to the match_busid sysfs file, which is
>> what this commit aims to achieve. This is done by making the match
>> function check that the passed in USB device was indeed requested by the
>> user-space to be handled by USB-IP.
>>
> 
> I see two patches 2/2 and 3/3 back to back. What is the difference
> between 2/2 and 3/3 versions? They look identical. Please include
> changes if any from version to version to make it easier for me to
> review.

Hello Shuah,

Sorry for the delayed reply, and thank you for your interest! I realize
that I did not add notes to the patch series regarding the changes between
v1 and v2, and I forgot to label the second patch series as v2.

Patches 2/2 and 3/3 are the same, as you have mentioned. I was addressing
Bastien's code review comments for patch 1/2, and I split that patch into
two separate patches, which is why the second patch series had 3 patches
as opposed to 2.

I realize that you are missing the context; here is a link to the thread:
   https://lore.kernel.org/linux-usb/359d080c-5cbb-250a-0ebd-aaba5f5c530d@runbox.com/T/

I can copy all patches to you as well, if you would be interested.

All this to say, I am sorry about this small mess, and I will rectify this
with patches I publish in the future.

>> Reported-by: Andrey Konovalov <andreyknvl@google.com>
>> Fixes: 7a2f2974f2 ("usbip: Implement a match function to fix usbip")
>> Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
>> Cc: <stable@vger.kernel.org> # 5.8
>> Cc: Bastien Nocera <hadess@hadess.net>
>> Cc: Valentina Manea <valentina.manea.m@gmail.com>
>> Cc: Shuah Khan <shuah@kernel.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: <syzkaller@googlegroups.com>
>> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
>> ---
>>   drivers/usb/usbip/stub_dev.c | 15 ++++++++++++++-
>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
>> index 9d7d642022d1..3d9c8ff6762e 100644
>> --- a/drivers/usb/usbip/stub_dev.c
>> +++ b/drivers/usb/usbip/stub_dev.c
>> @@ -463,7 +463,20 @@ static void stub_disconnect(struct usb_device *udev)
>>   static bool usbip_match(struct usb_device *udev)
>>   {
>> -    return true;
>> +    bool match;
>> +    struct bus_id_priv *busid_priv;
>> +    const char *udev_busid = dev_name(&udev->dev);
>> +
>> +    busid_priv = get_busid_priv(udev_busid);
>> +    if (!busid_priv)
>> +        return false;
>> +
>> +    match = (busid_priv->status != STUB_BUSID_REMOV &&
>> +         busid_priv->status != STUB_BUSID_OTHER);
>> +
>> +    put_busid_priv(busid_priv);
>> +
>> +    return match;
>>   }
>>   #ifdef CONFIG_PM
>>
> 
> Did you happen to run the usbip test on this patch? If not, can you
> please run tools/testing/selftests/drivers/usb/usbip/usbip_test.sh
> and make sure there are no regressions.

Ah, this is a very good point! I have been testing the patches on Qubes OS,
which uses usbip to forward USB devices between VMs. To be honest, I was not
aware of the self-tests for usbip, and I will run the self-tests prior to
publishing the next version of the patch series.

> thanks,
> -- Shuah

Thank you!

Vefa
