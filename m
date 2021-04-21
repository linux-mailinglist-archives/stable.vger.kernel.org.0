Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC404366D06
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhDUNnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:43:01 -0400
Received: from mail-bn8nam11on2088.outbound.protection.outlook.com ([40.107.236.88]:32864
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238346AbhDUNmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:42:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6ZFSEvpbYZh9oeoMa4kLi4+DUO7Es0qKePOK2noqLyUA2PNmyZyckLgtg9r61hSH26C0E2+EqHiOl8h/Y1VVSmQPPhyX4rkRB/ZvbtrX1ChV5Ka8NCLETuTADR11sjrcevEtqERxkCCp4rE0/R0TsIluZ3dPPnOB2NTBud3AAPGov7uvSa+mCgdp7wCtMrm3EqRMJ1GMfdiOgLHyCyzpBBJ643h56BHlTV7e5DRg6NlOzuweKk/7XO4W/hVfk5GyDvA3dITz4KSxLoySBFIDeSog8AhA+qKyYgt8y1/Vh1vREQwr+TsfGm8AlNOjXt2Ano/wpkbD2S452cFmP6Ycw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvUKHTwiZmby3WV4SqOoRSge7jQYLRAOIdUNfXtOp4s=;
 b=aKyvVKSia8puB+wtjhYs+7uKxF91s9VJwR5NUctijfltI3TV97AI40qjRPTuMPf9zSWjdaXRiNap7pTKQpJ+H/GxCNPW8muLscgJVAKIcRMPtdAPuThlVgSEUZ4e4AqYHwkHx45C8d+sg/Koax64GvdPxlfMPsgYOdxKYHp+AdvdId35SmJKIcT1pQqq5LaZ8vl2Zygslrx+m1iuIBqEjtPJU7dc2BCNSz5Ks0Gw42hIei2/OIj0vQJMZdHa72vooVyC1a0Qy6quNNqwr2zxyOD/1vrP9QaSjy6lkaOf+T9XQ5CI1N1hp4Zd29a4Hfbawiw47LkrSMWUym0uWUa7EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvUKHTwiZmby3WV4SqOoRSge7jQYLRAOIdUNfXtOp4s=;
 b=DXl2oEBiQ3LLz7/2uSMj/QSsgdUoiySQODI/yBpDK1Bu3MYFi4yO+7f6fJ1KBKbAHCYGG6uMdumortWxaptxQBBfJ/3EpZ3LiZoC4NFb9wrH+hsx24lXrT8yRg4J4hA1Pl5hPwBKwG9ZznrHnEgEH8PMtAMOecATY2c+0q4zJ1s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB4720.namprd12.prod.outlook.com (2603:10b6:805:e6::31)
 by SN6PR12MB4749.namprd12.prod.outlook.com (2603:10b6:805:e8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 13:42:19 +0000
Received: from SN6PR12MB4720.namprd12.prod.outlook.com
 ([fe80::2c6c:765e:d8cb:e4da]) by SN6PR12MB4720.namprd12.prod.outlook.com
 ([fe80::2c6c:765e:d8cb:e4da%6]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 13:42:17 +0000
Subject: Re: [PATCH v2] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
To:     Huang Rui <ray.huang@amd.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        stable@vger.kernel.org
References: <20210421023807.1540290-1-ray.huang@amd.com>
From:   "Fontenot, Nathan" <Nathan.Fontenot@amd.com>
Message-ID: <f1ae7cfb-ae34-3684-b191-c9a1f7f14240@amd.com>
Date:   Wed, 21 Apr 2021 08:42:15 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210421023807.1540290-1-ray.huang@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2600:1700:271:b60:c19b:c99d:a81d:b227]
X-ClientProxiedBy: SA0PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:806:130::9) To SN6PR12MB4720.namprd12.prod.outlook.com
 (2603:10b6:805:e6::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2600:1700:271:b60:c19b:c99d:a81d:b227] (2600:1700:271:b60:c19b:c99d:a81d:b227) by SA0PR13CA0004.namprd13.prod.outlook.com (2603:10b6:806:130::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 21 Apr 2021 13:42:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d738e2fb-9758-4d1e-2588-08d904cb4776
X-MS-TrafficTypeDiagnostic: SN6PR12MB4749:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4749E07798111A70DBC8E2D2EC479@SN6PR12MB4749.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XPVUDpWkP07Yse4nUIzq72G5K2Nj8IORzww4tPomgQvxk/tFUEGtttr267uXdwTN1NW1Bp5k1eQjI0x6UW9lUXiUEmWshIkikfBwmr2o45j8teMH7EqffGekFgitw16gehAF3yXtKhLwKFZfLHG+8hsiYLjBTIUPfoT1M9vV+CknndMf2AsM2PuqHISPsvLPP+z1XuOpWK385MTTLi4CfCdUToXfRd3iOtucqdlj2ErUr9E8CWbCyuI6DcZ7DG0H8motuXDDVKeW3YWFKCpPwHvFZAQCMlntpTtzw5no7mRc9U6f4AHWh5kcmeoO92cV+ZE+djjXJK/jtoZO630YoCCllwD0JxTDJQrGJ4cdNFxZbZvv/Bbo2nLSkboiaC1kuvjntCORWVhaqBjlvbIKfRxgE7Le+S1Fmh7Ak5DIF54KvhczpMMvhlmDeHTrRNZiDSt+NETjjaZ/GCjrET9Qpy7i5oKKJAiGnxjIyxSBxAY9w+qnLPMS+7I5/W78uSnO0mkq86OkTVGlg50tTWHS5GSvmrAifULIo1+NPnwi8nsujnK4CXqFgleROcnJWM0Uvmi+XvOYxandcLLVEM1AcEx9sxV/klcqNokhmEjVh7OcJun7Ql8Nne58SvU4B0+F7i44t/D7HniFrTe6AstZK9TrNzxJo9omhVktDOQynAzMOrNL6oXGmxgkOeB4Ex0k/oC0Rbka4Bq+Regs2oL4OjU1BkUwkDGRRIznE76nCEC7XhkFW2F3ji+wayo+Y/Fepc3UMTp71BVwJD7lfVUuZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB4720.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(396003)(39850400004)(376002)(8936002)(53546011)(16526019)(66556008)(54906003)(2616005)(8676002)(38100700002)(31686004)(186003)(316002)(4326008)(6486002)(2906002)(478600001)(66476007)(966005)(36756003)(83380400001)(31696002)(66946007)(86362001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZHhiMjd0dTdVeW5SNnRtVWFUMjlLbWYxT0dOL2U5bDE3RnF0d3RsK1V5eFJo?=
 =?utf-8?B?U3lSMFYvU2FyQnNKWlNzaGdaTkQzWFE3ZlJrMzJoT3hsUXBLSnhYK2NNSzlR?=
 =?utf-8?B?K3hJb09yeVRGYkJDbXN1TGNwdE9MZkptTjNsY1JGNDFGNXBkZXhxR21ma0ZP?=
 =?utf-8?B?TzlQWFZqN05HeFBQa1VjdXp6WVJ5M05kYloxeHZmQVd5b1pLbklXekZOSTds?=
 =?utf-8?B?WWkveWxBZG1hV2xYa096SlRmY3p5ZWZSTlBNdXEwMFdaSXRTVTZ6RU9vaDZa?=
 =?utf-8?B?U1g0QU5xWUQ2aDNZWGF3dUU1N0lHSi96aWJsZUs2ZXhlVEc2K1BWdXl0S2dz?=
 =?utf-8?B?VWtEN01DSUhwckhBSm5EOXJ0UGJFUmlPT0xuVDlnSmJLQWhnSi9EQzBlaEhU?=
 =?utf-8?B?d1RVbUlpTndlajk0NjJ2LzJaMlpDZDIxbU04dmtkNXlqczhYVEpBdnlTanBJ?=
 =?utf-8?B?WTlsYXhrNmhGbTA5WXFCdlBlazFYUHl6ZWdqUVZuT1RuMGRjU2dSRzg4TTYy?=
 =?utf-8?B?VUZISHovd1V2alpUVzlJa2tmK3RYcXF5MjBpQW5STTkrZUNxN3VzMzg4NmZs?=
 =?utf-8?B?dVhndEMvQWlzdmNFRFJxTVFCWVFpQ2M2Z28yK0FSRUJralBpK1VSei9HZmM0?=
 =?utf-8?B?cjFDT1lTbE9DTWJvMnV2aFRSWXV3MkpnUkxQWVpSamlxbGE1dlJLSkNmNWNp?=
 =?utf-8?B?UVJ3a1Y3TVBXSXZOR2l2U0FpRUViZ3FoaVRRVEhJdDQwUkd1M29hMXN5ZW4w?=
 =?utf-8?B?K1pkbW1Pck9nck1GaHcwNDhDN1RrQ1IzQTAxVHlyektJVk5nejdGNTFYL3cy?=
 =?utf-8?B?THB4OC9CVVp3YnY3SEVzOGtGVm00emNSMWR2NmZhM0FtOFhDb2hxaVQyWDNX?=
 =?utf-8?B?S1JKSUlBWVkxU1V6NC9ScGl6Vkdid1RBTGRmUlhpTzBlOFVKMXN2dFFwUjhI?=
 =?utf-8?B?dU1FTVVOSUEzZjZDWS95dkhzVWtoYkFFbCsrdUV1RkNRQ0R2UDNrbnJtdHVh?=
 =?utf-8?B?VXVheEw0amFSbFVZUyt5SDFrSldra3pabTl3dFdQMDE2KzJGN0E3MTJOeXhy?=
 =?utf-8?B?SlR0VVpNbUQvSnZDRTNXSkpCL0JBNk93WUlvVHUwQkh2cUhNVnRNTTBFNGdJ?=
 =?utf-8?B?N2VSY2NLRExUU1h4SmFHL0h4bG8weFVmN1hmbXFIZVR4ZHN0dE9RUU1qWnNr?=
 =?utf-8?B?d3JtS29ML0FRclI4Ykh1YXd2aHMzMFhWbDZZZ1VuY3F6Qy90RFZ3Vmt4NkMz?=
 =?utf-8?B?akwxS1NvMC9pNURrdm5WeEdSRzQzdndKMEFXdzhibnROditnNHpyTUtmaG5n?=
 =?utf-8?B?OForTit1Z1Fsem04dGRXdWpjYlNtS3JXOWZaY3AxTEhlUnZ6TmxQOTA1SU1h?=
 =?utf-8?B?Mm9ZR05KdWdzb0ZBYVpIVXhqM3Y5SXdRcW55NVYrZTd5eFRkVXEzTEtiYi9V?=
 =?utf-8?B?bnBtMHVsMHZIVmVqeHhDemluMiszNjJLZ3krU2N6RnlWOTNZVEplaW9JdzN2?=
 =?utf-8?B?NUpyWXQ3Z2dIZmRWY1JmRGRVUlpJMUdINDlHVkZqUFFCaVQyZU0zeVRGTHBm?=
 =?utf-8?B?Wms2cTNsenZSQmZKMlpBeWw0d3M2VTFPRnVHdHVrbnVqRGQwUFZNSEhoZXd2?=
 =?utf-8?B?OTFPRG1jV1RON1VDbjJnRitmQ1o0eXF4cXZyT1cveHhMeElUUzJVKzhPZW1O?=
 =?utf-8?B?QlN4aVNnMXFlOEZpazZ3YnhIYmJ6ZHhCOFlkaUc2ZUJESjM2bkFMWXhRTkJl?=
 =?utf-8?B?MWRCSERRZTRFQWw2VWxNb013aFNkUGdsOVg0SmFKUEpxcHZLZ3JsQXp3Q092?=
 =?utf-8?B?aWt6UFhzTGNFTDY3L0hOU3BvVnFBRnlvT0dMQ2lMaVlpaWFYR0NENCtLOEhZ?=
 =?utf-8?Q?GghVojOk3CrDM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d738e2fb-9758-4d1e-2588-08d904cb4776
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB4720.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 13:42:17.6591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsoWy1FrpaIyKLMdawRfQKB+6mWj1LrwjT3mnIiUD1JuUu8y89we+IFz0N0cz4WViYchUPmYZkWNbG8zx3D5/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4749
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/20/2021 9:38 PM, Huang Rui wrote:
> Some AMD Ryzen generations has different calculation method on maximum
> perf. 255 is not for all asics, some specific generations should use 166
> as the maximum perf. Otherwise, it will report incorrect frequency value
> like below:
> 
> ~ → lscpu | grep MHz
> CPU MHz:                         3400.000
> CPU max MHz:                     7228.3198
> CPU min MHz:                     2200.0000
> 
> Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
> Fixes: 3c55e94c0ade ("cpufreq: ACPI: Extend frequency tables to cover boost frequencies")
> 
> Reported-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> Tested-by: Jason Bagavatsingham <jason.bagavatsingham@gmail.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211791
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Nathan Fontenot <nathan.fontenot@amd.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: x86@kernel.org
> Cc: stable@vger.kernel.org
> ---
> 
> Changes from V1 -> V2:
> - Enhance the commit message.
> - Move amd_get_highest_perf() into amd.c.
> - Refine the implementation of switch-case.
> - Cc stable mail list.
> 
> ---
>  arch/x86/include/asm/processor.h |  2 ++
>  arch/x86/kernel/cpu/amd.c        | 22 ++++++++++++++++++++++
>  arch/x86/kernel/smpboot.c        |  2 +-
>  drivers/cpufreq/acpi-cpufreq.c   | 19 +++++++++++++++++++
>  4 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index f1b9ed5efaa9..908bcaea1361 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -804,8 +804,10 @@ DECLARE_PER_CPU(u64, msr_misc_features_shadow);
>  
>  #ifdef CONFIG_CPU_SUP_AMD
>  extern u32 amd_get_nodes_per_socket(void);
> +extern u32 amd_get_highest_perf(void);
>  #else
>  static inline u32 amd_get_nodes_per_socket(void)	{ return 0; }
> +static inline u32 amd_get_highest_perf(void)		{ return 0; }
>  #endif
>  
>  static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 347a956f71ca..aadb691d9357 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -1170,3 +1170,25 @@ void set_dr_addr_mask(unsigned long mask, int dr)
>  		break;
>  	}
>  }
> +
> +u32 amd_get_highest_perf(void)
> +{
> +	struct cpuinfo_x86 *c = &boot_cpu_data;
> +	u32 cppc_max_perf = 225;
> +
> +	switch (c->x86) {
> +	case 0x17:
> +		if ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> +		    (c->x86_model >= 0x70 && c->x86_model < 0x80))
> +			cppc_max_perf = 166;
> +		break;
> +	case 0x19:
> +		if ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> +		    (c->x86_model >= 0x40 && c->x86_model < 0x70))
> +			cppc_max_perf = 166;
> +		break;
> +	}
> +
> +	return cppc_max_perf;
> +}
> +EXPORT_SYMBOL_GPL(amd_get_highest_perf);

