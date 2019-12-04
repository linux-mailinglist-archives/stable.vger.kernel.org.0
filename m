Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773761137F3
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 00:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfLDXCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 18:02:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:58110 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfLDXCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 18:02:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 15:02:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,278,1571727600"; 
   d="scan'208";a="243024489"
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.135.23]) ([10.249.135.23])
  by fmsmga002.fm.intel.com with ESMTP; 04 Dec 2019 15:02:35 -0800
Subject: Re: [PATCH 4.19 082/321] ACPI / LPSS: Ignore
 acpi_device_fix_up_power() return value
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223431.423864271@linuxfoundation.org> <20191204212735.GC7678@amd>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <d9ac8b3a-39f7-c9c2-5bb5-9aa774a2de45@intel.com>
Date:   Thu, 5 Dec 2019 00:02:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191204212735.GC7678@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/4/2019 10:27 PM, Pavel Machek wrote:
> Hi!
>
>> From: Hans de Goede <hdegoede@redhat.com>
>>
>> [ Upstream commit 1a2fa02f7489dc4d746f2a15fb77b3ce1affade8 ]
>>
>> Ignore acpi_device_fix_up_power() return value. If we return an error
>> we end up with acpi_default_enumeration() still creating a platform-
>> device for the device and we end up with the device still being used
>> but without the special LPSS related handling which is not useful.
>>
>> Specicifically ignoring the error fixes the touchscreen no longer
>> working after a suspend/resume on a Prowise PT301 tablet.
> I'm pretty sure it does, but:
>
> a) do you believe this is right patch for -stable?

Yes.


>   Should it get lot more testing in mainline

It's been in the mainline since 5.0 and I'm not aware of any bug reports 
against it.


>   as it.... may change things in a wrong way
> for someone else?
>
> b) if we are ignoring errors now, should we at least printk() to let
> the user know that something is wrong with the ACPI tables?

The question whether or not to print a message is orthogonal to this 
patch.   Perhaps it would be useful to print a message on an error 
regardless of whether or not the error is ignored, but then users would 
need to know what to do about that error message.


>> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
>> index b21c241aaab9f..30ccd94f87d24 100644
>> --- a/drivers/acpi/acpi_lpss.c
>> +++ b/drivers/acpi/acpi_lpss.c
>> @@ -665,12 +665,7 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
>>   	 * have _PS0 and _PS3 without _PSC (and no power resources), so
>>   	 * acpi_bus_init_power() will assume that the BIOS has put them into D0.
>>   	 */
>> -	ret = acpi_device_fix_up_power(adev);
>> -	if (ret) {
>> -		/* Skip the device, but continue the namespace scan. */
>> -		ret = 0;
>> -		goto err_out;
>> -	}
>> +	acpi_device_fix_up_power(adev);
>
>
>>   	adev->driver_data = pdata;
>>   	pdev = acpi_create_platform_device(adev, dev_desc->properties);


