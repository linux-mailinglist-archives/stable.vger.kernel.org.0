Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25EE52F146
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 19:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352027AbiETRJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 13:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352017AbiETRJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 13:09:18 -0400
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03A81796FC
        for <stable@vger.kernel.org>; Fri, 20 May 2022 10:09:17 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id s67knGiLCm7vss67kn9UzI; Fri, 20 May 2022 19:09:16 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 20 May 2022 19:09:16 +0200
X-ME-IP: 86.243.180.246
Message-ID: <2c788d15-e771-377a-2dd2-796c86cf6f8a@wanadoo.fr>
Date:   Fri, 20 May 2022 19:09:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2] mtd: rawnand: cafe: fix drivers probe/remove methods
Content-Language: en-US
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Peng Wu <wupeng58@huawei.com>, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, liwei391@huawei.com,
        Kernel Janitors <kernel-janitors@vger.kernel.org>
References: <20220520084425.116686-1-wupeng58@huawei.com>
 <7b1b26e4-cc8e-3375-788c-56b5b548367d@wanadoo.fr>
In-Reply-To: <7b1b26e4-cc8e-3375-788c-56b5b548367d@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 20/05/2022 à 18:53, Christophe JAILLET a écrit :
> Le 20/05/2022 à 10:44, Peng Wu a écrit :
>> Driver should call pci_disable_device() if it returns from
>> cafe_nand_probe() with error.
>>
>> Meanwhile, the driver calls pci_enable_device() in
>> cafe_nand_probe(), but never calls pci_disable_device()
>> during removal.
>>
>> Signed-off-by: Peng Wu <wupeng58@huawei.com>
>> ---
>> v2:
>> - fix the subject prefix with "mtd: ranwnand: cafe:"
>> ---
>>   drivers/mtd/nand/raw/cafe_nand.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/raw/cafe_nand.c 
>> b/drivers/mtd/nand/raw/cafe_nand.c
>> index 9dbf031716a6..af119e376352 100644
>> --- a/drivers/mtd/nand/raw/cafe_nand.c
>> +++ b/drivers/mtd/nand/raw/cafe_nand.c
>> @@ -679,8 +679,10 @@ static int cafe_nand_probe(struct pci_dev *pdev,
>>       pci_set_master(pdev);
>>       cafe = kzalloc(sizeof(*cafe), GFP_KERNEL);
>> -    if (!cafe)
>> -        return  -ENOMEM;
>> +    if (!cafe) {
>> +        err = -ENOMEM;
>> +        goto out_disable_device;
>> +    }
>>       mtd = nand_to_mtd(&cafe->nand);
>>       mtd->dev.parent = &pdev->dev;
>> @@ -801,6 +803,8 @@ static int cafe_nand_probe(struct pci_dev *pdev,
>>       pci_iounmap(pdev, cafe->mmio);
>>    out_free_mtd:
>>       kfree(cafe);
>> + out_disable_device:
>> +    pci_disable_device(pdev);
>>    out:
>>       return err;
>>   }
>> @@ -822,6 +826,7 @@ static void cafe_nand_remove(struct pci_dev *pdev)
>>       pci_iounmap(pdev, cafe->mmio);
>>       dma_free_coherent(&cafe->pdev->dev, 2112, cafe->dmabuf, 
>> cafe->dmaaddr);
> 
> Hi,
> 
> Not related to this patch , but I wonder if this dma_free_coherent() is 
> needed.
> It is already part of cafe_nand_detach_chip() which is a .detach_chip() 
> function.
> 
> Is this .detach_chip() function already called (by nand_cleanup()) 
> somewhere in the removal process?
> 

In fact the "somewhere" is just 3 lines above the dma_free_coherent() 
call. So I definitively think that this line should be axed.

CJ


> CJ
> 
> 
>>       kfree(cafe);
>> +    pci_disable_device(pdev);
>>   }
>>   static const struct pci_device_id cafe_nand_tbl[] = {
> 
> 
