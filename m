Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB71310D7B
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 16:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhBEOR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 09:17:28 -0500
Received: from mail-eopbgr10069.outbound.protection.outlook.com ([40.107.1.69]:24549
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232065AbhBEOOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:14:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1byB0YAqKurt+nAEYG072bs4xoNiPjrIVDmcw9IrnaRsXTrrjZX4rhP2wZyI0cRRoTiuTJNmnSM9xm8rr90kGlFrHRRCdsK6J6CMnvBu3hYOkC0hmYJ7mZimSJLLAr1y9bF8qxrAXRWjQQNxgVUvLoWzMvjYBeL1XI2Kh/vFm/PftrerPfI4n017j2IIFRKAPtC4EtJvaX4TpR8E4z+BePMho74WVpbDn9QqumPqPSzN5CISHX662PR83GojT/fDP2gKAQsSRbE5IR9FO3srruk4ebTiOiiwnbVgxfmkkxaBi7svqo8AgCS/LGzsf24P0iMZla6s9n150HnNAau3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oizDDIKhW8i9GIVRqfU+JS0FyGGFit+4KHAzbG2ziBQ=;
 b=RJ5dTq5haxyfTQf40S+7MkFRxsVSL/cZ0wr04YAxTDAXuWDD3Xd25K32K1y4JJ+XmE6CLkLNTCBs5wf0fSL/rnncBGV+QBsjlPuAisdxkgK0psVRJY4svHWKVfZ96Qche353Z1VpUyJYQoe9khCDKsJgmZ+eWqKozjVa360tl1oDmYKdHioyCKYWHsOIkxhGK6t51LCaxflo6xP5FS2q14DIp8Y1kzlHfFzlxw0jK+g2w7op4kCr2qqWzdiMYpx59NADGJCe4CppFsxETcLU7t+AoliOZUWjw+ihRxjVV0YyW790Or9nEEAQDrWlJuksR7ZXXEEPHitwVv5atGX4ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kunbus.com; dmarc=pass action=none header.from=kunbus.com;
 dkim=pass header.d=kunbus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kunbus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oizDDIKhW8i9GIVRqfU+JS0FyGGFit+4KHAzbG2ziBQ=;
 b=Tedu+ds9mGh1IrBlTC0LEMLdmr8YQ12rUGrNSTRTfHO+vc20taW69q+UY1P0yKTGybp7iNbTYEEd3QEKaFraXLg12OM+cJbKMKaOItph9UfRwZffm7wadrKOAJ6U+glYX3IYcF4o/oNW2C1aNjs1Gt/LIOlsNqzLwRnkVl8/rTU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kunbus.com;
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:a0::11)
 by PR3P193MB0620.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:3e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Fri, 5 Feb
 2021 15:50:14 +0000
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73]) by PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73%5]) with mapi id 15.20.3784.022; Fri, 5 Feb 2021
 15:50:14 +0000
Subject: Re: [PATCH v3 1/2] tpm: fix reference counting for struct tpm_chip
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jarkko@kernel.org, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
 <20210205130511.GI4718@ziepe.ca>
 <3b821bf9-0f54-3473-d934-61c0c29f8957@kunbus.com>
 <20210205151511.GM4718@ziepe.ca>
