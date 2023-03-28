Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED946CB441
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 04:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjC1Cql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 22:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjC1Cqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 22:46:40 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA26819B2;
        Mon, 27 Mar 2023 19:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679971599; x=1711507599;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=omdSkVXlZ2/keu6QMskELpSLGHvhp8XFJc8UzBVr0kA=;
  b=V59BRnB+8XlBCnaT1xYVUsaFnobVq3Xgq6+AyTKLwcgl0MvXHCSVb70w
   G/vcyh0n81Chq3VdzE0qAcP4PwXFeqK4KzSwoMcljY0zicRPwtLrAsJQg
   xAqZi6k/GmVEA1znEGI4ncKlH6EW2nD07k/IBHXPe7a0o2QKsAwq2e2bj
   LR75iLU2tajMKa1W+GzFUA/Wrr8fI9d17Ox6ecs/dAZI8e7ZByzS/nAvj
   ZpiWieSY9tAoihzoou2tbjk1871WAuZ1HcTFDI8RneLUMTjyI/Nd/Xu3m
   HmepkwUIQufTWNIOtFEOFflVSnCOwslcvVY6RxoIDjD/ssqNclr2IVSR0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="320853099"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="320853099"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 19:46:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="1013364693"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="1013364693"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 27 Mar 2023 19:46:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 19:46:37 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 19:46:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 19:46:37 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 19:46:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6GTNBkZkctfAT7dT1dAKxwFSLfxuOLzw0iBOB+pvyn4pc2EkeI75YjAmFe0aNmjoloiO+aPKYmD6qFq1ssVIxR9hDGRMM9fllh7uEid0IAuXWo1thF9p9EwOfAtQu/58ndsPbz3M50A/tZu6KKOHS8pru9a9hj/04Hbk37XfbtJptyp/JZWvb1YWohkdXuownVTsOFZ3dicSE8wqr1c9Fr9/WcQbhf9qGZSfdKkyMseqlwHEiFCzvk+zpjwr6spcDD+iaonrL7XW/TDDkO3izN3bKrrJpXcvMGJD0g5Esyzp5aSCESEiuFQ9zJakEk5DeeWobF+CjpmH/HNGnP++Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJvDew3xIC7c2HSmHYmoP9yR/z2qn7dh3f4Mtr3Gc1U=;
 b=jlIGGQtVFJluhqk/JbtMg9j9JB37mm47ZnhvnayE/L0Tw/Y5MSt0nedfx0OfrGHxzPnNh3bX8esFziQwI1Z7n56JQEr2hOPSGPeGy/IoXWol5S59RiRMv2qvsq9MLfdUblHj24lwLOnEcN8iAvxsclwyfOZ85hEx93imsVWh3m5lMLl+QAOcPPpr1GzOoqM9CJ5Xc0ETi0Czhx7CZvxsgymu7vtUr67Nm/IXQg7O19SaoIHLOYmU/DIg5SFDUXhJEtMVaWC3+NJC+GKXBqdca8v4zl14SiQbRudqqZKCKjUZdS5JndYaA4xIzGOAIn+AfEfZOuScGf6avYdxrVbE+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
 by BL1PR11MB5368.namprd11.prod.outlook.com (2603:10b6:208:311::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 02:46:34 +0000
Received: from PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239]) by PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239%6]) with mapi id 15.20.6222.030; Tue, 28 Mar 2023
 02:46:34 +0000
Date:   Tue, 28 Mar 2023 10:48:06 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <heng.su@intel.com>, <lkp@intel.com>
Subject: Re: [Syzkaller & bisect] There is "io_poll_remove_entries" NULL
 pointer BUG in v6.3-rc4 kernel
Message-ID: <ZCJVZk4nfosZzA1k@xpf.sh.intel.com>
References: <ZCEy5jA2nT/vaO56@xpf.sh.intel.com>
 <d6818b66-e1c8-e2bf-e54f-73d1f83db020@kernel.dk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d6818b66-e1c8-e2bf-e54f-73d1f83db020@kernel.dk>
