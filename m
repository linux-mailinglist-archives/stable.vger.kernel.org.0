Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC62D4D1F6E
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 18:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242076AbiCHRu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 12:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348709AbiCHRu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 12:50:56 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2118.outbound.protection.outlook.com [40.107.93.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D856754BC5;
        Tue,  8 Mar 2022 09:49:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8JIUKIAAtMpwgIApYVmZbz0/JTyNg3yW6XzSdoeC6f/LHPUoCOIlEP9g7KMxxYW3HtvfVh7gdTeR3/OuWkkhvKbUPZS8QurPrIaEw43/0kP8U50hE4Zgf2qjvG10iD06ZxOAAOqprKfXOTaWdJyk7Mn6G0MyQcdMag24P52xDhDR8G3cBUZxaW81gXuxhAGU4PCOzNaJ3zMEHEPKIRJtrJtSGfz8+UQ+QmmvqSjtYWG6QjacPYPhV73vYrlbExRwriDt3OmFDYdvY8jqPttFSRjRY0nwWFtMM/TeK62RlagcA5iU2kBO/CApPaCkCgpNl7RnNMLygoSpf3zIp9YYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e56urm4SC0V5+Ku0QylJtS5f5ctZQOSjnt/v4QZ/wAw=;
 b=PqxTrM5on0lOgDfjW2EpfMvXjayAWVSyw3C59fe9tI30jdlvhHAlLlbhBgjTW1eRxHTPIhBp7G554Nc8CP6FbLoClE9AxqLsHvLeDwFCNSdlUbWQL4AfWgoXuDV9P2xtGbB2aX/5WZaAJJCSSNj3nhUTOcM9XMxdjlpZh6xkSNC7t36uQb9UATOCV0IYO9j9g6gWbIn/a4drYlOebXwQFK0kF0dnLUkuKhmVFqoMhHONUCuqgU/FlRp9otl3RFjhkXqsJ31rhAXzvVQ28+1R+IzyPCr4m/CQrRbQsb9SlBjW3Mkz4R3Z9qCqSG4pBUEkKaWlS2zPQ959IM0rLhnFUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e56urm4SC0V5+Ku0QylJtS5f5ctZQOSjnt/v4QZ/wAw=;
 b=BDC8YTjxDlvpwJYYBuDwf768g6/VK31bjQ4ZFnqKiOzJH5T9fWBKZHv74lMsZKL006y9PVLIQlZCD893hEnkIHrKYpyKkgz5GQnPc7yU3tLxSGrbr5N/mVRIiFXccY/iPW2gd535jV7twpUyWT7dVR/0RJe5uFd6qQ/TDCYXrJY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 BL0PR01MB4641.prod.exchangelabs.com (2603:10b6:208:7f::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 17:49:55 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 17:49:55 +0000
Date:   Tue, 8 Mar 2022 09:49:52 -0800
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] topology: make core_mask include at least
 cluster_siblings
Message-ID: <YieXQD7uG0+R5QBq@fedora>
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
 <20220308103012.GA31267@willie-the-truck>
 <CAKfTPtDe+i0fwV10m2sX2xkJGBrO8B+RQogDDij8ioJAT5+wAw@mail.gmail.com>
 <e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com>
X-ClientProxiedBy: CH0P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::6) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dd5c922-5910-420c-0ac6-08da012c0d96
X-MS-TrafficTypeDiagnostic: BL0PR01MB4641:EE_
X-Microsoft-Antispam-PRVS: <BL0PR01MB4641C60F0CB5B770A12EDF9EF7099@BL0PR01MB4641.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VZ3XN7nNqvFXp3s5k8Jf5KvPnJEv+dSH4+uYqBOkyNszy7laJ4h9vTCw0glXZ8vD2myUQJZzG8EhboA1yZFlqSeEp3918gNwyoGbAicirFOf6InaDk9M+M1nqxiD94wJxz/YdqeNbLG3IjsH6jXm1w08veSWV9VU798yMKO+D8B9o9tcjoJuVG9UcsyRdpdkHOHv5H6RFSpoGQ9OJC6+U4AzDNspQVqGdL/kOcGPIo1JEpSqNA/hhPnb6gjuW2Eb31HIzy2nR0HUv8lg5Ks5v8O/jtZSuVE3GpA/aMrDM96NrtR9iNoP818A5NmBmv+UA0z6GSjaHqXzjrkPTc3VtezQf0Q14hr+27dRxOMPVThTQhrvbFjD8CMBDuwsCbpXZ2VHtPPO7w6Rsa3vMNJBLkGkBZi1CgtYT9tCX0NduyL3EvD6ufAOTj9+WZDpWQST6ecF7F11qS3g7EJYoolExPOIoI35cL++wE11c0/TxGgT4NHzHMYp3wSgNRhvhO050BTCf8MzKoJeYl0v4TM4qQjPwC5X+nCOgPKZ+cuAt7Golqe9OZXeR2Iaa0lJ2GV9EjUwEBRRNriJ3/BMnRUfAeBiJzb46j4MQmdz82Qv4DDawNM0Gw0DLJF64kxkKGIbHKecJenlCR6xr/g6HZs78P4tH5/GNa2CrcmNEp9tPZ6wYfqb2xz+SJrmU9bS47/6xbEbihXtT1xMtBiFwrcihaUWjOF1E2y9KAMeL5f+CwY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(86362001)(38100700002)(38350700002)(83380400001)(26005)(186003)(66476007)(4326008)(8676002)(66556008)(66946007)(316002)(2906002)(7416002)(8936002)(5660300002)(6666004)(6506007)(53546011)(52116002)(9686003)(54906003)(6512007)(33716001)(508600001)(6486002)(6916009)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vQaqx99v5E6H3S1SKS3Mtu6MB9sGRnXnWEju2Nf8MxB7VyTyoJDAcM5bCyGQ?=
 =?us-ascii?Q?Szo97IabF+6WBKcwHRY4408sb8KQO+27JxEfqW0ykWcUbw730adRDJx0YXqj?=
 =?us-ascii?Q?gIIWqCzh8QqnmwxG4JZCPjAEGD7cS7w4jykT7hjI3I5gDXn4XUME6oXDi99K?=
 =?us-ascii?Q?9SSY7ilvnviXn4PxAAzdNawZ547ss7CR0cY2Uk0cbU5OCLw4EVXOuDDzKOp/?=
 =?us-ascii?Q?roPl1KeOJfHvqo/uOweT03I5Li5P5BJ3PFih/Y+sq7BBQpkEqK08XjPuXUtU?=
 =?us-ascii?Q?9KaL65Cu3LH6jpI1fCFPMfoPeDDc8eR9p+TesCvGVZwDy6UGKxaFlnL7GZNr?=
 =?us-ascii?Q?OgNGoYWu7p0CnmqPUGL2Wd5+aBlLwGBaBk/pQiZSxKW1JN1TVEh4g7a0dFz5?=
 =?us-ascii?Q?VWvGPCGuNbnyipGzBug2nuum4jbTKQGRMdGdNCo/SvJT5qASsoPApAFSguAC?=
 =?us-ascii?Q?NoQ0DUnfEsz/QQvRam3jJDUUKjHfwEAb+OTgU0qYg618EjXNoUhXbWtNBYKe?=
 =?us-ascii?Q?IyAdwMPjyfquIJcDxp9AGfItcKdxILvG1BIk+sYdkXSgNHq5+ZCvtPnSSJcW?=
 =?us-ascii?Q?d2i+uZF6UzwCunQQO61+o8vNkpK8YERf2EwzIDOylOPXZCFVbF/piw17c2Qb?=
 =?us-ascii?Q?w2eTYxE/pDl0w9QoYcivrFb7tnsFAccimOvT7RhOzNLRsa7go5WreEHPk5x9?=
 =?us-ascii?Q?ZEpLBT/POiTTsp1hnaCZ/yzvaIs94y10LJBMy4XdCyFekm0xkmUTdcgsRTFn?=
 =?us-ascii?Q?W+vf3eGGc0FfgdBsrqMW6/MXksRcegx3XAYzbhEUNsOmGR+MYgYqRsvGnlrV?=
 =?us-ascii?Q?nsbnXKmcXKD15XIu0dY29/LbOGo2w1aj0GXXSVRfHZX6enf3EMRM/rzYZ00X?=
 =?us-ascii?Q?NQmeKCagTu7Sa3fCTKdOASBIaGBz6V2iJGeoIeHo9+tom7JxUBK/iaeCFYZG?=
 =?us-ascii?Q?B4j7g6ac/REuM6cEzkZco0ZEQvrQqFuts+Sg9A0DSbI9ddI+8kbx6xhaMlkg?=
 =?us-ascii?Q?E8QrRV+gnlYNWww/8i4wgQ2xXgt+2syEmvxN7mRGNfGunKOpFdJQmBArxXs8?=
 =?us-ascii?Q?HTCFzv6M4Eid0IFfa+Yck8f6uoHSzv3HjCrCZSfrgyAJlRhhskmDKkd2tUNe?=
 =?us-ascii?Q?JYewlJ2mud7R+2egtINhhZWGfooOKtqN8V2w4feoCQpMDjGP/3NNyWTPQCFv?=
 =?us-ascii?Q?h3WN53ka7zYcVCa38tmCNsDHOI51x6l8hsf2dSlCkc62xvh3dqSArLwc9+E/?=
 =?us-ascii?Q?WdC7ASj2XlK5GNy+cu1qTUWAeWPCoYxo2xzFyNSgibXbSjT4OlcoyXdLt8fM?=
 =?us-ascii?Q?scMYa5jZfkKb3oBTXtNiywXnbwmDZapkGXl9RBSZUeOIM6VAk/4r8jSagP+V?=
 =?us-ascii?Q?nQQ9Jk/DZx0Er1uLfgiT3Z0ra5YHR9uNSF/8HpAc91/uBd6ulIvG3crnSM4f?=
 =?us-ascii?Q?nhz2lRYqi21oxf/O+wCOSZqOUxSWwbVaQhXqzjV2fcmo2VVA1i4EqmFmbEhk?=
 =?us-ascii?Q?oA09PQKVe1uLCPptet4oEHeOx9HkPJCG3VEcyOmxQ4Dk3W1ccQ6IwmEtVSk/?=
 =?us-ascii?Q?SehacPEQnBKidJlzPZU69O4+kLmWiaigOB99wecoRrKYO+F5awZgZQhUpmOR?=
 =?us-ascii?Q?2+sUKj4NKd5aPl7bMFbSc9nlb6IwUTFHCzDrisa3AgNa4k/TJ8siiItPCrAd?=
 =?us-ascii?Q?alftv/gVFdF8C1T3z2HZLGTs67SU5koN1CdNT2FbK0iO479y0cJsD/bRFw5B?=
 =?us-ascii?Q?Z9TXbPRoBA=3D=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd5c922-5910-420c-0ac6-08da012c0d96
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 17:49:54.8221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2m93Z49UguWFm3lO9V9DKMZ4w7Wt0npAS71IKog2mR5EGzouWMq2OU/OqQFVHz52E3WZhxFsuh5a18eaXxl6eac8UW6A21n1iRwlKfXWsWiuFmjwQNjNzrkjyjLX4j9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4641
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 05:03:07PM +0100, Dietmar Eggemann wrote:
> On 08/03/2022 12:04, Vincent Guittot wrote:
> > On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:
> 
> [...]
> 
> >>> ---
> >>> v1: Drop MC level if coregroup weight == 1
> >>> v2: New sd topo in arch/arm64/kernel/smp.c
> >>> v3: No new topo, extend core_mask to cluster_siblings
> >>>
> >>>  drivers/base/arch_topology.c | 8 ++++++++
> >>>  1 file changed, 8 insertions(+)
> >>>
> >>> diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> >>> index 976154140f0b..a96f45db928b 100644
> >>> --- a/drivers/base/arch_topology.c
> >>> +++ b/drivers/base/arch_topology.c
> >>> @@ -628,6 +628,14 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
> >>>                       core_mask = &cpu_topology[cpu].llc_sibling;
> >>>       }
> >>>
> >>> +     /*
> >>> +      * For systems with no shared cpu-side LLC but with clusters defined,
> >>> +      * extend core_mask to cluster_siblings. The sched domain builder will
> >>> +      * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
> 
> IMHO, if core_mask weight is 1, MC will be removed/degenerated anyway.
> 
> This is what I get on my Ampere Altra (I guess I don't have the ACPI
> changes which would let to a CLS sched domain):
> 
> # cat /sys/kernel/debug/sched/domains/cpu0/domain*/name
> DIE
> NUMA
> root@oss-altra01:~# zcat /proc/config.gz | grep SCHED_CLUSTER
> CONFIG_SCHED_CLUSTER=y

