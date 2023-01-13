Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20AE66A39B
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 20:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjAMTqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 14:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjAMTpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 14:45:46 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2056.outbound.protection.outlook.com [40.107.101.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D6A7D1CF
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 11:45:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcRwin86COJOL3u+QtqBtooo2GK7mkARKjuKAQ3JLpwrPCFmXy+GlIngkedRudL3BzITu1ntFf8DAPUEaZygo55SA3mAeXUOjKlTONaWRNC5j2iJTecoRooDQPT367xhA+rNPV9p54WRuXJo6DABxFBr3roBOxUcS6k33zBxy8X4fvM6CaZiqGtV08xL+R2Cl3rAJl+aXhCfrONyv2wTXbdV8+EXo6YKyu4kKG2YMLnA4J4vYdTbBoO8dyperame8ttbUeG9T2r8JtnA1U3wif7uzWHYryKSBC4xohesZobNb8cLMz02x3xOLerYwr2EioG5tQZP9EcvkS5Xt5fhag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xyK9DJuIaulOrsDX5/0pyWgOqaqKU6xYHcFuh4R8esw=;
 b=B8pDWBeSREtAebETanfs8CBakQE3sqyhNh0wB8oufwx/LNAHz7+Ck4ilkVFTigffBhRrnkWZz6KJCO5MoD9N3iJMxxOdEdbAittWCEBKJSlRU2+LSqp0qAoe6KjpK40gNEsrJt+2Kx2v/xQcnECWfErhpSovBUutdUDSWhZAL4BfZIPCONWJIjWNXcy7HleYO9Y9mXhytIXHwJUgTzl9dYs27RBk+JktV+7hLkvhkwDQVN8PTXWAiZrurp2lFU2W5h3Mv62tJTbwi0JhgV2DIfUJC2BMA3+8KjVhuTA2AXFtzjdRtdfWgmI5TBA2a3QFHPsoWx2uSA4FnBx1xChJlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyK9DJuIaulOrsDX5/0pyWgOqaqKU6xYHcFuh4R8esw=;
 b=RSs6Z94R/G9sF6+xU6YTd2HDarYNRLY7kq0Fy1la8Hm20pgvPvUZY32erfJdlt1Se/oZTarK+1338CanBFRXim4mPdmZVsLkbENCeezy3qFyy0KR2Nu/wN2RqsEgJyCUtDozReI1de+f9hBLsfYyz+Gnf/H5nLkkRFld9r7aWE0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MW4PR12MB7016.namprd12.prod.outlook.com (2603:10b6:303:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Fri, 13 Jan
 2023 19:45:34 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a%7]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 19:45:34 +0000
Message-ID: <dcf0612f-7d40-d607-e9aa-94599594e49f@amd.com>
Date:   Fri, 13 Jan 2023 13:45:31 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] Revert "drm/display/dp_mst: Move all payload info into
 the atomic state"
Content-Language: en-US
To:     Lyude Paul <lyude@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Dave Airlie <airlied@gmail.com>, stable@vger.kernel.org,
        stanislav.lisovskiy@intel.com, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        bskeggs@redhat.com, Rodrigo Vivi <rodrigo.vivi@intel.com>
