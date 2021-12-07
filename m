Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6025B46BEA6
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 16:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbhLGPK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 10:10:59 -0500
Received: from mail-bn7nam10on2052.outbound.protection.outlook.com ([40.107.92.52]:28288
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233627AbhLGPK6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 10:10:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URMSqkPfkVkYloELNmEUO6uyvuAIJq/mjC4mtUWGNa7YssgJdRsKUZPBeDHhrpwO201vSNb8TDjAIaZrzaCur8kz+Yl3usMsLSNQD8zPAPkqMJF9vCOjSYyq/QKbZP53JQEgl0KMatORw2/ucX+PbqvZj47VHLNW9eFYREY8Kvz1ycoBcGt1URoYahKz4upNjuNsn8zMEh8M4vsNp++t8sieTT7mPkuPXrMDloXmkmmAZFC4Qhxo0Hut+6en/qJ40VdEwIdCdC2SxsT5SlP7hCWtcLil7NTD5qxIJQ1uY+s00S9r02zpBu0KVavHrBZpLQ9tbptsWDhcDS9zeaoUbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UF/VL7a9NEjOXbeNZXeu6upjqVijJ63PPFhWVA1ourI=;
 b=n8nMFfDe588m5goVdFpyQXIhc9yk+n4aI4QdUXF2oGs1QytQ+VuEwALE8Bq4Njs5fuNujfB3ifGuMEgB34M8yUD1XCuhkyQWXD8puLAbh6m2+Q1HPvR53ZK7ocb1dPWnJpTRU9s/TYw1PNTe5rpfxcWvy20xjw2E2SFY/cYD9CM45x4phVEFGXrOKaDOMD7slxT7mCe8ExIOjeEisX/pnKTgQ6CAMpptGFddfi03Rkxa3resRDO+qFPo2KpBCuINZEarH94kRWa3k88X7AzlvSlgyCrB/EWQu8fz5n1Rqykl7e02Rn46Rd7ZFiJQ9E/AiFYOfeRlK00sdbVe45o5pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UF/VL7a9NEjOXbeNZXeu6upjqVijJ63PPFhWVA1ourI=;
 b=OACTNGIhnQsL6q5JqBHicvWHbESZ36YUHe5Cvoy6ZPNEVUYAuR0T0fFh6GirDFqTJFDqK2iiEr152Tp014MszHNM6YxYylruqNEdFF9sTxNQLjgnSsTmTVSnTVkiLR9P7PbNqa5ReM637m2DwMdUNwdHOti0fFl/lQlt4DVRqAYysEChuZxRmwO/nEAjSt5Pp9IJavgKr/pfPnklWflUF7xyUf2KWcE7CHTTG1tIxh3ZaVThfpOR/H5tHpuKkaRqpBkVPQgZmKF6v46iMV5iEJPtkGcLlcet4S5kQRn0e4humuGoVJdvi+YuHpNRt1WvYIeyFeYsmCcge4ShOW32EA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CO6PR12MB5443.namprd12.prod.outlook.com (2603:10b6:303:13a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14; Tue, 7 Dec
 2021 15:07:26 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ecac:528f:e36c:39d0%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 15:07:26 +0000
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Dmitry Osipenko <digetx@gmail.com>,
        Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <2f29f787-7c77-a56e-3b90-0fc452fd1c88@gmail.com>
 <9c21aa0d-b7e6-17b8-cd1a-f12a2b2a1a57@gmail.com>
 <5e50e8a1-5436-b543-f15d-50c5089304e3@nvidia.com>
 <9da3de11-b6c5-b2ac-f4cf-e14c73ec134a@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1d373ba1-d2eb-356d-259b-db7743654916@nvidia.com>
Date:   Tue, 7 Dec 2021 15:07:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <9da3de11-b6c5-b2ac-f4cf-e14c73ec134a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0400.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::9) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
Received: from [10.26.49.14] (195.110.77.193) by LO4P123CA0400.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:189::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Tue, 7 Dec 2021 15:07:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e39c54b-5214-47f3-2090-08d9b9934714
X-MS-TrafficTypeDiagnostic: CO6PR12MB5443:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB544393E07E8F2E18AA43C750D96E9@CO6PR12MB5443.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZtKCxQ5qRHvSbm54tcyFjNt2RDplLPmfq76KwqzntxLyefXEjI6ejIjAWs4Sq1xahtu12iPj77aKYiSLtfOUu3eCdH+yDvBDpg6F8A1o6tZC/vgQA9f293Vz24t6ySu+9iaiSBnjDgn6ocOWzlJ74cLKjHeS8/DRhXv4+XS4czggXS0XwcLTQRuepQ0+GtAWWJkP1BXWxdiIPUmE8KLqll4QjmXIkMmTzvPgj3inRSKTMstqr92TF6O01WJVaH1DrmQYlLKPDgo3FOA50ybV82SNCXRNOvo17LTRXftwK00RxUkXX/nMR8YH5ApXAP64ye8aiEnLJDxND1gmFPk3dd+Pepr70tceKPdvTxU4wJNwsq3AjheirLdsZt340Z8nl3j6copy8SH2UT5+Kr5nG9ed8sXEU2Y/VbhQTZspGlJ0O5/HVqou2jnGGMHXHPMfP7chPjXiFogvLok9cqoWglayLdiRRuSMhrIt63B9kygZJE4FCnmGF4GEi3UfNyYSUZpapy2oX+1dPblZDR+cJ3tr1+z4n6dQDXx23fk93Sp/I43ZiuKG//rV/Nm92C4Tl4hg/XF7E9u035htXHYVfcc4jUVQ85q4SONq71DoDgtZ18ytR6qXgmiX+91FwTEf4EI++AhTEhTDlYd6e1mhaLzfa1v0mI3PHesukuHuEiz7KIwr7cpkJ4OGf28RTF64U7y5rKMQ9KhHVJJa1L/0X1XFfO/Cg/YaYdhVoeEm9SEbdmzqkOAAynRADQmbeXz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(83380400001)(508600001)(16576012)(7416002)(110136005)(31686004)(36756003)(5660300002)(186003)(26005)(956004)(316002)(38100700002)(66946007)(6666004)(86362001)(8936002)(31696002)(55236004)(4326008)(2616005)(53546011)(66556008)(8676002)(66476007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXN0SDZZWDhJblJPenU0dHZyVmF1N3QvRHlGQzZHU0NYSytLOXd5T1RLYTFz?=
 =?utf-8?B?aHVSZkV3R2pRS1YxeEx3NDJuRGVkZ1l6NGJldktEa01uNUNFSUhVcEtvdEpX?=
 =?utf-8?B?WFRsZjhOUGUzVGlYNFZMYWtFQmNwQ2tnOUpicWxRQmFEcXd5VUJ5MEp5QjZz?=
 =?utf-8?B?ZmhyUldBdUlMN2d5bk9ZeUMzVmFEbVFjTVF6NmhnMndyd25PeVlPbGw3U09n?=
 =?utf-8?B?cGtydVdUSmVjQ3FZUXF6NzFZRkRnWmxidnV5M0R5aTN2UTZML1hDQ2hKa0hF?=
 =?utf-8?B?M1B4d2U0RzdPSTRHZDhJTVRxOVJFNzBzU05vMDdFWUpXUGMrYXNmci9UL3hT?=
 =?utf-8?B?MmlCQVE3dHpndzNNalZ1YmNBZFlyb3BJL3cvZjFLbGd6WjBwcHhkbzVGTUp6?=
 =?utf-8?B?S3ZIVUI3bS96U0ZuZkdEalk3WXJrc2Z5YlQxZHZUUkdFbjkyUzZYb2hKaFdj?=
 =?utf-8?B?d202NVpyUSs4UHptQndqM29oYkdaT3p5NGxqeWF5SHlnc21GWFlvb1FMUndT?=
 =?utf-8?B?em1ISW1wck1TMkd0SnlwN2ovN0xDMjlFaDhPK2ZjMFIxV2lEcnBTZmFJRHFy?=
 =?utf-8?B?ZWhVczYzNk1QbEhtYTZSSlRUalFENWtNYUhCZ3dvZitNdjR0VmUvLzIzWith?=
 =?utf-8?B?bUt2SVJnL3U4dFNDeUViUGtac013ZllsSURNaEVaT0JzQ0dvSkJzQXhEb3cv?=
 =?utf-8?B?QVZPMnhMUjBzK1ovTyt4encxZzcrOTVQTzBLL1dpTU1zNVdST095THRZWHlo?=
 =?utf-8?B?RzhBOEgvbkZ3eklXZ3JwcE5taS9LQm1UaFZyOWZJaUNFTGZZK3IwRTBoSitw?=
 =?utf-8?B?WHd3Yjk4TXRvZXVCVHlkakpBOUxpTHZkS2JiVmFoZmluQVp2MENoYVVMb2tq?=
 =?utf-8?B?Uy9Oa0UwZkk0NFYvUHlRNUd3S2M3UWx1UkZoYUFJdGhBQS9vMnlPTW5FbVBD?=
 =?utf-8?B?ODF4aVU2aDNVOVcvTGNxTm9wYWwvQUZOUFpKRjlXT0ZaQXZGTkxLZHFrc3ZQ?=
 =?utf-8?B?Q3dvSFZCOC9qYlNpMkNOSG1TYWNoV3h5amFMQ1ozY2cyWDRJUFRYZHVGMENE?=
 =?utf-8?B?SXZTdVpUbGRQcWJZODJrc1F3OWRWRko3eEVzNk5EOHdxNEtOUnlxMDlEdHNm?=
 =?utf-8?B?OUtoN0hLNDRuMGlMYksyM1BzTkJvWm4rWWpRd2xvTVpneE45dkIxRnoxWDQ0?=
 =?utf-8?B?V1hIalgzb1IxWWJYMUlFcjhvdVRaSGhzYW9Jb0hQeFNkTnBZZEFGTS94bm5z?=
 =?utf-8?B?bE1LbHBUMXBDV1RabXJoT0ViaDFBNTdJY3V5U3VhWDd6Rk11a2tTeUlVZEl5?=
 =?utf-8?B?VzJTR3VYZnNoMmFhR2oySXd6Yy9xNm1nM1pQUTFCcnFzV291WjViUXAralNU?=
 =?utf-8?B?QzNlejVlWXRFZnU5bUVickFSajdQQWxsSExPeGRkNlBUZTA1ZFl6eldVTHNz?=
 =?utf-8?B?MUZ3SjVWaVhLMThlOTNpWG03TkJPYzViS1lQYm1nVGRyMHJGNjNmYWszVzB6?=
 =?utf-8?B?bUdXVDBMY1UyeDNEM1Z0TFNuTkJCMTFleEZJZjZkdGVSSDArakgzNEJRUHdv?=
 =?utf-8?B?cE5tZjBZWWVGVGplckVuM3M0bVJrUysxeXQyLzRudHlITWhXRm5hMWVtaGNM?=
 =?utf-8?B?NnBLQ3MreCsyd25rU1NFdDYwODMzcDEvVzAwYVlLQXNibUJLSTlsc1ZMMUR3?=
 =?utf-8?B?UmwxRWJnVmJQNDdnWFZjcmwrZklYYkRHbHB2NVlsaUVhMlp3WitvS1ladFp1?=
 =?utf-8?B?bGE2RExFbkZUbnVRKys1cWFIUE1ZSVZpbVBPdDBEL2FYV3RmaE4wODl5SGtH?=
 =?utf-8?B?S0wwRjJkeWF4ak1lVUNsY2w2Q3BSRWZCWndkZHdUWmdZeS9FTys5RWNWdjR2?=
 =?utf-8?B?bFdZZk1iZy8vUW5CcjBQSUhOdkJVMnA5S01ickNjTVoxeTVDT2N4Q3R5MXJG?=
 =?utf-8?B?ZGVBc09haE1zdWQvQmVXZzViZmNDQzZzak1DWU5YSER4dHBXUXN0azVibHpL?=
 =?utf-8?B?R2lTa2cyeDZVQXJKVjVCblV0b2NIQkxCWlpab1FWWk9FWEtxZXlhT0JvQlI1?=
 =?utf-8?B?d2drM0NWYjlWK09BVGw4SWN3RC84cWswS1BIZ1pDVjBhZ21BY2pUK3JqVWYw?=
 =?utf-8?B?SGRZS0UvZ3J2UklWNVVGMVBIMFFRUkxOR0t4aVhkeTVUNVRaSXB2WHg0ZFRR?=
 =?utf-8?Q?Qxo4yyR/4nqtq/GOTqmJPu8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e39c54b-5214-47f3-2090-08d9b9934714
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 15:07:25.8416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eeIWDud54UZFqKg1ah353p4HV9GJotSjb4Bz+6g5TNnlXxaPOQ+9HL3iTRH5a21sUJYiW0g3jobWUI7bi9fy2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5443
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 07/12/2021 11:57, Dmitry Osipenko wrote:
> 07.12.2021 14:02, Jon Hunter пишет:
>>
>> On 07/12/2021 10:58, Dmitry Osipenko wrote:
>>> 07.12.2021 13:44, Dmitry Osipenko пишет:
>>>> 07.12.2021 13:22, Dmitry Osipenko пишет:
>>>>> 07.12.2021 09:32, Sameer Pujar пишет:
>>>>>> HDA regression is recently reported on Tegra194 based platforms.
>>>>>> This happens because "hda2codec_2x" reset does not really exist
>>>>>> in Tegra194 and it causes probe failure. All the HDA based audio
>>>>>> tests fail at the moment. This underlying issue is exposed by
>>>>>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>>>>>> response") which now checks return code of BPMP command response.
>>>
>>> I see that this BPMP commit already has been reverted. There is no
>>> problem in this hda_tegra driver at all.
>>
>> That is temporary until this fix is merged and then we will revert the
>> revert.
> 
> It's the device-tree that is broken, not the driver. If you don't care
> about broken HDMI audio using outdated dtb, then there is nothing to fix
> in the code.

That's correct. However, we do care about HDMI audio being broken with 
existing DTBs and so we need to make sure they still work.

Jon

-- 
nvpublic
