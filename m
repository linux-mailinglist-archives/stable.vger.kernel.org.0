Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60A5728B9
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 23:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiGLVoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 17:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiGLVoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 17:44:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8250425C56;
        Tue, 12 Jul 2022 14:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657662249; x=1689198249;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=zWMZaHQBjAy6L7woA6SgR4nYmN7wyKiZbNmszdMfsnM=;
  b=UczNjGv/nDmXotx1FdZlYvjXd/eahH7Qs7T+NAY3nN1F8TpDl+RmCAfk
   /aRdDwQoJUCaadAy7GH013RnCpk6K5xDSJMH8RUBBZqX18NAw2zvLmmO3
   S3KyKZmMprVTQEiMou1xIvN/K77rllM9HvoJ8Ru4fDiGon9oT6XCRasFa
   tkspDdIiempnqPAIHQGVd8WeBUOPC3MsqKyOQ0pv7DpZCfK09oATYIm/p
   tV7cY2yKMPkLTLaRoEokkihtEJschig+UKc6TzfUD3vUOAuKyyeVtumQ5
   YHtTRLpeWDjNLtew6jv8CsYZsF2miQI4xUAxh7uprrJCcwXmqZb0dKI/0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="282601710"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="282601710"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 14:44:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="599521918"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 12 Jul 2022 14:44:09 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 14:44:08 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 14:44:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 12 Jul 2022 14:44:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 12 Jul 2022 14:44:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXSmFxY68DxfAYFEJ0FdMjPRDsm+m2+7F9bn43erycizx5LFaxQ2Wz+d8QnVIzzEqNjozjAGXMeJMPaPdz7aoVDQ8bsIlCS9ztrQTOQCb+xauHoDNgcZlSmoE0W1r7N/PS6Lhx2QUOz/ZBR2Jwh4X+qI67qC3hK8ox6MFOCALdVPhOLVOCXuohRkrNY0rcBjhOD6l5giUzcbko24LoDlzm+H4MiW3/Vbds3d/lyDU2Ceevyy6TE463NUd1brKDKgcm2U7gS6A/LF9bgMisI6j2Cm3DVrEAsaZGiFJGqi0koNloLn2l+EbdG5cx6/W++KCUCulrgU1M15q2vTEEE1SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6t1KKJvH5PrkebURrLdrdpd/0WXCh/xAhIx7/OLqb54=;
 b=oOCh0fhJsUX/Gey8rFj1eASRY5kK9Q+CbkoPsjd8UWD7OoYWXhwya0Q3t2n1Vuj8TcawecUQynql7pUMsbFPEQ/NemfJCYLMmGV6JLPJhpewRZon8DfTc1VRfArNQCMyYsTyM8Y64TmiLHRwCYnkXcCXd4TDBXZ8duQRNCJgnt/z1WvXYByhmS5bMVYr4Ge3PNF5NXdZs4cX26SDZwscn8Oxy+QFkA52h0F139ZqpD+m1ahW3OcIvIFjsgDLhq+VO7XLQN7ssNLy5EwbD0dx7tgbXBwLmLf85lA1llT268L9ohqZ393vMTE/8ON5RyF0s2ZaD9H9tkDSDYL8MWKBUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by CO1PR11MB4961.namprd11.prod.outlook.com (2603:10b6:303:93::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Tue, 12 Jul
 2022 21:44:06 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::8053:3c59:9f5d:b615]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::8053:3c59:9f5d:b615%9]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 21:44:06 +0000
Date:   Tue, 12 Jul 2022 17:44:00 -0400
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
CC:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Thomas =?iso-8859-1?Q?Hellstr=F6m?= 
        <thomas.hellstrom@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        <dri-devel@lists.freedesktop.org>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Dave Airlie <airlied@redhat.com>, <stable@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>,
        John Harrison <John.C.Harrison@intel.com>
Subject: Re: [PATCH v5 2/2] drm/i915/gt: Serialize TLB invalidates with GT
 resets
Message-ID: <Ys3rIMMROTZB8JBh@intel.com>
References: <cover.1657639152.git.mchehab@kernel.org>
 <1e59a7c45dd919a530256b9ac721ac6ea86c0677.1657639152.git.mchehab@kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e59a7c45dd919a530256b9ac721ac6ea86c0677.1657639152.git.mchehab@kernel.org>
