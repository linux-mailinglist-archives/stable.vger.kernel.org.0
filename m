Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F5C9CDF0
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 13:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730670AbfHZLTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 07:19:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbfHZLTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 07:19:50 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DA78B796E4
        for <stable@vger.kernel.org>; Mon, 26 Aug 2019 11:19:49 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id r25so9401159edp.20
        for <stable@vger.kernel.org>; Mon, 26 Aug 2019 04:19:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4qUpb3wCTHM1fU96ef9SzrMItNaS4Q9j1q67CV3ibIA=;
        b=fFyQ/o5FqVRYVSf3nmlKSJ43vy0HE4q+8GEg4tt4ffiNfcVVDh+Mub4or4lDE8UAF8
         +XXvKsGcTK8UlmavJI8bZOyKo/7YzdT/MBJBmakaxungoSSe225vBrz0X60LIPazJdwm
         Xbbr6WIRSqbh6hGlkI2CrR7ErTtouEafFqx8z2dSL8WuIOR5G3y6KCh2Ue2o1QwRh7IS
         TZwa6vgBVejvZ6zak7UcfhDHHAc/HlCkDNc3bz1AzUOPVnYGk1uF64AptCeUaobSXf8d
         S5PdGNwNf3QjyLUuz6lr5Z/qn9PDIPNEaw/4ylMEYXVl8lC089XeE8/ffchF8kheqsaK
         EOKQ==
X-Gm-Message-State: APjAAAVNY8pBZBOAaGTMct8xh2+Pk69kgqjdAQZBo3mnNzh28qYH2had
        PzYpsd4QH1KyI0EoTKcQ8vsFizGrTb2L1VNOc1AiBG9fqIr0E6t+Mg6vqr87FLqqcq75BiervHT
        E57u8mSOIozJZUMeg
X-Received: by 2002:aa7:db12:: with SMTP id t18mr17977145eds.266.1566818387960;
        Mon, 26 Aug 2019 04:19:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxCnmDjJvCgvjFutK+znlJJJ7Z0I6CqQEM58WMaQufI5WwMO9+UW2qewF1kOS1EpCoRFSvzHA==
X-Received: by 2002:aa7:db12:: with SMTP id t18mr17977124eds.266.1566818387703;
        Mon, 26 Aug 2019 04:19:47 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id p5sm1258651edr.72.2019.08.26.04.19.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Aug 2019 04:19:47 -0700 (PDT)
Subject: Re: [PATCH] HID: logitech-dj: Fix crash when initial
 logi_dj_recv_query_paired_devices fails
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
References: <20190825153542.79245-1-hdegoede@redhat.com>
 <CAO-hwJ+AiViJg34dNKz05HfvnPVqigD7ZLyJpfsviBH8Rs0L2g@mail.gmail.com>
 <d5ff19d7-4a0c-6c38-2d97-fcc33a8cdedb@redhat.com>
 <CAO-hwJ+O34__f2CFH7-kBQc_95ur1A_yyBe7PXDmGAsQA8ZR7w@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <6f29a4b3-4aac-fc42-7b6c-9e0f8e019d9c@redhat.com>
