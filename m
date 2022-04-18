Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAFF504BB4
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 06:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbiDREhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 00:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbiDREhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 00:37:31 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB7C1E4;
        Sun, 17 Apr 2022 21:34:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBJYkrt0n390gRUAwrlfSsAV7scj7LjW5UYULkEALVhzBtDr4HDEkJnYSzfJLRVaayeLP2loS+JsEfkTUhGSxukEexixs+2cpHf9JVRxUyaQudsXZ7neCe6mwQ1ijYdmvgXXXukRtUJ4tajk23OGleUf1sEpWmLrime/a4K4gXCWp/glVg3pJCRjiBRPGu9kbBCC4/6dKB4+AVzLr4hrTJwGCjqq9KbfAlC6p+CwLAhE/5vQmRTVAQpqh3wfzxbzhKOJPn7X57LdrWlbOy+GAMOLums8jWc3NswVQ0eOlkPUEdimx4TUvB6sd9vaVgycnQA3DnUD7X3tvNFymNWFuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8P/AYBRLoalnAjLHo7FnlM+I5uNO45ldDvTjFMESoY=;
 b=H12jzDg9DZShhw5MFE6+rBzp/zzp0doOg+kbnBnCRB+fo6jk6RZz5lkpxGtxl4+nMsEhcKhfyn0SLp60sLvsm3sMYpakyIhz2+QWUfwjTB7jyuV4XwrM24x2Sr3E5TtD/U+2F8ytnzQrrbocN37VuzNlwjFbBk53STOFY/JOYItqz3LPLzTcWlVLTmzfr0vkQJ6OcJXTZTzPyqXv6CARFm2SeScvreZcisIKw5j1h2Q3r75soVTWMnWpwIj/J5dKV/k51RMycFdGqNS1vgafHjTWqbBZbdHwlC1+3pLWR30JDzaKDsPJC5ZiZs44oQOseMEDvfEwEMow3y+TaBrRwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8P/AYBRLoalnAjLHo7FnlM+I5uNO45ldDvTjFMESoY=;
 b=t4ymJWaxk+VWqUbBntktuHZAwJZt3lJ/BzVRxkf0CCbb+f0ZSQXZGrxi/1nhRF+HQxyZaVq1PCy+s1wgx7e04IXEaRtxrLYKPOJbsnX/TmA6TiOgr0Og/wuHSFbO4GYiQ3G9ojXAJsj2wHeAs76APTTbVQQ1Gitb57GkOxoicoU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by DM6PR12MB3371.namprd12.prod.outlook.com (2603:10b6:5:116::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 04:34:46 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603%7]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 04:34:46 +0000
Message-ID: <67df4178-5943-69d8-0d61-f533671a1248@amd.com>
Date:   Sun, 17 Apr 2022 23:34:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] gpio: Request interrupts after IRQ is initialized
Content-Language: en-US
To:     firew4lker <firew4lker@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Basavaraj.Natikar@amd.com, Richard.Gong@amd.com,
        stable@vger.kernel.org
