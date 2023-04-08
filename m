Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7406DB7E0
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 02:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDHAr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 20:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDHAr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 20:47:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5410BE192
        for <stable@vger.kernel.org>; Fri,  7 Apr 2023 17:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680914876; x=1712450876;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dkw/5KUaNNv0KoLUYeDaOsZS296o44yw9edOXfkqi38=;
  b=dUgUYG3fGeojUn11xJfF5SGr/YVAi3NESz/Z2RjefzfWeF0NCjwt9ESg
   Pqu42eNU3Dbqm6olOceu2SDsCyU6HozX+WZz+wyn1RYrg8gWOecIULjld
   6x0dOOt79oECkiYsl2aGucfyPDc0sMiD95FJnYVxiBk9OD46sn42aWpjM
   uVpn50gctdvrEXF3HDpluymU1w8ZLBtT3QEGa3ztSw+mvyUKx+sEUjRxF
   VAytuGAsKnRP/7m/1hyng3JR+2PacKIFJwO1E0jTrJnXsdDv9YtdlNQRw
   HoUyFUYZmGIz57T+BKeRF4P1kCwc0GH2UlbV6SMiwHWZOr3WpA82Uhidy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="370928141"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="370928141"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 17:47:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="1017412450"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="1017412450"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 07 Apr 2023 17:47:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 17:47:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 17:47:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 17:47:55 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 17:47:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myAhZ8KvwmM77KhRnW1MyEj+m8dXdWzaP0+uTB8OXqAUfMjSlRxQ/0gb49UpAq5ieYgQOWunnXLxfkm8573kEJ+ELMDmmuNw12I3tMyvWmcF/rzENXadUekh/cDcCQinM25fV2lVhEBE7zawng677wCLeLN06ZGlf7LveuJ4wDBTqVO8QezAjp+WC6I9Jejj9WXHewkhe1EP0mr3GtGRbaOTLRe7GybTDdYE7DQKU0zPbyfq6eZAREHkPnMKcOLdsrjNtWLWqeTBaqlbcmQktRu+vzzmZ+hEjptKEOfM572FQ8Sa8S/YDIVC5C0V7GIMWO7CxaSmMWXpIqf9mthvZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/tKai+3dnDZmv98R9K/6/bJd0IqZHn599Vt09z4kGI=;
 b=epIZ5QSOmFxj3vogoLRwSr3S467ZbQL61L/akjhWDsOPN6IahwX78sN8vb3+lLegA88yYgmpQmGKZ/upFM7tNly72Xea921HJUIIIiFd4dPDjqiQ6n0Aqsx8GPl3RgdcUqzNBO9TlCTZcP1dncW/0MqNsSvqo7GPXQQSXjBUIU665lVLwdPFnyIFuFu8tkjSX4Ac3k/WWea2fkjyhP1v2Dy1dgL8YMaKHvTP4+yk8JxLI2F9Gz5nWJXG14/D4cQs2S7m5DsZZDwgLJR4GR91Ne65yEcLFKku+iaBS4Lxnj97ehBwQxdLcakAY2O1+uw1Xnl3c4Myw0QKMCuatFnxHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB7859.namprd11.prod.outlook.com (2603:10b6:8:da::22) by
 DM6PR11MB4546.namprd11.prod.outlook.com (2603:10b6:5:2a7::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.30; Sat, 8 Apr 2023 00:47:53 +0000
Received: from DS7PR11MB7859.namprd11.prod.outlook.com
 ([fe80::1c61:b69d:4ca:10d0]) by DS7PR11MB7859.namprd11.prod.outlook.com
 ([fe80::1c61:b69d:4ca:10d0%8]) with mapi id 15.20.6277.033; Sat, 8 Apr 2023
 00:47:50 +0000
Date:   Fri, 7 Apr 2023 17:47:47 -0700
From:   Matt Roper <matthew.d.roper@intel.com>
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>
CC:     <intel-gfx@lists.freedesktop.org>, <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable sampler indirect state in
 bindless heap
Message-ID: <20230408004747.GT4085390@mdroper-desk1.amr.corp.intel.com>
References: <20230407093237.3296286-1-lionel.g.landwerlin@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230407093237.3296286-1-lionel.g.landwerlin@intel.com>
X-ClientProxiedBy: BY3PR10CA0028.namprd10.prod.outlook.com
 (2603:10b6:a03:255::33) To DS7PR11MB7859.namprd11.prod.outlook.com
 (2603:10b6:8:da::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB7859:EE_|DM6PR11MB4546:EE_
X-MS-Office365-Filtering-Correlation-Id: f8e01061-69a9-4426-010d-08db37cae0e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nJdu9/4Agj6Ypos98mkpFo9vfXuWKoQ0V3VeiZphErfhbW2l+mNrMfHLEziKtf357joO2UudnrLQ8XETmNAXOlw1FcG7KOAszTW736lt8ZjBhn2FahuWdCCXfezjj5cB+1d3rtVprpmS1v4i06PVNMZdmzISDis9KCTJsyLotccMCxWKkt5FXmDv9Q/opvbeHpGh2jMsk2Ho0b40kvar2bBkQvHvfRqjA1WVfpLeansKytnDvCdipF6YrKTF/4M7NggAkQouhSCrpJCzDMMQ6xVAMZsWkarVoRTULeO6tUTfooBK/zXsMRI8YSVQSK87308za6pZzi7dT3PoE/bXkBQArmjuHnL/i4jYN2JLV28fZAjX/E5N4Q2CF1wgw1ZSJVbvl5+6MNSgVt2egfnb+lmAWra4eYkHw+2N0vAuCWtTA10Jycg1EHj3mIocOLMYS4y1KcW2R7slUpV6gUDd327F5bTkATPOxfF/jEpZlfpq/OFo1WB8EdiYWuyTGeCwHeJbRQXqbkDJjOZpxtjhm90yQlpLIJO6bW3MpJhoxgCV1doGMDdXc3joVSHaEzmZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB7859.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199021)(6862004)(4326008)(8676002)(8936002)(41300700001)(66476007)(66946007)(66556008)(5660300002)(2906002)(316002)(478600001)(6636002)(6486002)(1076003)(6506007)(6666004)(83380400001)(26005)(33656002)(6512007)(38100700002)(186003)(86362001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4TqI3raiLsj1FGWFsIyjspqkkrCpSt9BouPkYriRhelN1/Hq7glT8J7JRYzZ?=
 =?us-ascii?Q?xuxep2lxCNFcYXJbAbTAWjRbyP1ZjWxg2tJ5g5ZGda5OzFhYSK6sonLx+v0Z?=
 =?us-ascii?Q?bFX/nHWm+gTG9qFEsdkCSPKyBoU7LtCy53/j7bPXuEfAWHbAR1ErAzcNUEJl?=
 =?us-ascii?Q?k9/N7UZ0lzplE287Zth8IKu1pFmbLPR7oAM9bkWUEtzsWkG0lGo/05gdVABC?=
 =?us-ascii?Q?nqLtpDXrzRoF3MoWbsd3ZSKHm3Q9hRMIUMaBWDfYKP49bGjV0hLSGzsfbfl9?=
 =?us-ascii?Q?qv6Ar50JPzoaY5HxFTN8wh2KVAmuInFqihDh9WrctJKH5MY68Fckbz8/HcL8?=
 =?us-ascii?Q?b5jdVu+Iro/9T4G9E6PpOyqfVBfnEFQ4pY/GHBdXvbLq2R6l5MUs7kVNixop?=
 =?us-ascii?Q?molUMt2704oBzuo8lwD0OfZFYLW2ZEnDa8q10JMsO56UcAuJKgdlydUcMnaq?=
 =?us-ascii?Q?4u6SOqrGKivV5g73qYZOfEKzg63iv4YE02fcN9NfUd5SnZYGT+thNkfIdU5s?=
 =?us-ascii?Q?3Da4AeGaakLHDZ7bUQB/4JZi5/PqxaBoYlN3blAkbah3Mgs8S9CmUXdNLoxF?=
 =?us-ascii?Q?cboRV80o+yPafm3QVj1qRXkVSYRu6Jlx1N1NkqudfQ2Wm2QCjVrHV0/tENn3?=
 =?us-ascii?Q?+0Ygo6HB7avlFy0ys4zfl9vdT5ea4ScR2fD26BM05cbYLSFHvrCLWsdDf7WE?=
 =?us-ascii?Q?8ELDHVEc+MsuLoVNR9kNhUhcoGpEXL+f1X08egRdxIuLxtNq6WgKe6dFo3Hf?=
 =?us-ascii?Q?ejCD1mDsKtIjODrSC5euBnsLraIsoaQHA83bw2ojDvR/610ZLSFHNJYAqc5e?=
 =?us-ascii?Q?6dufvvw8lOBH+SePDPQVcBNt9PDuyR0xD5OSdpiNNwcbJIovP9PEzM+u1aNw?=
 =?us-ascii?Q?rZnGHzuVIUtyaK1kIPDMi/Jb+ljV0HBodVoQSBsKj0j0gWWNWhXc2MP1maT0?=
 =?us-ascii?Q?FZYM92u+WwdPFfwgbGCaNRg6S7nK6AHq8Q7QjMuhYisczeJjRMU9YCSoupfc?=
 =?us-ascii?Q?E2cmXlJsuY5+EsrtF9sbPvaDQ8WRu7DIHo4l7MJl/rPCs1yr5D9zUne0Kgge?=
 =?us-ascii?Q?1YTX9CP5I7A7djOXl8pNXmUYUHuoWhREmsOI0VPEz/drC3u2tP8Vytgv6+Ho?=
 =?us-ascii?Q?mdc8IR67lbe8biu/VVxLLYVWskswPyWzFIcLk6kPu5GBkGM8xwrQXnFR8ukL?=
 =?us-ascii?Q?JYuLob5BzJCqTlqGkFB9AOBIdRwIJ7R6PSo97knOUyLGAx1z2BZQqAMMqq2f?=
 =?us-ascii?Q?1/DZjPs7ehqjXj8ErAfCv5u/N8mU0iiqTbEFfQ4+h0OXvVNt5lpA3/yIUmII?=
 =?us-ascii?Q?eSqSP8RwaGekSFyWzl+cIx7YFbJKLEyix7DUkPzOFbja7hKCd754zpujKqur?=
 =?us-ascii?Q?MVNBqG5U2eV9kKehO525oBKnzLqTy/+QkkuiuLPXgxz214dME1SFdpabXt3w?=
 =?us-ascii?Q?wuhmhMXKkz769LH9EhCiP0EKvOt9ft0wNW4sRKEveFljIOxKflLcnnd6PHFR?=
 =?us-ascii?Q?1LUHcleVpgpr0yFfusxq6vyN0M7mLz/taciIrWVNhEASNPa5qWgTmPuyYyiv?=
 =?us-ascii?Q?YfpP22UciQ8uOV0WcIsr/S1ciBn1NHUtvC9ajD90FBLy/VuSFbzGTjzlHv2j?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e01061-69a9-4426-010d-08db37cae0e8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB7859.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2023 00:47:50.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z6BxdWsB4/yXTsAVavqMbvYjkmwMX+J1AWaNJhE1FnuVh8tLMu88Amnko8x4xhQ8jJNOvN+V/Kx9ktSfI51MPoaoJLcQJiCi2138pz14wbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4546
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 07, 2023 at 12:32:37PM +0300, Lionel Landwerlin wrote:
> By default the indirect state sampler data (border colors) are stored
> in the same heap as the SAMPLER_STATE structure. For userspace drivers
> that can be 2 different heaps (dynamic state heap & bindless sampler
> state heap). This means that border colors have to copied in 2
> different places so that the same SAMPLER_STATE structure find the
> right data.
> 
> This change is forcing the indirect state sampler data to only be in
> the dynamic state pool (more convinient for userspace drivers, they
> only have to have one copy of the border colors). This is reproducing
> the behavior of the Windows drivers.
> 
> BSpec: 46052
> 
> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Haridhar Kalvala <haridhar.kalvala@intel.com>

Applied to drm-intel-gt-next.  Thanks for the patch and review.


Matt


> ---
>  drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
>  drivers/gpu/drm/i915/gt/intel_workarounds.c | 19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> index 492b3de6678d7..fd1f9cd35e9d7 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
> @@ -1145,6 +1145,7 @@
>  #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
>  #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
>  #define   MTL_DISABLE_SAMPLER_SC_OOO		REG_BIT(3)
> +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE	REG_BIT(0)
>  
>  #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
>  #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> index 6ea453ddd0116..b925ef47304b6 100644
> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> @@ -2971,6 +2971,25 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
>  
>  	add_render_compute_tuning_settings(i915, wal);
>  
> +	if (GRAPHICS_VER(i915) >= 11) {
> +		/* This is not a Wa (although referred to as
> +		 * WaSetInidrectStateOverride in places), this allows
> +		 * applications that reference sampler states through
> +		 * the BindlessSamplerStateBaseAddress to have their
> +		 * border color relative to DynamicStateBaseAddress
> +		 * rather than BindlessSamplerStateBaseAddress.
> +		 *
> +		 * Otherwise SAMPLER_STATE border colors have to be
> +		 * copied in multiple heaps (DynamicStateBaseAddress &
> +		 * BindlessSamplerStateBaseAddress)
> +		 *
> +		 * BSpec: 46052
> +		 */
> +		wa_mcr_masked_en(wal,
> +				 GEN10_SAMPLER_MODE,
> +				 GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
> +	}
> +
>  	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_B0, STEP_FOREVER) ||
>  	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_B0, STEP_FOREVER))
>  		/* Wa_14017856879 */
> -- 
> 2.34.1
> 

-- 
Matt Roper
Graphics Software Engineer
Linux GPU Platform Enablement
Intel Corporation