Date:   Mon, 26 Aug 2019 13:19:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAO-hwJ+O34__f2CFH7-kBQc_95ur1A_yyBe7PXDmGAsQA8ZR7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 26-08-19 11:41, Benjamin Tissoires wrote:
> On Mon, Aug 26, 2019 at 11:04 AM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Hi,
>>
>> On 26-08-19 09:46, Benjamin Tissoires wrote:
>>> Hi Hans,
>>>
>>> On Sun, Aug 25, 2019 at 5:35 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>>>
>>>> Before this commit dj_probe would exit with an error if the initial
>>>> logi_dj_recv_query_paired_devices fails. The initial call may fail
>>>> when the receiver is connected through a kvm and the focus is away.
>>>>
>>>> When the call fails this causes 2 problems:
>>>>
>>>> 1) dj_probe calls logi_dj_recv_query_paired_devices after calling
>>>> hid_device_io_start() so a HID report may have been received in between
>>>> and our delayedwork_callback may be running. It seems that the initial
>>>> logi_dj_recv_query_paired_devices failure happening with some KVMs triggers
>>>> this exact scenario, causing the work-queue to run on free-ed memory,
>>>> leading to:
>>>>
>>>>    BUG: unable to handle page fault for address: 0000000000001e88
>>>>    #PF: supervisor read access in kernel mode
>>>>    #PF: error_code(0x0000) - not-present page
>>>>    PGD 0 P4D 0
>>>>    Oops: 0000 [#1] SMP PTI
>>>>    CPU: 3 PID: 257 Comm: kworker/3:3 Tainted: G           OE     5.3.0-rc5+ #100
>>>>    Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./B150M Pro4S/D3, BIOS P7.10 12/06/2016
>>>>    Workqueue: events 0xffffffffc02ba200
>>>>    RIP: 0010:0xffffffffc02ba1bd
>>>>    Code: e8 e8 13 00 d8 48 89 c5 48 85 c0 74 4c 48 8b 7b 10 48 89 ea b9 07 00 00 00 41 b9 09 00 00 00 41 b8 01 00 00 00 be 10 00 00 00 <48> 8b 87 88 1e 00 00 48 8b 40 40 e8 b3 6b b4 d8 48 89 ef 41 89 c4
>>>>    RSP: 0018:ffffb760c046bdb8 EFLAGS: 00010286
>>>>    RAX: ffff935038ea4550 RBX: ffff935046778000 RCX: 0000000000000007
>>>>    RDX: ffff935038ea4550 RSI: 0000000000000010 RDI: 0000000000000000
>>>>    RBP: ffff935038ea4550 R08: 0000000000000001 R09: 0000000000000009
>>>>    R10: 000000000000e011 R11: 0000000000000001 R12: ffff9350467780e8
>>>>    R13: ffff935046778000 R14: 0000000000000000 R15: ffff935046778070
>>>>    FS:  0000000000000000(0000) GS:ffff935054e00000(0000) knlGS:0000000000000000
>>>>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>    CR2: 0000000000001e88 CR3: 000000075a612002 CR4: 00000000003606e0
>>>>    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>>    Call Trace:
>>>>     0xffffffffc02ba2f7
>>>>     ? process_one_work+0x1b1/0x560
>>>>     process_one_work+0x234/0x560
>>>>     worker_thread+0x50/0x3b0
>>>>     kthread+0x10a/0x140
>>>>     ? process_one_work+0x560/0x560
>>>>     ? kthread_park+0x80/0x80
>>>>     ret_from_fork+0x3a/0x50
>>>>    Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) bnep vfat fat btusb btrtl btbcm btintel bluetooth intel_rapl_msr ecdh_generic rfkill ecc snd_usb_audio snd_usbmidi_lib intel_rapl_common snd_rawmidi mc x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt iTCO_vendor_support mei_wdt mei_hdcp ppdev kvm_intel kvm irqbypass crct10dif_pclmul crc32_generic crc32_pclmul snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio ghash_clmulni_intel intel_cstate snd_hda_intel snd_hda_codec intel_uncore snd_hda_core snd_hwdep intel_rapl_perf snd_seq snd_seq_device snd_pcm snd_timer intel_wmi_thunderbolt snd e1000e soundcore mxm_wmi i2c_i801 bfq mei_me mei intel_pch_thermal parport_pc parport acpi_pad binfmt_misc hid_lg_g15(E) hid_logitech_dj(E) i915 crc32c_intel i2c_algo_bit drm_kms_helper nvme nvme_core drm wmi video uas usb_storage i2c_dev
>>>>    CR2: 0000000000001e88
>>>>    ---[ end trace 1d3f8afdcfcbd842 ]---
>>>>
>>>> 2) Even if we were to fix 1. by making sure the work is stopped before
>>>> failing probe, failing probe is the wrong thing to do, we have
>>>> logi_dj_recv_queue_unknown_work to deal with the initial
>>>> logi_dj_recv_query_paired_devices failure.
>>>>
>>>> Rather then error-ing out of the probe, causing the receiver to not work at
>>>> all we should rely on this, so that the attached devices will get properly
>>>> enumerated once the KVM focus is switched back.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 74808f9115ce ("HID: logitech-dj: add support for non unifying receivers")
>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>> ---
>>>
>>> Patch looks good to me, but doesn't logi_dj_recv_switch_to_dj_mode()
>>> has the same potential issue?
>>
>> logi_dj_recv_query_paired_devices() solicits data being send from the
>> device, so we do: hid_device_io_start(hdev); just before calling it.
> 
> Right, so the patch is just about fixing the workqueue item (and a
> little bit of the device too)
> 
> [/me tries to understand the KVM implications]
> 
>>
>> logi_dj_recv_switch_to_dj_mode() is done before the hid_device_io_start()
>> so it cannot cause the work to get queued.
>>
>> Also logi_dj_recv_switch_to_dj_mode() failing is something we cannot
>> recover from.
> 
> There is one thing I do not get.
> When the KVM hadn't the focus on the device, how can it not forward
> reports when you can actually call logi_dj_recv_switch_to_dj_mode()?
> Does it present the device to all the hosts connected to it and just
> filter the input reports to the "focused" one, or is it something
> different?

