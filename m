Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827A4532CAC
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 16:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238490AbiEXO4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 10:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiEXO4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 10:56:09 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AED111D;
        Tue, 24 May 2022 07:56:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4cdRIfcpVEG7tJwOv4Igsp4QrbsVVDl52NbVip1kjItmu//hgALKlupvyrBjlTacjXz6Td8AbSp4Pc2HibQcpARw3m3tauI7oTbN/MlTALi5OBsu4h5yL7t2GA20cC+L6Uxd3FKmc6mU1LFC59jGgbMjnFj13/pkYRLqURSYo+h856KVaWJu1xAYkDK4utnm1boFfUb50RVErOc9mo3Zm4m3qRwhk8o8lnnKqDgFMYG/9YkJWPvtZaUs9TqnPGSgyy4+bhjmzJVF5UzHwuk6ELDto2YLam2S7aPm0q94slNjkJdmuKTCzhShZu4PLrF3bAxxgipsWqWKwlo2YkkXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TFPmkTKHa7jD7ZZpz3n0T4wSQlVwH+xoQ8GvJJCNvQ=;
 b=eRAxllfqDFLvkNhI5dY3kCZD6jIf2NzdOZ6Sa7N/NPZLkGmrloSm4Z0XRiopxjOGgIlDLIG01P7ipYAxG+SWI0P7gAPEEjsduq0LryCOG7EaxaTp0rqaJfDArxLoHAHM8GmbBWeWLgGKFeH5q2TTp8fkzKDLYzuA8H3QwbVDY7kNiG23s8ntL4upyjEDZDGNR7S8RjGYQKLq2GjRk03Mfwz1T9fOW30/Q+Ak4Xc/qODZFi1a3/NaQgeoRpV5CKAUwfcBcoSZdJQUP2YHfkOucnH/PmD3o6P2gL4PES/N2z+BoAYkMm6IBuFZpAuu52helFuFEkU0GfhbzrSrSl5YLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TFPmkTKHa7jD7ZZpz3n0T4wSQlVwH+xoQ8GvJJCNvQ=;
 b=qabXazxuws0tffy8ga8qE8rWLiydFy+6k/apjPbjblrH5Vyggv6SfT09AJ7kudGL0aBmcvXJ2mb+3C61JPapO8e97TDJ7OmnqvXQzbApbYWvWHmwz0ZrTbM0kJZlkEMhqOTz5u1NMLYxieE6veQmztEyfnHlyxCGVIuEX0nKLrtFT2sjlp1j7MqQ+Vk6Hpxw92BLAPHyR2pIz0psqvUp8yiy1yrh7DGVMgQJ4on3SaUkxeZh48MmxvGCncQCKhXY9t73sQImoxnXRkZaKoSIez2dBIHy0cZdSVX/lxOWKath7jegFTxJIEtGO2uq7KXXExKeYIT+8MNo8AtJ+AeJbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 BN8PR12MB3428.namprd12.prod.outlook.com (2603:10b6:408:47::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.22; Tue, 24 May 2022 14:56:07 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5293.013; Tue, 24 May 2022
 14:56:07 +0000
Message-ID: <fbeb9833-4166-1919-e6ab-9ac7625a21d6@nvidia.com>
Date:   Tue, 24 May 2022 15:55:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
From:   Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 4.9 00/25] 4.9.316-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220523165743.398280407@linuxfoundation.org>
 <6f4034a5-f692-8a64-a09d-8bfe49767b78@nvidia.com>
 <YozK4DvamHBJ1qdX@kroah.com>
