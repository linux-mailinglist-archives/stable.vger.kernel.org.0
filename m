Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCBC32EEF1
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 16:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhCEPfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 10:35:41 -0500
Received: from mail-dm6nam12on2088.outbound.protection.outlook.com ([40.107.243.88]:32257
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229493AbhCEPfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 10:35:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKQOu4ynjjaY90HkcgexBsHZzG8rIDZ8Jwe1rpITcUUfW/7kOcdPKNw3Kyo2D9qS/UCdW+08Cl7FEF2p3oVKxwiv7hUCWPnMXDMidDRVre4XKH/rIR4Bsh5lNIyrCMzV8XoHPFeHfrfab2s/mlM4uID0koTn0bpJ7h5HYeQmywCf4gnbgTehH/9wbD+Url/peh/uyxldWkz1maDqTk4EbsHS5pOZO7tx77UDACQnEHNrRJnWvTkMnxGeAO4k56wGCj5YHyGPQ9Z4+ob14EziSBmt+C27e1wvUs5eixOZ8ZXmM2UPbHujUQ345CcDP+ziigNxfm3wZIy7dHsX/D3ZGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yAo8HNPdG2my5ygZyWP7+c+nZJmkLuvxytN/DmUSRA=;
 b=iydscFhPiDilTvAnhGh/8l/0cLGrSJUYF3PURq4DZ+DVd6ALWKL5BbaykbMVISLqoU/PB4/R1LETnP0XTcY8N1/4MU1ms5vdV+AMLtt/w6qBXh8c+KbtCRAxqNGssPUMp6Nii4Ts+oO786fUwRGccuR71JdNefC9MPA4D9rmgSmvYxrqOJ850YXIi4hg/emJZRTbi8jnUohEacQF9ymAvPaNF6sjFeTKDuooMdlMhzK2Loe2qZVKiihmh2jXM3FeS+80g+WHRbDxCtQx10KUraS63EvYtje6v7L4eHcw95dWAvv0Pp8xX/9A/ucDfhxO1Y0TIFcEAbXVZecNdI9hVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yAo8HNPdG2my5ygZyWP7+c+nZJmkLuvxytN/DmUSRA=;
 b=FcHPZNann/dm1cKb8Ep970EyUAI5mc0nal8XQibvf+U0v06sZ88mWjTlQq+TgLZZ7w+pwsAyAHlre2z/1E8JQS0Z2/EzbcLFZ7I0s+zJR5IKEDOdXDEvPeApI41bC0vRyVJbYoLPVRNyMQOSutko+eFxfU9olrDoCkIgT1O24ac=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4048.namprd12.prod.outlook.com (2603:10b6:208:1d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Fri, 5 Mar
 2021 15:35:34 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3912.023; Fri, 5 Mar 2021
 15:35:33 +0000
Subject: Re: [PATCH 5.11 079/104] drm/amdgpu: enable only one high prio
 compute queue
To:     Sasha Levin <sashal@kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Das, Nirmoy" <Nirmoy.Das@amd.com>
References: <20210305120903.166929741@linuxfoundation.org>
 <20210305120907.039431314@linuxfoundation.org>
 <23197f54-020a-691c-5733-45ce7e624fec@amd.com>
 <MW3PR12MB44918AD858505706809367F3F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
 <9f12d4c6-35c8-7466-f1bc-bee31957e11b@amd.com>
 <MW3PR12MB4491E72712027DCBB8486E59F7969@MW3PR12MB4491.namprd12.prod.outlook.com>
 <YEJOt6KXCzNb5y+x@sashalap>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <1b5bfcb0-3860-bb81-f0ad-91a522beef0a@amd.com>
Date:   Fri, 5 Mar 2021 16:35:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YEJOt6KXCzNb5y+x@sashalap>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:ee4e:e545:33e0:7359]
X-ClientProxiedBy: AM4PR0501CA0051.eurprd05.prod.outlook.com
 (2603:10a6:200:68::19) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:ee4e:e545:33e0:7359] (2a02:908:1252:fb60:ee4e:e545:33e0:7359) by AM4PR0501CA0051.eurprd05.prod.outlook.com (2603:10a6:200:68::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.18 via Frontend Transport; Fri, 5 Mar 2021 15:35:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f31223d-1240-4edd-5d9d-08d8dfec50da
X-MS-TrafficTypeDiagnostic: MN2PR12MB4048:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB40480C5262E10BB3E82B22FA83969@MN2PR12MB4048.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: msBdntCN6Ff8BMvxhQaPNK4VaKb+hZq1tZ05OOoTzEk3oVwa/jTfPJ6HXTpM1Kvvb2OYvz4sPgNGKhxMIUbPA+iK3kZuijGWsS5GaaggjFjzfHwtBopIc1q9qzh5x71buPJ8pBtU8EJJPyH3b71w+p49V6OnDjsVLEXLJVMP7lXVrCCYD5U/60RyXPp7k+NtbLWMY4tRuBkL4w6QOvnsK6QVuIfuloZ71bxFVizPHsBmZVqK9SQwQBkdKkQaw6mryQ/tSuUk4Gy/pyknW50DtHREMkUkJ9cdzr2/4lLksOsBjsUVcHWh/7qSMj6vUpBRjXlNYnCpja/CgCvsuGzVsQtTrmhyCFaXbwjuv8tKnMFUAAIVCFEOMtiY77JI9zP++Lt75FmXeybxOCLeftKjl/NGY1m+dNR9xMZgDbqcX0+QqXQnsBNn+5i6Wbo+CV2+Odsg320BtAqozmGaETHH0ZW1qJ/PDu87tEtLwCulrBJ5YQmfZj6qydyWjZCrUp8oC692PgIngSYFw747grJg1wROKaArjRulIVecfOnr3Aat3InvgtkMuaL8X2eLjOAwMTBbKMIJyokixBkZN3LNohrwMNlPDPw1Lrqbf/RB0Ho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(110136005)(316002)(6636002)(54906003)(66946007)(66556008)(31696002)(5660300002)(66476007)(86362001)(52116002)(6486002)(478600001)(36756003)(2906002)(4744005)(8676002)(2616005)(31686004)(4326008)(8936002)(16526019)(186003)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZWJEOFpnMHYrK2RjOFdLVWpQdGZGVUEwV2dQS0dKMzZkblR3WjQ5S1JjTDhN?=
 =?utf-8?B?cGttUDVFSkl1QURNRTRmYlRJR0w1UGcweFpLaGVvUDFxNEtnMTdNZStqRFFx?=
 =?utf-8?B?SnFmM28vZDFEdG9zeHBLSnc5TmprdlI2a3dGRktBZXlDSDF1OTRJQm1Tb1VP?=
 =?utf-8?B?NkZUVmk2aHh2bVJFV3V0dmNOdjRPeEpydW1WT0QrdSt5cDBXUWpiY2hDMnp5?=
 =?utf-8?B?RXpWZjd5SWNHUHZLS0JDeHlPTUExbnYzalQ3OUd0ZGV2TUV6TFBOSXlxMzdD?=
 =?utf-8?B?NmhtWVVLeC9mTVBEbkJtWHVpVlRpQ09WOEdiYTVicEorQkIvMjdDSVRpSDZI?=
 =?utf-8?B?Z3NiUENTUVhIZ3l2anZaMFNrR1FMcHlzZCtscWF0Y1ZqUnpxNWx0N1Z2SDVr?=
 =?utf-8?B?Ulg1aVVLaXcybjVhUU1DcldLZmd2eVVBNWZabS83NitCTEh1T3ZjZTI1VkZU?=
 =?utf-8?B?SXh3dVI3SHBKMkYrWHJIRDJQdlRZdXRHMXRGVzVRZzJTbWwyQU1MMmREWi9n?=
 =?utf-8?B?ZWFtWGFrSDQ1N0c3Tm8rL1QrUEJsTk5oUEpyS08xejBodWtTejhTdnoyN2k2?=
 =?utf-8?B?S3JYcngwTkRucnRzcDJxME82cDFteGJ3cDlyRU5hRWdsUmxqbE51RHFZRU00?=
 =?utf-8?B?K1M0MzN0dVFmODZaaDBtU1BoYUJkckRiaEI0SStlUU9NL3ZYS0J5TklSNjll?=
 =?utf-8?B?dklJMGoxWG1DbERRbXFGNThOM1pwMUdLM2hZOVBaQkp4ZmluSVVHcGhkU09j?=
 =?utf-8?B?ZmdwQm5VYXRVeW90ZGdDdGs3YlhSamw5NHBmQkNhRUUxaExVVnFoeW5mSHhy?=
 =?utf-8?B?ZXl5M1NKckRBK0preSs5UHlCUjhQUDhXV3A0VlM0dGowaTFUYnJsRzRMQ0pU?=
 =?utf-8?B?STRYcW9TY1lGTTRhbGV0QThHNXJ5OFN6WkJ1OWQ2eVRuQUI3ZTBkYlpwN0JF?=
 =?utf-8?B?S2FORFlGWmxoTDBKeEpGa1NKSzE5SHVLaDBBTVIwOG5FOG9BU0duTjlSMHRl?=
 =?utf-8?B?UFJ2UHFnNENheVBtd2VUQmgvbVErSnAwVjhwUFY5eGRzYks5SmIyZ2szbjN1?=
 =?utf-8?B?TXg5RHJDejBnT3MwN0hqKzAxR2htSmlZVlN0Umg0S1FrRnYzb3A4UllubnEx?=
 =?utf-8?B?UWgxQ21NeXVvRHprMnUrUk9ndXdFSHJqQSsxY1dMajhJTFFhbjY3ZFpXcTlX?=
 =?utf-8?B?ayt1cXZqSmVIbW9JWVU0ZUJldG53STFzcWtIbFY4dm8wS0RCd0RraXZoL1Ro?=
 =?utf-8?B?Q0czcHEzUDFIN1p0RTd6SU54VHl0WXhYTlIrZk1jU0VsUUp1MVZUb2pLNG1S?=
 =?utf-8?B?cFQ1VGVkdjFwT1lFV1g4MTNQeTZSd0RraFdLZlpGeXdUeVB6NTNCNkxCeUJP?=
 =?utf-8?B?Q0xmeWZieWJqaVh5bkwvajR2cnhqZTRyOWtvb3pNc3FIbFZicXRrb3dLbU8w?=
 =?utf-8?B?MnRtSEJGWjRHWjVHRzhsVmFENFVQclVMeXI3NjVrVUhjV0llWE1WdUtJZEJo?=
 =?utf-8?B?WmtwVmE1QVZqVHhYai9sZnR5dDRXaWhZUHlrd3k0Y3B5cjFOWnFMTmZWcTd4?=
 =?utf-8?B?MWNVR0REYWttRlhOc2RJZndka3ltUnJVUWQyaXBod2puYytWb3pDdzRjajVX?=
 =?utf-8?B?aFB0VXMwbDUrK25Mc01HWHVZQ3IxQkJpNFg4LzZRWG95bzg3V2J1OFZGSkwr?=
 =?utf-8?B?RWgvMFFqeWEva1BRVzFZcTZuNVBXV1ZvaW1sRktzcXZLTlFVWFlLYmszeUVh?=
 =?utf-8?B?VitnUjY1ejl2T25QUkFmQ0RmcUdqZTBRc3lNVDhQV25tay9mYkltdHlld3c1?=
 =?utf-8?B?YnhWQ0RBU3lXSGFUQjA3cUJuZE1kOXdUWXVVVmFkZ1Q0MERORkxoczNqTkUy?=
 =?utf-8?Q?uV2plOOF/cyn6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f31223d-1240-4edd-5d9d-08d8dfec50da
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 15:35:33.7587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGgOTFY75vTaY5x35zTfiukBuwkbvnqTLrywrFoT4rb2zOYJlFhhphy2sz2bGAW4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4048
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 05.03.21 um 16:31 schrieb Sasha Levin:
> On Fri, Mar 05, 2021 at 03:27:00PM +0000, Deucher, Alexander wrote:
>> Not sure if Sasha picked that up or not. Would need to check that.  
>> If it's not, this patch should be dropped.
>
> Yes, it went in via autosel. I can drop it if it's not needed.
>

IIRC this patch was created *before* the feature which needs it was 
merged. So it isn't a bug fix, but rather just a prerequisite for a new 
feature.

Because of this it should only be merged into an older kernel if the new 
features is back ported as well.

Alex do you agree that we can drop it?

Thanks,
Christian.
