Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0F741947C
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 14:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhI0Moa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 08:44:30 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:24006
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234408AbhI0MoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 08:44:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ikiwa4tHCQYFXtaqTKUm27VdpsxuyFW2o0AfdcAe/0fmw3cC42csInkRFIBw5v/VKtzuK6nckRWZYLvF22h+fWg1Eh87kpZ7IDdbeELUgjgGGYFBjeAi8uQtWqMayC9nIKoQu2t82dnUHqUpFOmS8YxBzQ9jeUQAmSO+YAqiKAL5jJwdDLZlQORt7yzZXybPL072KotCR2JG2AiGsWS3bukAw6dwLMgoM6zDc58bpqe0+fqb3foGeleO00qdcm2QOyUGGHPbDJCejs1GeqHqCRLt8NIEUw1Si2SdG81r4dVb7x49jo4gEQW3AvgPN8mGlsBR4OR0QPRzUznYjvwdYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yPjg/nAfGrwrLMweCTos7Dsi2zmD/HpJy2xuaosk3OI=;
 b=ElKZY/Kaql2mJB+0BkOdBX+3wfC1nCiG4mbCigW5EL/MDcX/95vp7ThUKHhfUcwVcc2hcAUrucwSzOcCIvR7ws0nzwfSEGvhVF9KjvL7QNAcey3qu3VqFl9qeHsB4NrMdGOvUt8fOx9LRuNhohLiYnEf1QMTBeUIY79DyNr/sw3GXysg66vSRVt/C6daSU0B4AUV9B08JI68G+77pN2tY8kv0fUPCqjfQQIy3axG4whv6OsGfT5IaITVjpv4ML7KOTH9i9Q54ZgyuMkJ6NH3YsSYeRrxObK4v6Y1wl5FZIQ53yIKte6akphKU61dUD13urRSldaHc0Fsq6oI9lr9qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPjg/nAfGrwrLMweCTos7Dsi2zmD/HpJy2xuaosk3OI=;
 b=EzFzcIWd62NciRBDDePzkQl3QJDp8dEnQb1iANhYaK5NuqHKJD8E+aIxj8IWG9EwsafWc1oqmHztOFk8caY3Kc5WcE0sDG1tueS0C0hzByfAxWwA7RD6Co6qj8i3IgPyT6NNMiIJRdthPUTQ5sUDG5kqxArYo+mrM4RJLMTAZFU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR04MB4893.eurprd04.prod.outlook.com (2603:10a6:803:5c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Mon, 27 Sep
 2021 12:42:46 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::e948:b382:34fc:c923]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::e948:b382:34fc:c923%7]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 12:42:46 +0000
Subject: Re: [PATCH] software node: balance refcount for managed sw nodes
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     heikki.krogerus@linux.intel.com, jon@solid-run.com,
        rafael.j.wysocki@intel.com, stable@vger.kernel.org