I honestly do not know, I have tested with this exact same kvm before and
then the logi_dj_recv_query_paired_devices() call worked, but the
input-reports send in response to it where forwarded to the wrong machine.

And later when focus got restored the unknown handler would redo
logi_dj_recv_query_paired_devices() and all was well.

For some reason, yesterday when I hit this bug and it crashes my workstation
as well as another machine attached to the KVM also running 5.3-rc5, I am now
getting -32 (EPIPE / USB endpoint stalled) errors from the
logi_dj_recv_switch_to_dj_mode() call. I think it may have something TODO
with which of the 2 USB ports on the KVM for mouse and kbd the dongle is in,
but I have not confirmed this yet.

Also I did do a firmware update of the KVM a while ago, I would like to think
that that was done before my previous round of testing. But I'm not sure.

TL;DR: The logi_dj_recv_query_paired_devices() call failing with EPIPE
when the focus is switched away is new and I do not know why this is
happening, but it does crash my machine(s) without the fix.

logi_dj_recv_switch_to_dj_mode() OTOH seems to not care where the focus is...

> And in the case logi_dj_recv_switch_to_dj_mode() failed, on a kvm it
> should not have much implications, because as long as one host
> converts the receiver to the DJ mode and the receiver keeps being
> powered on, it won't change back to the non DJ mode...

True.

> Anyway, I have queued the patch locally for testing, and will push it soon.

Thanks.

Regards,

Hans



>>>>    drivers/hid/hid-logitech-dj.c | 10 +++++-----
>>>>    1 file changed, 5 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
>>>> index cc47f948c1d0..7badbaa18878 100644
>>>> --- a/drivers/hid/hid-logitech-dj.c
>>>> +++ b/drivers/hid/hid-logitech-dj.c
>>>> @@ -1734,14 +1734,14 @@ static int logi_dj_probe(struct hid_device *hdev,
>>>>                   if (retval < 0) {
>>>>                           hid_err(hdev, "%s: logi_dj_recv_query_paired_devices error:%d\n",
>>>>                                   __func__, retval);
>>>> -                       goto logi_dj_recv_query_paired_devices_failed;
>>>> +                       /*
>>>> +                        * This can happen with a KVM, let the probe succeed,
>>>> +                        * logi_dj_recv_queue_unknown_work will retry later.
>>>> +                        */
>>>>                   }
>>>>           }
>>>>
>>>> -       return retval;
>>>> -
>>>> -logi_dj_recv_query_paired_devices_failed:
>>>> -       hid_hw_close(hdev);
>>>> +       return 0;
>>>>
>>>>    llopen_failed:
>>>>    switch_to_dj_mode_fail:
>>>> --
>>>> 2.23.0
>>>>
