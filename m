Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAFF573762
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiGMN31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiGMN3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:29:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F50012630
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 06:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657718958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uFOLdOBsgcxe9CKH8HCU++bC8nE9+yR90TIi+BCJERQ=;
        b=F4T7mjip6ZdJ2+ySYOtmhKs1Kfiur0sKjkfEdh3pMC/txE1ncoSauwxH8P+Mzm7yljPnxP
        iENhCR+psi1wly/a1IHq3x4vKmiNYRsZeuXmdJJuXptzilBpjKocfVlPAQOgeZJkHhJLCD
        4dyIBSV+QuKd5i5Z1wltXIwmfY+cTf4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-CL5uV1zUN3S_lawcBwdlww-1; Wed, 13 Jul 2022 09:29:09 -0400
X-MC-Unique: CL5uV1zUN3S_lawcBwdlww-1
Received: by mail-ej1-f69.google.com with SMTP id gr1-20020a170906e2c100b006fefea3ec0aso3413645ejb.14
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 06:29:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uFOLdOBsgcxe9CKH8HCU++bC8nE9+yR90TIi+BCJERQ=;
        b=wHK4sZsISRUsV55TEu7arYdIiyFJE8StzvjP+V0hYwUyuOyHvwOzBtw5z64qAgXR6G
         bU9rloDCs2PnwKtfPjMSM/9jr9t18cQNkWFsi8QwLr/PwihDD2MTdz9pp1SUQa0QrZPL
         qmUmh9UM/dUmfx9JgIIrfv7nSb5H78lSCjhv7K0oSHpw9ZZtcHD5j2wR691NVkwhXH5C
         azLtwLAI7V3OmSyY0uUqax6shZwXq9i1Plr3JcNKPtfEBwEDyPpiEL/2Nq4aTIWn7mZS
         EJJxK6iHch6yQRZarDvg+sCZw6NyE//M1wMaUrEBp6zZLv/6iOzd/sfIZqPMvEiNNwn1
         aVqA==
X-Gm-Message-State: AJIora+zlKssQpikMoh4f34sr2oWRe5brSXAYBferJeGZ44H5iulucr6
        MVZLbMiK6cb264fOYo5qGu2xduJEMvnvW1UHbIl2K/PCA9L9TzBZ8aU71CsOPWyfYg5dl550pia
        IhMCQiBlj2wCXNHqy
X-Received: by 2002:a17:906:d54f:b0:726:2c7c:c0f9 with SMTP id cr15-20020a170906d54f00b007262c7cc0f9mr3524214ejc.441.1657718947457;
        Wed, 13 Jul 2022 06:29:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vfcNTB8jRcdcMzJ3HSzgCPaZQzS4wwwuVgyODB0hjR+Eo+z5nzyR+6A/TTQwofdNgz7rYtSQ==
X-Received: by 2002:a17:906:d54f:b0:726:2c7c:c0f9 with SMTP id cr15-20020a170906d54f00b007262c7cc0f9mr3524187ejc.441.1657718947117;
        Wed, 13 Jul 2022 06:29:07 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id an12-20020a17090656cc00b0070b7875aa6asm4968942ejc.166.2022.07.13.06.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 06:29:06 -0700 (PDT)
Message-ID: <3ddcdb24-cab3-509d-d694-edd4ab85df0a@redhat.com>
Date:   Wed, 13 Jul 2022 15:29:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [Regression] ACPI: video: Change how we determine if brightness
 key-presses are handled
Content-Language: en-US
To:     Ben Greening <bgreening@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        rafael@kernel.org, linux-acpi@vger.kernel.org
References: <CALF=6jEe5G8+r1Wo0vvz4GjNQQhdkLT5p8uCHn6ZXhg4nsOWow@mail.gmail.com>
 <02190bee-2e1b-bea3-b716-a7c7f5aa2ff0@redhat.com>
 <CALF=6jG5gmqqXo5cSFFRWRM96K0rzx3WabNdwAmdZQH=unFG7g@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <CALF=6jG5gmqqXo5cSFFRWRM96K0rzx3WabNdwAmdZQH=unFG7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 7/13/22 15:08, Ben Greening wrote:
> Hi Hans, thanks for getting back to me.
> 
> evemu-record shows events for both "Video Bus" and "Dell WMI hotkeys":
> 
> Video Bus
> E: 0.000001 0001 00e0 0001 # EV_KEY / KEY_BRIGHTNESSDOWN   1
> E: 0.000001 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
> E: 0.000020 0001 00e0 0000 # EV_KEY / KEY_BRIGHTNESSDOWN   0
> E: 0.000020 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
> 
> Dell WMI hotkeys
> E: 0.000001 0004 0004 57349 # EV_MSC / MSC_SCAN             57349
> E: 0.000001 0001 00e0 0001 # EV_KEY / KEY_BRIGHTNESSDOWN   1
> E: 0.000001 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
> E: 0.000020 0001 00e0 0000 # EV_KEY / KEY_BRIGHTNESSDOWN   0
> E: 0.000020 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
> 
> Adding video.report_key_events=1 with acpi_backlight=video makes
> things work like you said it would.
> 
> 
> With acpi_backlight=video just has intel_backlight.
> 
> Without acpi_backlight=video:
>     intel_backlight:
>         max_brightness: 4882
>         backlight control works with echo
>         brightness keys make no change to brightness value
> 
>     dell_backlight:
>         max_brightness: 15
>         backlight control doesn't work immediately, but does on reboot
> to set brightness at POST.
>         brightness keys change brightness value, but you don't see the
> change until reboot.

