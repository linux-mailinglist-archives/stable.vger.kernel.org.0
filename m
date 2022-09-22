Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C275E5ADB
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 07:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiIVFpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 01:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiIVFpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 01:45:10 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B923B63F39;
        Wed, 21 Sep 2022 22:45:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m36+TRDZjF22xnNFHv9aUQgeJdr4xgrjvP7Kgp9Uq04jrsbrFMiEqFmr88OeFOvS3ZPjK/9GuXS+147hYdYE8Xdtt8mYschiY4rInZgNxPWcn0+hCAqGEeyFjSDyAFn2zYUtVmRU1IYawFYRoQLUMvzfPMClRtHjrXZv6AHJ/EqqEl1AP/jtm2XWglVCxyTq1d6Cw4JkMf4Nu2UAAHcHzrF4lUtFDPUZVFkHcevc9HQACl/M7XKBG0is0U8d0g5x1Yyswcm0Ut/q6y6NTSG2Em/IFuXtxAXxhI8ytFR5cBO9gNEvFqODwogrb5YgZiFhn4qJ6Eyg3nduQ0et7g2ILQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQYRJA64N//FndQqB16YrMfBCnoM9+SjNmvcAslXCYs=;
 b=JyqfXnibupEKOVg5ICUI/bK7ziOHOVrxm6DTpgGu+GCemv3VH7FNmOV76zPmyRt25NyIuldTP8ky/irLyuTxSy2/9nlZqSQsSgLt8I0hCxbpyLjwi19UXUPcnpu/nct1LWYY7KywUH/SW17sf4YxT+c3ynG4AJat1zhTMeSTntkklJ+Q0h3FM+/S9Ado8WJ/LmiRMeU3TT4knEtDBLBJaof8M9f9VJSwtmWUSINmyelBtpg3SDXo+cSVlNM3xff3koHQJpldKsjVfSnq4k2OLiT91YKHlUQSS7ESN+ePbOSupvjVXn4te9UEP4ifBPwBWO/6iW+DmmTbaajG60uocQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQYRJA64N//FndQqB16YrMfBCnoM9+SjNmvcAslXCYs=;
 b=SJVGWcEdJRP3rHbKFnAoPcxLF+gwixuf1XndDShx8OxpYg7K5XfVJcCg5yAxnRpj1MZI8cH9Z2LwGFXk/0801AuYBz8C2KNIihT5n3SsjmQQsvpfoM7gOY/iD3UgP2s6enXLmOQXO3jeQo28gTKtvMCWDoJCpXdSvl9jqlJtEgE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2381.namprd12.prod.outlook.com (2603:10b6:802:2f::13)
 by MN0PR12MB5811.namprd12.prod.outlook.com (2603:10b6:208:377::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 05:45:06 +0000
Received: from SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33]) by SN1PR12MB2381.namprd12.prod.outlook.com
 ([fe80::c534:ae1c:f7a1:1f33%4]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 05:45:06 +0000
Message-ID: <69a3f699-257a-1579-3ae6-236dd19b5381@amd.com>
Date:   Thu, 22 Sep 2022 11:14:45 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org
Cc:     rafael@kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, dave.hansen@linux.intel.com,
        bp@alien8.de, tglx@linutronix.de, andi@lisas.de, puwen@hygon.cn,
        mario.limonciello@amd.com, peterz@infradead.org,
        rui.zhang@intel.com, gpiccoli@igalia.com,
        daniel.lezcano@linaro.org, ananth.narayan@amd.com,
        gautham.shenoy@amd.com, Calvin Ong <calvin.ong@amd.com>,
        stable@vger.kernel.org, regressions@lists.linux.dev
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <2b6143b6-9db4-05bc-1e8d-c5d129126f99@intel.com>
From:   K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <2b6143b6-9db4-05bc-1e8d-c5d129126f99@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0190.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::15) To SN1PR12MB2381.namprd12.prod.outlook.com
 (2603:10b6:802:2f::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PR12MB2381:EE_|MN0PR12MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: 14fb7e2a-e373-4fa3-e315-08da9c5d9a05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +RgrltLvlZnJmbP6RIG0cvy5GZEk8Lqkh5ZVywsNfxqkI4WbQ37+IkGLtIh0RMBmumirQyOq1S8xWmMQIKLHHu/PcxBxqm4EcMNlTGnV8REa63/mkJKy7SUVDrIA3H71lrOUj1UQs1YqRMslsOUDuDIlyVV2hKqw6XffT/aVpi1R7gDIoXrcXoKzsf8omblsMUl5np/hfPqlxZjMA/CShNRN/V2fs4xw8AQGgsJLJRFjrY9xvbdPSeMPfCP02O7S7ANL19Ien3l5HvYU8DGyyofdZn8s4/zoKnWJsARmgPT+MunEzShjndn4DAAlwaGaHTkpnZbpm9g+vcocNSIJe24vKfHCMCPomQp7/qn4aTO5M9FGM5aSaPyc6mbfk5uNbJONcT6tOSpMSscSuBoxLBivQ6MSjt8p6alfWt3TQBCMQPdKdIUWlKV5HMtDO0xN4uHNLdr8oTk8HtibVhi48m+qFRtZfKROQzA6Hk5uEAWVpBZtBYP4VUWxWvJivyI3K5XaeYUf1lamhaJgMWRQcEJghblt+9VffQqpS+h6cCs/NzcnddCYU47youlbnhQnYzDll9LDVnYh3KtMWtSnsoAXiZM493rOQdyw6x3XXWPR1U5p0/gVFlFaiMBuRf7HmT2ILWT7SJklgdy8VU21z3Vy+NkgMyPu1qTh1RlSO+afpvtk940NJuhX/D5y3O5w5p0MPyxcS81GzZH+tfdmrzLjFyok00l0RtUJvkHxqehzHqnlqTaq/iNCY7kOHYVIQoa6XECDRK2Ovh0BN/hySNRU3+D9tvUKSLWZBoB7b1U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2381.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199015)(186003)(26005)(6512007)(83380400001)(31686004)(7416002)(86362001)(31696002)(316002)(66556008)(66476007)(6506007)(66946007)(4326008)(38100700002)(53546011)(5660300002)(8676002)(41300700001)(8936002)(2616005)(6666004)(6486002)(478600001)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHN1QzZUZHRvYVE1ZnRmWUlBdDhsaytKUmhOdC8rRU8wcllSZ29TeXNBSThn?=
 =?utf-8?B?a1djS0lzYi9jT1hINC9qaGQyUFdFVFdRbmdUZFgzQWUwYnFrVWlTaXNuNlJ6?=
 =?utf-8?B?c0J2NXFaMzhpbHI0b1VxQmFNcUIxYXE2aThXZ0pocWtaWkJCSDJzaXJ5SzRR?=
 =?utf-8?B?SlpGM2E2dkVPZmJ0dVVyS2JTM2F2MFY2Zkx6dVNxWWMyR2tkSkJzdFVNZUxE?=
 =?utf-8?B?Vnc5VElLdlJTVi9oWEZ4ajlUaG14eVRGYlRhbUFFN01DWm4zMHZQaDJ5RDRk?=
 =?utf-8?B?eTM2Zy9KVC8yWGZSNjlXSHdSTnpCTGZmRG9DY094aXhkNDV4UVQyVFF3OFV1?=
 =?utf-8?B?UkxDK29tcmorUDd6YzROVUR6TWk5c3diekZ5aTVHQ0JSOXp6dkhNSTlBL0JO?=
 =?utf-8?B?V1ZsU0dHTHMxUzFDUTdONVBhMWwvaVVwL0FGd2xsdHVuUmdmUHZlWmF4UGhj?=
 =?utf-8?B?YitsNVlnWG1JeFloUWgzdGRMbzFQWThQVGZCaWNrVzByd1BZNTdPUFY5Mml5?=
 =?utf-8?B?MHhLOEE1TEFKdUx1UzFmbUxqM0RzMlZkZHhheFJPNlo0WFBJZnpmejd6RUZk?=
 =?utf-8?B?SHVOR2xlWmFuODdBSE1tUFZJQ1J4d2pqVHova3NuekVVdnV2UEJueU5pWTNZ?=
 =?utf-8?B?cExlSE9KYkF4SDhtdU9mSFlYS3hNTjE1cWJMSi81ZzYxRTNwVloxY1pwbTJh?=
 =?utf-8?B?WmhJcVlabW1qOWZlLzZMeExHK2xsRFlpNXhYWjUyZmRjZHFZMWRCSC9qaE1L?=
 =?utf-8?B?NmlkVm5YdFc0QzBURmN2N2F3YUNwWW8wOHM4OE5sT29jL3ZJOVkrekdWRURB?=
 =?utf-8?B?U2tSbStpRVpqK0NydmJ0VWdXMW9sVE44YzVQSWQ2VHZxaXdocEYvZk9RU1Fr?=
 =?utf-8?B?K3QrTjZHNmd4NlFybklXbmpKbkgwT1l2MWRYeFJRaEZhVGtiZVRjZTEvSXp6?=
 =?utf-8?B?d1lydmgxVlYvVWlZNEZJcjN5RzZ3YW1mOVhySElYaHFucDBIamxuZXFraE13?=
 =?utf-8?B?NWh5LzZwVFkzUkVnWGxVNE9qK3JyQ3M1QjNubURWenI5NXFCUkhDd0s0VmpY?=
 =?utf-8?B?dk5XMnVOS0gwOC9mVk1XMzFydFgyQnpzUzRCUjBWWndqVVVXVTV3akZaQ3M1?=
 =?utf-8?B?dDVWejhPNHQzb2FBeS84d3BvWnNtTUNlYWdVdzNJWk1IN3F0bzJSR0FmSmNI?=
 =?utf-8?B?ZnNtN1NCSkpSWitOREdzbUdlWUp1VnlueUlzc1hmU3M1R0QvckNSendNOWpv?=
 =?utf-8?B?TGE1WldMSUpSLzlzaG5FQmM4SFdsWlZHVmJIb0JqbkZWamRLbG54NWUyU2JU?=
 =?utf-8?B?My91cWVjeG1laVlQa0hkdFFKY21Md2Q5WG9NclRzTUtZSm1GNG1rTVg4ZCsx?=
 =?utf-8?B?Vkc4aDY5OE53MXpvbzYwbHB0TWIzS0xsRjBZb3hGNlBEYUFQUU0xNmNTdmtO?=
 =?utf-8?B?NTE0bHZHQlN1amlQQkdyaWRvZG1qQndoUzdKM1BEL0pwWHZVRVg2YnJlMjFF?=
 =?utf-8?B?YW1aYmJsZ2U3Q0xnQkZpUitoREtycXVoQ0ZpSnhnNnlQQWNzeW15YzJUei9x?=
 =?utf-8?B?V0R1YUJpdlRWanhOaEhhNng5S3RMcmdBVGt6WUtHUWJVLzJ5QkRma3VkeUlG?=
 =?utf-8?B?MVh5cnN1TzBsMHYxQnA0TnJWQ1U4dlg2UjFUbVo0azhXS0o4OThtekNVcjVm?=
 =?utf-8?B?R05oN3d3ZzdZdDEyRW4xSERsK1Rwaldwa0ZjZC9UMTlIMVg2R3Q1TmdRalUw?=
 =?utf-8?B?MkQxLzZHSDVCelFIQ1VUYzI2SHlyMkNNcElCeVF0bnRmR3Z6N1hxU28rd3Rn?=
 =?utf-8?B?aitUOUpUU1p0U09GdzZtcWdzT0U5cFdiU3pheExpU3dVT1J5WHhReU1nVnpr?=
 =?utf-8?B?MGJHMG5Tc084MzZxa1NuTmhKMEJueFJjK3ZEZnNjT3owYTZJOW1tcm9JWk1x?=
 =?utf-8?B?OEo0cmhJMElwa3NJVURlcUxoeUZidnVDbjFrTFpkeTdNMlMwbXdwQW1yaktI?=
 =?utf-8?B?SEp5VEVjMUw5NzBKa1lQYUpXdWp5MWJVY09zci9Vd1l2UDNXL0Q5RXpvWmQx?=
 =?utf-8?B?YlZQZkF1NE40KzBHNWo2SWIyWC95UzYxYVM2UUxNM2QwcEtjU3JBWk9WUTkz?=
 =?utf-8?Q?0ale68ecDzeYkhOdhAZDuds1S?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14fb7e2a-e373-4fa3-e315-08da9c5d9a05
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2381.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 05:45:06.1002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MS71s26Lq5RuAtQ1IxnK/Nb+/zk7edwJYQjLqr8B6tPwIVs1ZiaRDJoEcyUiO0mRnUlVWVIonVwzL2YJ4fahcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5811
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dave,