X-ClientProxiedBy: SG2PR06CA0195.apcprd06.prod.outlook.com (2603:1096:4:1::27)
 To PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4839:EE_|BL1PR11MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: d3f7cbb0-da13-4f29-e40c-08db2f36a4d4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tR8o6PUD3EresCYs30NDxZCESHc7p3dYZAK5NV/8ic0dPj+LO/q4FpgtX2xzyDo/bNXgvL8WYpkkMhHKWK0CYuVhh3qbQkDB2RVaHs5pt5vTqMgHrS4bQJfGCRl67OikJqyMwHaCqfwEvG8Uv6Pj0nDZA/bvF+tBawN2g/dB4vra+JmIRWkmgj45SCF0tkWWtwqxXr5pqlWHYASgM+i6NvzLk4a+69XawTRsHVwmwVS1KuTJ88mmzAWlYNPW5n38lkIx9Z/oBiJIX4Z/fRzpcep3D8z6VbDTPcamPXSiIIY7V9dDtGChMFXe7GDObuby3534R5nLrZeKlzR2gWVKXJMEXO3rqseXGG7fAstfYK8xN2pC709WZ8mppDCZHhBLbGPoD/yXLRVm2Bap2ElB4fRhwXIWyIVSEAc0M6SgcfgzqcVSEtMCLud6s8iAQEjzSMG6ah2FRbrkrwTMzKs4yWv1zOR7c6fehxHIYdhNW62BXMSwnFchzV7L1oiwtcWUA7NeqYka1y046yd6752WiScluguhpS6D/zpz9E9UMGcfRkYVLGoH5c/NbfUMidtnY4QQKR5CrkSjhYyHdPWf0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4839.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199021)(83380400001)(38100700002)(186003)(2906002)(26005)(6506007)(6512007)(53546011)(44832011)(66946007)(66556008)(66476007)(82960400001)(6916009)(4326008)(8676002)(5660300002)(8936002)(86362001)(107886003)(41300700001)(6666004)(6486002)(966005)(316002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4HB4Y/GZXnqoiv4tQEw/tl7Hx6eh5fIZbdV7GBL0SpGIE559eFHl6/0sQVpB?=
 =?us-ascii?Q?SymqGMwXAyNVdzCyDjT7T5466YUFuvygYPzHwiEEk0mTGUgxKMXpZtD/qDQF?=
 =?us-ascii?Q?Oe3CukfV/Lx1QW2Lm73hPr+wesD332oUhK2QrK2iyVfxvVgZhdx1VwbxLTvt?=
 =?us-ascii?Q?pgceRNrLeG7SNpWJCDviw2T3b2/57IVZqk//bRdUcsUqwlKGEGAxIje+Mi2w?=
 =?us-ascii?Q?nzs8nooPUDaF+ywAaqEjulcbY5WoI3M80R0ZlLYL6O8xrWdbZhow1d6Ne8jX?=
 =?us-ascii?Q?7lGUpKy0ybbEBqPCLw5lOWhDQ5ACPIVv5RRRbvtK/sT81Qvd83dbvwWlB9KH?=
 =?us-ascii?Q?1kD2j/InFJ3+pVZ5IUELH014HiPFZYLFY3gzP59OXzN/K8aWlKKlWZLmo3Yt?=
 =?us-ascii?Q?FA1uMp4Hvg8fsmYsFXV4kMsH1I59xFOLRkFiULLkBuFJHnEdZGJWbZS6riX4?=
 =?us-ascii?Q?9G4pog1pNlFSX1OF/BG/MFTW/PYcGnctVurx2YwwKkADOEd9WeIMAlK7abVd?=
 =?us-ascii?Q?uXbZFRu84ZZz1LIqvw+wxNnjgROZDKEzc7EpQ8E0UAg1tP6hxNsOpESltjRO?=
 =?us-ascii?Q?V2dOZt/FOSVTJtHqD7ccZxdaz4X77V6bJHlK0lv0yXV+/dbVnQ2yHmomVJxm?=
 =?us-ascii?Q?F2JyCExmu9Y9utIDqJMVQ6GsO1uejxJgNQv3Ds81xHbQJyTOySTbRIbOCTxQ?=
 =?us-ascii?Q?hy5vmhdQjAOuIKZ7aPDuLyEtBpFbOp/tsRcJjL0SuE3sUjXavkG0T/o1CozB?=
 =?us-ascii?Q?tuwEq7vAC2fyuSY1HiVlXayh8rrixZBX3MokkNyhMxlpSrVJXNl8A1hlW10Q?=
 =?us-ascii?Q?3r/NGTUiyKF13zI4FTnTvQxmK/X7yx8YC/r5/TYzTgOxHVTIkKGjXeAe1k5Y?=
 =?us-ascii?Q?j7K2RAWB7MKWVGDLfwotxPByl6qnUD3EG+jl6gcSi7d6mx2fflV0NmANkGi6?=
 =?us-ascii?Q?+OY5ylBlp7cXKRFOaByJjkFMRssdJt8BiwNh02tjiyVxfDJFo3l6lE5yDrd3?=
 =?us-ascii?Q?qfQywlDbZ5bFs5OFBoxCu/vkkWaiALSAgaRdCveUlvGVaN9rTLXRR2IjcDBn?=
 =?us-ascii?Q?YLF/ZF+tgwUfRV1aobgHfuNqAWVk4Gz+Pe/DlOvJGX6bAoPcEukvbwr7NUfB?=
 =?us-ascii?Q?An3jhzejjN4mLeP0DfrOVDNi1PvKu7yq21bIn/rWns8pIn660fvfp+9wS/Ek?=
 =?us-ascii?Q?B/1ls2Kb+WBqgRTgUhWKlqbmn9g6r2ifGvC+HDuOq0CYPWa2qra8GooezhR1?=
 =?us-ascii?Q?01Qda6kmAelU8T+65xpdrXa5IbKZ9nZF5h7ngYNsYo7BO8LUzcxSzkOsZXFv?=
 =?us-ascii?Q?2WqvmUpQnj1AtDjZd5NHLpIHzDRtMHuipmdmGYAn68ydJu/hhpS0NHjj/rjd?=
 =?us-ascii?Q?ITXM1aZllxeuU8SEDmbdpnckq3+bEh+jnrzHF/YrH6w+XgkC1PYWHVVlfQdm?=
 =?us-ascii?Q?UWeHz3jVDqFxQ5TCV6sudJi/3pgdBaa8s/vCAvuQYsMirlAwfpBW/ulGZbKI?=
 =?us-ascii?Q?j/BTYNSHq10g8snjsfHTYAFdDm+u00Id6CDuwDTGNCMnz5s68D+fXZW8WK1Y?=
 =?us-ascii?Q?4Qpmrd+PWdqZSJTzRi9j5bsqSkQJUZc7s/Ztwnsr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f7cbb0-da13-4f29-e40c-08db2f36a4d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4839.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 02:46:34.4508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NabBJ2jsl+LFdXDWijnNWhP6VZG+WSaLkmBbGlx0NjmOFLVFv+ma0FuxMv+urLxnbuVpRsGeGfjcqEk5c1a5ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5368
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens Axboe,

On 2023-03-27 at 07:35:59 -0600, Jens Axboe wrote:
> On 3/27/23 12:08?AM, Pengfei Xu wrote:
> > Hi Jens Axboe and kernel experts,
> > 
> > Platform: x86 platforms
> > There is "io_poll_remove_entries" NULL pointer BUG in v6.3-rc4 kernel.
> > 
> > All detailed log: https://github.com/xupengfe/syzkaller_logs/tree/main/230327_041425_io_poll_remove_entries
> > Syzkaller reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/repro.c
> > Syzkaller analysis report0: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/report0
> > Syzkaller analysis status: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/repro.stats
> > v6.3-rc4 issue dmesg: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/v63rc4_reproduce_dmesg.log
> > Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/kconfig_origin
> > Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/bisect_info.log
> > 
> > It could be reproduced in v6.3-rc3 and v6.3-rc4 kernel, and bisected between
> > v6.3-rc3 and v5.11 kernel, bad commit was:
> > "
> > c16bda37594f83147b167d381d54c010024efecf
> > io_uring/poll: allow some retries for poll triggering spuriously
> > "
> > After reverted above commit on top of v6.3-rc3 kernel, this issue was gone.
> 
> This should probably fix it, though I do wonder why this can only
> trigger after that patch. Seems like it would've been possible before
> too.
> 
> 
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 795facbd0e9f..90555a22a900 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -600,7 +600,8 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>  	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
>  
>  	if (unlikely(ipt->error || !ipt->nr_entries)) {
> -		io_poll_remove_entries(req);
> +		if (ipt->nr_entries)
> +			io_poll_remove_entries(req);
>  
>  		if (!io_poll_can_finish_inline(req, ipt)) {
>  			io_poll_mark_cancelled(req);
> 
  Thanks for your fixed patch in short time!

  After receiving this email, I saw one of your newly improved fixed patch.
  I will verify the new one soon.

  Thanks!
  BR.
  -Pengfei

> -- 
> Jens Axboe
> 
