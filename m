Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 311BC11CD5A
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 13:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfLLMir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 07:38:47 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47272 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729297AbfLLMir (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 07:38:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576154326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HjG13pQnC6z3lipnj2OvOm4bGvR+32WxaKc1DUtleSc=;
        b=aQYjrP2f/0CbK2ALCt/AIme6BH+oc1ovnr7ayxpQJrJCpWlAU6vfVoEOJ/ZiSd7tdn42fv
        FiETwfM73qa0r4aSBMNBYQqWizKGZQkRgd/N6OtLxVtLMvmj628AZUOneSSNfDcWi3l9OA
        lI8Ez6RcVaKAHSMli3ECzmxd7JDD+7A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-WEoI_wCfMo-rVVBd4LV4fw-1; Thu, 12 Dec 2019 07:38:42 -0500
X-MC-Unique: WEoI_wCfMo-rVVBd4LV4fw-1
Received: by mail-wr1-f70.google.com with SMTP id u18so972084wrn.11
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 04:38:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HjG13pQnC6z3lipnj2OvOm4bGvR+32WxaKc1DUtleSc=;
        b=MbJdE/DiYH3PI1LbDJzRIaOSIe1R/36T1vmYlcqQexILHOccw0Jhfam4aNl8q9lRWa
         maKoNBoTow1soHtEm3jquZJPRmjxCesqSwWAJ4VTwPspnYUViSDz0P/uGGLgSIb2uv77
         cFJL+qceqCMiC6LGgtlN3KVbXKW2dvQlC50wI6E/RRz4HIH9fodHtwACogC+22QAFRYF
         n6QnVu0g0Uhvie5xvZnoTKQZ60ylE8HG3j9JmENjJjU6ynZxqHRY/Xc7KCKTb86UT7Yp
         rdP0tx+qqEfBLFKdwV8RZZQUtdQLqsxj1RWL2HrP8qsBHkdhH7eqklsifjVzcDahCYEW
         PeLA==
X-Gm-Message-State: APjAAAXZ6zBZV1uzaM+M2g6dpl5iUZ2/tfQXUZb+eFwYE/60qlGph1nX
        q96xNtXoYT3n8vXOzcL5VnqOP/fjYKn1+tazsc16SxqK0DaA8DxXlyfE50zQrJMmxhmoi/3nZxE
        gd9D3Iy2IkgugGIUw
X-Received: by 2002:a7b:c8d4:: with SMTP id f20mr6672465wml.56.1576154321536;
        Thu, 12 Dec 2019 04:38:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqwwdmZoRBXRAhpV+I2D00L1wp6fAuTvagscxFEYVkPI+ZSRTzsiKfEn/1uAXKqpUma+stMrcA==
X-Received: by 2002:a7b:c8d4:: with SMTP id f20mr6672437wml.56.1576154321316;
        Thu, 12 Dec 2019 04:38:41 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id x6sm6440761wmi.44.2019.12.12.04.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 04:38:40 -0800 (PST)
Subject: Re: [PATCH 5.5 regression fix 2/2] efi/libstub/helper: Initialize
 pointer variables to zero for mixed mode
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <20191212103158.4958-1-hdegoede@redhat.com>
 <20191212103158.4958-3-hdegoede@redhat.com>
 <CAKv+Gu9AjYVvLot9+enuwSWfyfzqgCWSuW3ioccm3FJ7KFA8eA@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <9c5e89d7-7971-a0b4-fa56-fe4832007ca6@redhat.com>
Date:   Thu, 12 Dec 2019 13:38:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9AjYVvLot9+enuwSWfyfzqgCWSuW3ioccm3FJ7KFA8eA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12-12-2019 12:29, Ard Biesheuvel wrote:
> On Thu, 12 Dec 2019 at 11:32, Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> When running in EFI mixed mode (running a 64 bit kernel on 32 bit EFI
>> firmware), we _must_ initialize any pointers which are returned by
>> reference by an EFI call to NULL before making the EFI call.
>>
>> In mixed mode pointers are 64 bit, but when running on a 32 bit firmware,
>> EFI calls which return a pointer value by reference only fill the lower
>> 32 bits of the passed pointer, leaving the upper 32 bits uninitialized
>> unless we explicitly set them to 0 before the call.
>>
>> We have had this bug in the efi-stub-helper.c file reading code for
>> a while now, but this has likely not been noticed sofar because
>> this code only gets triggered when LILO style file=... arguments are
>> present on the kernel cmdline.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/firmware/efi/libstub/efi-stub-helper.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
>> index e02579907f2e..6ca7d86743af 100644
>> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
>> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
>> @@ -365,7 +365,7 @@ static efi_status_t efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
>>                                    u64 *file_sz)
>>   {
>>          efi_file_handle_t *h, *fh = __fh;
> 
> What about h? Doesn't it suffer from the same problem?
> 
>> -       efi_file_info_t *info;
>> +       efi_file_info_t *info = NULL;
>>          efi_status_t status;
>>          efi_guid_t info_guid = EFI_FILE_INFO_ID;
>>          unsigned long info_sz;
> 
> And info_sz?

You are right in both cases. I only checked allocate_pool and locate_protocol callers as those
are the usual suspects.

Shall I send a v2 of just this patch, or of the entire series, or are you going to
fix this up?

Regards,

Hans


> 
> 
>> @@ -527,7 +527,7 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>>                                    unsigned long *load_addr,
>>                                    unsigned long *load_size)
>>   {
>> -       struct file_info *files;
>> +       struct file_info *files = NULL;
>>          unsigned long file_addr;
>>          u64 file_size_total;
>>          efi_file_handle_t *fh = NULL;
>> --
>> 2.23.0
>>
> 