Should this be an update to cpp_get_perf_caps()?

This approach would ensure that all callers have the correct value
and remove the need to fix up individual callers to use this new
routine to get the correct value.

-Nathan

> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 02813a7f3a7c..7bec57d04a87 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -2046,7 +2046,7 @@ static bool amd_set_max_freq_ratio(void)
>  		return false;
>  	}
>  
> -	highest_perf = perf_caps.highest_perf;
> +	highest_perf = amd_get_highest_perf();
>  	nominal_perf = perf_caps.nominal_perf;
>  
>  	if (!highest_perf || !nominal_perf) {
> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> index d1bbc16fba4b..3f0a19dd658c 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -630,6 +630,22 @@ static int acpi_cpufreq_blacklist(struct cpuinfo_x86 *c)
>  #endif
>  
>  #ifdef CONFIG_ACPI_CPPC_LIB
> +
> +static u64 get_amd_max_boost_ratio(unsigned int cpu, u64 nominal_perf)
> +{
> +	u64 boost_ratio, cppc_max_perf;
> +
> +	if (!nominal_perf)
> +		return 0;
> +
> +	cppc_max_perf = amd_get_highest_perf();
> +
> +	boost_ratio = div_u64(cppc_max_perf << SCHED_CAPACITY_SHIFT,
> +			      nominal_perf);
> +
> +	return boost_ratio;
> +}
> +
>  static u64 get_max_boost_ratio(unsigned int cpu)
>  {
>  	struct cppc_perf_caps perf_caps;
> @@ -646,6 +662,9 @@ static u64 get_max_boost_ratio(unsigned int cpu)
>  		return 0;
>  	}
>  
> +	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
> +		return get_amd_max_boost_ratio(cpu, perf_caps.nominal_perf);
> +
>  	highest_perf = perf_caps.highest_perf;
>  	nominal_perf = perf_caps.nominal_perf;
>  
> -- 
> 2.25.1
> 