References: <20220414025705.598-1-mario.limonciello@amd.com>
 <20966c6b-9045-9f8b-ba35-bf44091ce380@gmail.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <20966c6b-9045-9f8b-ba35-bf44091ce380@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::29) To BL1PR12MB5157.namprd12.prod.outlook.com
 (2603:10b6:208:308::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1197f34-1432-4bf5-a7c3-08da20f4c407
X-MS-TrafficTypeDiagnostic: DM6PR12MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB33714DE3EB42A1A9CAECBB3DE2F39@DM6PR12MB3371.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NBqgrgNSUJrFCpIg3F/p/EvTMQ+y1uWUQYfSQL9tuca1+8V1P/W45nirMVx5gsaBWf0T6LrggGPzuUoeEFjvoSyzyK7SgNc9rndQcolrnPx+2LBDyCcgsBMLKbPH5A1kQtAcD0n8qfz6v4uJdX6bOQTCtSgRv4FMusn2riw4rgXF8CLwf08chbWNm1w9bVgjfQRpxPCu2tN72aBnx9ri4PCFyEifOpZeaZSoMYeC/0sFCpEXn0O7B35tEg69575BUL5qa77DnP9A4Y/W02WsHkCzMtlEoQZvJPG67VA5T+qgspbA1j9TcWEylUHl7OKogiBNujBoDa9KOSOvbHvzF0CL7Ay44dCN+3XNfQzUqSQ0A01yhyKAMIaTIG3D87Oxoi8SPin7cieFA/DibJpu6kK9a2wq2JiXF+jqFC96Sdntf58OA1C22C6VeKMHd+0xe7+IgXE6xaXTbkbOocRughNC7XrNL1PPRen3yjPIRgsxAQA5wV19iHLwYONRbrKyv1MvVJ2/cQy4/qAjtJ2g11dwhET3ef6/W/P1WFC80C6ASTdFCyZkluVvSQq+Bgg0o6HAMx4k40akQcg0phfCta+gvE0ESvvoF/8SYqCsHPKmBu9nVq48ZiWB9rgWtEztMCRk1OTzwKACk0bplFEQ0W10m61HNV7W6oPaKKj4NLKpZjTbbO9K0o0bGBTSRANWmVUjhhKjuwZdOO0kjl0mXGcSJj3PdkgR8WUWkvadZxUuMKjex++EcNSsJQ17p670iqqzQtBGP595ivScpupOmrSWV33X+InAQk4GLv75UhLpKXCQIiYUBo+qpDWW/SE58a71teQo0/DZzcANeg7jow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(2906002)(44832011)(38100700002)(316002)(31686004)(36756003)(66476007)(66946007)(66556008)(83380400001)(110136005)(186003)(6512007)(6666004)(31696002)(508600001)(86362001)(5660300002)(8936002)(45080400002)(2616005)(6486002)(966005)(53546011)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2ZsTktDMk9rQVBueFJnVFdQd1VSVHVRVCtWSCs5ODIyQ2ZZMGNOQkVCOHdW?=
 =?utf-8?B?OFZGdjRHbTV3UzdzYTk2L0hVZE1VcmFwZkp5TTdMelMxUXhzUVBPaHU2djF1?=
 =?utf-8?B?ajFETGdyalpCdmc1WndKVCtRNTUrTm8vdlFwMW9xNVJBOTZHYTFzZnNja3d6?=
 =?utf-8?B?Szlyai80MTBCV0dudDEyNlBORi81ZU5JUmN4NFJocklkVnVKelpuUGxxOXFR?=
 =?utf-8?B?NE1oVXg1OHRKSFlyUXU1OUxJZThaNFZaZ2FUdW5qdUZqUnlvKzFqeXhpb2ta?=
 =?utf-8?B?Y0xHMjRaV3FublJGOW93TkRqUThpRWxydzU3S0VodGljaEY3RWh2dHhBUXZX?=
 =?utf-8?B?V25DU2NTZGMvVnpXUEdSMUgzNnFwL1pMYlV5ZTVQZ3F5NkJ2WTIySyttTnVD?=
 =?utf-8?B?a1NxbVprQUJtNjhSeFNMNWduWHZCWU12bzFCUjRlNHJoUWtEd2VmYVpDRW5y?=
 =?utf-8?B?UGxDYU9XOG5YNUlxUlhET0ZhOU1ubXB5dStjYlhDOXJGZk94ZTZ4Tk1uekoz?=
 =?utf-8?B?N0cxSmo4VkRQVi9YRHdDanZEbzhNTzJ0eGV3T2Jqd2RxLzdQUm1UYzczR3hu?=
 =?utf-8?B?dTVacW1SQituRHY0U3o3VTVPYk12VDNYWTl5R1JSZjh5Q1djZXdpSlV3MFlx?=
 =?utf-8?B?SHRzSFBVQzNQbzRSdHlJQVpvMlJLT3ZVcEcvN2t2ZmVlNzBZaFNnblFsRGNu?=
 =?utf-8?B?REVHYkNVSG5jK2k3eGsxVlVRMWdramd4VElwS0dKM0dNZHRWWEZyb0lqRTNp?=
 =?utf-8?B?WmNKSS9nTTRpdVIzVXppc1VSY1EwSG1XV3RUd1UrSHJXQkhuTEtEUWxDbFBG?=
 =?utf-8?B?cVVKcCtETm9nN1Q0M0h2Y2tSUThyVjE5UDgxTVhkVEVpeFFHbVFjNW5VMlF1?=
 =?utf-8?B?d3pYblpsbnFrcU9TR1BCdmp0TmU3WHlqQVkzZTdrTjhJenN4TW56d0Z1TUlh?=
 =?utf-8?B?NFRlS2lNa1pTRU8wR1BkdENJQmd3Q3NoRXhtRldwbHdJOGZsMGNEdktRNHhp?=
 =?utf-8?B?MzZxUU8vRDkvZ2VLSEVieHFzeEhibWp0NWp2UUpSN1NGQnlhWDRseEpPbVVI?=
 =?utf-8?B?MWM3WHRxL3FPS1FZejBhNWx4YUpRQUV3blBxVDBoQkx2cGd6MUVMR20xdXBz?=
 =?utf-8?B?YndmSzBzMkVDeVBxRTErYzZJNXVZT1RJWUVaRkxMSUU0VHFsNWhKZElNbS96?=
 =?utf-8?B?a2dSc2xza1ZNc1pxb29HaDZzMXlZZmw3eVdOQWRMUGo4N2d4WlhKTk1abnUy?=
 =?utf-8?B?MklSRE0rajFxWW84MjNlUTJlTFRNOW92WC81ZWR2dVo4bnlhb1l0TVBvRzJX?=
 =?utf-8?B?QzR6Tkw2eUZFbjl2YmI3Qko4Tnd4c0NxUnhnMG9OazVvVEp4b0txUDJmR0h3?=
 =?utf-8?B?cmxjc2IwMjJlMGMxcllYa3ZnaDNKNThPYlF0YUVmSXVPSExIcnl0RndkSEhR?=
 =?utf-8?B?U3dDcmtabTVtY2JIK1FRSFNKMDFteEpsdUt2S0lCTTZ0eFEzSEVhcTNtNGt2?=
 =?utf-8?B?cGdXZTZHWG84ajFTcFg3Q3lnYjNKUXBxeTJua2N3OXNyM2NKTlVLK2RtSDEv?=
 =?utf-8?B?RThTVDRZbmN6M1BVUmdhajNpVzBRcVZlVHd3cHdxMkJaYXNMbFBqRTZlTEhM?=
 =?utf-8?B?dFZwQVB5YTQ1N0dQSFRacGl4LzExMCt0UU5tMVhYV3kvdzdIVDVqU2V4VjYr?=
 =?utf-8?B?V0s5bVpDdEZPN012ZGQ5RGJRSk9SYmQvdWFKKysyY0VWU2U0a09RTkFSYlpa?=
 =?utf-8?B?TUNSaFpYTFBGOHpWMW13QWpQcksweEcrOHlHTUJyZUxGVGFJSERPNzB2NGdi?=
 =?utf-8?B?S1YzdTJnMXR6MExYU0p1cE9KY0JhVnJLTzZPSHp5REtxTnJucjBUd3plRkdR?=
 =?utf-8?B?c1FSMExRR3djcmRjVEpzYlIyZEtaR2VtZVVUajVDOW9wbm83NjI3STQxTzBl?=
 =?utf-8?B?R3Y0VkU5U1A5NWx4bkp6YUhnRzBpcDRLa0UyZVRoZjRFcW5iOFhDU2w3UTBO?=
 =?utf-8?B?MktIOWZpM2FjR1VCWFl6TFA3cVBUTml4ckk1YXgzd2NkRzM5S1ZDb2hkVFZp?=
 =?utf-8?B?bVk3NTM5d3BubThsdkVCMHZ3ZmJWemo0cVBoeVJzaXM4dFpMcHZLb2k1YnBw?=
 =?utf-8?B?dVdFQkJpSm5FT3UzZGYxM2Zjb0RkamZXNk9yeTlML2V0NVlidS8wa3ZZbkZ0?=
 =?utf-8?B?YWFTNXdZN3UwWTd4c2xyUEJhTXZkWWFyblRTbkdHMTIyZEp3NDdtN0F0N1hZ?=
 =?utf-8?B?QmNWM0RHRDRERno4MUFOOXRqNTZZRHRXVlFsVXowUlEvUUNjYldGOFdjMDB1?=
 =?utf-8?B?VnpJSmdhc2lOTnk2d0ZQNnpKdlF0MWFJRCtEKzJSTUIzd0lQUTdJTGlrU2da?=
 =?utf-8?Q?cYcrBCACKi7j4pf/J9siHNeOnvBqhZz9w/usmV4UxsOqp?=
X-MS-Exchange-AntiSpam-MessageData-1: O2seqTfGOAdGcw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1197f34-1432-4bf5-a7c3-08da20f4c407
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 04:34:46.1181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f9DhCV1QnNtAwxQnbQIKXjLmniuD/1Y2u9mmFegBpNF5xOb8ncZOZ2k7PUzjbROhIvOICoLoNBUyjHhhUkKZKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3371
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/17/22 07:24, firew4lker wrote:
> On 4/14/22 05:57, Mario Limonciello wrote:
>> commit 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members 
>> before
>> initialization") attempted to fix a race condition that lead to a NULL
>> pointer, but in the process caused a regression for _AEI/_EVT declared
>> GPIOs. This manifests in messages showing deferred probing while trying
>> to allocate IRQs like so:
>>
>> [    0.688318] amd_gpio AMDI0030:00: Failed to translate GPIO pin 
>> 0x0000 to IRQ, err -517
>> [    0.688337] amd_gpio AMDI0030:00: Failed to translate GPIO pin 
>> 0x002C to IRQ, err -517
>> [    0.688348] amd_gpio AMDI0030:00: Failed to translate GPIO pin 
>> 0x003D to IRQ, err -517
>> [    0.688359] amd_gpio AMDI0030:00: Failed to translate GPIO pin 
>> 0x003E to IRQ, err -517
>> [    0.688369] amd_gpio AMDI0030:00: Failed to translate GPIO pin 
>> 0x003A to IRQ, err -517
>> [    0.688379] amd_gpio AMDI0030:00: Failed to translate GPIO pin 
>> 0x003B to IRQ, err -517
>> [    0.688389] amd_gpio AMDI0030:00: Failed to translate GPIO pin 
>> 0x0002 to IRQ, err -517
>> [    0.688399] amd_gpio AMDI0030:00: Failed to translate GPIO pin 
>> 0x0011 to IRQ, err -517
>> [    0.688410] amd_gpio AMDI0030:00: Failed to translate GPIO pin 
>> 0x0012 to IRQ, err -517
>> [    0.688420] amd_gpio AMDI0030:00: Failed to translate GPIO pin 
>> 0x0007 to IRQ, err -517
>>
>> The code for walking _AEI doesn't handle deferred probing and so this 
>> leads
>> to non-functional GPIO interrupts.
>>
>> Fix this issue by moving the call to 
>> `acpi_gpiochip_request_interrupts` to
>> occur after gc->irc.initialized is set.
>>
>> Cc: Shreeya Patel <shreeya.patel@collabora.com>
>> Cc: stable@vger.kernel.org
>> Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members 
>> before initialization")
>> Reported-by: Mario Limonciello <mario.limonciello@amd.com>
>> Link: 
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinux-gpio%2FBL1PR12MB51577A77F000A008AA694675E2EF9%40BL1PR12MB5157.namprd12.prod.outlook.com%2FT%2F%23u&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7C96ec39c78488493fd5ca08da206d3c7b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637857951204650754%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=xZbNC%2F50JqlNwcTYAtGLn6z0%2FEPbfCKKOc%2BlZlMh0EQ%3D&amp;reserved=0 
>>
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> ---
>>   drivers/gpio/gpiolib.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index 085348e08986..b7694171655c 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -1601,8 +1601,6 @@ static int gpiochip_add_irqchip(struct gpio_chip 
>> *gc,
>>       gpiochip_set_irq_hooks(gc);
>> -    acpi_gpiochip_request_interrupts(gc);
>> -
>>       /*
>>        * Using barrier() here to prevent compiler from reordering
>>        * gc->irq.initialized before initialization of above
>> @@ -1612,6 +1610,8 @@ static int gpiochip_add_irqchip(struct gpio_chip 
>> *gc,
>>       gc->irq.initialized = true;
>> +    acpi_gpiochip_request_interrupts(gc);
>> +
>>       return 0;
>>   }
> 
> Tested-By:firew4lker@gmail.com
> 
> This patch addresses the issue. Tested on a Lenovo T14 with AMD Ryzen 5 
> PRO 4650U with Radeon Graphics Graphics.
> 
> Without this patch the laptop is impossible to wake from S3 and S0ix.
> 

Thanks for testing it!

Linus Walleij,

As this is backported to 5.15.y, 5.16.y, 5.17.y and those all had point 
releases a bunch of people are hitting it now.  If you choose to adopt 
this patch instead of revert the broken one, you can add to the commit 
message too:

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1976
