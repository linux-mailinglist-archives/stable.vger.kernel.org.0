Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF95C48665A
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 15:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiAFOzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 09:55:46 -0500
Received: from mail-bn8nam11on2080.outbound.protection.outlook.com ([40.107.236.80]:21344
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231788AbiAFOzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jan 2022 09:55:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLKrmRIgoY/0+a98ihcYzwupzIpxR8OweYHrVXANpAYbzxWO/uEd6qrrSwmzce6m453kfQYTYc199SxYva1ImzshRHaQeAHHLxcw1ek14gkip7aLhQAs1uH4j09TyUhgXJiHonEkUCJDhbs8X/XF1gc1GMok/yvug0oxGZNEbqTLDck/ewYUdu5rIh2odvM/46kACUJwvsT8lCwY3SjKr0r9s2ioPkvhgr5VCkN2OaebHQSXMFBEqepKVw/Z7oQuHcbO/to5F/9oGkb0enq1Y8lBsIc3r3EErVPN7u6ey8ZSYAfFkBzjNUpIvp+vKw/A0sF62PysI3aBZg52uKr2BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G9tOyxAbfOIz8mIkiDs8QFB0ukPYRsb3G9s46NALK1M=;
 b=apG/tmw1Mwl9PbFC2k+4LnOUuTmo1Hc5HlF0KS+QMqqpPK/kTMORUXws5iT6QZHSx5uOqInCnSSX9Rryvbqo/G5yQ3C+roNts4skEb8MloQXbEfiEZMmw2Cp/D9ex2trBhkt3/u5suTcMRKMyAZyzKfcxhgxU6DMsC6bku4CNxQlBWFvw0rdEwQ2Xir+9vPRfNJDdjBNZDqjiQp/Ds8FXJQVIs7WHBwUJlFSy5tR4JZ2aubxGByd+nfeqSXjTl1Q5T7TH5xgLQ69taDLw26BqXhZG6peyhwltsbUglPGtfkmSNEAMFeZ5epylX/RYnbJo8R8bv0eeBAxFrg6YhfQ4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9tOyxAbfOIz8mIkiDs8QFB0ukPYRsb3G9s46NALK1M=;
 b=nP0lc/ecc0M9sWTkJr5YYOkXug1byHTqfPeYlTvVj37Uaa4f8+Vc2EvQ1k6fZf4nLmecrGsvr//F0wdU8CQ9HWVhfboKt2rJHNQElhWL9PF7t6RFixT8By06jFY5Mt9HHTR+ALld85uCWevPJNe/gKv1AdDWA41kmRwdQFYyw6o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2504.namprd12.prod.outlook.com (2603:10b6:4:b5::19) by
 DM5PR12MB1867.namprd12.prod.outlook.com (2603:10b6:3:10d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.14; Thu, 6 Jan 2022 14:55:42 +0000
Received: from DM5PR12MB2504.namprd12.prod.outlook.com
 ([fe80::f02e:2cba:7c63:e368]) by DM5PR12MB2504.namprd12.prod.outlook.com
 ([fe80::f02e:2cba:7c63:e368%4]) with mapi id 15.20.4844.017; Thu, 6 Jan 2022
 14:55:42 +0000
Date:   Thu, 6 Jan 2022 22:55:20 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuan, Perry" <Perry.Yuan@amd.com>,
        "Su, Jinzhou (Joe)" <Jinzhou.Su@amd.com>,
        "Du, Xiaojian" <Xiaojian.Du@amd.com>,
        kernel test robot <lkp@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, sched: Fix the undefined reference building
 error of init_freq_invariance_cppc
Message-ID: <YdcC2JK7sOFs292B@amd.com>
References: <20220106074306.2712090-1-ray.huang@amd.com>
 <20220106074306.2712090-2-ray.huang@amd.com>
 <Ydbdq6lXPKFG98MY@zn.tnic>
 <Ydb+rHXsXqxzmR0V@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ydb+rHXsXqxzmR0V@amd.com>
X-ClientProxiedBy: HK2PR03CA0053.apcprd03.prod.outlook.com
 (2603:1096:202:17::23) To DM5PR12MB2504.namprd12.prod.outlook.com
 (2603:10b6:4:b5::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a575e14-38a1-430e-853b-08d9d1249c85
X-MS-TrafficTypeDiagnostic: DM5PR12MB1867:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB18671869066874ED80C4BDC6EC4C9@DM5PR12MB1867.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cA2LsF4LkUOXwDa7yoQX0WPbnUquNeBhx907VumzWvnW/+UuFzZVpSuvMv5oIwqOMuVISvPkLoCNxVxYb3AYI5n82a65PfK0CbLLV8HHVPzZMmaiUqNX+EoZ1at2CRXUnVQchy2SYTFctu+i7piq2p7h7WyxPVTip93JRSZPA2+ZcWvoEHOb+vAWmlNEJtThvZvEpOhzUgE4xKXW6APB3GWzlLNsXMyjfX6cyJ0V1vDd/iZPrWIsArO5sQhBUT0AE7bCRIF5Ku56sO86goDeXcB+1flMfYlxD9//vpgogpA7ePH7SSXhwrSrYpDxiex9cM/k2gT2W5sTVsPiL3yqKufIVHcbfonjuZ4+cN5sGvs/H7f3K41Lfskf/wfAxGzM1lf980svhO0czpMGupqSNkguDHQ7x/NdL1EjFlHQGzXNINQAlU6gJ+4oyKJsdvDBxi70GqIqJ0ooBwhLSGNFqMtJx+vF755ae3rD81D95XwIEsmk0CPnyPEAhf20xms7WBy88DLobzTqxNqv8jSeUWdhP+WgCNbplGYoMm/Pw67Owg8Ohy7cWB9Y7Nso+yzGa9G7L5i2E/Etu57oHq/qhO/TcRccGZw8fV+d/U6uVUNFMHDuzKDyt9eT6spLTXtA6i6PFoRcnolzn10c4g8L0vgLWEvlJT3etINGrLIbFEQWMhyyqTZVg5JTtHr3uxTMt0JObD7w5SesSsCICEUosDpkmeChLN07zF4x+0BFNmY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(966005)(2906002)(508600001)(86362001)(66476007)(6916009)(66556008)(7416002)(8676002)(6506007)(6666004)(26005)(8936002)(316002)(4326008)(186003)(6486002)(2616005)(5660300002)(45080400002)(6512007)(38100700002)(83380400001)(36756003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3wGEHWxYI2AWHeIuFkirtlCeXWzb3Q5MIBfr0pG5c9PIPEbOiPC4XJnqypY7?=
 =?us-ascii?Q?YfP2tbIbINr48oyJvlcq+lJw0AOxr17YlNhKWI9kcmSelgFSX0JvckCaIAD5?=
 =?us-ascii?Q?NZTz2d/z1TGTGKxajD7vMLUQYaVqla5fVZfdVldUKHdP9n3nVhhoqj1+Qzc7?=
 =?us-ascii?Q?xHUajJ7ywINhP6KkFW8wOC/elW1O8w0y1+hGQTUgr78O5CqdSW1yJhyHnc4p?=
 =?us-ascii?Q?9GwTyRRNWfLYXeGbRjzAKvwJawTcJ0zgMoqzhLrEHofRQvD98vY7XTLX5nb8?=
 =?us-ascii?Q?0uPUuqZCb2PTUw8aSwk+OG7/CwTiHciaDnQBSVA8DEF7DaNvOHqwvJyvPd4g?=
 =?us-ascii?Q?Ocx1C09OcR9I2FXYQuJ/l0z/fYndtiLIvPkTiy9JQ6x8tBFCqGkhqQM+tFFj?=
 =?us-ascii?Q?NH4NyQL64sI5n5NRac1dPn5sq/s0x+j248RgvBBweTRc9BxlwuWoFvgvyZu+?=
 =?us-ascii?Q?Tf+Hym0lKIuO801p1uVF0Qi4eEjtFF1L+of4pZn4FxC2s9HVh5CdXI3IGhqs?=
 =?us-ascii?Q?7pqfS/pczAcDhMd//ByWAyFj+PaKwKnONk9LqIiLTiIH11jA57zXYMO+rvId?=
 =?us-ascii?Q?NMtyPawXz6fTZvyBIt0NlWG//xdaimOno4ohjTzQ9q95d20PhC4/McRK+MJe?=
 =?us-ascii?Q?WtiQJHLwO4mEAF/+S6LcEXZQbtRg3xC5lCsyR3IiKZSmSB/BEbRjd4Wm073p?=
 =?us-ascii?Q?0gExZmQpA/RXZm1J2GfNJI5Hqf+v04CGKm8c6cdi6sylo/z/Pot0A8VlVg5i?=
 =?us-ascii?Q?u/BDH3xIREEgTFP7inElLCZoDYxF591BMDkF0YuITaVFWg47GNUN7xY0WYqv?=
 =?us-ascii?Q?sblpJsAHpQjAfEmcSLhXVDByI1fI6r9yeTkmg0WgmlRr/fpBa4UByGSLGTqq?=
 =?us-ascii?Q?bMJt5bR/F/G3xvuFRu9ZynOf7GanstVF3Agimiuf0eIaN6dPSkkf+1x25ZYF?=
 =?us-ascii?Q?t5hp3ggEVOMCAs66UILP2T5XBOxYEhIIsaXB3Nf6idPmaSyAltPUpNwqcjBO?=
 =?us-ascii?Q?e0kFOZTnLbY1dDiCrGCXLtvz+Wi9wb3TlcTQhlnBsJffbWtBmbkf95H/uiet?=
 =?us-ascii?Q?8mH4u1UEIHVK41RfPxRuSM4Ia6hvjywYyn3AjNNQKtj9kNSznh0cm9Ms7ZGP?=
 =?us-ascii?Q?Vndx+fVCAVQDSsh9t23zJz0+8KQswdwwOIFENKDLv7+sgc5zNjl7jUEYjA6H?=
 =?us-ascii?Q?Kixs0QMUgR9VQzNjgNFjp1d5QTb55LZJqtemWruAgfjXj+YM07UtXYjyP7UC?=
 =?us-ascii?Q?sDDyIYG/iX5u8zWOGGzPpblJt1fdoW1H/NgG1c4eN1BzWB2NZY0qcX+Ab0hc?=
 =?us-ascii?Q?ouFyeY8uAri2HHO7//iuGc/IXp8bCIqOWrKN1pyibe1TyOxCk+04DvXYrt0n?=
 =?us-ascii?Q?tqVGibKczvuWJbhlRg61bgXFPeIecDg2GeYPrw0FGf3IsMkmiLXoyelQqjYi?=
 =?us-ascii?Q?I4fKFXx1h1nGtFQDhKLGvdrALOm2SAAsaCV0WkxgpuoWaUtDSXhwBKVkSZRo?=
 =?us-ascii?Q?r1ODSVoE8g8w2ieRnGpzq48bX39C01mxkAOHwTnkR2hgfW+9AIzF0Wbngsjz?=
 =?us-ascii?Q?v3jztKp6c3CziAkNl014AGR6J/kSx+zdUA52cYCsS/bfdO2INHGIMCjK0Wnq?=
 =?us-ascii?Q?tb/WcE1rHqsmC7WqrYc35v4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a575e14-38a1-430e-853b-08d9d1249c85
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 14:55:42.7003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zhGBixWhr7jOO5hFbabPaaV3VmC6o9pxph/T0UbEHZzFwSYGBdtSvhJnbYPYETXDqkR4ceR0/khFdayxqOJ7Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1867
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 06, 2022 at 10:37:59PM +0800, Huang Rui wrote:
> On Thu, Jan 06, 2022 at 08:16:43PM +0800, Borislav Petkov wrote:
> > On Thu, Jan 06, 2022 at 03:43:06PM +0800, Huang Rui wrote:
> > > The init_freq_invariance_cppc function is implemented in smpboot and depends on
> > > CONFIG_SMP.
> > > 
> > >   MODPOST vmlinux.symvers
> > >   MODINFO modules.builtin.modinfo
> > >   GEN     modules.builtin
> > >   LD      .tmp_vmlinux.kallsyms1
> > > ld: drivers/acpi/cppc_acpi.o: in function `acpi_cppc_processor_probe':
> > > /home/ray/brahma3/linux/drivers/acpi/cppc_acpi.c:819: undefined reference to `init_freq_invariance_cppc'
> > > make: *** [Makefile:1161: vmlinux] Error 1
> > > 
> > > See https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F484af487-7511-647e-5c5b-33d4429acdec%40infradead.org%2F&amp;data=04%7C01%7Cray.huang%40amd.com%7C4c696d3f23ac4479dda108d9d10e6a53%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637770682133383506%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=9lC2az1xGeYn7fNputkUMsy7PIhmkqW8jdpDUsaWthI%3D&amp;reserved=0.
> > > 
> > > Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD systems")
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Cc: Borislav Petkov <bp@alien8.de>
> > > Cc: Ingo Molnar <mingo@kernel.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: x86@kernel.org
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  arch/x86/include/asm/topology.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> > > index cc164777e661..2f0b6be8eaab 100644
> > > --- a/arch/x86/include/asm/topology.h
> > > +++ b/arch/x86/include/asm/topology.h
> > > @@ -221,7 +221,7 @@ static inline void arch_set_max_freq_ratio(bool turbo_disabled)
> > >  }
> > >  #endif
> > >  
> > > -#ifdef CONFIG_ACPI_CPPC_LIB
> > > +#if defined(CONFIG_ACPI_CPPC_LIB) && defined(CONFIG_SMP)
> > >  void init_freq_invariance_cppc(void);
> > >  #define init_freq_invariance_cppc init_freq_invariance_cppc
> > >  #endif
> > > -- 
> > 
> > Well, since that function is in smpboot.c then the logic should be that
> > CPPC depends on functionality in smpboot.c for proper operation.
> > 
> > IOW, ACPI_CPPC_LIB should have "depends on CONFIG_SMP" in Kconfig, no?
> > 
> > Instead of adding more ifdeffery around...
> > 
> 
> Hmm, yes, that's fine. I will modify it in V2.
> 

I just thought the CPPC function should be able to work on single core even
SMP is disabled.

Thanks,
Ray
