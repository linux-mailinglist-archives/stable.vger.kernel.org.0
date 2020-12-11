Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37452D6CA3
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 01:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733306AbgLKAnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 19:43:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56797 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733153AbgLKAmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 19:42:35 -0500
Received: from [123.114.42.209] (helo=[192.168.0.106])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1knWVM-0003ZX-If; Fri, 11 Dec 2020 00:41:53 +0000
Subject: Re: [PATCH v2] ACPI / PNP: check the string length of pnp device id
 in matching_id
To:     Greg KH <greg@kroah.com>
Cc:     linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com,
        lenb@kernel.org, stable@vger.kernel.org
References: <20201210012539.5747-1-hui.wang@canonical.com>
 <X9HklmczekRvwKTE@kroah.com>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <b99ea4e8-8bc2-6533-b78d-8a729c9400f7@canonical.com>
Date:   Fri, 11 Dec 2020 08:41:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <X9HklmczekRvwKTE@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/10/20 5:04 PM, Greg KH wrote:
> On Thu, Dec 10, 2020 at 09:25:39AM +0800, Hui Wang wrote:
>> Recently we met a touchscreen problem on some Thinkpad machines, the
>> touchscreen driver (i2c-hid) is not loaded and the touchscreen can't
>> work.
>>
>> An i2c ACPI device with the name WACF2200 is defined in the BIOS, with
>> the current ACPI PNP matching rule, this device will be regarded as
>> a PNP device since there is WACFXXX in the acpi_pnp_device_ids[] and
>> this PNP device is attached to the acpi device as the 1st
>> physical_node, this will make the i2c bus match fail when i2c bus
>> calls acpi_companion_match() to match the acpi_id_table in the i2c-hid
>> driver.
>>
>> An ACPI PNP device's id has fixed format and its string length equals
>> 7, after adding this check in the matching_id, the touchscreen could
>> work.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hui Wang <hui.wang@canonical.com>
>> ---
>>   drivers/acpi/acpi_pnp.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
>> index 4ed755a963aa..5ce711b9b070 100644
>> --- a/drivers/acpi/acpi_pnp.c
>> +++ b/drivers/acpi/acpi_pnp.c
>> @@ -319,6 +319,10 @@ static bool matching_id(const char *idstr, const char *list_id)
>>   {
>>   	int i;
>>   
>> +	/* a pnp device id has CCCdddd format (C character, d digit), strlen should be 7 */
>> +	if (strlen(idstr) != 7)
>> +		return false;
> Shouldn't you verify that the format is correct as well?

I thought the rest code in this function will verify the format, just 
missing the length checking. But I was wrong, "a pnp device id has 
CCCdddd format" is not correct since WACFXXX is a valid id, I will 
follow Rafael's advice:  compare two string's length.

Thanks.


>
> thanks,
>
> greg k-h