On 9/21/2022 7:45 PM, Dave Hansen wrote:
> On 9/20/22 23:36, K Prateek Nayak wrote:
>> +	/*
>> +	 * No delay is needed if we are in guest or on a processor
>> +	 * based on the Zen microarchitecture.
>> +	 */
>> +	if (boot_cpu_has(X86_FEATURE_HYPERVISOR) || boot_cpu_has(X86_FEATURE_ZEN))
>>  		return;
> 
> In the end, the delay is because of buggy, circa 2006 chipsets?  So, we
> use a CPU vendor specific check to approximate that the chipset is
> recent and not affected by the bug?  If so, is there no better way to
> check for a newer chipset than this?

Elsewhere in the thread, people have noted that the faulty chipsets seem to
go all the way back to pre-2002. Andreas's comment was added in 2006 but we
have no way of knowing if it is limited only to chipsets prior to 2006. If
anyone can confirm a clean cut-off point when this was no longer required,
perhaps we can limit this dummy wait to the older chipsets by annotating
them with a X86_BUG_STPCLK quirk.

> 
> Do X86_FEATURE_ZEN CPUs just have unusually painful
> inl(acpi_fadt.xpm_tmr_blk.address) implementations?

Yes. The issue becomes more pronounced with increased core counts when many
cores exit from C2 simultaneously. The core density is especially high on
X86_FEATURE_ZEN chipsets, none of which require a dummy wait op to ensure
correct behavior. Hence, we used the feature check to skip it.

> Is that why we
> noticed all of a sudden?
> 

We saw run-to-run variance in tbench with 128 clients as a part of our
scheduler regression runs. Originally we attributed it to the tbench
threads not being spread around uniformly, but the problem persisted even
when we ensured that the initial task placement spreads them out. Further
analysis showed that significant time was spent in exit from C2 in the
bad runs.

--
Thanks and Regards,
Prateek
