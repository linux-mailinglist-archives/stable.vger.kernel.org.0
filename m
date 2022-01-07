Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F8D486FAC
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 02:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344406AbiAGBXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 20:23:52 -0500
Received: from mail-bn8nam08on2040.outbound.protection.outlook.com ([40.107.100.40]:1249
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344075AbiAGBXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jan 2022 20:23:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UypKQUoqjZLV87wg5ftBgEdguLMp2EycHZF7bfX6J7V1kCRMMfwqc4rQ+XlmaDx9aS/+9/5j98Omo3KyMqQkzOuFbX+yEFE+eAAjpuP76r9hDR5Dzkel28cUOyh/wEHRknZEEKOUCWmGxuGicw79p5dST62qefOw9EB8Qx7Q7M8vu7aUnj+SHtGwUurmiuuQzG01KUW2ycI2FscozLc/hVcEGEX3Osn5ukgmT+hA5rGWp4uNky3yHEDLLaC2VAOrGSulqHegVqYmn8lP41dxOaMg+V89KkzcZWZW2c9VUbJc4oDNw8PDLRVlBoIy4081zC8C9wjfbdYDgAMtgyh98w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KwUMq4rQo3+zzSt1Ib7f/zvzZoncMXEc57CZZVardbs=;
 b=JWtTonYCyTJg/PX0AxIK1RljNC6KgH+7fCueKvElTh6h3q2sXgTbmjNCAjwJBl7kpDMBU5YQxouAxC2yg2j1xFqbQSJRH7qlafYoQq0W9kqgxzdduGygMcDemi1pvQ1cLEHkuct67nkplEIUNv0v1yB4Fcy/z9T1Of2gO8eUCGssJfIRdpeIzehH4zouvljxcInZG1CAqX1jcNubOcE2y0pXwz+fOdjrX/bEuIs6v3jq+XMKkXk5J+xwh0dYAn4ClVFlLEcyeJaRLvI00ELBqwZXneJEFlAQltAaeL9u10DzKv611dLIRKgLYwA9TuN9Jy/wy+FoUc0d7wEIv5PVRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwUMq4rQo3+zzSt1Ib7f/zvzZoncMXEc57CZZVardbs=;
 b=CJzea/SuOxMVFMEPkVpe663CdqqWWsCBWouJushTL6xqSXBG8uWv709L/7GhuMDwoXyIf6bVmnqcoq36YCHSkTadmpRRhTa9BV3+tywsGRSU1P27xTn8JpMNXrtNM9OxQ+3+bec9s8dbxJnmXI76jrh1kY3G0WZMfa1n/4M6nfk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2504.namprd12.prod.outlook.com (2603:10b6:4:b5::19) by
 DM5PR12MB1836.namprd12.prod.outlook.com (2603:10b6:3:114::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Fri, 7 Jan 2022 01:23:49 +0000
Received: from DM5PR12MB2504.namprd12.prod.outlook.com
 ([fe80::f02e:2cba:7c63:e368]) by DM5PR12MB2504.namprd12.prod.outlook.com
 ([fe80::f02e:2cba:7c63:e368%4]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 01:23:49 +0000
Date:   Fri, 7 Jan 2022 09:23:24 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Yuan, Perry" <Perry.Yuan@amd.com>,
        "Su, Jinzhou (Joe)" <Jinzhou.Su@amd.com>,
        "Du, Xiaojian" <Xiaojian.Du@amd.com>,
        kernel test robot <lkp@intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, sched: Fix the undefined reference building
 error of init_freq_invariance_cppc
Message-ID: <YdeWDDCwBQAYnlKb@amd.com>
References: <20220106074306.2712090-1-ray.huang@amd.com>
 <20220106074306.2712090-2-ray.huang@amd.com>
 <CAJZ5v0htW=twuLY88XJmLGnDtmmjoav=Z8WLZZcjG29-YKQMog@mail.gmail.com>
 <CAJZ5v0iH=rAgC0YPcCv_zoMtNoA1hG=ZGgLRdrgKqWAjmsYqcw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0iH=rAgC0YPcCv_zoMtNoA1hG=ZGgLRdrgKqWAjmsYqcw@mail.gmail.com>
X-ClientProxiedBy: HK2PR03CA0058.apcprd03.prod.outlook.com
 (2603:1096:202:17::28) To DM5PR12MB2504.namprd12.prod.outlook.com
 (2603:10b6:4:b5::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 296c2028-11d3-4680-1d7e-08d9d17c5b61
X-MS-TrafficTypeDiagnostic: DM5PR12MB1836:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB183674A47A832B8FBFB527A5EC4D9@DM5PR12MB1836.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WStylXZmNmioSkyxykXPGRjYwh3pJkxPAVk+XikQ3d2yOmRzGRA2Di9N3G6fs7BMHIfdEP07MeiChXaDqWmvOcn0drCLwVwRIyCjJ718lhJeaesDHerOvG4MsItJNbSv8gy2zvuATELxF3XxTfOcEXBFWNcZUQhrlC1Z7PrW8SokG2UMiy8Mk+14q64DGLddSj98oRS//uXaAEv6944YSAxEtbeKVIuPW9rM5dfeDjOHX12dyTBuByASg/PtRetu5z5F1tMQmoUrrpSwKMs74V4G9RSH+/2pP5km0jWoVcLISCU4FXzpLvtuWortJWJAzGGWxUaJ2OEu5trpH/x/oRqIC3Pfwh+PkhOaswxmdo16tw1FxvMVuRFJ1XJqZvhAtaWydTNeeV+x1ZIKUUhJnUCly50X49AxkrL80+nVLWfW2WouxcQ0HYmthmiVfpdLG4aIZ9FNLipZvvCq2VprCdOznCnj29Fpu9Xj5QC0DgReF1Whq8Onfum0P/f+Y/VmzKYd89ksut0KXXNEeROBy3d0HPu57c9ZU41FKw4LfWn0zpqD2VdIE/7g0Yl0749AWeMvYtuyryIykHMcIxKXVfl8zIWQyc8nKVx9BwNd3zwNpUgaPK30awpDqjMSQkknuEqKQUDUm4vve3/vl/dgirOsbL5CLZP8yGjFSBNQsdebHfZM+FeUgR+BcWKCQx6zMimfZ0wUB7UydQx1ZKW56Qt8Q/NEzxW6FdBV/h+6cIc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6486002)(45080400002)(8936002)(83380400001)(6916009)(6506007)(53546011)(26005)(508600001)(54906003)(6512007)(4326008)(7416002)(6666004)(2906002)(66946007)(966005)(36756003)(8676002)(66476007)(66556008)(2616005)(186003)(5660300002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8/d4TRCqLoakZfwl1+hJvOjKJRg1FpMR8Ud/Ssh7Sba3VHQieaJkkbj6UbsC?=
 =?us-ascii?Q?euYxIJz402+qA6bjUdZsCLk6AH1I4CKtkUXJawQtC/oaZw0zjkgteTIHhi1U?=
 =?us-ascii?Q?k73j3sfxM8dwBBPIZubzvmWNAazsBeu3y8R+iY+nmFA5ss++ZLcRjVoxWa+N?=
 =?us-ascii?Q?KoHOHQG79uPrzebC6nnG19SfbJO2RKsldT0d3ivRpvHma0ovuoyB8q2XqTaK?=
 =?us-ascii?Q?u+WXw5k/zfsvx+CxQpxApBDAPRzGikNGqY1vQaH9MhqEP80g9j7+zFNbQKiQ?=
 =?us-ascii?Q?KEl8s7KYgAiTR9mXSkq8ERMEfCD4xebfEmQHJ/I6XyK6D4RKvLfmWVGczFhc?=
 =?us-ascii?Q?PjZJaI2kqdUfJxoBIV6J5bNXrQOECHolP/qPXi/sDUE2Qj/oTN6wZVZ8hIxF?=
 =?us-ascii?Q?PFdSieRLtkcR5ttjTY+WES6Zvsj/PgjQv88UxizwQDxETgOzxxj/FDfg1Kcj?=
 =?us-ascii?Q?lv1Qp8/bbHWoSRXhQSnch548VIm7Lqyxd2aKcwEU44mnGucWd/M2LNrofV0O?=
 =?us-ascii?Q?sbLCm7uaSPILExaFOsleFOL05+T8nndFNkJngaY+o7yjWRogivwuRh3A2hgY?=
 =?us-ascii?Q?tfqpHxzpGzIfEEyfY9tVMnugQR2NzgcTcerTYap+H37aq6iHmktRwgTRth8P?=
 =?us-ascii?Q?+UwhBL9tPhwNjwbhTG4OG9ofiiutGa9anwAK97CxzNQGptjQRfqP66hKnfZz?=
 =?us-ascii?Q?XSw/hQcXPenE4Qqf0AMIsR+G9uQk+JesXLMrUQBxrWQn7ktHA8mr2R6KcoVN?=
 =?us-ascii?Q?0CYkuGms/5P6c+yU4yWiULXKKqo+35k5iW/9sY2F3egbUiN1EyDngBomG/NN?=
 =?us-ascii?Q?Bsuc+BU2boXFa4UB+RMsdH1JLi0N8swGSyLzzPQriIkgNNoktkPq669q4/YG?=
 =?us-ascii?Q?EhxuaK8+JLEe+ZNikHCVtMxIUkZhqqKMU2XUkletFlJBPm1CFto31W9vKUdS?=
 =?us-ascii?Q?7AAeYyQW5pl0sKs51/Qsb+xrSyoMnlnYwH5RFXFA191fsj3uXdt/FmhMXXld?=
 =?us-ascii?Q?IzzHvyyvRgfuaACvfKg1g7qFG+uk1A8MQYAtSb2g+XbIQsChapMmRcApwgYe?=
 =?us-ascii?Q?IMHIXV1cvFh63jdHwFU9lPGH/BbST1fijrOniEqoUK/q5lX53grcrBQoe2EH?=
 =?us-ascii?Q?wf0XkeGnDOB8Atiy58e7866lsxq4T8NLkdgDdG4rNh1vRoXUzPJDOeaTsLJ9?=
 =?us-ascii?Q?IVP+xbI5kBjpeMgJ2Dq3XIGMVOx7blBBx0N8bk9vru6AB1GYZSGtXBqsRZ6C?=
 =?us-ascii?Q?cha2qAc6gX2vYgx9RH7QXaUxus89605lbrIKlh9HscuhITOF7Oe1yDWXDoGp?=
 =?us-ascii?Q?vral/N0+YdNbfV2ETNYr6ae59a7NgYrxrsFGVgpTt3gqqgOUDXk/bomGa6IV?=
 =?us-ascii?Q?aDzkBbchkyRDGSFa/YCox+bDujxeO2BpSTim5NZXGsQnS5isLVwey11OnHp/?=
 =?us-ascii?Q?076ingsd/cuqoT4dizyLKMAhqWO37HvAasN4LA4+OFp/1mto+Czvd1HJ/5u8?=
 =?us-ascii?Q?POq1TZE02c3Fg+wwXVANqoK+mijPi/EqVh9At503MG0Wt2PnMrU9IDnLFoQw?=
 =?us-ascii?Q?frM6wW4GevfrymRikk0DAga96ATG9v7eOuZ83rzc9QxfdUszPSXyjJXQZ1c7?=
 =?us-ascii?Q?g2Edg0Cp4347kZXK+T6VECA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 296c2028-11d3-4680-1d7e-08d9d17c5b61
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 01:23:49.1533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NteTZxYY3NqD04lFlhX8F8a35+QMK5rAlYqGr6cmL2yY6fNh0WRgNXu2/5E7OnfVde2xwevcjU9XHvmldtH2zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1836
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 07, 2022 at 01:46:04AM +0800, Rafael J. Wysocki wrote:
> On Thu, Jan 6, 2022 at 6:12 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Thu, Jan 6, 2022 at 8:43 AM Huang Rui <ray.huang@amd.com> wrote:
> > >
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
> > > See https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F484af487-7511-647e-5c5b-33d4429acdec%40infradead.org%2F&amp;data=04%7C01%7Cray.huang%40amd.com%7Cde64292b38394cf2cac508d9d13c701c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637770879795785268%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=BtO45nsVaYM%2BBytS%2B5GOPQuIadaiUEnzzaSmydsl0Jo%3D&amp;reserved=0.
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
> >
> > Why don't you check CONFIG_SMP instead of this symbol in cppc_acpi.c?
> > That file depends on CONFIG_ACPI_CPPC_LIB anyway.
> 
> Scratch that, it needs to compile on non-x86 too.
> 
> The $subject patch is cleaner than all of the alternatives I have
> considered, so I'm going to apply it.
> 
> However, I'm not really happy with the dependencies between CPPC and
> smpboot.c going both ways.

Thanks, for urgent fix for linux-next, I think we can use this patch at
this moment.
Let me think out a better way to handle the dependencies next step. :-)

Thanks,
Ray
