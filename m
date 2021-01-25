Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3579D302C2F
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 21:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbhAYUFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 15:05:37 -0500
Received: from mail-eopbgr60114.outbound.protection.outlook.com ([40.107.6.114]:30949
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732259AbhAYUAq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 15:00:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llBziSRGr0m9Mxnutqntxmh1i8K81MqMsSfkEhcVtsu0b7FOQwW/QiSdfcAuPPSleaYzIzUsrodLozU65kZvxivQCw83+pofwYLvO5KYDMsr9tHjc0+JEF80MzOld5O+lf45ZWG1qZ8hO89R/7dzKcj8iEhBcQ7J2UjBglVynihv6zu31vm4t/bisMM2oIh3ze3zoKVJninLksP8JvtB0+fpDwCJP0uZI7oS6q9XaT0qLLgGEoq84ln9kC/OAespoVxLMWgTtkNLxC9311WSTTKcdXphVZNfqZuHaEIqdVBB0GczhedJUEFv/6PGKT42ALh6KgmU5JSdMiw7OWWZ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=efbmtrtuZ15ozwHEOvg67o7ph4Y6NtFXpM20OaevoLI=;
 b=NIRNqfbrmWEUVqNgUpnhoBUoQKB8FarqicL6zmc5gkKuHweoxO87BKfJU9OeZzjs5oZnoxh6IoRvDzhTF/WAVDmSuFtGAl6lPfnMjFOMx1Q1IfTFhW+4raq9IZoF1sCnb/HcZNeWZFtAEVvgyfE1kI1WNSa/JrLBq/UQ13xWSomHfYM00J1o3vA2qplrhTKPo3U7Qenl63CfznKqToF+j2RlZcVTZZEh4oeAB8Zgy5bXJZhKmKi0cTD2iUkhnh1cilMWvz+89KBLAcQyZTGmrd9dmpKJTF8UtwskQQlJcbh+Son68qcr/h9+L9I97028JXgnAA51KSqIDr5BiIsnOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=efbmtrtuZ15ozwHEOvg67o7ph4Y6NtFXpM20OaevoLI=;
 b=g+ys1506KPg341HhT0Di8XlUg67bxTv9/t/92eafa2Cf8Am8+t20L+1vZGkDpd2/EGv5hhnAQkeWbuvsgZ+WMmZPRikx1mk9BQTp7vqyvMUO3h02DNG8VTkHwISlsqe0UELCjOhtVbUFaAF4A/LgYHiNl2qAPchbZf0x1LG43Cs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2275.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Mon, 25 Jan
 2021 19:59:55 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 19:59:55 +0000
Subject: Re: [PATCH 4.19 46/58] net: dsa: mv88e6xxx: also read STU state in
 mv88e6250_g1_vtu_getnext
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210125183156.702907356@linuxfoundation.org>
 <20210125183158.687957547@linuxfoundation.org>
 <8447247a-6147-32b6-541d-0dd717ac9882@prevas.dk>
Message-ID: <b3be188e-f874-72be-d3bc-2c0cc06aba53@prevas.dk>
Date:   Mon, 25 Jan 2021 20:59:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <8447247a-6147-32b6-541d-0dd717ac9882@prevas.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5P194CA0012.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::22) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM5P194CA0012.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:8f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 19:59:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f92c29f-a064-41d7-195d-08d8c16bc93e
X-MS-TrafficTypeDiagnostic: AM0PR10MB2275:
X-Microsoft-Antispam-PRVS: <AM0PR10MB22756159DC512CBB396EB06893BD0@AM0PR10MB2275.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KPlZwIMPxcHAbnKxsVL8dPEnFA/0Hj9N2BzWq+xFK26R4C87rPU0shx1Of4q1KGmi4NiOjYhZUC2qUKiSzGhI++vA/UMakQWDFwIwY2NexzGJuFBv20l6tskw77D2AAOSra8H7k5khJNxWA1mF2OST/Tmn8I/9W6DOBQMrGH1/zun3v+mpxOoMZQtbsTikgOtjrsQ6bnSQWu4ilWOWhQ/0HY+QaLtonSWiGoYkWb27PDRgC5WfbnXscViM+rvTf4Xa7vIfpgMKqK1IDieWo8VlLHvmmoK15/ceEjUq6Ac3h3uJoB2MrPox9YWQ7y8OBLsiom+NVQmQPbheSXOJ3GBg1c9pY62i1S/DNGFruXl85dNggyKYWqlt/Upm56i99lbA8mz8ya7aI4Z3z2rOqjQlOzBUKbRvtS85o4l3B70fX8WsSK3t8sB9vi2VTukbZxSqiBQ4PEq9BEd6gEPJnbsCKPMF13KkqZ3sXsHsb6tuLBHw/yChhGbpOHXiS7x2D7sCPQiIPUUeVrs2he05cxUp6p3rBtzwVpsaFtyJWVjHFOysPdTPGvF/O5RZnryohQzoxRDWBfeZH37xUdArYL05yJJJS1hkWK/n2o12LFP0A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39840400004)(366004)(376002)(346002)(396003)(86362001)(8676002)(66556008)(2616005)(5660300002)(8936002)(956004)(66946007)(66476007)(186003)(31686004)(31696002)(52116002)(36756003)(4744005)(44832011)(6486002)(8976002)(54906003)(26005)(16526019)(478600001)(2906002)(316002)(4326008)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V3luVjlPUWI2RXJYTkpEUTlaZVFpeXJwU0VDMmJjbnVlNmlKQTRiOVFEWEdQ?=
 =?utf-8?B?U29PMUxraWZNNnEyVm5kei8xTGUzWk1QeEIxRnpxMWF4Zkt4YnA0WUVnSmJo?=
 =?utf-8?B?eElYemdRTFZVU2tUdWlzS3RONmhwZXlUS1Z6QjZZSGIvaXJNQzVIamVNK1lB?=
 =?utf-8?B?bi9oT2EvUmxFVGFOR1FXdmRYVHhvell1cjJUK05oRDBieXZoYnJ6Q3lodmFX?=
 =?utf-8?B?Q3dDdHJuWTVsTUdMUWZLYmZoUnl5cHBNMDVndCtYWTFkelBnZG91ak03NGJV?=
 =?utf-8?B?Sk5vK2pvVkJVRlVVcTBYTjNUZko0WHB1VE9hZm11QUJZUnZJOUtMTlo1dFBG?=
 =?utf-8?B?TFpBbjhqMjhxWjU1LzFOZHprMThYQjRJWHRqZmliaUxKdmZnOWtaVGFoSTNl?=
 =?utf-8?B?ZnRFaEpJaVl0V2cydEVVbkNBdGdMNENYZVFiQkZtbEtCV2NycDM2RUVuS09Y?=
 =?utf-8?B?QnRjMmtIL3luVnovbHB3TUhrVnR5M0xpWlV3WlJmYW5pT3pxOExYOHFIcm5p?=
 =?utf-8?B?WlY0R3EzR2g1Y3hrTVIxeDA4ZFBhMktVMmVjUUxCaCtJZkEyTW54eXVGelY5?=
 =?utf-8?B?M3JpdlZEdVJtSWxVeXBVTk0wc0hKZVNuanRKZ0V0WG1yT3ZXVGNDemVUdFh1?=
 =?utf-8?B?Y0lrWmFJM21Xays2VU1YSmYybzBubjBlTHJRSVNhWUhIZ1ozMkxMVU5MWU9o?=
 =?utf-8?B?a0tMd2ZPcmpKQzdnTThIZjQ5YnZhbzVSTTYvMjlTR0p0VmVWM21TYnBrRDZL?=
 =?utf-8?B?MmxtdC9KVzRPb3RzWFdPQnU5WDA0ZXhzOWZFdTNCVEt2N3Q3Nzl2N1p5OGRE?=
 =?utf-8?B?QzZodTQxN1l2OTZiT1FHbzgvM1dEeUZWcDJwakFzNWkwSHpHaGdzNyt0V0sv?=
 =?utf-8?B?Mmx2d21mb1FsdjZGZ0xnMUpidDM1TmtBWVcwMXJpREpyMmkyQXZqYXQrVDM2?=
 =?utf-8?B?SFd2R3lWbDV3MDlBekJpaXhHTVVkT25paHJWejAxRThPSnNYcnJvcVhHZFlp?=
 =?utf-8?B?SzBSY04wUUpBNTFLMko5dzNUR3hrM1FDQjlrcEpBamxoaDhIUWp6OHVkSmNS?=
 =?utf-8?B?WmwzQTBvbS9PZFZ3T2JtSDAzNmhpMWVGVVk1NnVWRFdQbGQ5TEQ1Z25XNy9o?=
 =?utf-8?B?cGZTN0R1OGpjbkNRa09UVnV5Q3lwOG5SUHB3R2IwY0srTDA1eThiUjF6SEsy?=
 =?utf-8?B?Mm4zYmZiWENvNGFTVnRyUnR5bUU1R1h4SG1UY0haQ28wRG0rNUdibENZeEFa?=
 =?utf-8?B?MDFUbnl2eVpUeUJqSXFsSE9lQVhweTkyU1I1WWN3UnBnYjUrNGFJa3J5RWE1?=
 =?utf-8?B?cHpSWXljMzI1VWFuT00xVi9ldHM0SHg0dm5LMEJkU1NLVzgyaUVIa0xudUE3?=
 =?utf-8?B?aXp5Q2t0Y3BWdUM4NUlRMWhmUGlzYnVwM3NyWVZMUm5aVmViMFdjWDIrUzB3?=
 =?utf-8?Q?p9V9NBlv?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f92c29f-a064-41d7-195d-08d8c16bc93e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 19:59:55.6585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LSVLsSzbr6uxyY72ZkeC5+p8c1zz6mj6UVMXgquWVo+46b+um1SuY7bFIb1NTo97CAqmZW+pWwIziw/HXkO8SxPm8by4OXiwpgNcOdNAf4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2275
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/01/2021 20.40, Rasmus Villemoes wrote:
> On 25/01/2021 19.39, Greg Kroah-Hartman wrote:
>> From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
>>
>> commit 87fe04367d842c4d97a77303242d4dd4ac351e46 upstream.
>>
> 
> Greg, please drop this from 4.19-stable. Details:
> 
>>
>> --- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
>> +++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
>> @@ -357,6 +357,10 @@ int mv88e6185_g1_vtu_getnext(struct mv88
>>  		if (err)
>>  			return err;
>>  
>> +		err = mv88e6185_g1_stu_data_read(chip, entry);
>> +		if (err)
>> +			return err;
>> +
> 
> The function that this patch applied to in mainline did not exist in
> v4.19. It seems that this hunk has been applied in the similar
> mv88e6185_g1_vtu_getnext(), and indeed, in current 4.19.y, just one more
> line of context shows this:

Bah, that was from 4.14, so the line numbers are a bit off, but I see
you've also added it to the 4.14 queue. Same comment for that one: Drop
this from both 4.19.y and 4.14.y.

Rasmus
