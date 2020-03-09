Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB617E432
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 17:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgCIQB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 12:01:58 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36333 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726758AbgCIQB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 12:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583769716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=94IZgGavdfaUL8Zkv4zTnhDZlaIIttEknSSNkC7OOwE=;
        b=WDJKwM7aApOQHzDqFzc3TYZCcuZ5zRuKcrZ/C70XOW9EWME0ugnBBsfsLzO9ASb5KlrXjm
        QblMlX9z9puBk9GulAbQcIy772RjwVo/W/eXUOzItobeLS063dFV+v9+PxGwqGb1AZSWM0
        v/GkWShnivZ8prYmAfyMZtt1hdvxFJ8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-hjAbySB8NoupquCRH9G0Lg-1; Mon, 09 Mar 2020 12:01:43 -0400
X-MC-Unique: hjAbySB8NoupquCRH9G0Lg-1
Received: by mail-wm1-f71.google.com with SMTP id y7so15546wmd.4
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 09:01:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=94IZgGavdfaUL8Zkv4zTnhDZlaIIttEknSSNkC7OOwE=;
        b=PfEtY7JOa8tMvxaYXSJpnT8pBf+u1hFUoeLNxENmBrduNL+hPl5yjenHWnhWxrMH39
         0xXYA/GfuUSSDr5giGQBqIzqJtYpwXGZg9snubAR+Lvd0ClF7WBeRmEJ7rua6KQU6O4v
         2bWXPwizV0UJB82BXTjnDG9wI0yUmASMPzzTLXtBl6uy7nIsS3o9xmqFb7SXpEHkANRJ
         y46P8hme7z6kukKyMig12BXHOPH7IUx7yaJdz6CzVZXcX6JBF55AfkqARa4Z08ycP/5h
         QNwvX7iyGg0viT3JYhIVfAFY6yi7MesngnvXVZ+Jfd2pn5/DaYgMxyUfbQCguoZHFp7/
         0flg==
X-Gm-Message-State: ANhLgQ0+if5yps75piHy+4MOb4cmYvc+lmFvbnp7jXjQfIJShC7KO9NC
        G7KXKJbPy/CEQa7shrRUqssjgza/AZsXNq/45AxcXtPCI/y3iBh++yCfQD1WgRsJ/xPNhIC3ZMQ
        H600MQ/I/PeuUznSt
X-Received: by 2002:adf:b652:: with SMTP id i18mr1477060wre.310.1583769701282;
        Mon, 09 Mar 2020 09:01:41 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuKSFM5gbK+49BRXb/KYPAnsy9nuu76KdYdpNjpCYH+8wnp6knbVxnwQasfwj2NJ/cw/re+mQ==
X-Received: by 2002:adf:b652:: with SMTP id i18mr1477043wre.310.1583769701040;
        Mon, 09 Mar 2020 09:01:41 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-fc7e-fd47-85c1-1ab3.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:fc7e:fd47:85c1:1ab3])
        by smtp.gmail.com with ESMTPSA id e1sm50248164wrx.90.2020.03.09.09.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 09:01:40 -0700 (PDT)
Subject: Re: [PATCH 2/2] iommu/vt-d: dmar_parse_one_rmrr: replace WARN_TAINT
 with pr_warn + add_taint
To:     Barret Rhoden <brho@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     iommu@lists.linux-foundation.org, stable@vger.kernel.org
References: <20200309140138.3753-1-hdegoede@redhat.com>
 <20200309140138.3753-3-hdegoede@redhat.com>
 <34b13929-cbea-9906-0169-8f274bd40377@google.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <ef22beeb-fd9c-ead9-496f-e7466edc94f9@redhat.com>
Date:   Mon, 9 Mar 2020 17:01:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <34b13929-cbea-9906-0169-8f274bd40377@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/9/20 4:57 PM, Barret Rhoden wrote:
> On 3/9/20 10:01 AM, Hans de Goede wrote:
>> Quoting from the comment describing the WARN functions in
>> include/asm-generic/bug.h:
>>
>>   * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
>>   * significant kernel issues that need prompt attention if they should ever
>>   * appear at runtime.
>>   *
>>   * Do not use these macros when checking for invalid external inputs
>>
>> The (buggy) firmware tables which the dmar code was calling WARN_TAINT
>> for really are invalid external inputs. They are not under the kernel's
>> control and the issues in them cannot be fixed by a kernel update.
> 
> This patch sounds good to me.

Can we have your Acked-by then ?

> Given the rules with WARN and external inputs, it sounds like *all* uses of WARN_TAINT with TAINT_FIRMWARE_WORKAROUND are bad: WARNs that are likely based on invalid external input.  Presumably we're working around FW bugs.

Right, as I mentioned in the cover letter I'm working on a follow-up
series fixing the other cases. I wanted to get these 2 out there (and
hopefully into 5.6-rc# soon) as they are causing aprox 1-2 new
bug-reports to be filed every day for just Fedora.

> While we're on the subject, is WARN_TAINT() ever worth the backtrace + bug report?  Given the criteria is "prompt attention", it should be something like "nice to know about when debugging."

I have not looked at WARN_TAINT usages other then those with the
TAINT_FIRMWARE_WORKAROUND flag; and as mentioned I do plan to fix
those. Feel free to take a look at any other callers :)

Regards,

Hans



>> So logging a backtrace, which invites bug reports to be filed about this,
>> is not helpful.
>>
>> Some distros, e.g. Fedora, have tools watching for the kernel backtraces
>> logged by the WARN macros and offer the user an option to file a bug for
>> this when these are encountered. The WARN_TAINT in dmar_parse_one_rmrr
>> + another iommu WARN_TAINT, addressed in another patch, have lead to over
>> a 100 bugs being filed this way.
>>
>> This commit replaces the WARN_TAINT("...") call, with a
>> pr_warn(FW_BUG "...") + add_taint(TAINT_FIRMWARE_WORKAROUND, ...) call
>> avoiding the backtrace and thus also avoiding bug-reports being filed
>> about this against the kernel.
>>
>> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1808874
>> Fixes: f5a68bb0752e ("iommu/vt-d: Mark firmware tainted if RMRR fails sanity check")
>> Cc: Barret Rhoden <brho@google.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/iommu/intel-iommu.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index 6fa6de2b6ad5..3857a5cd1a75 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -4460,14 +4460,16 @@ int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header, void *arg)
>>       struct dmar_rmrr_unit *rmrru;
>>       rmrr = (struct acpi_dmar_reserved_memory *)header;
>> -    if (rmrr_sanity_check(rmrr))
>> -        WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
>> +    if (rmrr_sanity_check(rmrr)) {
>> +        pr_warn(FW_BUG
>>                  "Your BIOS is broken; bad RMRR [%#018Lx-%#018Lx]\n"
>>                  "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
>>                  rmrr->base_address, rmrr->end_address,
>>                  dmi_get_system_info(DMI_BIOS_VENDOR),
>>                  dmi_get_system_info(DMI_BIOS_VERSION),
>>                  dmi_get_system_info(DMI_PRODUCT_VERSION));
>> +        add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
>> +    }
>>       rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
>>       if (!rmrru)
>>
> 

