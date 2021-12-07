Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8424C46B6B0
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 10:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhLGJNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 04:13:31 -0500
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:56672
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233506AbhLGJNa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 04:13:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TozuHYkzH2IM9Tipsyq1vrAhVHw1o4iq1DDhIR/w8fKTnaytE5bO8IiT3FkknbRqj4/SwSb3GX2WtXioWw1r9zen/KCgrnRjVP7dqzVgLeejuvKHxiiPjzpdUeeS0Xmw4QKbCxqJgndYXOz85WrmhNa7SAE1RQnwK3N+Fh2szpcuzMTY/q5jrnjwGf7SbI+kCWYkT40zhARSyEEjS04z9azSt0kIcQXMSPtoVzrA/02yjIbmzCJ+/+Gz5fsIRD5ixTswwy7n5Ki0iq1AY9LQk4PXk6RzNbFLc+fA/FUWr7vzqWPncfCd4+AMUQd4DCxb0M5xNH2lX3oniIOLMFX+gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKfjMJwQhVk5yv2eGJlF4rmKA0iqXWvPud+M9B5suDw=;
 b=oRIKp+PMD444rrCWzJeZQ72sB9CX6MPRy8KnaSjTrlnkyoQ90QCJjo24P1+fotErNpFGPlbRotAEv8HwmkxEkkKSb/pWUFyjXLvD4684SEdZQI4eWN8Pzz6NzZB6+EO6DX1GQ6W99ru6RxZGc+8V3IRSCZ+aIuFxSnth4ft/gvfK/QnL49F/KGT/tvRt/Ywv/RPBbsgymU6mHLAb/Vt0vtl/2Dw7CGVfSB5ERA59LRcpjx++GYAHsgnud+x4WlK5xDDPfm/kviqFszg2ohvzdI9hsxZEufcsrIrNpC5z+m5kq90twoN8pYpv+omMxjkDGvmXIGkgc66/CGpIZD35gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKfjMJwQhVk5yv2eGJlF4rmKA0iqXWvPud+M9B5suDw=;
 b=ERBZoTK2S41ZnbVz6RuDABy4K2icTjzN2Zs88IsNzg86kfYu48F2XAkqPmpAgbvijQo8qPd1W3hLrKh7rGw66ngGZiU91jVEAS1VeJKsIdAU1FpdxNGzq4AiTNWJOAMnskFENKqPFltAdxSbhee03+YZpk1ijclG0Qx9j00OuuT1zy1Uq+VPtZQo4SCJry3sAM4KTLbXudM0YSeRwS8Q/GL/VPWyhXdngZCDB/x8XBEaP+Qgf0s5OXUYq7uDGMEj8p/I2nBV+hNUz8fuB2HSo+zWrrkCYAKg2CFAjRKuZDVyYpwz+/VN/L/oUK4gVZakzGtSToLELqlmqX9K71RNvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR12MB1287.namprd12.prod.outlook.com (2603:10b6:903:40::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Tue, 7 Dec
 2021 09:09:57 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 09:09:57 +0000
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Takashi Iwai <tiwai@suse.de>,
        Thierry Reding <thierry.reding@gmail.com>
Cc:     tiwai@suse.com, broonie@kernel.org, lgirdwood@gmail.com,
        robh+dt@kernel.org, perex@perex.cz, jonathanh@nvidia.com,
        digetx@gmail.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <Ya8Ya2en5Tm5Ol2u@orome.fritz.box> <s5htufkolpr.wl-tiwai@suse.de>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <d1e222e4-a260-06da-6c01-6b96ec707c8b@nvidia.com>
Date:   Tue, 7 Dec 2021 14:39:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <s5htufkolpr.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: PN2PR01CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::30) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
Received: from [10.25.102.117] (202.164.25.5) by PN2PR01CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:25::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend Transport; Tue, 7 Dec 2021 09:09:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59720d4d-433f-4fa4-f68d-08d9b96156c2
X-MS-TrafficTypeDiagnostic: CY4PR12MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1287CF99C7F4C8FD1D76E4B9A76E9@CY4PR12MB1287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eEy1bjWNYRC64TVlYnuGSMT59lBiqabx4N1MhP73sUw/LDyKZJ1M6PDqrnQTwMMeSjeYQ+orvSXkFu6UBcJzowBca3bH/TgWfoWKIEH7zHVdrLyPpCJdjvI5+1cpeZj8OnP/lhGfb51TQcbMHH/LLfm4Qm/Zkg9bXklaJco/d6V/fH++fFUY+zIxK8LZToS6I1MXE8J6gU8Cr+yQYgL8tQcH89v8abK+0djwfKJVAgsysrGdIe9SENp7imNPSA1qpu7HH21LGR5kCFuBAdH5xLaejTJre45b1Ja0QlAVjXv1M8CDvqv41lD/qcyyBFT4VPBWx8mk/Sm4bKjeRDe0L34j9wfF1fM3lH5bPRIZDNLfgCa6QlusSDdqecCzWw6y3Wezbrro8wnWt8//8g8LHGrnIHjjU8n2EfS/RRKtp9F6sDyoM7Xahlar2NCROqeCXMxIMXxje5xdS/itnGV34Gd73vBf/ASDh4HgpAAuANaAhlIO+kidro0+YH6ZharALnMBeVhWKFAFAaxR1q0R/i0gtLYdEAClt5kf8lukcrzYY8S6OadtasWC0C4XRhEarkzK25Ycnh8/UlCc1fuDqZ1wWBkHmeTGyr6IQJtRL86IrN/U1nl9flv7c+5iGVeojP7Y++Ls3uMI9P6drI12LATd/6CtzEPYyHJUYGw6Nps05YadvhDDeZB3Vxmy2ihchV+RMb1CMJrAFowtZHQi+iuI0Wk7eY/c3/NE7HcWZxo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(4326008)(31696002)(38100700002)(186003)(6666004)(16576012)(508600001)(110136005)(7416002)(316002)(31686004)(26005)(86362001)(66946007)(2906002)(6486002)(36756003)(53546011)(2616005)(8676002)(8936002)(66476007)(66556008)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0JsRHVja3puZ2o2eE1sRkI1RGs1TTF5VHlRb0p1MzJHaUhFNERHUWVsdVpX?=
 =?utf-8?B?TzdjMUlhVG5RNVJGZXB6eHE3L0hweE9YQmxrTmxDdjZJK2JiaVZpN0hLRWh3?=
 =?utf-8?B?QjFaZ1JLcmdXcXlRRlJEM3cycUo2bGt1NGhXeVYxa3VvcUZyMHpHSEhjYklS?=
 =?utf-8?B?bXRFWFE1N09jQnJSU2M5QU0wWDRua3pMTFptdEpjUWN1YVRETnErN3oyakty?=
 =?utf-8?B?b1dkWE1OcE0xdG5LMVE0SUdQaWJiUmYzN25VVGFSZy9wblVzaTROeEFlamtY?=
 =?utf-8?B?N2dBaTkwRmd2Z3REK2c1WWlXMU1YZHRFaE13RVhrMjZiWDdkNFFWd0QyaHoz?=
 =?utf-8?B?QlZEamtuT0EreG5sL2tSVHZ2Z2dtQUVhdkxEREZtYVduZVhQaytCSDV2dklo?=
 =?utf-8?B?QktGRDBaYnRhcVMraE8rTWl2d0lFNUt5MVcvS2hxd3pkUUh0cVp0WlhDNGN5?=
 =?utf-8?B?SFRGV0RSMHFvdnZ5Z3Z3SDZ0ZFdOVXZRMUorMGtVSkIwbHFwQUVyR0Q2MFdl?=
 =?utf-8?B?c1NwV1ZsclBTZ1hOS2NFUXlaRjRIazlzbzR3cFlJZmE1OS9ZVmc3dnB4V09G?=
 =?utf-8?B?bC9XQjV1OFZEcXdhQW9nL0drUGtmbnR1VjN2aThDZHB4ODJ4bkV3dlo4cTk5?=
 =?utf-8?B?R0J1ZDJKazA1a1hQRE5iNFo0eTJUcllmbkg4U2IwQ2VjN0RLKzd0T0Y3Ny96?=
 =?utf-8?B?L1ZacDVCUlk2emd2dkR3VWIvaU5UZitrRHdzbTd1QlZWb3BWMExpcVhEWnFW?=
 =?utf-8?B?WG9MZjB3c2pER3JCdnN0ZFVOK3MybTdxSXFSSkNjaDJWd1h4Rnd3ZzhUQXNO?=
 =?utf-8?B?MU1sUklqeklYRXdoUit0SXkzRldMVEdmaGtUQSs2NUxNVHl0b282YWZtdmlN?=
 =?utf-8?B?c1RVZGkvMGdyZWNQVVIvaXhxU0VHU3VCT2JMc3RoeVZYYkIzYXgvNHZzYzcz?=
 =?utf-8?B?RTltUHZBMXR3NUc3L2RaeDdGVE80VDlBSUF0WG9LTGkyZWMrYmZWVWJvbCtB?=
 =?utf-8?B?SnQvUHErU3pzVUlWYjJuNUdsVitpTnZZbUNwZS9TSTlGRmhNMmE1OFZSaDBt?=
 =?utf-8?B?TFlNQ20xN0dFQWFDdFFZTzMydDRIKzdZMXVYZUg5cngrcmJ6R2YrT0NiVjlN?=
 =?utf-8?B?UHlaVjluZXJlUjh6cDYxVW40c3c5R0M0cXJLSnMyOUd6bVRTRWpVcWFGOG9x?=
 =?utf-8?B?NjV6aGRyZENvUmN6Nk9tTTZNNzB6a2d6cmRmalV0VGlkeGdIZ2Z0WTRwMWlT?=
 =?utf-8?B?Sjk2NFZIUEZQUnhpUlNyU1V3cGQ2UWpiT2dINUF6a0RsVkZKWldpYkw4TlpU?=
 =?utf-8?B?U0NZUDZFMWUwbnZoL213aVluSFhKYzM0YXUwTk5CaDI1My9rLy9TanFqbDZz?=
 =?utf-8?B?dG5vTStKaVlKS3hGK0hKWFZtYnBKRnUyeW4wOVNnTTUzTlczTGVmR3dpTnMy?=
 =?utf-8?B?amNDTnN2VUxXQ1VJV3EwZTFpVGRtM2NkVThQNkVoM0Y3cExnbW5QanFHa1Jp?=
 =?utf-8?B?SGJ1TWgySW9ReWxMejdseWVvQ09LNHRwRkU4aTFQQ1huZVRzL1kyeWp5Q2ls?=
 =?utf-8?B?YW00TmM0THVwM0ZSZUp4WXFBVG1NRURQVWZUVklBR1dRVWlnZDJRT3hEdkZP?=
 =?utf-8?B?VnpvRnBJRVZDS3l3NFlVa2RJOFhpQlVvZXZPTFdKMXFyZk53RThodGxtVHVs?=
 =?utf-8?B?ZjNKYTQrZ3VJYmwrRlNJREZxZ2poeWRTK0lGSTRKb0V3TzNJU3NhRWRpK0Zv?=
 =?utf-8?B?bnc3NGEyelFSeU9RaktzeWFNTk91MzRLWm5RdktMdjRrNnJYM2ZsT09iLytB?=
 =?utf-8?B?Z3VFWmNYcENZdDEvc2NwT1kzUmhrYjNlTjQ5aGhlVGxSc0NQejRiRGd6SlRC?=
 =?utf-8?B?NFE2cjNDTURSazdNRmdXVTM5KzdyZFdhcU04bUk4S1ZHY01jc0RiUEtqQjBz?=
 =?utf-8?B?YjgrVFJJUTk0cXhHZkxWdUgyZFlvQ3RFZXhGZ1k1THBNaGFDS3hUYUM1RVJo?=
 =?utf-8?B?T3dmVnR1Z3hzektzcmpsSGxSbllrUy9TQjl1QkVHTU0wUkFZYUFwQWFKZ2s0?=
 =?utf-8?B?TXEyU2RVNDBOQVlyNEZuWkQ5TFlQUXo1L2I1V0ZhWmJlcXgybktycTdPM2da?=
 =?utf-8?B?NHIyUnRCa2lkSjlnQit6N2MrTTFPN3piQnFuT2tNNnNSTXZxZEdMS3FDUHg5?=
 =?utf-8?Q?Ad3put3iIZjgSd/oFMEuRX8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59720d4d-433f-4fa4-f68d-08d9b96156c2
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 09:09:57.2248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZNf49uUc3PDcJo9ap0YcBcH+HlQ+KpBZ/1wiRWGBcusd6WFRov74dEQkdWqtoH2/xfEk9Ss67a4+jiWwb53UEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1287
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/7/2021 2:06 PM, Takashi Iwai wrote:
> On Tue, 07 Dec 2021 09:16:43 +0100,
> Thierry Reding wrote:
>> I suppose this could also be a bool. Not sure if we need to care about
>> packing optimizations at this point.
>>
>> It may also be useful to rename this to something less generic to avoid
>> potential clashes with other data structures in the future. We've often
>> used the _soc suffix in other drivers to mark this kind of SoC-specific
>> data. In this case it would be struct hda_tegra_soc.
>>
>> If Takashi is fine with this as-is, I don't have any strong objections,
>> though.
> Indeed, a bit more prefix would be better for avoiding the possible
> conflict in future, but the struct name is local, so I don't mind to
> use the simple name for now.  We can change it later once when needed,
> too.

[...]

>>
>> One other thing we've done in the past is to explicitly pass these
>> structures for each compatible string. That simplifies things a bit
>> because we don't have to keep checking for non-NULL pointers and instead
>> rely on the fact that there's always a valid pointer.
>>
>> To do so, you'd basically add:
>>
>>        static const struct hda_data tegra186_data = {
>>                .do_reset = 0,
>>        };
>>
>> And reference that for both the Tegra186 and Tegra194 entries. Again,
>> not strictly necessary and since we have only one occurrence where we
>> need to check this, it seems fine as-is, so:
>>
>> Acked-by: Thierry Reding <treding@nvidia.com>
> That's true, too.  OTOH, completely without a NULL check would be also
> unsafe, so some sanity check would be still required.
>
> That said, the current patch is good enough for taking as a regression
> fix, but I'm fine to wait for a while for v2 to address those, too :)
>

Let me send a v2 for above.