Ok, so your system lacks ACPI video backlight control, yet still reports
brightness keypresses through the ACPI Video Bus. Interesting (weird)...

I think I believe I know how to fix the regression, 1 patch coming up.

For the need to pass acpi_backlight=video, what you are in essence
doing is setting acpi_backlight=native.

The auto-detect code goes to acpi_backlight=vendor because of the lacking
ACPI video backlight control and manually setting acpi_backlight != vendor
disables the dell_backlight. ATM the native (intel) backlight ingnoes
the acpi_backlight setting so it loads unconditionally. But in the near
future this will change and then you need to pass acpi_backlight=native
otherwise the intel backlight will not register because you requested
video.

So I plan to fix this part by adding a quirk to make native the default
on your machine. Can you do:

sudo dmidecode > dmidecode.txt

And email me the generated dmidecode.txt (this will contain serialnumbers
so you may want to send it off-list) ? Then I can also prepare a patch
to add a quirk to make native the default on your model.

Regards,

Hans










> 
> Thanks again,
> 
> Ben
> 
> On Wed, Jul 13, 2022 at 2:43 AM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Hi Ben,
>>
>> On 7/13/22 07:27, Ben Greening wrote:
>>> (resending because of HTML formatting)
>>> Hi, I'm on Arch Linux and upgraded from kernel 5.18.9.arch1-1 to
>>> 5.18.10.arch1-1. The brightness keys don't work as well as before.
>>> Gnome had 20 degrees of brightness, now it's 10, and Xfce went from 10
>>> to 5. Additionally, on Gnome the brightness keys are a little slow to
>>> respond and there's a bit of a stutter. Don't know why Xfce doesn't
>>> stutter, but halving the degrees of brightness for both makes me
>>> wonder if each press is being counted twice.
>>
>> Author of the troublesome patch here, sorry that this broke things
>> for you.
>>
>> So this sounds like you are getting duplicate key-events reported,
>> causing the brightness to take 2 steps on each key-press which is
>> likely also causing the perceived stutter.
>>
>> This suggests that acpi_video_handles_brightness_key_presses()
>> was returning true on your system and is now returning false.
>>
>> Lets confirm this theory, please run either evtest or evemu-record
>> as root and then record events from the "Video Bus" device and then
>> press the brightness up/down keys. Press CTRL+C to exit. After this
>> repeat selecting the "Dell WMI hotkeys" device as input device.
>>
>> I expect both tests/recordings to show brightness key events with
>> the troublesome kernel, showing that you are getting duplicate events.
>>
>> If this is the case then as a workaround you can add:
>>
>> video.report_key_events=1
>>
>> to the kernel commandline. This should silence the "Video Bus"
>> events. Also can you provide the output of:
>>
>> ls /sys/class/backlight
>>
>> please?
>>
>>
>>> Reverting commit 3a0cf7ab8d in acpi_video.c and rebuilding
>>> 5.18.10.arch1-1 fixed it.
>>
>>> The laptop is a Dell Inspiron n4010 and I use "acpi_backlight=video"
>>> to make the brightness keys work. Please let me know if there's any
>>> hardware info you need.
>>
>> Note needing to add a commandline argument like this to get things
>> to work is something which really should always be reported upstream,
>> so that we can either adjust our heuristics; or add a quirk for your
>> laptop-model so that things will just work when another user tries
>> Linux on the same model.
>>
>> So while at it lets look into fixing this properly to.
>>
>> When you do not pass anything on the kernel commandline, what
>> is then the output of:
>>
>> ls /sys/class/backlight
>>
>> And for each directory under there, please cd into the dir
>> and then (as root) do:
>>
>> cat max_brightness # this gives you the range of this backlight intf.
>> echo $some-value > brightness
>>
>> picking some-value in a range of 0-max_brightness, repeating the
>> echo with different values (e.g. half-range + max) and see if
>> the screens brightness changes. Please let me know which directories
>> under /sys/class/backlight result in working backlight control
>> and which ones do not.
>>
>> Also what is the output of "ls /sys/class/backlight" when
>> "acpi_backlight=video" is present on the kernel commandline ?
>>
>> Regards,
>>
>> Hans
>>
> 

