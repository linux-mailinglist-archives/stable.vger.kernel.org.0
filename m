Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CC2473D85
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 08:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhLNHWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 02:22:40 -0500
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:6401
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230000AbhLNHWj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Dec 2021 02:22:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpT+PNu9r/Nx9D+HkjSZ2VKdGIKwAwp8sLKpyS754rAwRk3fsUFey5Cz6dWKYIFOpvl5NwIdRIZquV8gcCMqeeMJapL0xAhyijnlEqOHwNZb0ylDMUDZXfy1PFq4c8Bdh/cSR021jV6q0jaJwUVADIwy5tl2U/Fll3Yv4AP9ekhLz1V4iJdeU11cOqgxCaU5HEir86PHWFzD5kNUPH7zHlXRy5sRIdq/j5Pv6KrmUx7dzoziaCGAzYeiJdKQiHaQzweJONDCCEAFSCRLm2Lw8Sx/DkrDCVONmCAuqCLfFeBpUAPnjVrM3Ahou2+uSxbKJY4zZCqdGME31Xi2KbiMoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EVgOrRO6rh6eAxz/3q1ufyQF1OeV1GqI6Q68lVGJhY0=;
 b=MfYFJz4SrmM4J8lNm6Q96QL17WW8cagF4sggDADfSAfiAQPmyWqNNNbeKib5WSRldH333KMhJYYz5guJ5wHXqsO4gHtrhOQdG7mAm0cfZ6OU2L+1NoX3TZ68yog5MudWSEzt4qLs03DYD1bp2u1JPkkUXLmzaQ30kC61RzaeURD9PGqg9cSRnM/sgDcu92y1/moYufB7VYR3clfs2M2HsT/T/bS5XRHXPmaTgcFdEilR/CTk2sBdTIJ304UDLkmKUTxUbB9XKdpkox1cHbJg494HzCTIDJopnSyKZJEBbug5QYtjwQ5dPpnvVd+mA5LUKwgruL8oVVA06ujPA3ErAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVgOrRO6rh6eAxz/3q1ufyQF1OeV1GqI6Q68lVGJhY0=;
 b=Dje+EDPq3Gq7tPimDD95wuqMQ3JhRqog6ATVAtjr34yPNds46gOYmdElvONvGp4oygHS3/THjf/61m8/Ag3np57kp251MJNaKFlDgv4Sz20aRy1tXN2v9hFi/M2viXKQqSQoxUiyMroDnOkpj1rqlZAPLoR91DPL+UomWgqEPz2krAiaJVPz8eLwB545hfz8ttX3qofiDA7rbjlxIrY2w2YnFV2A0Mcb93e9R/9LofP4S87MpUxOH1Cpq7jpCQ6nJn8rTRZ3SOHj8G3AN6yiwA4nY5NqovgMfpt7zo5rA9kON1UXWnMH8zX8NXY8TiYtNAshnrm7Lb0b71J4nLpcUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR12MB1654.namprd12.prod.outlook.com (2603:10b6:910:3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 07:22:37 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 07:22:37 +0000
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Dmitry Osipenko <digetx@gmail.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, thierry.reding@gmail.com,
        perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohan Kumar <mkumard@nvidia.com>, robh+dt@kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
 <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
 <4855e9c4-e4c2-528b-c9ad-2be7209dc62a@nvidia.com>
 <5d441571-c1c2-5433-729f-86d6396c2853@gmail.com>
 <f32cde65-63dc-67f8-ded8-b58ea5e89f4e@nvidia.com>
 <95cc7efa-251c-690b-9afa-53ee9e052c34@gmail.com>
 <148fba18-5d14-d342-0eb9-4ff224cc58ad@nvidia.com>
 <3b0de739-7866-3886-be9c-a853c746f8b7@gmail.com>
 <73d04377-9898-930b-09db-bb6c4b3eb90a@nvidia.com>
 <ad388f5e-6f60-cf78-8510-87aec8524e33@gmail.com>
 <50bf5a83-051e-8c12-6502-aabd8edd0a72@nvidia.com>
 <7230ad0b-2b04-4f1b-b616-b7d98789ded0@gmail.com>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <48f891bc-d8f6-2634-6dd1-6ea4f14ae6a3@nvidia.com>
Date:   Tue, 14 Dec 2021 12:52:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <7230ad0b-2b04-4f1b-b616-b7d98789ded0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: MA1PR01CA0171.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::17) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20d21862-5133-4114-13f8-08d9bed28148
X-MS-TrafficTypeDiagnostic: CY4PR12MB1654:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1654D64E3A8702A1D58B285AA7759@CY4PR12MB1654.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: baIN69Y6DIIc0rAtKt5EqhXB0ic/yS9mdosRjLL7Wn9GhAJl3qmdqq6YEhHZVo8uZmcfNWpcwB2It/tpGe3/iV311H2iq9CmCUVnZY84JW7K4h1tpZlXm36crLVmGrfVyl+lBlmCAB9wOL9tRMkb5vXRtcNv0873qZy+vk+aWHmWOw4pipGlsz2tPkvMRAFa1KbrB2lAVnPkv4YWgdljYegOElTQCctiHVzdpYoHOYHTMH34zigatASSomw0JFXjfEJ9emjJcbUwSwOThItaoC1T1s8B+KLdlpS+wLJ6yG/eVjoRC89QdcrPjKOhYIBElWJUGdHDBv4OMLZbvRC4DT+UEXrl+keBD6g6mS9rqUH3RYNr5KjahFIZwvvZLNQSstQJjOPJXXBeeCVySJJ9uOXJjzGsdF68wRHvyhyiZzpekHj2OaIMTynq60ppr6lXmnxiK2cjEB56J68IMo2fZzd+pTkK+GbpK2/u46AXyU5dQpaHlnAolgJUEdP0PcPLNxtMgZEHPFZEJJEatReYSkFW+pzCVkOuyHUFfrstEsiqCkDEPMbBc9bmvdkDBgXGybrc4sl+Rp69yf3yMSSCWm2qSbKRmiWdLaAHDxgGbnzzXCOrwI9ZDJ7bUUwOsVP/aOJa8EGNNSw0ye1P22NjYAdXLRa/dguXhUO8CH0dLCgSkgQsvStM4S9CN5Tw2ec0390fEpWRGh0mK6o3659C67QE9K1rAn/VQm2XpMOSHys=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(66476007)(31686004)(66556008)(66946007)(8936002)(7416002)(6486002)(38100700002)(508600001)(2616005)(5660300002)(86362001)(36756003)(4326008)(53546011)(6506007)(8676002)(31696002)(186003)(316002)(26005)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTVTaU82cktScThpcWdRQzc1MjNobVcvTDRvdGZjNmFUcUpsd3Z0UUtlM3lV?=
 =?utf-8?B?aHFXRU1hOXozVGpaL3pLREc5ZkJZeitFRVJjcDg5a2VKU2tMSkhQOGVLaW44?=
 =?utf-8?B?alozZjllTmRvT3IzTDdkb3ZIL3FoQTJwTG14M0pzT2VzNDJvOVExa3NsdWNB?=
 =?utf-8?B?S2M1S1p0OUZoU1c2RXpML2NBQ0F0dURNamU4Y3ZrbTN2cC9MNHJxeSs0eDhS?=
 =?utf-8?B?RWEyRlc3SWpNMkZ4N2NyZ3crZHZ2RThkUTd3S054ZFlsUUlGemUvbEFoUEMv?=
 =?utf-8?B?QzNVYThIRWNKOU8vQ3kyYkRIN01zR2NlQThicG11UmoybENDUXVvZzY3RjdX?=
 =?utf-8?B?OEwwQmJkM3RpTDJoTnBUam01ekJ6OXV0S2w3Y1pkbEN2NWY0NUh0MmhTR3pX?=
 =?utf-8?B?bm9WUFZRSVY4QzFFaGNTSDdwL3grSGJQSnFESXNRTFFzME5hV2lEVkdHZVpR?=
 =?utf-8?B?ZUtPai9nbVJjdTRYLzQzeTZaTUlWLy82QjMxd29HU0dvZlRvMEJYZ1poUmlp?=
 =?utf-8?B?T29YTkVWTWlIcjZwWEIrVlhwTjFYb3VWS2t4SU1jWDhSWFpzb3duYU92UCtV?=
 =?utf-8?B?RGRjOEdUa1JNeEl3dUpibjJUNlF5Vy9VdkhUMXVFQ3JrYXAyQmFKQ0NQZTBF?=
 =?utf-8?B?STJGZTdoTDlnL3JVZW9MVE96UzlSVi94ZnR3UEVyTERRQStja0krLzFBd2Mx?=
 =?utf-8?B?Z21WRnBwNDdWRXJ4cUpKM29QZm1KZm9aKzRVRDFGU0cxTkQrbzJGOW41MjdG?=
 =?utf-8?B?eEZDQ3lpK1FiZlFNMUVVSjA4YnRHc3NzTHJEcGVFNk9weDhQNG9lYXdEbmNv?=
 =?utf-8?B?MVlEWHdKUjBTdGVoRHJCVnkzMFExVENhZTVmbC9yY284VHNodlRqd2hOMXlO?=
 =?utf-8?B?VE9kS1JsVmZQNStIbjVSVklnS3Njb1hNMkRJREpnMkp2RW14VTBSN0tVWDlz?=
 =?utf-8?B?Uzc0cm9MNmo2eHgxaGdXR2ZHYVlnclptY1BxRmlNRHZmNUF4Rk53SE5FZTBt?=
 =?utf-8?B?Tm1EMXFuUUlRbXBZOWUxcjQrc1FOVm9mWVJUMWprTE56R0dwck5hRlBWRFJl?=
 =?utf-8?B?TDVUL00vcTZJWlBDVk05MVg3ZzdVTEk0Zi9nU3EvTG5DdndnUXJFNUlOMmN1?=
 =?utf-8?B?dVpuekprTDY5VWhick1PaWszd1ZteXNDd0QwN0ZOc21BaWpOdk5YYUdlUk9z?=
 =?utf-8?B?N3dCVVFaNXp5VXMydDZyN3VNNFBXdm1LOUk0R0xPQWoxcmtRa0RmV0tPanZ4?=
 =?utf-8?B?NEVUelZsMjlhbVR3b1hpeXE0ZnZ2NTRnR0xDZ01iaVhRWW03VXVvYzZQNjlt?=
 =?utf-8?B?QWJ3RklpSXpmaGJDcGJ6dll0N0kveVZKeW9WbnNzUEJ1Njc5dEk1Y1pkVVlS?=
 =?utf-8?B?a3V6cmxZYjd5ZFo5bFFHUTRwQzQ2RTAwNk1CVEdJQTdXcmVwZS9MckNlK1NO?=
 =?utf-8?B?ZXdZTkVkM1FZUHpWaU92MVh0U0hKWmtXU28vWVMyY3NqUlJyQW8wU1k2Qmla?=
 =?utf-8?B?L0I0Nk9zdEpFcitGZ1k1YWtrSGFCYUxEVXhIOHMxV28yVE9ZZDZHRkNrVjAx?=
 =?utf-8?B?aFEyQXRpaXdHVW56a2xReTFGdWlMOFoyZHBjYk41ZDBnTmh1UlJyOGJtdWNu?=
 =?utf-8?B?S2crd2pqRCt0blFZRGw2ZmRRRDdyK090b2dQM0dsMHZLZjZEa1ZUZ1ROU3cw?=
 =?utf-8?B?Z0xyekpWeUcyc09JYTFocGU2bjUvT0JoTHJ6RlZYeVFtTlZiNEVrc1V2Qko4?=
 =?utf-8?B?Sjg4U3BZYnNBWlFYK3lqcUUzYkI0ZHlBeEZ2UVdBdEFXZGRyNytxNHYwK050?=
 =?utf-8?B?emFpY05POWtqQ001SWM2ZWEzbms5N0RFeTN6QWtiVGtRc3RTbTI1RmdIRnNO?=
 =?utf-8?B?aVlVVnBwUjJMZjErbGxMbFBsa2dHR1M3OEtCU0JHNWRubmVudVVjZ0tUZUFH?=
 =?utf-8?B?TTcrb1RvQnFQNWlGNEFEM2d1Z0lGN2hPbG45VDVRRWpLRks0azZCSFl0UnI3?=
 =?utf-8?B?QjJta3JBcktaZTN6elRoVGdHdEcvcXQ2NU8zYTdqaW45RmE0bkpvUTAwbFZY?=
 =?utf-8?B?Y2t4cEhZalo2MWZkbUNuZFNlMm5oejFIbE1kbEc4QUt5YVVuKzFMbzZJNGxT?=
 =?utf-8?B?NDdudjVEbTBoUUFUM2d0VXhERy9NV1JKVmNQV01JQVRHbWhkOTdneHBQMzA4?=
 =?utf-8?Q?wB6uuwZzepD5aSzBLgW/rT8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d21862-5133-4114-13f8-08d9bed28148
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 07:22:37.2369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxqhfE/17CU0+KoHw7LfGIu+ehkhN8cPfgRTEvHrlu7QHhTZvafcKQEDf11e/GFKyj3OhKP6QhGWPaVncJ4eEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1654
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/14/2021 11:39 AM, Dmitry Osipenko wrote:
> 14.12.2021 09:02, Sameer Pujar пишет:
>>
>> On 12/8/2021 5:35 PM, Dmitry Osipenko wrote:
>>> 08.12.2021 08:22, Sameer Pujar пишет:
>>>> On 12/7/2021 11:32 PM, Dmitry Osipenko wrote
>>>>> If display is already active, then shared power domain is already
>>>>> ungated.
>>>> If display is already active, then shared power domain is already
>>>> ungated. HDA reset is already applied during this ungate. In other
>>>> words, HDA would be reset as well when display ungates power-domain.
>>> Now, if you'll reload the HDA driver module while display is active,
>>> you'll get a different reset behaviour. HDA hardware will be reset on
>>> pre-T186, on T186+ it won't be reset.
>> How the reset behavior is different? At this point when HDA driver is
>> loaded the HW is already reset during display ungate. What matters,
>> during HDA driver load, is whether the HW is in predictable state or not
>> and the answer is yes. So I am not sure what problem you are referring
>> to. Question is, if BPMP already ensures this, then why driver needs to
>> take care of it.
> 1. Enable display
> 2. Play audio over HDMI

> 3. HDA hardware now is in dirty state

Why this would be a dirty state? It is rather a functional state. Isn't 
it? Power-domain is ON while all this happens.

Another point is, with present logic the reset is not applied for every 
runtime PM resume of HDA device, which is confusing. It depends on the 
state of 'chip->running' flag and I don't see this getting cleared 
anywhere. Would you say subsequent HDA playback happen under a dirty state?
