Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6178A6DD2D0
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 08:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjDKGa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 02:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjDKGay (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 02:30:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1178A1BCA
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 23:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681194653; x=1712730653;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PK1YZD44eulhaOHiuFwh+r5EWG+jWko8W/nbiGUOQgQ=;
  b=J0Tne7xTMcijc0RKdThOJfiL+BecFxWy/XGtL2cCh0zqPlQZG0R65ram
   fdcAHsqPxf8A08Hkwnoymyg90kWsQDHFgbrsKlF8DV/+bj7HcuqUnLOY0
   TyF7aA9v6eHaLAJi0CXv1F7LFqg252OvEIYm+gEYPeFcLXJll9+5DGqkA
   d6p7XNaR6EXX8BL2QUn2sSUJKvwwgDSawXspwNpb7vZ78Bg3V8+y3WdPe
   pqOC9aRjGeF17Rcq33SVrfPypBGktVt0tKWFoxXLUYlYcfEeAXX6PUbDQ
   OJcBO3VYvUfHGVh3vz3Xok8f0gP4sMvMro+boj6w9Gm1k8xhHKr/Lhj2+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="342301594"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="342301594"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 23:30:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="777796898"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="777796898"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Apr 2023 23:30:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 23:30:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 23:30:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 23:30:47 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 10 Apr 2023 23:30:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evYXXgH9LKOFaI0NahHh7RryfcQEDwSMLvTKNP+Qr8cVp1jNfRolPxXdbbFtxOk28Z5qfTWVaPc9UlJ/B76T9NtAshcGqbmXBn+fXkVKyekQqL2vHFM1VMppNMzY9WCJ1vqkKip0TS5p+Ots/t2wRIX6e49tqXfCTKs4Alu5QJCmTT4Ee9oYkD6GKP5Clu8ad9WOKm9M2lqodXF2oZoPc9s5W9l7MUPJCDOKLJRdp/SRqkZPRZCgRbwgy2tvekJQbevEqzDImHq0KuPAPbiayO+ZW9oudjzKEQ4oxsxGaH1IHTQMH/YyNnhpW1+HQzxbRUQPZxDQNdxVOnHcQ2goGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcTylPksPAs3IG37cqojJf0z0IdRmIJh43Re0q9k/XU=;
 b=d8SSLoRbYEOkKZMd/bVyxDYf7i+YO+HY43RiNWHfFmlF1k8MfwaQXYT3toul7az70zSN5j59q97xD7mNWHLsO2qWbpWjD1iK9Qh/2Xoaleat9AUfJnzSqpPNx0vlxmw44N7MlasG8rh2uwXBTeWzllJC3v+KNq0wPkJUDRUq++iJUMUyuKs3PciwgEXEbBDDY/8TzJptKa3p+h0n2oNGRB30YHuY69nDnjefrOG+B53/HKZojkJ6p4c00HzzFxl4VEHuVWyuIC1nfPDl3NM4uVZlpQaoJH3Y1pP/JiYnqKqJD0V5EXZR0qV07B6YPmJ/+33YkLP/UHoXdh32tlq3fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2961.namprd11.prod.outlook.com (2603:10b6:208:76::23)
 by BL1PR11MB5256.namprd11.prod.outlook.com (2603:10b6:208:30a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Tue, 11 Apr
 2023 06:30:45 +0000
Received: from BL0PR11MB2961.namprd11.prod.outlook.com
 ([fe80::6c34:bbe1:bd34:aa2d]) by BL0PR11MB2961.namprd11.prod.outlook.com
 ([fe80::6c34:bbe1:bd34:aa2d%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 06:30:45 +0000
Message-ID: <202b4602-04d1-de35-64c8-4d2da5889cd4@intel.com>
Date:   Tue, 11 Apr 2023 08:30:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v4 3/5] drm/i915: Create the locked version of the request
 create
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <stable@vger.kernel.org>
CC:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
References: <20230308094106.203686-1-andi.shyti@linux.intel.com>
 <20230308094106.203686-4-andi.shyti@linux.intel.com>
From:   "Das, Nirmoy" <nirmoy.das@intel.com>
In-Reply-To: <20230308094106.203686-4-andi.shyti@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0047.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::14) To BL0PR11MB2961.namprd11.prod.outlook.com
 (2603:10b6:208:76::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB2961:EE_|BL1PR11MB5256:EE_
X-MS-Office365-Filtering-Correlation-Id: 77636dc3-23b8-4479-10ee-08db3a56479c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8J73/kqr8SztaUNXZhFc2NSqZB/EnbVh4KVaWWnRV00eEkIa3oe+iORzzsjEtVS9Z/28C5MALpBpOrSaZn41OuXPTp3ZFXD8FrSj5ByJ2ycoSn5R1k7ZcU8kNEnA3tjp0aghXD7jaO7345SSXK3myspve1MNhairkHYcKLUPBRbsUdgiC83UNZJ5L0piTifLf2ghcm618ZEIHVLgsrLehNTsfIqZXbz/JAG9wnWlNmXm1CCixRziTKjBSbiIPuqPSAodswyu6vr/fi51NkWhKsj68U8JgZz2GIdd742x5PeVvGhv/NGT/Mw1Cera6Dpvz4+A4TgooIKmRR67Y7ZFcZmw19dLVYh9YIotsTltE4nYwhpwEUGWuXw2omXpJFni5cf4FpSqHtEtGESQLEcXOakz3GyS9I6iE5W2SECFwobepvUjg7STnPwThrGar0iICQAf68XTgjemUBB33POoxaRatOSluQUlJMuHeK25xGNCxtNUIm4SUZcPrp8jusrAs4MhrKGbQ+BqCpTY/CtCC0vk4wwQGeuvdXGRrsLYNfK6zhCeq3ZppnwyEDjwL0IYumYLEzTdiMfTeU9fJgruzlcgWIveKWcUzv73Rz1DIQXmS5+ZgUCJpuV6qwxpHdNYgjNtAA1sfpWNhCk2lws0tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2961.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199021)(31686004)(478600001)(86362001)(31696002)(36756003)(83380400001)(38100700002)(82960400001)(2616005)(6666004)(6486002)(2906002)(316002)(6506007)(53546011)(186003)(54906003)(6512007)(26005)(66476007)(8676002)(66556008)(8936002)(5660300002)(41300700001)(4326008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2s4NG1OQnE1ZXJyYTNLWUtQMVpXRm9oUzh2bWtJeVQxM1ZWYkFoVzc2eWE5?=
 =?utf-8?B?M1hKbUJXM3R4dHFPQkZ2NmRMQ3pISXFzaGxTQ3FZKzExZXpkbVdmWUozRkYr?=
 =?utf-8?B?OUllbnA0M3dPWlhwcWRNbUVXd0h3T0ZodGQ1UEE3OUdpSmdSeWF4M256YWJU?=
 =?utf-8?B?L3BHQnhOcVJzdEI1QkQ3d0VVQ0hQWFhLT0pTWUhDd0o0UFlaZERPbnI4UkRW?=
 =?utf-8?B?Uzd2YU43bFFVUTNISjMyc2hrMkZtQm4wWTJ5RHBLaENCWS95WVB4QjMyL1NH?=
 =?utf-8?B?Y3FRUkVkY0FtK3MycWVBREpHSDRzRXNocWtuQUpiL1VUY1hyN21hTWJTRkNY?=
 =?utf-8?B?T2JrcW9kUkhBUXQ4Y0doZ0Z1bUlNMmhPYitzb2d1TUJsZUkyMlFkQk5mck1q?=
 =?utf-8?B?VFB4N2RqUXlUR0ZyemljN2lHeENRSnc2SzBVZkZXRy9jZ0k0eHF0TXhPcEgw?=
 =?utf-8?B?WHFQZEtFVzZnNUE1RC8zcGsyZitmaFREc1h6SC9WbHd5dDZJQnJqeVpkTmhN?=
 =?utf-8?B?Z0V0Rlk3ZGRvYVhpejFCYzdtSE45WUVEQi9xblF3MVRIUDZ6QXF1VTVmV0dl?=
 =?utf-8?B?eUJoanNlWk44RnRPUWNWL3JLQi9BMk8vaWNadms5azZxZ3FXRmlXdGliY3F4?=
 =?utf-8?B?Z3ZOV1AzTWZuY3VINGZBL1dRcWdtSlQrTjBDZk5LSHUzTU1TcVF2c29FVE9H?=
 =?utf-8?B?dVdhR3BOYVBITlYydDZ3MHlQbHlGemZ1VzkvbzVubndUNjlqR3loUk80UE9N?=
 =?utf-8?B?SDdiNDRlcjJTOC9EYUd6K0lnWVR2OFEyNmlWVXhiYjJIUGNhcHBid3BQaUln?=
 =?utf-8?B?NjF6b2VlTHdJaUltZEVCZXlYVlFCS3pzQVBYdXcyZXdydjN2Yy8yNFBYZWpJ?=
 =?utf-8?B?U1FRUERSWjE4bzMwZVl6SEVPeGdrYndzaG51d0MxT3duamRLZVFESVcydDNH?=
 =?utf-8?B?QnpPanFQL0IvRU12S0puaFBTRGJSQi9QeU4wMCt0c1pCM0Z0NTFITTJjYW5t?=
 =?utf-8?B?N3RSY21DaGRpMVBYcFFISUFrRVFnMWU5MzU5UGZNbFZNSEFiZDdTYnp2Ky9y?=
 =?utf-8?B?bVNFdGhzUk0yWFNMZzdtWEtNSVM5Tm1lZjh1cHJMdHppaGtvNGJ3dkU4K0lM?=
 =?utf-8?B?TEVqL2tBQ1QrZGN3VFRiVEkyZnFwNFZIUEQ0eVI4RTBBdzQ1WncxL1h2WFZK?=
 =?utf-8?B?Qm1VNDFYTFB6UkZXZHhjcEt4VnU5VHRVcjF5Qld2eDFLQUluR1RMQk9FcFNX?=
 =?utf-8?B?YmJQUTVaOVBiREhsSW8wdW9jVWZWRFRxN09XWldCemJzQldqOHRrb0xra2tm?=
 =?utf-8?B?M2lWNUgzM2tHclErQ2VVak9rRzZxVHBUUFQramFDSldDL2szQkNuaHNJMHYr?=
 =?utf-8?B?R25INHdKLzNnVzBHQ2RuQy9wZlJuVFovb2hvdCsyUVEweFByaGo3TEU3VG5a?=
 =?utf-8?B?aWJINm5DNjhCdnBnS2tmVWkzNTdxWmNTNlhrVlg3bnpFUGhpR05GN0l5RFZo?=
 =?utf-8?B?RkI4VUtiK1BueE13cERNOUNTRHpSRW54dWdJNFduNWFVWU55alZpZDh1MWNr?=
 =?utf-8?B?VUV3WTc4VHlhQ3FMb0ZDZkRpMll0dC81K3o1Q0theEc0RmI2dDRLUndybVVF?=
 =?utf-8?B?U3drTTFxRkJnSGpxQUJaRWcyRlRqcXo0ZnI2cnNFVUhVMlBrNlZoR2w0NnNC?=
 =?utf-8?B?cHJybEtlaFNoUWRLRWYvbTRLcGUrUFE4ZU95Q1NRZlpoYnE2RHVKR1IybVFr?=
 =?utf-8?B?bXFQeEtZcEgvemN3a285eVJiaFlLamFlTUQ2MW9JSHZDdFFMaExPelBBOW9O?=
 =?utf-8?B?N3haZUhZMGE3TFVsbXFMWWRTMEU3TGQ5ajZXUjZMM3VRVDZQMUczUUJOM3RQ?=
 =?utf-8?B?VTFrWngvOU0vY0NBd0xZOWtsS3Z1VmdsRTlJNEJRUlh6OTJuaTcxUStSbkFz?=
 =?utf-8?B?eDNxcjY3c2dpakE5a0JPYmZiTHRKSkZRY0hsR21hamtnMnVOWkdob0VjTEJs?=
 =?utf-8?B?eThzdE93aGI0c05LcXJFcUJ1a0YwcnFTeFVLcUJsc2dqTEN3TXZnaXJmS3lz?=
 =?utf-8?B?RERNK3p5L3JnenJ5WERTMitjL0VhTjFqUnZSdFIrbG4vUmlNYmJhVTRuOXNk?=
 =?utf-8?Q?sa2hdNyCdu3O4c0BsHmjns0hn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77636dc3-23b8-4479-10ee-08db3a56479c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2961.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 06:30:45.3827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3A9Lf6zRx+QQjZjIcoj4eVQfG5jxibc8+272N4YGdHEbtLNg5j8Y/IV7Rdl+xzxSTGZdJANbVjYXyauzS1UzUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5256
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/8/2023 10:41 AM, Andi Shyti wrote:
> Make version of the request creation that doesn't hold any
> lock.
>
> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>

> ---
>   drivers/gpu/drm/i915/i915_request.c | 43 +++++++++++++++++++----------
>   drivers/gpu/drm/i915/i915_request.h |  2 ++
>   2 files changed, 31 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 72aed544f8714..5ddb0e02b06b7 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -1028,18 +1028,11 @@ __i915_request_create(struct intel_context *ce, gfp_t gfp)
>   	return ERR_PTR(ret);
>   }
>   
> -struct i915_request *
> -i915_request_create(struct intel_context *ce)
> +static struct i915_request *
> +__i915_request_create_locked(struct intel_context *ce)
>   {
>   	struct i915_request *rq;
> -	struct intel_timeline *tl;
> -
> -	if (intel_context_throttle(ce))
> -		return ERR_PTR(-EINTR);
> -
> -	tl = intel_context_timeline_lock(ce);
> -	if (IS_ERR(tl))
> -		return ERR_CAST(tl);
> +	struct intel_timeline *tl = ce->timeline;
>   
>   	/* Move our oldest request to the slab-cache (if not in use!) */
>   	rq = list_first_entry(&tl->requests, typeof(*rq), link);
> @@ -1049,16 +1042,38 @@ i915_request_create(struct intel_context *ce)
>   	intel_context_enter(ce);
>   	rq = __i915_request_create(ce, GFP_KERNEL);
>   	intel_context_exit(ce); /* active reference transferred to request */
> -	if (IS_ERR(rq))
> -		goto err_unlock;
>   
>   	/* Check that we do not interrupt ourselves with a new request */
>   	rq->cookie = lockdep_pin_lock(&tl->mutex);
>   
>   	return rq;
> +}
> +
> +struct i915_request *
> +i915_request_create_locked(struct intel_context *ce)
> +{
> +	intel_context_assert_timeline_is_locked(ce->timeline);
> +
> +	if (intel_context_throttle(ce))
> +		return ERR_PTR(-EINTR);
> +
> +	return __i915_request_create_locked(ce);
> +}
> +
> +struct i915_request *
> +i915_request_create(struct intel_context *ce)
> +{
> +	struct i915_request *rq;
> +	struct intel_timeline *tl;
> +
> +	tl = intel_context_timeline_lock(ce);
> +	if (IS_ERR(tl))
> +		return ERR_CAST(tl);
> +
> +	rq = __i915_request_create_locked(ce);
> +	if (IS_ERR(rq))
> +		intel_context_timeline_unlock(tl);
>   
> -err_unlock:
> -	intel_context_timeline_unlock(tl);
>   	return rq;
>   }
>   
> diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
> index f5e1bb5e857aa..bb48bd4605c03 100644
> --- a/drivers/gpu/drm/i915/i915_request.h
> +++ b/drivers/gpu/drm/i915/i915_request.h
> @@ -374,6 +374,8 @@ struct i915_request * __must_check
>   __i915_request_create(struct intel_context *ce, gfp_t gfp);
>   struct i915_request * __must_check
>   i915_request_create(struct intel_context *ce);
> +struct i915_request * __must_check
> +i915_request_create_locked(struct intel_context *ce);
>   
>   void __i915_request_skip(struct i915_request *rq);
>   bool i915_request_set_error_once(struct i915_request *rq, int error);