References: <20210927102249.12939-1-laurentiu.tudor@nxp.com>
 <YVG2XCK1nF4vVYP0@kroah.com>
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
Message-ID: <97a611be-3deb-111e-5619-f0f015393e24@nxp.com>
Date:   Mon, 27 Sep 2021 15:42:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <YVG2XCK1nF4vVYP0@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0078.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::19) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
Received: from [192.168.0.30] (78.96.82.95) by AM0PR06CA0078.eurprd06.prod.outlook.com (2603:10a6:208:fa::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 12:42:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5e27f40-e960-48cf-dc9f-08d981b44e41
X-MS-TrafficTypeDiagnostic: VI1PR04MB4893:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4893F88EA6AED9259364C623ECA79@VI1PR04MB4893.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PUBSl+I9/eOjMeq4HQIiZqQUeIgPP/9/5FTW+/d8Yxz+YlBC3rD8SHGgjZrKNn09dc9qwv1NyfdzoTwWCb47rQskKfSEv/S7QJJsho9OnYFs0C4sEc20GxcHls3OmsUlNnvV9sjygrrRrri0/84n9EZ+Gb9Zh83drJYMNS9Ph3TTIfK239fgmky1zANSy81k93OeD51vT6+s95jL2tdOfYNBK7GIBpThYEvPhqRvlxjyqFPNkfk4genHg8Mb9sHie2/NiFQhKKFJSVC1bMHT6yQlEpH+b75QMlTit6/L1c5d44iubGArLAFiYuc6oCzENlxCdEfosJqaSY/+QtVPuos007Ms5xNKbf3arCMffy3WMduV+aIK5Mjxn42jAx7Cr9QsbrDjabxokKmCaTBKfzFXGyAf2qisuvkkE5Kv8/nMa+8LSsF+hzh3SBdVYc8U5P6SlmQA6M2uL/uNQ34UW1R9azE26Aus96tTnn12NapEB0uOi1INRQsKB5y6NX6aIunAtVJM88cnDwV2kS7vlzSf9Slb0E2clapQMqDNZTYAfvpK51Q1ZALnLzHSmbIeKkbMs/wiGzLLVUYdXhHtOBCjLoz5AZxBCVDomICMi7nftiJdXw0gDTVorbMWLdhHAbpnAYM+nDztv4Ckb4ZVZ3+Z2AzpvHZ+eiVoy4LlmM0Ph1GzxBXXs6pKLzjblkqaPD766spBoYUdo7SeYH/qJhSOK4gCbkAel0GTQeKTxRkVTli/W9ZEVaAYVH5muLdf0uqvn/Tr/XhEYQJMBWGUrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(16576012)(2906002)(53546011)(5660300002)(6486002)(956004)(31686004)(2616005)(4326008)(6666004)(6916009)(66476007)(66946007)(8936002)(186003)(66556008)(86362001)(38350700002)(8676002)(52116002)(38100700002)(31696002)(36756003)(26005)(44832011)(316002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2M2OENZQU9LQkp5WUVCWFJ2QTR1WVV2UTl3bmpuTXRCVUNvM1NkSS9qbnQ3?=
 =?utf-8?B?ZDZYRWdpU0QvTHk3a2lMR3grYTcwbDVBaGhmT2JLS1krOXExbzlQQWl6dFpt?=
 =?utf-8?B?SmJZbVQ4T3pOVjJ4c1UvNWdKZUpZdWw1eTkzV29JYUZhWTk3QkRtREppTXo4?=
 =?utf-8?B?T1B3Rk9sZFhZRU5PbkhpRmtCclJnMmFtRXY1NkY3SE9rR1dFY3A4M2Z6U0lK?=
 =?utf-8?B?bUt2ZWVKVkw0dTRmdnFWOTJQaGlhU3dXT1N0blZ5RmtCdUFsWG94dy9KSEww?=
 =?utf-8?B?a29HcENOazBIbkJNZVdiZ0w0NWZOSTVITisrSTZPakpSbjNBMTlzOVRqUktx?=
 =?utf-8?B?TDVzR0YwT0NxZGZyeUtXTTlmT0I3ZXNUQ05GVlQ1bjhCVzNGODBsTkNtU2lj?=
 =?utf-8?B?ak9ldWU2Z3QxSldBMGsvYVVMaGgwUG1penRjdVFqUWRVWHBDOUwrNXYwc29t?=
 =?utf-8?B?c200NHRHS0FEUHJNWDdreFJIWXpGbmpuTXdKaVhUQTYwenMvYTJ1Z3c4d1Z5?=
 =?utf-8?B?MXpIV0hTNWxkczhYSXY4RkNKcXFseTJ6VzhjK2NQTk5rY3ZHMzU3NXkxVlo0?=
 =?utf-8?B?Zk1rSUlDcmxtaDViTU85ZU1lbEY2R1JTTjBqdjNaNGkwbkhTYStzOTBHS283?=
 =?utf-8?B?bzBYVmM2ZnM2R052SWV5MkpXS2NQSkZyUU9Xd1BYUC9HNU1YU3FlcjVZYjZR?=
 =?utf-8?B?ZmJwWUlSQmhwVkwvc3lHLzNLNUxBR1V0VFBJbUp0YWZVa3lwRVVUYlpVcGx2?=
 =?utf-8?B?MkJtOHRoUmFFa0hKdGdLMU9DWC9oTnE2a09ndXQzZ2gwcVplVi9LMnJqV29s?=
 =?utf-8?B?ZFZZeno2bVZud2g3eG9lR1JISXhKM25jM2VEUEN1OVlkUlB4dE9yYkplTHYx?=
 =?utf-8?B?aERzNVpGbldkMUdoTENZZ29VWUtYNlhCRmNDTTNFZ0t2d1MybFB0ODVEcmdh?=
 =?utf-8?B?Y3MyYko3QzNvckdvcjBzakJicmRxb3BvRDlubFZhVE1rWmc4YmJsS2xOWk00?=
 =?utf-8?B?UW9rMlZ4RGcxQ1cyWGJMWEI5V0NQTG1UVUpzUEF2bHVwOUQ2YnowVFMzeTlv?=
 =?utf-8?B?NVJuQ0lVZC8zU2Z4NmNTWkRUSW5RaUZjK0laSjFaWllON2dwUzMwTXd1SEN0?=
 =?utf-8?B?eGJIYk8xWHJLbFRTckZEWjR0cmxta09iK20rTTV0b01wL01QMTRwU29Sb2I5?=
 =?utf-8?B?eXJObjd6RVdIeHpYZ2VlczFlUkpDK0lYdFNzYXJJSE1yMmxManUwMXZNY05X?=
 =?utf-8?B?WVNtaVowQ3daQUtPeVEydVVNbVhuUXpBWXlKZFpsU0tlZ3VXN0NDcWthellq?=
 =?utf-8?B?MTBYalh1ZCtUSytoYWhWUkxPQTRyRXdxTEY5L0FmOEtwSVN3TFJGbUpIaEYr?=
 =?utf-8?B?MlpJVlhOU3FzeDV0T1JxNEhoZnhjcFNwbzlkREtUR08yTzg0dFRHVzdQTisr?=
 =?utf-8?B?WHZIdThmSUdDa2g0YURXNE9WR0d0OWVYZFpJdUV2eVhpVUhmUVVkdXdudkVx?=
 =?utf-8?B?TFBuNDBieU5NQ0o3aTA0UmhVV2dnSU1NOG56Ym1KLzA3UnRHT3YzRXZpT0JD?=
 =?utf-8?B?cXZESGRnbDZOUmprRk1CU1AxYUtGcmV4ejJmTzIrNWc4dng4Y25kVmNHT21P?=
 =?utf-8?B?UEQvNEZ4aDFWckVka2lsUlVqQWczTWprcEl1bUtFdzUxR2o5UGV0R3lRWVZC?=
 =?utf-8?B?cTJwaHpLa1FRTnlmdk9DNmpSVHA5Wm5OTjdNN0I2dGFSZVROOWJadC8wQ1lx?=
 =?utf-8?Q?ZVxUkcn5umxz3wK3xlIwIcvq4wxlSzd1vR4JFJG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e27f40-e960-48cf-dc9f-08d981b44e41
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 12:42:45.9080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TpHvE/RN7CmzAYaDOsvQQd+1iXZho1VSSemp6QOIC64J+xcIj0PuNqdE1XXqXch/uSJFVuedlBiRpmaqZZvzwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4893
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/27/2021 3:17 PM, Greg KH wrote:
> On Mon, Sep 27, 2021 at 01:22:49PM +0300, Laurentiu Tudor wrote:
>> software_node_notify(), on KOBJ_REMOVE drops the refcount twice on managed
>> software nodes, thus leading to underflow errors. Balance the refcount by
>> bumping it in the device_create_managed_software_node() function.
>>
>> The error [1] was encountered after adding a .shutdown() op to our
>> fsl-mc-bus driver.
>>
>> [Backported to stable from mainline commit
>> 5aeb05b27f81 ("software node: balance refcount for managed software nodes")]

But ...

>> [1]
>> pc : refcount_warn_saturate+0xf8/0x150
>> lr : refcount_warn_saturate+0xf8/0x150
>> sp : ffff80001009b920
>> x29: ffff80001009b920 x28: ffff1a2420318000 x27: 0000000000000000
>> x26: ffffccac15e7a038 x25: 0000000000000008 x24: ffffccac168e0030
>> x23: ffff1a2428a82000 x22: 0000000000080000 x21: ffff1a24287b5000
>> x20: 0000000000000001 x19: ffff1a24261f4400 x18: ffffffffffffffff
>> x17: 6f72645f726f7272 x16: 0000000000000000 x15: ffff80009009b607
>> x14: 0000000000000000 x13: ffffccac16602670 x12: 0000000000000a17
>> x11: 000000000000035d x10: ffffccac16602670 x9 : ffffccac16602670
>> x8 : 00000000ffffefff x7 : ffffccac1665a670 x6 : ffffccac1665a670
>> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
>> x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff1a2420318000
>> Call trace:
>>  refcount_warn_saturate+0xf8/0x150
>>  kobject_put+0x10c/0x120
>>  software_node_notify+0xd8/0x140
>>  device_platform_notify+0x4c/0xb4
>>  device_del+0x188/0x424
>>  fsl_mc_device_remove+0x2c/0x4c
>>  rebofind sp.c__fsl_mc_device_remove+0x14/0x2c
>>  device_for_each_child+0x5c/0xac
>>  dprc_remove+0x9c/0xc0
>>  fsl_mc_driver_remove+0x28/0x64
>>  __device_release_driver+0x188/0x22c
>>  device_release_driver+0x30/0x50
>>  bus_remove_device+0x128/0x134
>>  device_del+0x16c/0x424
>>  fsl_mc_bus_remove+0x8c/0x114
>>  fsl_mc_bus_shutdown+0x14/0x20
>>  platform_shutdown+0x28/0x40
>>  device_shutdown+0x15c/0x330
>>  __do_sys_reboot+0x218/0x2a0
>>  __arm64_sys_reboot+0x28/0x34
>>  invoke_syscall+0x48/0x114
>>  el0_svc_common+0x40/0xdc
>>  do_el0_svc+0x2c/0x94
>>  el0_svc+0x2c/0x54
>>  el0t_64_sync_handler+0xa8/0x12c
>>  el0t_64_sync+0x198/0x19c
>> ---[ end trace 32eb1c71c7d86821 ]---
>>
>> Fixes: 151f6ff78cdf ("software node: Provide replacement for device_add_properties()")
>> Reported-by: Jon Nettleton <jon@solid-run.com>
>> Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
>> Cc: <stable@vger.kernel.org> # 5.12+
>> ---
>>  drivers/base/swnode.c | 3 +++
>>  1 file changed, 3 insertions(+)
> 
> Next time, please include the git commit id of this patch that is
> already in Linus's tree so that I don't have to go and manually look it
> up...
> 

... i did mention the mainline commit in the description. Maybe there's
a mix up with the previous submission, or i should have used a special
syntax that i'm not aware of...
Anyway, thanks for picking this up.

---
Best Regards, Laurentiu