Content-Language: en-US
In-Reply-To: <YozK4DvamHBJ1qdX@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0236.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::7) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ac2b8a6-5ca5-458e-33c3-08da3d958819
X-MS-TrafficTypeDiagnostic: BN8PR12MB3428:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3428744AF80CB9978E99BEA8D9D79@BN8PR12MB3428.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NumfCPNkE0n7TJzv8ocHStCqCQBlVfD6jLkgHuGhcJ7YEkmog3GdZUJYaXIW7PQitaeeOHUlP9Qcvf1NoEfK4TNALbTuOAPptU6pon3OR/o5h+UqODmjm6YlTPxblCyamGW9QMQqN/89Sc+Ou5QJpmAU9buCnuw7/phx0pRAWsM0/xxeK2g94tVR/vfpRYqz3xgzUQPnBFt3iyI4IkZjjYOZsFC/TMLenPaVokiXE5ji5RZyIoai93VGqoH8/aw6IC5066ObjOOIaov9st85AKi9tjCnVltOA624BDtcCY9LZSuCGltTEcmGcMmwcgf/f0JSvajVcjSpxt0BRG2KK0FigiK/J5KX8anG3sOAwyCylVAMNc2xKQzaWCmr1vSOlA0x+PaB0S8JiKN2hA4f5Wt6dGSf21cfE84kQWvG3zWb6aCCyWDym6mZ09L2ihn1AgNozrnTYU5VreegdQC45hQXwxGIm0KMzXQk88d5cBky8pMYjScVRV4jeTBV6t2armO+NF7ulgpPON79MGlVebBHLWXmgvu3xJI+YNd9nrAwn7j78aXvT9pwUg/6ZhMfGAeAuvUGpNsaADt+8AThs5zIHrW7amAY+c7DUvGRn/aUqRbBLdBErSNwC7VxldgEUhI2NSTJq1Rsl3WXwqnzKlYohRhoGzIFJv4pXjRI0ohUVt1FKoxs5JUjqaZxW/vcWz51NOm43vRFTWqNdQ/j6SfZaKVXU5HDAcr4m2Cyqi2E8ZzXoV8bfxaIUcAjCsVLbYyI1w8DSz0vbO40QMz1FLH/QtHrVOTjOBczdcNrBa83M7AkNbrID1xlVCLcaVC+xJm2tQg1SOX2rLFXkmEI/AKCTZFh0wiot3kjavdncF4mIRwJG8cT+Hf999AjVh2y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(966005)(6506007)(6512007)(6666004)(6486002)(26005)(55236004)(53546011)(508600001)(186003)(110136005)(2616005)(8936002)(7416002)(31696002)(66476007)(8676002)(66556008)(31686004)(36756003)(316002)(86362001)(2906002)(66946007)(4326008)(5660300002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1JnOTRRd0ZlaUxjelFialhVRHdWZkhmT3cvUGtvR1NHU0t4VXcvNUg1TlB6?=
 =?utf-8?B?R3pmV1ZDV0RZc2FIK2ZsSWVrS2h5ZWxDTi94anhzS09zVURhbUZHam8rSXZv?=
 =?utf-8?B?RjgvdWpUNVhDbGwrTHA2SGF5a3ErMHFGVThwWkxBRzVEY0xyd0dKcmN4NHcx?=
 =?utf-8?B?UzJEYzV4UFQ5bTMzQnYzN0xyOGhYQmIwZnBBbjVEQzJ1L2NCbFRGUm9jK1FR?=
 =?utf-8?B?L2VoNWwyM2FVY2ZpakFtaHRiYXJuR2ZFWm1xR3JwY1BROUFsYWswdXkrNTkz?=
 =?utf-8?B?ZGN2YVNSNFp2cHdZVk9yaS9hcGZhVVAyNkJIb25VVnVyZitiZFNZeHMra1JQ?=
 =?utf-8?B?MjJkS1UzTUllK3o1ek04UngvL3A2OTdDaE9OUUMwMWVyWDB2WDQ3Z3lacTli?=
 =?utf-8?B?TmxRVmlFMVJpd2M5ZU45NDlpckZpU0hqdkRkNzhnNVEvVnNHdUd2V2g3VVdp?=
 =?utf-8?B?YVVaaTIrSm9kWUV2RTVROFRoS0xLVDE2QjdBWWllQUkydGt2d2p2dTZLcjhQ?=
 =?utf-8?B?THF0a2s4WjZjdlYwYW11RVZ2aExLM1VkWUE1bHkzd2N5cVlQaXhnR3BDa2d4?=
 =?utf-8?B?c01jUHlWTTZGSG9jQ0JMdmJ0RnVHM3RzMVFtWjNHWTdCL1BjQ25LL3FmdEpY?=
 =?utf-8?B?ZlNSYnJtM1lkS0xSK2l3MnhxYUJGUEo1SklZa3BieWI0eFBHM1NhNCtMNksx?=
 =?utf-8?B?a3A4UGh3bGNXam0yeTRweEdDUlpvQlFMajBJQndpMU82UzlRdzQ5RjYvWGlB?=
 =?utf-8?B?amRxV2ovU1RnWUdjaE1vTkk4L0UwZE1MakZUTmpIMGpEaXhoQ2Z3bmEvN2VJ?=
 =?utf-8?B?Q2FyLzNHTExEM1BGeXZwbjhabjJxMEViTzRqSkxoOVhJQUxrbWZSQWhVT3R0?=
 =?utf-8?B?N3U5aTJNbE5DOUJXOFdoYjFzT1JIdWVZUWxlZ3dhdzBYLzFSM1FyVE5ieW9u?=
 =?utf-8?B?cXJyMFlRZWI0WVkxWE01cWpiQ2NqTVdlNHV4K0NkckVEL25TNU5WaUJzMUI4?=
 =?utf-8?B?TzZVZjZ2akwrd1hINHZnRmhTdmdTaEJab2JZMWt3M3A0ZU9pNkZBNU9xSlcr?=
 =?utf-8?B?NVM5aTdaU3hTWFp3b29VVVQxK05ISGFPc0t6djdocWVvYTR0QkQyb0tQOUdE?=
 =?utf-8?B?ZC9reXNBQlJqMFpJR0trcys3V1NsdXh5RU8yUGZ3K1pMS25hZ3dtcjFod04x?=
 =?utf-8?B?ZGFjV2F5VWo0U1h2TEFSRUtWbkxvamVxRGdxWWR1aEFQRGVyL0M1OTUzZWE5?=
 =?utf-8?B?TFRTc1dReXhDdkZpUVNZVFVHc3NTdVdrMUZRY0VZWlNaNnlPdGlva0tTY1FZ?=
 =?utf-8?B?UWhDNWhsN2RFWlVsU0dYUzQvQU44UE5MWFFJV2c0bkJIcVVQLzdld2VGVG80?=
 =?utf-8?B?Tkt6bXNnVjJDelcrbmYrNGR1bDBRWktaOVNXbjlDcE0xdFlpeTVkVlBzaU1F?=
 =?utf-8?B?cll2cUxMY2tFa2J1TlNTQm9GdEZObHlmWElVS0I5RmhScjFPbVUwbXZqN0xQ?=
 =?utf-8?B?dlNIZ1ludldPVHplbEZUVnE3aDlMWWNkTlZDYnZaWW5ieW9wblBtUGVwa1E1?=
 =?utf-8?B?dzAzS1Q4TzFvZzNocytHdS9FdkFsNk5VNHNJc2xSYjYveUVIeDR0Tk1jY3Bz?=
 =?utf-8?B?N010NmtCcmJ0WFRtZzNYUnRHa1NBbFFib1JVZHo5dkI3ZTQ5V2VEOW1mejR0?=
 =?utf-8?B?ZTZLaHE0TDZmajlpK25pUkpZbnlZWVRyeDVhZjBvYUplQThXNE11OUNvTExT?=
 =?utf-8?B?SStiUThvRFE2elNlaU1HRTVLRHVHelRKUTNtQTI5THVjcFhScmx0SFdwUSt0?=
 =?utf-8?B?SUVpRW5iVU9saFV5YUJFell2K2s2eG9DS01Odm0yVy9ZbGJUOEVVLzV1alNs?=
 =?utf-8?B?YSs1N2thTWxLNUU1Ym5USXphV3VLZFJuOXVONHBib3dJWXJrK29QZDFlcjB6?=
 =?utf-8?B?aWJqVVNuWFlGZjNXQnl3RksrTFNDMUdVVm4zOHg2RkFrdVp5R0czblRaZ01L?=
 =?utf-8?B?dWkvTTZtTHpBR1JNOU4zeE9KanJ4OTdYb1BCY1hYV0R6QVRnRElwbmVhRGNH?=
 =?utf-8?B?U0EvNzJ5VnJGRElMdTZvYTFGVThTc1NldnJqRTF5QTZvMXFWQ3dkR29qL1F5?=
 =?utf-8?B?TzY5aURPMFViOElnLzJxWE9uNmtua251eDFCUktMT1lDWThtSmtMNTdyQjFV?=
 =?utf-8?B?OFhLZ3c2UEdEOGxPSm9PNWM4YUZ6bDRFUmZjemVhMXZxSWtNaFIyc1Joc0pl?=
 =?utf-8?B?Y3dXd1JWY3FGY2RaVVphM0o0d29zQXBPNkUrWjN0ZWpJMXFiWEg3dm9zOGZj?=
 =?utf-8?B?aGxWZ1ZEZE8xUnlKY2hDWUJyNGNnYXRNeWdaNU9aUVk5dGNtSzcrY2YxQ2hL?=
 =?utf-8?Q?HIRMovOcw26afPvI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ac2b8a6-5ca5-458e-33c3-08da3d958819
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 14:56:07.1308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwZ040PyA7QvwCrwcwQSz0FwfrbtH60IZz5hPsO+QwsIRC5wg1GuORRczpzj9M3qducRG3E/lIkBX5Nz2gxmDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3428
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/05/2022 13:09, Greg Kroah-Hartman wrote:

...

>> I am seeing a boot regression on tegra124-jetson-tk1 and reverting the above
>> commit is fixing the problem. This also appears to impact linux-4.14.y,
>> 4.19.y and 5.4.y.
>>
>> Test results for stable-v4.9:
>>      8 builds:	8 pass, 0 fail
>>      18 boots:	16 pass, 2 fail
>>      18 tests:	18 pass, 0 fail
>>
>> Linux version:	4.9.316-rc1-gbe4ec3e3faa1
>> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>>                  tegra210-p2371-2180, tegra30-cardhu-a04
>>
>> Boot failures:	tegra124-jetson-tk1
> 
> Odd.  This is also in 5.10.y, right?  No issues there?  Are we missing
> something?


Actually, the more I look at this, the more I see various intermittent 
reports with this and it is also impacting the mainline.

The problem is that the commit in question is causing a ton of messages 
to be printed a boot and this sometimes is causing the boot test to fail 
because the boot is taking too long. The console shows ...

[ 1233.327547] CPU0: Spectre BHB: using loop workaround
[ 1233.327795] CPU1: Spectre BHB: using loop workaround
[ 1233.328270] CPU1: Spectre BHB: using loop workaround
[ 1233.328700] CPU1: Spectre BHB: using loop workaround
[ 1233.355477] CPU2: Spectre BHB: using loop workaround
** 7 printk messages dropped **
[ 1233.366271] CPU0: Spectre BHB: using loop workaround
[ 1233.366580] CPU0: Spectre BHB: using loop workaround
[ 1233.366815] CPU1: Spectre BHB: using loop workaround
[ 1233.405475] CPU1: Spectre BHB: using loop workaround
[ 1233.405874] CPU0: Spectre BHB: using loop workaround
[ 1233.406041] CPU1: Spectre BHB: using loop workaround
** 1 printk messages dropped **

There is a similar report of this [0] and I believe that we need a 
similar fix for the above prints as well. I have reported this to Ard 
[1]. So I am not sure that these Spectre BHB patches are quite ready for 
stable.

Cheers
Jon

[0] 
https://lore.kernel.org/linux-arm-kernel/20220519161310.1489625-1-dmitry.osipenko@collabora.com/T/
[1] 
https://lore.kernel.org/linux-arm-kernel/a589f56d-a0e1-328d-e4be-9427342d46b8@nvidia.com/

-- 
nvpublic
