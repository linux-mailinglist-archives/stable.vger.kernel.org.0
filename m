Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5B65BB1BA
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 19:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiIPRqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 13:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiIPRqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 13:46:17 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2127.outbound.protection.outlook.com [40.107.92.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66E589809;
        Fri, 16 Sep 2022 10:46:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5btiMUChFjepxvJTHTuMPiiUz3foUVopyCDWg7u4dafpcsxniw2eKppldJQWK/rBW3IvynV//vBgO3HP0gnpz4YN1sQ13cW9AxdLOM9vNYGXZ/M/3ULVIvf8F01Mv8HixyyBOS/1ilj7+c+ZCvUJ63WEIuMTRPmDRtuN5idK/eoq4YT9USv7tfIOdUXrmLn8vmmwsYaNdcBeq/ROGpJBEtqzjjrRdyC7Lo641AHUj458JWsfmXSvweqDAc0FpYSK+x1HymtQ3YiiZaJg2hnMLD4f5vgeQZXm+1KzJp+TbdOdF3QclzbyK8zlH0GwS6Oc4/fKujjByhB9AkoSQgOpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5kooSkDwYIhBqto01ETq++kjnjCx1MHZdznhdgMb6k=;
 b=W4RH8TlnyhmNbJACae1TbuL0hXsFL573MyVMzNalgHNIgZKF3UCD/lCar1JJBt8Qj+aopyRbADR3nSak7PPmaMGZ2KuoaTV4OLGJDOs/vYSBsUcsPon6ZPJox7c6v3s0FmMhRnKfkPAgRldqlNmP8s9hzdnvS9fGCaCWm546Cuo3gTYFpXLwn0WOjIv/YvQKQAwMFjxNp/LjcjxWnFBju/MROSeGYzNvetLBdfVhScC3zG+wiW6e6EhPGJeUq4uR4mjQ4j4wfimDAm9Cp7hqqq9InprukM4sdCjzSL/eGpAkUAVYH9lkzYJrMScQ1/2bPcsSbYgjDFOzBUPSvaDv/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5kooSkDwYIhBqto01ETq++kjnjCx1MHZdznhdgMb6k=;
 b=Afywr5jd+ayBuvOe7PrqRtZP/5AA3FBJ3mYwwc34pCq1WG2V0K/KtATNS8+wXJ7aL5p2WQ/SX309R0HnCYK/TfzBXn9F4qfItl2f5JI+R431WMJSYjFt3P8p8dU6m2F5R+0oKIZu04DjMr/q1ughXFV9SC24/r4+Ayq6i+SF/vo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from CO1PR01MB6742.prod.exchangelabs.com (2603:10b6:303:f7::15) by
 MWHPR0101MB2880.prod.exchangelabs.com (2603:10b6:301:30::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.23; Fri, 16 Sep 2022 17:46:13 +0000
Received: from CO1PR01MB6742.prod.exchangelabs.com
 ([fe80::a068:3bad:b9f:c3b8]) by CO1PR01MB6742.prod.exchangelabs.com
 ([fe80::a068:3bad:b9f:c3b8%9]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 17:46:13 +0000
Date:   Fri, 16 Sep 2022 10:46:11 -0700
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Ionela Voinescu <ionela.voinescu@arm.com>
Cc:     Yicong Yang <yangyicong@huawei.com>, yangyicong@hisilicon.com,
        Sudeep Holla <sudeep.holla@arm.com>,
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
        Barry Song <21cnbao@gmail.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v5] topology: make core_mask include at least
 cluster_siblings
Message-ID: <YyS2YzOHZ8m8/OV+@fedora>
References: <c8fe9fce7c86ed56b4c455b8c902982dc2303868.1649696956.git.darren@os.amperecomputing.com>
 <eee69d10-11d0-be2d-69f6-34089947311e@huawei.com>
 <YyNnMmtoOrdexLoy@fedora>
 <bcd61ebd-d751-57a3-690b-b76c7bd230c5@huawei.com>
 <YySg8UM2Vqb9jPfh@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YySg8UM2Vqb9jPfh@arm.com>
X-ClientProxiedBy: MW4P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::33) To CO1PR01MB6742.prod.exchangelabs.com
 (2603:10b6:303:f7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR01MB6742:EE_|MWHPR0101MB2880:EE_
X-MS-Office365-Filtering-Correlation-Id: d60382cb-9356-434f-24f6-08da980b58e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cQOJzPiTaLinC97+76UJflFJnOiopuCdS+i5WfHs2eI/oNodSh7UfLQgmYngViRF6zBvtHf7iOplVgKQgvqp3gTXq/ZYazm2OPy9i5Jthuy/MKslwld6/zzTtZvPkXBdPniO1nuTrDL4qnzcn9wM6YK4umoZaOo++YOxvZuH55g6JEyFtmLEDlR0KiRr2yG3oC/+WorCAFdl5+onxKQCsj95KF2P2yqrLX2+JxRaGDapRz9ikhABXB//q3dKLyynIev7hGt+f8zXFmyq0TAsdlCfhW+CDbmAM5hihDi+mUlpmbypgJCWubOqwOIfJ8UMbMk1aK8FK0l/N3tpY9fdvagr+sJTZYCG3bDKvl+Go8Z598lpfXc+Xdtgx7rYqHbXI3NADWBCQh7c8boC4CzrMHWXiivxM/CwQ+a0ZalJRzemLDE1FyejjqQQiIP3NjHzzq15AG4+/DeSDHTZF/irCPL4ds9vZJJfdzQpJ1JbfW2jI8ubBFUySjwOfDqwuJf3U9dQTzr+KutTriRYa4V97b1q10GGXD0cp0+VfXdADQzN+7yOMSAaLMub/SRwe8Di3qLnsobv3gG4Qi1LfcvSo9Tg7H1YvNSQLJzWZ2xkgjbm2HIAsUJw1WNGM9ys8daLL1BtVfaj2IURut9d/g5F69+9Pn6aKGlEoY5n1j0/+ZkN+NZPTWsh3y3O7Gmk31Ltvjg7r4c61aA8z/iUGF9PFvaKaIMAmGiW/e2pKkeftD3f+cCMaUC0yiLSX48tNVX19828EtNbtkgPT/+DMMbScg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR01MB6742.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(346002)(376002)(136003)(366004)(39850400004)(451199015)(8676002)(4326008)(38100700002)(6506007)(66476007)(38350700002)(66946007)(26005)(66556008)(478600001)(41300700001)(52116002)(9686003)(54906003)(6486002)(6916009)(316002)(6512007)(83380400001)(186003)(8936002)(7416002)(86362001)(2906002)(5660300002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+geCDoM9+ibB6J6DPnTpQipVQhTyjx6sZVnRsfb3IyMSTeDST5OqtqWIBgN2?=
 =?us-ascii?Q?8FnQSFxeORKz1HX6QjjknJXmDZQKh9QQsFSLaSL2lS/8mcPei2xIJkXbKyZw?=
 =?us-ascii?Q?IHtcFf4nIu7zYHLreWdsa1YymD7kZTffMPCgQkKPyqX4+FYs+UTy49JIDnSk?=
 =?us-ascii?Q?+a4hMs21iLKzpZpJXuTFSwudeCfbK/5y2/wgts1JPFGuMGOmiMlJdAslfWG5?=
 =?us-ascii?Q?4gw3JYhEgnGv7tsPQFiCKV/SPksRqPqukCtObwRC+VI2sAahBnaJvTo2ZGtA?=
 =?us-ascii?Q?d7xLOcQLFipOHlf0ehKD4iwWajcTd1DulYWQDqPfbshz9A52kaJesrTMVKIF?=
 =?us-ascii?Q?+tMzjnWTRIG+586hQgMRfeac9/K0xNlXTPQbBUA/UPTSaWikDoW0w/ObI/23?=
 =?us-ascii?Q?gVuMBJgaQ2NMy6i5Tr3KITLpU/3lhQTtdJ4rR1+vvFE6BOZTn3WeX30ga3XC?=
 =?us-ascii?Q?d2GmI3+qwCauOySFXsjkx8jvR9FrC05G62kmMdT12vTDzKe7pE3hnRcHQB6r?=
 =?us-ascii?Q?NqAMi8IcbBqQr0R8FBKLC8eqf6elsE5nAUmL6T2aaoNyj65I446iuchA9BEn?=
 =?us-ascii?Q?/Bbp+slZIKCPWWzDZO5No4KXCNKP6gJHrpmApqmZDpRq5b9m5G7RnN3KUpVp?=
 =?us-ascii?Q?Vpr6RxbtXBmFMbWYo0OC4Qwy/JQBANlmzHnQzHsO19UVXMyT6fUO7avRMZb5?=
 =?us-ascii?Q?4keja1b3KC+hp2Kon2naQdCTGX3MkoNZxsYhN8fQrV5mtDClbao/Wspqc6bw?=
 =?us-ascii?Q?Yrny36Q2cqLR8Hx0GDZX4WL+qoZ5vrmKBxlApHH+87DAdiW2B12m3V1hs4Ww?=
 =?us-ascii?Q?4vPtC4VbsiooLbvgnkBgPqiGZo0ohHYU4z0vFx1VE8FhlaJRBVJpMTejcDb5?=
 =?us-ascii?Q?o2FS+vkUvPl5Jqx4aDBqAP4TOGsf9IVyy4UhYyOcYiEzYV287plGfejCEb2K?=
 =?us-ascii?Q?5zHEUuwPvqYItveW5zLNzg6+70ydOEprdA1HodquIHa8koQZs0B7kxyHM62E?=
 =?us-ascii?Q?TUAXMxWIPCrWvtst77PCy6ZK2nnVNFNoNOKYOq/JFyqjoywr83oU3hD7RpQW?=
 =?us-ascii?Q?yS2u/zvolE52UYsNm3C1tIt8GrYiRjBLFBAH6n0sH5UjQR/zWp7vAaFJ1JPV?=
 =?us-ascii?Q?654X6Cg66Qadx/+yiu2uTQCpbonxb7LQuWVB8VFeFllmP/FJsxUB3ZlALCD3?=
 =?us-ascii?Q?F5b+sblctXpoJ499EmbXG/x53lYYdg1p5yyfHYh9FQCngONQTd1prc9CtEOE?=
 =?us-ascii?Q?la/MAIGdf9Zi/4KRHMY8zZyrubJ6ZPrTJUXv2eCvdXhOsa7LNFEiU2QcD6La?=
 =?us-ascii?Q?+WAVyX6JL2Tuv9pEO0MXwphOb2v7BnLaV0sI7bsSxak7/Pa1B+nvbjUtfouk?=
 =?us-ascii?Q?DnbLY2ieirp5XFP5w0QAWkdcSo7MbVdw90yHfyy+B2tgABR7RsPBk3VxIzgg?=
 =?us-ascii?Q?stRQwsgnY4+sXYu7/qM6U9OI+R0tOQ1GodECGLMD7Pwo2Swr7Z8Monfp3nFQ?=
 =?us-ascii?Q?O4qWpLmz0ApdbkU3o3yD+p40W1PvM/tGjOzPqiDUewAh16D06ALko6wJOqyb?=
 =?us-ascii?Q?zQfatqWCL9PPnEagCihAeexGvXon3Ru2vTKl5cPYTyIXnxWiiVM33D8atR5q?=
 =?us-ascii?Q?A4kpahi1N4FweWl0h4MpdjM=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d60382cb-9356-434f-24f6-08da980b58e6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR01MB6742.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 17:46:13.0823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IN3lZKzhGd5mLawAdH1azAgF8xJ6dQUFHfpGG3a83SGWkshVQ9Mw7SW5zAvtRf/kJdCEecbFhJoJnICccDbURuLnk1EinFvZVk3NreNtFwlhBQLHhQc982Y5MyZQwwsU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0101MB2880
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 05:14:41PM +0100, Ionela Voinescu wrote:
> > >>
> > >> I found an issue that the NUMA domains are not built on qemu with:
> > >>
> > >> qemu-system-aarch64 \
> > >>         -kernel ${Image} \
> > >>         -smp 8 \
> > >>         -cpu cortex-a72 \
> > >>         -m 32G \
> > >>         -object memory-backend-ram,id=node0,size=8G \
> > >>         -object memory-backend-ram,id=node1,size=8G \
> > >>         -object memory-backend-ram,id=node2,size=8G \
> > >>         -object memory-backend-ram,id=node3,size=8G \
> > >>         -numa node,memdev=node0,cpus=0-1,nodeid=0 \
> > >>         -numa node,memdev=node1,cpus=2-3,nodeid=1 \
> > >>         -numa node,memdev=node2,cpus=4-5,nodeid=2 \
> > >>         -numa node,memdev=node3,cpus=6-7,nodeid=3 \
> > >>         -numa dist,src=0,dst=1,val=12 \
> > >>         -numa dist,src=0,dst=2,val=20 \
> > >>         -numa dist,src=0,dst=3,val=22 \
> > >>         -numa dist,src=1,dst=2,val=22 \
> > >>         -numa dist,src=1,dst=3,val=24 \
> > >>         -numa dist,src=2,dst=3,val=12 \
> > >>         -machine virt,iommu=smmuv3 \
> > >>         -net none \
> > >>         -initrd ${Rootfs} \
> > >>         -nographic \
> > >>         -bios QEMU_EFI.fd \
> > >>         -append "rdinit=/init console=ttyAMA0 earlycon=pl011,0x9000000 sched_verbose loglevel=8"
> > >>
> > >> I can see the schedule domain build stops at MC level since we reach all the
> > >> cpus in the system:
> > >>
> > >> [    2.141316] CPU0 attaching sched-domain(s):
> > >> [    2.142558]  domain-0: span=0-7 level=MC
> > >> [    2.145364]   groups: 0:{ span=0 cap=964 }, 1:{ span=1 cap=914 }, 2:{ span=2 cap=921 }, 3:{ span=3 cap=964 }, 4:{ span=4 cap=925 }, 5:{ span=5 cap=964 }, 6:{ span=6 cap=967 }, 7:{ span=7 cap=967 }
> > >> [    2.158357] CPU1 attaching sched-domain(s):
> > >> [    2.158964]  domain-0: span=0-7 level=MC
> > >> [...]
> > >>
> 
> It took me a bit to reproduce this as it requires "QEMU emulator version
> 7.1.0" otherwise there won't be a PPTT table.
> 

Is this new PPTT presenting what we'd expect from the qemu topology? e.g. if
it's presenting a cluster layer in the PPTT - should it be? Or should that be
limited to the SRAT table only?

-- 
Darren Hart
Ampere Computing / OS and Kernel
