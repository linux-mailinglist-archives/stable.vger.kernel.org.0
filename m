Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E2869AFAC
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjBQPlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 10:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjBQPlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 10:41:18 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328A84CCBA
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 07:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676648477; x=1708184477;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gtOK7/GbN74e84PdOljtYlq1F7Gb8glTAEh3cV2cDPU=;
  b=cP4QQ1O6/E1gdwSNLq/ypd1ZatcyusTyZd+uOtr+3NQFJ+Hy92CvjVX1
   XtahmRFZXghydFzp+ecYw+qgi4a04B05NA46R3Vl8K6qw0WDNcZ9Bkeay
   q0u7alBxcFMS6r2IJfKzubVFRq17SQXK8OYh2KpRz6NeUdChc1PhzGssa
   CgjnMYPOJd3xwItxwhpKsbYcTQsowXWrvtc8tlVg3P1LIAAABazdlOVQv
   5SAl4FqiuiSE4zS1z6Eth9Mynjxwx65GTX0alo0FNpj5Da6rw3vVl20e7
   0ZA1EaXJsl64ckw7rkuW4CRf73VKsVduz1uZNdDsjUdEzyUMPHQjgjNwl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="418230851"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="418230851"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 07:41:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="670580009"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="670580009"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 17 Feb 2023 07:41:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 07:41:15 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 07:41:15 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 07:41:15 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 07:41:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuIHQrJ4R2iwQMqeqhfH0hBncEwAJaU7wWeuMqNs4Tv3nRFbGWoI/jbvS4xJ4k5ZKeq8pwQqNo6amrb5F5sgFGkDQxdt0VRxCxFxwQyNEXxNyzIQWKu5nKa2zAEkIQxYTYzBHzNO7B5TGG9+/FNanGeCyeGekBkJc/ON0iKwvwRhPpT716FYgqsncI9J/GHV6LsDC2fG5OYP0cUWp67HZdYU5YyI3cVhujdnLRoMftGNn7doTCG+fAgKd5zt7CDvMQEM6m02Ry8qq3zk6QK7Y2Ny+dK1uEh4jvygAkBXkdyv0RPw8ar7p5bKnprgNnc4bD1mKcme4g9pJBaMEDt7KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CWc0DDrlslELKMghO8o7sYId+EuFnXOneaC5Q15xogI=;
 b=Xe+8pk3uwZTT5FBVhUarJQH+l0ClysoGmt6Kl8rwas6TSxbSJS+SCGpn/ynYNXPBxvexnL260lmeLUTsfve2ddtOTEHxjXJkQVVehTPq5Drb9QRb6G5Xz6iqA2G1ece+prjBaez5XrQNyCTGoWn/r8758b6L/KKbkC6iOXhjlJ4XXJuqPwJL6ENeDIeAxO8wAqJBqXI7+oS9Y5aAf8ikRzVHDiYtERa+AFneJ/xStQnKH7ofpHgc6UGxx/kKeiNdzgcdSyHhhJtFvjylbHs3hJ81eukUuuGTUKJFnBNk1tVdRL2F508Ydw/+pNu/ITQ19qQSWUn0p0rQoVxp/zUMvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5488.namprd11.prod.outlook.com (2603:10b6:5:39d::5) by
 IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Fri, 17 Feb
 2023 15:41:13 +0000
Received: from DM4PR11MB5488.namprd11.prod.outlook.com
 ([fe80::218f:c449:80c8:7ad9]) by DM4PR11MB5488.namprd11.prod.outlook.com
 ([fe80::218f:c449:80c8:7ad9%5]) with mapi id 15.20.6111.015; Fri, 17 Feb 2023
 15:41:13 +0000
Message-ID: <a8957bb6-fb82-184f-d35b-471a667c1ac2@intel.com>
Date:   Fri, 17 Feb 2023 07:41:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-gfx] [PATCH v3 1/2] drm/i915: Don't use stolen memory for
 ring buffers with LLC
Content-Language: en-US
To:     <John.C.Harrison@Intel.com>, <Intel-GFX@Lists.FreeDesktop.Org>
CC:     Chris Wilson <chris@chris-wilson.co.uk>,
        <DRI-Devel@Lists.FreeDesktop.Org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, <stable@vger.kernel.org>
References: <20230216011101.1909009-1-John.C.Harrison@Intel.com>
 <20230216011101.1909009-2-John.C.Harrison@Intel.com>
