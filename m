Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E670F52031
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 03:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbfFYBAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 21:00:52 -0400
Received: from smtp2207-205.mail.aliyun.com ([121.197.207.205]:45179 "EHLO
        smtp2207-205.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729336AbfFYBAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 21:00:52 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08014652|-1;CH=green;DM=CONTINUE|CONTINUE|true|0.238094-0.0170177-0.744888;FP=0|0|0|0|0|-1|-1|-1;HT=e01l01425;MF=liaoweixiong@allwinnertech.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.Epjbx14_1561424445;
Received: from 172.16.10.102(mailfrom:liaoweixiong@allwinnertech.com fp:SMTPD_---.Epjbx14_1561424445)
          by smtp.aliyun-inc.com(10.147.42.135);
          Tue, 25 Jun 2019 09:00:46 +0800
Subject: Re: [RESEND PATCH v2] mtd: spinand: read return badly if the last
 page has bitflips
To:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Frieder Schrempf <frieder.schrempf@exceet.de>,
        Peter Pan <peterpandong@micron.com>,
        Chuanhong Guo <gch981213@gmail.com>
Cc:     "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <1561378534-26119-1-git-send-email-liaoweixiong@allwinnertech.com>
 <f86e6750-6b4f-daf7-3f0c-1c5e63b5b95d@kontron.de>
From:   liaoweixiong <liaoweixiong@allwinnertech.com>
Message-ID: <049081eb-355e-6671-310c-3083cbdb0abc@allwinnertech.com>
Date:   Tue, 25 Jun 2019 09:00:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f86e6750-6b4f-daf7-3f0c-1c5e63b5b95d@kontron.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Um.. I am sorry. It is the first time for me to resend patch.
I will send this patch again with correct tags.

On 2019/6/24 PM10:47, Schrempf Frieder wrote:
> On 24.06.19 14:15, liaoweixiong wrote:
>> In case of the last page containing bitflips (ret > 0),
>> spinand_mtd_read() will return that number of bitflips for the last
>> page. But to me it looks like it should instead return max_bitflips like
>> it does when the last page read returns with 0.
>>
>> Signed-off-by: liaoweixiong <liaoweixiong@allwinnertech.com>
>> Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
>> Acked-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> Why did you change our Reviewed-by tags to Acked-by tags?
> 
>> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
>> ---
>>   drivers/mtd/nand/spi/core.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
>> index 556bfdb..6b9388d 100644
>> --- a/drivers/mtd/nand/spi/core.c
>> +++ b/drivers/mtd/nand/spi/core.c
>> @@ -511,12 +511,12 @@ static int spinand_mtd_read(struct mtd_info *mtd, loff_t from,
>>   		if (ret == -EBADMSG) {
>>   			ecc_failed = true;
>>   			mtd->ecc_stats.failed++;
>> -			ret = 0;
>>   		} else {
>>   			mtd->ecc_stats.corrected += ret;
>>   			max_bitflips = max_t(unsigned int, max_bitflips, ret);
>>   		}
>>   
>> +		ret = 0;
>>   		ops->retlen += iter.req.datalen;
>>   		ops->oobretlen += iter.req.ooblen;
>>   	}

-- 
liaoweixiong
