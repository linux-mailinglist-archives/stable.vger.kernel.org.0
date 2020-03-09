Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C62117E455
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 17:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgCIQLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 12:11:17 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34563 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgCIQLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 12:11:16 -0400
Received: by mail-qt1-f193.google.com with SMTP id 59so7407946qtb.1
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 09:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ew+9jb+HqObcwrpB1jo+N23u3azkJKqgAtqlD3vrYB8=;
        b=LYPWRY99d4H4yaijPuGOKyG2ZlW8bjaZs0R8HfR2Tm2HxCxhZbpXmO7sXj7SvlTyf8
         eP1cG6ye54QGKo9R24IRuZXcYork3hKwzFFEh9AYH10UYRu4zPwuQZY/hOjNxjDZ7At2
         RVU2YKvShTLi57tsYTkOFXzMOSSeGAoKjUW3g1qHFIhwZdmn0X33sAiZ6haOr0SbijHi
         bcj3rarTGlBkDotByj/7ZqTanCuBV6IRkv5wbojHt9y8od+GeCgT3cxY8EjoCbd01Lcl
         nJ7QU92Z5Q7yeq7UcfyxmTtJXr0buAMDdaKXt+5YRbjAW4ezyo3byp0W9uED0wRrdHIt
         qWlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ew+9jb+HqObcwrpB1jo+N23u3azkJKqgAtqlD3vrYB8=;
        b=RkDDvy9vtPzCnRrdIluctXNSVXs/4uAhgnDuBewN0JML25ku+SPbi5VZchmiWYu+4s
         7bFTNCbDTMqlb2/whraVDxWIawzQBRUwFgR1oU1J3XuEJ9MZ1vLo6eqsl5LggJWTXgDP
         lu7ZKRdMdtrPlS2FRDEitEqkRoqj8H6LSELCd6/QXLCysRnMnPSbw5LmYAG/lwCeK8O1
         QbNiCoyZzXr8FaxFepaRuF04d+dEg59Q8zI+8D9nbGU5WJ/dCj0PHRe4NQRCJMIGyPOV
         iX0EIXOjrgK2ekTpDjaFVqk8xQI7Va2WbKoXsTInvDkZgSpTTUUKAo7eAFi4TA8IdLbf
         IKxw==
X-Gm-Message-State: ANhLgQ3julAxQ3G6GRWzoYKBDm9MfJaN4dCmm86XtWNndCDjXv1guN3E
        gYpMfNQdthpAgedgLA5MPtKCa3hGDgM=
X-Google-Smtp-Source: ADFU+vuUGa0WUW110kKCdVUiGT+d0DJEeWs3zMYxxel4r284ptQ572AX3hJOEZLAftzXo3aH9lY/SA==
X-Received: by 2002:ac8:710a:: with SMTP id z10mr12112943qto.181.1583770273196;
        Mon, 09 Mar 2020 09:11:13 -0700 (PDT)
Received: from [192.168.1.10] (c-66-30-119-151.hsd1.ma.comcast.net. [66.30.119.151])
        by smtp.gmail.com with ESMTPSA id w21sm23983251qth.17.2020.03.09.09.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 09:11:12 -0700 (PDT)
Subject: Re: [PATCH 2/2] iommu/vt-d: dmar_parse_one_rmrr: replace WARN_TAINT
 with pr_warn + add_taint
To:     Hans de Goede <hdegoede@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     iommu@lists.linux-foundation.org, stable@vger.kernel.org
References: <20200309140138.3753-1-hdegoede@redhat.com>
 <20200309140138.3753-3-hdegoede@redhat.com>
 <34b13929-cbea-9906-0169-8f274bd40377@google.com>
 <ef22beeb-fd9c-ead9-496f-e7466edc94f9@redhat.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <096ec150-f7f4-1136-0627-92c7b1e49f0f@google.com>
