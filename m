Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA21485796
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 18:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242490AbiAERpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 12:45:49 -0500
Received: from mail-co1nam11on2060.outbound.protection.outlook.com ([40.107.220.60]:43553
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242486AbiAERpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jan 2022 12:45:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTrtVuDwjbAyMpuACZZzqVKbRTW3n3LeQy0zbKUYnZM551rUXSoyKfP9ZDxfvtf+1EJcqbK7Bvqe55bVli9uvMODcTKacTgNPCLi9USQFjJE7PKkngeLhKvfaGLC3s0RZ3Y6NsAsDUp3Gn7tSY43EE64q8FL+YtKmJ/zngpJbROzKF3kulgRWRBXnX/DqN2b3wILVKS8HaDh90jAL2mZdNNfPSwzADit0XOmdf9vcIt1okFAadVQNLY8pY0H1+3safrLZl7LqtetjR/PouqmJVg0OvALGVKlRkoiu7cQr3ikJhLlGx0ieGw0fMOsLkBmnfPLiAptJCeWi/zQtiSuBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5dcvXbTcxL8jOQTkwJ8LWXm8yR8M+Dm4mbINJWh7kM=;
 b=W72DEWsDnQnv9V9DxI5e63iiEMD9ShgzDW8LiGvsSlICY8Pqin1NWRD7qWmmtQ8Wlw9mrXdFKwBtFsrLeb0RGJR011TFpoMqx8sUgVNT36FJmT37HtD4x2gODaJEx+701pFTI83xhDLwu+COUMXFxXEAZ3811cQhel6IkXdR7ui56msF4tWg34wkIOTRNcXYE4TlW2oSnMNe7HRmg8RcGRA01O2dhZOF3QJUfEh1omnV4B4dSux15W7xwAm2UOwsU1I83k/K9Ck9b5h3CtalwcrbgrNeio17P8y4X5q49DkkEt5snT1PDLq9SVZBI467rY9YWEF/a6GumAuJLiZdgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5dcvXbTcxL8jOQTkwJ8LWXm8yR8M+Dm4mbINJWh7kM=;
 b=gZ1AzjJtFfuCwmLPANkrUGJDyLTdG6yAMsHmqOGascmgkMNI/a6D3l9TvVsIhzr1m+0Hqi3WHcuWjkpQqxWcc6Bc6VcG9rGnUbJrHpKBLvAayFIXLgApLglrvcboHKYbSlylxkTU8+NsLmqTvZF74PYbfivK8jEcFBEvYQ1HCtHjmm795SOQ6I0Kob6kNpVi3wIFzZ9EN0KQwhqtt2QYwsbMKxhHLj+cpyS3mAqd8nbzHmz022WInC7+Ceg0hX56wmICNJRP8O2SOaU8fGHZo24FSChglOiR9c/sfWcYvSETVGqMmSlE5bwcjm8qVGUmV5QmZIFgJ3p5xw4onXtbDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 5 Jan
 2022 17:45:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 17:45:47 +0000
Date:   Wed, 5 Jan 2022 13:45:45 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for-rc] IB/hfi1: Insure preempt is held across
 smp_processor_id
