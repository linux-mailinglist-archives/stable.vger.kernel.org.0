Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1307E69890D
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 01:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBPAGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 19:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBPAGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 19:06:21 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F001830EA0;
        Wed, 15 Feb 2023 16:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676505979; x=1708041979;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FoFMouxnRK7WZqF3f0YODy5oEXK91nJLpYsB/OFppsE=;
  b=Wka98bG88iLskyK8XopaSGSalWGF4by28gQYxhY9JymSdaAcBaut0ktj
   XPpA8JBXpaIjzzm7lxUZrtTeABPxrBrjngYaKdGrThfWoHGwRFZ3oDC9+
   /P56Lp4xIHx9pv2ccvAQlvENXXow61eykJSron+OBYR8axVdGTQzXQatn
   4DbjjxyustP5ZKU3A2KYK0ln6xXeTpEzJmLpMJ/jM/nfit9CLBHxkksmN
   O01RrbTFvuDMNRRtHwP40g5EOJKVIlI6M/smLleS50LKVey3f+nluNEZs
   Izcft7ev0++bEopl05BSDLLblUa+A01322ddXa7/BGqWZOjuLcIILZp8b
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="396213996"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="396213996"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 16:06:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="843925297"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="843925297"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 15 Feb 2023 16:06:18 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 16:06:17 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 16:06:17 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 16:06:17 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 16:06:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAIgQh1M64GCOFlTYZVk7rX4+VQ8vIfkqKjcNcQhhu3WOw+w5biTXWEUmz13wUzQL9d0uRBiQlfNQIoisIJ+aO+nSzrM8m9Vg9tMIEmchhYTGatim43TV+YT3xD4LQ5IIZjLYMZBNyFdn3dKjORTsyL7r2YPTuls1iVJwc9stmouIaHCDXs8wDbBRH+Mfw8QbxLGf1G41Qj8yEIXKjzS/lgIDiUfXPeafAL92jDfidDIfpsT5STdxPTonMR/gQx5EZxAbI4r55eZNif3ETzmZEQkdEIVewPof9zepYYS3DqJ71a8v0MIhebICuSQM5bFjYgVrcME63kqUp52NmObag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYrdISk8L0LH34713V2VSVAdwYLVfdh1qBxDZeF3o0E=;
 b=keuIOJl+Fil/TIs5JKJM7isnZoQ931tZdRSe3RZnw1e6RPFGODLXI3a3Ni8oyIxS6PSFDyOhO5+lTgkmygewMXkDVXQofhJ+ScgGLabr1ElLGsRjcQjPPKmQIr1eEwr9VhVyuE8qdzrDmzSeg49ajsKr42+0cT3ps7CMfRoYx38SG2n0cAHVi2H6IQxOeHxBwk7cuxb0BkpG+5lgM22eIYgI9q04pBozCGzo2CmZyCThGvJlWaKXspTEKiFIIhEQenQXcKnDoqSRaRMAw/z8Py1xkdhP2x4SR8QhTUZH3qC+xbVdrxjaTmBoqvkmviVdS5YNBEoGLYjL+VtnY+c4ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA1PR11MB5777.namprd11.prod.outlook.com (2603:10b6:806:23d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Thu, 16 Feb
 2023 00:06:15 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff%6]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 00:06:14 +0000
Date:   Wed, 15 Feb 2023 16:06:11 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        <linux-cxl@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] cxl/pmem: Fix nvdimm registration races
Message-ID: <63ed7373900fe_19cbb72948e@iweiny-mobl.notmuch>
References: <167641090468.954904.2931923185712477447.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <167641090468.954904.2931923185712477447.stgit@dwillia2-xfh.jf.intel.com>
X-ClientProxiedBy: MW4PR03CA0214.namprd03.prod.outlook.com
 (2603:10b6:303:b9::9) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA1PR11MB5777:EE_
