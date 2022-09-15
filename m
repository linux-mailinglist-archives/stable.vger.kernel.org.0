Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03AA5BA08B
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 19:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiIOR4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 13:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiIOR4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 13:56:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2099.outbound.protection.outlook.com [40.107.223.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD8F491E1;
        Thu, 15 Sep 2022 10:56:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYU1+r3qn1oEVBJVXEyeLqNsWN3Q1nLuQbprADB5qEyBcg2o5lSi1b3Ja3DRv2S/MpWb01Pm+hSYNWxoVjB+iUdbiAC9Oo/AdPk6YT3WCr7r8eW65dp4dFl7lJ3H2lOBu5mcBBtvQO8QiTNZPXxynFefDnr3zXBHTJVueu+nxikiUVNrmLaisGXoS7rDo1cCXJKC+1x2CZhFvN/5nQr1zmIdglwk7JGKJV7rUHY60lyiEPBW+1lCaolIiNlJQw17ifJRGegT3g3m/lLvTSMCzcaMilDgf+j+ReOhuw84WWeBeJTWbHycIx/WOamxLnzvIKw80vpC6ria3uh8qCNc7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/PxYVLW1VtZCPdKdvAg0t6XzHKBcDx/LlrdXVteV40=;
 b=iGKcI7nG6OJ9cmSGOa2MWkzgxg8XEA9t1X5rz4FrOl8xNVGroRhytU8uOxkRZ28s4KAPWQTEP++mlsM7P9Tb9cBQcmSNZRAdqugrfb/ePklSkmvVjm2aFi6QDUxUMhAGl074DbJBv+ug91kMjiAkbfMJ6+4CDBt0vbCntXWnqjvWoct7EWPfJ/nE/pcoB5aOwU5blGZHi5JvyHWR+0xKF5ycLW23jye6tXy4cWmeaBaDXbhdKG3GPsr2q9ZB06Hcia4IVakUxsi2DH1pchZ7Bj5X0nFqoC66L982ZjQ3S3zUvpkU8ZfpieKQS07houxH0dM7ynKSoeQmnvamHgZTwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/PxYVLW1VtZCPdKdvAg0t6XzHKBcDx/LlrdXVteV40=;
 b=XuOm62wDAg3IiCpKGgTwBTUkrgWlsO0alSKm9vDyXC5/o79xSpH4yogpZPXbQEBPxAc721TiBjUANfS9ZdrQmAWwheHnWZ4zY79DdlQ09vhXqPZk2E2cKIiWsG/YbHpxSbXYaDpweZ/Q0rG+A0L6l+M5KL9Kon1Qt//MiTXusLc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from CO1PR01MB6742.prod.exchangelabs.com (2603:10b6:303:f7::15) by
 MW2PR0102MB3564.prod.exchangelabs.com (2603:10b6:302:6::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.20; Thu, 15 Sep 2022 17:56:06 +0000
Received: from CO1PR01MB6742.prod.exchangelabs.com
 ([fe80::a068:3bad:b9f:c3b8]) by CO1PR01MB6742.prod.exchangelabs.com
 ([fe80::a068:3bad:b9f:c3b8%9]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 17:56:06 +0000
Date:   Thu, 15 Sep 2022 10:56:02 -0700
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Yicong Yang <yangyicong@huawei.com>
Cc:     yangyicong@hisilicon.com, Sudeep Holla <sudeep.holla@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Ionela Voinescu <ionela.voinescu@arm.com>,
        Barry Song <21cnbao@gmail.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v5] topology: make core_mask include at least
 cluster_siblings
Message-ID: <YyNnMmtoOrdexLoy@fedora>
References: <c8fe9fce7c86ed56b4c455b8c902982dc2303868.1649696956.git.darren@os.amperecomputing.com>
 <eee69d10-11d0-be2d-69f6-34089947311e@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eee69d10-11d0-be2d-69f6-34089947311e@huawei.com>
X-ClientProxiedBy: CH2PR17CA0001.namprd17.prod.outlook.com
 (2603:10b6:610:53::11) To CO1PR01MB6742.prod.exchangelabs.com
 (2603:10b6:303:f7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR01MB6742:EE_|MW2PR0102MB3564:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a829b2d-6aad-4815-7721-08da97438fca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xHAp/j+FBsUGPLq4ZKK7jf2O/mXJdAUccU+mL+84eC8algjKREzUeSZ2f2lUPdtafW/GIiKrLYxsQbAUNPc40LRX+SFYBxhC0MfQtWWkudzKJcsoRg0soCejMoT/MfuenjvKVoTDKJFzzh1Uj6nmjGuMO3kAPOzGBN//+ZtnZbxdgXZjnHEVJmXmxtYHVSgRPdMKBqpPKTqEmA7H+X0XqiBICpbu7MyeNLoyc4bj1QXrLVQiXCLB5N7aONssiJlM1J9TyO8vBWT+qqZ8haABgIut4Uhi9ZN5gEsa8ya6aUiVC8A0SgSG3V6zLqEBUS67RRRE514oy9zRVcHDsQjWArG3A6264fwV1qAabRs/yJHsY6mcN9bqMEneymsRQoXnbVtMFC71eKok8f6NqvCGgZ6yAhIXYgsHRo+LCS9WqM4MSwqdV5hXI8b8TSa/mruKmgCYYOmYOlfTOiiwgUfDHnyC9Pmg/HRT2oUPGS7AYEcKEC3tfagQT9g8ktRAF/14o7meqESkrjrvffy2iq8c1+iCkDCEDawo/x+BVUYAowYEm4qWlzu/zkPlNCG7UnpuWhe/OF38wb3gq0GcaZUOqaoK0LDAV8kRFlwNFiLJO0bzcUBEgAYVhkFkqkVfUZCjuPHpGXMUi/+ynRx5Ds6V4inO5XWqszQd0wFPYNXCMGDeROUtM/ivL3DLsG+K+ThqKK9tPAUAIeT7K5ySTPg6/QFgwxgj+ErojZ+JkPUqGeUpcTH8UgJXIa+B8lj3H0yQOjeVrlw65j1dcQ3XOa0R+Uwytb/digQLakqiA5Uh29A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR01MB6742.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(396003)(346002)(376002)(136003)(39850400004)(451199015)(83380400001)(8936002)(86362001)(478600001)(66476007)(66946007)(8676002)(38100700002)(6666004)(66556008)(6506007)(52116002)(2906002)(9686003)(6512007)(5660300002)(26005)(33716001)(966005)(54906003)(41300700001)(4326008)(186003)(316002)(6916009)(7416002)(38350700002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F57ad3t0eSDrxatw1f64G1SGLcuMJ7B3nS5Amb42W43WWfa4bgwrq5Dgc8Uo?=
 =?us-ascii?Q?9doHl255S54a7c+D9KMFJdf8lErmFlG3WLfI05qanm1ul006NUGayhdomopK?=
 =?us-ascii?Q?USarMMAK/KGBPYZRo+5RfhdWLSpNPwCKx+v6i3Jrf4UvkoTgECgC433dYdDM?=
 =?us-ascii?Q?4d5MpxC7wBpHowB7TMGETTbjwexZyAfG4SqZNJw1yao8OBEqRwCi1P9b+U3D?=
 =?us-ascii?Q?lITatEdYvTxRPQsBR6cZhbpVr+YcvbRpt8Pf89yxgIlaWtTbhOjr7CF9oPxV?=
 =?us-ascii?Q?SHH3WUzu95CiNvypKX5dtv6S06SzrKtYthUaE/inI6sFTcgmQKqYhrzBd8yp?=
 =?us-ascii?Q?bZpdFEW4qZyym6kHmHW4yhtX9y5gjJa3VFzxyIUAZC1ziWOdNvQMXftCl+U9?=
 =?us-ascii?Q?cqd72RiqsblgeiccX0ErjYyA2dZ7w4xO4HNFqEPiRAy7yRO2iMfFLd8MSH+3?=
 =?us-ascii?Q?2+iGJ+Z5GUrOLwpXILoiLv/SPNzkfPFJYZ+j7L8xsNu4GwE389i2W+eAED+s?=
 =?us-ascii?Q?DoF7DDS6Xn8i/ZV3gCD8xJtdnJdmJVzeG3mor+iG+7y8kTKfUB9/udEpBRGA?=
 =?us-ascii?Q?NGmUEBVjWANdZTOgKCNoCrbu/IDkJ2jXUn1tZOAXQkUGJq6tD1zr5u7cfLTq?=
 =?us-ascii?Q?MMp8f3WdrSgTzY0ojqHmWc2Gyv7AwKtbGv8G9ERJNAlDUyzbnLb8JQzPUdmO?=
 =?us-ascii?Q?K1bBIPN9tTXnyqXM4Aq5TEaSr4OEK/vLFXerRtKIrwqFtdSk6n3E5kRS7T/j?=
 =?us-ascii?Q?iHvga6Jd7APlGj+Bzai3NpV394gzrXMLLnx5BlJr5+7zAQ6dj6rgVxvIggJR?=
 =?us-ascii?Q?ryvVROCTby24O2ENtDzaNRSCxyMi+DQDlKuPUgGT0KfzP3LCyOnbJ9VgRkpW?=
 =?us-ascii?Q?eKpHb/nwJsUJAmf+wybJIYNvlCKgiDzyAcX08Iah7FzXAFHxZZBJ2gvyM0mu?=
 =?us-ascii?Q?ja6LcbOolcz4nAnrjrOhQX/GYnvYzPmbOmIoEiCKDUUPwXTL9anubZaxH/iU?=
 =?us-ascii?Q?XWl6SztlqwJX3YoKzmpN6/HoADufQAEaxo5NOweWjfDJ83kFbecfTd5tEbcI?=
 =?us-ascii?Q?7/lvmWKjp5WnU5psMYN9OpARmbreGj1h2OyIl9WKy+x80RD9VYEwuAvgAynt?=
 =?us-ascii?Q?E0QD4g9saEyjcEduXaHEuMB+jn3kVLIMemu2MGgCFcq6O8BXooBH6Qu0vCkU?=
 =?us-ascii?Q?AIxrrdzUxlPUfmJgoMUi4y1c0/OWsJIXGSst3MIVpj0RgJQC+yLeohtkpLEk?=
 =?us-ascii?Q?6evB1yjJa2rBhKJPNzn3M6juEsR1IlOnUNMjGczDOLoRn7pQIF2UeLm/QkDv?=
 =?us-ascii?Q?Xz74tlBCQwBx5RybnMbdUIMwRlwP41ssPetUs8BBGZ9GyNOcOlQYVJ1QTics?=
 =?us-ascii?Q?mTQfJpadrYz5PFRF9IyL3u+4Fn9dlw+SH4cVbGBsPBEi4MmmmrK2pVRhgl77?=
 =?us-ascii?Q?5Dl3H/iq7dY2F1njQAXaZlq7GfZFSyUsjoyzP8WAdsPdpGvJGJtE+4bUTP21?=
 =?us-ascii?Q?sos2Izhj066V66ODAdgi+dZ5uLigUgMw8h/LICma0ncQEMNwn4r3c3Is0yv0?=
 =?us-ascii?Q?SMlxn512h8wotoF+gT/bm1tW2IgJHY6C530+Z+1QgANzgD1UBrnUEhTV7yZp?=
 =?us-ascii?Q?DezpycSYX6EWVoMXXdetbrE=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a829b2d-6aad-4815-7721-08da97438fca
X-MS-Exchange-CrossTenant-AuthSource: CO1PR01MB6742.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 17:56:06.0966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8UY03KHjngf1899fIgHClNmc9ggtGYo/TFJmESPelb12ffMjWeTdIsXm6v7UKJ7DDFTGRpy3/8rPQ1S35/y82LNJF2VSy+y9hTs+8McZuYQBY22XclT9VCf7LiHVYEb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR0102MB3564
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 15, 2022 at 08:01:18PM +0800, Yicong Yang wrote:
> Hi Darren,
> 

Hi Yicong,

...

> > diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
> > index 1d6636ebaac5..5497c5ab7318 100644
> > --- a/drivers/base/arch_topology.c
> > +++ b/drivers/base/arch_topology.c
> > @@ -667,6 +667,15 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
> >  			core_mask = &cpu_topology[cpu].llc_sibling;
> >  	}
> >  
> > +	/*
> > +	 * For systems with no shared cpu-side LLC but with clusters defined,
> > +	 * extend core_mask to cluster_siblings. The sched domain builder will
> > +	 * then remove MC as redundant with CLS if SCHED_CLUSTER is enabled.
> > +	 */
> > +	if (IS_ENABLED(CONFIG_SCHED_CLUSTER) &&
> > +	    cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
> > +		core_mask = &cpu_topology[cpu].cluster_sibling;
> > +
> >  	return core_mask;
> >  }
> >  
> 
> Is this patch still necessary for Ampere after Ionela's patch [1], which
> will limit the cluster's span within coregroup's span.

Yes, see:
https://lore.kernel.org/lkml/YshYAyEWhE4z%2FKpB@fedora/

Both patches work together to accomplish the desired sched domains for the
Ampere Altra family.

> 
> I found an issue that the NUMA domains are not built on qemu with:
> 
> qemu-system-aarch64 \
>         -kernel ${Image} \
>         -smp 8 \
>         -cpu cortex-a72 \
>         -m 32G \
>         -object memory-backend-ram,id=node0,size=8G \
>         -object memory-backend-ram,id=node1,size=8G \
>         -object memory-backend-ram,id=node2,size=8G \
>         -object memory-backend-ram,id=node3,size=8G \
>         -numa node,memdev=node0,cpus=0-1,nodeid=0 \
>         -numa node,memdev=node1,cpus=2-3,nodeid=1 \
>         -numa node,memdev=node2,cpus=4-5,nodeid=2 \
>         -numa node,memdev=node3,cpus=6-7,nodeid=3 \
>         -numa dist,src=0,dst=1,val=12 \
>         -numa dist,src=0,dst=2,val=20 \
>         -numa dist,src=0,dst=3,val=22 \
>         -numa dist,src=1,dst=2,val=22 \
>         -numa dist,src=1,dst=3,val=24 \
>         -numa dist,src=2,dst=3,val=12 \
>         -machine virt,iommu=smmuv3 \
>         -net none \
>         -initrd ${Rootfs} \
>         -nographic \
>         -bios QEMU_EFI.fd \
>         -append "rdinit=/init console=ttyAMA0 earlycon=pl011,0x9000000 sched_verbose loglevel=8"
> 
> I can see the schedule domain build stops at MC level since we reach all the
> cpus in the system:
> 
> [    2.141316] CPU0 attaching sched-domain(s):
> [    2.142558]  domain-0: span=0-7 level=MC
> [    2.145364]   groups: 0:{ span=0 cap=964 }, 1:{ span=1 cap=914 }, 2:{ span=2 cap=921 }, 3:{ span=3 cap=964 }, 4:{ span=4 cap=925 }, 5:{ span=5 cap=964 }, 6:{ span=6 cap=967 }, 7:{ span=7 cap=967 }
> [    2.158357] CPU1 attaching sched-domain(s):
> [    2.158964]  domain-0: span=0-7 level=MC
> [...]
> 
> Without this the NUMA domains are built correctly:
> 

Without which? My patch, Ionela's patch, or both?

> [    2.008885] CPU0 attaching sched-domain(s):
> [    2.009764]  domain-0: span=0-1 level=MC
> [    2.012654]   groups: 0:{ span=0 cap=962 }, 1:{ span=1 cap=925 }
> [    2.016532]   domain-1: span=0-3 level=NUMA
> [    2.017444]    groups: 0:{ span=0-1 cap=1887 }, 2:{ span=2-3 cap=1871 }
> [    2.019354]    domain-2: span=0-5 level=NUMA

I'm not following this topology - what in the description above should result in
a domain with span=0-5?


> [    2.019983]     groups: 0:{ span=0-3 cap=3758 }, 4:{ span=4-5 cap=1935 }
> [    2.021527]     domain-3: span=0-7 level=NUMA
> [    2.022516]      groups: 0:{ span=0-5 mask=0-1 cap=5693 }, 6:{ span=4-7 mask=6-7 cap=3978 }
> [...]
> 
> Hope to see your comments since I have no Ampere machine and I don't know
> how to emulate its topology on qemu.
> 
> [1] bfcc4397435d ("arch_topology: Limit span of cpu_clustergroup_mask()")
> 
> Thanks,
> Yicong

Thanks,

-- 
Darren Hart
Ampere Computing / OS and Kernel