References: <20230112085044.1706379-1-Wayne.Lin@amd.com>
 <877cxqg2na.fsf@intel.com> <Y8ExtuE8fFyNnnXh@phenom.ffwll.local>
 <748aa93c23e6e4dd353054ea632a21c8017f8769.camel@redhat.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <748aa93c23e6e4dd353054ea632a21c8017f8769.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0132.namprd11.prod.outlook.com
 (2603:10b6:806:131::17) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|MW4PR12MB7016:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dd994fd-4f4c-44b6-cba6-08daf59ebc76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bM9yNYpVP+fdMh1l0cUyAhfZA+0yhxcN42VXXswP/AiKqXxPGUsb2ihBtEuWHzsWjyuAaiSnPUjX3l2L7Ci2vHTyAcACMs3Ytqu4HzjsqVg5lFELuN9vfST8tJ3mPo4hkj6RMXJghD4FlGLh/sn7zyDgeknpYEEfUsQqvD5v4lse1gLAiLoHCQUS+Jk83dNqVyLxD9r0p6L7V/TYDx2s7Bci130ucJYq0j/0fK+/s1lXgiapSZEGkyxmlddqmMhop8YWmzliN+bpA4rJDC+E+96Y5AKi0yD/XTDoZr8ja3TbPlQCYykO6/p+30lMmEMnef/1WrhOtNIJiIpCfY9p+/oCr2BTJFE7tdAnOOqouQkTeFh5GLJqhGJdUt9a16tET0n9YuT1gEYiifnsetXvF5AdMMvefPa5zA6LEA/boebPLcEbLdRvQ5+0PZc9axorjWroa9c3NwUMH1GMpfijOthG4gJCePEim8IytDD6EFyzUHJp02DXj54sMlXhMzxGjHC4jPABG03oHqopxKg0bL26Bk2b/U+fhZBYq9/UnQojMrgXCGWR5T1bDS31P5o3APSZuk+3SwsigAEIkSokT3YbH0yFqvIrphBYM5ghNKySO4PRsxzX2RcGSVkIV1JmLvGwA86Ha0ROve01wa1KuFloB9pAIMV5CinqclCpWMxPzIdAZUJr9lFqIrx4JfCf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199015)(66899015)(2906002)(7416002)(38100700002)(31696002)(86362001)(36756003)(31686004)(8676002)(5660300002)(478600001)(6486002)(83380400001)(26005)(110136005)(6666004)(316002)(6512007)(4326008)(66556008)(66946007)(66476007)(54906003)(186003)(6506007)(966005)(53546011)(41300700001)(8936002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTFDLzFsdmkzZWkxWkh5cnVwSXBqd0haRml5U0p6UGRqWDVtaTg5SmVTa1FE?=
 =?utf-8?B?RXVubTU3djVIVjVaWUhsRUNid0xpRnVzVzN0TlJQcG9UTWhueDcrdncyMUJv?=
 =?utf-8?B?dG9wY0M4aFAvWDRTc25TS0l1TklNQWtnTmM2SFllVFdUTzRvcC9zWStLbW5I?=
 =?utf-8?B?RkxZc2RISFJyTEhZdWxNRlA4dW81YkNZb2t1NEQvby9Kalo1dFVFc24wQ1U0?=
 =?utf-8?B?R3ZoZm14eENybFJNbXhZYmlJckFRR29BM0xJNGRsbWZPNHY2blgxRWY3TWFx?=
 =?utf-8?B?UlNLTGw2UXpXaWVJSUsxdXFoTWV1clVvMVExMzRjNWkrYnRkRHdSU3Fmb3px?=
 =?utf-8?B?Q2ZpNHNpWG5WVWQzd2gweXVxa2JobERsTk5LaTZNc2dRTldweFhRaHFQNEZN?=
 =?utf-8?B?bUlFaUxMTmVwSFMyb0VKeGw4U3hnMkMrRjVZeHVEZ3U4RTYzODBqU3JpZ2VZ?=
 =?utf-8?B?cmZIcis0Zk1JdGQyZzRuTS9IMEdFVmZ1U0plK3BBRldpVzVsd2R2cnhpbWo0?=
 =?utf-8?B?TkhjWUlvUWZOSEpqSnJDMEYydFVvbUN4Nkc2cUlwMHNzZzhlelNMYkFuejRI?=
 =?utf-8?B?Q1Zmc2FRdG5QSUNad0pUd1RLNmE4QVd4bVhPclZIcW5sd3dRSkFXSHhFeHBV?=
 =?utf-8?B?VE5xdm1pa3g3dlZZaHovU2svbDIwQmJLRGtxRHhuM281cTJJblVHTlh3cWRV?=
 =?utf-8?B?dllibzg1dVFPMmVlbDRCeEVjYWg3aXA3SkZ6WXdDR3FUQXhFVFBvTS9KdHlM?=
 =?utf-8?B?RmM0aUM0bFM0OFZoVkI4VWNUUXdiUU93aVVvTUNpcnFraGIvcFdqbW1LR2FB?=
 =?utf-8?B?ZGJaM0tHdE4wdFRsRTVJMUlQbzBLcXFEOEVac1BOYjA3VTB1S1V6TXlRNVJH?=
 =?utf-8?B?ck00WDV4emROcjNQclA1clVLTXFMM2ZqU3VzK3EvVEJOdit1RUpyS2p6WlU2?=
 =?utf-8?B?cVJoVnVMQWxNY0hWWnZ3dHBIUmpEcXF5c2tGV05wbm0wVksrb0JUK2ZtVzc2?=
 =?utf-8?B?eEtlcHdiUWU1YU8vZzBtTjJTTTRQbmZhY09CRVIzSEUvRnVWTU4zVUxWWWV6?=
 =?utf-8?B?eXg1K1JhMExqa29FQk1EcTI3Qy8yaEYyR3pjWDZZQ1FlQ0c2U2V6RjZWcGMz?=
 =?utf-8?B?bjlaK1RlZ0YwMmQ2OHJTaEJFZThhQWMrTVdsSDBGdStub3hZTzVGMmM4NmtJ?=
 =?utf-8?B?QzkzeHFSNFJmOGtoQXRpQ3pwN2diekxtV09NZFp6Z2Q5U3paNG9qVWlsMm1Z?=
 =?utf-8?B?ZTVoME5nK1cwUGJjMFZxcHNlVEZ0bnB4ZWpEREZaVDVFaXFSTDZQYzhTdkVN?=
 =?utf-8?B?TWZVd3lrUEhZUStDRThwOEJUblNScXl5RlViY2Z2QVZUZTB6azZrdktrSWFC?=
 =?utf-8?B?R1c0NnJ2VEtwWU5oakVQdHNXL2lrdnhsaG1CZkFVTkg2U1FDT212bEVQbkdu?=
 =?utf-8?B?a0RnQmRWL05VTm8xNnhtTmxnMHVGTXY1M0k0dGhKRk9RYXYraGxhcWNHWmpR?=
 =?utf-8?B?N1dtWFIwVHNndVVnajFiL2QxcDlmQ0xHdk9GYmNoYTgwQWQ1ckw4dHRiWXJY?=
 =?utf-8?B?Y0tEN0ZMVEFwTGVRNWhkOGhHRVI1N1BSK21LYUNUOXFhcFg4a2c2WmFURTdR?=
 =?utf-8?B?WitBczJWbzlZbURLdTZJRGxzNCtPQlgzZEx4Tm10cWVEZWQwZDNFR2V5RWVI?=
 =?utf-8?B?RDUzNjlPU2J1NGRaRDM5NG9qeWlmK05LWERCSk5idXhZcGhsU1pIVzYxVHhE?=
 =?utf-8?B?SGdKYU5OZ2JTOSt5a0V0VUF2cGdNTG9GUC9wSzVySFV1QzRnMmZxc0JaWmo3?=
 =?utf-8?B?S25zV2V4L21IbE5MelZDVGpMekk1cmwrTUxDMnRud0N2bVg4dUlMQUt3bDIv?=
 =?utf-8?B?WWlqcTZNTll2dzQzRFhtWFZNZ2RFaDZsMTdZU2VTUXVpaG1RNm5vaXZRWSs2?=
 =?utf-8?B?K0hhNEJSWVYwRFpQTTBzbGdBOXdaVkFRcE9LajZlQVVUTklqNGcwRStnZ1VC?=
 =?utf-8?B?bjBCNjFiOGs2RmhaaGlvMlZ6Z1J1UUNPNXFwS3BiZUNRMUVNUWs0UitnbVla?=
 =?utf-8?B?YmQvYlJiR0hWV1dzRDFGeXp0S21sVi9Iem52LzFGV1djQTBqZXIvN2JxKzhV?=
 =?utf-8?Q?0JD8ytaEidMbfaKO9r/U6Tn4B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd994fd-4f4c-44b6-cba6-08daf59ebc76
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 19:45:34.3761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +d0BXW+VOrb81EIuBS0GqHkL6SZ4HmzOXo/4O5HWwdnkMRjONACm2OhF/dl8GMIDwWNjBD5rDpkpRdket8T9eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7016
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/13/2023 13:28, Lyude Paul wrote:
> On Fri, 2023-01-13 at 11:25 +0100, Daniel Vetter wrote:
>> On Fri, Jan 13, 2023 at 12:16:57PM +0200, Jani Nikula wrote:
>>>
>>> Cc: intel-gfx, drm maintainers
>>>
>>> Please have the courtesy of Cc'ing us for changes impacting us, and
>>> maybe try to involve us earlier instead of surprising us like
>>> this. Looks like this has been debugged for at least three months, and
>>> the huge revert at this point is going to set us back with what's been
>>> developed on top of it for i915 DP MST and DSC.
>>
>> tbf I assumed this wont land when I've seen it fly by. It feels a bit much
>> like living under a rock for half a year and then creating a mess for
>> everyone else who's been building on top of this is not great.
>>
>> Like yes it's a regression, but apparently not a blantantly obvious one,
>> and I think if we just ram this in there's considerable community goodwill
>> down the drain. Someone needs to get that goodwill up the drain again.
>>
>>> It's a regression, I get that, but this is also going to be really nasty
>>> to deal with. It's a 2500-line commit, plus the dependencies, which I
>>> don't think are accounted for here. (What's the baseline for the revert
>>> anyway?) I don't expect all the dependent commits to be easy to revert
>>> or backport to v6.1 or v6.2.
>>>
>>> *sad trombone*
>>
>> Yeah that's the other thing. 2500 patch revert is not cc stable material.
>> So this isn't even really helping users all that much.
>>
>> Unless it also comes with full amounts of backports of the reverts on all
>> affected drivers for all curent stable trees, fully validated.