Message-ID: <20220105174545.GA2812462@nvidia.com>
References: <20211213141119.177982.15684.stgit@awfm-01.cornelisnetworks.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213141119.177982.15684.stgit@awfm-01.cornelisnetworks.com>
X-ClientProxiedBy: YT1PR01CA0105.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5737437-51d5-4eb1-6da7-08d9d0733489
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB51765C9208CC3F2BD6332B73C24B9@BL1PR12MB5176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gv3UbgXhE7TAh535ZJZv7X9afn0oI1+wRosXtiDfvWMOzJIJwWmmYJye4vlF5r9eGV1OebFQQ5fkNNYf36eOwIhIovd8ISyqDr286g/s1/4WJs0Z6Qw0ryUROPYxEEzsc+fYQ/HWNdqcwSlCaR30kqhRHMWfxXXwGcTe13KPbSVuyc2hVBnEi7NYJwjG247baGwWP7XUSHeVERJ8uwqZ/YTNy06Pjsq3npdi6LgxItq+fHmAsoNP6ktRxAEziDkKMF0O/qCNaJUUWdL2mvUyuEyz6xApdKJpuiW0clhrK+AlTo4+gg7Zjfs1/cvgv/S5R0S7ttjkxFErR6luwveGnceFWhkSilwff529e8HwmUljcrYlJlqafG7exoh4ZBabCzdl+HsBTMSWX14p963+llYWnj3ZUmVEEB98/F6NYmZEC2TJFp7fSwqXGYLiHsUyC/6PzEt9GXBIjaUTPAfnC7M+YxaWsKXDaOiFX0ZSsT1YVsWbaWR8OAY3qzehnExKhOT+fMJgxy5V904vC1Ol9AQPc3uaEz6L8x6PXQBc7UL9C2ablsUI7pz27BzvcM6c4xH0Bn2lbeD/9aVJhBOHlAPOBcdxdShClXNR34eou460EJnzqfqu68IqioxQKzmxCpQdsWOqmGdWnYtjIjVfwnrPNpawSeVWwfznhqZn9e1gvVRvXKFPUYv0hrVKmAezkOHL1/19jcqc7MWKC8zl6Cim4v+9n40Pgd9JT3RlD8U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(966005)(26005)(6512007)(1076003)(8936002)(2616005)(8676002)(186003)(508600001)(66946007)(66556008)(66476007)(316002)(6486002)(2906002)(5660300002)(6916009)(6506007)(36756003)(33656002)(38100700002)(86362001)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?icOQOnzPGzUGvSIAO7jSpvbOI6/Tz5QZwHVsh01Qz2JX1M+qwOGCXbsHy1//?=
 =?us-ascii?Q?FhNxbizO2qqGjlu1KKp9aX06EmcJC7RIPhGk8Q3s7nTrmzvJGiOPp4pCw06r?=
 =?us-ascii?Q?ycAzJugwE2exvbnYRfxLNkLs4qGey6qtx5eeyY1sIOYQDGKjvP+xOsFyRBpE?=
 =?us-ascii?Q?DOz5mUetM2+bPSl3HB3mSSCg5RogfLweT2EzYEdmvX5aHUawKYbvaJspoYjn?=
 =?us-ascii?Q?KL4OqbkGVZfemE08BzOrX6utYPeNRQrf+eiEM5x/7CyD/Of925bOHXM3GBu+?=
 =?us-ascii?Q?i26gIYY80BiTCquRxNnD2/kZ+IDxO8F/WjvdhkHBYh+T7dFnAGjHkRdWiSvE?=
 =?us-ascii?Q?k6ubwt6i4iqRxM6gzukSY/SWic/8z2xvsy2WMOqsnGB5+1/3yUhOTVHMIl7u?=
 =?us-ascii?Q?DF+/hUvsTQ2T8DCSy0Rvg9kpji3nbAiMMKcsghGmr5uswz5MFtMTWLTDBqnr?=
 =?us-ascii?Q?3Ck31uDBIBNbRCD39ZNYtRpbBnLB1CW0qgPImmNghWAQMQ10Ls38i/peuGKt?=
 =?us-ascii?Q?Kd86E2vr5mETDh9Vo1mo9FE/XYFnnRi3z/JgmGkmvn1ctZtwZGyhusdvk3QE?=
 =?us-ascii?Q?oQJaT0PO8zll97l9dngYhm1FMlgF5jf83inOhhcblebSpDHNTVbpDo3Q5/0y?=
 =?us-ascii?Q?5jPlWb2tkgUQjQ6m6YY89YBS+iejVgPXHs5yVeSdKGryBWSOR4dwkcNOMpdg?=
 =?us-ascii?Q?3P+wCQmiDFsYAzaw+oduakBbOFn7sk+dLBpzb+C4YjPzSW53rV0qEIDMxKZO?=
 =?us-ascii?Q?g5ig/+DFogGUodhS5xgun0uAz8Ef3C54bxHkzFl7nfO5OSPxWpnVxSJAqOPZ?=
 =?us-ascii?Q?PIfoBnKCHhU8feEFJmTUqgtkJxRUA0GLai+95QQclWt8gqIb+bwVnZyOoHXZ?=
 =?us-ascii?Q?7XFHasR0dDawyCq87h1LfyrWRD/ljDN7KkEl5uoctTco+/Ur0ULKhfOjh9qw?=
 =?us-ascii?Q?HxauMQmYjS48BPpQ8Pt/pO6lZTFJWch87macJiTUtjWgTmZYyFsTO+p9Qb5R?=
 =?us-ascii?Q?8hUyfVUviWR/0SOVtZcglh/EQLBMvhgccjYuADil2wuZglM7ljiCVxdBoSqX?=
 =?us-ascii?Q?O3o8BMAWnpZ5sGMBMjAuo1xgs1iCDOG699PzGlhi1YVz9+GqAp/Bqp3wY5kl?=
 =?us-ascii?Q?9V3QDBNYcrOhTAh2evRFlIemdmkeMvmEM5b16ZTXZmKC4VpG9VhAmikuEJPo?=
 =?us-ascii?Q?rEN8LYoRmPw9p3uZIB0TZ/paZRxvbdFWVmJLVi8hOdY4HhheryeROK34ZLyC?=
 =?us-ascii?Q?vUS1zfUg2F7KhteT13KiU5KSWcgDvCtWoR6THiC3rskDgPLyXlluffQQxbQo?=
 =?us-ascii?Q?b3ug7A/S7cMcCSR5jPlayYERoL5w2SjQXumGHAZtWS+B+UoW5DOs5wsaBWoX?=
 =?us-ascii?Q?Q9TscaQUYnio0Lb/CcZbBLng8lV8yhj9r02gnwgUUgDFM00I7WWfA51DvYhl?=
 =?us-ascii?Q?/vOS+kl6xibHY3HXUXVWhp8XQupm2o2ItnapRkAJ8Yo5XwhY52UgnDtSWoPK?=
 =?us-ascii?Q?tTHu7AdQdipCWyrmzWrlx2rpWCQ55yvGzo5ImgoXTdgff8VhPl9hJ/SQEkW8?=
 =?us-ascii?Q?/bxjqhJ3i0XxOgqTHyw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5737437-51d5-4eb1-6da7-08d9d0733489
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 17:45:47.5716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5P5QL94wltRQxAUdfWzW07p3ICH9jFk7V0SCKg+KOMuCVDhMBgJq1Ep/seR1/9Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5176
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 09:11:19AM -0500, Dennis Dalessandro wrote:
> From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> 
> Despite the patch noted below, the warning still happens with
> certain kernel configs.
> 
> It appears that either check_preemption_disabled() is inconsistent with
> with debug_rcu_read_lock() or the patch incorrectly assumes that an RCU
> critical section will prevent the current cpu from changing.
> 
> A clarification has been solicited via:
> https://lore.kernel.org/linux-rdma/CH0PR01MB71536FB1BD5ECF16E65CB3BFF26F9@CH0PR01MB7153.prod.exchangelabs.com/T/#u
> 
> This patch will silence the warning for now by using get_cpu()/put_cpu().
> 
> Fixes: b6d57e24ce6c ("IB/hfi1: Insure use of smp_processor_id() is preempt disabled")
> Cc: stable@vger.kernel.org
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
> ---
>  drivers/infiniband/hw/hfi1/sdma.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
> index f07d328..809096d 100644
> --- a/drivers/infiniband/hw/hfi1/sdma.c
> +++ b/drivers/infiniband/hw/hfi1/sdma.c
> @@ -839,15 +839,15 @@ struct sdma_engine *sdma_select_user_engine(struct hfi1_devdata *dd,
>  		goto out;
>  
>  	rcu_read_lock();
> -	cpu_id = smp_processor_id();
> +	cpu_id = get_cpu();
>  	rht_node = rhashtable_lookup(dd->sdma_rht, &cpu_id,
>  				     sdma_rht_params);
> -
>  	if (rht_node && rht_node->map[vl]) {
>  		struct sdma_rht_map_elem *map = rht_node->map[vl];
>  
>  		sde = map->sde[selector & map->mask];
>  	}
> +	put_cpu();
>  	rcu_read_unlock();

None of this makes any sense to me.. We have RCU locking but what is
the RCU dereference protecting map and sde? How can sde be taken
outside the lock without protection?

I see stuff like this:

				ret = rhashtable_remove_fast(dd->sdma_rht,
							     &rht_node->node,
							     sdma_rht_params);
				kfree(rht_node);

Which tells me the RCU is not being used properly.

It looks like this all relies on the cpu_id being exclusive at lookup
when the remove is being done, which I think, is not really true under
preempt rt anymore - so at least that is a functional bug fix, not
just a warning suppression.

It seems to me this code is really trying to get the CPU the task is
scheduled on:

	if (current->nr_cpus_allowed != 1)
		goto out;

Why not just get it directly from current? And how is all of that not
racy anyhow with task cpuset changes?

What happens if the wrong sde is selected anyhow?

This all seems so very sketchy and wrongish.

Jason
