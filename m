Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D1F5A9D8D
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 18:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbiIAQx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 12:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiIAQxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 12:53:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0B5985B1
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 09:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662051234; x=1693587234;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wqFLH+hxHJ8Os6B0ZBuE3MPV5NawZepa1NaiIqnejLo=;
  b=V2pI9fDCpLiJn3m25Zt+fzQC2GRctlMUxXd1R0Zefys2gue8nakXjyAD
   LGxgQdjhhGYVPpZpSbG4RvSRevl3SiElZQvi+ARqQKPZqFpIAjJIEBWz1
   PZ0YsjF1++nsbU8jQ5ZBxcmLcu8tYwJAca7z/BvqqXWw6C/OpjIfZxKyY
   0QMOAtUMUD04L8VLwSpqpSFj05SqCD5A/8HoT9LSq9SgfA9d12OhNuu0s
   eQj8LZ9T1rw1beCmpA39xGuxZKOGom4tbuzhKPWK6Qi8rHKUDkk1HDcyI
   Q5IAOaCIT0ZQqHSSnJOiW6XALrns6PJJY5UFzbDzrAVC1u+pFwRto/iR8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="295779607"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="295779607"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 09:53:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="642416133"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 01 Sep 2022 09:53:52 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 09:53:52 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 09:53:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 09:53:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 09:53:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XM91D/me7cTNnluY4pyYRnO8nkA1NASMSyxB4SKE1bF5PRDv0FAxnID65sYu9kPrj7YlK7hJwINNALyNcR0dQZn9NpqAO6w4lfkDe/7ajblS2DYs4tPXe7IiopS/RvjA/WXJQgUCmyOq4QnCqCbk63KuCQ3v37fiui+3V9uW90SRiaLWGhwMho3oZLeXA9lltef3pNT+rQlodaYtFb2M8oBf1nuz7GGQPNlZfOir/FzMvTbJUqFoRx8OBULQdZlqwjvq3eNuEWQN6+qxpQ4SmK/lU9DmtOo5HqSZ6KrVOkNtYT02BXX+URxJzC9z2OZmgqDcwp+nG18d5OdcmmxwWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnzxuYeMs+TTIp49iijdwI+gVtLFJz3/rcfNufXi1BI=;
 b=nLf3j0qFaJbNxlt+ielWdD3v9xoBc/qNJ5i+ZsHkT6vZZb6LBeEqX5d5XkNPOzqNH4nFTL+OP5XaJ0WkCjcI7k9a3nKxdwIX1jBXktwcmD0KtdQl1p0lY64A6DkhiB+L9fHtByVClz60kAZh9bn6hHTSO6/d/0ndFadIAgEgxc1r3yqAMp1g17T1q79pOIR8GHEjx6hWnE18vExsihXGmY0XJk0+3Zq+LdhgcTheWzqlGOCNvznHodgKpGkZ/n3hOuQoSJFQ1rD4pJs6kfdnjq8Pjl6DKqJPqXs+g09QLd7Kc09ZqScyfq4nrMLYaqBtQbAZ58OHOTl1GHvfBTixuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by BN8PR11MB3539.namprd11.prod.outlook.com (2603:10b6:408:8b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 16:53:49 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7ce8:1e4e:20d4:6bd4]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::7ce8:1e4e:20d4:6bd4%9]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 16:53:49 +0000
Date:   Thu, 1 Sep 2022 12:53:45 -0400
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     "Dixit, Ashutosh" <ashutosh.dixit@intel.com>
CC:     <intel-gfx@lists.freedesktop.org>,
        Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>,
        <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/slpc: Let's fix the PCODE min freq
 table setup for SLPC
Message-ID: <YxDjmSFS01Kb9cxA@intel.com>
References: <874jxtz1e7.wl-ashutosh.dixit@intel.com>
 <20220831214538.143950-1-rodrigo.vivi@intel.com>
 <87v8q8rrbd.wl-ashutosh.dixit@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87v8q8rrbd.wl-ashutosh.dixit@intel.com>