From:   "Ceraolo Spurio, Daniele" <daniele.ceraolospurio@intel.com>
In-Reply-To: <20230216011101.1909009-2-John.C.Harrison@Intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0113.namprd05.prod.outlook.com
 (2603:10b6:a03:334::28) To DM4PR11MB5488.namprd11.prod.outlook.com
 (2603:10b6:5:39d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5488:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: 899e7f2f-3f74-4e3a-d071-08db10fd660f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 17zeF55/UjpBR61CYwraBVAjLdVxf5EmVZKb9Aa+Z9bzlAtJjSWqqLegc19SVT8tfDB7eOX08ei/qlL4cBNINXMoGOCaLRtE3Mwfq1zONLVa0mdNXVB6wR3SbFIHnpwtQ2ha2Aqkdir3aZ9WpfIBxRg4JAkEvFaHvEJx8BTOxtf94psnQ2cAv/yn5nbNI+7UY9kHfVYKxhejlQFnXeW2eHGODZcqR2LlLbxRFD6Nk4R8HPJlgi7mKZRNQ8Ucd5WZY38D5v1z5lXNk5hC5Pm5pkwlOj3YAAzVENvKdBnW5JbxLNVg6jFsCgmGu/MXRF9Twslo9ftsIAMQT3UTD4OZEqSfCl5jpFbXiOfqi9Y27s4DR/TDDzCKfE+xG1OX+dwkBQZneGBTZDwdvffEfx/oNNuJB49iTiwH8S6UFTFTQQwq6fLT0Ls0WdFYBuYH6uUpzwBQXbVhFd2vWSL3wqhwMDxsYoe20nuP2sdI2h/yQC4js1zdvPEr+eyERFOkA9bRsJDamClVaj6ffAleyj7QvfPkmWO5/IW+oxaEqmlP0A0x4m4BpXiBINFJl2QyzC4PdeIfuhyXnaQ5jQrT2NFANwiX13z3VFc6x3/g2T27JXFnl8HGGukweSv79QAG/k3DU2dYvuM3CL/tEjeLyhiEsXxVp5s+ZsYLXc5nH8xdrgAMnyZjmnC4zkSaewGVbGy1u8cMzW/2DpakN97DiBVOL0R0OOjBRem/1PMlVMxhD34=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199018)(6506007)(186003)(83380400001)(6512007)(38100700002)(82960400001)(54906003)(2616005)(86362001)(26005)(8676002)(8936002)(4326008)(66476007)(53546011)(66556008)(5660300002)(41300700001)(2906002)(66946007)(36756003)(478600001)(316002)(6486002)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkFzSEJycDJxR0hwenRrekpsdTFBNzRJNG5KWmRmbGRHaGEveDg2dW41OVJ6?=
 =?utf-8?B?V3JZM1JjcTdnWW1kSEU5dnIxTTZkZkdnK0NCc0ZVVWdmUFdKaG1jYkVEc1g4?=
 =?utf-8?B?REtIdVZva0xOYVMzNGJBQVBndjJKQ1BGOUxCYkdWdTBNd1NtcjZmcW1qbVhk?=
 =?utf-8?B?Mld1Rk1JeVA2QWlVOTZyYllqOTB4WXJXczQ3ekc0MVRsdXZPUlZ1T1BWd0Vn?=
 =?utf-8?B?Ui9sTktZSmdocDdjWmNlWHR2alkyMk9RRG56QTNucUVaOG1vNFJ6YWd3elFZ?=
 =?utf-8?B?UnVtRUtMM3cyWGV1bmtWd2pML0xYTGVTejZsL1VXMElyc1ZQOGt0SFhkZ3Qx?=
 =?utf-8?B?L2ZtRzVtMFMrSlUyYjUremdaQnlFSHFYQkZUWXBQTmlIOUhOUG1jczZuQmg5?=
 =?utf-8?B?aHUvRTNwTHBoN0hnQjFLUHExam1oS2tXaXF3VEJMWDRDbnZVdDJuRFhHSzFM?=
 =?utf-8?B?RkoyaHNNOWxUclRHRHRYYk9IMXIzOFNXa0M5Z0dodlp5cUtwc1FOKzFSNGpZ?=
 =?utf-8?B?Q0J1aXhvMzVaMEgwWHBJR0Jkc2k1MGlhZXBsVUI0Q2lqU2NWWVhHU0lwQXFK?=
 =?utf-8?B?ZE9GaXRXcFhkQUQ2aWRjUVU3MWtTc0tRSVlIM25PbkZ0REhxTjQxREIxNVZn?=
 =?utf-8?B?bUtNVjViZWFLUE5PMmNpUVBtaFF4cUhTZnRzV2Q3YWNlRHNtdGZwdGZGcTJJ?=
 =?utf-8?B?OVIvOURVQ0FiRUhHRjQrZ2VQdDhjZTFwaUo2V3hjODdaZ0JoNGhYUGZHOTlI?=
 =?utf-8?B?VmN1akF4dGhUYlcrU29idW5xeWZwRjNKRHBxVVpUREFpMnpLd1h0M3E5Mmw4?=
 =?utf-8?B?dGRiUTkyaXo0NHdLazZnM0Q2Z1hMNzRMaUdzWDltQWljeVl6S1lZbkNLbVcw?=
 =?utf-8?B?V3FvcUNNTk82Ui9DOElzWklEOVhnYVZRc1AzaGRJdmtLRmZwcFhndWVMdnNW?=
 =?utf-8?B?YkVOSHNhVlRDZW5CeElhOGRYNVJ0czk2TlVWdThkN0pHRUZDandZa1VETVc1?=
 =?utf-8?B?VTFYOVk0d1BMV1p4ZUc0eUhaZEZJa1dPVWJFNnZvWU9UNXMvZnJrQVk2WHBH?=
 =?utf-8?B?aHFGajB2Wko3QWtSa2drK3FpSTk1UHVLWGpxcEJsaHdPdVRKd09PaGlaVkxi?=
 =?utf-8?B?alFrdERESTBOTWozbk1hYUhicXUyMXFxUmxwT211V2w2dDNwQnZQc0lqcG9X?=
 =?utf-8?B?Ry8zZU1qdExsdmluVFIwVU5RRW5GL0crcDQ2S0xrcnFwNG9peGtzcmQ4ZlVM?=
 =?utf-8?B?SWFNZnNqZHlPSVkzUFdwOXFVZkFRZUNLVHlqNWVNZFZIVXVoZzR1eUlHUTFZ?=
 =?utf-8?B?aHpPQ3A0U21UOThQc3ZvWkZlNjlRS0Z4U1BILzhHN1pzUzRvQ2RCRlFVTGRY?=
 =?utf-8?B?UG9TaXV3bWcxNlpCaTVKMldpVmdFeXUvQlZFYVR2dmo5dzhESlNNL09WZlpL?=
 =?utf-8?B?Rkc5MUJwWGFLUVlXaDRaS0RaSVJpOVpWYzRGTnp2MEJrY2JSdWp6cHJGZHJY?=
 =?utf-8?B?OVAyN2grbmFRSkZRTk92SXprdmFYZmVCbGRzOUtUTnFQVjcwTFhLcXFMVTFq?=
 =?utf-8?B?OXZILzVoUjg0cE55cEQ5TGpYbnl5V1NxdStrZHJ2SEZwM0ROZ0szNWFWa2pW?=
 =?utf-8?B?amdlN2xoNEdzWVFlK1JvdHpxR1JYVkU4YTF6VDV4T0VCQWFnVmhTWWJPN1JC?=
 =?utf-8?B?YUhMaURla1dHQ1NwangycnorRlFrNjNWQUVmd2JjSmlYelNmNWZJa2JHaXNo?=
 =?utf-8?B?YkZRSUtrZ211YjNHYmlQdVFBcW5sdVd6TVJ1aHZ1bFZrNUlsSmlUR2hqOW1s?=
 =?utf-8?B?UHRUVkZPd05PR0wxNnBNUEViY3NtNC9QVU93Q25yVkJrenBxOG9TaGZRSFNH?=
 =?utf-8?B?M2Z5VkRkekJzMkhmSEZPQ0xNVGZrYkVoWWY4czU3U01COUNOM29XbzA3Nzll?=
 =?utf-8?B?V2ZTOXl5Z0ZQVmhoU1hIcWJiYW9XNXpUS2lyTEs4d3N2bm1hcnczNFUxaVZV?=
 =?utf-8?B?WmFtYnNwL2JVTEd4MENQN2xBMnB6YWxHeHpOVlZQTmFPR3pVZm02YkVydW9t?=
 =?utf-8?B?SGNtYmx0SEJNSzA5U2wxWFZ0ajBXTkJEekxKc2JwRjd3bTloNmIzVnB2blBE?=
 =?utf-8?B?SFJteUptVXlQNXNVaDJHR3orYldRVjRWdURGTlM3aU5uREJ2SW5JbVE3QVVw?=
 =?utf-8?Q?mOXF71nCi5vRX8VqgUmyXns=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 899e7f2f-3f74-4e3a-d071-08db10fd660f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 15:41:13.3920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FoHlRVgpw3DyCfCgN9s5CVD9jrvN/49OBdaUcwQj3I47HDUYEuM8TqX+AbuBEnTNqwvC8IO7no1qXiJdcx3euH/KsYI4XvePEudSWZ5B2E0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/15/2023 5:11 PM, John.C.Harrison@Intel.com wrote:
