Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EAE5755E9
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 21:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbiGNTiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 15:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiGNTiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 15:38:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0718E67583
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 12:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657827500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h2gwjfySPN5w9CEE1tS8fl1rO2civ/bV3ydiTYY1dv0=;
        b=N5p41/a18PxQUl2oywymUTi1n+dpsN/T6zH5x8cZFbUsyiXanawz6r76QI6E6gGHnJmHYn
        +dG98Uzk036zIlW4d1whkNJtCBgmuq9KZoHgjUE1P05RJ5OCzaJcHMGWuxW5iEB2DDGzSY
        tkkCic8oor109gG881WNVBJtTakq3hQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-XWJBKOFLORC8JNrbs_PaHA-1; Thu, 14 Jul 2022 15:38:18 -0400
X-MC-Unique: XWJBKOFLORC8JNrbs_PaHA-1
Received: by mail-ed1-f69.google.com with SMTP id o13-20020a056402438d00b0043aa846b2d2so2062316edc.8
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 12:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h2gwjfySPN5w9CEE1tS8fl1rO2civ/bV3ydiTYY1dv0=;
        b=yLD8h3UkBPPTSrIvvkGvh5YGI1Ho8X/iZl60FtVvexox/B1aUUmieKyX7yHsUJ77DU
         dnzHx0tUC5fyipUh9zUa3SpbGhhh76R42ihfj+mcrJR0zuIO0NlK+9yxW6yJ+87lSzoQ
         +FILNHt6cGyyXbO1oZ5FTnrYbMU108M9YsbnbE0PhLvB9fZFLrKQcjBTJTpxk8nGDH26
         f4UdODn4RkgklkuwLo8s1OrIcd2FgEXWSOeFP1pXVtNuOPKN25KZ4gKo6YGfZWKe/nHQ
         Tdc1SWCym9gIMIxuAj/d+Kfrttd1ZG/AnOW7A9kjZZa+HREzscf48qbfEBjAy7EZYoak
         z6nA==
X-Gm-Message-State: AJIora/iGlSkqNpCaQcFEukyHH1dL0ZfVQbcJ4MQJIyfk9PFGv7Ise8f
        J6yvOxW6O4HaRmkPEhk5qPj08X/UXBYtHbKoGR1s5vsSw+whNkX9Kb9pa0b6GPdV1qsOdphnQFI
        TJyWAcvKlGNurqnPb
X-Received: by 2002:a05:6402:cba:b0:43a:6b17:f6b5 with SMTP id cn26-20020a0564020cba00b0043a6b17f6b5mr14553390edb.330.1657827497664;
        Thu, 14 Jul 2022 12:38:17 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t4xuOIXNbl2CNGIAEfrjxV7mv997tcOYLHcI0NV/Q8nRqHgyvSdTrNt6iYAQ263foi/jKBRA==
X-Received: by 2002:a05:6402:cba:b0:43a:6b17:f6b5 with SMTP id cn26-20020a0564020cba00b0043a6b17f6b5mr14553372edb.330.1657827497479;
        Thu, 14 Jul 2022 12:38:17 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id f4-20020a17090631c400b0072ee9790894sm378628ejf.197.2022.07.14.12.38.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 12:38:16 -0700 (PDT)
Message-ID: <3b317137-6550-61f4-8386-4aa787c453af@redhat.com>
Date:   Thu, 14 Jul 2022 21:38:16 +0200
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
 <3ddcdb24-cab3-509d-d694-edd4ab85df0a@redhat.com>
 <eb760bcd-8817-65ed-471e-60e8d9bdae79@redhat.com>
 <CALF=6jF1TTgc4_mXRcx=6EV64Cj=VWLU3zXi7AoyM1F3bdgT=A@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <CALF=6jF1TTgc4_mXRcx=6EV64Cj=VWLU3zXi7AoyM1F3bdgT=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 7/14/22 01:56, Ben Greening wrote:
> Hi Hans,
> 
> Applying the latest
> 0001-ACPI-video-Change-how-we-determine-if-brightness-key.patch you
> sent me off-list (my fault, forgot to reply all) and
> 0001-ACPI-video-Use-native-backlight-on-Dell-Inspiron-N40.patch makes
> it all work again. And a bonus that I don't need any extra kernel
> parameters anymore.
> 
>> It would also be interesting if you can start evemu-record on the
>> Dell WMI Hotkeys device before pressing any of the brightness keys.
>>
>> There might still be a single duplicate event reported there on
>> the first press. I don't really see a way around that (without causing
>> all brightness key presses on some panasonic models to be duplicated),
>> but I'm curious if it is a problem at all...
> 
> I rebooted and ran evemu-record before pressing the brightness keys
> and "Dell WMI hotkeys" didn't show any events at all.

Great thank you for reporting and testing this!

I will send the fix on its way to Linus tomorrow and I've just
submitted the new acpi_backlight=native quirk upstream too.

Regards,

Hans


> On Wed, Jul 13, 2022 at 6:49 AM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Hi Ben,
>>
>> On 7/13/22 15:29, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 7/13/22 15:08, Ben Greening wrote:
>>>> Hi Hans, thanks for getting back to me.
>>>>
>>>> evemu-record shows events for both "Video Bus" and "Dell WMI hotkeys":
>>>>
>>>> Video Bus
>>>> E: 0.000001 0001 00e0 0001 # EV_KEY / KEY_BRIGHTNESSDOWN   1
>>>> E: 0.000001 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
>>>> E: 0.000020 0001 00e0 0000 # EV_KEY / KEY_BRIGHTNESSDOWN   0
>>>> E: 0.000020 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
>>>>
>>>> Dell WMI hotkeys
>>>> E: 0.000001 0004 0004 57349 # EV_MSC / MSC_SCAN             57349
>>>> E: 0.000001 0001 00e0 0001 # EV_KEY / KEY_BRIGHTNESSDOWN   1
>>>> E: 0.000001 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
>>>> E: 0.000020 0001 00e0 0000 # EV_KEY / KEY_BRIGHTNESSDOWN   0
>>>> E: 0.000020 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
>>>>
>>>> Adding video.report_key_events=1 with acpi_backlight=video makes
>>>> things work like you said it would.
>>>>
>>>>
>>>> With acpi_backlight=video just has intel_backlight.
>>>>
>>>> Without acpi_backlight=video:
>>>>     intel_backlight:
>>>>         max_brightness: 4882
>>>>         backlight control works with echo
>>>>         brightness keys make no change to brightness value
>>>>
>>>>     dell_backlight:
>>>>         max_brightness: 15
>>>>         backlight control doesn't work immediately, but does on reboot
>>>> to set brightness at POST.
>>>>         brightness keys change brightness value, but you don't see the
>>>> change until reboot.
>>>
>>> Ok, so your system lacks ACPI video backlight control, yet still reports
>>> brightness keypresses through the ACPI Video Bus. Interesting (weird)...
>>>
>>> I think I believe I know how to fix the regression, 1 patch coming up.
>>
>> Can you please give the attached patch a try, with
>> video.report_key_events=1 *removed* from the commandline ?
>>
>> It would also be interesting if you can start evemu-record on the
>> Dell WMI Hotkeys device before pressing any of the brightness keys.
>>
>> There might still be a single duplicate event reported there on
>> the first press. I don't really see a way around that (without causing
>> all brightness key presses on some panasonic models to be duplicated),
>> but I'm curious if it is a problem at all...
>>
>> Regards,
>>
>> Hans
>>
>>
>>
>>
>>
> 

