Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D6C2D6CA4
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 01:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389559AbgLKAoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 19:44:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56814 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733153AbgLKAnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 19:43:50 -0500
Received: from [123.114.42.209] (helo=[192.168.0.106])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1knWWZ-0003e2-Dw; Fri, 11 Dec 2020 00:43:07 +0000
Subject: Re: [PATCH v2] ACPI / PNP: check the string length of pnp device id
 in matching_id
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Stable <stable@vger.kernel.org>
References: <20201210012539.5747-1-hui.wang@canonical.com>
 <CAJZ5v0jDHka2mxHiUBd41N5QV0ePS9O-EbFz46DXTYPKbDv-Ug@mail.gmail.com>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <9462e5b6-e1af-dc91-1450-809ce7b91119@canonical.com>
Date:   Fri, 11 Dec 2020 08:43:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0jDHka2mxHiUBd41N5QV0ePS9O-EbFz46DXTYPKbDv-Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/10/20 9:57 PM, Rafael J. Wysocki wrote:
> On Thu, Dec 10, 2020 at 2:27 AM Hui Wang <hui.wang@canonical.com> wrote:
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
>>          int i;
>>
>> +       /* a pnp device id has CCCdddd format (C character, d digit), strlen should be 7 */
>> +       if (strlen(idstr) != 7)
>> +               return false;
> What I meant was comparing the length of the arg strings and return
> false if they don't match.  Wouldn't that work?

Oh, got it.

Thanks.

>
>> +
>>          if (memcmp(idstr, list_id, 3))
>>                  return false;
>>
>> --
>> 2.25.1
>>
