Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF336D0EF8
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjC3Ti3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjC3Ti2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:38:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08C66EAD
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680205107; x=1711741107;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6KW8ggtpaLLjIKpA6cbnMUzKOmG60LaMw7Jdn7r0UgA=;
  b=Dnd+T78yM3a1XzYax4Hf3zQVaw260TO5tiVzPG3nH4IGC6Jjt9WvfPYH
   TjpIUCR4VVAQXDZ5da5pJmGn9JxJfvCxjjYLbSvHZNXZRaDkRCiQh4B2w
   hNL6xhdPL6dUTC2ORdi2XlDsamDVe3wWbEhCKgta9np2OavkYJMTudTEA
   sBj0TjMWCA/bd0zl0gfLZptc4ESCtB6k46qZL1cjnhVDGgva6GmvcZL3Y
   tDX28kMUfWNeJRvyOy2GiHzpzILMpVrGIRRAMcIGZS1kNpq2oLyfD6K97
   cx3xMNHPOVSqPWj+otrKySZC0UKxy5e09TOkQ09td+TzjMLy9oiYJxNCV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="403964550"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="403964550"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 12:38:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="754156156"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="754156156"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 30 Mar 2023 12:38:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 12:38:26 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 12:38:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 12:38:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 12:38:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUrQ667OH24qLx72ouN0XpA9ezL12urljgxBVh8OFfSG3Hph/1H0nMju9DanyLmLroMGrZ2iXcCJzvxOSZvEKct+xbZuAVbo5HnYCeQQ04ECfg1fQVlhIMre6pp53ZX2WIGk6fxyf/4o2f+EAVAfAZWrHBbENkAEA/uOgvB1LYa7WslEsW/w+TvtiUilhlK/Yco2A6vv9PvtptTAx7+fFjwsTppC3/a8F6t/A0JWWGTcre+LAKlVHKAO2SWISq23WXv9JXJIn7r2F7pXpixWWVURhEubEVxfDT4b8snxZuf5bZYrQz5JqUFi21E720IxvqzpeiVKN5Fr/Pwq1i3ndw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xe2rKnO79IZWi7yLcukBa3bObsgATNfRTrJ/0OWYj8E=;
 b=TSyEvXS0vN4Bjf3clNh56tEzTxf7043O3Swdcw1c+p9lFOprXCvIrE56ir4RwrzeDzGblAoYYr0HYtSX/8WIrs9JemKx9Gc9DJA0zBexExdPxn5YHzNdTX7a1mEESt0sSmzMevI+fi54dWStjmXgjf/7UUTLtkXHK18TI36fmB09ZHa3xwJQMzUqUU/VPHkAqYSEFtTcQi0KVFiO+0qDNNCHBTb8KxwlVvjumg7xACwF9Tkv1Q8zXIcS58bWWSBZKLazF+6AEu52E/Mw+QQvZFdR2jDrcQiUMm/bVilTIRpHWGXW9aosHWGen7YP/Coij55a1y4e49LtPwd8dDZ1aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4226.namprd11.prod.outlook.com (2603:10b6:a03:1bf::12)
 by PH7PR11MB6452.namprd11.prod.outlook.com (2603:10b6:510:1f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Thu, 30 Mar
 2023 19:38:23 +0000
Received: from BY5PR11MB4226.namprd11.prod.outlook.com
 ([fe80::6cce:2fa:c480:8bf0]) by BY5PR11MB4226.namprd11.prod.outlook.com
 ([fe80::6cce:2fa:c480:8bf0%6]) with mapi id 15.20.6222.033; Thu, 30 Mar 2023
 19:38:23 +0000
Date:   Thu, 30 Mar 2023 12:38:18 -0700
From:   Matt Atwood <matthew.s.atwood@intel.com>
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [v2] drm/i915: disable sampler indirect state in
 bindless heap
Message-ID: <ZCXlKkrKkvrG0T4f@msatwood-mobl>
References: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
 <20230330174740.2775776-1-lionel.g.landwerlin@intel.com>
 <ZCXipYU8ULR6eEPc@msatwood-mobl>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZCXipYU8ULR6eEPc@msatwood-mobl>
X-ClientProxiedBy: SJ0PR03CA0284.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::19) To BY5PR11MB4226.namprd11.prod.outlook.com
 (2603:10b6:a03:1bf::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4226:EE_|PH7PR11MB6452:EE_
X-MS-Office365-Filtering-Correlation-Id: a91390fe-4bcc-41fa-892e-08db315652ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xll3MLhHanR8GY7lQXKC9rwNkcnUzsYg+gwV37frQjsXHvfw/KmyzAVlzR41TXBzUdrWemUCFPdXcgNZmLWsxvx9ZHx1BeCQ785ePLjeSRVtJsenDhG2EsmPweDfTrJZOSKw6/DxlDAdqQfnX3yn5NBTKqcvjlucnqGBwaHdavHwe6vl5/r93QOSTu1lVY2MzA16PQXDjjLKYV871jePeXWDO90rYs5Cic86VQgRo/4vLUu0yc/yhg077zSVP54aJOAEhXrWYJCpXxRosK4yZF68kgwoPj3vOGkJuyqzrpbCidsfH+MGN/ehQG1H+azImxMh/TqpcyqrxAaUP59WX8SJdZ1enVQAqGdBlxEOelFh4l6c3CTYXYvclA5DSI4kVRpVFXpoNf+p1f7nCrywFC2SRk1WNpTTosIEPRHiajUtP8/q/COyXtpYofA7oBaQkz2ELspUxNGZpepqVDpt88f9UDSEo9mz8qbO8lSF8iEhojihJ/PV1Tj/xEplVGgP1JyQnakc3HOp1cfGO4y2dMiQaJuVTFo2T8PR2SEIHJF4mItQPiR/M3FTqVdPPvKt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4226.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199021)(82960400001)(4326008)(5660300002)(9686003)(6486002)(26005)(316002)(6666004)(66556008)(33716001)(8676002)(8936002)(83380400001)(6506007)(66946007)(86362001)(478600001)(41300700001)(2906002)(186003)(38100700002)(6512007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VG9zSDk2RlFxUHQ2S1BvK3RCai9SOWZZNm51d1IraklVYlQyVEtTYzVnamRD?=
 =?utf-8?B?MGtVd3grOVFVbzJMVHdlSzVuMzh3OFFyd1dhRDRtWGlrUmtOQW50MlZLTU5K?=
 =?utf-8?B?MEtGTXM0c2ZaMzFQVTlQeUhhb1hjS2xCcHlJSW9GcWR3SHdOY3RUTGovcjNh?=
 =?utf-8?B?RWcvN3ZKUkZNa2RnMVVUQU9HMzQvL2xTUWF5MUU0M2hVZU5IK2dTQzhoTmVT?=
 =?utf-8?B?ZW1CbFcyREhnbzV3YjlNSEg0QVJkSk0xVm5QWjJQUkN1M2pwd0plS2pVRTVD?=
 =?utf-8?B?Y1BNVkxPNU5ROTNzQ09OcWFPVHZCcDhUVCtRYjdONkkrK09aZWtJSzdESVhS?=
 =?utf-8?B?WEJDYStWMEoxRE4wNW85cXNrU2U5N2xqZ0lrZzdrUHl1dkU3MFEySUs2WG9p?=
 =?utf-8?B?MUlrUjRGM21vUXdnOVNsZ1FpSTF1OUxRVkFYMjIvSVIzQ0wyR3k5QWh2cEpR?=
 =?utf-8?B?dDNOdmgzVGNhQzlXNGlJUmRqczVUL2JrOUZLLzhDdXoyb0lpREFhQnpUQXIr?=
 =?utf-8?B?M0JFUFdJY0w4K0tIWm5ZcE1icFZjdWZpT0ZsTkE0Qng0NlVscVBRaXVGa2Fp?=
 =?utf-8?B?VmdTRXY2SEFMcWVBQjhKSDdMZkJueVZXVGIxUUlaVTYvdW1vNGJuci9qVVJ2?=
 =?utf-8?B?bnY3OG5qenFBSUlWZXI4VUlHanJIVmF3SGtMZkdzUDMxNXhkV0V3OS85LzN2?=
 =?utf-8?B?NHNZQ0lrcEw0RmZtOUJiT0RId1RVakNuQUczZDVEN3FRV2RoSjZGRjNJNlF3?=
 =?utf-8?B?OHdMMjZGdk1HVDhHZ3NFd2taTHNmbnVkdC9lVmIrZ293aDNYQWNiMVZ4WkR4?=
 =?utf-8?B?bW5ucTJKSUl1NGJPRGl4OUIvaUdhbk0zbmtFOG5NMmNpOXc0UURuWUhKbTlp?=
 =?utf-8?B?QVlleHpTMVVvSnl4YlJWd0wwMmkwa3hSdWI5ZUlWZW9DbUVRVmxuYVJ1bVpt?=
 =?utf-8?B?aExDVVBVUWg2dDNpWTJoY3NQOHJCZHZvazlwdTRuQUhvSlBtdy9WazQ2SDRP?=
 =?utf-8?B?dTVqbWJnNWtZdFcyamlya3Jnc3VZUG1iNG9wb1E3MU9WRm5iK3BsaU1rY0lC?=
 =?utf-8?B?a0VUYTUxeVlCeUZ3cmJyUXNGU2x2d0hVRkQzNi9ZV2prTXBheStkTEd6SERp?=
 =?utf-8?B?M3Z3ekdTZ2pOa202YWNuQ0hFM2N2S0V0OTE4SDdjdnFydVlhanB4OUpqNndT?=
 =?utf-8?B?WGhqclc0VkMxVEwrbUo3a1Fodlp0NkpsclU0NW1Qak5NUlNnUHhvMGFNRnlr?=
 =?utf-8?B?YWVycXBpUG5SNFZPeGEwNHkrV2licGJGeUdTb2ZoNVJUak1WNFVEemRxUEdr?=
 =?utf-8?B?cno4clFWWG1ZdnZnY1VCajA4R2VDSXI3eDljVlhFUnp4S1o5TmpGakZIcW96?=
 =?utf-8?B?RkpEdC9iN3BTMEpjYml4ZE1PUHdBLzBvbmpLUUE4RzE5K2g0TjU3cGFDTmE3?=
 =?utf-8?B?RUQ3MmZYUzJYVVBPSUxNSW1BWG5TQ2lvQzRHZXJ6bDc3Y1hHdkN1S0F3VU5j?=
 =?utf-8?B?dlJOb3NScWYvU284K0lBKzVtMXdJWlFlTFBxL09NQWlYT3BBRy92YithdXM4?=
 =?utf-8?B?OUR2N0dEY1ZsTFE0SEpydm1WSXpLTkZIcUYvaDQwSWM5MlBHOW1OM3VKd3J4?=
 =?utf-8?B?NUg3ZmVheEJRc3dTcDJ0WkdDMHhudlJCY0lTVFh1NnN1a3NiejJVQUNhVTdp?=
 =?utf-8?B?RXJnQ2pBR3psQ0tEMzYvcENpMGNpdEhtYkZkT0tlYVNYMU02bmx6Ti9Ca2lF?=
 =?utf-8?B?Z3B2QU41NXQ0OGljYzNxOGlHNXVTQUdQeG1oRk9RRFh3U2xXRjQ4QXhJdXY2?=
 =?utf-8?B?SzI4OExDNCtvUkZOTHdKRHlIRTJoRFZZZy9iZ3NwUTRQcHVTeTloWkYyeW5T?=
 =?utf-8?B?RDFSeS9abzQ5OVBtVFhvelFBRHlDSE02NlI4RUhIU3dha3c3amhvekRjekpv?=
 =?utf-8?B?SWpzL2txZkR2c0NCYUFJdjBlcDE5YXp1WFNxclpZdCtyRmxpNC9KQ1ZmZWNy?=
 =?utf-8?B?Z2NPV0RZQjhMQ1YrMjVGTE1XdStzUFI5SEJOZVlzK1k0T3NSYk5uWC9wRVha?=
 =?utf-8?B?QVMwa0JVVzNjZUZ2clhBbHY5TWFYSGh2dWxiSHJvOG01b1BPYlBWQ1ZFUE1F?=
 =?utf-8?B?YkUvbXdINHRkR1VocS9QZk9ValBuaXYva2s2Qkg0MlhXczJYaDlMK0pDQTJV?=
 =?utf-8?B?M3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a91390fe-4bcc-41fa-892e-08db315652ab
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4226.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 19:38:22.9293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7/euLSoZloX2HT9InVOMw9K0omZtckGGuLQGMtM/epyWfiiS8W9zNFfhJOgFOrxH0g5I+HyVKURmV3pbI4FQbHzga4kTxBRkNpQ6kkSmVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6452
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 12:27:33PM -0700, Matt Atwood wrote:
> On Thu, Mar 30, 2023 at 08:47:40PM +0300, Lionel Landwerlin wrote:
> > By default the indirect state sampler data (border colors) are stored
> > in the same heap as the SAMPLER_STATE structure. For userspace drivers
> > that can be 2 different heaps (dynamic state heap & bindless sampler
> > state heap). This means that border colors have to copied in 2
> > different places so that the same SAMPLER_STATE structure find the
> > right data.
> > 
> > This change is forcing the indirect state sampler data to only be in
> > the dynamic state pool (more convinient for userspace drivers, they
> 			       convenient 
> > only have to have one copy of the border colors). This is reproducing
> > the behavior of the Windows drivers.
> > 
> > BSpec: 46052
> > 
> Assuming still good CI results..
> Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
My mistake version 3 required. comments inline.
> > Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
> >  drivers/gpu/drm/i915/gt/intel_workarounds.c | 19 +++++++++++++++++++
> >  2 files changed, 20 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> > index 4aecb5a7b6318..f298dc461a72f 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> > +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> > @@ -1144,6 +1144,7 @@
> >  #define   ENABLE_SMALLPL			REG_BIT(15)
> >  #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
> >  #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
> > +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE	REG_BIT(0)
> >  
> >  #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
> >  #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
> > diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> > index e7ee24bcad893..0ce1c8c23c631 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> > @@ -2535,6 +2535,25 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
> >  				 ENABLE_SMALLPL);
> >  	}
> >  
This workaround belongs in general render workarounds not rcs, as per
the address space in i915_regs.h 0x2xxx.

#define RENDER_RING_BASE        0x02000


> > +	if (GRAPHICS_VER(i915) >= 11) {
> > +		/* This is not a Wa (although referred to as
> > +		 * WaSetInidrectStateOverride in places), this allows
> > +		 * applications that reference sampler states through
> > +		 * the BindlessSamplerStateBaseAddress to have their
> > +		 * border color relative to DynamicStateBaseAddress
> > +		 * rather than BindlessSamplerStateBaseAddress.
> > +		 *
> > +		 * Otherwise SAMPLER_STATE border colors have to be
> > +		 * copied in multiple heaps (DynamicStateBaseAddress &
> > +		 * BindlessSamplerStateBaseAddress)
> > +		 *
> > +		 * BSpec: 46052
> > +		 */
> > +		wa_mcr_masked_en(wal,
> > +				 GEN10_SAMPLER_MODE,
> > +				 GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
> > +	}
> > +
> >  	if (GRAPHICS_VER(i915) == 11) {
> >  		/* This is not an Wa. Enable for better image quality */
> >  		wa_masked_en(wal,
> > -- 
> > 2.34.1
> > 
MattA
