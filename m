Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45074154391
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 12:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgBFLzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 06:55:06 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:41050 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727630AbgBFLzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 06:55:05 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 016Bt0hH091917;
        Thu, 6 Feb 2020 05:55:00 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1580990100;
        bh=2Coh5p3qK7LHZQttiOinvCEs7fyz7VfDVezsyJy7rYQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=ek6SC1TAl5DzeYgwPpr9VSihDWTPoxgPuhzqO81fOexKs5XkSwS+tx++DPywyPBO2
         JlnyeUMWiZTJwhSAXkaAr075Skh4H9qAUeqI0lNCzF9jTBqhZaQFZTPVX6UKiHa6Vk
         yxBu8UH35HsY3jWQJ1XVxzWSnkvcGx39JUMuCPeI=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 016Bt0os083904;
        Thu, 6 Feb 2020 05:55:00 -0600
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 6 Feb
 2020 05:55:00 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 6 Feb 2020 05:55:00 -0600
Received: from [192.168.2.14] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 016BswWh069423;
        Thu, 6 Feb 2020 05:54:58 -0600
Subject: Re: [PATCH] ata: ahci_platform: add 32-bit quirk for dwc-ahci
To:     Hans de Goede <hdegoede@redhat.com>, <axboe@kernel.dk>
CC:     <vigneshr@ti.com>, <nsekhar@ti.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20200206111728.6703-1-rogerq@ti.com>
 <d3a80407-a40a-c9e4-830f-138cfe9b163c@redhat.com>
From:   Roger Quadros <rogerq@ti.com>
Message-ID: <50ad68d2-39e2-d2f0-1794-cf7b499cb1f0@ti.com>
Date:   Thu, 6 Feb 2020 13:54:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d3a80407-a40a-c9e4-830f-138cfe9b163c@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hans,

On 06/02/2020 13:50, Hans de Goede wrote:
> Hi,
> 
> On 2/6/20 12:17 PM, Roger Quadros wrote:
>> On TI Platforms using LPAE, SATA breaks with 64-bit DMA.
>> Restrict it to 32-bit.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>   drivers/ata/ahci_platform.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
>> index 3aab2e3d57f3..b925dc54cfa5 100644
>> --- a/drivers/ata/ahci_platform.c
>> +++ b/drivers/ata/ahci_platform.c
>> @@ -62,6 +62,9 @@ static int ahci_probe(struct platform_device *pdev)
>>       if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
>>           hpriv->flags |= AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;
>> +    if (of_device_is_compatible(dev->of_node, "snps,dwc-ahci"))
>> +        hpriv->flags |= AHCI_HFLAG_32BIT_ONLY;
>> +
> 
> The "snps,dwc-ahci" is a generic (non TI specific) compatible which
> is e.g. also used on some exynos devices. So using that to key the
> setting of the 32 bit flag seems wrong to me.

You are right, Vignesh also pointed this out to me offline.

snps,dwc-ahci does indeed support 64-bit addressing, so this patch is wrong.

> 
> IMHO it would be better to introduce a TI specific compatible
> and use that to match on instead (and also adjust the dts files
> accordingly).

The TI platform's TRM does say it has only 36-bits of the controller wired
in the device. If that was the case and DDR address never goes beyond
36-bits, we don't understand why it fails in the first place.

80000000-afcfffff : System RAM
b0000000-feffffff : System RAM
200000000-27fffffff : System RAM

cheers,
-roger

> 
> Regards,
> 
> Hans
> 
> 
> 
>>       port = acpi_device_get_match_data(dev);
>>       if (!port)
>>           port = &ahci_port_info;
>>
> 

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
