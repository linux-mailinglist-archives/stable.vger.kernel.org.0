Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A1E6D9B61
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 16:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjDFO6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 10:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238197AbjDFO6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 10:58:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499901B0;
        Thu,  6 Apr 2023 07:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680793094; x=1712329094;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pnaIsvYdEBUsxi881CQXMsuHSK4R7/JfF2eRFZxb8ek=;
  b=PcGwK2pFdMmsZ8KbeCpK1AAL7ztjWFn2Arccx32n1Q86gCvSQQ38fgaB
   lCSVoYRj4+nlie3zzDuAAPoZoFpvmWh951citYgBN89XJqNh64EQ0FKbs
   EuHMphe/YJuRpnIUqTlGHN1oZZd/lcMUjb9N/bReSu0a2TZUN7tWrkF8S
   EcUdD6ru/JVgqty92v5SgusXVUZGBB0hGdKaurgMgq4kkBcDgn3lmxnFs
   qF8y+vytYQq3Y+EaKoXJa7nE1S5GD9gm+8W8TvhmD3fvZ1Tt1K8rI0NwH
   l+OIWZesMmS2VExhkeI2IPY6QoL9aIr7WUyO4ro8dPrU4i09JLLhSeriT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="429041351"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="429041351"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 07:58:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="1016902674"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="1016902674"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 06 Apr 2023 07:58:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 07:58:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 07:58:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 07:58:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 07:58:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3N5CbcMQCNkVzk3o7IvOGE57/aR6Doh/xMkTppHMeaWAXQ16TYtfwCTiybnGUFs2rsJola0bfao4zYEJ2Htg/aZrOA6gzb2wCWkXAiSlJFLN8TYm7QGG5rLA8t1wgFur7dbnwHeXct4WFLMIc0QDo/BGmpf6t49cAwvjGrTuRsbY51qbsFnFOtGNuZhPbK14qM4xaG+Ja0ijzlAY2kgYU7z/UTbyHT9nwW3svcDsqtrmtGtq2YBiqDZhRvJ68frnOEF8ooVf/bJbSVy0gmZdFY4eR40EEhPvzOUtnx3zswe765LLQLKD5hSAh+qGHBQ5iOK0DM8g7y6NmjDNCMGxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8sDIOKLYVClANxUhEOiSGgSTW3mg/oSQ88JjNJDWZPY=;
 b=Py9pjFSniKa3RKwYuY0mxL9ZGJGawW29jdoQZNE7oWIfE7N0pxA8x3abAePbT9O7OYJFN1kphCqgzaO/oViqY8tkTV+hgmLl7qa4j0dGzs+eydnDtLE16sOFOpUl5KBgBwid7bqMoKjkqZMcWaoNhh/QsX09TkJlCuuez1knvajqOzhUKSZoMUuY9x1WLsac35DBxPydgIsdthw2t36c6GsXLyGmCE3AR7wrberlNKN6Snl0UHXwAPypTsWA1RNjxdVaaVAutnZPT23i8KKtdQGEb0Ed5O/mrh35Nb1Pgwp9OEDHnAqhMZfVFTHiThzWJMQqGsiCJNsF8efzKW4zAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB3060.namprd11.prod.outlook.com (2603:10b6:208:72::24)
 by DS7PR11MB7860.namprd11.prod.outlook.com (2603:10b6:8:da::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.34; Thu, 6 Apr
 2023 14:58:07 +0000
Received: from BL0PR11MB3060.namprd11.prod.outlook.com
 ([fe80::bb9:c617:3fd4:7bb3]) by BL0PR11MB3060.namprd11.prod.outlook.com
 ([fe80::bb9:c617:3fd4:7bb3%6]) with mapi id 15.20.6254.026; Thu, 6 Apr 2023
 14:58:07 +0000
Date:   Thu, 6 Apr 2023 22:57:54 +0800
From:   Aaron Lu <aaron.lu@intel.com>
To:     Rongwei Wang <rongwei.wang@linux.alibaba.com>
CC:     <akpm@linux-foundation.org>, <bagasdotme@gmail.com>,
        <willy@infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm/swap: fix swap_info_struct race between swapoff
 and get_swap_pages()
Message-ID: <20230406145754.GA440657@ziqianlu-desk2>
References: <20230401221920.57986-1-rongwei.wang@linux.alibaba.com>
 <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
 <20230406140416.GA415291@ziqianlu-desk2>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230406140416.GA415291@ziqianlu-desk2>
X-ClientProxiedBy: SG2PR01CA0132.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::36) To BL0PR11MB3060.namprd11.prod.outlook.com
 (2603:10b6:208:72::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB3060:EE_|DS7PR11MB7860:EE_
X-MS-Office365-Filtering-Correlation-Id: fcc4257c-e60b-49ac-f072-08db36af5478
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vI5fqmB9tMgEAELzct+75Sx7sqDL32NSTpQrtKVABmmd2MIG7AmxaTbc96tUM8inrU9t8/VUqytgixtzWuJUtlA3PL765UCOqTIDn0b1xWMjvsl//qAvnyPPyqzmFFofG1+Ak8OuaRX2rKFaDPZYC+Tnu8m46VPX0NinoA7NPAOK9+ixqtMKDhB9SPcmTm+JAmrc0sFZuUSPSTuxIEpbE10tyMs+4k2yq3pYaSV004avJfN6wFdjp1z/cRF3zRtg2MQ6rMvo+F8+WSURBdA2YEym8fZVkbNgtaYY+S4Q3xp8zDvqY8D3r96LHykMBZyLWIVLdG8L7q6h+lmYK/4gBrBAAYHxeQPTAqadEUuUv4egHng0NfzuVhkZJ7BbJsJglRnPfuBJkVTMET90d4V8MzKRT2TlXJeDagjC8rx42hcjhEqQjib1W4nwn3PmiJJJvBV0zVIHn4MFlPm4lzEbl/XUpROPpyTVB157o9taNlJBW0GqK/ry6ZtOkP/PIlu7yPl7TyAWWTgvYJcwoQpryKkdlCToJEBJ7BMD0LjIUAIoy5x6fPB7WZtUYnepFxnK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3060.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199021)(2906002)(9686003)(6512007)(6486002)(1076003)(316002)(6506007)(26005)(478600001)(66476007)(66946007)(82960400001)(186003)(86362001)(8676002)(66556008)(83380400001)(6666004)(6916009)(4326008)(41300700001)(5660300002)(44832011)(38100700002)(45080400002)(8936002)(33716001)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oKznUXgtj+7Ws1Wh0tUneP3UR2lwSy1kJzZKKGjvoqHq6YX2lCnyphnIzASR?=
 =?us-ascii?Q?yPdBYS30NEiXDpwzZlsl6M5HZoQkhtL9K9ssVgIl15U2Evfn5xMP5wCpxpbC?=
 =?us-ascii?Q?lKKfk+TTA07aFhlGJnlHG3V9l8a3MkokenISkjuLDaVL1fuar+2o+rGQoA23?=
 =?us-ascii?Q?rBK/Nj4OI/NuyGb7veoZiYdpeIU/pdmFBF0e79vU2HGS30ajWzxUWKeQnf5A?=
 =?us-ascii?Q?fmm3avoPPWsC/g0564Y+HGUoMjxKNGcUbSYbCO+gPYea9qsmVvY5J+DEXpH4?=
 =?us-ascii?Q?pVxyM2+ukxbWc3QeLFOb0qnuag1GUjqdowK8SaKMg7tsirFn31Ahn2gr2O+A?=
 =?us-ascii?Q?AXDp+A+IxueVqRiN/sRqSfgdUNxDbp6vcalH6UyKB/fMb/zEBpav6QRwTaVz?=
 =?us-ascii?Q?OjU7VeOTh1eCxZHSK4SIuNv0nUtUDXOsvAoDDROyyPwlH1nRhOOCGMbcTJ9j?=
 =?us-ascii?Q?RMlqlDoAg59dEOgL/WkgtOGHiKEaIarmlkbbpd7bHrqlV0/tD2ipJx8C24Hi?=
 =?us-ascii?Q?0Q4QXGzdvCgjX+lDtRa5NbP3rxcIK5YP6gK1fNLitiQEdKAW1Byw1Px9NtEP?=
 =?us-ascii?Q?8S/aingkMRlWgvYqAIxL7cbHz+8E0TK+7vn9D9nCunficFvlNq6tYNunT2k/?=
 =?us-ascii?Q?cRkppTFKP/utu9I2MG5TYzEHxVgm9WE0YFuWBK8JrMnMQBq/ZfPobhdYAejD?=
 =?us-ascii?Q?pIYWEmr++a7kVFq1cyph2UEi7rAk4gLix7ZZA/57TvsSjr82O3pManZGLxLk?=
 =?us-ascii?Q?bX1QEAT+isrodWLLxQQIMsPtydHvudiT8fjTz9ZpYNlLPuBAMPmFpteL2d1l?=
 =?us-ascii?Q?gShIuFeYUBQvhPEo/uOWQCrJB/clYfGbY+vgV+06OcAZIBwIL7KfPTASqHwM?=
 =?us-ascii?Q?KRKF9nmLr+6zfkKQxCxt3md6jqQyNRUGRUDcBdjbnEvrjFxoW717ecN+hvz9?=
 =?us-ascii?Q?6F90RFqjJPJkPZjOTiIs1T4fgA1teu5HAUo2PUBORaV0oQwrrpt4e3WW1Jty?=
 =?us-ascii?Q?TsDdl8nMNGODXOB132bJNFYpEWeayPdd+U7bo1kF7l+/MSYj5RIWOmmwkStt?=
 =?us-ascii?Q?ONgeGAOuLCKK/Hox4SBcaen9pUXYj1Fbk4oijdYRx8bNlFanCp5E4A73Cxn+?=
 =?us-ascii?Q?x/XyAmHYA9k//KuOsN+VaHlFDCcIKALNd9afeVM80hta5klTj/4dCIDdQQvd?=
 =?us-ascii?Q?yXgLg7pYQXQs98/oe/8uNlOJoCs2nGFPFI84kUleyDS8YhEV+yYEnGDYpY9i?=
 =?us-ascii?Q?nwulXOfhTSwLQ+At8MKefNqyT7S7TMhJRRoVJoVdAQpEBEqwTLjLM2YknEjB?=
 =?us-ascii?Q?+bn9RlSkXbeZyfNA31nY2cSDoy+i4IjX0rtMB8dpj014X9UMSA5FBr58tIh5?=
 =?us-ascii?Q?DBMbp1l2Wot/F/AIPosPg2ey+g/941OMYgbVT/uhccQsbaq6Td07GowYPve1?=
 =?us-ascii?Q?ZRQAVoY7gSF+zUygQW1eVTOy1mupbWnue8Yl8GlYsSKph369+895wn8hFJ+5?=
 =?us-ascii?Q?lUlPNCD6FQXcXT48QAdsC6Rkobtp9xBwtfPypAJnY1g0IasfXuveAO9q7pIk?=
 =?us-ascii?Q?jPVGz1O5de02yIjRVXL3+mxagvXiFcpqUqfzDGdO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc4257c-e60b-49ac-f072-08db36af5478
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3060.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 14:58:06.9193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Mfq6GO3WKKiRBdzzRIMWU1boLvipKPFChK3ejS3s06VywPbzwUD7kA5z1mkAqsPke45t8AXjYvqChq4EhMCQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7860
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 06, 2023 at 10:04:16PM +0800, Aaron Lu wrote:
> On Tue, Apr 04, 2023 at 11:47:16PM +0800, Rongwei Wang wrote:
> > The si->lock must be held when deleting the si from
> > the available list.  Otherwise, another thread can
> > re-add the si to the available list, which can lead
> > to memory corruption. The only place we have found
> > where this happens is in the swapoff path. This case
> > can be described as below:
> > 
> > core 0                       core 1
> > swapoff
> > 
> > del_from_avail_list(si)      waiting
> > 
> > try lock si->lock            acquire swap_avail_lock
> >                              and re-add si into
> >                              swap_avail_head
> 
>                                confused here.
> 
> If del_from_avail_list(si) finished in swaoff path, then this si should
> not exist in any of the per-node avail list and core 1 should not be
> able to re-add it.

I think a possible sequence could be like this:

cpuX                             cpuY
swapoff                          put_swap_folio()

del_from_avail_list(si)
                                 taken si->lock
spin_lock(&si->lock); 

				 swap_range_free()
				 was_full && SWP_WRITEOK -> re-add!
				 drop si->lock

taken si->lock
proceed removing si

End result: si left on avail_list after being swapped off.

The problem is, in add_to_avail_list(), it has no idea this si is being
swapped off and taking si->lock then del_from_avail_list() could avoid
this problem, so I think this patch did the right thing but the
changelog about how this happened needs updating and after that:

Reviewed-by: Aaron Lu <aaron.lu@intel.com>

Thanks,
Aaron

> 
> I stared at the code for a while and couldn't figure out how this
> happened, will continue to look at this tomorrow.
> > 
> > acquire si->lock but
> > missing si already be
> > added again, and continuing
> > to clear SWP_WRITEOK, etc.
> > 
> > It can be easily found a massive warning messages can
> > be triggered inside get_swap_pages() by some special
> > cases, for example, we call madvise(MADV_PAGEOUT) on
> > blocks of touched memory concurrently, meanwhile, run
> > much swapon-swapoff operations (e.g. stress-ng-swap).
> > 
> > However, in the worst case, panic can be caused by the
> > above scene. In swapoff(), the memory used by si could
> > be kept in swap_info[] after turning off a swap. This
> > means memory corruption will not be caused immediately
> > until allocated and reset for a new swap in the swapon
> > path. A panic message caused:
> > (with CONFIG_PLIST_DEBUG enabled)
> > 
> > ------------[ cut here ]------------
> > top: 00000000e58a3003, n: 0000000013e75cda, p: 000000008cd4451a
> > prev: 0000000035b1e58a, n: 000000008cd4451a, p: 000000002150ee8d
> > next: 000000008cd4451a, n: 000000008cd4451a, p: 000000008cd4451a
> > WARNING: CPU: 21 PID: 1843 at lib/plist.c:60 plist_check_prev_next_node+0x50/0x70
> > Modules linked in: rfkill(E) crct10dif_ce(E)...
> > CPU: 21 PID: 1843 Comm: stress-ng Kdump: ... 5.10.134+
> > Hardware name: Alibaba Cloud ECS, BIOS 0.0.0 02/06/2015
> > pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
> > pc : plist_check_prev_next_node+0x50/0x70
> > lr : plist_check_prev_next_node+0x50/0x70
> > sp : ffff0018009d3c30
> > x29: ffff0018009d3c40 x28: ffff800011b32a98
> > x27: 0000000000000000 x26: ffff001803908000
> > x25: ffff8000128ea088 x24: ffff800011b32a48
> > x23: 0000000000000028 x22: ffff001800875c00
> > x21: ffff800010f9e520 x20: ffff001800875c00
> > x19: ffff001800fdc6e0 x18: 0000000000000030
> > x17: 0000000000000000 x16: 0000000000000000
> > x15: 0736076307640766 x14: 0730073007380731
> > x13: 0736076307640766 x12: 0730073007380731
> > x11: 000000000004058d x10: 0000000085a85b76
> > x9 : ffff8000101436e4 x8 : ffff800011c8ce08
> > x7 : 0000000000000000 x6 : 0000000000000001
> > x5 : ffff0017df9ed338 x4 : 0000000000000001
> > x3 : ffff8017ce62a000 x2 : ffff0017df9ed340
> > x1 : 0000000000000000 x0 : 0000000000000000
> > Call trace:
> >  plist_check_prev_next_node+0x50/0x70
> >  plist_check_head+0x80/0xf0
> >  plist_add+0x28/0x140
> >  add_to_avail_list+0x9c/0xf0
> >  _enable_swap_info+0x78/0xb4
> >  __do_sys_swapon+0x918/0xa10
> >  __arm64_sys_swapon+0x20/0x30
> >  el0_svc_common+0x8c/0x220
> >  do_el0_svc+0x2c/0x90
> >  el0_svc+0x1c/0x30
> >  el0_sync_handler+0xa8/0xb0
> >  el0_sync+0x148/0x180
> > irq event stamp: 2082270
> > 
> > Now, si->lock locked before calling 'del_from_avail_list()'
> > to make sure other thread see the si had been deleted
> > and SWP_WRITEOK cleared together, will not reinsert again.
> > 
> > This problem exists in versions after stable 5.10.y.
> > 
> > Cc: stable@vger.kernel.org
> > Tested-by: Yongchen Yin <wb-yyc939293@alibaba-inc.com>
> > Signed-off-by: Rongwei Wang <rongwei.wang@linux.alibaba.com>
> > ---
> >  mm/swapfile.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 62ba2bf577d7..2c718f45745f 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -679,6 +679,7 @@ static void __del_from_avail_list(struct swap_info_struct *p)
> >  {
> >  	int nid;
> >  
> > +	assert_spin_locked(&p->lock);
> >  	for_each_node(nid)
> >  		plist_del(&p->avail_lists[nid], &swap_avail_heads[nid]);
> >  }
> > @@ -2434,8 +2435,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
> >  		spin_unlock(&swap_lock);
> >  		goto out_dput;
> >  	}
> > -	del_from_avail_list(p);
> >  	spin_lock(&p->lock);
> > +	del_from_avail_list(p);
> >  	if (p->prio < 0) {
> >  		struct swap_info_struct *si = p;
> >  		int nid;
> > -- 
> > 2.27.0
> > 