> From: John Harrison <John.C.Harrison@Intel.com>
>
> Direction from hardware is that stolen memory should never be used for
> ring buffer allocations on platforms with LLC. There are too many
> caching pitfalls due to the way stolen memory accesses are routed. So
> it is safest to just not use it.
>
> Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
> Fixes: c58b735fc762 ("drm/i915: Allocate rings from stolen")
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v4.9+

Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

Daniele

> ---
>   drivers/gpu/drm/i915/gt/intel_ring.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
> index 15ec64d881c44..fb1d2595392ed 100644
> --- a/drivers/gpu/drm/i915/gt/intel_ring.c
> +++ b/drivers/gpu/drm/i915/gt/intel_ring.c
> @@ -116,7 +116,7 @@ static struct i915_vma *create_ring_vma(struct i915_ggtt *ggtt, int size)
>   
>   	obj = i915_gem_object_create_lmem(i915, size, I915_BO_ALLOC_VOLATILE |
>   					  I915_BO_ALLOC_PM_VOLATILE);
> -	if (IS_ERR(obj) && i915_ggtt_has_aperture(ggtt))
> +	if (IS_ERR(obj) && i915_ggtt_has_aperture(ggtt) && !HAS_LLC(i915))
>   		obj = i915_gem_object_create_stolen(i915, size);
>   	if (IS_ERR(obj))
>   		obj = i915_gem_object_create_internal(i915, size);

