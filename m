Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BEF46BE23
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 15:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhLGOw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 09:52:58 -0500
Received: from mail-bn7nam10on2046.outbound.protection.outlook.com ([40.107.92.46]:33249
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229455AbhLGOw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 09:52:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJuE9XOvb7jW+AzVqP5NdR8wMnzq1wjgnenwryfzENCjeCRJ7XTRrkkwdEapOcRTrvCa+ZJicR7GMWenNuhTAu+ohWX4GIWPb2F7buWk5qTmATk3hoHdNvgFkoZDAEbf6JkA5UmlLYMra/Opn/VTD0ZLZPUglwyRfybHvWIN7Vb0UUHovxdapDZFtJC08nSYMqYDHqqa+Czju4V7fSn9G3kTiUmqKSMiHa+cE3JHZYzoz9ydE4Kz109paMBy9Xbf1XEAn4v80UWCGEiwQXcBzwz6XWUaT6W6Q1FEMEPG5F6tIvw7+w/L9doffodtkF4xhOn0UYYC2EyPH8gqx2jbyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSvd20MHhKAXyq5nWa3c9hb0357xIzbeeWz224iLUWI=;
 b=AMJFPZaEwjmr/ga4YlYTNcBi9ibFKQ7HN2MqvsIi+7EgoaEJzGVdbyZtny02Pyvsb3h5pCOM2mRWqJKtMc6qenomdU5HZDn9EVx0uUBPBJkBr2ra//F4Zv4mvrfHMB0uZQ6Jci2jnscPxzMtD//IJqvVsFLTSgoQ7YoTLX9uqlbN3SvNQb/yNce2x8096XJmMC4nMVfQ/eXn2tnIcyBxLka2hdCFYG3D8JvxUHVoljIHJaehBEeE149g0s0lKuqRpol2pasTrtytXjM+Ixln2sSse51iJqGId7W0JVPUGk3+U/unfkCTD1Bfzjc/Mcx1TubIG6pqWjHp19hEgRzKvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSvd20MHhKAXyq5nWa3c9hb0357xIzbeeWz224iLUWI=;
 b=BSMf8/sx+xGNEOXXJbKFgN1q4wrDWpvVvXrIzPtXNlH8NuGr7TvIZLl+uPB4GvPDYCN6cL8KpaodCmS0WOPQO1FqiZeM7idED8jKb9OW9nTbIfWAHfD0aLNYvdU2jmnwtUbTcUTD0O/mNwQIvBvBqeJx9uTjJY6B2LYKJSCnL3xyzNJo2xJkmVPfVhYGSSgMJ4WYwpzu8O1kRBf/InpoB+xCQbhZ0lnc9pxnODiN7xq5KOVqF0fKYE64c68KXk4oUY6aFrzrAletLkSr+7iR/WuQBjvZp8+e0+HXdna3bVfO/sm6Db0ACeHVn27PLvy/my/XVpO3rQDWAvADuQ9DNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR1201MB0037.namprd12.prod.outlook.com (2603:10b6:910:1c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 14:49:25 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 14:49:25 +0000
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Dmitry Osipenko <digetx@gmail.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohan Kumar <mkumard@nvidia.com>
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
 <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
 <4855e9c4-e4c2-528b-c9ad-2be7209dc62a@nvidia.com>
 <5d441571-c1c2-5433-729f-86d6396c2853@gmail.com>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <f32cde65-63dc-67f8-ded8-b58ea5e89f4e@nvidia.com>
Date:   Tue, 7 Dec 2021 20:19:10 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <5d441571-c1c2-5433-729f-86d6396c2853@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: MAXPR0101CA0015.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::25) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
Received: from [10.25.102.117] (202.164.25.5) by MAXPR0101CA0015.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 14:49:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8b1bf4e-0786-44ce-a20c-08d9b990c313
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0037:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0037F08E5E4E52640150202BA76E9@CY4PR1201MB0037.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wgXSiKr0VR81Ffqs+BTV1+Lg2Tr3dl6jozN81ynkm/e+nsExhQoypLzyOWUj45R9q5piBtuIdwOQW/I4wbHKJWJig6Qre1t8YTMzPX/8hwzVxd72TT6ikmSoiLGQm3CscMkPyzEITQBhZ3SqZy2+rIHzGaK+ueWEPvnMa6rQDDY5bwXtSxV5pbxlWxL+JdoKBUDkGQVoVTzksbizLJMcjDP2/ZcdHlmGmN1hOIZgfecTXp9D+BRYhSEqvSVNYzrkIICi9UrfUtZfgohgQBo8wSHDuX+Xo29xa1YnmK5vG8h3VqeAO+dpD9R+cMnnGC1lKtCkGuUEKp7UQs7OsJJc/CfkTK36hng1EpekQezdRYTZ/wMKCfGhUakbTXXA3aNEkH9Ocm8c7euczrU2nc2h8RfUonYchuO26hF4X5EOoE6j6ylnJtbMY5X9oR88emgwqOxaKgcVbn+Zk5uVBqdmXeORGhBKsNnFxfspPB4J3s1AId/1nj4Ff+YNjL6iXL/dfjiiJ0B+GO7N88KG29d0+GXF2BIRnTiCHytabSV73wV4FVx4J2aMXNQ/5fYA7t0QKXxpWSS73drr6IQPejFes+UDYqv+BgMaH8LtN9Z77fGrF5sAW+KJYyIm1I9bdSezLNOqpX2J0UBQsWtfKyLo1CT/gFvSg9xrtOVvqincdlnUmHHIGOzUcaOe4jAjHB3s1fMD6+O9ptfWp4OenotCAM9p7Fmqktpp5ZXr6hb9how=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(16576012)(86362001)(38100700002)(186003)(107886003)(2906002)(316002)(26005)(4326008)(508600001)(7416002)(2616005)(6666004)(8676002)(31686004)(66946007)(66556008)(956004)(66476007)(36756003)(83380400001)(31696002)(8936002)(53546011)(5660300002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bktFY09WK3k4bGNGV0JqZGppTUVtd2diUU10eUhtR09PMGZKRE9jKzBKWUIv?=
 =?utf-8?B?c0kzSm15M0NNL2lyeTRhaGlGdmlPVStwbWp3MmZtdWZSdEtXSlByU2o1OUlB?=
 =?utf-8?B?M3lncVlPUUNocjN0R2lTQlV2dGc0U0RZTCs0S0JPVU51cjRjNXlMK2RtSk52?=
 =?utf-8?B?d21qNTVWTTVLNThCMnVGc245Z3ErbXZsQk9HNTV0OS9QdVZnL0RoZVRRczM5?=
 =?utf-8?B?ZS9iZkhXelg0Q1JKREpEV1pCZVRNQzRCQmdla3hIVnZmSXFUdnJjTWtjS2Q1?=
 =?utf-8?B?VGFsRnhkYW9iL2lrK1Nndit1L3ZCVnVQeDRMR3hQU2ZmY0wydW9MUld1T3lv?=
 =?utf-8?B?ZE0xT01XLzY5ZlV3b2k0WXo3dTRnVnBaQ0JDc0h0S0EraG5HM096Snh6WjBC?=
 =?utf-8?B?ZlQ4WTVlS0QxWjArWDZ1aGxTVkE0M0YyNkZuVXR0UzRGM0JPWDk2V3hwb0Fk?=
 =?utf-8?B?aHA5OTUxUCtjRUxPZzlxKzc0cUNsQUEzaGFXYlNBcDc4NzVMQ3dsczZaN0xO?=
 =?utf-8?B?aVY3MisyaitPL2J3alQ3bzc3TDFWM3RocnovOWdQYUtDT29xWkI2UitjT0dx?=
 =?utf-8?B?U0Rxc1dQTEMweWx1SmF5SFF2djl1bVNROEQ4RFRmNzAyN1ExTnpvWGUwQmtD?=
 =?utf-8?B?dTFPT3FnL045djkrRUoxNWg4bXhNbXg3VkVzb2RWNlhUeGhTOTEzRXJ0QkU5?=
 =?utf-8?B?Mk42U1B3UFhxcUt2SmNndTBLZ1NjRDloSzh5Q0NEdVIwaDVaV2dBUTFSL2xR?=
 =?utf-8?B?UVRyRm5OQ1g2eVpTelF3ZVM5UmkvUmhRVjNLSXJWcDMyWkY2L3RzdTRQVWgw?=
 =?utf-8?B?QTQwSDY2Y1dnR3p4NVVFNW90RzdFSlVMVHBJVXRhY291cTdyKzBuaG9wOUdS?=
 =?utf-8?B?dDh2QmtvZlA4bmJ1RXZHc1FSK25ONXo1VkRVcTNJbllHVlI0VzBWUStKU2k2?=
 =?utf-8?B?b3lncTkxdzlzaUhZR2JhWlRJVVkyc3ZxMkphdE1TRXlQa1lTZ3JqOUo5Vk1V?=
 =?utf-8?B?UEdhTEVXWFM0dFpPRXRpb3pudWRVRURIekJSYXNES0doMU1sZlFBa3JaTXdr?=
 =?utf-8?B?M2tINndwbEFoSjRZcTgwNUkvTlFZVEZvaXh1MUhzdmZDaEtpSzNMdUlqdFpk?=
 =?utf-8?B?ZGtFeDRIYURBcFlsNjlLaElyd1FDNE5VejFBdGtGZVJnTkViTGtvWFl5N1RV?=
 =?utf-8?B?bG45UVJiVktiaVZ3VHZTeVg0R3VUS2tPVHhEcHBDNGFCOUYrVmRORFc4YWZK?=
 =?utf-8?B?aE5pV2JDUmJiaDJaWU84cUFlZEFYUnBGMXluUVFJTHNIN3d4VUNrZWE1ejRE?=
 =?utf-8?B?MGx5UnJRcVJGUlNEUlNKN1VqdWFyekVnd2Zna08vQzhTdmx6aTAzb0hjTUFT?=
 =?utf-8?B?bTM2RWxsSlg5RUI5Ui9zd3dmbCtaVHJRd0dxYTJkTWFSK2VvRXBVTVc1VjVm?=
 =?utf-8?B?eUc3M2hxcDFZS1JvaGlnZ2U2M1VnTExJRTB2UU84SVZ0cnJjVGxVaTdRbHVq?=
 =?utf-8?B?ckRONW5Oc1A0c2IxYUdYdnNqdVlZcVloajZKNHFrNVlvZFgxVm5USzVORG8r?=
 =?utf-8?B?bzUxdk5tNEE0SlJxYWs1VDZGUDM2bmVGaVhramlRQWVNYjVjUkNqc2NjU3Fo?=
 =?utf-8?B?dkp1TGZSMys3Rk9zOUQ0aklvQk5WMlpmY0dWN3dsRlBJbm9YTFVnemFaUWUv?=
 =?utf-8?B?VTZ4YzdxMDVzKzM3Zm04aVl1TGxoR1hESGRnS1ZMOFp5NzFscjZDMCthUTMx?=
 =?utf-8?B?a3M5L3FIQ055N0lwLzhZUkcraGlzVkZCdWFHQ0NTcVh2blpxajgyL25ZV3ZM?=
 =?utf-8?B?dVM3elJkbjZCczJPNEYycmdkOWZLaXJyT2F4c1FJczFaMEZ2MDAxSTBvMktO?=
 =?utf-8?B?MWVzOXI0TjVKaVl4Zll6UGNVd2JWdnhvK0dSc2NoMW1tL2h3Umx5MFJWdzNN?=
 =?utf-8?B?ZE1Mekl6UldjcU9VQ1Y2WUdyYm80ZHJNSWs4N0l3My9HNVNUaWtNTmNDcVk3?=
 =?utf-8?B?ZCsyN0tOd3U1c3Y1UXpieGxtaHJFQ1lxYlFsZXZ6MUN2cEJyenp5V0FqTHg5?=
 =?utf-8?B?d2VhaTI5bjhucnc3cUJZeFdGZU9YVmNCMkpPcnJpdEw2ZktzRThEckJWQ25o?=
 =?utf-8?B?T0ZtQXBoWjZyaFdEVGJySnE1dEFwdjhGOXByVUFqVzNBWlE3NzlxMEI3eG9q?=
 =?utf-8?Q?kGSfvZ78gzEiI2gCC7HwHjg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b1bf4e-0786-44ce-a20c-08d9b990c313
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 14:49:25.0658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3myVPz0VDdSbfyZppQCg1TVIcOIgbX85cktEWIwcqGjE87pfq7x6tZB59/mADJf97YRBM3+XJAD5QXuZsK7I+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0037
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/7/2021 7:37 PM, Dmitry Osipenko wrote:
> 07.12.2021 15:40, Sameer Pujar пишет:
>>
>> On 12/7/2021 5:35 PM, Dmitry Osipenko wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> 07.12.2021 15:00, Sameer Pujar пишет:
>>>> On 12/7/2021 3:52 PM, Dmitry Osipenko wrote:
>>>>> 07.12.2021 09:32, Sameer Pujar пишет:
>>>>>> HDA regression is recently reported on Tegra194 based platforms.
>>>>>> This happens because "hda2codec_2x" reset does not really exist
>>>>>> in Tegra194 and it causes probe failure. All the HDA based audio
>>>>>> tests fail at the moment. This underlying issue is exposed by
>>>>>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>>>>>> response") which now checks return code of BPMP command response.
>>>>>>
>>>>>> The failure can be fixed by avoiding above reset in the driver,
>>>>>> but the explicit reset is not necessary for Tegra devices which
>>>>>> depend on BPMP. On such devices, BPMP ensures reset application
>>>>>> during unpowergate calls. Hence skip reset on these devices
>>>>>> which is applicable for Tegra186 and later.
>>>>> The power domain is shared with the display, AFAICS. The point of reset
>>>>> is to bring h/w into predictable state. It doesn't make sense to me to
>>>>> skip the reset.
>>>> Yes the power-domain is shared with display. As mentioned above,
>>>> explicit reset in driver is not really necessary since BPMP is already
>>>> doing it during unpowergate stage. So the h/w is already ensured to be
>>>> in a good state.
>>> If you'll reload the driver module, then h/w won't be reset.
>> How the reload case would be different? Can you please specify more
>> details if you are referring to a particular scenario?
> You have a shared power domain. Since power domain can be turned off
> only when nobody keeps domain turned on, you now making reset of HDA
> controller dependent on the state of display driver.

I don't think that the state of display driver would affect. The HDA 
driver itself can issue unpowergate calls which in turn ensures h/w 
reset. If display driver is already runtime active, HDA driver runtime 
resume after this would be still fine since h/w reset is already applied 
during display runtime resume. Note that both HDA and display resets are 
connected to this power-domain and BPMP applies these resets during 
unpowergate.

> Do you want to have
> inconsistent h/w reset behaviour depending on the runtime state of
> display driver?

Of course no.

