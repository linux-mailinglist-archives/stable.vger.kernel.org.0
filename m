Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE53E14B871
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732351AbgA1OXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:23:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46890 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727818AbgA1OXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 09:23:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580221414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PoorEe3BgUIDWbZrCh3DXrBZXbNmAisrYa8c3ofYrmk=;
        b=jMkIfWiQAbnV+J4YyQxn09/sPidarpAjSJHoE6nCnldXRRD4zXMMwr/Xck9Jlwn7FLyhFY
        /n2grw5vXnL39f8MKBfVrZQfE11FtxhC0mkcBfOKYvGRhYkM3DjUb3eFxHWUbJGc54VA3t
        95n4vk/nd5WuuUAC/eRo0QebB0UFMZQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-as6eW6fEPNO5URtQqxD0zg-1; Tue, 28 Jan 2020 09:23:32 -0500
X-MC-Unique: as6eW6fEPNO5URtQqxD0zg-1
Received: by mail-wr1-f71.google.com with SMTP id k18so8099902wrw.9
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 06:23:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PoorEe3BgUIDWbZrCh3DXrBZXbNmAisrYa8c3ofYrmk=;
        b=prDTAHwLlBZCjOFnUw4Yhd00XUVZJ42Eq+Wi0bHa9ErLC00aYAqOpicqshGiLYhmYG
         tNFKHD3ehPgDh863srS7R1visuvM0bIAWcdbRwjNCn+2TYJIf6hs5cW7rRMNQZoIUBab
         +rM+aN/zMmwlDy6ousJ7ROyWZqOkE6dyizpyzPglNjdHbUJc69uF1M1NzIIAeeHPGBET
         TplwV3IJytIauEMB4bYQa/2qzOumEfN0kxgo3OAKMjdQ2diks1B63XSp+Ay+hRTXvYFl
         rnlkxa0G2jKpNtney5gw1D530MckFSPdDUUXLRyzkRh67G6u8swHroHtTroQ7zi4JOyv
         TGOg==
X-Gm-Message-State: APjAAAXEErT9H8xfWLqwcGj1WqkJglw1SODIq6zZKvnEDcACHj8zoALq
        noU4IZ6cVopYnb71wjT1Lpp1IzDNvoKCwtPSRQD2Bq7XuiGw1Q5H7U2fTS+5XZ4bTvPlyvI36/g
        k7G9oB/7FD60iKiXA
X-Received: by 2002:a5d:4983:: with SMTP id r3mr27273090wrq.134.1580221411441;
        Tue, 28 Jan 2020 06:23:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqxYw2chTdDz/2/YZKa8hws0FseLlswooyyiI+PyGP3EMBgoFWXFLA6gKBHI6Dwbt8wiSXVkSA==
X-Received: by 2002:a5d:4983:: with SMTP id r3mr27273066wrq.134.1580221411179;
        Tue, 28 Jan 2020 06:23:31 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id s65sm3348672wmf.48.2020.01.28.06.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 06:23:30 -0800 (PST)
From:   Hans de Goede <hdegoede@redhat.com>
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
To:     vipul kumar <vipulk0511@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
 <87eevs7lfd.fsf@nanos.tec.linutronix.de>
 <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com>
 <878slzeeim.fsf@nanos.tec.linutronix.de>
 <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
 <20200123144108.GU32742@smile.fi.intel.com>
 <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
 <87iml11ccf.fsf@nanos.tec.linutronix.de>
 <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
 <87ftg5131x.fsf@nanos.tec.linutronix.de>
 <37321319-e110-81f5-2488-cedf000da04d@redhat.com>
 <CADdC98To8VKOUWnR+8zAJ04vgdc4vJoh2h96588+5XFer9YTJw@mail.gmail.com>
Message-ID: <329a2f7d-c5ed-6376-ec78-f00fa1ba41cd@redhat.com>
Date:   Tue, 28 Jan 2020 15:23:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CADdC98To8VKOUWnR+8zAJ04vgdc4vJoh2h96588+5XFer9YTJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 28-01-2020 12:47, vipul kumar wrote:
> Hi Thomas,
> 
> Please find attached logs with mainline kernel version 5.4.15 with patch.

So the suggested change seems to not work, that is strange.

Can you double check you are running the correct kernel and
add the following change and gather debug output ? :

--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -102,6 +103,8 @@ unsigned long cpu_khz_from_msr(void)
         /* Get FSB FREQ ID */

+ pr_err("tsc msr id match %ld lo 0x%02x\n", id - tsc_msr_cpu_ids, lo);
+
         /* Map CPU reference clock freq ID(0-7) to CPU reference clock freq(KHz) */
         freq = freq_desc->freqs[lo & 0x7];

Regards,

Hans



> On Fri, Jan 24, 2020 at 9:24 PM Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com>> wrote:
> 
>     Hi,
> 
>     On 1/24/20 12:55 PM, Thomas Gleixner wrote:
>      > Hans,
>      >
>      > Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com>> writes:
>      >> On 1/24/20 9:35 AM, Thomas Gleixner wrote:
>      >>> Where does that number come from? Just math?
>      >>
>      >> Yes just math, but perhaps the Intel folks can see if they can find some
>      >> datasheet to back this up ?
>      >
>      > Can you observe the issue on one of the machines in your zoo as well?
> 
>     I haven't tried yet. Looking at the thread sofar the problem was noticed on
>     a system with a Celeron N2930, I don't have access to one of those, I
>     do have access to a system with a closely related N2840 I will give that
>     a try as well as see if I can reproduce this on one of the tablet
>     oriented Z3735x SoCs.
> 
>     I'll report back when I have had a chance to test this.
> 
>     Regards,
> 
>     Hans
> 

