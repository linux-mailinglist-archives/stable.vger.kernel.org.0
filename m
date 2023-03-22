Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9F06C5824
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjCVUvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbjCVUvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:51:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9865C61321
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 13:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679518148; x=1711054148;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1JpfElNbU9lSUD2RsNSp4Jv6ZoG7LgzEftUpkgZDDxY=;
  b=JhkDQO54o/0FCVeGzD7VI3fZ4SInlqDfs8djC6BcxQ6EWpquZxw8NkId
   6HmxpQ8lTxI/9gN8R5eHTyGNfiLhwPnG+oRwqTrl+9/Dl4nU3ulSSrLml
   3kMYtDY0lq+G2wuNp5/ry8Gj4L1P5hFy3J/vOvXaX6Z2z+qgrhu8bOZXz
   SmtlCR22VUe8XcsWOrrlOTESAdLHrriI/KELk8TUoIuyQ2ohtkVcdKvVX
   FM6TCgDrRuSf5hvTEg5G0bl34l8o/oDqOyrpeOFV4c7oLnKn97coKqPp5
   LREHFF0JXZhQLmIcxEqYWItF0uus4/G0hdFiBs86Ta+e9cUwFzzFLa3YK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="319720848"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="319720848"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 13:49:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="684459032"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="684459032"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 22 Mar 2023 13:49:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 13:49:07 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 13:49:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 13:49:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 13:49:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/R2qg8wEZKKesvoDjU8jI4y7/AtgBERk4uvCWYc/+Wfdzpg1dm3bhs/65aXds9esAqytBNDmanMAbfWI9UMHxUCcIhDscz6GkQSjYkNwyR5MVc/tJOelO3rZnhPGmjEuwjRGCgV64YM4QThn2t4i7t9SK50DkAnR4qc40Vc0kcMjWtFEeKy3cd6ogVv5scRlZ+zYBaaXy31z3qW5+2LGDWN7r3C5+TEGqxeF/yfGLC9pghjRRnnc2hIVZvgnHP76neieNPO9uG948P+1jgTNTg/mGqMRUhDz3QU4yOnsK7DqeRJbqk+R5owcisCq6EpnvrA19daqtrVHwXn/bzBdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r055CtdHp/T+lc3BX0hJy4rOn6ok2EWxbyCTyQ0LvCc=;
 b=XTcda1f6CYdHdSg58y1/2CYioN8ZX7qq/DlJZ1NL4AZw6IF5C58L6Ai87pFgQzmbNHqe6qsJ7eQGQRYBt8skC5auBADqPhfHayjTKwF13N5M/AoZI8AnzI82Swu7nzGyDAldCCcjsMlWGkSKdj96ev1P2saAcpayLULaPUvL5NK2nLbZRdM9tucfg/E8osDvYFakzwms+2BNHB5v8TK+UkUNj9WvlDRTUbHsKOEldLyNbqZcVO7B4wGoYGBwge2cA/r72kA/0GcCZbnS05F4hvn7WjRqOqMw5XyuYvww9tiuA/7iDyMT3jgIoF/KnBw9DEy5Dm4B58tHjl/uNMGUFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by PH7PR11MB5944.namprd11.prod.outlook.com (2603:10b6:510:124::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Wed, 22 Mar
 2023 20:49:05 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::3bd5:710c:ebab:6158]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::3bd5:710c:ebab:6158%9]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 20:49:04 +0000
Date:   Wed, 22 Mar 2023 16:48:59 -0400
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Alexandre Oliva <oliva@gnu.org>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        John Harrison <John.C.Harrison@intel.com>
CC:     <intel-gfx@lists.freedesktop.org>, <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] [i915] avoid infinite retries in GuC/HuC
 loading
