Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA3515A741
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 12:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgBLLBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 06:01:47 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:54586 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgBLLBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 06:01:46 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01CB1bdO061311;
        Wed, 12 Feb 2020 05:01:37 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581505297;
        bh=V0cNRr6nMfebDwQ1Gji0eIn7moZlgt46XRlYG9hjkd4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Vco7dHicYxB7mfj5Soxbrl92Azfqsz+llyU8Jba5IXt81AyX7xYDshilWIgfKvqi9
         mN05xnujwaQJlCgCcSKdS+U3op8nRvNMAqCYSYH3zDVfwQyyeGfyJlWp7qGH41nrUD
         VBfAW2CB3RNEsR/dvTL7N6mCvWm62qkgcuNggLj0=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01CB1bkv031866
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Feb 2020 05:01:37 -0600
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 12
 Feb 2020 05:01:35 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 12 Feb 2020 05:01:35 -0600
Received: from [192.168.2.14] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01CB1WXq116272;
        Wed, 12 Feb 2020 05:01:33 -0600
Subject: Re: [PATCH] ata: ahci_platform: add 32-bit quirk for dwc-ahci
To:     Hans de Goede <hdegoede@redhat.com>, <axboe@kernel.dk>
CC:     <vigneshr@ti.com>, <nsekhar@ti.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?Q?P=c3=a9ter_Ujfalusi?= <peter.ujfalusi@ti.com>
References: <20200206111728.6703-1-rogerq@ti.com>
 <d3a80407-a40a-c9e4-830f-138cfe9b163c@redhat.com>
From:   Roger Quadros <rogerq@ti.com>
Message-ID: <1c3ec10c-8505-a067-d51d-667f47d8d55b@ti.com>
Date:   Wed, 12 Feb 2020 13:01:32 +0200
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

Hi,

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
> 
> IMHO it would be better to introduce a TI specific compatible
> and use that to match on instead (and also adjust the dts files
> accordingly).

Thinking further on this I think it is a bad idea to add a special
binding because the IP is not different. It is just that it is
wired differently on the TI SoC so DMA range is limited.

IMO the proper solution is to have the right dma-ranges property in the
device tree. However, SATA platform driver is doing the wrong thing
by overriding the dma masks.
i.e. in ahci_platform_init_host() in libahci_platform.c

         if (hpriv->cap & HOST_CAP_64) {
                 rc = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
                 if (rc) {
                         rc = dma_coerce_mask_and_coherent(dev,
                                                           DMA_BIT_MASK(32));
                         if (rc) {
                                 dev_err(dev, "Failed to enable 64-bit DMA.\n");
                                 return rc;
                         }
                         dev_warn(dev, "Enable 32-bit DMA instead of 64-bit.\n");
                 }
         }

This should be removed. Do you agree?

You can also see a similar in ahci_configure_dma_masks() with the XXX disclaimer
explaining that it is wrong.

static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
{
         const int dma_bits = using_dac ? 64 : 32;
         int rc;

         /*
          * If the device fixup already set the dma_mask to some non-standard
          * value, don't extend it here. This happens on STA2X11, for example.
          *
          * XXX: manipulating the DMA mask from platform code is completely
          * bogus, platform code should use dev->bus_dma_limit instead..
          */
         if (pdev->dma_mask && pdev->dma_mask < DMA_BIT_MASK(32))
                 return 0;

         rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(dma_bits));
         if (rc)
                 dev_err(&pdev->dev, "DMA enable failed\n");
         return rc;
}


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
cheers,
-roger
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
