Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE44031092E
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 11:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhBEKdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 05:33:33 -0500
Received: from mail-eopbgr00069.outbound.protection.outlook.com ([40.107.0.69]:53634
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231403AbhBEKb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 05:31:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcMWbRbg584/UhS80e8yfH5FmFfwTm9U0yTiz+YbQry9RH0EZwa2VlXWucqVn6oqeDSpFz+Bk5zVyceggZ/b7jzhQ/deCdBohemRlXPTeP6h/0xSLlG/17qUcYsq6QKCnYtrxDQHA7j4Ro9/+dnTA8CHBwsPzBbIUSwD8rPhiNpAq/lX0s4Uic22zgiRhn9xbTKq4gXF00TkkdEM02R2rbmAkMdkpvMwg11SzFAuiQVEdFIMBIlwH4HcNcwBKu/svay5KXDg0odWluIGz+2l4uHpO8GDEFyNVbCfJqUKQywPbnlHU2uJtEhrQjPHTFGCuQaOuPsLP7FZpcB1LTASxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBD+FW2my+EtYLaseTlOa1XRLSspqLVFmJLPd7C3S/A=;
 b=if9VFQcRFhHeSu41dvGXkUqkOQVP9lZv01eo0rZQ9yfZF2GQ7JFo2j1QJllKDDeEFGuJWR84TQr4xaVS08cYK2baPIoBgDEU+VI7M6vu/Wt/9d1LiKAuPp0/gW8UfIEOXdGWKDc6q6WIMd2qch4ro5NhgbDEpfuYmCGv1DIfaqiPmSp/UrrxwWBvXMvZz5Sra9hkq0UOgqWnQla7+wMTxSxbMxGebGZYird6JEiD0H6Qq8LvJNg+MV8+3ZfTvKpLWWpzySmjtqxVEa8uOqQb6Hbgir9pnD5xYIS0r2n4YsKNl+cyyex8nuBXjEPbytNsiJ5sLpT9M6SgkvgzwdDdew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kunbus.com; dmarc=pass action=none header.from=kunbus.com;
 dkim=pass header.d=kunbus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kunbus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBD+FW2my+EtYLaseTlOa1XRLSspqLVFmJLPd7C3S/A=;
 b=UtClRiLw3xla8rcn+EhU+AgUMUri66zxh6f4lw1fhwRG68Gyvxzygs9zhP9hGUuwpl2OyYv+uGNrn/riHD7pZfVNwBzUPXzX97jZ5gZj+ylQ1P2SD2MkrvWzyYVxBS/AOqXXqc1EtmMDmCI7hOCKKqWgcLQRyJ1n5u26FDCSLI4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kunbus.com;
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:a0::11)
 by PR3P193MB0539.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 5 Feb
 2021 10:30:34 +0000
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73]) by PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73%5]) with mapi id 15.20.3784.022; Fri, 5 Feb 2021
 10:30:34 +0000
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jarkko@kernel.org
Cc:     jgg@ziepe.ca, stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
 <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