Date:   Mon, 9 Mar 2020 12:11:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <ef22beeb-fd9c-ead9-496f-e7466edc94f9@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/20 12:01 PM, Hans de Goede wrote:
> Hi,
> 
> On 3/9/20 4:57 PM, Barret Rhoden wrote:
>> On 3/9/20 10:01 AM, Hans de Goede wrote:
>>> Quoting from the comment describing the WARN functions in
>>> include/asm-generic/bug.h:
>>>
>>>    * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
>>>    * significant kernel issues that need prompt attention if they should ever
>>>    * appear at runtime.
>>>    *
>>>    * Do not use these macros when checking for invalid external inputs
>>>
>>> The (buggy) firmware tables which the dmar code was calling WARN_TAINT
>>> for really are invalid external inputs. They are not under the kernel's
>>> control and the issues in them cannot be fixed by a kernel update.
>>
>> This patch sounds good to me.
> 
> Can we have your Acked-by then ?

Acked-by Barret Rhoden <brho@google.com>

>> Given the rules with WARN and external inputs, it sounds like *all* uses of WARN_TAINT with TAINT_FIRMWARE_WORKAROUND are bad: WARNs that are likely based on invalid external input.  Presumably we're working around FW bugs.
> 
> Right, as I mentioned in the cover letter I'm working on a follow-up
> series fixing the other cases.

Great!

Thanks,

Barret


  I wanted to get these 2 out there (and
> hopefully into 5.6-rc# soon) as they are causing aprox 1-2 new
> bug-reports to be filed every day for just Fedora.
> 
>> While we're on the subject, is WARN_TAINT() ever worth the backtrace + bug report?  Given the criteria is "prompt attention", it should be something like "nice to know about when debugging."
> 
> I have not looked at WARN_TAINT usages other then those with the
> TAINT_FIRMWARE_WORKAROUND flag; and as mentioned I do plan to fix
> those. Feel free to take a look at any other callers :)
> 
> Regards,
> 
> Hans
> 
> 
> 
>>> So logging a backtrace, which invites bug reports to be filed about this,
>>> is not helpful.
>>>
>>> Some distros, e.g. Fedora, have tools watching for the kernel backtraces
>>> logged by the WARN macros and offer the user an option to file a bug for
>>> this when these are encountered. The WARN_TAINT in dmar_parse_one_rmrr
>>> + another iommu WARN_TAINT, addressed in another patch, have lead to over
>>> a 100 bugs being filed this way.
>>>
>>> This commit replaces the WARN_TAINT("...") call, with a
>>> pr_warn(FW_BUG "...") + add_taint(TAINT_FIRMWARE_WORKAROUND, ...) call
>>> avoiding the backtrace and thus also avoiding bug-reports being filed
>>> about this against the kernel.
>>>
>>> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1808874
>>> Fixes: f5a68bb0752e ("iommu/vt-d: Mark firmware tainted if RMRR fails sanity check")
>>> Cc: Barret Rhoden <brho@google.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>> ---
>>>    drivers/iommu/intel-iommu.c | 6 ++++--
>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>>> index 6fa6de2b6ad5..3857a5cd1a75 100644
>>> --- a/drivers/iommu/intel-iommu.c
>>> +++ b/drivers/iommu/intel-iommu.c
>>> @@ -4460,14 +4460,16 @@ int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header, void *arg)
>>>        struct dmar_rmrr_unit *rmrru;
>>>        rmrr = (struct acpi_dmar_reserved_memory *)header;
>>> -    if (rmrr_sanity_check(rmrr))
>>> -        WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
>>> +    if (rmrr_sanity_check(rmrr)) {
>>> +        pr_warn(FW_BUG
>>>                   "Your BIOS is broken; bad RMRR [%#018Lx-%#018Lx]\n"
>>>                   "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
>>>                   rmrr->base_address, rmrr->end_address,
>>>                   dmi_get_system_info(DMI_BIOS_VENDOR),
>>>                   dmi_get_system_info(DMI_BIOS_VERSION),
>>>                   dmi_get_system_info(DMI_PRODUCT_VERSION));
>>> +        add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
>>> +    }
>>>        rmrru = kzalloc(sizeof(*rmrru), GFP_KERNEL);
>>>        if (!rmrru)
>>>
>>
> 