Message-ID: <ZBtpu1KPKa0IsJ0C@intel.com>
References: <orjzzlhhg8.fsf@lxoliva.fsfla.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <orjzzlhhg8.fsf@lxoliva.fsfla.org>
X-ClientProxiedBy: BYAPR07CA0099.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::40) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6059:EE_|PH7PR11MB5944:EE_
X-MS-Office365-Filtering-Correlation-Id: c4695d3c-5fcf-4c70-edef-08db2b16df29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0PSHNUnTTycqPQPDJ0fjke6RPkw0a1UXqI1QMvoslsYIWJbTGYhTAlj7SlV/ssoNZb0DEl3qZuLwpk+t/BYwUOTMsr1YEhwmvuvCIZnH93Wh05yif5Ef8o3A/CK94krT2loaRTW/GmuQXKAdSHFXBQZy5oc8el2jYLsMBya3UJ/NRiFqAnkYPDh5QCLGNxcCIjeqhiCXL9F+L006H92TiW/FLxrawvOSbJXy2Zm5pYYhR4LU9Eg03O0R3jMgCteMri20YlzYvPnu7ZYYAOVTvAf9pXalTVD/WcQgcWLFkEhgEOonYV4oRDzp+XmgNTJ+3H6C9sFvdBvGKBa/L+xb4sifXSGECVtVol5fyczevz9JmAXuIW6txzUkEW5PSX5QGXibWawq59DiQTDs1p3CVBkHmJCcXXPct7LZ+llcdBURI8TgKLkBWlIcCbcMgs7xd+eNCC1xqCSjn6t80RFuwyC0N0XTXOHGUISl4Z/2uTkCtDoHdn0pbjqkwEwey0mNjYbLf6voOlUcpFAAQZKL2SxlcEFH+FA6Sznn9cJDs30lFOAMV74MyM0hRWbe+fTls8vpVwomFRr1K43p6FsZS3TKB7kD/axKmpxmwByD58NSwpteC0O48rdsO7tkKF+2cIzJUIEaqiSbIr3YaGRRDGsrnSKxYHimipm+cXN9Jn+Ut+Aqo9zEZSwv8rulwHi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(136003)(376002)(39850400004)(451199018)(2616005)(38100700002)(82960400001)(26005)(2906002)(186003)(6506007)(44832011)(6512007)(86362001)(5660300002)(66946007)(966005)(6666004)(41300700001)(6486002)(8936002)(66556008)(478600001)(66476007)(4326008)(36756003)(8676002)(83380400001)(110136005)(316002)(6636002)(2004002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y7M7SgER1XASm0zxuTSkIWivtHYgVBx7g+edT2Qewco3UcL6eYfUcALJlPeW?=
 =?us-ascii?Q?D2NKDPrGB+z4DjKyjBIcX/KM80FHdoiC/Z6Ye0X5s3d9qPjtmWiebCj4+0b/?=
 =?us-ascii?Q?uPfUt+Qbk+t09lv/BBzqqHVR7mL06lmqILJuJQI5XqyBljA/6uAwdRrUYlqO?=
 =?us-ascii?Q?MMhsB17VGXcGWx21itR0hdGt2keCmmQBwPM1FDV1e4Igjm0VqDYksmvKrGbX?=
 =?us-ascii?Q?SvoeUhXUb79SW1v5+aNwYn1vZvhT7gHxeI/WKIiM6gH7++57t67uevvhtiCC?=
 =?us-ascii?Q?uAjmynaLjuLeDACW0WIxW31bWPfl2eV1lgjsWpnalfANzWQju+026oKFaYpy?=
 =?us-ascii?Q?cdayKCp6y4i/ye1PnFmH4B5Xlhkwxh3G8mpQdKQ9njBB1vc4YBYE1RFPhCgv?=
 =?us-ascii?Q?L2NwuZ1aOYIdw7948Mnm1vZJ/w2B95ansmLJ2YuT/cg0gKssfIfWEIwpwfBA?=
 =?us-ascii?Q?eUXVmEtPTatewG5kcE8/YPLebn6/k4YnvON7Lqjxm6YLogW95MMX30L/eebl?=
 =?us-ascii?Q?ojGP5AkpbSWBwameJ0fjJxc5YckA3b0AHZiNSIIh1IwjmCtUB4yDrJlMbtLR?=
 =?us-ascii?Q?hCqnohceuVpLbQUs4CS9TEcmj4IbWpdUW59Wy/pDM+iNB0a0Rzexru+hMKRS?=
 =?us-ascii?Q?OzYk22wpkZ1BZGWcEyOF1QZQpUmHU2Iff9Ho0I/rj0xKAdoPOi4dNbXbwT3L?=
 =?us-ascii?Q?rmNrQP2TfYrgfrXuYLwBJ2SXNJwHYaEybF7GpNl9fvMfNLR/j95MPw3kVmox?=
 =?us-ascii?Q?J4WkFPoF1UWUg5pEGHC8XfvF4lM45BROAKWsXiduV/BPyVxxCQ/AGbrhXe97?=
 =?us-ascii?Q?A3SbwSjXKmHqq0CrNt/Ufwanjnpr7ziOhlw8X+2x/3vQMhlgyRGcYzX/8t5j?=
 =?us-ascii?Q?sk1yfQWW4nMZY54oZMDZngHfK45f0hH4jVH9YghEBLFnGDDnwEPKzc8KVM4u?=
 =?us-ascii?Q?LA3TujFzCGuM57XaRFhF+RpZNCWJ6S8UR0CtRFoATiWAWiuoXRPYGhNiNoI7?=
 =?us-ascii?Q?ZPhBk7GCLOIKoG28nUzvZ6IK0xOugD0xXVVKjQ4BHrYTF88yesRYW3PyoyAM?=
 =?us-ascii?Q?1Qf34eRGUbjzHkD+Q+9TrAqobvRXVI+FsWJepMVJ+to0oWrpdRobwgyD7PV6?=
 =?us-ascii?Q?huFaMbfaWaYi78KwfM3VQ73DOsYuxao6EZg3mFFJMNadexH+9rvRnsIiciWk?=
 =?us-ascii?Q?m29yMieHn09l1ilMQjDDcwpgl8YB8vf+LqL1iLcuJawHeFC7ZfQKNEzOAzLm?=
 =?us-ascii?Q?RutgcDdhuulgWX8TcuQuH53Nk5/TUReRKJEX9HJjieq+dDfURi3D3S6WnZlG?=
 =?us-ascii?Q?geNkD7RFFyg7erXNYmdayJLNE1eoWnUIPCQHAv9j1o6AfkCGZH/4bIPfUCHb?=
 =?us-ascii?Q?m9Ib5ebsO44jbt4cyoHLwJooA9fmQI3IytFrru1RlKn2stNgGIX9zQFmnG16?=
 =?us-ascii?Q?JhKxZ+GfvDBMKh5VjdBEzJV6zxVgONKIi4W6IUihwSVtQXRGKm+bYU7Kptr+?=
 =?us-ascii?Q?o1IraNxMK0y1VLSH56uxi+8hLg+6riqK7RrVNEhjQqv2tb6mYRlrfak5X3VG?=
 =?us-ascii?Q?sO9SbMWlo0cyf3WHjcEJY9Q8LuUx7wnP5HfdZ7fbNN5jY4W74DsClqn4QQoC?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4695d3c-5fcf-4c70-edef-08db2b16df29
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:49:03.9692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d065ya582aKq/dlSP9a+3CikViQWkpu6ivGz/u8Z2A4XOTm6b4M7pQdCENcgZmeAE+wjj+KuHJ9kDiFRHSKukw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5944
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 04:56:23PM -0300, Alexandre Oliva wrote:
> 
> If two or more suitable entries with the same filename are found in
> __uc_fw_auto_select's fw_blobs, and that filename fails to load in the
> first attempt and in the retry, when __uc_fw_auto_select is called for
> the third time, the coincidence of strings will cause it to clear
> file_selected.path at the first hit, so it will return the second hit
> over and over again, indefinitely.
> 
> Of course this doesn't occur with the pristine blob lists, but a
> modified version could run into this, e.g., patching in a duplicate
> entry, or (as in our case) disarming blob loading by remapping their
> names to "/*(DEBLOBBED)*/", given a toolchain that unifies identical
> string literals.
> 
> Of course I'm ready to carry a patchlet to avoid this problem
> triggered by our (GNU Linux-libre's) intentional changes, but I
> figured you might be interested in fail-safing it even in accidental
> backporting circumstances.  I realize it's not entirely foolproof: if
> the same string appears in two entries separated by a different one,
> the infinite loop might still occur.  Catching that even more unlikely
> situation seemed too expensive.
> 
> Link: https://www.fsfla.org/pipermail/linux-libre/2023-March/003506.html
> Cc: intel-gfx@lists.freedesktop.org
> Cc: stable@vger.kernel.org # 6.[12].x
> Signed-off-by: Alexandre Oliva <lxoliva@fsfla.org>

Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>

> ---
>  drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> index 9d6f571097e6..2b7564a3ed82 100644
> --- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> +++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> @@ -259,7 +259,10 @@ __uc_fw_auto_select(struct drm_i915_private *i915, struct intel_uc_fw *uc_fw)

Since __uc_fw_auto_select is also called from another place,
intel_uc_fw_init_early
out of the intel_uc_fw_fetch infinite loop,
I'm afraid this proposal below could have some side-effect.

I hope Daniele and John have a better understanding and can provide
some guidance or acks here.

>  				uc_fw->file_selected.path = NULL;
>  
>  			continue;
> -		}
> +		} else if (uc_fw->file_wanted.path == blob->path)
> +			/* Avoid retrying forever when neighbor
> +			   entries point to the same path.  */
> +			continue;
>  
>  		uc_fw->file_selected.path = blob->path;
>  		uc_fw->file_wanted.path = blob->path;
> -- 
> 2.25.1
> 
> 
> -- 
> Alexandre Oliva, happy hacker                https://FSFLA.org/blogs/lxo/
>    Free Software Activist                       GNU Toolchain Engineer
> Disinformation flourishes because many people care deeply about injustice
> but very few check the facts.  Ask me about <https://stallmansupport.org>
