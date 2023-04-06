Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC82A6D9015
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 09:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235471AbjDFHFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 03:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbjDFHE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 03:04:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F999BB8D;
        Thu,  6 Apr 2023 00:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680764601; x=1712300601;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=N8gyyV3oIQrOS3Bhv+IwmZz0HlaYz2lJEUZS7C4kwFc=;
  b=MnaTCIUULUIGfSKX3ziYdQtaze2eXPAFR8KRduObazk58Pn7TQdD5Iqy
   AhhQLE5g9c9R4tPQxDGj3W2L5g+HVFZwDoIJzOB0PnxrQXvIGbLb6KlRe
   EdJ3scOAgM4CPpCgAY4zQjLT8+H0HwBVM3sqNMtDZ5wunfn+AsRLHcHZw
   hnlzmxRIghd65vd7BI/Cjtcliv/YASQfSg/+1KZmI4iQfQc0RMwG27CE6
   ipyde8neVq1BcVq2T2uS5k6UWb6O+PXlhlFwtQ95TU1RPKjHJ0Da2+XyU
   C0BVKSVDBXSFiDYQ2Sjdp6Qaj6QXtgeTIlKru6M8cuRGvcZt+XxGuLKAi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="322311062"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="322311062"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 23:58:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="717337926"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="717337926"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 05 Apr 2023 23:58:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 23:58:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 23:58:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 23:58:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 23:58:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLd9W71WqthVTptzjfCoDvWEaNIjxcd0TPFxuFLo5mjeC5NsM7yuWvaF+LB1uZmk6u8AM98wDoFS7//rjkIF0qCIIEjhRfXe1er1UGUo012HS2RmbO79ixTrn9Z2eTvedOp/GbrtBII+yfAqYCwIWkWjhF3WC7ZM+mmPMwAgndtYp6FlNhCE+gmZnQuGBS/cSlM7IxY4+HMrfc0t9UibHfjyQbQ6Oc4stkhNoDKtuYlZd/zADhHPACWLtXqQ1Y+vCNapWLG7z3yU+hSuNZ9t3ujlLMGEUPa4xukEby3NG+C6EZraDFc4KKjTvei57g5drNTeyfZfdHkeoKIE7aAlew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QjW1OD8rt73L9SpkQXSiJU84LQ+ImT5WFmSzX0+JvLM=;
 b=nzuZFjNRbpW+bY5hlRGwGbaGmfhjNmv6yh6YQXwtwsF2Jc8bQvbFM8L9mZRMzWUycXgYBhaBjQBOdf5PZdYZsMUA5Pqxbets5x1Mg7zVfD47ULjHganLmuMoOynR8PPfs8GmulMHuBAGvEX1RfMYTeMzo5vuwDm/QHgoNDFi3sVgctIGen9YKXFmis4xm8NS34joX6jx7U+o4dxb/8RpTI88/DB43QyrUOPzahqZ8Xf/sQ77vO/toaMoe07iiC+8N8gHYBE99QNdTwqv36tcU2Jy3DkWSX32A5VbWqiqdklFyP8QWdCuAa9OQuUUyI+EqUinXvm8qiemAgu1+2M3hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3062.namprd11.prod.outlook.com (2603:10b6:a03:92::18)
 by SJ0PR11MB6717.namprd11.prod.outlook.com (2603:10b6:a03:44f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Thu, 6 Apr
 2023 06:58:19 +0000
Received: from BYAPR11MB3062.namprd11.prod.outlook.com
 ([fe80::78d1:41fe:eae2:1f6d]) by BYAPR11MB3062.namprd11.prod.outlook.com
 ([fe80::78d1:41fe:eae2:1f6d%7]) with mapi id 15.20.6254.034; Thu, 6 Apr 2023
 06:58:19 +0000
Date:   Thu, 6 Apr 2023 14:58:09 +0800
From:   Aaron Lu <aaron.lu@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Rongwei Wang <rongwei.wang@linux.alibaba.com>,
        <bagasdotme@gmail.com>, <willy@infradead.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm/swap: fix swap_info_struct race between swapoff
 and get_swap_pages()
Message-ID: <20230406065809.GB64960@ziqianlu-desk2>
References: <20230401221920.57986-1-rongwei.wang@linux.alibaba.com>
 <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
 <20230404122600.88257a623c7f72e078dcf705@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230404122600.88257a623c7f72e078dcf705@linux-foundation.org>
X-ClientProxiedBy: SG2PR04CA0202.apcprd04.prod.outlook.com
 (2603:1096:4:187::20) To BYAPR11MB3062.namprd11.prod.outlook.com
 (2603:10b6:a03:92::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3062:EE_|SJ0PR11MB6717:EE_
X-MS-Office365-Filtering-Correlation-Id: d767ee59-ea0d-4d3b-e946-08db366c4dda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VV5QtuVduuouNjtJMT1uPmnNi5nl3a2A56gigzmypAayOACmnIlv9dFAt413IkwXXsOCLsmkgWIJ37gq9AuHerpu71dVQZmG3L/bdPnZhjO6+bG0qx35ZUfKnJ4/YSSByUaJGuXMXgTOnbqu52qwcMZuXyK4Vc62ARXItqSerGd2sPsYdu3RH/Q+zp/JpCKVzpV8cxNeV8LNGiDdBHan0bsdtqYC5Sh86okznT4nRp4HGE2NkAgfibrAsUvFVjdlTnDwewlzSxswpYhClXPVWYGfOtzr8eN7IToSs887af2cFCS94AKmBJl008kIkgCEgp6YGG30xtFUi4jlnv9lIPcyKSdhd9e3GbW1xoEcn5Km01BG8xaJE3EdqCbbR7mMDqxZOWaIqF2iMIzHN0+6iMv3WJ3LSL6s+G7t6u6H75enBJrSrg8Jwd3rvjpLwkxHpeI4trL/15Kketjl/KFLo52JoATk+clqJu0+4gzEF3NbdSOt/p8i2q0zDtTiQ6I4Tw7uLtf46jtpMjJstryfo6xnUkqqFhhcko3vZqOIxCD1ADUFP+qKb6JGZ/UW4fTR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3062.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199021)(6506007)(66946007)(66556008)(5660300002)(66476007)(82960400001)(478600001)(38100700002)(4326008)(316002)(8936002)(41300700001)(8676002)(186003)(45080400002)(83380400001)(44832011)(6486002)(9686003)(26005)(6512007)(6916009)(1076003)(6666004)(33656002)(2906002)(33716001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p3tiRIguc5gYkDBi1YwDp/oPV49bZlId6J9ySUngLCcedioGUUGeygXe41Lu?=
 =?us-ascii?Q?TYJMCEk//qDTUhLZuur0QZ/lvimgt7NeYFwQU49lWmTcASbK8X31KV192c3q?=
 =?us-ascii?Q?aG7jHI8ywozaczFAajKMx022D9vtwMrrV/qcYbNA6uPxve1uW4OX7oEmangb?=
 =?us-ascii?Q?qWQsfh/u6moNKxn55dG2/vK3v2y95HteEWVpsVYeB3cftgxnWKvOmbpqaX/F?=
 =?us-ascii?Q?y4M2KsH1UgdRdjUGbczeDIxlkhbA95MNJY3DoHkjjvSzeuyBJ5WZxJ0BBNuP?=
 =?us-ascii?Q?zEVxURU1jiIQU+PZquyG64okIYqrHX1zqj5NzBtWUEGCRl8yOuCMit9BLPp7?=
 =?us-ascii?Q?rubS5gdH2TsAlIiVc04SVj7xg+G0lYRJrm4gFcNazy/4iA+qxnGmy/PWlcQ8?=
 =?us-ascii?Q?R0ubjXFXbl+fw4cfYixlCh6Yqcfla9ehcvLomrMWA6cTR6/VkPmM83vtJ9Kv?=
 =?us-ascii?Q?GLDQN75W7mVTCROZ78l3vaOdU3ay/1b3JGJZPZ4ewuZXf0dV4d3FGZFona7y?=
 =?us-ascii?Q?WQGIH+jPxynDuGxgmb9jbqTGX+WAk3B1xLSCPef+bo4q6PxZQjpNfTuggQQZ?=
 =?us-ascii?Q?t1go0lFFZRgFb8jaCQZ+upsSnwsufOO9TJuAqz61xcKy05N4RwUGCLCwj2Tt?=
 =?us-ascii?Q?Sf5kCOEG+pDXh7YZJiB6nj1/SyQ5D/qH1WuVskVVwB7Q0VvZXY1C/+DugmzG?=
 =?us-ascii?Q?hR2ATcmF3H6xTQbzh/0XAOW9218UQbaXsaZdGN5zC/ddiQtzo9DUllgrq7hk?=
 =?us-ascii?Q?N1Ab5JPCA1LQ4k3FPq+008QrYgUIILZz4av4TvFG+jXaFV5o0rczjF4febtL?=
 =?us-ascii?Q?zFrj6r51crciKpcJ3mS47ArP7QNnlfMyHdc9/yQrq8I918na4D12+ue67OUR?=
 =?us-ascii?Q?DuYyHmX6milZx8PaKtbe8a88ZENTXws3NXq5SJwf+mMBMddTKfvDGfHZkqGp?=
 =?us-ascii?Q?MlnK6Q9Kfu0F2alBTEFYq2yYGbRQt+q9aMGYoXZfRs8JGwCXVFQUZkIwIszl?=
 =?us-ascii?Q?XwSc1mKtwIinmii9qVICmPLzOBc665AQY/mAMnnjRLZz2hxc5pcFqWsJKRbF?=
 =?us-ascii?Q?gAmzftwIDwGiJdTyuR49SfC8oe7rj/tuMiMYNHzRf+gHXqp8yaxnsxIfs4ot?=
 =?us-ascii?Q?uIAV7WiFiasqOtH2+slP/HKQ8LwpMuVzfKVU28TUUw8FVPiegqw2Ihp9rTmP?=
 =?us-ascii?Q?FFcFvBsWVf1/e6TGOlYr/x0rOKfnGvfCodWiGoqhCZ204ieNPHiKWS9dJQ3p?=
 =?us-ascii?Q?k/cuSxMO20xmrns0Fq77zsswioSJ7dVi4P6RlUtXVCnxBnf+0JEJAJMZRqFe?=
 =?us-ascii?Q?Fd0v2lttFIL0vDJM7J8wx9reCcCPpFNpwisnL2E6b+0PCPAzkoKkYjHjnGcQ?=
 =?us-ascii?Q?D27JYzBdkoVPDo7PshsSmnCO31lV/TgTNukOqBDqjGZcBDUIuruLYDsloM7B?=
 =?us-ascii?Q?Fdpj1mB9wENeTu2lFTdrxQuoxZGREq52HOX17dnO6ZsLPlkN15dqQGbV2ryZ?=
 =?us-ascii?Q?13yOiAYPed5jSV0mYyCEsTxEczG/xDUIUVAyrF1yrEKOTH3rcbac9jDzfpoX?=
 =?us-ascii?Q?hGQ+dAWqUGn0qRWUc/kG47z917QVW/3rqMvHeJdW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d767ee59-ea0d-4d3b-e946-08db366c4dda
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3062.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 06:58:19.5248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CS7ImG7oLaYpKMA7EsjsHox/G5I4/IR3O3Oyrg4SM4QBzELaIYr/qTB0t8Z5sKpEsoLWA+N1f9W3dJFCQGOtMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6717
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

Sorry for replying a little late, it's holiday here yesterday.

On Tue, Apr 04, 2023 at 12:26:00PM -0700, Andrew Morton wrote:
> On Tue,  4 Apr 2023 23:47:16 +0800 Rongwei Wang <rongwei.wang@linux.alibaba.com> wrote:
> 
> > The si->lock must be held when deleting the si from
> > the available list.
> >
> > ...
> >
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
> 
> So we have
> 
> swap_avail_lock
> swap_info_struct.lock
> swap_cluster_info.lock
> 
> Is the ranking of these three clearly documented somewhere?
>

I see some comments in swapfile.c mentioned something related, e.g.
above the definition of swap_avail_heads, the comment mentioned
swap_lock has to be taken before si->lock and swap_avail_lock can be
taken after si->lock is held, but I'm not aware of a place documenting
these things. Documenting these things is useful information I think,
let me see if I can come up with something later.

> 
> Did you test this with lockdep fully enabled?
> 
> 
> I'm thinking that Aaron's a2468cc9bfdff ("swap: choose swap device
> according to numa node") is the appropriate Fixes: target - do you
> agree?

It doesn't appear to be the case. For one thing, the problematic code
that removes the swap device from the avail list without acquiring
si->lock was there before my commit and my commit didn't change that
behaviour. For another, I wanted to see if the problem is still there
without my commit(just to make sure).

I followed Rongwei's description and used stress-ng/swap test together
with some test progs that does memory allocation then MADVISE(pageout)
in a loop to reproduce this problem and I can also see the warning like
below using Linus' master branch as of today, I believe this is the
problem Rongwei described:

[ 1914.518786] ------------[ cut here ]------------
[ 1914.519049] swap_info 9 in list but !SWP_WRITEOK
[ 1914.519274] WARNING: CPU: 14 PID: 14307 at mm/swapfile.c:1085 get_swap_pages+0x3b3/0x440
[ 1914.519660] Modules linked in:
[ 1914.519811] CPU: 14 PID: 14307 Comm: swap Tainted: G        W          6.3.0-rc5-00032-g99ddf2254feb #5
[ 1914.520238] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc36 04/01/2014
[ 1914.520641] RIP: 0010:get_swap_pages+0x3b3/0x440
[ 1914.520860] Code: 48 8b 4c 24 30 48 c1 e0 3a 4c 09 e0 48 89 01 e8 43 79 96 00 e9 b2 fd ff ff 41 0f be 77 48 48 c7 c78
[ 1914.521709] RSP: 0018:ffffc9000ba0f838 EFLAGS: 00010282
[ 1914.521950] RAX: 0000000000000000 RBX: ffff888154411400 RCX: 0000000000000000
[ 1914.522273] RDX: 0000000000000004 RSI: ffffffff824035cb RDI: 0000000000000001
[ 1914.522601] RBP: ffff888100d95f68 R08: 0000000000000001 R09: 0000000000000003
[ 1914.522926] R10: ffffffff82a7a420 R11: ffffffff82a7a420 R12: 0000000000000350
[ 1914.523249] R13: ffff888100d95da8 R14: ffff888100d95f50 R15: ffff888100d95c00
[ 1914.523576] FS:  00007f23abea2600(0000) GS:ffff88823b600000(0000) knlGS:0000000000000000
[ 1914.523942] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1914.524206] CR2: 00007f23abbff000 CR3: 0000000104b86004 CR4: 0000000000770ee0
[ 1914.524534] PKRU: 55555554
[ 1914.524661] Call Trace:
[ 1914.524782]  <TASK>
[ 1914.524889]  folio_alloc_swap+0xde/0x230
[ 1914.525076]  add_to_swap+0x36/0xb0
[ 1914.525242]  shrink_folio_list+0x9ab/0xef0
[ 1914.525445]  reclaim_folio_list+0x70/0x130
[ 1914.525644]  reclaim_pages+0x9c/0x1c0
[ 1914.525819]  madvise_cold_or_pageout_pte_range+0x79f/0xc80
[ 1914.526073]  walk_pgd_range+0x4d8/0x940
[ 1914.526255]  ? mt_find+0x15b/0x490
[ 1914.526426]  __walk_page_range+0x211/0x230
[ 1914.526619]  walk_page_range+0x17a/0x1e0
[ 1914.526807]  madvise_pageout+0xef/0x250

And when I reverted my commit on the same branch(needs some manual edits),
the problem is still there.

Another thing is, I noticed Rongwei mentioned "This problem exists in
versions after stable 5.10.y." in the changelog while my commit entered
mainline in v4.14.

So either this problem is always there, i.e. earlier than my commit; or
this problem is indeed only there after v5.10, then it should be something
else that triggered it. My qemu refuses to boot v4.14 kernel so I can
not verify the former yet.