I'd like to follow up on this. Would you share your dmidecode BIOS
Information section?

Which kernel version?

> >>> +      */
> >>> +     if (cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
> >>> +             core_mask = &cpu_topology[cpu].cluster_sibling;
> >>> +
> >>
> >> Sudeep, Vincent, are you happy with this now?
> > 
> > I would not say that I'm happy because this solution skews the core
> > cpu mask in order to abuse the scheduler so that it will remove a
> > wrong but useless level when it will build its domains.
> > But this works so as long as the maintainer are happy, I'm fine

I did explore the other options and they added considerably more
complexity without much benefit in my view. I prefer this option which
maintains the cpu_topology as described by the platform, and maps it
into something that suits the current scheduler abstraction. I agree
there is more work to be done here and intend to continue with it.

> I do not have any better idea than this tweak here either in case the
> platform can't provide a cleaner setup.

I'd argue The platform is describing itself accurately in ACPI PPTT
terms. The topology doesn't fit nicely within the kernel abstractions
today. This is an area where I hope to continue to improve things going
forward.

> Maybe the following is easier to read but then we use
> '&cpu_topology[cpu].llc_sibling' in cpu_coregroup_mask() already ...
> 
> @@ -617,6 +617,7 @@ EXPORT_SYMBOL_GPL(cpu_topology);
>  const struct cpumask *cpu_coregroup_mask(int cpu)
>  {
>         const cpumask_t *core_mask = cpumask_of_node(cpu_to_node(cpu));
> +       const cpumask_t *cluster_mask = cpu_clustergroup_mask(cpu);
> 
>         /* Find the smaller of NUMA, core or LLC siblings */
>         if (cpumask_subset(&cpu_topology[cpu].core_sibling, core_mask)) {
> @@ -628,6 +629,9 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
>                         core_mask = &cpu_topology[cpu].llc_sibling;
>         }
> 
> +       if (cpumask_subset(core_mask, cluster_mask))
> +               core_mask = cluster_mask;
> +

Either works for me. I felt the version I sent was parallel to the
existing implementation, but have no preference either way.

>         return core_mask;
>  }
> 
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> 

Thanks for the review Dietmar.

-- 
Darren Hart
Ampere Computing / OS and Kernel