From:   Lino Sanfilippo <l.sanfilippo@kunbus.com>
Message-ID: <327f4c87-e652-6cbe-c624-16a6edf0c31d@kunbus.com>
Date:   Fri, 5 Feb 2021 11:30:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [87.130.101.138]
X-ClientProxiedBy: AM0PR06CA0130.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::35) To PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:a0::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.23.16.111] (87.130.101.138) by AM0PR06CA0130.eurprd06.prod.outlook.com (2603:10a6:208:ab::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Fri, 5 Feb 2021 10:30:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d73e556-dd1b-4c76-e2d6-08d8c9c11215
X-MS-TrafficTypeDiagnostic: PR3P193MB0539:
X-Microsoft-Antispam-PRVS: <PR3P193MB0539988C0C525C56FEA4E24FFAB29@PR3P193MB0539.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GGZ0nRThjgehMhKqLmV0ptMGwvTvzFRUYvcw2RCqe+WpZ3Fz8zba+Y9IefYqaZ6yz5eCtSWYFGfMRqUFmwBT5f8xhjXZs/rTawygZd9zTumMQcNOOOsQr1iF8vFNLNvhFL6VZLdz5NiF/vKjU+bKYyIbSxeUwivSUZ5TvKrDyhsGJDO58V9iEnDwNqd6cxn9FL601dzTxQruyHm7oyIYiEZ95IWoRTDqF74n/aO/aXIIpNWlURw0ag3CZ4fJwsQPQrsqvYqkh87vJ6eKg/lhnP2PUIN/lj/g200tcjUhk+6U+2ht4t15RORjkWZxGoEmU0NZQ+ckAg93IBHsb0pnJZ1I3REyTJj7o3fLPyi2zzp6jqTdSC+LcBQihfD5ic3EuwfOjX0QVGuC3noDnixkr8pnLKuYiLoj45zXmkTSIaevjpxj1r87A8xgXFExzl3qokDx7QSwYH0e42K+1GMZ/IbLuIv31cf5v6olu4DMLNfY3J1lI3pvnXpIMw/Tf1gZ6xANzuAtONxrW9KT/WtZfsUEfaluFcGY/ZBpxG+Z/8whVjQK53ynz+wKcNOKaFGP0l/R10+WtdF12fsx27Rtkn0yuRgoTyG1bGEPAVNUf+Vfzyiv+XMBMWAPCOpvBqj2LyyfWmoJIYLR1s7fmnNmCMP2dldaDfn7tW6A7JLm0y8mnTZDmtEB2+NhwNAxpHsa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3P193MB0894.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39830400003)(366004)(36756003)(2616005)(16526019)(4326008)(66476007)(956004)(5660300002)(66556008)(8936002)(6486002)(8676002)(16576012)(26005)(86362001)(186003)(4744005)(52116002)(31686004)(478600001)(966005)(316002)(66946007)(31696002)(53546011)(2906002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SFBxR3VEYzZrTlJCQkc4NDZIUTZwNFhuL0xNY2huYU5Mc3h4YmtvcTAxU2U4?=
 =?utf-8?B?VXhDTG5oeTUxemtwbFc2SWNyb1dpU3RiT05LbjNPdGZxeXVLdDZFdHo5UjMy?=
 =?utf-8?B?MnR2ZE5iaWU0K3pJa3lHVzNmTEVFakVaZ2QrREV4NHRtb0lmT0VrYTZuTkl6?=
 =?utf-8?B?OGduQlk3bGRJekZkbVlPcUxmdG51Q0ExOFpzN3RuWVo5elQxY2loYU5qZWMy?=
 =?utf-8?B?M0xuSUlFM2trY1JLQjB2TzVtcS9HM1RRZFYrMTdZUFNaQ2tFVDJBRU15Y1JI?=
 =?utf-8?B?N1dYUng3cHFjelBTc3k3T2x3aXBxSFl5SWYwYSsyRzI0SEJOajY3a052Szl4?=
 =?utf-8?B?aUVpYVdBNnAxenY5Z1JUQUFJQXc0VEo5T1JBSkx4dmx5RW9nbHpzVkdpR3NV?=
 =?utf-8?B?V2s5Q0FtNzFSa1l6R2FQclBJdWt3cjJtY2dTTGNKNkIxZHEzcmlFWENzMHp2?=
 =?utf-8?B?V1E0N2UzczhteXdKelMrNWhmYk5GbVdPSklCQ0oyS2J5TG1KNlMyUFJQdVh3?=
 =?utf-8?B?aFdtbHBLdnJuL2hQUHRBcTRGR2VUcmJkUU9KNkdRd1JqVjRDU0tOK0FyakZN?=
 =?utf-8?B?cG9ES3Job1Z5ZkFZS29QSFNPVUIwVkZIZjBOaXZJMVZJa2krQ1Q1NlFYcEpl?=
 =?utf-8?B?MFNBYlBHZjBQSE1JRVVTU2pMMXhLWVQ0cTZaVGlianpSUGdPUEI4cUdvYXJo?=
 =?utf-8?B?aU1aTE0ybUhMbTRXZFZLRXVqZFZucEFQTDExNTVDYjFEM1VoRXhJY2dweFNs?=
 =?utf-8?B?QlBBcTlyb280c3JWTUJ6SWRnUGU4VkVpLzNlZUNSUlJabnp3Uno4RjlBVjE1?=
 =?utf-8?B?YTBBT0ZTcS9xbHplRXFwUTJVTWVBbEFualdMRGV2YW9pSTNsTVlFUzgvb3g4?=
 =?utf-8?B?ZXlsT2N0OUJabWJ5VFJBTHhTbUNONnFhS3hlZHRaVW1kTW1ncUZiYm54YWZt?=
 =?utf-8?B?MzBlcDZJMGJwWDVFd3ZqUG04K2NCM1U3K1ZacDdNdWp0WS9CNisvbEkwZ0Yw?=
 =?utf-8?B?QVNNOFoxZEdqUGtVb1V5WlNkWjc3L2x4L2RrTEwxTFpRWlJuZzJQR1JRcHV4?=
 =?utf-8?B?aExNRSt4N0pxQjJyV3JDMlJuZTRZNmg4NVlqTG4vczkwRmR0UHVKdU1PNWkx?=
 =?utf-8?B?YXVFSThmV1Y2U2JBY2VDc2hseDJSeWVZRlFUZVo0K2tqVWMwMnV0bjh1UGdB?=
 =?utf-8?B?bHdmZ3hOc1hmdUlHeXNuT1NhaExYWXdKcGw5K2FmNFgyemE3NlRMWVJOeFJm?=
 =?utf-8?B?M2o2bXNJcU8yRlBCcHU4b1k0VDd4eVJCQmxZNnlneTMrRkZkQ1liSWJPVUxZ?=
 =?utf-8?B?ZVF0cGRJNnRGbm5rMlJUanpqaDVZRjZodDY2SE1mUTJXenQwcFBjQUlWMzJ3?=
 =?utf-8?B?SksxL2R1MkhFeG1kM0ZFbHo2dXJ0Mk9NcjRYVGFDTEZrN0N1L1BTeTY5a25G?=
 =?utf-8?B?NWJVM3Q2dHZUSTZQY20zeXI3M0d1SmlHSm1QcDVVcVh4NTlxYWZrZUpkb3dx?=
 =?utf-8?B?amluckh3cHQ0U0FYdjBBSVFSd2FZR25paS9CZFVTUzkxbkc3bXdKOGszeGdh?=
 =?utf-8?B?bmVGWWNlTjdUNFExM1dCTzhicVlhTHE5LzlPUkNsUFJTUnhTSmh6cWorZ0Fz?=
 =?utf-8?B?RzFGWFFuRXcyVmEycW1SNGI3MVU3YWo0WThVdXh0WmdqZDhueFVvaks1Snlv?=
 =?utf-8?B?Nm1IcWpuQ0lGNlZyem9KZjJteUNDNTFScHRWTDc3cGlCT1NtYW5xVEQ0RWY0?=
 =?utf-8?Q?j1mta8M12n6p4rTASyh7QPqTopEqbZDI+GzHiBv?=
X-OriginatorOrg: kunbus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d73e556-dd1b-4c76-e2d6-08d8c9c11215
X-MS-Exchange-CrossTenant-AuthSource: PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 10:30:34.3415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: aaa4d814-e659-4b0a-9698-1c671f11520b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0eSNCS+MhOmTFboqyKkVEToKrE97JzXqVbhBbaTJiVdY5Dd5M8005nr12tuqWRU/Tx0Ih5/Iq0RO9kg0pYrRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P193MB0539
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi James,

On 05.02.21 01:34, James Bottomley wrote:
> 
> 
> Actually, this still isn't right.  As I said to the last person who
> reported this, we should be doing a get/put on the ops, not rolling our
> own here:
> 
> https://lore.kernel.org/linux-integrity/e7566e1e48f5be9dca034b4bfb67683b5d3cb88f.camel@HansenPartnership.com/
> 

Thanks for pointing this out, I was not aware of this discussion.

> The reporter went silent before we could get this tested, but could you
> try, please, because your patch is still hand rolling the ops get/put,
> just slightly better than it had been done previously.

I tested your patch and it fixes the issue. Your solution seems indeed much cleaner.

FWIW:

Tested-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>

Best Regards,
Lino
