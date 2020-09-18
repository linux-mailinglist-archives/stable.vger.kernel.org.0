Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C6226FFED
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 16:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgIROcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 10:32:02 -0400
Received: from aibo.runbox.com ([91.220.196.211]:39174 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgIROcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 10:32:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject;
        bh=JiTb7IeCRmeEU+pE2dpY6N2mMZW+Z3A95EDmSNkAqyY=; b=Qw6PFKnc2Tt7oK5jTttIu88hDr
        udt12tnZQvhpU/UW1FGplGaW6xKMjSnokT0D1Oe0W5SNQ/cQM8uKvghbkIJHU42SIG3CxRO9H+y0k
        LS7Jlb0/JgUMti9p7Bl+13liH0z6O1fHcLFl2eb6/3qkBgR7W8VgMTGw2OZZkh70QzTJ1VUifZf82
        PTmLeGozypXyFyw8c2VRWncz1OHMjUfHNXHfTN7vM0vHPa4nvJ/M+I/p/iNlBxvXfCq3m+SYM/wrO
        A33mzpA7rgTNwSWuSgPVus8scuja6STgf5bD5LP7XYSWiCGiP6LcM7c7o3GZghUWWLSaZSCzS4DlV
        E7n/pPpA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kJHQa-0001Cs-BW; Fri, 18 Sep 2020 16:31:56 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kJHQG-0007hI-VD; Fri, 18 Sep 2020 16:31:37 +0200
Subject: Re: [PATCH 3/3] usbip: Make the driver's match function specific
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
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
 <e64f51b0-db05-e078-af58-b31a0be1e9ca@runbox.com>
Message-ID: <e6404ae3-4b4e-f8d4-4c92-a71410e20569@runbox.com>
Date:   Fri, 18 Sep 2020 17:31:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <e64f51b0-db05-e078-af58-b31a0be1e9ca@runbox.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/09/2020 12.26, M. Vefa Bicakci wrote:
> On 17/09/2020 18.21, Shuah Khan wrote:
>> On 9/17/20 8:41 AM, M. Vefa Bicakci wrote:
>>> Prior to this commit, the USB-IP subsystem's USB device driver match
>>> function used to match all USB devices (by returning true
>>> unconditionally). Unfortunately, this is not correct behaviour and is
>>> likely the root cause of the bug reported by Andrey Konovalov.
>>>
>>> USB-IP should only match USB devices that the user-space asked the kernel
>>> to handle via USB-IP, by writing to the match_busid sysfs file, which is
>>> what this commit aims to achieve. This is done by making the match
>>> function check that the passed in USB device was indeed requested by the
>>> user-space to be handled by USB-IP.

[snipped by Vefa]

>>> Reported-by: Andrey Konovalov <andreyknvl@google.com>
>>> Fixes: 7a2f2974f2 ("usbip: Implement a match function to fix usbip")
>>> Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
>>> Cc: <stable@vger.kernel.org> # 5.8
>>> Cc: Bastien Nocera <hadess@hadess.net>
>>> Cc: Valentina Manea <valentina.manea.m@gmail.com>
>>> Cc: Shuah Khan <shuah@kernel.org>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: Alan Stern <stern@rowland.harvard.edu>
>>> Cc: <syzkaller@googlegroups.com>
>>> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
>>> ---
>>>   drivers/usb/usbip/stub_dev.c | 15 ++++++++++++++-
>>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
>>> index 9d7d642022d1..3d9c8ff6762e 100644
>>> --- a/drivers/usb/usbip/stub_dev.c
>>> +++ b/drivers/usb/usbip/stub_dev.c
>>> @@ -463,7 +463,20 @@ static void stub_disconnect(struct usb_device *udev)
>>>   static bool usbip_match(struct usb_device *udev)
>>>   {
>>> -    return true;
>>> +    bool match;
>>> +    struct bus_id_priv *busid_priv;
>>> +    const char *udev_busid = dev_name(&udev->dev);
>>> +
>>> +    busid_priv = get_busid_priv(udev_busid);
>>> +    if (!busid_priv)
>>> +        return false;
>>> +
>>> +    match = (busid_priv->status != STUB_BUSID_REMOV &&
>>> +         busid_priv->status != STUB_BUSID_OTHER);
>>> +
>>> +    put_busid_priv(busid_priv);
>>> +
>>> +    return match;
>>>   }
>>>   #ifdef CONFIG_PM
>>>
>>
>> Did you happen to run the usbip test on this patch? If not, can you
>> please run tools/testing/selftests/drivers/usb/usbip/usbip_test.sh
>> and make sure there are no regressions.
> 
> Ah, this is a very good point! I have been testing the patches on Qubes OS,
> which uses usbip to forward USB devices between VMs. To be honest, I was not
> aware of the self-tests for usbip, and I will run the self-tests prior to
> publishing the next version of the patch series.

Hello Shuah,

I have just cleaned up the patches and run usbip_test.sh with a kernel without
the patches in this series and with a kernel in this series.

I noticed that there is a change in behaviour due to the fact that the new
match function (usbip_match) does not always return true. This causes the
stub device driver's probe() function to not get called at all, as the new
more selective match function will prevent the stub device driver from being
considered as a potential driver for the device under consideration.

All of this results in the following difference in the logs of the usbip_test.sh,
where the expected kernel log message "usbip-host 2-6: 2-6 is not in match_busid table... skip!"
is not printed by a kernel that includes the patches in this series.

--- unpatched_kernel_log.txt  2020-09-18 17:12:10.654000000 +0300
+++ patched_kernel_log.txt  2020-09-18 17:12:10.654000000 +0300
@@ -213,70 +213,69 @@
      |__ Port 1: Dev 2, If 0, Class=Human Interface Device, Driver=usbhid, 480M
  ==============================================================
  modprobe usbip_host - does it work?
  Should see -busid- is not in match_busid table... skip! dmesg
  ==============================================================
-usbip-host 2-6: 2-6 is not in match_busid table... skip!
  ==============================================================

Do you find this change in behaviour unacceptable? If no, I can remove this
test case from usbip_test.sh with the same patch. If yes, then there is a need
for a different solution to resolve the unexpected negative interaction between
Bastien's work on generic/specific USB device driver selection and usbip
functionality.

Thank you,

Vefa
