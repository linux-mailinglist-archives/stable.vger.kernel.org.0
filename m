Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD732681B3
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 00:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgIMWdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Sep 2020 18:33:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41347 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgIMWd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Sep 2020 18:33:26 -0400
Received: from mail-pg1-f200.google.com ([209.85.215.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <alex.hung@canonical.com>)
        id 1kHaYm-0000Br-AA
        for stable@vger.kernel.org; Sun, 13 Sep 2020 22:33:24 +0000
Received: by mail-pg1-f200.google.com with SMTP id t3so8147329pgc.21
        for <stable@vger.kernel.org>; Sun, 13 Sep 2020 15:33:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rEKlKZmh/1YZMbvfsNtQ59gLQC9wICTVNrBlPswdPyM=;
        b=SQSoMnuusN9LmRUAYq/1JHJOiYFGV+YRHSjQBH64HzBm2klFIsJ21W6U+J8fgJm0Jg
         7lJgpRHhpWak0/ImRjFDEKW4sYxa2OiEwFi82DopWGf4mfIAKqXgvvNUWHK5JoY7z+mv
         WcOXUbwGnc+F6l3Ug2+eDyIpkcMPYXh8sGxPmNL9N2ZeXEqa3dp8MCRyNZwykDprTs3Z
         W/F10zBQLugCQHndqDpRhdlkz7PEZf9HuLlXB/HrmsAJXCVkqKNc5nULfN7dyXdaWcx6
         YzllC3POFUB6mU3+lpyO+/M4qewD/rVrtckELxSCgY8ZnET+VUJkwWZ5rmaviOs5Htlh
         XTSw==
X-Gm-Message-State: AOAM531GhLUDfH8PEs8USLN1dYnDNjM4pGZYvbugGAo6SXHW3qe9jEUb
        YBbMYG8ecUnYVUpwvp2DBnz8aW2HPatqIrQO7q8YjZQOJXFm4GdkyvwKcwm0xGjfqKCXyFvn5fP
        xD0XoY3FjeuvZpQTB2kCBBGgiKw0LQUG4fg==
X-Received: by 2002:a17:90a:2ec8:: with SMTP id h8mr11530602pjs.173.1600036402795;
        Sun, 13 Sep 2020 15:33:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzosOtxUbpPgTZbDQitLsYRQmDKVbBLcnbz36bOMEnqd19xG9jTA7kwvfXHZfIm0tWP+W4A3w==
X-Received: by 2002:a17:90a:2ec8:: with SMTP id h8mr11530584pjs.173.1600036402461;
        Sun, 13 Sep 2020 15:33:22 -0700 (PDT)
Received: from [192.168.0.119] (d66-222-144-129.abhsia.telus.net. [66.222.144.129])
        by smtp.gmail.com with ESMTPSA id c3sm8428906pfo.120.2020.09.13.15.33.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2020 15:33:21 -0700 (PDT)
Subject: Re: [PATCH] ACPI: video: use ACPI backlight for HP 635 Notebook
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        All applicable <stable@vger.kernel.org>
References: <20200911221420.21692-1-alex.hung@canonical.com>
 <20200912064900.GB558156@kroah.com>
From:   Alex Hung <alex.hung@canonical.com>
Message-ID: <dcd820c5-619c-bd18-4d38-4a4cab38a2f4@canonical.com>
Date:   Sun, 13 Sep 2020 16:33:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200912064900.GB558156@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-09-12 12:49 a.m., Greg KH wrote:
> On Fri, Sep 11, 2020 at 04:14:20PM -0600, Alex Hung wrote:
>> Default backlight interface is AMD's radeon_bl0 which does not work on
>> this system. As a result, let's for ACPI backlight interface for this
>> system.
>>
>> BugLink: https://bugs.launchpad.net/bugs/1894667
>>
>> Cc: All applicable <stable@vger.kernel.org>
>> Signed-off-by: Alex Hung <alex.hung@canonical.com>
>> ---
>>  drivers/acpi/video_detect.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
>> index 2499d7e..05047a3 100644
>> --- a/drivers/acpi/video_detect.c
>> +++ b/drivers/acpi/video_detect.c
>> @@ -282,6 +282,15 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
>>  		DMI_MATCH(DMI_PRODUCT_NAME, "530U4E/540U4E"),
>>  		},
>>  	},
>> +	/* https://bugs.launchpad.net/bugs/1894667 */
>> +	{
>> +	 .callback = video_detect_force_video,
>> +	 .ident = "HP 635 Notebook",
>> +	 .matches = {
>> +		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
>> +		DMI_MATCH(DMI_PRODUCT_NAME, "HP 635 Notebook PC"),
>> +		},
>> +	},
>>  
>>  	/* Non win8 machines which need native backlight nevertheless */
>>  	{
>> -- 
>> 2.7.4
>>
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>
> 

Sorry about this.

I will send V2 to correct it to "Cc: stable@vger.kernel.org"


-- 
Cheers,
Alex Hung
