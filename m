Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F0747E38D
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 13:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbhLWMer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 07:34:47 -0500
Received: from mail-vi1eur05on2138.outbound.protection.outlook.com ([40.107.21.138]:36161
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243653AbhLWMed (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Dec 2021 07:34:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9GL38oBqo+Ca61wogey99GYRudCgWq1PKlkC1Iau/XdUmgteR4yxTSAbJB0bRdL++F1/Luw0iQA80/fVVJjiYcvBGw4Cgf5/QoGgJIPBabQzI5XOJ6q6ss/GSiLNzFPFZhFIlfAeQmLfd2OjbJ3PT1oUCcphgCS5quw5ZBmUWsslgN50zLr4VI0PZXvjq7Nyg1uQAROiprfPr6oKRT4MgKpGsveLsls8BCNOCQiMk4oI5tkOSzLaxO4W5uqhtVzkJ6R2rGy+mXGoWqVZUY3H0nUdJsqocXsDdnCDB6yge4GJJCDgey+JvETgJZeWsGER8s60TAYmaqwrF4E8mOpOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OyflxAMYSSgWt13xj7K5edANX56O/i+4ZunAq2FCQjQ=;
 b=bqHxWTpwcUIU7OZf4lsvdsIZXcpVw2TOJ4lwVyx4F9gznc0ewa4s4t5xQqtKspArvYitKVW7ffvSZU/APuyfLOdfqOwtvABmR0tVYoZ9ZvJ+tJo9td/BEuXWXgytrnOSO+DkgsjwtTpBpsk4i4w3rKwcbfHgOMYSt7NY8YwSKNRJVC/2/2Z5/VQuLAS8QBtxpzHJHeEpmFJCHeiggvk0sXQZpyzXKKIn8YPlT+Wlk2vEPiSStXr3otGixKAqgjF0IT+rxMfwNfAsJ6wnzRaaj3BrEb3qZKBXAf/l3X4itqwz/xw9DktQzFR5Ohk3HAU6mTBemzpaW+yDsi3XKr43cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyflxAMYSSgWt13xj7K5edANX56O/i+4ZunAq2FCQjQ=;
 b=Htm4mncAl78TQoMhNVdYc82jawWobtW53ybqAqnCxtTii5t4a49hqpJMBefnZ/v0Ct+wees8CGRndRdISgQuahamsFu6qXqxxYeweN8uk5JRAIDsdKmd3z5jyWhiYkbklmIzgElL7GFHXSkgftly22s0ysa7Eb7TyhIyCxyeSQA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from DB9PR08MB6619.eurprd08.prod.outlook.com (2603:10a6:10:257::21)
 by DB8PR08MB5050.eurprd08.prod.outlook.com (2603:10a6:10:e2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.14; Thu, 23 Dec
 2021 12:34:28 +0000
Received: from DB9PR08MB6619.eurprd08.prod.outlook.com
 ([fe80::347f:d385:ec53:75aa]) by DB9PR08MB6619.eurprd08.prod.outlook.com
 ([fe80::347f:d385:ec53:75aa%7]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 12:34:28 +0000
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
To:     Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     cgel.zte@gmail.com, shakeelb@google.com, rdunlap@infradead.org,
        dbueso@suse.de, unixbhaskar@gmail.com, chi.minghao@zte.com.cn,
        arnd@arndb.de, Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org
References: <20211222194828.15320-1-manfred@colorfullife.com>
 <3ca4dec8-f0bd-740f-73c8-34fc6fc1cf66@virtuozzo.com>
 <937f1320-6b7e-9aa2-2a21-7fd2f94eeb32@colorfullife.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <f24d2e3f-1dfd-7bf4-78fa-4eb515b4cd7c@virtuozzo.com>
Date:   Thu, 23 Dec 2021 15:34:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <937f1320-6b7e-9aa2-2a21-7fd2f94eeb32@colorfullife.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR07CA0019.eurprd07.prod.outlook.com
 (2603:10a6:20b:46c::23) To DB9PR08MB6619.eurprd08.prod.outlook.com
 (2603:10a6:10:257::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63d3fb65-e7c8-4ff7-c2d0-08d9c6108fdb
X-MS-TrafficTypeDiagnostic: DB8PR08MB5050:EE_
X-Microsoft-Antispam-PRVS: <DB8PR08MB5050D2DDEC5CF5A2D11701B1AA7E9@DB8PR08MB5050.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXiG9oSlQ5icwWttUWJ7FI7n/W5iSvAa2JWPJeLAU82mOzD8OY7uHRhnao0nFmJFy9QGR/G+y/oA/kcdkj3aLadwo8fZuGPsFcrNMHPzKcJvRGcMR9JDDh1SW7Xos3F+OV09yw1HcV1c7uS81hdK1xV58MolUi3Zm8NkVRPgEKxfcTw5ifAPVzgTR71qkpsV9d/6KQfE4BUbeU1M4HWlfgyjW1MUXWLHsDL7974UnMd2m+tX9i6yXO/89ENqsU7lfoYuzkiL/woLlfkXdGfQQpLXPD9XVpdT2arjse1pa1XfyGkn/jBOEqI9EADy3CX1xVR4jB6VqfD5RiS1mKdUDSRd37K1lDyYdO61Hnyg0B/pkOrx6bbYlGfowN+XatsU17NXCqgOEY22BNrewszTWigoaJy1jivXrzD+lr7Qwh/UDzZZL27Us3GiRzk1zvVuY3HzK9nR3LCwQwNb/vAo/PDoLUapCiD1wvWoSeJijAF4Yjp5ghMDumoZ5DCu3B82taLd/oxMz+mFpRh8XTA5jLuWyq34L9Vei3hxOV8xdRdgsoxzJU8bgNBD8x9jYVibTPWYK1PGv3EEEOeO+qOCaZYklkULxS1SMTUkkvQKMPnphTEcW0t+/InFiSk388xtTvqAs1KWNliblc+KZrdWVddh4a/xFep1boGGrK7Hm0nYT8wZ4RLQnW06bDn8LBwMhSQZ/JYfxh594vCPrGX946b84YOy2UES2gc5M99NKIPegqNU9Dnx2sjmLxNHOaX7JsrQ9V4KB+OktekTHFiC0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB6619.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(26005)(4326008)(186003)(38350700002)(6506007)(6512007)(36756003)(2906002)(6486002)(38100700002)(86362001)(2616005)(508600001)(66476007)(66946007)(66556008)(7416002)(52116002)(8676002)(31686004)(5660300002)(316002)(110136005)(31696002)(8936002)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2FZWGFLYkRlZ1N1UzM2YUlYTXZZRUhRN3BvcGpSZE04NlJ6NmhLVDhrekd5?=
 =?utf-8?B?NUVEUmFGL25aaFh3UkYrM25BTHZDcHhhOUI4YnVMUk1qZ0xQYTh2dVRnS1kz?=
 =?utf-8?B?eXhOc0g4NXA0eFZuVGpaQnpwNmlMT2JPT2x3WFdPNGxuQVlVVzQvRjZFODA5?=
 =?utf-8?B?d0ZqS3ptOTRMekovZ1lBWWJmbUxQRHFzVml2ak9OV3lWQTVjSjJ2eHhoajFE?=
 =?utf-8?B?SVRLMTlPRThWUnRwY1VxaSs0S1V3VHB0NXhCU3lQZE9hS1hqZUJ4Q3grRHdR?=
 =?utf-8?B?RlRNZ0RmVWNsS2RBS1kvcHpFZ2doV2ovM2UvM2hEZ0NjMTRUa1JlZHpoK1l1?=
 =?utf-8?B?bVlVRVMreUlXNTduVEZCSk1EUjdmYlNLQWNZZitsNjg5NEw0SlA4SDJ6YVB6?=
 =?utf-8?B?L215bzFmdXcvU3VpQzZxajByNllQZDRDSmVLUEFsWHlNd2l1VGVKRlRqTDA0?=
 =?utf-8?B?MHdRaHhWcmFJWFJyY04xc2FKN2V6eENTYUFpM0FjUnAwTEs2bHBVSFhFQVhs?=
 =?utf-8?B?ZHRxcWdGZW1CVFUyblhUU0NlUFFkc3FPa3hMNTNjaC93V0YvV3UxVlNScWts?=
 =?utf-8?B?RHVuNSt5YWNaUUdjVUlwY0MvYzYwUTJHWU96ekwxYTR6RXJ3Q3VzYnJmZ1Ny?=
 =?utf-8?B?TjBEZ1dHUHZqSVdjVDNaMHRoWnFVWUxqRFZmS3JaQVdMSlRpWGRNZU50WEJZ?=
 =?utf-8?B?NGIxYkwvZzJuTEFRcGFpbFVuSlhmd0RGRzlaVHZacXprWnNzT2hGZ2dkSm40?=
 =?utf-8?B?cHBpWW52MTJ2dzNxdGx6cHZNTlV3dFFHT3JPVkZBWXp4czBuY3c2eXFVdUZ3?=
 =?utf-8?B?WVpLN3ZldkJDTmptTklGbllscFd6RWkvYklPb2RLMmVpdGhTa0paVm9OYmZs?=
 =?utf-8?B?bHhZcytWVkxreFdWeTFWdUpZL1VZa1hwNlQ4NGlNVnFWOGI3Q2d4QkMrSm5G?=
 =?utf-8?B?MlVtb05aR05rZGMzOXFEN3pGMEFSQ0p1N0Ezcm1sS09MMVEzWGx2MEpBUDUv?=
 =?utf-8?B?Z1NEbnJmUVA0Y21zcUJRT0xWY0p2d0JCWDFUUnJJOTViTXlMM1NDMVZHZGts?=
 =?utf-8?B?TkRkME9JRkRVUm5LOE9JZ05pRjdobHFSRmg2T3BLMzVmTEJnVFcrOWY4TUwv?=
 =?utf-8?B?Q3hFTUE3ZVBVWDJ3SW9XUytaR0VyYXZDcjZyTTNuNXBScjVqSHJieGNTUzQ0?=
 =?utf-8?B?Mm0xZDdTWEpLQ2NPMEoxQyt3THdZZU1yejcxM2l2NlJVS0tFVStvdnM5djVp?=
 =?utf-8?B?M0V3ZUJuMDVmeTZrQ2VITHR3YUdnaXdRaXFValpKRSt1QUI2L3Q2Ym1vdjc5?=
 =?utf-8?B?cjRwYUZuYjFYVHpTeTJKM3FkZlZWVVR1SkQxSktYQ0lmeXlpMjBVOFdoOFVU?=
 =?utf-8?B?Y0RPclBIdGoxVzRqRVRqV0h2WnZNQnFXK1VGVnZRTHRTOXVEWWFwT3psRDMx?=
 =?utf-8?B?QUQ4U2dHQmUxYUMrRUVmbnZ3aEltSjJpa0hTOVRFZG5XQTlCZ1JjWmFQbEd5?=
 =?utf-8?B?UTQyVGR0dHBpUU1Pd2h5T1djN0dYZDFIeDV3WEdQS0xQU3FTbWR4WmdKNGlJ?=
 =?utf-8?B?NkFvWkNXNmtFN25ZamtCMFRYVjVWeUIvWUtxVkUwLzRVbC8wY0ozT2diQXNi?=
 =?utf-8?B?Z0xNL1V1Sm1nRy9YWmZ6MDhhZ0R0K2dhWjN0c1I5WnZsR2tMaWh6c0JETkxJ?=
 =?utf-8?B?Q3V0ZTQxejhiVk5XbUYvbHhGUUFwNnZSb3c4cGQ3byszcXIzSHZZVnN4QXhC?=
 =?utf-8?B?c2I0OUZsV0QrWk1zYms5T2tZcGd0TWtwNUxwcFR3T0tHM091SEpKNXFVYkI1?=
 =?utf-8?B?Uk1rTEdnbUxPRmo0R3NPNEorSTVJUDBSNnQ3VEFvNjJSbk15b29PNjVRZUFq?=
 =?utf-8?B?Mm5tTFI3V2tBN2VPT1Z2b3VZc2lhdlAxWkR6cld1SU9Fank5WHlHN2w1MzZy?=
 =?utf-8?B?QXh3bzV3Rk5HTFpQN3krUjk3YXJPMmNwODIxbWZVSU9Yc2JhamdncUsyMWpD?=
 =?utf-8?B?d0REWkdJQWZRWFRaNWdtcGtoRXFxbnhHZU9aaVlFS0ROUVo3d1FGUWNkaDUy?=
 =?utf-8?B?ZHZOQ3hkcXBnaTRPVWpZVzBQOTZQTGlDSTJPSG1jSWFDYjBzZnBXdk85T29I?=
 =?utf-8?B?RXkzQ2lEWEJkd1VIbUorOXNDOCt3a2xXQzlNRXJ6YjcvTjE1VE4wQkFiZWN6?=
 =?utf-8?Q?gZ63c05VDJOUlasSBlHbWeQ=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d3fb65-e7c8-4ff7-c2d0-08d9c6108fdb
X-MS-Exchange-CrossTenant-AuthSource: DB9PR08MB6619.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 12:34:28.6549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y0p0QjaQ4wZ+lLl24kTgXlircvvhMxHrO9XGqXpwufN9fdCuZC1Ehmeh2yhXGlWGY0CzvUBT5bct/s1sgWapLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5050
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.12.2021 14:52, Manfred Spraul wrote:
> Hello Vasily,
> 
> On 12/23/21 08:21, Vasily Averin wrote:
>>
>> I would prefer to release memory ASAP if it's possible.
>> What do you think about this change?
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -614,9 +614,12 @@ EXPORT_SYMBOL(kvmalloc_node);
>>    */
>>   void kvfree(const void *addr)
>>   {
>> -       if (is_vmalloc_addr(addr))
>> -               vfree(addr);
>> -       else
>> +       if (is_vmalloc_addr(addr)) {
>> +               if (in_atomic())
>> +                       vfree_atomic();
>> +               else
>> +                       vfree(addr);
>> +       } else
>>                  kfree(addr);
>>   }
>>   EXPORT_SYMBOL(kvfree);
>>
> Unfortunately this cannot work:

yes, you're right and I do not see any better solution yet.
