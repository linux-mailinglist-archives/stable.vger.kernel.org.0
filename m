Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EE91534EB
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 17:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgBEQDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 11:03:53 -0500
Received: from mail-eopbgr60122.outbound.protection.outlook.com ([40.107.6.122]:21113
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726973AbgBEQDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 11:03:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUQDSKUPIfYYlTA9A3g2AQD6ifaaSmnEC6P7kC9jxtqPIljTvvVTin/yiiY/Lcpmt73T5FbV4+BgAyjLSql1zWUElROYqtjU61f+AWCvgyqb3FbOLi9bo/vHaeSz61135Q8Nkd5jg7Sn790Uxt8tKnkOmOv1wI7OXYX3kQ0C7KvOXMVDbxF6PxwH8fhxJxQtUcaXWzGDr6mGQ7ly6+rV6urVUtPCH38mYfFtKFVomfWrnQDofXE5q8HIY3axhxWQ7gZJMOuD0KBI+PWhaD4XsoYvKFH7b6ER1p0Q0UdwfSafZQVQcCTLoYaAJQCZsPT/kn08Y46kvZd80qfCmY5KPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5xgmJ0HT8+vo4v7DxGFVMzsF8J+wi2D79JmlWH1P2g=;
 b=Vw2mT53ajzwGijGSOQWTSlPlrUxuJIsLfyhMMFdV/9bAxjLDjl9eYdisgizmb6SZ5Be2dZfEpH/+8suTHeRJGzKLxUK/fW7KxETohu68tQFdqWc7UCp7maarpcgmVzaGeomAPAhuBPaoO15/ClN+CopDL5tUPbLErNOHeeQKObgjII2g/rY/Qz6h7eip47gwPlVN3850CP3GldijVUFl/8GSkgTTKqOaIrotxztuYMDy6It5dGMPj2aR8nfROmJUqSUr7+JQJ74fJsCTwMqanfRsHEMCOxaOAyV4/A0Y0WWQsWMeIOsRifRCuxEtAcoa8z4ZVfO+Di0MyZHfrIXeKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5xgmJ0HT8+vo4v7DxGFVMzsF8J+wi2D79JmlWH1P2g=;
 b=COp9qQImzKaLmWlOFxZdHMRfbIbay4J0j4knqPGxcDhwhG7zgDcjXn9cOijUPNjxqOu8BXpGO5rhAqe3H23NCImmHb2aKUM88gwOYXgTTSy9tI6ySWEQhk9h1as+4eeaPy53h398k7iGFdM8HhNTC0wl9+kaRhlO7ZdNXIswsjs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB6014.eurprd07.prod.outlook.com (20.178.123.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.15; Wed, 5 Feb 2020 16:03:48 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::20c4:7ce8:f735:316e%2]) with mapi id 15.20.2707.011; Wed, 5 Feb 2020
 16:03:47 +0000
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size for S25FS-S
To:     John Garry <john.garry@huawei.com>, linux-mtd@lists.infradead.org
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        stable@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <20200114134704.4708-1-alexander.sverdlin@nokia.com>
 <2759888e-0a88-cf76-d2c0-3f0f5141f8cd@huawei.com>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <b376b949-67b1-b3cf-38cd-9f5e5622057d@nokia.com>
Date:   Wed, 5 Feb 2020 17:03:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
In-Reply-To: <2759888e-0a88-cf76-d2c0-3f0f5141f8cd@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HE1PR05CA0257.eurprd05.prod.outlook.com
 (2603:10a6:3:fb::33) To VI1PR07MB5040.eurprd07.prod.outlook.com
 (2603:10a6:803:9c::20)