From:   Lino Sanfilippo <l.sanfilippo@kunbus.com>
Message-ID: <f6e5dd7d-30df-26d9-c712-677c127a8026@kunbus.com>
Date:   Fri, 5 Feb 2021 16:50:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210205151511.GM4718@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [87.130.101.138]
X-ClientProxiedBy: AM3PR05CA0134.eurprd05.prod.outlook.com
 (2603:10a6:207:3::12) To PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:a0::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.23.16.111] (87.130.101.138) by AM3PR05CA0134.eurprd05.prod.outlook.com (2603:10a6:207:3::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 15:50:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5faf711-a9aa-4fc1-55c5-08d8c9edba77
X-MS-TrafficTypeDiagnostic: PR3P193MB0620:
X-Microsoft-Antispam-PRVS: <PR3P193MB062058D260C331F25FED00F2FAB29@PR3P193MB0620.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WXgu1rHTmfmqGDwlIllB7PlGYJTcdYRBYwgPU1g/jt994LsP8hxwqNNcqgrGj1RV0KpSvX1HBuHcYJdDzCNWqIqTFkVaXbUGwjT3W3Ukq2GbH5+hPPQC/K7zOoQlA146IvhEDqqhrLxlZ36xmz1o2I8fnFi/pIRIsqNrXJgApIylT8Y8vL3UVwKgpKl31UhixJZnq4YBxzRGRpZ7T82CM/HM3UtclUldz/knlDRap0vTInSWuRqIPhV+Pz2YTKuKxBpoWdNyNGJP+MlgzUonlKMTKjT/iSVIZ+ZeFOPuvpzIGVUZu3yM9JTZNFnq4doaIG8x35ZKchaRgY4K/z0cjFyv6otdrj22ZwbsRYgsoPl1DgR60MAx0uZFvgznrS9VeomJDuSd2oYcnicevpikAf4yXWO2COASzK/mZQrMmbTeG12qAc5NYNHUJ7qbgN4Tx1Ic9oQdoo0+Yrd0+yBjJWFG62TcYPBq1zRRMgklacznnre/V3Tu0kNPEDRBiMP0E4rXQuzdOexcLPnDSsPhYfAjQxvaq3LBEgfIhESFgSJAjof148jEt3djdu4uwxjcHAemZJFwpCQfUOX5PJAWuuuZvw4o0F/W87MZHIrudzc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3P193MB0894.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(39840400004)(396003)(316002)(8936002)(36756003)(52116002)(5660300002)(2906002)(31686004)(2616005)(956004)(4744005)(66946007)(186003)(16576012)(478600001)(26005)(31696002)(4326008)(53546011)(8676002)(6916009)(66476007)(66556008)(16526019)(6486002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V24xWitQZmhiRlo3NW0rLzkyS0pMYUk3bkpNbDdXWGN0aXZmMlNvUC81M3or?=
 =?utf-8?B?SVdyODdObXROWWxqSDMvVDFSYmpvYnJjenVocHlqdFIvMk9CMVFlUjR2U2xU?=
 =?utf-8?B?cTNEd29DWlpJNjl4OGl4NHFKZDc4U0xybmNZMXpUdlJTelNkZWRzSXl6NDh0?=
 =?utf-8?B?MXVlUnVGWGQ1WTU2c0xoQ2hxaE1HOWdGMW81WWlEY0FYYXcyakQ3aTY5M3NI?=
 =?utf-8?B?NU1IUWl6NFZFbGtBS3dSeE5yZWdGYlNiYUQra3BRaGN2UlE1M2c3eWk5ak9p?=
 =?utf-8?B?UHhISWViRk9DTTBBSmtkVThHd1VjbGdCWndyWWV3K0F1ZFFFbFN6YnFGL1Nh?=
 =?utf-8?B?VmJkVThOaWdrVk9IRjVOOVIvM3g2SWd0a3h1U3o4QzFCWi9ITms4Rm90TUJx?=
 =?utf-8?B?Qll3azJNbnNkU0duL1RKQStSMFgxWG1pN25wQTVubmFCTlNhSmRIRUg4aDhm?=
 =?utf-8?B?Qy9oejYvL3F1aVI5NVN3UDdBTGU4NXViS3NZdkcwYnpTd1RJT0JnZHVGKzRN?=
 =?utf-8?B?UlBVL1dJWTNBcVIwNEJ1V1JTNjRjdFQ2d1Y5RW4rK0Q0dGhQaUVaUDZtcW9O?=
 =?utf-8?B?VDkwbDBSak1taGlvRlJLWUJ1TVRleHBkb210RmZSUUdxQS9KRjBqRGZwS2Jw?=
 =?utf-8?B?MEtPdzZSR0pTcElGNmlsTWZXWElMMnlDUHh0dmRId293VklKNWo4YzBEN0Fp?=
 =?utf-8?B?K2JSR1Vib2dLcDh4WkhwQkxZUG9RbDIxUFBJOWQ1ZXVRUEVlcTI2K0RTUjNL?=
 =?utf-8?B?S2p5UTJzWmlWaHRjeXpNNjJFZ0plamgyOUJNclU5MzZhSWQ2V0h0a2tOaUtF?=
 =?utf-8?B?QVE5WGIvNEFWdm1ucjN6UDBjZVpQczlyazNlK2JVMWtNbVQ2ODFEWmREc2JX?=
 =?utf-8?B?Q2h3N2p5R3JRRDNVaThaanBoMEQ3WGRTWTJWR3VNL0VoTFhYODZsOXduWEpv?=
 =?utf-8?B?eGVBdjAzeTJONSs0czdyTDRqTVJxZWZGd3cwbHJVMzJMeEpjL3gyNXhVQ3BY?=
 =?utf-8?B?SlBlT2NLbGJpUXJEODRwQTk1UXhsM3ZEdzlVRm9MVHpaa3Jkb3EvYzBJUngv?=
 =?utf-8?B?Mkw1YjVwSzFvN3VLeGRwOFNtRnNURWgvTTU3NitCT3kwa1plKzcwVys4Y2hm?=
 =?utf-8?B?SU8zVEVlZGozV0VyN20xRzFONm9jdEZHUGUvQUxoc3dpOG1NejdwMjBQUU1x?=
 =?utf-8?B?aGQybWxESG96NEE4RzNTdFJHTnBXcUhramRMaUcxMlBSdlcrd3Z1c0dhYm9t?=
 =?utf-8?B?M1N0bTMralFWS3RIR2ZBVUUzRlNYSU4xYkZId1VHQ0xaNTVDMElSdmk5WGxH?=
 =?utf-8?B?NkhtYlE4V3pEdWpDQXJQZ2xobWFDTDUwSm5kdWhDcm91TC9SMzdTYUdoNXVR?=
 =?utf-8?B?RWpwMC8xRlhoYnNxakxmYlcyWGh6QXZ5RFAyTGxpUzc1YnNSMVVDaXY1U1dZ?=
 =?utf-8?B?V3BHdGh6Q1dkMSt5Mi8vQzg0d1BVWGg0d2YvV3BJU1JxaWFLY2h5dUsrZG5j?=
 =?utf-8?B?bDZpOG1uNnRSam5OTjQyby9JVVNHdTM1aWpzUE1MNlNMSXlsZ0Q3ZmpSTmVO?=
 =?utf-8?B?RWVEdno4eWNjQWVZRVZRMUJidW1KYmJ0ZEV1OW9IelY5TjRtaERSU2FyMGt1?=
 =?utf-8?B?cGdSSFg5ajJWbStMdWNzTU9EQzY4RWNFVThwbnN5dG1Md0VxK3pEdi9JTmNN?=
 =?utf-8?B?U2ExaGt3T2ZpZG8rRjhxVEl5ZTdVaG4yM2NyOXp4QndQbkZNdDNWdGRPZ3pH?=
 =?utf-8?Q?4RhaMLciZxoxFoOul3PfNyl8oZ6TEE0c5W6+kGu?=
X-OriginatorOrg: kunbus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5faf711-a9aa-4fc1-55c5-08d8c9edba77
X-MS-Exchange-CrossTenant-AuthSource: PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 15:50:14.6725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: aaa4d814-e659-4b0a-9698-1c671f11520b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3yaXwBnlOeRJcxo/c5dKGKdvDcd7E1xM3KZdgu3OP9EKeNCN0AvlZ/x+FtaGjmWo2kpv+v+XFisujbEq+VgkBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P193MB0620
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 05.02.21 16:15, Jason Gunthorpe wrote:
> 
> No, the cdev layer holds the refcount on the device while open is
> being called.
> 
> Jason
> 

Yes, but the reference that is responsible for the chip deallocation is chip->dev
which is linked to chip->cdev and represents /dev/tpm, not /dev/tpmrm.
You are right, we dont have the issue with /dev/tpm for the reason you mentioned.
But /dev/tpmrm is represented by chip->cdevs and keeping this ref held by the cdev 
layer wont protect us from the chip being freed (which is the reason why we need
the chip->dev reference in the first place).

And yes, the naming dev/devs/cdev/cdevs is quite confusing  :(

Regards,
Lino