X-ClientProxiedBy: BY5PR20CA0007.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::20) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3665584-45b3-4e6a-cddc-08da644fa4cc
X-MS-TrafficTypeDiagnostic: CO1PR11MB4961:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jXgF7v2UQFsIoojWLFQjNk7dwwx8s4ePagNwiPxdYmY6ZFZ17DYpscjnoqUXS+u13BLGNbKwEncN97/IEb8iCuItwFMeiAkBdrisFxjHTOAW2OjpOZ6R7G6dD+xQSy/RZReyQzMqaEIdV6wtKRKT9wi7AsEt7ICJox694Mjbu/x6B/elD1SGk0/yCBMt3UsEiz40D920QF9SCMXTslePM7ekK0Q4TzuAhKqmGOuLOwbjyau56hW6xpdd7PnMSaCeTHnRkPxl16HrWxUn4iUHG36xHQD06TGRHOM0GQX0G0NsW+VMqjg8gPM71/vlAcBYI0a/r++tqgbf3feav5Cn/gpr0isXQo0vcMIKaHbgMMa5S6bqB+KMdIjcjVnJc24fbFsrx2vWekvrySmA0HZ9Eangbse/p7b1pUmqDkL/g+behkUxPV6yvikqfLnnewubUf2VLZ8cClpUMQvJZEqkhMe6/4x+t22lLcsTnN3PehRc+xHuiGAJctsTn98oAt94jYOpXdv2QKVkwYOF3qAomFu1DLe4cKtdFZMvjj7RsV5QClaxLLYVT8J6pzh5BrogRD/FhaTIoYrCvJjF68vPoV4/q9f/yCMOHHsM8sEJxr61mRCBQ+Y5JOnnC9OefQdnr+ZTE2X3QbvSzCLgTf8aB6hl3SDda0Kkgj38sUJQE7/21VER3+/Usx9DkYM0rEP+rCWhx1+v0CKg6ZS/RGA2cAqJso0uRPrG2qv4PfxFIASFNeOyxyit0/I1dTMNHFNvTThZjz58BAVndwXw/60eMuyTaltwSs+MsQzuvWIq0zg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(366004)(376002)(136003)(346002)(38100700002)(54906003)(66574015)(83380400001)(44832011)(186003)(4326008)(316002)(36756003)(66946007)(5660300002)(82960400001)(966005)(66476007)(66556008)(6512007)(6916009)(8676002)(86362001)(26005)(41300700001)(6666004)(2906002)(6506007)(8936002)(2616005)(7416002)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Qf5+EHix0/t0m7i6Fj4qMEvqJFb/lfRXva4OGVm6FaO6ZHjZKK67aqp3oj?=
 =?iso-8859-1?Q?+v4FfcwxZRNZdobKMEr8SB9o8mfpyV0wmL4gpvU9YCJfuSl7iNZVi9bYB7?=
 =?iso-8859-1?Q?2dSyEDjAGRmtQhk3PMBmShIW7QoUPW+0icZAVjTaO+D7QpTG/i0nkWVrdf?=
 =?iso-8859-1?Q?jV8RhYJ9kyYIoUEzoIoexZmUEAGXJn4Z8lVpuN+pICdd5UO9ERdby2Qrsu?=
 =?iso-8859-1?Q?MUTlsHwFHrVR4oP8uh+BxpMXrgyMktLNW5eI22b92Jg49Jq6TQFBxfVGRS?=
 =?iso-8859-1?Q?ngYeUTkxusI/mRj2qjWCBIe7UdtNEk4nblpSAHPFqGxfiIjFIC/aZrN8BQ?=
 =?iso-8859-1?Q?JIdpqGerDCFrHAs/h0dCzzd31EzMy2ohnnUP5dtVxWkf+K0Foaek/owXxd?=
 =?iso-8859-1?Q?xjK57S5g+E4NlOqXXrelv9fx0gva/2FHuSzSTBInrpzp0fFLpX3gLglSdF?=
 =?iso-8859-1?Q?IF1f4xbAM8wKqfYsE08WpfRSk8RUBz0oilzwRJe4gjPs4QMxiQbBnvSWUR?=
 =?iso-8859-1?Q?uVfj59Kv9Dz5HqNheXXGNbU6YGf3rfG0MMJQMLjv3KBEg3sTQ3UlrWkpyJ?=
 =?iso-8859-1?Q?iiIfOzkORORNOT4Y17/nMxdGlYezHAMWIy3AR26yVdGcb+Gm4zzbJpE73X?=
 =?iso-8859-1?Q?dT5ltRiiw5fQdzYP7n42vXaYMdAhUWI0F6VfkMJytUG6YH6pi9cNXZMLhG?=
 =?iso-8859-1?Q?Ovwzv8fjq3vLXDckO2JTb3j5bmXPlsxDjmx162OAkp6h66gzLBLoF+WITi?=
 =?iso-8859-1?Q?QkFNBjbzKuLNVxFd5/Dq7y+Lk65e62YKN199wSvtOPg2N4Arvh3Y2eFjVb?=
 =?iso-8859-1?Q?cCo4s7kra5UyUYvZo7Q/FUSk0Qmyj3jaV3OAy+jxlWTphR2K9/M0UfDSqD?=
 =?iso-8859-1?Q?y0OXlEKpLhM1rg/Je0VZthlM3SVTfDvf5daVhLXmZ46CS0FO1R/JMJBZ15?=
 =?iso-8859-1?Q?SRFnedDLpPlYY2ZSg3YkxgB/WHUSOLF9CeK8X1Hlsbn58yBGOx6FD0YqfB?=
 =?iso-8859-1?Q?r+4YdMcUENUSuacnJCvmfWjuFUyUS804Xkw3nOESAgV+8S2KevAUCdWeDj?=
 =?iso-8859-1?Q?UO2liuD03bBrZc3FvCNj21leEhKNwk68ylRfDZu9lCl75BSriQwbIExBSj?=
 =?iso-8859-1?Q?aHorZBlHK+5y7/oZ+anCZ40J79tFN60A1d9xjFRsx8PpFqzfhBhbVrjSkq?=
 =?iso-8859-1?Q?zKQnwoPSUirnUc5Ezt66DnkEFT3jFbjl4dzsIMgoD6IzxBUkYTGMRAk1mn?=
 =?iso-8859-1?Q?GUQKBgTS0aFY99gc/skAl0j4UhKgTdzZrMF0Goslde9Jm1Nu6DGfH3kmqX?=
 =?iso-8859-1?Q?c4P0ljgziBWotcbqTzbnz8w3Z6Lfg37DYRN3/bMrWe0jnzfn/8S4bSYfH6?=
 =?iso-8859-1?Q?+bfbQHV+OM458JnsdhGcjQNLxrsLoKdz/srI2oivB6lCmruzFKE4GGQw0h?=
 =?iso-8859-1?Q?+SGiXY9lvMQctkvMQ7C/3x0Yhy/9s54dtZ8wFGU5xRWMyyzG0dvuyUZz7Z?=
 =?iso-8859-1?Q?6CVRkDk3toIymaoMqm1M8eRCyy/ils08pO6f5zOoU9Usrwue+H/J81N/wV?=
 =?iso-8859-1?Q?zLgpFzdbTtEYw0WfGjdmvI2SbXmGT13yGAkuIpknxsRFJd76QBoBLtdDxQ?=
 =?iso-8859-1?Q?OZxq4o4YyurZSqraTm1jZ19Dy9MEuPWhIuYTr4ci3r3yZxOzQOZgahog?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e3665584-45b3-4e6a-cddc-08da644fa4cc
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 21:44:06.0643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ueSUWzWNu4nz6H98EDWk7+sxDXKG+DLhlHIXRmXvk8Ypz9pYFCqhBOYcBz8cDDPV+2puyl0GrC8PgS0ClGqWtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4961
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 04:21:33PM +0100, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Avoid trying to invalidate the TLB in the middle of performing an
> engine reset, as this may result in the reset timing out. Currently,
> the TLB invalidate is only serialised by its own mutex, forgoing the
> uncore lock, but we can take the uncore->lock as well to serialise
> the mmio access, thereby serialising with the GDRST.
> 
> Tested on a NUC5i7RYB, BIOS RYBDWi35.86A.0380.2019.0517.1530 with
> i915 selftest/hangcheck.
> 
> Cc: stable@vger.kernel.org  # v4.4 and upper
> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
> Reported-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Tested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Reviewed-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