MIME-Version: 1.0
Received: from [0.0.0.0] (131.228.32.167) by HE1PR05CA0257.eurprd05.prod.outlook.com (2603:10a6:3:fb::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.32 via Frontend Transport; Wed, 5 Feb 2020 16:03:46 +0000
X-Originating-IP: [131.228.32.167]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7a878cee-13fb-4513-e8fc-08d7aa54fbf8
X-MS-TrafficTypeDiagnostic: VI1PR07MB6014:
X-Microsoft-Antispam-PRVS: <VI1PR07MB6014A2D5A661E02C71C0224188020@VI1PR07MB6014.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0304E36CA3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(199004)(189003)(956004)(2616005)(44832011)(16576012)(26005)(31696002)(86362001)(8936002)(2906002)(316002)(8676002)(53546011)(6666004)(478600001)(66556008)(31686004)(66476007)(186003)(66946007)(16526019)(81156014)(81166006)(4326008)(6486002)(5660300002)(52116002)(54906003)(6706004)(36756003)(78286006);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB6014;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eQiz9spku56vIeTM14wytEOL9iDif7jdblsmyMBuoKQht34b7wugJZiT1DawekCNX2x7LSCKRWhQYdunVYuQVVGJqAq22FK9VYGxWjCmm1vDSdXBR9q5TkfoaJa9GEGA9UpdP92y0/SqVYhSy2eZw2odF31oEdjWIvy1u62zNGLF4iDlyeuHJus/kl2tQbFvnj1+nyFZhutTeFqy1JFHHbnkrbEmipck5TAStpCP6zEHRQ9FA9wbTuK/lTYJuF7SvSg3KJEx69ua2CEWUESPOLKABhyzrVe6IGFXkvXg/SbWXlXuRDxcPDIMNf62/oM115aJ6uZJ8pmubthoZDYB33BxYsLLQ6ytg5LRQU1EqKqW9mO7hHvCYZEwV2aCYQ7LvuTgF/qPbwAsqFgkVwhryNPBpRFDFT+H5tba4rmi8k0uy7jVPskHuOzsmvC8RzZ42NH0EAx+7wMpEhjqoiB2z56T0ZZgGWyK3utDMzpy9qUjmD9ilj0w6HpBM/x142ipA+dKr4DUG2v+1rboj+etPQ==
X-MS-Exchange-AntiSpam-MessageData: SwnJgDwlYxc5g7UNC3vx8VcTwsQI7tqcIDtTnztx/h4qWH6eYaArwXY7C986BPO0nnb+RzmuwTVTg27bQhO+AT5/xW9ZGZn1KRoIXfwOV7GWb2CM9cUIdQ10iPwr175ZYnLE2lspLFoKc7UZ/NJbBA==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a878cee-13fb-4513-e8fc-08d7aa54fbf8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2020 16:03:47.9082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RjiipjT2oVkpybvfNngt1YOm83+w49qUmkgYyTTf4EprNtH1JRlw7uMzy1g99eax/FuMH8mJGVIY9geEWxMQk+9W1d2vqJX0ZVbEl3wc/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB6014
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 05/02/2020 16:32, John Garry wrote:
> On 14/01/2020 13:47, Alexander X Sverdlin wrote:
>> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>>
>> Spansion S25FS-S family has an issue in Basic Flash Parameter Table:
>> DWORD-11 bits 7-4 specify write page size 512 bytes. In reality this
>> is configurable in the non-volatile CR3NV register and even factory
>> default configuration is "wrap at 256 bytes". So blind relying on BFPT
>> breaks write operation on these Flashes.
>>
>> All this story is vendor-specific, so add the corresponding fixup hook
>> which first restores the safe page size of 256 bytes from
>> struct flash_info but checks is more performant 512 bytes configuration
>> is active and adjusts the page_size accordingly.

[...]

> One of my dev boards has part s25fl129p1, so I would like to try this patch. However it does not apply. Any chance you could resend?

It was based on spi-nor/next branch of git://git.infradead.org/l2-mtd.git and as I can
see, this branch is unchanged from the last patch submission.
I can re-send if one of the maintainers confirms this wasn't the correct branch
to base on.

[...]

>> Cc: stable@vger.kernel.org
>> Fixes: f384b352c ("mtd: spi-nor: parse Serial Flash Discoverable Parameters (SFDP) tables")
>> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>> ---
>>   drivers/mtd/spi-nor/spi-nor.c | 39 +++++++++++++++++++++++++++++++++++++--
>>   include/linux/mtd/spi-nor.h   |  5 +++++
>>   2 files changed, 42 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
>> index 73172d7..18f8705 100644
>> --- a/drivers/mtd/spi-nor/spi-nor.c
>> +++ b/drivers/mtd/spi-nor/spi-nor.c
>> @@ -1711,6 +1711,39 @@ static struct spi_nor_fixups mx25l25635_fixups = {
>>       .post_bfpt = mx25l25635_post_bfpt_fixups,
>>   };
>>   +/* Spansion S25FS-S SFDP workarounds */
>> +static int s25fs_s_post_bfpt_fixups(struct spi_nor *nor,
>> +    const struct sfdp_parameter_header *bfpt_header,
>> +    const struct sfdp_bfpt *bfpt,
>> +    struct spi_nor_flash_parameter *params)
>> +{
>> +    const struct flash_info *info = nor->info;
>> +    u8 read_opcode, buf;
>> +    int ret;
>> +
>> +    /* Default is safe */
>> +    params->page_size = info->page_size;
>> +
>> +    /*
>> +     * But is the chip configured for more performant 512 bytes write page
>> +     * size?
>> +     */
>> +    read_opcode = nor->read_opcode;
>> +
>> +    nor->read_opcode = SPINOR_OP_RDAR;
>> +    ret = nor->read(nor, SPINOR_REG_CR3V, 1, &buf);
> 
> struct spi_nor has no member .read AFAICS.
> 
>> +    if (!ret && (buf & CR3V_02H_V))
>> +        params->page_size = 512;
>> +
>> +    nor->read_opcode = read_opcode;
>> +
>> +    return ret;
>> +}
>> +
>> +static const struct spi_nor_fixups s25fs_s_fixups = {
>> +    .post_bfpt = s25fs_s_post_bfpt_fixups,
>> +};
>> +
>>   /* NOTE: double check command sets and memory organization when you add
>>    * more nor chips.  This current list focusses on newer chips, which
>>    * have been converging on command sets which including JEDEC ID.
>> @@ -1903,7 +1936,8 @@ static const struct flash_info spi_nor_ids[] = {
>>               SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>       { "s25fl128s1", INFO6(0x012018, 0x4d0180, 64 * 1024, 256,
>>               SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>> -    { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR) },
>> +    { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR)
>> +            .fixups = &s25fs_s_fixups, },
>>       { "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>       { "s25fl512s",  INFO6(0x010220, 0x4d0080, 256 * 1024, 256,
>>               SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>> @@ -1913,7 +1947,8 @@ static const struct flash_info spi_nor_ids[] = {
>>       { "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024,  64, 0) },
>>       { "s25sl12801", INFO(0x012018, 0x0301,  64 * 1024, 256, 0) },
>>       { "s25fl129p0", INFO(0x012018, 0x4d00, 256 * 1024,  64, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>> -    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>> +    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
>> +            .fixups = &s25fs_s_fixups, },
>>       { "s25sl004a",  INFO(0x010212,      0,  64 * 1024,   8, 0) },
>>       { "s25sl008a",  INFO(0x010213,      0,  64 * 1024,  16, 0) },
>>       { "s25sl016a",  INFO(0x010214,      0,  64 * 1024,  32, 0) },
>> diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
>> index b3d360b..222eee9 100644
>> --- a/include/linux/mtd/spi-nor.h
>> +++ b/include/linux/mtd/spi-nor.h
>> @@ -114,6 +114,7 @@
>>   /* Used for Spansion flashes only. */
>>   #define SPINOR_OP_BRWR        0x17    /* Bank register write */
>>   #define SPINOR_OP_CLSR        0x30    /* Clear status register 1 */
>> +#define SPINOR_OP_RDAR        0x65    /* Read Any Register */
>>     /* Used for Micron flashes only. */
>>   #define SPINOR_OP_RD_EVCR      0x65    /* Read EVCR register */
>> @@ -149,6 +150,10 @@
>>   /* Status Register 2 bits. */
>>   #define SR2_QUAD_EN_BIT7    BIT(7)
>>   +/* Used for Spansion flashes RDAR command only. */
>> +#define SPINOR_REG_CR3V        0x800004
>> +#define CR3V_02H_V        BIT(4)    /* Page Buffer Wrap */
>> +
>>   /* Supported SPI protocols */
>>   #define SNOR_PROTO_INST_MASK    GENMASK(23, 16)
>>   #define SNOR_PROTO_INST_SHIFT    16
>>
> 
> 

-- 
Best regards,
Alexander Sverdlin.