X-ClientProxiedBy: BYAPR05CA0087.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::28) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f1bcf42-493c-4108-c6fe-08da8c3a8adc
X-MS-TrafficTypeDiagnostic: BN8PR11MB3539:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bI5zkWPGN5I6ScA1YUB5Jhf3T6v9WPE5SWgQeBYKtqT4I7QRmhJQJ58V7XeMi2PcemWff7iyhZQoY7EImhCOmjHyqvoeGIng8hMHhK2AQz+DEoChXqomhrI79ngIcHuvEy4gbYf490K2Vk2BJvdpPJFhZoEBlbT18zdWR6jnXu+QBjBidoBnot2RYvIRo2cTWfdJ4UWshtCEW5p7q3ed6rmTlcy3j10fy3xc5eC0wgBFKNTIAFbDmXUcWMsFJaFP6EEzo7e5tzlqdAkC89/UUdEYW3VUi2BQpOZf/37yuatpEcnnTUmGDiN9bwApazWqUxKbtjEqsvJ71mfOK98BrtDFiS/9CcUkHQgwxzQtlSgTgL4geRqvKIx2wh+oiU2lzd5lYGslzVGIEdi5CPg5grDj8+3yPJAvwD9tAEUwBTz+bXk9ZjbydK5J/+o8J0fXkq2xqsjCykujeGfMXI228nM6Cs8Ks90xsXt/FM0jXQ0M+pWsMzY10GbhR2tjX2yrRC/Rc/11dp12e7z+4SOUxzbdBobqlPQTuJKp5Pabu+bYbTYYaPmvScu74P17evX7A87YjW3cWIDaLgSlwJxcFJvyb53+9blf0n0E/7pLjMTrMgSPVqb7TboVQwjTBKvxN8rlDju/h0X7xJRxiFArDI/wnUhdf2IvDCnpvFbuQNDLLNWNlZNJ6ZnrxnPU1nGMmm+Llb0r/Q6+a+JWmWrkRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(39860400002)(346002)(366004)(83380400001)(82960400001)(66556008)(66946007)(6862004)(8936002)(2616005)(186003)(37006003)(2906002)(316002)(6636002)(5660300002)(66476007)(44832011)(4326008)(8676002)(36756003)(41300700001)(6506007)(6512007)(6666004)(26005)(38100700002)(478600001)(86362001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fqISfCyyJpnKdEqaorWCsUzjWYVutCuMgqjpn8RquFOJvbN2y67588ci+xGo?=
 =?us-ascii?Q?1LezNEINJv6GLbNhv1v20cwJaAK4OZIdGuvwSpUpijoqCW6dZpOPDAWMEPd9?=
 =?us-ascii?Q?yNaOY8F4G9zPBYIGrlV+GVTZT6bLNA7nJgA3egQB9280gtHjoibiMZssLEIj?=
 =?us-ascii?Q?Lh8hSUd6ymLv7GrFBsUQKoZ1jd0k9bN9Z1L5Q4kc1tSMHfpp8n+eskZFNNb6?=
 =?us-ascii?Q?XgNxwjNi1MOp9stpwNc42XdKXpoQUAna5LZDAwV31+Dp3rZIcYyaSGGNTaej?=
 =?us-ascii?Q?mk+w2Nc/zyfzGAV51qdTNpT4hkfaSsccdcKmei/4EIAG1EynpQ1YrxeJfNTJ?=
 =?us-ascii?Q?+10De5//FzPRHdcb2WdOdhmWJfrPohPVJJwzR1dyPvk8WYrf6xVmOx6OXqvm?=
 =?us-ascii?Q?xYO1gvxeqJ8vldooKVl8xoEH7ZIegyMEDWj/kZpDYIi1QON6/NFnYcOvMib8?=
 =?us-ascii?Q?EpteuyAveEys+m1lJwy7Vcoh+ENEMB2+8NYe/P4OygIlS9v4j8oedoJHwDu1?=
 =?us-ascii?Q?AEk7b1vmbW5a8I3/g0R3s+DezpaB/jpPSXamR8zuSKbyYBOkpZJvMjScWwBi?=
 =?us-ascii?Q?Pk/k4bZLhtUMF16cQAl5Z31VeVG5ujr+TLfVDkQWWpK8pd5mFtlOwbbYJWQY?=
 =?us-ascii?Q?cZUws3cxKK5jSZIP7DTFR2kxj30gIcQPxrzvHgoYupYWbk0QVdO1engp9LvP?=
 =?us-ascii?Q?sWJjFSBPQdu1SXVJ35TC5kd0DHVqDwxe4rXaPyMCdZbUyx5FywxdVqiZno0/?=
 =?us-ascii?Q?iHxoUgiveOOn+UF+sagx3P+bFC48+VbMNBhVJLvMOcZdrkuptE+Zc5Oic15X?=
 =?us-ascii?Q?wIkp4V7JZoK/7+YmDwY/8FHqD2pK5YnQRVtB3UKQJPQbeQ1TcmV0ENiR3WqI?=
 =?us-ascii?Q?ImTmKWXJd8ZMvH/9FS3QOOz2mLbXdDH8/xbLNgG1lDwhxifeojt4nJfS9V2N?=
 =?us-ascii?Q?y3AR5hhB+fQmiaZE0SrLenbX84tCTCYEadYdUnkH+eNOtuMBWWVI97TQx7Un?=
 =?us-ascii?Q?xblkhg5qzRE0epIZaDGjYzxXMsVIWTN2GBI4YguSCRxBOdWWHJIEKjVj+yY/?=
 =?us-ascii?Q?UqdynpNJkaXE/kLwrzDXdXwI0nOG0aAZTlnpD6nP8wwojoXIgykihgR+86Cq?=
 =?us-ascii?Q?17GJdn9IP3pDQDvrM23Uv4KhSVQL9cXKgjclfF3FdOJEv1FOH9CxaE/UQbKG?=
 =?us-ascii?Q?YUaT3wtI0iG/5PcVlONC80GQFD1eGfz7Qifa3LAX1s0Z6aDVQz17p0yRNA1w?=
 =?us-ascii?Q?mb8+f2V7xK+PQ6saJSTaXXCoxH10TUWGpLXyH7yS+gCXjJm6Z+OSIurR6gbN?=
 =?us-ascii?Q?2fmi/EdEY0aDVPB6coSalSe0JtOZaskIc9nY/UbcgXzw9p3MCTtR27ZrZB00?=
 =?us-ascii?Q?cz3ay41QQa7QdKP7IhsHFSQwIzQoVRRZObsuQ7yc3LTCYrjKIJCkfNbeAnrP?=
 =?us-ascii?Q?z3DT0lpjbmeR9I8FhaT6Mh9nexM4kwQmrTY28N80F7oX5MYgq5qSZDlHtTMk?=
 =?us-ascii?Q?EAnBZhfAecd8S8ZpVHDnNk7XFGxp7/N6JDYuvk1NJiQXNwCgd4pBpFSnmK/k?=
 =?us-ascii?Q?gogwo80oY6ELJsiXREXHp0xrAREBJxcayFeo8uL2v+PkGxeD4zay5rcrkc65?=
 =?us-ascii?Q?zA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1bcf42-493c-4108-c6fe-08da8c3a8adc
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 16:53:49.6281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KK+xZ+aXdTA8FtROaOaQLnK/pRzQg1KkrLM0/xAQq0YTHcJ++c8eBvKF+/UMaj0cRbjNPJaJbXFhUikEAZBoDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3539
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 03:17:26PM -0700, Dixit, Ashutosh wrote:
> On Wed, 31 Aug 2022 14:45:38 -0700, Rodrigo Vivi wrote:
> >
> 
> Hi Rodrigo,
> 
> > We need to inform PCODE of a desired ring frequencies so PCODE update
> > the memory frequencies to us. rps->min_freq and rps->max_freq are the
> > frequencies used in that request. However they were unset when SLPC was
> > enabled and PCODE never updated the memory freq.
> >
> > v2 (as Suggested by Ashutosh): if SLPC is in use, let's pick the right
> >    frequencies from the get_ia_constants instead of the fake init of
> >    rps' min and max.
> >
> > v3: don't forget the max <= min return
> >
> > v4: Move all the freq conversion to intel_rps.c. And the max <= min
> >     check to where it belongs.
> >
> > v5: (Ashutosh) Fix old comment s/50 HZ/50 MHz and add a doc explaining
> >     the "raw format"
> 
> I think we both agree that mostly the way this patch is written it is to
> add SLPC but not risk disturbing host turbo, specially old platforms
> (CHV/VLV/ILK and pre-Gen 6). Also these freq units (sometimes 16.67 MHz
> units, sometimes 50 MHz, sometime MHz) in different places in the driver
> and different product generations is hugely confusing to say the least. For
> old platform we don't really know what units the freq's are in, we only
> know intel_gpu_freq will magically convert freq's to MHz. In any case let's
> work with what we have.

yeap!

> 
> > @@ -130,6 +123,12 @@ static void gen6_update_ring_freq(struct intel_llc *llc)
> >	if (!get_ia_constants(llc, &consts))
> >		return;
> >
> > +	/*
> > +	 * Although this is unlikely on any platform during initialization,
> > +	 * let's ensure we don't get accidentally into infinite loop
> > +	 */
> > +	if (consts.max_gpu_freq <= consts.min_gpu_freq)
> > +		return;
> 
> As I said I would remove reference to "infinite loop", I am not seeing any
> infinite loop, maybe just delete the comment.
> 
> Also as I said I see the check above should be completely removed (so it is
> actually a pre-existing bug in the code). However since you want to carry
> it forward in order not to risk disturbing legacy behavior that's fine.

I know we can get the infinit loop because I faced it here on a bad config
where min = max. os if min >= max, the for loop will never close.
And in case we have some fused parts with min = max we will take a while
to figure out what's going on during po. and who knows about older platforms
and skus out there as well.

I will keep the comment so we don't end up removing it from here.

> 
> Rest LGTM:
> 
> Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>

Thanks