X-MS-Office365-Filtering-Correlation-Id: c19045dc-76be-4e03-f222-08db0fb19e7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6KY0tFAb7P+SoB8dygVAdvM4UaCWhSyK9X0p2DpjZFMBwkFM0HL2Cwzo8PkGsxuVm7Xzd9VX8MlZNflLTC7qvrXk0M946luqc2JWqW/LZN1GGT5Y7b6FYz7B0E/nQRzgjz4PVFlObcX9l3khiDRkPVSagXyain76a5TiDxunPbxArZsK/3bS+smjZnLO8Zz906093xKNewKiUQW/ImXB/b2bNjl4wbksE4R7/Me7O7TmeZxYB1H7FOrlQ7YM3AU+yyT3Zs1Lm9Tou4TLEX03REic2Bx/42WAkVMBdKXagCyrDcSwc7Zp5dyge9Ct6ytS0/2q7T8qlNYb7bCenNwXaIuBgoteQO5C4Jcf5yHQPc2kfPTYCQ5h78h+vWSgwssOsFZHaE66aJb6+tgDqxfU2w502T6MC+CBYAvv9I8ZVROudpVEo/DG8HBic6+1niaadkPhdYJA3xzP/gKuHQVf3HYIxhCHgGQrpCpCLDupMwmJQFw56Z8OXWeFgBm/9m7lV9Va++8xqDLbogApx4Py8QNou0EUP1gMzmEM2s/OhNdCjqxucid6hwDQx2XIPmnxWVF7WzBcERcWz5utbZCJCEXEYA3tL2yPKcXG+o+kz52EXry5cqZBZKh3YKbBIZURX6kgVxELYt7wY4DJB58DFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(366004)(39860400002)(346002)(136003)(451199018)(2906002)(44832011)(186003)(6512007)(26005)(9686003)(5660300002)(8936002)(4326008)(8676002)(41300700001)(82960400001)(6506007)(38100700002)(86362001)(66476007)(66946007)(66556008)(6666004)(6486002)(83380400001)(316002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mV7KovpsAtvB0QkN/cwlNncRTDX/bFrn93EeeT57dbsGbE4vlLMvBPOe57Ax?=
 =?us-ascii?Q?zaavd9HSHS+b7JlRIZFgRmJ402jVS5lk/6CAsv/4QroeEErQ1HWDRaTii5uc?=
 =?us-ascii?Q?7gLiPPqbpCEecq0GgLE3g+TPzROyYADvGfVAxfpqghhjvVQE1pflHWx0Qgnq?=
 =?us-ascii?Q?UFgl2dvfnkADapohgTDTCbm9vSloJsU6yotv6lMV0LrT4hN258hnCrSv52dw?=
 =?us-ascii?Q?4gsLlhKEZZQ0y7lqO6NR+TWk/7hI99koPN8Hz2XD+kBqmCsei6CqM67XKtGG?=
 =?us-ascii?Q?hn1J3z6pIIy8B7faX9fR7LEKlHcHQMSHbqkW5bSYIM731q7Gy8QEbLBJjINI?=
 =?us-ascii?Q?aLts8IoATcJffjGR+rW1Nvgu4M87/8i5S3X3c2LI8Ig6n41CtOpN+KxOU2fy?=
 =?us-ascii?Q?GermXn29ekn4hEJYgBAEw3zXXxtJU8BEthdAsDq6TwmtEf12Cd5WePYPxjxD?=
 =?us-ascii?Q?LpLqAi2UWQd/tpkC1wR1tFMV5gAmVj/y+Ku+n/VMnIpCfjdnazt04olugMZs?=
 =?us-ascii?Q?CxlBFd9nV4khg++1r9IDwOLo8FCeiSUzDO5koO+pfwb1KIjuKD0QV6QWFbXa?=
 =?us-ascii?Q?iO46dhp64ukp53o8TBC8dx20ALJiK8/9QNp3J6H5czDuvJ1G3AXdhmUA8Y3E?=
 =?us-ascii?Q?bXwgenOJBHyyXnTP+pJPTy2PB30E8JuANwoXIDvzPje0Kq/JG+AECBqb9Eje?=
 =?us-ascii?Q?9YW/Dv+0Z4oqXkRrC52JVYccd9EECK3rB2zjlpXLLUcP0kmZs2pn6HjXTD75?=
 =?us-ascii?Q?5XfMZvr8s3Wholvx0Lj1B9PQabVRwIQ4hY3DBqRfmC1hFIl++c4Njqvf8PY8?=
 =?us-ascii?Q?fvEJuPfQyo3vOmgZZGxviPxXKk0seBVodXCl4M1+xJEGa1NbBJ9yWdV1z6fH?=
 =?us-ascii?Q?ymoYFIRdCYD80iK8UYEBHtDtJnniwv5lfzYcfqm/q21xkSG6dq753vKpjA/r?=
 =?us-ascii?Q?JHoTWdg7IAyMppVg6jGXRrpJSoi4e5xEr14TpyN0B0GdKcqi7bgsmnG4v5av?=
 =?us-ascii?Q?4yj2ZV+v/4bRIuaeba8ED5Y/kdLJbZwYGT7kLb24mlYn1LivZ//He+Gh5I95?=
 =?us-ascii?Q?9EluA/IwheAo7bihwUXHzGOR2jgWAjSDysYNKb3GIsE5tpT8gaCSHBigLVg/?=
 =?us-ascii?Q?K9NQpIz75sP2e7i8RR9es2GQKu7RncoC5Q182Vn8kus1346UC24lY3vfY3/t?=
 =?us-ascii?Q?NzsGyx5tTZgHyEcFXFO18vJ/i3oU7uU0k9Oi5Tqm+ueTGrp1tj8zWLpgo85P?=
 =?us-ascii?Q?p1PrXi+2jAjPAF0l1GDxtAuRmddXtJ1cZK6osaQg4+XDz5u4hD5grtZCKp1s?=
 =?us-ascii?Q?CQW1+9Tz30hyP0gyVCZAulWUQOnKpQCSkHqhY4kAGLDz78YD15Tqgjz8o+rp?=
 =?us-ascii?Q?VI/1likcIZs+s7kPhl/7fh1nWCyltdVPe/cR7ukTsGv3wkbqdBr9zCZwmtdx?=
 =?us-ascii?Q?uT6fccVNlBXkyMJhMmISbBBs4KOhSA/YsEZJ3GEIyU8XxHFhisO22acvfhZw?=
 =?us-ascii?Q?KcjVR1ucKwxfC225bymkH4Kz6XyHYaebCf3SjD7BChUmFoJZ79tQ9lD4iteY?=
 =?us-ascii?Q?DBg7l30pbBTnaeWXIVnvIBXuggvDsunTCziZSR+E5h0YDAiYVSi2NX5lPXSf?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c19045dc-76be-4e03-f222-08db0fb19e7f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 00:06:14.8058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yiqowtncr8XVhMT5qybwLb1u8On52doZPudYFrLyhplFIkStWHHKpElDmP952X7pIvc7035QXia8SVcVtYsyeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5777
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dan Williams wrote:
> A loop of the form:
> 
>     while true; do modprobe cxl_pci; modprobe -r cxl_pci; done
> 
> ...fails with the following crash signature:
> 
>     BUG: kernel NULL pointer dereference, address: 0000000000000040
>     [..]
>     RIP: 0010:cxl_internal_send_cmd+0x5/0xb0 [cxl_core]
>     [..]
>     Call Trace:
>      <TASK>
>      cxl_pmem_ctl+0x121/0x240 [cxl_pmem]
>      nvdimm_get_config_data+0xd6/0x1a0 [libnvdimm]
>      nd_label_data_init+0x135/0x7e0 [libnvdimm]
>      nvdimm_probe+0xd6/0x1c0 [libnvdimm]
>      nvdimm_bus_probe+0x7a/0x1e0 [libnvdimm]
>      really_probe+0xde/0x380
>      __driver_probe_device+0x78/0x170
>      driver_probe_device+0x1f/0x90
>      __device_attach_driver+0x85/0x110
>      bus_for_each_drv+0x7d/0xc0
>      __device_attach+0xb4/0x1e0
>      bus_probe_device+0x9f/0xc0
>      device_add+0x445/0x9c0
>      nd_async_device_register+0xe/0x40 [libnvdimm]
>      async_run_entry_fn+0x30/0x130
> 
> ...namely that the bottom half of async nvdimm device registration runs
> after cxlmd_release_nvdimm() has already torn down the context that
> cxl_pmem_ctl() needs. Unlike the ACPI NFIT case that benefits from
> launching multiple nvdimm device registrations in parallel from those
> listed in the table, CXL is already marked PROBE_PREFER_ASYNCHRONOUS. So
> provide for a synchronous registration path to preclude this scenario.
> 
> Fixes: 21083f51521f ("cxl/pmem: Register 'pmem' / cxl_nvdimm devices")
> Cc: <stable@vger.kernel.org>
> Reported-by: Dave Jiang <dave.jiang@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Tested-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/pmem.c         |    1 +
>  drivers/nvdimm/bus.c       |   19 ++++++++++++++++---
>  drivers/nvdimm/dimm_devs.c |    5 ++++-
>  drivers/nvdimm/nd-core.h   |    1 +
>  include/linux/libnvdimm.h  |    3 +++
>  5 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 08bbbac9a6d0..71cfa1fdf902 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -76,6 +76,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>  		return rc;
>  
>  	set_bit(NDD_LABELING, &flags);
> +	set_bit(NDD_REGISTER_SYNC, &flags);
>  	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
>  	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
>  	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index b38d0355b0ac..5ad49056921b 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -508,7 +508,7 @@ static void nd_async_device_unregister(void *d, async_cookie_t cookie)
>  	put_device(dev);
>  }
>  
> -void nd_device_register(struct device *dev)
> +static void __nd_device_register(struct device *dev, bool sync)
>  {
>  	if (!dev)
>  		return;
> @@ -531,11 +531,24 @@ void nd_device_register(struct device *dev)
>  	}
>  	get_device(dev);
>  
> -	async_schedule_dev_domain(nd_async_device_register, dev,
> -				  &nd_async_domain);
> +	if (sync)
> +		nd_async_device_register(dev, 0);
> +	else
> +		async_schedule_dev_domain(nd_async_device_register, dev,
> +					  &nd_async_domain);
> +}
> +
> +void nd_device_register(struct device *dev)
> +{
> +	__nd_device_register(dev, false);
>  }
>  EXPORT_SYMBOL(nd_device_register);
>  
> +void nd_device_register_sync(struct device *dev)
> +{
> +	__nd_device_register(dev, true);
> +}
> +
>  void nd_device_unregister(struct device *dev, enum nd_async_mode mode)
>  {
>  	bool killed;
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 1fc081dcf631..6d3b03a9fa02 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -624,7 +624,10 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
>  	nvdimm->sec.ext_flags = nvdimm_security_flags(nvdimm, NVDIMM_MASTER);
>  	device_initialize(dev);
>  	lockdep_set_class(&dev->mutex, &nvdimm_key);
> -	nd_device_register(dev);
> +	if (test_bit(NDD_REGISTER_SYNC, &flags))
> +		nd_device_register_sync(dev);
> +	else
> +		nd_device_register(dev);
>  
>  	return nvdimm;
>  }
> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> index cc86ee09d7c0..845408f10655 100644
> --- a/drivers/nvdimm/nd-core.h
> +++ b/drivers/nvdimm/nd-core.h
> @@ -107,6 +107,7 @@ int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
>  void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
>  void nd_synchronize(void);
>  void nd_device_register(struct device *dev);
> +void nd_device_register_sync(struct device *dev);
>  struct nd_label_id;
>  char *nd_label_gen_id(struct nd_label_id *label_id, const uuid_t *uuid,
>  		      u32 flags);
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index af38252ad704..e772aae71843 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -41,6 +41,9 @@ enum {
>  	 */
>  	NDD_INCOHERENT = 7,
>  
> +	/* dimm provider wants synchronous registration by __nvdimm_create() */
> +	NDD_REGISTER_SYNC = 8,
> +
>  	/* need to set a limit somewhere, but yes, this is likely overkill */
>  	ND_IOCTL_MAX_BUFLEN = SZ_4M,
>  	ND_CMD_MAX_ELEM = 5,
> 
> 


