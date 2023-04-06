Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429586D98EC
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 16:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238960AbjDFOFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 10:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbjDFOFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 10:05:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1459768;
        Thu,  6 Apr 2023 07:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680789910; x=1712325910;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FGwC4sC+Ba98YiKKWS1kBPmmulCGW7APU+8S33UpVnU=;
  b=arrq6zii07OvZuU4czQsdoz7DwXq44OTd4En7ynGwJGd/JDd8dsEziz/
   1tuwe4Pm544c4F2kgXB9/bJSlNwfh8PXNBuTbk55fmzKBVaVXciVTlM9K
   Mu4naEw+64LW7BNCV5LTxxdstSbVxEO14GUACqSiWhVOg2X43et4Bu0Ro
   TXXzXKb/qt8EeexL4iHvGEFargdBfBavmoBCR2fLm/3H8PFWt7hNa7onc
   xcboOLI8lodglF3XTGuGPAW95/cBsb60Seis8tq0OjfC8MwXuCSckiMj9
   wxe3tiRNTNBGmhIImarRh9B9x9rgWJXuGdU43TOu14iKvyWugF8hi6cbM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="341473157"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="341473157"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 07:04:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="1016884432"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="1016884432"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 06 Apr 2023 07:04:32 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 07:04:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 07:04:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 07:04:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 07:04:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUZYMdzKMf6eX5t6ZT8D4NaUjitG3H4piOjZWquvqQ0uVgYyDgWrryze4BtbKTVn0tSyBI7mpEzG5yLbohcnh42X45GZVKD+Ff8jRMeY3YoXpzhwHtFecYDFDq99x6JS34ogoBYhu0YI6CnskiR5B5fKaMW/h5GD67mTpaymIb7UEMOBSj97i5iIVyPSM6RGz/hPyqEVp9oZE2U/A+GO8sZQAwoaYLEN7Q9rT8dWSH8bgWgzf6kfYjDF4NuzLSNozzU2H5nNVCorJS9U2h2IjzD8/0nbdOFM70yrIsA3zjmMReVw+f7F188UNrkvJU67jv/on5eU5GYBgsYKQMi0sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BeNUkCAySR0f0YY7DngWIjYjWUskMctFluD/xT/NPsg=;
 b=AQ0TTvnyGbz1OPeyH/Q8k6K8BE77WB7XSjHQOL5d8cTdujqrcYjm0UDtBvnEfz9OddmKsA03HpjskSr/fDB/pydKNBlfSpEOWZN+vkE0JVVrFBParTBiz1VaeTlcv/7hVGKc6b333xL035A6Fc6NZU8SInmjuXps/adPIQ7m7MBJCpVUS8BPRRqYEZYR/nhWkLSEruL1+A1Kqx8927NY4EUjSuT9iI03tZygFSMuC4c87AlTQ63M5XeIsu6c7DpfUIwGzpdsw/CO2iXE7r9RNAcm+ijHmgtHJRdVN95dWxXDmgDaHDPT77NsvS2EeTfKciwExEXXHB+Do/gc3Www0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB3060.namprd11.prod.outlook.com (2603:10b6:208:72::24)
 by SJ2PR11MB7670.namprd11.prod.outlook.com (2603:10b6:a03:4c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.34; Thu, 6 Apr
 2023 14:04:28 +0000
Received: from BL0PR11MB3060.namprd11.prod.outlook.com
 ([fe80::bb9:c617:3fd4:7bb3]) by BL0PR11MB3060.namprd11.prod.outlook.com
 ([fe80::bb9:c617:3fd4:7bb3%6]) with mapi id 15.20.6254.026; Thu, 6 Apr 2023
 14:04:28 +0000
Date:   Thu, 6 Apr 2023 22:04:16 +0800
From:   Aaron Lu <aaron.lu@intel.com>
To:     Rongwei Wang <rongwei.wang@linux.alibaba.com>
CC:     <akpm@linux-foundation.org>, <bagasdotme@gmail.com>,
        <willy@infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm/swap: fix swap_info_struct race between swapoff
 and get_swap_pages()
Message-ID: <20230406140416.GA415291@ziqianlu-desk2>
References: <20230401221920.57986-1-rongwei.wang@linux.alibaba.com>
 <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
X-ClientProxiedBy: SG2PR06CA0249.apcprd06.prod.outlook.com
 (2603:1096:4:ac::33) To BL0PR11MB3060.namprd11.prod.outlook.com
 (2603:10b6:208:72::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB3060:EE_|SJ2PR11MB7670:EE_
X-MS-Office365-Filtering-Correlation-Id: 871b6a0d-316f-468c-8e76-08db36a7d606
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H4petGXPGEp0J02JpeRMb5UNcwYE6u/Z7Ln1+O6qhgEQyqWfnW2zbOGS/t9c9T4D3oURM8XTUx4D2pCTvRTOiQ7s4WqicsgcmDPCb4VCNO51MznLwCC2E/La72zlNSKJ3jAO8rz+5ELfgpA8fIjmKTza+nL0jmQNheJNSf6k6DixpDVl1wkGw8O8AriGP5GMD2KwyW9x4bc+OLYKR3AMrf4+eRANaGGId4+suS5z5fGKsp64yPK7/KGtrMxGBMtVINfwsP+oljTkM6A4RKgDP8chOYzcmchoz7gdJ/uT5dArRsoq1Dic1kffc6ejRee5C2i/XS67VqhRzUU9kxJqa0V0RZ2wct5cYL7UilgRKQkz84r/QIAZqMp2gGngK7vYrYfCcUW1AofapGmqdu/4Kw/dG2x7wVWnr5YI5sNBofjS6zbqqpYNpVJNue8caVeb5zUWoeZqctQqzhB5q9NGmRq+qez58YdKnKD6FCsma4+juxeb+IeIMIX0elQDvT51K4oF5zmapyAaBuBXQ+ADx8wcvRlzrnO2eLWGsEFcjUokJC0gKrJKpkxeHKmEcm65
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3060.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199021)(4326008)(66946007)(6916009)(66476007)(478600001)(8676002)(66556008)(316002)(8936002)(38100700002)(5660300002)(41300700001)(44832011)(82960400001)(45080400002)(6486002)(186003)(9686003)(6506007)(6666004)(1076003)(26005)(6512007)(83380400001)(2906002)(33656002)(33716001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bjtbTLeMzW2guBoSGR2fXFJtTz1ZlSH7kwqYljobtoDmE36dJ+wA8cku4LB8?=
 =?us-ascii?Q?/HxPR5P+ax1li9dXOpcxRGE2MCyproQbisu5baR45P6YWG20zkrPrqhOD2JL?=
 =?us-ascii?Q?iHq5UulJFoZgOyXzJBbcf2paAtWgqtcnY5WVnm87oCEWymqHjN8hg/ii+jzQ?=
 =?us-ascii?Q?9dyQhPA22PJ03mWaiK2SyeSZHZ80AexxTXCvrOemmT4GnanUG7kV7A5ect9s?=
 =?us-ascii?Q?X+Kabivfoz8xmwooM6338KaIPgwSN/9E7DdQANxIBBGzzWvttWVduMkURXlT?=
 =?us-ascii?Q?VS98qkdj8qh5gx1WgdKatw3Bf9y60ljjEeEga1xmPKAAZenpsPNncme5eSjO?=
 =?us-ascii?Q?SOSshusTECOO/pZewKhAk60oYVJNTvcbBVouhuc0HLpSZyy5q+5pLQuaD4gG?=
 =?us-ascii?Q?X43ZTIqblp7VmRhe3tLrXhG+7NBY6+ClRvV/AoyOgQx4CGZGLEo1Ode/B9xQ?=
 =?us-ascii?Q?yH1gegK+bnDgMsay1XjKazcrx6Y+SbBRE5bciC/QbSX0mfmPOVRfCwy+ia9z?=
 =?us-ascii?Q?YUdCm4X34Jtvc32i2icmSO89cGDkETLdgmiNHotJ3C2ayNexLbo7MQ7Wlip2?=
 =?us-ascii?Q?1UGx62V5K6f0HaxNCVMUNJfYWIO2I4/1cmMgF5ITcJzSKEnCExEFFZNoJBng?=
 =?us-ascii?Q?wl2hFZeJSxYisx08rhYgSPztm8OKkL6iT6xOuVsJHKHn54oXJLwDayQAdF3r?=
 =?us-ascii?Q?u/a4Zb97GV89689IWqho0UvSF1Zj+MzlfUoabUiNrpFXgBcgqbSlk3FhQ8j/?=
 =?us-ascii?Q?YIl//GKdpzJVSvMXUgzKncJ8BpOeHmeD1XXC62QE573fVk5FB5QNxivcpk6J?=
 =?us-ascii?Q?6B65VtYFvjYMiFgSBiBGJ3bBlQIGEYLmVxz2PAtoMntv8jwaVcFJZPAz2GMw?=
 =?us-ascii?Q?hPTTruWoQVvV9E/yuwbT0gq92eB4bLZAILp8ciXvpPaTwxwpWYLnxOky3CRk?=
 =?us-ascii?Q?vw13WuhcgUDWQjK0y0Xo5h9bjeGF5/nGqAPCz8cPXboKa/yFY3zuV3e9QQHO?=
 =?us-ascii?Q?0ZI0nj/rYCHQ59Vh3tCS3JVU4p/Od2arYpqOTLou7+hM1fgbI8KpinYuVyTy?=
 =?us-ascii?Q?lpu6a7D2DfLXlqwCZ+rjVljEQfWzicXFyZgT4iE81IFqdjk1tY5KeuHFHoQK?=
 =?us-ascii?Q?/7DzebO641e7h9cvNmCQAlWlryRQZJWMUBH0IGAj9I3GVlvuWp19gCIS3Yek?=
 =?us-ascii?Q?rQNsengBUGfnJGSHIkWoY4SgvB7/H50zXIiffwRBKaJu74iRaD43owWsT8X5?=
 =?us-ascii?Q?0zkB9RbBZ1C5ng378L0G+QVtfWBMeTH/sy4DDjRygivbk1ykHJpwLOJs68db?=
 =?us-ascii?Q?2LNGYRL8lGPaUa8NGoJSE7lQoLmQCh1DAf+/fl9ZU95gCK3eVJR2aAlFsNP+?=
 =?us-ascii?Q?wNKeu3eNiD6CV7Wrl9xwrdmHAe+0KYXVAhivifv6xQyDL+oQ0UzxcT6+RCLq?=
 =?us-ascii?Q?NdqzfV01fMk5GmDsllaAuwyDY5XTk8CISZq+khPQ+gEKKkneP1gp2opjYhj3?=
 =?us-ascii?Q?5padmIIZVZs7zxsX+lZ4mpeNSKaZRb0MlbAqFg3d+QNY2dydvRTqlYYOvrOf?=
 =?us-ascii?Q?kaN+Xx4Kyy4lgHIxKS4oIU5AODTXHFJaQZ9Ju5fK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 871b6a0d-316f-468c-8e76-08db36a7d606
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3060.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 14:04:28.2674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vIzSLxwP6IqqXA9R32V0b6GOvI+FauiVVzWjfgYQHsjWUjN9a03hHkVBoewvD7YIB7XB/20vLOcG2dtF8ljYKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7670
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 11:47:16PM +0800, Rongwei Wang wrote:
> The si->lock must be held when deleting the si from
> the available list.  Otherwise, another thread can
> re-add the si to the available list, which can lead
> to memory corruption. The only place we have found
> where this happens is in the swapoff path. This case
> can be described as below:
> 
> core 0                       core 1
> swapoff
> 
> del_from_avail_list(si)      waiting
> 
> try lock si->lock            acquire swap_avail_lock
>                              and re-add si into
>                              swap_avail_head

                               confused here.

If del_from_avail_list(si) finished in swaoff path, then this si should
not exist in any of the per-node avail list and core 1 should not be
able to re-add it.

I stared at the code for a while and couldn't figure out how this
happened, will continue to look at this tomorrow.

Thanks,
Aaron

> 
> acquire si->lock but
> missing si already be
> added again, and continuing
> to clear SWP_WRITEOK, etc.
> 
> It can be easily found a massive warning messages can
> be triggered inside get_swap_pages() by some special
> cases, for example, we call madvise(MADV_PAGEOUT) on
> blocks of touched memory concurrently, meanwhile, run
> much swapon-swapoff operations (e.g. stress-ng-swap).
> 
> However, in the worst case, panic can be caused by the
> above scene. In swapoff(), the memory used by si could
> be kept in swap_info[] after turning off a swap. This
> means memory corruption will not be caused immediately
> until allocated and reset for a new swap in the swapon
> path. A panic message caused:
> (with CONFIG_PLIST_DEBUG enabled)
> 
> ------------[ cut here ]------------
> top: 00000000e58a3003, n: 0000000013e75cda, p: 000000008cd4451a
> prev: 0000000035b1e58a, n: 000000008cd4451a, p: 000000002150ee8d
> next: 000000008cd4451a, n: 000000008cd4451a, p: 000000008cd4451a
> WARNING: CPU: 21 PID: 1843 at lib/plist.c:60 plist_check_prev_next_node+0x50/0x70
> Modules linked in: rfkill(E) crct10dif_ce(E)...
> CPU: 21 PID: 1843 Comm: stress-ng Kdump: ... 5.10.134+
> Hardware name: Alibaba Cloud ECS, BIOS 0.0.0 02/06/2015
> pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
> pc : plist_check_prev_next_node+0x50/0x70
> lr : plist_check_prev_next_node+0x50/0x70
> sp : ffff0018009d3c30
> x29: ffff0018009d3c40 x28: ffff800011b32a98
> x27: 0000000000000000 x26: ffff001803908000
> x25: ffff8000128ea088 x24: ffff800011b32a48
> x23: 0000000000000028 x22: ffff001800875c00
> x21: ffff800010f9e520 x20: ffff001800875c00
> x19: ffff001800fdc6e0 x18: 0000000000000030
> x17: 0000000000000000 x16: 0000000000000000
> x15: 0736076307640766 x14: 0730073007380731
> x13: 0736076307640766 x12: 0730073007380731
> x11: 000000000004058d x10: 0000000085a85b76
> x9 : ffff8000101436e4 x8 : ffff800011c8ce08
> x7 : 0000000000000000 x6 : 0000000000000001
> x5 : ffff0017df9ed338 x4 : 0000000000000001
> x3 : ffff8017ce62a000 x2 : ffff0017df9ed340
> x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>  plist_check_prev_next_node+0x50/0x70
>  plist_check_head+0x80/0xf0
>  plist_add+0x28/0x140
>  add_to_avail_list+0x9c/0xf0
>  _enable_swap_info+0x78/0xb4
>  __do_sys_swapon+0x918/0xa10
>  __arm64_sys_swapon+0x20/0x30
>  el0_svc_common+0x8c/0x220
>  do_el0_svc+0x2c/0x90
>  el0_svc+0x1c/0x30
>  el0_sync_handler+0xa8/0xb0
>  el0_sync+0x148/0x180
> irq event stamp: 2082270
> 
> Now, si->lock locked before calling 'del_from_avail_list()'
> to make sure other thread see the si had been deleted
> and SWP_WRITEOK cleared together, will not reinsert again.
> 
> This problem exists in versions after stable 5.10.y.
> 
> Cc: stable@vger.kernel.org
> Tested-by: Yongchen Yin <wb-yyc939293@alibaba-inc.com>
> Signed-off-by: Rongwei Wang <rongwei.wang@linux.alibaba.com>
> ---
>  mm/swapfile.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 62ba2bf577d7..2c718f45745f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -679,6 +679,7 @@ static void __del_from_avail_list(struct swap_info_struct *p)
>  {
>  	int nid;
>  
> +	assert_spin_locked(&p->lock);
>  	for_each_node(nid)
>  		plist_del(&p->avail_lists[nid], &swap_avail_heads[nid]);
>  }
> @@ -2434,8 +2435,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  		spin_unlock(&swap_lock);
>  		goto out_dput;
>  	}
> -	del_from_avail_list(p);
>  	spin_lock(&p->lock);
> +	del_from_avail_list(p);
>  	if (p->prio < 0) {
>  		struct swap_info_struct *si = p;
>  		int nid;
> -- 
> 2.27.0
> 
