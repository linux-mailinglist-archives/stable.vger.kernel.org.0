Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2A7642988
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 14:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiLENit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 08:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLENir (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 08:38:47 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2059.outbound.protection.outlook.com [40.107.249.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEC3335;
        Mon,  5 Dec 2022 05:38:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIRJyTD+XodA3q5iyt5MsBHAv0bdHNM46Fwt+o71uxgdYAeDkf9hCoemheG9/csvteGsOf1wnNdHv/JCtBoLd0TB8F3dwsUFyAxxYWZJXZpXFIjjX4LExVAgvV5FN+jWSqjVOcjuirvcV8X755VQeDJSs1qH1SBuwSWsIxbhVQFSvtSbxhxzMHUC7CFdjIvICzAr8IrBzDC0K8GxoCNpU4AgPrXsti0xbChQpe+baMYSdiU+D9yNWPiL5exolWKtA1bq083UML0AmPInt2atXefdE2mFuxABsVb0cBNUtwbSa2xL65ulc55AKZE0eOZz7AEyay64E9EM53vv5CeY9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LEzbZZK8MfQ5/sZycuunXqTpDTMB06vwtnW5bfy00y4=;
 b=TaMzMq+W5nNZR5XGwXwEYTXxe5cxZ1VfmRX11S+dqgP4rOY0APaw922NK4qgs8AOZDme+7yUpH2NwF2aC4rgvgtdkXyESE3K/E0PsenJMmGBV7r33+1W/Fgv93i16tJ7tSxKvN1qoDO+Nxn3jnrg5DyyHSO3tt5DmCG1+aLDHp1MBpfKehg2Fa61JK4hbkCjqnYI8MPSPmH8grbCW8ouHJWeBwmgUM1E/x0Ha2/sZynITpwPJMKz7AVBl+g1CMGok2B6OvHL5QWt9zmsSfTvr4Ci7SAc0OHvYZKO3G6M3AdVT1HUsQGCvrFly6t2kXxP9e/O7R1Ac+zjArw2M5pZYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEzbZZK8MfQ5/sZycuunXqTpDTMB06vwtnW5bfy00y4=;
 b=IYbzvJBL0APp9YBRKC8OHXmmr4pFUy6dbTYZsHDG8fwNdfHm11MIyhs/ifCVgNR9Xq1crJn0jk3XMJLrYITkendjGYZ46kAKXvoGNokYFAmi+Vu/Fc8LuQpqv8dkG5UfYLet2+KXpWrNR8lmg+7G5rCpF77A4DE4esY/2bKH1rY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3919.eurprd08.prod.outlook.com (2603:10a6:803:c4::31)
 by PR3PR08MB5660.eurprd08.prod.outlook.com (2603:10a6:102:8d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 13:38:41 +0000
Received: from VI1PR08MB3919.eurprd08.prod.outlook.com
 ([fe80::fe5c:b195:a2ad:b19c]) by VI1PR08MB3919.eurprd08.prod.outlook.com
 ([fe80::fe5c:b195:a2ad:b19c%4]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 13:38:41 +0000
Message-ID: <a3bb50a1-ef19-25d4-f4d6-402174702fec@arm.com>
Date:   Mon, 5 Dec 2022 13:38:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] [v2] ata: ahci: fix enum constants for gcc-13
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-ide@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
References: <20221203105425.180641-1-arnd@kernel.org>
 <caa0e7a8-f222-b190-12a6-a36996affee2@opensource.wdc.com>
From:   Luis Machado <luis.machado@arm.com>
In-Reply-To: <caa0e7a8-f222-b190-12a6-a36996affee2@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO2P265CA0363.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::15) To VI1PR08MB3919.eurprd08.prod.outlook.com
 (2603:10a6:803:c4::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR08MB3919:EE_|PR3PR08MB5660:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c41a23e-ac78-47a3-bcd6-08dad6c60563
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JJT42lf6rAazGuJRxz9+BDPX1UBw3Nxq9DFGGkY0GBGnVNO78tMmRK3SvAHCKrw3pKLkQ8XwSr7whFlfyOxI4z6P+GrJ07K0jB8xCLY0SItQ87nJ1IB0VhkkcNrLoiciiqkm1/CWWz9GXLRawSqeHk8l7MXZwwFwgyReuM/clc43hT8jCIcXNPyaQKL+gwwntgWOICdR8ea+CIRMa6xWDLmEBf/BmCexOPdC3e9DymTOhGDCGFD4wfBxvfsREKOp56fu7BvSo2AIMKY9JzzQLJfa9UmI58i6NiIj3wQUJsH58fia73BavduhRDwZxXoHoKOdYaHl+NcwXhIFzB4xs+WUOivQ6e2MyB7vUr7+UvIvTPle4vRBnbY+Cox/qNClSjOVE59edRXwTUCB8cPrkhJp4zBkd1z79WZZqVsDowEI/PRKVUro8h41ocXzKJZ2zu/I3q9Et5RFF1RvNJzCR00bK7uc7FPPmJAR7VsiGvKR99XuOBoSgwGQSBANxQhrB88hhNdmQGKP9fYrC9nUn5Mh9cZ15CDyugo3MS+JtL7vfpRF+2NuhhnQrZnsqUv3SbeFU1r3UkRZJY6oemRwnQ50XPiDvnZ85ES7WDSVcUu/CYMfEVBIYPX0d+mIBKAu81rM2Mbs5yjc4B83B+/pDyUJDg0o06OK5cxs7fdJVJrytZ1kIDUbtykHyWygrDa79Hp8rvC91uDt3Db32nXCLV6sU+d/ig3BNqmALh+VVOEJPRfwFK8exc/bAgGIb/ACwmoK9yC8ozTEXkxiYN1rMptqzYCupR0/oo4vl/GZRWlemeJHDY1PN9j07gA2BYni
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3919.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199015)(38100700002)(66476007)(86362001)(6486002)(4326008)(31696002)(66556008)(66946007)(54906003)(8676002)(8936002)(110136005)(44832011)(41300700001)(316002)(30864003)(2906002)(186003)(2616005)(5660300002)(83380400001)(478600001)(966005)(6512007)(6506007)(53546011)(26005)(31686004)(66899015)(36756003)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUd3ZVV6clg1TjZJaTZNNlNkWFlUZVh1TXo2NVFGb3FWRkQvVzVTQjdMOE1u?=
 =?utf-8?B?SjBLeU82YW0rdXVFK2JXb2MzUnFjU3AvMUp6ckY3UGIvWjJxeGNvNE03dGNh?=
 =?utf-8?B?SDJjZzVTMS9IM3FZMThoZ0ljbkdvcUloWiszZEk5WEEvNlpHVGVCQys3Nk9j?=
 =?utf-8?B?M0lzY2N6OWN3Tzl4S2dMUHRFY0tZT3ZPSzlQV1pHdHE0eENBa0I0VEtlWm9y?=
 =?utf-8?B?M1huUnhHbXRTVGlFNjhScGs3WWM5T2NFZlNjN0hqbDFOOUdzUGNWWkk3REFP?=
 =?utf-8?B?Zlp0ZzdqMlRZNWFYbldGNzlQZlc0OG15TWRRV3JWR3JFQ1lHbllTRktDTk9p?=
 =?utf-8?B?OURySlQxelkvcW5pYXNvVmVrNlBFZ2UrMlI0QmtHcVIxVHk1d29qemI4RmNZ?=
 =?utf-8?B?MXZya2hINzlyS1ZuQ3BJaHdwZnNFQ0ttYlUraU1JeEpWYWhlbDU4SEdBNDY2?=
 =?utf-8?B?SkV1SzJwMVpQN1NjcXMvdFFBSWNONUhGMWczQU85WWtDRDROQXJJVHBTZlha?=
 =?utf-8?B?VVNTTzFZWXBVSHNDbU9ZVFJJYVVJWjk1alRsTmRLUUdXRWR1bm5iQjdqL0dI?=
 =?utf-8?B?SEswVG9HUk1YMXhLdVVYWlhhV3J2bmJsUmtaUW8waFlVTTloU3BxaVNESTNC?=
 =?utf-8?B?MXYxanhrY3BZQmtSSTFhZ29FRE1KVDZCazBUbGUvZG5hSE5JSWJjOHFEb0ls?=
 =?utf-8?B?N0p5bkNGZVFhblpVTnRjUU11d0s4QW1IM3dyeDVVSnZyR2FTcGswb2grRVQ3?=
 =?utf-8?B?VitrUk9Kd3o4NHVSWlZSeWRYWHcxNnJLUFNpZFhvbTV6dkJSWTRSQjhONlJj?=
 =?utf-8?B?SjJiZzBtWmJ6UDJqbHhScE40QVZmejJOQjh5UklsZGtjcStsRk5WYWVZWDJN?=
 =?utf-8?B?cWNZV1NINWRVLzFETGhPRmJHb2R0NCtCU05xRGxNcTBKaEY0VFIzY3dvREdp?=
 =?utf-8?B?SmZjcTdBVXRWR1BicWh6VzZHTjlJZk1vRWdwY01QSzNWczcvNDM4aVFBNmcv?=
 =?utf-8?B?SFBYbDROUnVEY3p2ZjNHMFNXd3hUQ0thQjROengzK2kxc2h4d21rUkRCMWxq?=
 =?utf-8?B?eHNxV095MThLdDRFc1Z5aGwzVGdtanE1aTJxR2N2SFNldUs1aHVnN2hVNGM1?=
 =?utf-8?B?NEg3MnlrSGRWVzVHYS8xV2JEQVBQbmdUN1FQZDhSN1BoMzFnNW5zdkZuSWZw?=
 =?utf-8?B?eU1SUm80OFByczBQbFhoTks1L1hzU2QweVpuaHVCdm5vaU5rdTFaMEc3VDRw?=
 =?utf-8?B?NXVhRWpHK3J2bzhKcVdkWjArWUJHa1UzVTBPSXp3NmorazFYZk1RUTRJL2Jo?=
 =?utf-8?B?QjhNbHlRWXdBRDB6NUdBbFZLZkFkNzlZTGdXd09kQ0xjc0U1OS9MV0dVQ0Vs?=
 =?utf-8?B?WXlKM2FvMThZblkvQ0xVSGpuY2N4K1JMTG5QM2FFc0JkUjlZRFlPSGZZN0Y4?=
 =?utf-8?B?TjZYeTMzS3BZWjdnRHQrV085aFFvRXRQNUc5UzlLTTY1LzY4alJvcE1FYThw?=
 =?utf-8?B?NzVvOFI5eTh2L0d1QTdWblVpQ21JSVRuUGN0WDZOa3l2NFo3ZzRBT240TllN?=
 =?utf-8?B?NXY5bXROZnoycG00d1cydXB3K0xkRFpscmx1OWNveWN4a3E0Q2Q4RXIrVCt4?=
 =?utf-8?B?aWJzNVhkalV5RjZwaElaQzJYNTl1NTZEMUY0ZlBSdHpEaEZoVE53azZsUGFv?=
 =?utf-8?B?RUFaVnE3L2VRcHFTbjY1aGRRMFdkUzBQZ3lRcVhEbEw2T0ExTzRZa1lPWXFW?=
 =?utf-8?B?ZTdXcUMwR0tPaXpqZFhod3hoMXlWZkZTN3V3eXRUVThKN25GdE4wamNKditD?=
 =?utf-8?B?OTFwWGE2eUh4T21GbkcrTkY4bmozcWZJN0RYSVJ1TVJQQUcwUVFCYzVqZm5w?=
 =?utf-8?B?RUQ0Qk9kTTVNRUhjMHNCcjN3WG1qK2xnQ2FOM2tCQmpabC93cFkxa2ttd3o3?=
 =?utf-8?B?YUhFWmRjYXBJeHMwaTNMYlpIUWV0dHBGckk1UC84cVI5cHFaVmU4THpXc2NV?=
 =?utf-8?B?bUYzbm1HRjlIei83eVJ4SVpOL0FpY2Zjcjh3ZWhvdXUzcmFNbDZ1SDJrSkJH?=
 =?utf-8?B?Y3dlRlR1SWNNdkRIZ21XWTBuY1k0d3RxUGlBSDM1dUFZRlhHUnRlR1pHUU50?=
 =?utf-8?Q?lSssdHHX47c4WlhQWycE5e1J2?=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c41a23e-ac78-47a3-bcd6-08dad6c60563
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3919.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 13:38:41.1918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvnNS1LPxd8F/65a2aGlFlryxGPqEZ6oP8iMGifsvzSC4hDlnAUPLPjnvNKTXOhMXasqZSTNPm+OQTl/R9/EmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5660
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/5/22 13:33, Damien Le Moal wrote:
> On 12/3/22 19:54, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> gcc-13 slightly changes the type of constant expressions that are define=
d
>> in an enum, which triggers a compile time sanity check in libata:
>>
>> linux/drivers/ata/libahci.c: In function 'ahci_led_store':
>> linux/include/linux/compiler_types.h:357:45: error: call to '__compileti=
me_assert_302' declared with attribute error: BUILD_BUG_ON failed: sizeof(_=
s) > sizeof(long)
>> 357 | _compiletime_assert(condition, msg, __compiletime_assert_, __COUNT=
ER__)
>>
>> The new behavior is that sizeof() returns the same value for the
>> constant as it does for the enum type, which is generally more sensible
>> and consistent.
>>
>> The problem in libata is that it contains a single enum definition for
>> lots of unrelated constants, some of which are large positive (unsigned)
>> integers like 0xffffffff, while others like (1<<31) are interpreted as
>> negative integers, and this forces the enum type to become 64 bit wide
>> even though most constants would still fit into a signed 32-bit 'int'.
>>
>> Fix this by changing the entire enum definition to use BIT(x) in place
>> of (1<<x), which results in all values being seen as 'unsigned' and
>> fitting into an unsigned 32-bit type.
>>
>> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D107917
>> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D107405
>> Reported-by: Luis Machado <luis.machado@arm.com>
>> Cc: linux-ide@vger.kernel.org
>> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> Cc: stable@vger.kernel.org
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Looks all good to me. One nit: for the PORT_CMD_ICC_XXX definitions, we
> could use GENMASK() to be consistant with the use of BIT(), no ? Not a bi=
g
> deal though.
>
>> ---
>> Luis, I don't have gcc-13 installed on the machine I used for
>> creating this patch, can you give this a spin and see if it
>> addresses the build failure?
>
> Luis, if you test/review, please send Tested-by/Reviewed-by tags !
>

Sorry. Got sidetracked. I'll get the test going.

>>
>> v2 changes:
>>   - fix typos in changelog
>>   - change PORT_CMD_ICC_* constants as well
>>   - include linux/bits.h
>> ---
>>   drivers/ata/ahci.h | 245 +++++++++++++++++++++++----------------------
>>   1 file changed, 123 insertions(+), 122 deletions(-)
>>
>> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
>> index 7add8e79912b..ff8e6ae1c636 100644
>> --- a/drivers/ata/ahci.h
>> +++ b/drivers/ata/ahci.h
>> @@ -24,6 +24,7 @@
>>   #include <linux/libata.h>
>>   #include <linux/phy/phy.h>
>>   #include <linux/regulator/consumer.h>
>> +#include <linux/bits.h>
>>
>>   /* Enclosure Management Control */
>>   #define EM_CTRL_MSG_TYPE              0x000f0000
>> @@ -53,12 +54,12 @@ enum {
>>      AHCI_PORT_PRIV_FBS_DMA_SZ       =3D AHCI_CMD_SLOT_SZ +
>>                                        AHCI_CMD_TBL_AR_SZ +
>>                                        (AHCI_RX_FIS_SZ * 16),
>> -    AHCI_IRQ_ON_SG          =3D (1 << 31),
>> -    AHCI_CMD_ATAPI          =3D (1 << 5),
>> -    AHCI_CMD_WRITE          =3D (1 << 6),
>> -    AHCI_CMD_PREFETCH       =3D (1 << 7),
>> -    AHCI_CMD_RESET          =3D (1 << 8),
>> -    AHCI_CMD_CLR_BUSY       =3D (1 << 10),
>> +    AHCI_IRQ_ON_SG          =3D BIT(31),
>> +    AHCI_CMD_ATAPI          =3D BIT(5),
>> +    AHCI_CMD_WRITE          =3D BIT(6),
>> +    AHCI_CMD_PREFETCH       =3D BIT(7),
>> +    AHCI_CMD_RESET          =3D BIT(8),
>> +    AHCI_CMD_CLR_BUSY       =3D BIT(10),
>>
>>      RX_FIS_PIO_SETUP        =3D 0x20, /* offset of PIO Setup FIS data *=
/
>>      RX_FIS_D2H_REG          =3D 0x40, /* offset of D2H Register FIS dat=
a */
>> @@ -76,37 +77,37 @@ enum {
>>      HOST_CAP2               =3D 0x24, /* host capabilities, extended */
>>
>>      /* HOST_CTL bits */
>> -    HOST_RESET              =3D (1 << 0),  /* reset controller; self-cl=
ear */
>> -    HOST_IRQ_EN             =3D (1 << 1),  /* global IRQ enable */
>> -    HOST_MRSM               =3D (1 << 2),  /* MSI Revert to Single Mess=
age */
>> -    HOST_AHCI_EN            =3D (1 << 31), /* AHCI enabled */
>> +    HOST_RESET              =3D BIT(0),  /* reset controller; self-clea=
r */
>> +    HOST_IRQ_EN             =3D BIT(1),  /* global IRQ enable */
>> +    HOST_MRSM               =3D BIT(2),  /* MSI Revert to Single Messag=
e */
>> +    HOST_AHCI_EN            =3D BIT(31), /* AHCI enabled */
>>
>>      /* HOST_CAP bits */
>> -    HOST_CAP_SXS            =3D (1 << 5),  /* Supports External SATA */
>> -    HOST_CAP_EMS            =3D (1 << 6),  /* Enclosure Management supp=
ort */
>> -    HOST_CAP_CCC            =3D (1 << 7),  /* Command Completion Coales=
cing */
>> -    HOST_CAP_PART           =3D (1 << 13), /* Partial state capable */
>> -    HOST_CAP_SSC            =3D (1 << 14), /* Slumber state capable */
>> -    HOST_CAP_PIO_MULTI      =3D (1 << 15), /* PIO multiple DRQ support =
*/
>> -    HOST_CAP_FBS            =3D (1 << 16), /* FIS-based switching suppo=
rt */
>> -    HOST_CAP_PMP            =3D (1 << 17), /* Port Multiplier support *=
/
>> -    HOST_CAP_ONLY           =3D (1 << 18), /* Supports AHCI mode only *=
/
>> -    HOST_CAP_CLO            =3D (1 << 24), /* Command List Override sup=
port */
>> -    HOST_CAP_LED            =3D (1 << 25), /* Supports activity LED */
>> -    HOST_CAP_ALPM           =3D (1 << 26), /* Aggressive Link PM suppor=
t */
>> -    HOST_CAP_SSS            =3D (1 << 27), /* Staggered Spin-up */
>> -    HOST_CAP_MPS            =3D (1 << 28), /* Mechanical presence switc=
h */
>> -    HOST_CAP_SNTF           =3D (1 << 29), /* SNotification register */
>> -    HOST_CAP_NCQ            =3D (1 << 30), /* Native Command Queueing *=
/
>> -    HOST_CAP_64             =3D (1 << 31), /* PCI DAC (64-bit DMA) supp=
ort */
>> +    HOST_CAP_SXS            =3D BIT(5),  /* Supports External SATA */
>> +    HOST_CAP_EMS            =3D BIT(6),  /* Enclosure Management suppor=
t */
>> +    HOST_CAP_CCC            =3D BIT(7),  /* Command Completion Coalesci=
ng */
>> +    HOST_CAP_PART           =3D BIT(13), /* Partial state capable */
>> +    HOST_CAP_SSC            =3D BIT(14), /* Slumber state capable */
>> +    HOST_CAP_PIO_MULTI      =3D BIT(15), /* PIO multiple DRQ support */
>> +    HOST_CAP_FBS            =3D BIT(16), /* FIS-based switching support=
 */
>> +    HOST_CAP_PMP            =3D BIT(17), /* Port Multiplier support */
>> +    HOST_CAP_ONLY           =3D BIT(18), /* Supports AHCI mode only */
>> +    HOST_CAP_CLO            =3D BIT(24), /* Command List Override suppo=
rt */
>> +    HOST_CAP_LED            =3D BIT(25), /* Supports activity LED */
>> +    HOST_CAP_ALPM           =3D BIT(26), /* Aggressive Link PM support =
*/
>> +    HOST_CAP_SSS            =3D BIT(27), /* Staggered Spin-up */
>> +    HOST_CAP_MPS            =3D BIT(28), /* Mechanical presence switch =
*/
>> +    HOST_CAP_SNTF           =3D BIT(29), /* SNotification register */
>> +    HOST_CAP_NCQ            =3D BIT(30), /* Native Command Queueing */
>> +    HOST_CAP_64             =3D BIT(31), /* PCI DAC (64-bit DMA) suppor=
t */
>>
>>      /* HOST_CAP2 bits */
>> -    HOST_CAP2_BOH           =3D (1 << 0),  /* BIOS/OS handoff supported=
 */
>> -    HOST_CAP2_NVMHCI        =3D (1 << 1),  /* NVMHCI supported */
>> -    HOST_CAP2_APST          =3D (1 << 2),  /* Automatic partial to slum=
ber */
>> -    HOST_CAP2_SDS           =3D (1 << 3),  /* Support device sleep */
>> -    HOST_CAP2_SADM          =3D (1 << 4),  /* Support aggressive DevSlp=
 */
>> -    HOST_CAP2_DESO          =3D (1 << 5),  /* DevSlp from slumber only =
*/
>> +    HOST_CAP2_BOH           =3D BIT(0),  /* BIOS/OS handoff supported *=
/
>> +    HOST_CAP2_NVMHCI        =3D BIT(1),  /* NVMHCI supported */
>> +    HOST_CAP2_APST          =3D BIT(2),  /* Automatic partial to slumbe=
r */
>> +    HOST_CAP2_SDS           =3D BIT(3),  /* Support device sleep */
>> +    HOST_CAP2_SADM          =3D BIT(4),  /* Support aggressive DevSlp *=
/
>> +    HOST_CAP2_DESO          =3D BIT(5),  /* DevSlp from slumber only */
>>
>>      /* registers for each SATA port */
>>      PORT_LST_ADDR           =3D 0x00, /* command list DMA addr */
>> @@ -128,24 +129,24 @@ enum {
>>      PORT_DEVSLP             =3D 0x44, /* device sleep */
>>
>>      /* PORT_IRQ_{STAT,MASK} bits */
>> -    PORT_IRQ_COLD_PRES      =3D (1 << 31), /* cold presence detect */
>> -    PORT_IRQ_TF_ERR         =3D (1 << 30), /* task file error */
>> -    PORT_IRQ_HBUS_ERR       =3D (1 << 29), /* host bus fatal error */
>> -    PORT_IRQ_HBUS_DATA_ERR  =3D (1 << 28), /* host bus data error */
>> -    PORT_IRQ_IF_ERR         =3D (1 << 27), /* interface fatal error */
>> -    PORT_IRQ_IF_NONFATAL    =3D (1 << 26), /* interface non-fatal error=
 */
>> -    PORT_IRQ_OVERFLOW       =3D (1 << 24), /* xfer exhausted available =
S/G */
>> -    PORT_IRQ_BAD_PMP        =3D (1 << 23), /* incorrect port multiplier=
 */
>> -
>> -    PORT_IRQ_PHYRDY         =3D (1 << 22), /* PhyRdy changed */
>> -    PORT_IRQ_DMPS           =3D (1 << 7), /* mechanical presence status=
 */
>> -    PORT_IRQ_CONNECT        =3D (1 << 6), /* port connect change status=
 */
>> -    PORT_IRQ_SG_DONE        =3D (1 << 5), /* descriptor processed */
>> -    PORT_IRQ_UNK_FIS        =3D (1 << 4), /* unknown FIS rx'd */
>> -    PORT_IRQ_SDB_FIS        =3D (1 << 3), /* Set Device Bits FIS rx'd *=
/
>> -    PORT_IRQ_DMAS_FIS       =3D (1 << 2), /* DMA Setup FIS rx'd */
>> -    PORT_IRQ_PIOS_FIS       =3D (1 << 1), /* PIO Setup FIS rx'd */
>> -    PORT_IRQ_D2H_REG_FIS    =3D (1 << 0), /* D2H Register FIS rx'd */
>> +    PORT_IRQ_COLD_PRES      =3D BIT(31), /* cold presence detect */
>> +    PORT_IRQ_TF_ERR         =3D BIT(30), /* task file error */
>> +    PORT_IRQ_HBUS_ERR       =3D BIT(29), /* host bus fatal error */
>> +    PORT_IRQ_HBUS_DATA_ERR  =3D BIT(28), /* host bus data error */
>> +    PORT_IRQ_IF_ERR         =3D BIT(27), /* interface fatal error */
>> +    PORT_IRQ_IF_NONFATAL    =3D BIT(26), /* interface non-fatal error *=
/
>> +    PORT_IRQ_OVERFLOW       =3D BIT(24), /* xfer exhausted available S/=
G */
>> +    PORT_IRQ_BAD_PMP        =3D BIT(23), /* incorrect port multiplier *=
/
>> +
>> +    PORT_IRQ_PHYRDY         =3D BIT(22), /* PhyRdy changed */
>> +    PORT_IRQ_DMPS           =3D BIT(7),  /* mechanical presence status =
*/
>> +    PORT_IRQ_CONNECT        =3D BIT(6),  /* port connect change status =
*/
>> +    PORT_IRQ_SG_DONE        =3D BIT(5),  /* descriptor processed */
>> +    PORT_IRQ_UNK_FIS        =3D BIT(4),  /* unknown FIS rx'd */
>> +    PORT_IRQ_SDB_FIS        =3D BIT(3),  /* Set Device Bits FIS rx'd */
>> +    PORT_IRQ_DMAS_FIS       =3D BIT(2),  /* DMA Setup FIS rx'd */
>> +    PORT_IRQ_PIOS_FIS       =3D BIT(1),  /* PIO Setup FIS rx'd */
>> +    PORT_IRQ_D2H_REG_FIS    =3D BIT(0),  /* D2H Register FIS rx'd */
>>
>>      PORT_IRQ_FREEZE         =3D PORT_IRQ_HBUS_ERR |
>>                                PORT_IRQ_IF_ERR |
>> @@ -161,27 +162,27 @@ enum {
>>                                PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
>>
>>      /* PORT_CMD bits */
>> -    PORT_CMD_ASP            =3D (1 << 27), /* Aggressive Slumber/Partia=
l */
>> -    PORT_CMD_ALPE           =3D (1 << 26), /* Aggressive Link PM enable=
 */
>> -    PORT_CMD_ATAPI          =3D (1 << 24), /* Device is ATAPI */
>> -    PORT_CMD_FBSCP          =3D (1 << 22), /* FBS Capable Port */
>> -    PORT_CMD_ESP            =3D (1 << 21), /* External Sata Port */
>> -    PORT_CMD_CPD            =3D (1 << 20), /* Cold Presence Detection *=
/
>> -    PORT_CMD_MPSP           =3D (1 << 19), /* Mechanical Presence Switc=
h */
>> -    PORT_CMD_HPCP           =3D (1 << 18), /* HotPlug Capable Port */
>> -    PORT_CMD_PMP            =3D (1 << 17), /* PMP attached */
>> -    PORT_CMD_LIST_ON        =3D (1 << 15), /* cmd list DMA engine runni=
ng */
>> -    PORT_CMD_FIS_ON         =3D (1 << 14), /* FIS DMA engine running */
>> -    PORT_CMD_FIS_RX         =3D (1 << 4), /* Enable FIS receive DMA eng=
ine */
>> -    PORT_CMD_CLO            =3D (1 << 3), /* Command list override */
>> -    PORT_CMD_POWER_ON       =3D (1 << 2), /* Power up device */
>> -    PORT_CMD_SPIN_UP        =3D (1 << 1), /* Spin up device */
>> -    PORT_CMD_START          =3D (1 << 0), /* Enable port DMA engine */
>> -
>> -    PORT_CMD_ICC_MASK       =3D (0xf << 28), /* i/f ICC state mask */
>> -    PORT_CMD_ICC_ACTIVE     =3D (0x1 << 28), /* Put i/f in active state=
 */
>> -    PORT_CMD_ICC_PARTIAL    =3D (0x2 << 28), /* Put i/f in partial stat=
e */
>> -    PORT_CMD_ICC_SLUMBER    =3D (0x6 << 28), /* Put i/f in slumber stat=
e */
>> +    PORT_CMD_ASP            =3D BIT(27), /* Aggressive Slumber/Partial =
*/
>> +    PORT_CMD_ALPE           =3D BIT(26), /* Aggressive Link PM enable *=
/
>> +    PORT_CMD_ATAPI          =3D BIT(24), /* Device is ATAPI */
>> +    PORT_CMD_FBSCP          =3D BIT(22), /* FBS Capable Port */
>> +    PORT_CMD_ESP            =3D BIT(21), /* External Sata Port */
>> +    PORT_CMD_CPD            =3D BIT(20), /* Cold Presence Detection */
>> +    PORT_CMD_MPSP           =3D BIT(19), /* Mechanical Presence Switch =
*/
>> +    PORT_CMD_HPCP           =3D BIT(18), /* HotPlug Capable Port */
>> +    PORT_CMD_PMP            =3D BIT(17), /* PMP attached */
>> +    PORT_CMD_LIST_ON        =3D BIT(15), /* cmd list DMA engine running=
 */
>> +    PORT_CMD_FIS_ON         =3D BIT(14), /* FIS DMA engine running */
>> +    PORT_CMD_FIS_RX         =3D BIT(4),  /* Enable FIS receive DMA engi=
ne */
>> +    PORT_CMD_CLO            =3D BIT(3),  /* Command list override */
>> +    PORT_CMD_POWER_ON       =3D BIT(2),  /* Power up device */
>> +    PORT_CMD_SPIN_UP        =3D BIT(1),  /* Spin up device */
>> +    PORT_CMD_START          =3D BIT(0),  /* Enable port DMA engine */
>> +
>> +    PORT_CMD_ICC_MASK       =3D (0xfu << 28), /* i/f ICC state mask */
>> +    PORT_CMD_ICC_ACTIVE     =3D (0x1u << 28), /* Put i/f in active stat=
e */
>> +    PORT_CMD_ICC_PARTIAL    =3D (0x2u << 28), /* Put i/f in partial sta=
te */
>> +    PORT_CMD_ICC_SLUMBER    =3D (0x6u << 28), /* Put i/f in slumber sta=
te */
>>
>>      /* PORT_CMD capabilities mask */
>>      PORT_CMD_CAP            =3D PORT_CMD_HPCP | PORT_CMD_MPSP |
>> @@ -192,9 +193,9 @@ enum {
>>      PORT_FBS_ADO_OFFSET     =3D 12, /* FBS active dev optimization offs=
et */
>>      PORT_FBS_DEV_OFFSET     =3D 8,  /* FBS device to issue offset */
>>      PORT_FBS_DEV_MASK       =3D (0xf << PORT_FBS_DEV_OFFSET),  /* FBS.D=
EV */
>> -    PORT_FBS_SDE            =3D (1 << 2), /* FBS single device error */
>> -    PORT_FBS_DEC            =3D (1 << 1), /* FBS device error clear */
>> -    PORT_FBS_EN             =3D (1 << 0), /* Enable FBS */
>> +    PORT_FBS_SDE            =3D BIT(2), /* FBS single device error */
>> +    PORT_FBS_DEC            =3D BIT(1), /* FBS device error clear */
>> +    PORT_FBS_EN             =3D BIT(0), /* Enable FBS */
>>
>>      /* PORT_DEVSLP bits */
>>      PORT_DEVSLP_DM_OFFSET   =3D 25,             /* DITO multiplier offs=
et */
>> @@ -202,50 +203,50 @@ enum {
>>      PORT_DEVSLP_DITO_OFFSET =3D 15,             /* DITO offset */
>>      PORT_DEVSLP_MDAT_OFFSET =3D 10,             /* Minimum assertion ti=
me */
>>      PORT_DEVSLP_DETO_OFFSET =3D 2,              /* DevSlp exit timeout =
*/
>> -    PORT_DEVSLP_DSP         =3D (1 << 1),       /* DevSlp present */
>> -    PORT_DEVSLP_ADSE        =3D (1 << 0),       /* Aggressive DevSlp en=
able */
>> +    PORT_DEVSLP_DSP         =3D BIT(1),         /* DevSlp present */
>> +    PORT_DEVSLP_ADSE        =3D BIT(0),         /* Aggressive DevSlp en=
able */
>>
>>      /* hpriv->flags bits */
>>
>>   #define AHCI_HFLAGS(flags)         .private_data   =3D (void *)(flags)
>>
>> -    AHCI_HFLAG_NO_NCQ               =3D (1 << 0),
>> -    AHCI_HFLAG_IGN_IRQ_IF_ERR       =3D (1 << 1), /* ignore IRQ_IF_ERR =
*/
>> -    AHCI_HFLAG_IGN_SERR_INTERNAL    =3D (1 << 2), /* ignore SERR_INTERN=
AL */
>> -    AHCI_HFLAG_32BIT_ONLY           =3D (1 << 3), /* force 32bit */
>> -    AHCI_HFLAG_MV_PATA              =3D (1 << 4), /* PATA port */
>> -    AHCI_HFLAG_NO_MSI               =3D (1 << 5), /* no PCI MSI */
>> -    AHCI_HFLAG_NO_PMP               =3D (1 << 6), /* no PMP */
>> -    AHCI_HFLAG_SECT255              =3D (1 << 8), /* max 255 sectors */
>> -    AHCI_HFLAG_YES_NCQ              =3D (1 << 9), /* force NCQ cap on *=
/
>> -    AHCI_HFLAG_NO_SUSPEND           =3D (1 << 10), /* don't suspend */
>> -    AHCI_HFLAG_SRST_TOUT_IS_OFFLINE =3D (1 << 11), /* treat SRST timeou=
t as
>> -                                                    link offline */
>> -    AHCI_HFLAG_NO_SNTF              =3D (1 << 12), /* no sntf */
>> -    AHCI_HFLAG_NO_FPDMA_AA          =3D (1 << 13), /* no FPDMA AA */
>> -    AHCI_HFLAG_YES_FBS              =3D (1 << 14), /* force FBS cap on =
*/
>> -    AHCI_HFLAG_DELAY_ENGINE         =3D (1 << 15), /* do not start engi=
ne on
>> -                                                    port start (wait un=
til
>> -                                                    error-handling stag=
e) */
>> -    AHCI_HFLAG_NO_DEVSLP            =3D (1 << 17), /* no device sleep *=
/
>> -    AHCI_HFLAG_NO_FBS               =3D (1 << 18), /* no FBS */
>> +    AHCI_HFLAG_NO_NCQ               =3D BIT(0),
>> +    AHCI_HFLAG_IGN_IRQ_IF_ERR       =3D BIT(1), /* ignore IRQ_IF_ERR */
>> +    AHCI_HFLAG_IGN_SERR_INTERNAL    =3D BIT(2), /* ignore SERR_INTERNAL=
 */
>> +    AHCI_HFLAG_32BIT_ONLY           =3D BIT(3), /* force 32bit */
>> +    AHCI_HFLAG_MV_PATA              =3D BIT(4), /* PATA port */
>> +    AHCI_HFLAG_NO_MSI               =3D BIT(5), /* no PCI MSI */
>> +    AHCI_HFLAG_NO_PMP               =3D BIT(6), /* no PMP */
>> +    AHCI_HFLAG_SECT255              =3D BIT(8), /* max 255 sectors */
>> +    AHCI_HFLAG_YES_NCQ              =3D BIT(9), /* force NCQ cap on */
>> +    AHCI_HFLAG_NO_SUSPEND           =3D BIT(10), /* don't suspend */
>> +    AHCI_HFLAG_SRST_TOUT_IS_OFFLINE =3D BIT(11), /* treat SRST timeout =
as
>> +                                                  link offline */
>> +    AHCI_HFLAG_NO_SNTF              =3D BIT(12), /* no sntf */
>> +    AHCI_HFLAG_NO_FPDMA_AA          =3D BIT(13), /* no FPDMA AA */
>> +    AHCI_HFLAG_YES_FBS              =3D BIT(14), /* force FBS cap on */
>> +    AHCI_HFLAG_DELAY_ENGINE         =3D BIT(15), /* do not start engine=
 on
>> +                                                  port start (wait unti=
l
>> +                                                  error-handling stage)=
 */
>> +    AHCI_HFLAG_NO_DEVSLP            =3D BIT(17), /* no device sleep */
>> +    AHCI_HFLAG_NO_FBS               =3D BIT(18), /* no FBS */
>>
>>   #ifdef CONFIG_PCI_MSI
>> -    AHCI_HFLAG_MULTI_MSI            =3D (1 << 20), /* per-port MSI(-X) =
*/
>> +    AHCI_HFLAG_MULTI_MSI            =3D BIT(20), /* per-port MSI(-X) */
>>   #else
>>      /* compile out MSI infrastructure */
>>      AHCI_HFLAG_MULTI_MSI            =3D 0,
>>   #endif
>> -    AHCI_HFLAG_WAKE_BEFORE_STOP     =3D (1 << 22), /* wake before DMA s=
top */
>> -    AHCI_HFLAG_YES_ALPM             =3D (1 << 23), /* force ALPM cap on=
 */
>> -    AHCI_HFLAG_NO_WRITE_TO_RO       =3D (1 << 24), /* don't write to re=
ad
>> -                                                    only registers */
>> -    AHCI_HFLAG_USE_LPM_POLICY       =3D (1 << 25), /* chipset that shou=
ld use
>> -                                                    SATA_MOBILE_LPM_POL=
ICY
>> -                                                    as default lpm_poli=
cy */
>> -    AHCI_HFLAG_SUSPEND_PHYS         =3D (1 << 26), /* handle PHYs durin=
g
>> -                                                    suspend/resume */
>> -    AHCI_HFLAG_NO_SXS               =3D (1 << 28), /* SXS not supported=
 */
>> +    AHCI_HFLAG_WAKE_BEFORE_STOP     =3D BIT(22), /* wake before DMA sto=
p */
>> +    AHCI_HFLAG_YES_ALPM             =3D BIT(23), /* force ALPM cap on *=
/
>> +    AHCI_HFLAG_NO_WRITE_TO_RO       =3D BIT(24), /* don't write to read
>> +                                                  only registers */
>> +    AHCI_HFLAG_USE_LPM_POLICY       =3D BIT(25), /* chipset that should=
 use
>> +                                                  SATA_MOBILE_LPM_POLIC=
Y
>> +                                                  as default lpm_policy=
 */
>> +    AHCI_HFLAG_SUSPEND_PHYS         =3D BIT(26), /* handle PHYs during
>> +                                                  suspend/resume */
>> +    AHCI_HFLAG_NO_SXS               =3D BIT(28), /* SXS not supported *=
/
>>
>>      /* ap->flags bits */
>>
>> @@ -261,22 +262,22 @@ enum {
>>      EM_MAX_RETRY                    =3D 5,
>>
>>      /* em_ctl bits */
>> -    EM_CTL_RST              =3D (1 << 9), /* Reset */
>> -    EM_CTL_TM               =3D (1 << 8), /* Transmit Message */
>> -    EM_CTL_MR               =3D (1 << 0), /* Message Received */
>> -    EM_CTL_ALHD             =3D (1 << 26), /* Activity LED */
>> -    EM_CTL_XMT              =3D (1 << 25), /* Transmit Only */
>> -    EM_CTL_SMB              =3D (1 << 24), /* Single Message Buffer */
>> -    EM_CTL_SGPIO            =3D (1 << 19), /* SGPIO messages supported =
*/
>> -    EM_CTL_SES              =3D (1 << 18), /* SES-2 messages supported =
*/
>> -    EM_CTL_SAFTE            =3D (1 << 17), /* SAF-TE messages supported=
 */
>> -    EM_CTL_LED              =3D (1 << 16), /* LED messages supported */
>> +    EM_CTL_RST              =3D BIT(9), /* Reset */
>> +    EM_CTL_TM               =3D BIT(8), /* Transmit Message */
>> +    EM_CTL_MR               =3D BIT(0), /* Message Received */
>> +    EM_CTL_ALHD             =3D BIT(26), /* Activity LED */
>> +    EM_CTL_XMT              =3D BIT(25), /* Transmit Only */
>> +    EM_CTL_SMB              =3D BIT(24), /* Single Message Buffer */
>> +    EM_CTL_SGPIO            =3D BIT(19), /* SGPIO messages supported */
>> +    EM_CTL_SES              =3D BIT(18), /* SES-2 messages supported */
>> +    EM_CTL_SAFTE            =3D BIT(17), /* SAF-TE messages supported *=
/
>> +    EM_CTL_LED              =3D BIT(16), /* LED messages supported */
>>
>>      /* em message type */
>> -    EM_MSG_TYPE_LED         =3D (1 << 0), /* LED */
>> -    EM_MSG_TYPE_SAFTE       =3D (1 << 1), /* SAF-TE */
>> -    EM_MSG_TYPE_SES2        =3D (1 << 2), /* SES-2 */
>> -    EM_MSG_TYPE_SGPIO       =3D (1 << 3), /* SGPIO */
>> +    EM_MSG_TYPE_LED         =3D BIT(0), /* LED */
>> +    EM_MSG_TYPE_SAFTE       =3D BIT(1), /* SAF-TE */
>> +    EM_MSG_TYPE_SES2        =3D BIT(2), /* SES-2 */
>> +    EM_MSG_TYPE_SGPIO       =3D BIT(3), /* SGPIO */
>>   };
>>
>>   struct ahci_cmd_hdr {
>

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