pushed to drm-intel-gt-next. Thanks for the patches, tests, reviews and patience.

> ---
> 
> See [PATCH v5 0/2] at: https://lore.kernel.org/all/cover.1657639152.git.mchehab@kernel.org/
> 
>  drivers/gpu/drm/i915/gt/intel_gt.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
> index 8da3314bb6bf..68c2b0d8f187 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt.c
> +++ b/drivers/gpu/drm/i915/gt/intel_gt.c
> @@ -952,6 +952,20 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>  	mutex_lock(&gt->tlb_invalidate_lock);
>  	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
>  
> +	spin_lock_irq(&uncore->lock); /* serialise invalidate with GT reset */
> +
> +	for_each_engine(engine, gt, id) {
> +		struct reg_and_bit rb;
> +
> +		rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
> +		if (!i915_mmio_reg_offset(rb.reg))
> +			continue;
> +
> +		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
> +	}
> +
> +	spin_unlock_irq(&uncore->lock);
> +
>  	for_each_engine(engine, gt, id) {
>  		/*
>  		 * HW architecture suggest typical invalidation time at 40us,
> @@ -966,7 +980,6 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>  		if (!i915_mmio_reg_offset(rb.reg))
>  			continue;
>  
> -		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
>  		if (__intel_wait_for_register_fw(uncore,
>  						 rb.reg, rb.bit, 0,
>  						 timeout_us, timeout_ms,
> -- 
> 2.36.1
> 