The silver lining here is that in terms of how many stable trees this is 
broken it's only 6.1.y.

Wayne's revert is against drm-tip.

I found that attempting backporting his revert I run into
conflicts in 6.2-rc3 because of:

831a277ef001 ("Revert "drm/i915: Extract drm_dp_atomic_find_vcpi_slots 
cycle to separate function"")

I worked through them and have the result here:
https://gitlab.freedesktop.org/superm1/linux/-/commit/8e926eb77c41e7f32f3d8943cdf7d140ed319b79

and conflicts in 6.1.y from the lack of:

8c7d980da9ba ("drm/nouveau/disp: move DP MST payload config method")

I worked through those as well and the result is here:

https://gitlab.freedesktop.org/superm1/linux/-/commit/2145b4de3fea9908cda6bef0693a797cc7f4ddfc

Affected people in Gitlab #2171 have tested amdgpu works w/ MST again 
with 6.1.5 with that applied.

To your point, we do need someone with the appropriate hardware to make 
sure we didn't make i915 or nouveau worse by this revert though.

>>
>> This is bad. I do think we need to have some understanding first of what
>> "fix this in amdgpu" would look like as plan B. Because plan A does not
>> look like a happy one at all.
> 
> Yeah this whole thing has been a mess, I'm partially to blame here - we should
> have reverted earlier, but a lot of this has been me finding out that the
> problem here is a lot bigger then I previously imagined - and has not at all
> been easy to untangle. I've also dumped so much time into trying to figure it
> out that was more or less the only reason I acked this in the first place, I'm
> literally just quite tired and exhausted at this point from spinning my wheels
> on trying to fix this ;_;.
> 
> I am sure there is a real proper fix for this, if anyone wants to help me try
> and figure this out I'm happy to setup remote access to the machines I've got
> here. I'll also try to push myself to dig further into this next week again.
> 
>> -Daniel
>>
>>> BR,
>>> Jani.
>>>

