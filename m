Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CA33BBC56
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 13:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhGELnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:43:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230377AbhGELnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 07:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625485243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DBpQU/+1ZccDkRSdA2KQhnxi9plUS5A5WzFT+nIfNjM=;
        b=QUNOh9TBAS5uaXS2Kt0sJ/ypa6i3+Fz9NgRNwhh/zF2fyWjeWDVHNQb+garQWVahlTPbTG
        YLJZIOiNYhVB6uZztWp4leqiCdyX2Lzwc0rWzswM2spnL5PUKbFYHZJb1LKBvr/2aKHWEd
        B8oG4gj9bZUolJ5v6TaZ2VgVs1uysHA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-Saiz1mEyOwGavcJ5VqLHFg-1; Mon, 05 Jul 2021 07:40:42 -0400
X-MC-Unique: Saiz1mEyOwGavcJ5VqLHFg-1
Received: by mail-wm1-f69.google.com with SMTP id 9-20020a05600c2289b02901f519cc69a8so2383548wmf.9
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 04:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DBpQU/+1ZccDkRSdA2KQhnxi9plUS5A5WzFT+nIfNjM=;
        b=t+kPCm5pcCYMHY5fUZQAOw+MXLzHlhhLWVGJa8rPVZH/ZdjE65ixEzw5q7bouAIYY0
         t5rbmwrjmFRq3DFT8J/mNrx5Bc77i0o1xAtsbLnCELN+50RC/Ee3i6DYGLZvmdG+qqWx
         IZ0kT7qZSSYvxa8GFkE/4GvCbelVRnCtufzZuuiKoGe3d5xagpmpq+nTUGNX41wuGxG/
         jPbsH1+e9drJXiUbtD7KjasEprq+01eCofknX1Zkxv235CCoWEn4oSvEtHuhhTPHm65I
         WqePZTh5gEQnJcbmoHK5C2fk+DggtUTjDsv76r3sjxLqIhHKjvHCVw4+fanaI7Qsi4Q5
         y1SA==
X-Gm-Message-State: AOAM533Blfd7ogk0vizaUPx4qZQ7LcgsiyoI3bUPxxb5DkqQOPMu2QAE
        xi68+SjSYD6E/xLeGtSQPYQSa/m+aXMwYyuUyDiCpjeG4Lkx8pSxuYiHYjXekOA030X2UkWOgL9
        168cUWn6PilOK1Vmm
X-Received: by 2002:a05:6000:18a7:: with SMTP id b7mr15350099wri.348.1625485241226;
        Mon, 05 Jul 2021 04:40:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2CvXg0E0fmyYhbqBQgk6W79cCImuV5yKc0ObL1OA2OczSWPlxb9lSzW22aIjKIyzGFDvvsw==
X-Received: by 2002:a05:6000:18a7:: with SMTP id b7mr15350093wri.348.1625485241096;
        Mon, 05 Jul 2021 04:40:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id j17sm15851064wmi.41.2021.07.05.04.40.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jul 2021 04:40:40 -0700 (PDT)
Subject: Re: [PATCH 5.4] KVM: SVM: Call SEV Guest Decommission if ASID binding
 fails
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alper Gun <alpergun@google.com>
Cc:     stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>
References: <20210628211054.61528-1-alpergun@google.com>
 <YOKxf/8AT5LA5wfu@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d857d3b7-edef-d9ea-98ac-70c4c5783c88@redhat.com>
Date:   Mon, 5 Jul 2021 13:40:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOKxf/8AT5LA5wfu@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/07/21 09:15, Greg KH wrote:
> On Mon, Jun 28, 2021 at 09:10:54PM +0000, Alper Gun wrote:
>> commit 934002cd660b035b926438244b4294e647507e13 upstream.
>>
>> Send SEV_CMD_DECOMMISSION command to PSP firmware if ASID binding
>> fails. If a failure happens after  a successful LAUNCH_START command,
>> a decommission command should be executed. Otherwise, guest context
>> will be unfreed inside the AMD SP. After the firmware will not have
>> memory to allocate more SEV guest context, LAUNCH_START command will
>> begin to fail with SEV_RET_RESOURCE_LIMIT error.
>>
>> The existing code calls decommission inside sev_unbind_asid, but it is
>> not called if a failure happens before guest activation succeeds. If
>> sev_bind_asid fails, decommission is never called. PSP firmware has a
>> limit for the number of guests. If sev_asid_binding fails many times,
>> PSP firmware will not have resources to create another guest context.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 59414c989220 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_START command")
>> Reported-by: Peter Gonda <pgonda@google.com>
>> Signed-off-by: Alper Gun <alpergun@google.com>
>> Reviewed-by: Marc Orr <marcorr@google.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> Message-Id: <20210610174604.2554090-1-alpergun@google.com>
> 
> Message-id?  Odd...

Not that much, see "git log -- drivers | grep Message-Id".  A link to 
lore.kernel.org is getting more popular these days, but Message-Id is 
what "git am" knows about.

>> ---
>>   arch/x86/kvm/svm.c | 32 +++++++++++++++++++++-----------
>>   1 file changed, 21 insertions(+), 11 deletions(-)
> 
> <snip>
> 
> Can you also provide working backports for the newer kernel trees as
> well?  We would need this in 5.10 and 5.12, right?

Already queued:

https://lore.kernel.org/stable/20210628141828.31757-102-sashal@kernel.org/ 
for 5.12
https://lore.kernel.org/stable/20210628142607.32218-94-sashal@kernel.org/ 
for 5.10

For this one:

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

